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



	// Deploy a base at each starting area
	foreach grid.PlayerStarts(start)
	{
		spawn           = new class'ActionSpawnUnit';
		spawn.unitClass = class'BuildingUnit';
		spawn.node      = grid.GetNode(start.row, start.col);

		sequencer.Schedule(spawn, 5000);
	}

}

DefaultProperties
{
}
