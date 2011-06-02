class BuilderGFxHUD extends GFxHUD;

var Vector4 debug;
var ISOBuilderHUD hud;

/**
 * The user has requested to save this map
 **/
function onUpdateMap(int xrange, int yrange)
{

}

/**
 * The user has requested to save this map
 **/
function onSaveMap()
{
	hud.onSaveMap();
	//ISOBuilderGrid(ISOMapBuilder(WorldInfo.Game).grid).SaveMapData();
	//ISOBuilderHUD(Outer).onSaveMap();
}

function onUpdateDebug(float x, float y, float z, float w)
{
	debug.X = x;
	debug.Y = y;
	debug.Z = z;
	debug.W = w;
}

/** FROM UNREALSCRIPT TO ACTIONSCRIPT **/
function onShowNotification(String message)
{
	ActionScriptVoid("onShowNotification");
}

/*
function SetGridRotation(float x, float y, float z)
{
	ActionScriptVoid("SetGridRotation");
}

function SetGridPosition(int x, int y)
{
	ActionScriptVoid("SetGridPosition");
}
*/
DefaultProperties
{
	bDisplayWithHudOff=FALSE
	bEnableGammaCorrection=FALSE

	// Path to your package/flash file here.
	MovieInfo = SwfMovie'ISOBuilder.ISOMapBuilderHUD'
	//MovieInfo = SwfMovie'ISOBuilder.ISOAS3Test'
}

