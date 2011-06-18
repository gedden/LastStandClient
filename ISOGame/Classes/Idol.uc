/**
 * Idols are simply ISOUnits
 * that have abilities
 **/
class Idol extends ISOUnit;

var int instanceId;

var protected String unitName;
var protected int health;
//var protected int speed;          // From ISOUnitBase
var protected int defense;
var protected int attack;
var protected int critChanceBonus;
var protected int critDamageBonus;

//var protected int team;           // From ISOUnitBase; What team I am on
//var		    float size;         // From ISOUnitBase; How big my radius is
//var protected int step;           // From ISOUnitBase
//var protected int movementSpeed;  // From ISOUnit; Visually, how fast an idol moves
//var protected int size;           // From ISOUnit    
var protected float scale;          // Visual Scale


var protected UnitRace  unitRace;        // Everything has ONE race (Structures are race: Structure)
var protected UnitClass unitClass;      // Everything has ONE class

var protected byte type;            // IdolTemplate.IdolType
var Array<Ability> abilities;


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
public function string GetName()
{
	return unitName;
}

public function Unit GetUnit()
{
	return Unit(tech);
}

/**
 * Set the template for this idol, and update
 * all the base stats accordingly. 
 * 
 **/
public function SetFromTemplate(const Unit unit)
{
	// Set the tech
	tech       = unit;

	// Now that the idol has been spawned, set all of its juicy stats
	unitName   = unit.template.GetName();
	health     = unit.template.GetHealth();
	speed      = unit.template.GetSpeed();
	defense    = unit.template.GetDefense();
	attack     = unit.template.GetAttack();
	step       = unit.template.GetStep();
	size       = unit.template.GetSize();
	scale      = unit.template.GetStep();
	unitRace   = unit.template.GetUnitRace();
	unitClass  = unit.template.GetUnitClass();
	abilities  = unit.template.abilities;
	critChanceBonus    = unit.template.GetCritChanceBonus();
	critDamageBonus    = unit.template.GetCritDamageBonus();
	//movementSpeed      = unit.template.GetMovementSpeed();
}


DefaultProperties
{
	// Default base stats
	health  = 99
	speed   = 99
	defense = 50
	attack  = 50
	unitName= "Unnamed"

	critChanceBonus = 0;
	critDamageBonus = 0;

	team    = 0;     // What team I am on
	size    = 3;     // How big my radius is
	step    = 3;     // How many nodes I can step up
}
