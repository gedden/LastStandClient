class ISOUnitBase extends Actor abstract;

// Move Modifiers
const UNIT_WALKING = 1;
const UNIT_FLYING  = 2;

// Member variables
var protected int team;     // What team I am on
var		      float size;     // How big my radius is
var protected int step;     // How many nodes I can step up
var protected int MovementFlags;

/**
 * Check the flags to see if
 * this unit is flying
 **/
function bool isFlying()
{
	return (MovementFlags&UNIT_FLYING) == UNIT_FLYING;
}

/**
 * Check the flags to see if
 * this unit is walking
 **/
function bool isWalking()
{
	return (MovementFlags&UNIT_WALKING) == UNIT_WALKING;
}

function int GetStep()
{
	return step;
}

DefaultProperties
{
	team    = 0;
	size    = 1.5;
	step    = 3;
	MovementFlags=UNIT_WALKING;
}
