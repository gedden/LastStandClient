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

/** FROM UNREALSCRIPT TO ACTIONSCRIPT **/
/*
function ShowRadius(float xloc, float yloc, float w, float h)
{
	ActionScriptVoid("ShowRadius");
}
*/

function DrawGrid(Array<Vector2D> verts, Array<int> colorIndices)
{
	local array<int> vb;
	local Vector2D v;

	foreach verts(v)
	{
		vb.AddItem(v.x);
		vb.AddItem(v.y);
	}
	SetVariableIntArray("grid.vb",0, vb);
	SetVariableIntArray("grid.cb",0, colorIndices);
}

function DrawActiveNodes()
{
	ActionScriptVoid("DrawActiveNodes");
}
function HideActiveNodes()
{
	ActionScriptVoid("HideActiveNodes");
}


DefaultProperties
{
	bDisplayWithHudOff=FALSE
	bEnableGammaCorrection=FALSE

	// Path to your package/flash file here.
	MovieInfo = SwfMovie'ISOPackage.ISOMouseDefault'
}

