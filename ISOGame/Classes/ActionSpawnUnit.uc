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

	unit = WorldInfo.Spawn(unitClass);
	unit.SetLocation( node.GetCentroid() );
}

DefaultProperties
{
	duration = 0;
	unitClass = class'ISOUnit';
}