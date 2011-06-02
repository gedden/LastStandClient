class ActionGroup extends ActionObject;

struct SequencedAction
{
	var int offset;
	var Action action;
};

var private Array<SequencedAction> actions;
var private Array<SequencedAction> active;

// Back reference to the sequencer... its an Actor!
var protected ActionSequencer sequencer;

const UNSET = -1;

/**
 * Add an action to this group
 **/
function Add(Action action, optional int offset=0)
{
	local SequencedAction seq;

	seq.action = action;
	seq.offset = offset;

	// Add it
	actions.AddItem(seq);

	// Update the duration
	duration += action.GetDuration();

	// Update the effective end time
	if( effective == UNSET )
	{
		if( action.GetEffectiveEndTime() != UNSET )
			effective = action.GetEffectiveEndTime();
	}
	else if( action.GetEffectiveEndTime() > effective )
		effective = action.GetEffectiveEndTime();

}

// From Action
function actionBegin(int msLate)
{
}

function actionEnd()
{
}

function actionTick(int dt)
{
	local SequencedAction item;
	time += dt;

	foreach actions(item)
	{
		if( item.offset >= time )
		{
			actions.RemoveItem(item);
			active.AddItem(item);
			item.action.actionBegin(time-item.offset);
		}
	}

	foreach active(item)
	{
		if( item.offset + item.action.GetDuration() > time )
		{
			item.action.actionEnd();
			active.RemoveItem(item);
		}
		else
		{
			item.action.actionTick(dt);
		}
	}
}


DefaultProperties
{
	effective = -1;
}
