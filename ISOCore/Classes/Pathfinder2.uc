class Pathfinder2 extends Object;

var HashMapISOPathNode hash;

var ISOPathNode start;
var ISOPathNode goal;
var ISOGrid grid;

var MapZone zone;

var bool impossible;

function setup(const out ISONode istart, const out ISONode igoal, MapZone izone, const out ISOGrid igrid)
{
	zone    = izone;
	grid    = igrid;

	hash    = new class'HashMapISOPathNode';
	hash.setup( zone.nodes.length );

	start   = ToPathNode(istart, 0);
	goal    = ToPathNode(igoal, 0);

	impossible = zone.nodes.Find(istart)<0;
}

public function bool FindPath()
{
	//var openNodes:Array = [];
	local Array<ISOPathNode> openNodes;
	// var closedNodes:Array = [];
	local Array<ISOPathNode> closedNodes;
	//var currentNode:INode = firstNode;
	local ISOPathNode currentNode;
	//var testNode:INode;
	local ISOPathNode testNode;
	//var connectedNodes:Array;
	local Array<ISOPathNode> connectedNodes;
	//var travelCost:Number = 1.0;
	local float travelCost;
	//var g:Number;
	//var h:Number;
	//var f:Number;
	local int g, h, f, l, i;
	//currentNode.g = 0;
	//currentNode.h = Pathfinder.heuristic(currentNode, destinationNode, travelCost);
	//currentNode.f = currentNode.g + currentNode.h;
	//var l:int = nodes.length;
	//var i:int;

	// Sanity check! Make sure the starting node is even in the zone
	if( impossible ) return false;

	currentNode = start;
	travelCost  = 1.0;
	l           = zone.nodes.Length;

	travelCost  = GetCost(currentNode, goal);

	currentNode.g = 0;
	currentNode.h = euclidianHeuristic(currentNode, goal, travelCost);
	currentNode.f = currentNode.g + currentNode.h;


	// Actual loop
	while (currentNode != goal )
	{
		//connectedNodes = connectedNodeFunction( currentNode );
		connectedNodes = GetConnectedNodes(currentNode);
		l = connectedNodes.length;

		`log("Connected Nodes: " @l );

		for (i = 0; i < l; ++i)
		{
			testNode = connectedNodes[i];
			//`log("Compare:" @testNode.GetIndex() @currentNode.GetIndex() @(testNode == currentNode));
			if (testNode == currentNode || testNode.travesable == false) continue;

			//If you have a world where diagonal movements cost more than regular movements then you would need to determine if a movement is diagonal and then adjust
			//the value of travel cost accordingly here.

			travelCost  = GetCost(currentNode, testNode);
			`log("Travel Cost " @testNode.row @testNode.col @"-->" @currentNode.row @currentNode.col @" = " @travelCost );

			g = currentNode.g  + travelCost;
			h = euclidianHeuristic( testNode, goal, travelCost);
			f = g + h;

			if ( testNode.open || testNode.closed )
			{
				if(testNode.f > f)
				{
					testNode.f = f;
					testNode.g = g;
					testNode.h = h;
					testNode.parent = currentNode;
				}
			}
			else
			{
				testNode.f = f;
				testNode.g = g;
				testNode.h = h;
				testNode.parent = currentNode;
				//openNodes.push(testNode);
				Push(testNode, openNodes);
				`log( " --> Pushing " @testNode.GetIndex() );
				testNode.open = true;				
			}
		}
		//closedNodes.push( currentNode );
		Push(testNode, closedNodes);
		testNode.closed = true;

		if (openNodes.length == 0)
		{
			return false;
		}
		`log("Open list" );
		openNodes.Sort(SmallestFSort);
		foreach openNodes(testNode) 
			`log( "   - " @testNode.GetIndex() @testNode.f );

		currentNode = PopSmallestF(openNodes);
		currentNode.open=false;
		`log( "Checking : " @currentNode.GetIndex() @currentNode.f );
		//openNodes.sortOn('f', Array.NUMERIC);
		//currentNode = openNodes.shift() as INode;
	}
	`log( "Finished! Building Path!");
	//return BuildPath(goal, start);
	return true;
}

//public function Array<ISONode> BuildPath(ISOPathNode destinationNode, ISOPathNode startNode)
public function Array<ISONode> BuildPath()
{
	local Array<ISONode> path;
	local ISOPathNode node;

	node = goal;
		
	//path.push(node);
	path.AddItem(node);

	while (node != start)
	{
		node = node.parent;
		path.AddItem(grid.nodes[node.GetIndex()] );
	}
			
	return path;			
}

private function Array<ISOPathNode> GetConnectedNodes(ISOPathNode node)
{
	local Array<ISOPathNode> pathNodes;
	local Array<ISONode> nodes;
	local ISONode n;


	nodes = zone.GetNeighbors(node, grid);

	foreach nodes(n)
	{
		pathNodes.AddItem(ToPathNode(n));
	}
	return pathNodes;
}

private static function int euclidianHeuristic(ISOPathNode a, ISOPathNode b, optional float cost = 1.0)
{
	local float dx, dy;
	
	dx = a.row - b.row;
	dy = a.col - b.col;
			
	return Sqrt( dx * dx + dy * dy ) * cost;
}

private function ISOPathNode ToPathNode(const out ISONode node, optional int defaultCost=99999)
{
	local ISOPathNode pnode;

	pnode = hash.Get(node.GetIndex());

	if( pnode != none ) return pnode;

	pnode = class'ISOPathNode'.static.Create(node);
	pnode.g = defaultCost;
	hash.Put(pnode.GetIndex(), pnode);

	return pnode;
}


/**
 * Sort by the smallest F
 * (looks like this works like java's 'Comparable'
 * 
 * @return 0 if A==B, < 0 if A < B, > 0 if A > B
 **/
public function int SmallestFSort(ISOPathNode a, ISOPathNode b)
{
	return b.f - a.f;
}


private function Push(ISOPathNode node, out Array<ISOPathNode> list)
{
	list.InsertItem(0, node);
}
private function ISOPathNode Pop(out Array<ISOPathNode> list)
{
	local ISOPathNode node;
	node = list[0];
	list.Remove(0,1);
	return node;
}

private function ISOPathNode PopSmallestF(out Array<ISOPathNode> list)
{
	local ISOPathNode node;
	list.Sort(SmallestFSort);
	node = list[0];
	list.Remove(0,1);
	return node;
}

/**
 * Get the distance between two nodes
 **/
private function int GetCost(ISONode a, ISONode b)
{
	return Abs(VSize(  a.GetCentroid() - b.GetCentroid() ));
}

//reconstruct reverse path from goal to start
//by following parent pointers

DefaultProperties
{
}
