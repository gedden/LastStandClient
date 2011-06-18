class ISOUnitBase extends Actor abstract;

// Move Modifiers
const UNIT_WALKING = 1;
const UNIT_FLYING  = 2;

// Member variables
var protected int team;     // What team I am on
var		      float size;   // How big my radius is
var protected int step;     // How many nodes I can step up
var protected int speed;
var protected int MovementFlags;


/** 
 *  Get the stat for this unit
 **/
public function int GetSpeed()
{
	return speed;
}
public function SetSpeed(const int speedIn)
{
	speed = speedIn;
}

/** 
 *  Get the stat for this unit
 **/
public function int GetStep()
{
	return step;
}


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


DefaultProperties
{
	team    = 0;
	size    = 2;
	step    = 2;
	MovementFlags=UNIT_WALKING;
}
