class ActionSequencer extends Actor;

var private int time;
var ActionGroup game;

/**
 * Called to setup this Actor
 * 
 **/
function PreBeginPlay()
{
	`log("ActionSequencer Creating...");

	// Setup the game
	Reset();
}

function Reset()
{
	game = new(self) class'ActionGroup';
	time = 0;
}

/**
 * Schedule an action
 * 
 **/
function Schedule(Action action, optional int offset=0)
{
	game.Add(action, offset);
	action.SetWorldInfo(WorldInfo);
}

/** 
 *  Looks like the time is a float in seconds
 **/
function tick(float dt)
{
	local int delta;

	delta = dt * 1000;
	// I like ms!
	time += delta;
	game.actionTick(delta);
}

DefaultProperties
{
}
