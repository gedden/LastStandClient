/*****************************************
 * Main Entry point for the core of the 
 * game play portion of the game client.
 * 
 * So it beings. ~ag
 ****************************************/
class ISOCoreGameInfo extends GameInfo;

var ISOGridController gc;
var	class<ISOGridController> GridControllerClass;
var ISOCorePlayerController LocalPlayer;
var ActionSequencer sequencer;

event PostLogin( PlayerController NewPlayer )
{
    super.PostLogin(NewPlayer);
    NewPlayer.ClientMessage("Welcome to the ISOCore "$NewPlayer.PlayerReplicationInfo.PlayerName);
	NewPlayer.GotoState('ISOPlayerWaiting');

	// Set the local player
	LocalPlayer = ISOCorePlayerController(NewPlayer);
}

function ISOGridController GetGridController()
{
	return gc;
}

function ISOGrid GetGrid()
{
	return gc.grid;
}

event PreBeginPlay()
{
	// The actual grid controller
	gc = Spawn(GridControllerClass);
	gc.Setup();

	// Build the action sequencer
	sequencer = Spawn(class'ActionSequencer');
}

DefaultProperties
{
	PlayerControllerClass   = class'ISOCore.ISOCorePlayerController'
	HUDType                 = class'ISOCore.ISOHUD'
	GridControllerClass     = class'ISOCore.ISOGridController';
}