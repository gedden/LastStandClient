class ISOUnit extends ISOUnitBase abstract;

// The tech that created this unit
var protected Tech      tech;

var ISONode             current;
var int                 selectFxSize;
var bool                isSelected;
var Actor               selectFx;

var protected Array<Ability>   abilities;

var class<ISOCoreFXGenerator>    selectFxGenerator;
var Actor selectionFX;

// Movement related stuff
var(Custom) float                        movementSpeed;


simulated function PostBeginPlay()
{
	local Vector groundLoc;
	local Vector groundNorm;
	super.PostBeginPlay();
	//SetOwner(RTSGame(WorldInfo.Game).getPlayer(team));
	Trace(groundLoc, groundNorm, location - vect(0,0,500), Location + vect(0,0,500), true);
	SetLocation(groundLoc);
}

/**
 * Get the node that this 
 * unit currently occupies
 **/
function ISONode GetNode()
{
	return current;
}

/** 
 *  Set the node this unit
 *  occupies
 **/
function SetNode(ISONode next)
{
	current = next;
}

simulated function Destroyed()
{
	onDeselect();	
}

function onSelect()
{
	selectionFX = selectFxGenerator.static.generateEffect(Self, Self.selectFxSize, 0);
	isSelected = true;
}

function onDeselect()
{
	selectionFX.Destroy();
	selectionFX = none;

	isSelected = false;
}

/**
 * Add an new instance of this ability
 * to the unit
 **/
function AddAbility(Ability ability)
{
	abilities.AddItem(ability);
}

/**
 * Remove an ability from this
 * unit
 **/
function RemoveAbility(Ability ability)
{
	abilities.RemoveItem(ability);
}

function Tech GetTech()
{
	return tech;
}

DefaultProperties
{
	selectFxSize=100
	RemoteRole=ROLE_AutonomousProxy

	movementSpeed = 300
	bUpdateSimulatedPosition=true
	bCollideActors=true
	bBlockActors=true

	Begin Object Class=CylinderComponent Name=CollisionCylinder
		CollisionRadius=+0034.000000
		CollisionHeight=+0078.000000
		BlockNonZeroExtent=true
		BlockZeroExtent=true
		BlockActors=true
		CollideActors=true
	End Object
	CollisionComponent=CollisionCylinder
	components.add(CollisionCylinder)

	SelectFxGenerator=class'ISOCoreSelectionFXGenerator'
}
