class ActionObject extends Object implements(Action) abstract;

var protected int time;
var protected int duration;
var protected int effective;

var transient WorldInfo	WorldInfo;

function actionBegin(int msLate)
{
	time = msLate;
}

function actionEnd();
function actionTick(int dt)
{
	time+=dt;
}

function int GetDuration()
{
	return duration;
}

/**
 * Set the duration for
 * this action
 **/
function SetDuration(int dur)
{
	self.duration = duration;
}

function int GetEffectiveEndTime()
{
	if( effective == -1 )
		return GetDuration();
	return effective;
}

/**
 * Get the percent of completion!
 * 
 * Between 0 -> 1 (inclusive)
 **/
function float GetPercent()
{
	local float percent;

	// Get the duration
	if( duration < 0 ) return 1.0f;

	// Simple Check
	percent =  float(time)/float(duration);

	// Some sanity checks
	if( percent > 1 ) return 1.0f;
	if( percent < 0 ) return 0;

	// Return the percent between 0 - 1
	return percent;
}
function SetWorldInfo(WorldInfo info)
{
	WorldInfo = info;
}

DefaultProperties
{
	duration = 1000;
	effective= -1;
}

