class ISOBuilderHUD extends ISOHUD;

var BuilderGFxHUD builderHUD;

var ISOBuilderNode root;
var ISOUnit unit;
var MapZone zone;
var MapZone unitZone;
var Actor worldActor;
var Vector mouseOnWorld;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	builderHUD = BuilderGFxHUD(HudMovie);
	builderHUD.hud = self;
}

event PostRender()
{
	local int range;

	range = 8;
	super.PostRender();

	// Show the hover area
	//ShowHoverArea(range);
	ShowPathArea(range);
	//ShowEdges();
	//ShowEverything();

	// Now lets show the hover areas
	if( root != none )
		DrawProjectedNode(root, class'ISONode'.const.NODE_SIZE, RedColor );


	Canvas.SetDrawColor( 255, 255, 255, 255 );
	Canvas.SetPos( 10.0, SizeY-20 );
	Canvas.DrawText( "MouseWorld: X:" $ mouseOnWorld.X $ ", Y:" $ mouseOnWorld.Y );

	Canvas.SetPos( SizeX/2, 10.0 );
	//Canvas.DrawText( WorldInfo.GetMapInfo().Name );
	Canvas.DrawText( WorldInfo.GetMapName() );
	
} 

function ShowEverything()
{
	local ISOMapBuilder     game;
	local ISOGrid           grid;
	local ISONode node;

	game = ISOMapBuilder(WorldInfo.Game);
	grid = game.GetGrid();

	foreach grid.nodes(node)
	{
		DrawProjectedNode(node, class'ISONode'.const.NODE_SIZE, GreenColor );
	}
}

function ShowEdges()
{
	local ISOMapBuilder     game;
	local ISOGrid           grid;
	local ISONode node;
	local int r;

	game = ISOMapBuilder(WorldInfo.Game);
	grid = game.GetGrid();


	for( r=0;r<grid.Rows;r++ )
	{
		node = grid.GetNode(r, 0);
		DrawProjectedNode(node, class'ISONode'.const.NODE_SIZE, WhiteColor );

		node = grid.GetNode(r, grid.Cols-1);
		DrawProjectedNode(node, class'ISONode'.const.NODE_SIZE, WhiteColor );

		node = grid.GetNode(r, 1);
		DrawProjectedNode(node, class'ISONode'.const.NODE_SIZE, RedColor );

		/*
		node = grid.GetNode(r, grid.Cols-2);
		DrawProjectedNode(node, class'ISONode'.const.NODE_SIZE, WhiteColor );

		node = grid.GetNode(r, grid.Cols);
		DrawProjectedNode(node, class'ISONode'.const.NODE_SIZE, RedColor );
		*/
	}

	/*
	for( c=0;c<grid.Cols;c++ )
	{
		node = grid.GetNode(0, c);
		DrawProjectedNode(node, class'ISONode'.const.NODE_SIZE, RedColor );

		node = grid.GetNode(grid.Rows-1, c);
		DrawProjectedNode(node, class'ISONode'.const.NODE_SIZE, RedColor );
	}
	*/
}

/**
 * Show the hover area
 * 
 **/
function ShowPathArea(int range)
{
	// Get the center of the game's grid
	local ISOMapBuilder     game;
	local ISOGrid           grid;
	local ISOGridController gc;
	local ISONode           current;
	local Color             highlightColor;

	highlightColor = MakeColor(0,0,255,255);

	game = ISOMapBuilder(WorldInfo.Game);
	gc   = game.GetGridController();
	grid = game.GetGrid();


	current = GetCurrentHoverNode(game, gc);

	//`Log("Current: " @current.row @current.col @current.height @current.GetCentroid() );
	// Only process the zone if its needed
	if( current != root && current != none)
	{
		if( unit == none )
		{
			unit = Spawn(class'ISOUnitTest');
		}
		else
		{
			unitZone        = new class'MapZone';
			unitZone.nodes  = class'GridUtil'.static.GetNodesInRange(current, unit.size, grid);
		}

		zone = class'MapZone'.static.Create(current, range, grid, unit );
		root = ISOBuilderNode(current);
	}	
	
	if( current == none || root == none )
	{
		// nothing to show, we are not over anything
		return;
	}

	// Finally, show the zone
	ShowZone(zone);

	if( unitZone != none )
	{
		if( class'GridUtil'.static.IsValid(current, grid, unit) )
			highlightColor = MakeColor(128,0,128,255);
		ShowColorZone(unitZone, highlightColor);
	}
}

