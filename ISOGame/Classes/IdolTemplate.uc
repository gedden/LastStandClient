/**
 * An idol template holds the basic
 * data that makes up an idol
 **/
class IdolTemplate extends Object;

enum IdolType
{
	CHARACTER,
	STRUCTURE
};

// Template identifier
var int templateId;

// Basic stats
var protected String unitName;
var protected int health;
var protected int speed;
var protected int defense;
var protected int attack;
var protected String archetypeName; 

var protected int critChanceBonus;
var protected int critDamageBonus;

var protected int step;
var protected int size;
var protected float scale;          // Visual Scale
var protected int movementSpeed;    // Visually, how fast an idol moves

var protected UnitRace  unitRace;        // Everything has ONE race (Structures are race: Structure)
var protected UnitClass unitClass;      // Everything has ONE class
var protected IdolType type;

var Array<Ability> abilities;

/**
 * Create a new template
 **/
public static function IdolTemplate Create(const int templateId, const String archetypeName, const IdolType type, const String unitNameIn, const int healthIn, const int speedIn, const int defenseIn, const int attackIn, const int critChanceBonusIn, const int critDamageBonusIn, const int stepIn, const int sizeIn, const float scaleIn, const int movementSpeedIn, const UnitRace unitRaceIn, const UnitClass unitClassIn, optional const Array<Ability> abilities)
{
	local IdolTemplate template;

	template = new class'IdolTemplate';

	template.archetypeName = archetypeName;
	template.templateId = templateId;
	template.type       = type;

	template.unitName   = unitNameIn;
	template.health     = healthIn;
	template.speed      = speedIn;
	template.defense    = defenseIn;
	template.attack     = attackIn;
	template.critChanceBonus    = critChanceBonusIn;
	template.critDamageBonus    = critDamageBonusIn;
	template.step       = stepIn;
	template.size       = sizeIn;
	template.scale      = scaleIn;
	template.movementSpeed      = movementSpeedIn;

	// Set the race & class
	template.unitRace       = unitRaceIn;
	template.unitClass      = unitClassIn;

	// Set the abiliities
	template.abilities  = abilities;

	// Return the template that was just built
	return template;
}

/** 
 *  Get the health for this
 *  unit
 **/
public function int GetHealth()
{
	return health;
}

/** 
 *  Get the stat for this unit
 **/
public function int GetDefense()
{
	return defense;
}

/** 
 *  Get the stat for this unit
 **/
public function int GetAttack()
{
	return attack;
}

/** 
 *  Get the stat for this unit
 **/
public function int GetSpeed()
{
	return speed;
}

/** 
 *  Get the stat for this unit
 **/
public function string GetName()
{
	return unitName;
}

function int GetStep()
{
	return step;
}

public function int GetSize()
{
	return size;
}

function UnitRace GetUnitRace()
{
	return unitRace;
}
function UnitClass GetUnitClass()
{
	return unitClass;
}

function int GetCritChanceBonus()
{
	return critChanceBonus;
}
function int GetCritDamageBonus()
{
	return critDamageBonus;
}

function class<Idol> GetIdolClass()
{
	if( type == CHARACTER )
		return class'Character';
	return class'Structure';
}

function Idol GetArchetype()
{
	if( type == CHARACTER )
		return Character(DynamicLoadObject(archetypeName, class'Character'));
	return Structure(DynamicLoadObject(archetypeName, class'Structure'));
}

DefaultProperties
{
	size    = 2;
	step    = 2;

	// Default base stats
	health  = 99
	speed   = 99
	defense = 50
	attack  = 50
	unitName= "Unnamed"

	unitClass   = None
	unitRace    = None

	type          = CHARACTER;
	archetypeName = "Archetypes.Durus.DurusBerserker";
}
