class ISOUnit extends ISOUnitBase abstract;

var ISONode             current;
var int                 selectFxSize;
var bool                canSquareSelect;
var bool                isSelected;
var Actor               selectFx;

var protected array<int>   abilities;

var class<ISOCoreFXGenerator>    selectFxGenerator;
var Actor selectionFX;

// Movement related stuff
enum Movement {HOLD, MOVE, APPROACH};
var float                                   movementSpeed;
var Movement                                mType;
var float                                   speed;
var NavigationHandle                        navHandle;
var Vector nextVelocity;
var Vector movementPosition;
var float tdt;
var Vector tvec;
var Vector targetPos;

simulated function PostBeginPlay()
{
	local Vector groundLoc;
	local Vector groundNorm;
	super.PostBeginPlay();
	//SetOwner(RTSGame(WorldInfo.Game).getPlayer(team));
	Trace(groundLoc, groundNorm, location - vect(0,0,500), Location + vect(0,0,500), true);
	SetLocation(groundLoc);

	// Movement related
	navHandle = new(self) class'NavigationHandle';
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
	addAbilities();
}

function onDeselect()
{
	selectionFX.Destroy();
	selectionFX = none;

	isSelected = false;
	//if (removeAbility) removeAbilities();
}

function addAbilities()
{
	/*
	local int abilityID;
	foreach abilities(abilityID) {
		getPlayer().addAbility(abilityID, self);
		`Log("adding ability "$abilityID);
	}
	*/
}

function removeAbilities()
{
	/*
	local int abilityID;
	foreach abilities(abilityID) {
			getPlayer().removeAbility(abilityID, self);
		}
	*/
}

// Movement level stuff
function setMovement(Movement newMType, Vector newVelocity, float travelTime)
{
	Velocity = newVelocity;
	SetRotation(Rotator(Velocity));
	mType = newMType;
	stopMovingAt(travelTime);
}

function bool MoveTo(Vector targetPosition)
{
	local Vector direction;
	//local Vector nextVelocity;
	local float travelTime;
	targetPos = targetPosition;
	//SetPhysics(PHYS_None);
	direction.X = (targetPosition.X - Location.X);
	direction.Y = (targetPosition.Y - Location.Y);
	direction.Z = 0;

	nextVelocity= direction * (movementSpeed/vSize(direction)) * 20;
	travelTime  = (vSize(direction))/movementSpeed;

	setMovement(MOVE, nextVelocity, travelTime);
	//setMovement(MOVE, nextVelocity * (speed/vSize(direction)), (vSize(direction)-approachDistance)/speed);
	return true;
}

function tick(float dt)
{
	switch (mType)
	{
		case APPROACH:
			/*
			Velocity.X = (target.Location.X - Location.X);
			Velocity.Y = (target.Location.Y - Location.Y);
			Velocity.Z = 0;
			if (vSize(Velocity) <= approachDistance)
				stopMoving();
			else {
				Velocity *= (speed/vSize(Velocity));
				SetRotation(Rotator(Velocity));			
			}
			*/
		case MOVE:

			tvec = Normal(targetPos - Location) * movementSpeed * dt;
			self.Move(tvec);
			//self.MoveTo(tvec);

			/*
			//tvec = targetPos - Location;
			tvec = (targetPos - Location)* dt;
			self.Move(tvec);
			*/


			/*
			tvec = location+velocity*dt;
			//self.Move(vect(0,0,1));
			navHandle.SetFinalDestination(targetPos);
			navHandle.GetNextMoveLocation(tvec,20);

			MoveTo(tvec, 20);

			SetLocation(tvec);
			//movementPosition = navHandle.MoveToDesiredHeightAboveMesh(location+velocity*dt, 0);
			
			*/
			//SetLocation(movementPosition);
			//setLocation(navHandle.MoveToDesiredHeightAboveMesh(location+velocity*dt, 0));
		break;
	}
}

function stopMoving()
{
	mType = HOLD;
	Velocity = vect(0,0,0);

	self.Move(targetPos - Location);
	// Make sure it got there. Should not be needed.
	//self.MoveTo(targetPos);
	//if (onFinishedMoving != none) onFinishedMoving(self);
}

function stopMovingAt(float timeFromNow) {
	setTimer(timeFromNow, false, nameOf(stopMoving));
}

function face(Vector targetLocation) {
	targetLocation -= Location;
	SetRotation(Rotator(targetLocation));
}

/*
function RTSPlayer getPlayer() { return RTSPlayer(Owner); }

function bool canSelect(RTSPlayer_Comands RTSPlayer) { return (RTSPlayer == Owner); }

function takeHit(int damageAmmount, int damageType);
*/
DefaultProperties
{
	selectFxSize=100
	canSquareSelect=true

	RemoteRole=ROLE_AutonomousProxy

	movementSpeed = 300
	bUpdateSimulatedPosition=true
	bCollideActors=true
	bBlockActors=true
	mType=HOLD
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