/**
 * Show the hover area
 * 
 **/
function ShowHoverArea(int range)
{
	// Get the center of the game's grid
	local ISOMapBuilder     game;
	local ISOGrid           grid;
	local ISOGridController gc;
	local ISONode           current;

	game = ISOMapBuilder(WorldInfo.Game);
	gc   = game.GetGridController();
	grid = game.GetGrid();


	current = GetCurrentHoverNode(game, gc);

	`Log("Current: " @current.row @current.col );
	// Only process the zone if its needed
	if( current != root && current != none)
	{
		zone = class'MapZone'.static.Create(current, range, grid );
		root = ISOBuilderNode(current);
	}	
	
	if( current == none || root == none )
	{
		// nothing to show, we are not over anything
		return;
	}

	// Finally, show the zone
	ShowZone(zone);
}

/**
 * Get whatever node the mouse is 
 * currently hovering over
 * 
 **/
private function ISONode GetCurrentHoverNode(ISOMapBuilder game, ISOGridController gc)
{
	//local Actor worldActor;

	// get the data
	GetWorldUnderMouse(mouseOnWorld, worldActor);
	
	// Fail fast
	if( worldActor==none )
		return none;

	return gc.GetWorldspaceToGridspace(mouseOnWorld);
}

function ShowColorZone(MapZone zoneInput, Color c)
{
	local ISONode node;
	foreach zoneInput.nodes(node)
	{
		DrawProjectedNode(node, class'ISONode'.const.NODE_SIZE, c );
	}
}

function ShowZone(MapZone zoneIn)
{
	local ISONode node;
	foreach zoneIn.nodes(node)
	{
		DrawProjectedNode(node, class'ISONode'.const.NODE_SIZE, ISOBuilderNode(node).GetColor() );
	}
}


function onSaveMap()
{
	ISOCoreGameInfo(WorldInfo.Game).GetGrid().SaveMapData();
	onShowNotification("Save Complete");
}

function onShowNotification(String message)
{
	builderHUD.onShowNotification(message);
}

function bool IsInRange(ISOBuilderNode node)
{
	local Vector delta;

	delta = ISOMapBuilderPlayer(Owner).Location - node.location;

	return VSize(delta) < 256;
}

function DrawProjectedNode(ISONode node, float size, Color col )
{
	/*
	  C --- D
	 /  X  /
	A --- B 
	*/
	local Vector A, B, C, D, X, N;
	local Vector from;
	/*
	local ISOMapBuilder     game;
	local ISOGrid           grid;
	local ISOGridController gc;
	local ISONode           current;
	game = ISOMapBuilder(WorldInfo.Game);
	gc   = game.GetGridController();
	grid = game.GetGrid();
	from = gc.GetVirtualCentroid(node.row, node.col, node.height) - vect(1,1,0)*(size/2);
	*/
	from = node.GetCentroid() - vect(1,1,0)*(size/2);

	A = from + vect(0,0,0)*size;
	B = from + vect(1,0,0)*size;
	C = from + vect(0,1,0)*size;
	D = from + vect(1,1,0)*size;
	X = from + vect(1,1,0)*(size/2);
	N = from + vect(1,1,1)*(size/2);
	
	A = Canvas.Project(A);
	B = Canvas.Project(B);
	C = Canvas.Project(C);
	D = Canvas.Project(D);
	X = Canvas.Project(X);
	N = Canvas.Project(N);

	Canvas.Draw2DLine(A.x, A.y, B.x, B.y, col);
	Canvas.Draw2DLine(A.x, A.y, C.x, C.y, col);
	Canvas.Draw2DLine(D.x, D.y, C.x, C.y, col);
	Canvas.Draw2DLine(D.x, D.y, B.x, B.y, col);

	Canvas.Draw2DLine(X.x, X.y, N.x, N.y, col);
}

DefaultProperties
{
	HUDClass = class'ISOMapBuilder.BuilderGFxHUD';
}
