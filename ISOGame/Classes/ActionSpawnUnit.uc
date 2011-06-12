class ActionSpawnUnit extends ActionObject;

var public Class<Actor> unitClass;
var public ISONode node;

/**
 * spawn the actual unit
 **/
function actionBegin(int msLate)
{
	local Actor unit;
	super.actionBegin(msLate);

	`Log("Spawning Unit: " @msLate @time );

	unit = WorldInfo.Spawn(unitClass);
	unit.SetLocation( node.GetCentroid() );
	ISOUnit(unit).SetNode(node);
}

DefaultProperties
{
	duration = 0;
	unitClass = class'ISOUnit';
}
