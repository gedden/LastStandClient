class ISOGame extends ISOCoreGameInfo;

var Array<UnitRace>     races;
var Array<UnitClass>    classes;
var bool testing;

/** 
 * Start up the game, bitches
 **/ 
event PostLogin( PlayerController NewPlayer )
{
    super.PostLogin(NewPlayer);
	NewPlayer.GotoState('ISOCombatPlayerTurn');
}

event PreBeginPlay()
{
	super.PreBeginPlay();

	// Load up the races & classes
	races   = class'UnitRace'.static.Load();
	classes = class'UnitClass'.static.Load();
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
	local ActionSpawn aSpawn;
	local Unit base;
	local Unit dude;
	local Unit warlord;

	// Create base template
	base = new class'Unit';
	base.template = class'IdolTemplate'.static.Create(1, "Archetypes.HeliousStructures.Ship", 1, "Base", 100, 0, 100, 0, 0, 0, 0, 3, 2, 0, races[10], classes[6] );

	// Create a base character
	dude = new class'Unit';
	dude.template = class'IdolTemplate'.static.Create(1, "Archetypes.Durus.DurusBerserker", 0, "Berserker", 100, 20, 100, 50, 0, 0, 2, 2, 1, 300, races[10], classes[6] );

	// Create a base character
	warlord = new class'Unit';
	warlord.template = class'IdolTemplate'.static.Create(1, "Archetypes.Durus.DurusWarlord", 0, "Warlord", 100, 20, 100, 50, 0, 0, 5, 3, 1, 300, races[10], classes[6] );


	// Deploy a base at each starting area
	foreach GetGrid().PlayerStarts(start)
	{
		`log("Scheduling...");
		aSpawn          = new class'ActionSpawn';
		aSpawn.unit     = base;
		aSpawn.node     = GetGrid().GetNode(start.row, start.col);
		sequencer.Schedule(aSpawn);

		aSpawn          = new class'ActionSpawn';
		aSpawn.unit     = dude;
		aSpawn.node     = GetGrid().GetNode(start.row + 5, start.col + 5);
		sequencer.Schedule(aSpawn, 1500);

		aSpawn          = new class'ActionSpawn';
		aSpawn.unit     = warlord;
		aSpawn.node     = GetGrid().GetNode(start.row - 5, start.col - 5);
		sequencer.Schedule(aSpawn, 1500);


		// Make a dude near the building
		//spawn           = new class'ActionSpawnUnit';
		//spawn.unitClass = class'Character';
		//spawn.node      = GetGrid().GetNode(start.row+5, start.col+5);
	}

}

DefaultProperties
{
	PlayerControllerClass   = class'ISOGame.ISOGamePlayerController'
	HUDType                 = class'ISOGame.ISOGameHUD'
}
