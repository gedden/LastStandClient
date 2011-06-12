class MapZone extends Object;

// I miss you, java hashtable ~ag
var array< ISONode > nodes;
var ISONode root; // this is kind of an 'iffy' concept for a zone...

static final function MapZone Create(ISONode centroid, int radius, ISOGrid grid, optional ISOUnit unit)
{
	local MapZone zone;

	// This is the base path
	zone        = new class'MapZone';
	zone.root   = centroid;  

	if( unit == none )
		zone.nodes = class'GridUtil'.static.GetNodesInRange(centroid, radius, grid );
	else
		zone.nodes = class'GridUtil'.static.GetMovementArea(centroid, radius, grid, unit );
	return zone;
}

function Array< ISONode > GetPath(ISONode goal, ISOGrid grid)
{
	local Pathfinder finder;
	local Array<ISONode> path;


	if( nodes.Find(goal)<0 ) return path;

	finder = new class'PathFinder';

	finder.setup(grid, self, root, goal);
	if( finder.FindPath() )
		path = finder.path;
	return path;
}
function Array< ISONode > GetPath2(ISONode goal, ISOGrid grid)
{
	local Pathfinder2 finder;
	local Array<ISONode> path;

	finder = new class'PathFinder2';

	finder.setup(root, goal, self, grid);

	if( finder.FindPath() )
		path = finder.BuildPath();
	return path;
}

// Can prob just delete these, I dont know if I will ever use them
function ISONode GetNorthmost(ISOGrid grid)
{
	local int r,c;
	local ISONode result, n;
	c = root.col;

	for( r=root.row;r>=0;r-- )
	{
		n = grid.GetNode(r,c);
		if( nodes.Find(n)>0 )
			result = n;
	}
	return result;
}
function ISONode GetEastmost(ISOGrid grid)
{
	local int r,c;
	local ISONode result;
	local ISONode n;

	r = root.row;

	for( c=root.col;c>=0;c-- )
	{
		n = grid.GetNode(r,c);
		if( nodes.Find(n)>0 )
			result = n;
	}
	return result;
}

/**
 * 	Get the simple area around the passed in node.
 * 	 _ _ _
 * 	|_|_|_|
 * 	|_|C|_| c is centroid
 * 	|_|_|_|
 **/
public final function Array<ISONode> GetNeighbors(const out ISONode centroid, const out ISOGrid grid)
{
	local Array<ISONode> peers;
	local ISONode node;
	local int r, c;


	for( r=-1;r<=1;r++ )
		for( c=-1;c<=1;c++ )
		{
			if( r==0&&c==0 ) continue;

			// Get the node
			node = grid.GetNode(centroid.row + r, centroid.col + c);

			if( node != none && nodes.Find(node)>0 )
				peers.AddItem(node);
		}
	return peers;
}

DefaultProperties
{
	nodes.Empty
}
