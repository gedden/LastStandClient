class GridUtil extends Object;

// Map Modifiers
const MAP_MOD_CHASIM    = 1;
const MAP_MOD_IMPEDING  = 2;

// Flags for pathfinding
const IMPASSABLE        = -999; // I cant get to it
const PASSABLE          = 1;    // I CAN get to it
const UNKNOWN           = -1;   // I have not checked yet, or I cant be sure


/**
 * Get all the nodes in a 
 * radius around the passed
 * in range
 **/
public static final function array<ISONode> GetNodesInRange(ISONode root, int radius, ISOGrid grid, optional bool considerHeight=true, bool considerMapBounds=true, optional out int checksum)
{
	local array<ISONode> nodes;

	local int minRow, maxRow, r;
	local int minCol, maxCol, c;
	local int index;
	local float uRadius;
	local Vector nodeCentroid;
	local ISONode node;

	if( considerMapBounds )
	{
		minRow = Max(0,         root.row-radius);
		maxRow = Min(grid.rows, root.row+radius);
			
		minCol = Max(0,         root.col-radius);
		maxCol = Min(grid.cols, root.col+radius);
	}
	else
	{
		minRow = root.row-radius;
		maxRow = root.row+radius;
			
		minCol = root.col-radius;
		maxCol = root.col+radius;
	}


	// Convert the passed in radius to 'UDK' scale
	uRadius     = radius * class'ISONode'.const.NODE_SIZE;

	for( r=minRow; r<=maxRow; r++ )
	{
		for( c=minCol; c<=maxCol; c++ )
		{
			/*
			node = grid.GetNode(r,c);

			// If the node I wanted is not the node I got, then its a node off the grid
			if( !considerMapBounds && (node.row != r || node.col != c) )
			{
				nodeCentroid = grid.GetController().GetVirtualCentroid(r, c, 0);
				node = none;
			}
			else
				nodeCentroid = node.GetCentroid();	
			*/

			index = grid.GetNodeIndex(r,c);

			if( !considerMapBounds && (index<0 || index>grid.nodes.Length-1) )
				node=none;
			else
				node = grid.nodes[index];

			// If the node I wanted is not the node I got, then its a node off the grid
			if( !considerMapBounds && ( node==none || (node.row != r || node.col != c)) )
			{
				nodeCentroid = grid.GetController().GetVirtualCentroid(r, c, 0);
				node = none;
			}
			else
				nodeCentroid = node.GetCentroid();


			// Ignore the height
			if( !considerHeight ) nodeCentroid.Z = root.GetCentroid().Z;

			if( VSize(root.GetCentroid() - nodeCentroid) <= uRadius ) 
			{
				checksum++;
				if( node != none )
					nodes.AddItem(node);
			}
		}
	}
	return nodes;
}

/**
 * Can this unit exist on this node?
 * 
 **/
static function bool IsValid(ISONode root, ISOGrid grid, ISOUnitBase base, optional out HashArea passableArea)
{
	local array<ISONode> area;
	local ISONode node;
	local int m;
	local int checksum;

	// Get the area this unit will take up
	area = GetNodesInRange(root, base.size, grid, false, false, checksum );

	if( area.Length != checksum ) return false;

	foreach area(node)
	{
		if( node == none ) return false;

		// Is the ground to rugged for me to fit on it?
		if( base.GetStep() < Abs(root.height - node.height ) )
		{
			`Log("Root Neighbor HEIGHT: " @root.height @root.index @root.IsA('ISOPathNode') );
			//`log("Base.GetStep()" @base.GetStep() @" vs (" @root.height @"-" @node.height @") " @Abs(root.height - node.height)  @"Root index" @root.index );
			return false;
		}

		// Double check it!
		if( passableArea != none )
		{
			m = passableArea.Get(node.GetIndex());
			if( m == PASSABLE ) continue;
			if( m == IMPASSABLE ) return false;
		}

		// Check to see if its blocked
		if( node.IsBlocking() 
			|| ( node.isChasim() && !base.isFlying() )
			|| ( node.GetUnit() != none ) )
		{
			if( passableArea != none )
				passableArea.Put(node.GetIndex(), IMPASSABLE);
			return false;
		}

		//if( passableArea != none ) passableArea.Put(node.GetIndex(), PASSABLE );
	}
	return true;
}

public static final function Array<ISONode> GetNeighbors(ISONode centroid, ISOGrid grid)
{
	local Array<ISONode> peers;
	local ISONode node;
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
			node = grid.GetNode(centroid.row + r, centroid.col + c);

			if( node != none )
				peers.AddItem(node);
		}
	return peers;
}

