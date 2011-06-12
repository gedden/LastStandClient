class ISOGame extends ISOCoreGameInfo;

/** 
 * Start up the game, bitches
 **/ 
event PostLogin( PlayerController NewPlayer )
{
    super.PostLogin(NewPlayer);
	NewPlayer.GotoState('ISOCombatPlayerTurn');
}

/** 
 * Entry function into the game
 **/ 
function PostBeginPlay()
{
	// Deploy the bases
	super.PostBeginPlay();
	DeployBases();
}

/**
 * Deploy bases
 **/ 
function DeployBases()
{
	local PlayerStartData start;
	local ActionSpawnUnit spawn;

	// Deploy a base at each starting area
	foreach GetGrid().PlayerStarts(start)
	{
		`log("Scheduling...");
		spawn           = new class'ActionSpawnUnit';
		spawn.unitClass = class'BuildingUnit';
		spawn.node      = GetGrid().GetNode(start.row, start.col);

		sequencer.Schedule(spawn);

		// Make a dude near the building
		spawn           = new class'ActionSpawnUnit';
		spawn.unitClass = class'Character';
		spawn.node      = GetGrid().GetNode(start.row+5, start.col+5);

		sequencer.Schedule(spawn, 1500);
	}

}

DefaultProperties
{
	PlayerControllerClass   = class'ISOGame.ISOGamePlayerController'
	HUDType                 = class'ISOGame.ISOFogHUD'
}
