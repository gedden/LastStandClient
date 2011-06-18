class GFxHUD extends GFxMoviePlayer;

var int MouseX;
var int MouseY;

var protected GFxObject MouseCursor;
var protected GFxObject lowerHUD;
var ISOHUD hud;

function Initialize(const ISOHUD parent)
{
	hud = parent;
	Start();
	Advance(0.0f);

	// ensure mouse cursor is always on top
	MouseCursor = GetVariableObject("MouseCursorInstance");
	MouseCursor.SetBool("topmostLevel", true);


	// Get the lower hud object
	lowerHUD = GetVariableObject("lower");

}

/******************* FROM ACTIONSCRIPT TO UNREALSCRIPT *************************/
function ReceiveMouseCoords(float x, float y)
{
	MouseX = x;
	MouseY = y;
}

function RecieveMouseClick()
{
	//`log( ISOHUD(Outer).WorldInfo );
	`log("MOUSE CLICK!");
	//ISOCoreGameInfo(ISOHUD(Outer).WorldInfo.Game).LocalPlayer.onClick();
	ISOCoreGameInfo(hud.WorldInfo.Game).LocalPlayer.onClick();
}

/**
 * Show the proper information
 * in the lower hud
 **/
function ShowHUD(Tech tech)
{
	/*
	SetStats(base.GetHealth(), base.GetSpeed(), base.GetAttack(), base.GetDefense());
	SetName(base.GetName());
	*/
	lowerHUD.ActionScriptVoid("ShowHUD");
}

function HideHUD()
{
	lowerHUD.ActionScriptVoid("HideHUD");
}



/** FROM UNREALSCRIPT TO ACTIONSCRIPT **/
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

/************* LOWER HUD COMMUNICATION **********************/
function SetStats(int health, int speed, int attack, int defense)
{
	lowerHUD.ActionScriptVoid("SetStats");
}

function SetName(string newName)
{
	lowerHUD.ActionScriptVoid("SetName");
}

DefaultProperties
{
	bDisplayWithHudOff=FALSE
	bEnableGammaCorrection=FALSE

	// Path to your package/flash file here.
	MovieInfo = SwfMovie'ISOPackage.ISOMouseDefault'
}

