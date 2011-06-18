class ISOHUD extends HUD;

var GFxHUD HudMovie;

var	class<GFxHUD>	HUDClass;

var Vector          mouse3D;
var Vector          mouseOnWorld;
var Vector          worldDireciton;
var float           scaleformRatioX;
var float           scaleformRatioY;

var bool drawRadius;
var Vector          radiusAt;
var int radiusSize;

var Actor  debug;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	if (HudMovie == None)
	{
		// If I had a different hud, I guess I could set it up here? (lobby vs game)
		//HudMovie = new class'ISOCore.GFxHUD';
		HudMovie = new HUDClass;
		HudMovie.Initialize(self);
	}

	
	// Register the grid
	//AddPostRenderedActor(ISOCoreGameInfo(WorldInfo.Game).grid);
}

/**
 * Get the 2D mouse coords from the scaleform
 * driven HUD
 **/
function vector2D getMouseCoordinates2D()
{
	local Vector2D mousePos;
    mousePos.X = HudMovie.MouseX * scaleformRatioX;
	mousePos.Y = HudMovie.MouseY * scaleformRatioY;

	return mousePos;
}

/**
 * Get the pre-computed mouse coords
 **/
function Vector getMouseCoordinates3D()
{
	return mouse3D;
}

function ShowLowerHUD(Tech tech)
{
	HudMovie.ShowHUD(tech);
}

function HideLowerHUD()
{
	HudMovie.HideHUD();
}

/**
 * Get the stuff under the mouse
 * 
 **/
simulated function getStuffUnderMouse(out Vector MouseHitWorldLocation, out Vector MouseHitWorldNormal, out Actor TraceActor)
{
	TraceActor = Trace(MouseHitWorldLocation, MouseHitWorldNormal, mouse3D + worldDireciton * 5000, mouse3D, true);
	debug = TraceActor;
	if ( (TraceActor == WorldInfo) )		TraceActor = none;
	//if ( (TraceActor == WorldInfo) || ( Terrain(TraceActor) != none ) )		TraceActor = none;
}

simulated function GetWorldUnderMouse(out Vector hitLocation, out Actor TraceActor)
{
	local Vector hitNormal;

	foreach TraceActors(class'Actor',TraceActor, hitLocation, hitNormal,  mouse3D + worldDireciton * 5000, mouse3D )
	{
		if( TraceActor != none && TraceActor.bWorldGeometry ) return;
	}
	TraceActor = none;
}

/**
 * Get whatever node the mouse is 
 * currently hovering over
 * 
 **/
public function ISONode GetCurrentHoverNode(ISOGridController gc)
{
	local Actor worldActor;

	// get the data
	GetWorldUnderMouse(mouseOnWorld, worldActor);
	
	// Fail fast
	if( worldActor==none )
		return none;

	return gc.GetWorldspaceToGridspace(mouseOnWorld);
}

event PostRender()
{
	local Vector2D mouse2D;
	local ISOCoreGameInfo game;
	
	// Pre calculate most common variables
	if ( SizeX != Canvas.SizeX || SizeY != Canvas.SizeY )
	{
		PreCalcValues();
		CalcScaleformValues();
	}

	// Get the updated mouse2D coords
	mouse2D = getMouseCoordinates2D();

    //Deproject the mouse from screen coordinate to world coordinate and store World Origin and Dir.
    Canvas.DeProject(mouse2D, mouse3D, worldDireciton);

	Canvas.SetDrawColor( 255, 255, 255, 255 );
	Canvas.SetPos( 10.0, 10.0 );
	Canvas.DrawText( "Mouse: X:" $ mouse2D.X $ ", Y:" $ mouse2D.Y );


	// Now draw the radius debug stle
	//DrawMapZone(zone);

	//ISOCoreGameInfo(WorldInfo.Game).grid.showNodes(self);

	game = ISOCoreGameInfo(WorldInfo.Game);
	ISOCorePlayerController(PlayerOwner).setHover( GetCurrentHoverNode( game.GetGridController() ) );

}

/*
function DrawMapZone(MapZone zone)
{
	local Array<Vector2D>   vb;
	local Array<int>        cb;
	local ISONode           node;
	local float             size;

	if( zone==None ) return;

	size = class'ISONode'.const.NODE_SIZE/2;

	foreach zone.nodes(node)
	{
		vb.AddItem(WorldspaceToHudspace(node.GetCentroid() + vect(-1, 1,0)*size) );
		vb.AddItem(WorldspaceToHudspace(node.GetCentroid() + vect( 1, 1,0)*size) );
		vb.AddItem(WorldspaceToHudspace(node.GetCentroid() + vect( 1,-1,0)*size) );
		vb.AddItem(WorldspaceToHudspace(node.GetCentroid() + vect(-1,-1,0)*size) );

		cb.AddItem(0);
	}

	HudMovie.DrawGrid(vb, cb);
	HudMovie.DrawActiveNodes();
}
function HideMapZone()
{
	zone = none;
	HudMovie.HideActiveNodes();
}
*/

