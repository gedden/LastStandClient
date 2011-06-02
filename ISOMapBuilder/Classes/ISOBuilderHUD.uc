class ISOBuilderHUD extends ISOHUD;

var BuilderGFxHUD builderHUD;

var ISOBuilderNode root;
var MapZone zone;
var MapZone unitZone;
var Actor worldActor;

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
	//ShowHoverArea();
	ShowPathArea(range);

	// Now lets show the hover areas
	if( root != none )
		DrawProjectedNode(root, class'ISONode'.const.NODE_SIZE, RedColor );
} 

/**
 * Show the hover area
 * 
 **/
function ShowPathArea(int range)
{
	// Get the center of the game's grid
	local ISOMapBuilder     game;
	local ISOBuilderGrid    grid;
	local ISONode           current;
	local Color             highlightColor;

	highlightColor = MakeColor(0,0,255,255);
	game = ISOMapBuilder(WorldInfo.Game);
	grid = ISOBuilderGrid(game.GetGrid());


	current = GetCurrentHoverNode(game, grid);

	// Only process the zone if its needed
	if( current != root && current != none)
	{
		if( game.LocalPlayer.unit == none )
		{
			game.LocalPlayer.unit = Spawn(class'ISOUnitTest');
		}
		else
		{
			unitZone        = new class'MapZone';
			unitZone.nodes  = class'GridUtil'.static.GetNodesInRange(current, game.LocalPlayer.unit.size, grid);
		}

		zone = class'MapZone'.static.Create(current, range, grid, game.LocalPlayer.unit );
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
		if( class'GridUtil'.static.IsValid(current, grid, game.LocalPlayer.unit) )
			highlightColor = MakeColor(128,0,128,255);
		ShowColorZone(unitZone, highlightColor);
	}
}

/**
 * Show the hover area
 * 
 **
function ShowHoverArea()
{
	// Get the center of the game's grid
	local ISOMapBuilder     game;
	local ISOBuilderGrid    grid;
	local ISONode           current;

	game = ISOMapBuilder(WorldInfo.Game);
	grid = ISOBuilderGrid(game.GetGrid());

	current = GetCurrentHoverNode(game, grid);

	// Only process the zone if its needed
	if( current != root )
	{
		zone = class'MapZone'.static.Create(current, 8*class'ISONode'.const.NODE_SIZE, grid, game.LocalPlayer.unit );
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
*/

/**
 * Get whatever node the mouse is 
 * currently hovering over
 * 
 **/
private function ISONode GetCurrentHoverNode(ISOMapBuilder game, ISOBuilderGrid grid)
{
	local Vector mouseOnWorld;
	//local Actor worldActor;

	// get the data
	GetWorldUnderMouse(mouseOnWorld, worldActor);
	
	// Fail fast
	if( worldActor==none )
		return none;

	return grid.GetNodeBy3D(mouseOnWorld);
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
	ISOBuilderGrid(ISOCoreGameInfo(WorldInfo.Game).grid).SaveMapData();
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
