class MapPathZone extends Object;

var HashMapISOPathNode nodes;
var ISOPathNode root;

/***
 * Get all the nodes in the hashtable
 ***/
public function Array<ISOPathNode> GetNodes()
{
	return nodes.list;
}

public function bool Contains(ISONode node)
{
	return nodes.Get(node.GetIndex())!=none;
}

/**
 * Prepopulate the map area.
 * 
 **/
private final function GetAllValidPeers(ISOPathNode root, ISOGrid grid, ISOUnitBase base, float uRadius)
{
	local array<ISOPathNode> open;
	local array<ISOPathNode> neighbors;
	local ISOPathNode node, centroid;
	local int c;

	root.g = 0;
	open.AddItem(root);

	while( open.Length > 0 )
	{
		// Remove it from the open list
		centroid = Pop(open);
		centroid.closed = true;

		//`log("  Hashed: " @nodes.list.Length @"  OPen" @open.Length );

		// Get the neighbors of the currently open node
		neighbors = GetNeighbors(centroid, grid);

		foreach neighbors(node)
		{
			// Sanity check
			if( node.closed ) continue;

			// Distance check to root
			if( !node.travesable )
			{
				// Am I out of range?
				if( VSize(root.GetCentroid() - node.GetCentroid()) > uRadius )
				{
					node.travesable = false;
					node.closed = true;
					continue;
				}

				// Step check *from me
				if( base.GetStep() < Abs(centroid.height - node.height ) )
				{
					//node.travesable = false;
					continue;
				}

				// Can somthing step on this node?
				if( !class'GridUtil'.static.IsValid(node, grid, base ) )
				{
					node.travesable = false;
					node.closed = true;
					continue;
				}

				// Set it true if its travesable so we dont check if its valid next time
				node.travesable=true;
			}

			if( node.travesable )
			{
				c = GetCost(centroid, node) + centroid.g;

				// If I am cheaper, I shoud be parent, but favor the diagonal if its equal!
				if(     c < node.g || 
					   (c == node.g && node.row != centroid.row && node.col != centroid.col) )
				{
					node.g      = c;
					node.parent = centroid;
				}

				// Add it to the list of available nodes
				nodes.Put(node.GetIndex(), node);

				// Only add the node if its not already in the open list (already queue'd up)
				if( !node.open )
				{
					node.open = true;
					open.AddItem(node);
				}
			}
		}
	}
}

public function GetPath(ISONode goal, out Array<ISONode> path, const out ISOGrid grid)
{
	local ISOPathNode n;

	n = nodes.Get(goal.GetIndex());

	while (n!=none && n != root )
	{
		//path.push(pathVisited.node);
		path.InsertItem(0, grid.nodes[n.GetIndex()]);
		`log("Adding : " @ n );
		n = n.parent;
	}
	path.InsertItem(0,root);
}

/**
 * Get all the nodes in a 
 * radius around the passed
 * in range
 **/
public static final function MapPathZone Create(ISONode centroid, ISOUnitBase base, int radius, ISOGrid grid)
{
	local MapPathZone zone;
	local float uRadius;
	local HashMapISOPathNode hash;

	// Init the class
	zone = new class'MapPathZone';

	// Real quick sanity check
	if( centroid == none ) return zone;
	if( base == none ) return zone;

	// Increase the range by the base size
	radius += base.size;

	// Convert the passed in radius to 'UDK' scale
	uRadius = radius * class'ISOPathNode'.const.NODE_SIZE;

	// Initialize the passable hash
	hash = new class'HashMapISOPathNode';
	hash.setup(Square(radius*2));
	zone.nodes  = hash;
	zone.root   = zone.ToPathNode(centroid);
	
	// Check in a simple area and work out
	zone.GetAllValidPeers(zone.root, grid, base, uRadius);

	return zone;
}

private function ISOPathNode ToPathNode(const ISONode node, optional int defaultCost=99999)
{
	local ISOPathNode pnode;

	pnode = nodes.Get(node.GetIndex());

	if( pnode != none ) return pnode;

	pnode = class'ISOPathNode'.static.Create(node);
	pnode.g = defaultCost;
	nodes.Put(pnode.GetIndex(), pnode);

	return pnode;
}


/**
 * Get the distance between two nodes
 **/
private function int GetCost(ISOPathNode a, ISOPathNode b)
{
	return Abs(VSize(  a.GetCentroid() - b.GetCentroid() ));
}

private static function Push(ISOPathNode node, out Array<ISOPathNode> list)
{
	list.InsertItem(0, node);
}
private static function ISOPathNode Pop(out Array<ISOPathNode> list)
{
	local ISOPathNode node;
	node = list[0];
	list.Remove(0,1);
	return node;
}

private final function Array<ISOPathNode> GetNeighbors(ISOPathNode centroid, ISOGrid grid)
{
	local Array<ISOPathNode> peers;
	local ISOPathNode node;
	local int r, c;

	// Check in a simple area and work out
	//  _ _ _
	// |_|_|_|
	// |_|C|_| c is centroid
	// |_|_|_|
	for( r=-1;r<=1;r++ )
		for( c=-1;c<=1;c++ )
		{
			// Get the node
			node = ToPathNode(grid.GetNode(centroid.row + r, centroid.col + c));

			if( node != none )
				peers.AddItem(node);
		}
	return peers;
}

DefaultProperties
{
}
