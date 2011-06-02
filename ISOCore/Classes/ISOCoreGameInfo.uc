/*****************************************
 * Main Entry point for the core of the 
 * game play portion of the game client.
 * 
 * So it beings. ~ag
 ****************************************/
class ISOCoreGameInfo extends GameInfo;

var ISOGrid grid;
var	class<ISOGrid> GridClass;
var ISOCorePlayerController LocalPlayer;
var ActionSequencer sequencer;

DefaultProperties
{
	PlayerControllerClass   = class'ISOCore.ISOCorePlayerController'
	HUDType                 = class'ISOCore.ISOHUD'
	GridClass               = class'ISOCore.ISOGrid'
}

event PostLogin( PlayerController NewPlayer )
{
    super.PostLogin(NewPlayer);
    NewPlayer.ClientMessage("Welcome to the ISOCore "$NewPlayer.PlayerReplicationInfo.PlayerName);
	NewPlayer.GotoState('ISOPlayerWaiting');

	// Set the local player
	LocalPlayer = ISOCorePlayerController(NewPlayer);
}

function ISOGrid GetGrid()
{
	return grid;
}

event PreBeginPlay()
{
	// Create the grid
	grid = Spawn(GridClass);
	grid.setup();

	sequencer = Spawn(class'ActionSequencer');
}
