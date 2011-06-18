class ActionMove extends ActionObject;

var ISOUnit unit;
var Array<ISONode> path;
var Vector currentPos;
var Vector finalTarget;

var ISONode current;
var ISONode next;

var Vector tvec;
var int etime;

/**
 * Setup the path
 **/
function setup(ISOUnit unitIn, const out Array<ISONode> pathIn)
{
	unit = unitIn;
	finalTarget = pathIn[pathIn.Length-1].GetCentroid();

	current = none;//pathIn[0];
	next    = none;//pathIn[pathIn.Length-1];

	path = pathIn;

	// Get the total time
	duration = GetTotalTime(pathIn);
}

private function float GetTotalTime(const out Array<ISONode> pathIn)
{
	local ISONode tlast, tnext;
	local float time;

	time = 0;
	tlast = none;

	foreach pathIn(tnext)
	{
		if( tlast != none )
			time += VSize(tlast.GetCentroid() - tnext.GetCentroid());
		tlast = tnext;
	}
	if( unit.movementSpeed == 0 ) return 1;
	return time / unit.movementSpeed * 1000;
}


/**
 * spawn the actual unit
 **/
function actionBegin(int msLate)
{
	super.actionBegin(msLate);
	unit.SetCollision(false, false);


}

private function GetCurrentTarget(int dt)
{

}



function actionTick(int dt)
{
	local float delta;
	local int index;
	local Vector current;
	local Vector next;
	super.actionTick(dt);

	delta = dt/1000.0;

	// How far along am I between the nodes in question
	


	index = GetPercent() * (path.Length-1);
	//`log("PErcent: " @GetPercent() @index @" of "  @path.Length );

	current = path[index].GetCentroid();
	if( index < path.Length-1 ) index++;
	next    = path[index].GetCentroid();

	tvec = Normal(next - unit.Location) * unit.movementSpeed * delta;
	ShowWalkingAnimation(Normal( next - current ));
	unit.Move(tvec);

	//unit.SetLocation(nextTarget);

}

function actionEnd()
{
	`log("ActionMove> ENDED!!!!!!!!!!!!!!!!!!!!!!!" @etime);
	unit.SetCollision(true, true);
	HideWalkingAnimation();
	unit.SetNode(path[path.Length-1]);
}

/******************* PRIVATE METHODS FOR MOVING THE UNIT ******************************/
private function ShowWalkingAnimation(Vector newVelocity)
{
	newVelocity.Z = 0;
	unit.Velocity = newVelocity;

	// Currently snapping to location. I wont do this forever
	if( !IsZero(newVelocity) ) unit.SetRotation(Rotator(newVelocity));
	//unit.SetPhysics(PHYS_Falling);
}

private function HideWalkingAnimation()
{
	unit.Velocity = vect(0,0,0);
	//unit.Acceleration = vect(0,0,1000);
	//unit.SetPhysics(PHYS_Flying);
	//`Log( "Physics" @unit.GetPhysicsName() );
	//unit.Move(nextTarget - unit.Location);

	unit.SetLocation(finalTarget);
	unit.SetPhysics(PHYS_None);
	
}

private function face(Vector targetLocation)
{
	targetLocation -= unit.Location;
	unit.SetRotation(Rotator(targetLocation));
}


DefaultProperties
{
	duration = 3000;
	//unitClass = class'ISOUnit';
}
