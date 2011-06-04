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

	`log("Hitting the scheduler" @GetGrid().PlayerStarts.Length);

	// Deploy a base at each starting area
	foreach GetGrid().PlayerStarts(start)
	{
		`log("Scheduling...");
		spawn           = new class'ActionSpawnUnit';
		spawn.unitClass = class'BuildingUnit';
		spawn.node      = GetGrid().GetNode(start.row, start.col);

		sequencer.Schedule(spawn, 5000);
	}

}

DefaultProperties
{
	PlayerControllerClass   = class'ISOGame.ISOGamePlayerController'
}
