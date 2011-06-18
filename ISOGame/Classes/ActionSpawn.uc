class ActionSpawn extends ActionObject;

var public Unit unit;
var public ISONode node;

var Structure s;
/**
 * spawn the actual unit
 **/
function actionBegin(int msLate)
{
	super.actionBegin(msLate);

	// Cant spawn something from a template if there is no template
	if( unit == none ) return;
	if( unit.template == none ) return;

	`Log("Spawning From Template: " @msLate @time );
	//tech.idol = template.CreateIdol(WorldInfo, node, 1);
	unit.SpawnIdol(WorldInfo, node, 1);
}

DefaultProperties
{
	duration    = 0;
	unit        = none;
}