public function Vector2D WorldspaceToHudspace(Vector world)
{
	local Vector2D v2d;
	local Vector v;

	v = Canvas.Project(world);
	v.X /= scaleformRatioX;
	v.Y /= scaleformRatioY;

	v2d.X = v.X;
	v2d.Y = v.Y;

	return v2d;
}


function DrawProjectedBox(Vector from, float size, int r, int g, int b, int a )
{
	/*

	  E --- F
	 /|    /|
	A --- B |
	|  G -|-H
	| /   |/
	C --- D
	*/
	local Vector A1, B1, C1, D1, E1, F1, G1, H1;
	local Color c;

	c = MakeColor(r, g, b, a );

	C1 = from + vect(0,0,0); // Lets assume C is the origin
	A1 = from + vect(1,0,0)*size;
	D1 = from + vect(0,1,0)*size;
	B1 = from + vect(1,1,0)*size;
	G1 = from + vect(0,0,1)*size;
	E1 = from + vect(1,0,1)*size;
	H1 = from + vect(0,1,1)*size;
	F1 = from + vect(1,1,1)*size;

	A1 = Canvas.Project(A1);
	b1 = Canvas.Project(B1);
	c1 = Canvas.Project(C1);
	d1 = Canvas.Project(D1);
	e1 = Canvas.Project(E1);
	f1 = Canvas.Project(F1);
	g1 = Canvas.Project(G1);
	h1 = Canvas.Project(H1);
	//Canvas.DeProject(a2, A1, worldDireciton);
	//Canvas.DeProject(b2, B1, worldDireciton);
	//Canvas.DeProject(c2, C1, worldDireciton);
	//Canvas.DeProject(d2, D1, worldDireciton);
	//Canvas.DeProject(e2, E1, worldDireciton);
	//Canvas.DeProject(f2, F1, worldDireciton);
	//Canvas.DeProject(g2, G1, worldDireciton);
	//Canvas.DeProject(h2, H1, worldDireciton);

	Canvas.Draw2DLine(A1.x, A1.y, B1.x, B1.y, c);
	Canvas.Draw2DLine(A1.x, A1.y, C1.x, C1.y, c);
	Canvas.Draw2DLine(A1.x, A1.y, E1.x, E1.y, c);
	Canvas.Draw2DLine(G1.x, G1.y, C1.x, C1.y, c);
	Canvas.Draw2DLine(G1.x, G1.y, E1.x, E1.y, c);
	Canvas.Draw2DLine(G1.x, G1.y, H1.x, H1.y, c);
	Canvas.Draw2DLine(D1.x, D1.y, C1.x, C1.y, c);
	Canvas.Draw2DLine(D1.x, D1.y, H1.x, H1.y, c);
	Canvas.Draw2DLine(D1.x, D1.y, B1.x, B1.y, c);
	Canvas.Draw2DLine(F1.x, F1.y, E1.x, E1.y, c);
	Canvas.Draw2DLine(F1.x, F1.y, B1.x, B1.y, c);
	Canvas.Draw2DLine(F1.x, F1.y, H1.x, H1.y, c);
	// Get all the points of the box in 3D space
}

/**
 * The scaleform movie could be created at a different resolution
 * than the display. So we need to store the values for any HUD-> UDK 2D
 * translations that may occur
 **/
function CalcScaleformValues()
{
	local Vector2D h;
	local Vector2D k;

	// ratio of viewport compared to native resolution
	HudMovie.GetVisibleFrameRect(h.x, h.y, k.x, k.y);
		
	scaleformRatioX	= SizeX / (k.X - h.X);
	scaleformRatioY	= SizeY / (k.Y - h.Y);
}

/*
function ShowRadius(Vector loc, int size)
{
	local Canvas Canvas;
	local Vector screenspace, screenspaceW, screenspaceH;
	// Go from Worldspace to screenspace

	Canvas = lastCanvas;

	
	screenspace = Canvas.Project(loc);
	`Log("Loc Info : " @loc @screenspace );

	screenspaceW = loc;
	screenspaceW.X += size*class'ISONode'.const.NODE_SIZE;
	screenspaceW = Canvas.Project(screenspaceW);

	screenspaceH = loc;
	screenspaceH.X += size*class'ISONode'.const.NODE_SIZE;
	screenspaceH = Canvas.Project(screenspaceH);

    screenspace.X *= scaleformRatioX;
	screenspace.Y *= scaleformRatioY;

	HudMovie.ShowRadius(screenspace.x, screenspace.y, 20, 20);
}
function HideRadius()
{
	HudMovie.HideRadius();
}
*/

DefaultProperties
{
	HUDClass = class'ISOCore.GFxHUD';
}
