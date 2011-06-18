class Ability extends Object;

enum AbilityType
{
	PASSIVE,
	ACTIVATED, 
	ATTACK,
	BUILDING
};


var protected String abilityName;
var protected int focus;
var protected int cooldown;
var protected int remaining; // duration of this ability, -1 = lasts forever
var protected int instance_id;
var protected int database_id;
var protected AbilityType type; 
//var protected Targeting targeting; // not written this yet


/**
 * Get the name of this ability
 **/
public function String GetName()
{
	return abilityName;
}

/**
 * Get the focus time for
 * this ability
 **/
public function int GetFocus()
{
	return focus;
}

/**
 * Get the CD time for
 * this ability
 **/
public function int GetCooldown()
{
	return cooldown;
}

/**
 * Get the Instance ID for
 * this ability
 **/
public function int GetInstanceID()
{
	return instance_id;
}

/**
 * Get the DB ID for
 * this ability
 **/
public function int GetDatabaseID()
{
	return instance_id;
}


DefaultProperties
{
	name = "Unnamed Ability";

	focus       = 0;
	cooldown    = 0;
	remaining   = INDEX_NONE;
	instance_id = 0;
	database_id = 0;
	type        = PASSIVE;
}
