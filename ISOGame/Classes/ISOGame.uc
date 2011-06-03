class ISOGame extends ISOCoreGameInfo;

/**
 * Entry function into the game
 **/ 
function PostBeginPlay()
{
	super.PostBeginPlay();

	// Deploy the bases
	DeployBases();
}

function DeployBases()
{
	local PlayerStartData start;
	local ActionSpawnUnit spawn;

	`log("HItting the scheduler" @GetGrid().PlayerStarts.Length);

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
}