private static final function GetAllValidPeers(ISONode root, ISOGrid grid, ISOUnitBase base, float uRadius, out array<ISONode> nodes, out HashArea passableArea)
{
	local array<ISONode> open;
	local array<ISONode> neighbors;
	local ISONode node, centroid;
	local int m;

	open.AddItem(root);

	while( open.Length > 0 )
	{
		// Remove it from the open list
		centroid = Pop(open);

		// Get the neighbors of the currently open node
		neighbors = GetNeighbors(centroid, grid);

		foreach neighbors(node)
		{
			// Sanity check
			if( nodes.Find(node)!=-1 ) continue;

			// Distance check
			if( VSize(root.GetCentroid() - node.GetCentroid()) > uRadius ) continue;

			// Step check
			if( base.GetStep() < Abs(centroid.height - node.height ) )
			{
				// I cant get to it, from here
				//if( passable != none ) passable.Put(node.GetIndex(), UNKNOWN);
				continue;
			}

			// Check to see if the node has been checked before, and is passable
			m = passableArea.Get(node.GetIndex());

			if( m == UNKNOWN && IsValid(node, grid, base, passableArea ) )
			//if( (m == UNKNOWN && IsValid(node, grid, base, passableArea )) || m == PASSABLE )
			{
				nodes.AddItem(node);				
				open.AddItem(node);
			}	
		}
	}
}

/** 
 *  So it looks like you cant call the same function recursively over 250 timess
 *
private static final function GetAllValidPeersRECURSIVE(ISONode centroid, ISOGrid grid, ISOUnitBase base, ISONode root, float uRadius, out array<ISONode> nodes, out HashArea passableArea)
{
	local array<ISONode> children;
	local ISONode node;
	local int r, c, m;

	// Check in a simple area and work out
	//  _ _ _
	// |_|_|_|
	// |_|C|_| c is centroid
	// |_|_|_|
	for( r=-1;r<=1;r++ )
		for( c=-1;c<=1;c++ )
		{
			// Get the node
			node = grid.GetNode(centroid.row + r, centroid.col + c);

			// Sanity check
			if( nodes.Find(node)!=-1 ) continue;

			// Distance check
			if( VSize(root.GetCentroid() - node.GetCentroid()) > uRadius ) continue;

			// Step check
			if( base.GetStep() < Abs(centroid.height - node.height ) )
			{
				// I cant get to it, from here
				//if( passable != none ) passable.Put(node.GetIndex(), UNKNOWN);
				continue;
			}

			// Check to see if the node has been checked before, and is passable
			m = passableArea.Get(node.GetIndex());

			if( m == UNKNOWN && IsValid(node, grid, base, passableArea ) )
			//if( (m == UNKNOWN && IsValid(node, grid, base, passableArea )) || m == PASSABLE )
			{
				nodes.AddItem(node);				

				children.AddItem(node);
			}	
		}

	foreach children(node)
		GetAllValidPeersRECURSIVE(node, grid, base, root, uRadius, nodes, passableArea);
}
*/

/**
 * Get all the nodes in a 
 * radius around the passed
 * in range
 **/
public static final function array<ISONode> GetMovementArea(ISONode centroid, int radius, ISOGrid grid, ISOUnitBase base)
{
	local array<ISONode> nodes;
	local HashArea passableArea;
	local float uRadius;

	// Real quick sanity check
	if( centroid == none ) return nodes;

	// Increase the range by the base size
	radius += base.size;

	// Convert the passed in radius to 'UDK' scale
	uRadius = radius * class'ISONode'.const.NODE_SIZE;

	// Initialize the passable hash
	passableArea= class'HashArea'.static.Create( Square(radius*2) );

	// Check in a simple area and work out
	//  _ _ _
	// |_|_|_|
	// |_|C|_| c is centroid
	// |_|_|_|
	GetAllValidPeers(centroid, grid, base, uRadius, nodes, passableArea);
	//`log("passable area: " @passableArea.count @nodes.Length);
	//passableArea.toLog();
	return nodes;
}

private static function Push(ISONode node, out Array<ISONode> list)
{
	list.InsertItem(0, node);
}
private static function ISONode Pop(out Array<ISONode> list)
{
	local ISONode node;
	node = list[0];
	list.Remove(0,1);
	return node;
}

DefaultProperties
{
}
