class MapZone extends Object;

// I miss you, java hashtable ~ag
var array< ISONode > nodes;

static final function MapZone Create(ISONode centroid, int radius, ISOGrid grid, optional ISOUnit unit)
{
	local MapZone zone;

	// This is the base path
	zone       = new class'MapZone';

	if( unit == none )
		zone.nodes = class'GridUtil'.static.GetNodesInRange(centroid, radius, grid );
	else
		zone.nodes = class'GridUtil'.static.GetMovementArea(centroid, radius, grid, unit );
	return zone;
}

DefaultProperties
{
	nodes.Empty
}
