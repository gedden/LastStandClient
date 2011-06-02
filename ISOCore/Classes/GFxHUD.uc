class GFxHUD extends GFxMoviePlayer;

var int MouseX;
var int MouseY;

var GFxObject MouseCursor;

function Initialize()
{
	
	Start();
	Advance(0.0f);

	// ensure mouse cursor is always on top
	MouseCursor = GetVariableObject("MouseCursorInstance");
	MouseCursor.SetBool("topmostLevel", true);
}

function ReceiveMouseCoords(float x, float y)
{
	MouseX = x;
	MouseY = y;
}

DefaultProperties
{
	bDisplayWithHudOff=FALSE
	bEnableGammaCorrection=FALSE

	// Path to your package/flash file here.
	MovieInfo = SwfMovie'ISOPackage.ISOMouseDefault'
}

