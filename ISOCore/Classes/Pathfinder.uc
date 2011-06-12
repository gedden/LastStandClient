class Pathfinder extends Object;

/**
 * Based on http://theory.stanford.edu/~amitp/GameProgramming/ImplementationNotes.html
 **/
// This class implements A* and related algorithms.  A* works by
// using two estimates from each point: the cost from the start to
// the point (g) and the cost from the point to the goal (h).  As
// we explore we calculate the g values and reach the best
// (lowest) cost from the start to any point. If the heuristic is
// "monotone" then the first time we reach a node we will have
// reached it via the shortest path, so g will be optimal.  If the
// heuristic is "admissible" (and all monotone heuristics are
// admissible) then h will never be greater than the actual cost
// to the goal.  In A*, f is the sum of g and h.  We define OPEN
// to be a "frontier" set of nodes we haven't completely examined
// yet and CLOSED to be a set of nodes that we've already seen.
// In this implementation we have VISITED, the union of OPEN and
// CLOSED, and we also store OPEN, but we do not keep track of
// CLOSED separately.  We repeatedly examine the most promising
// candidate from OPEN (the one with the lowest f score) and put
// in its neighbors.  With a monotone heuristic, f never
// decreases, so all the f values in the OPEN set are in a narrow
// range; OPEN can be thought of as a contour of f values, where
// OPEN is always expanding as the f values are increasing.  When
// h exactly matches the cost of reaching the goal, A* follows
// only that path and no others.

var ISOGrid grid;
var ISONode start;
var ISONode goal;
var MapZone graph;


//public var heuristic:Function;

// A function that takes two adjacent nodes and returns the
// cost of traversing from one to the other. This function
// does not have to be symmetric. Return Infinity if the
// traversal is impossible.
//public var cost:Function;

var float alpha;

//var array< ISOPathNode > visited;
//var HashArea hash;
var HashMapISOPathNode visited;

// The path array stores the final path, once it's found
var array< ISOPathNode > path;
var array< ISOPathNode > open;
public function setup(ISOGrid igrid, MapZone zone, ISONode startingNode, ISONode goalNode)
{
	grid    = igrid;
	graph   = zone;
	start   = startingNode;
	goal    = goalNode;

	initialize();
}

private function initialize()
{
	local ISOPathNode pnode;

	pnode = class'ISOPathNode'.static.Create(start);

	pnode.open  = true;
	pnode.closed= false;
	pnode.g     = 0;                    
	pnode.h     = GetHeuristic(start, goal);
	pnode.f     = (alpha*pnode.g + (1-alpha)*pnode.h)/ FMax(alpha, 1-alpha);

	if( visited == none )
	{
		visited = new class'HashMapISOPathNode';
		visited.setup(graph.nodes.Length);
	}

	Push(pnode, open);
}

public function bool FindPath()
{
	local ISOPathNode best, e;
	local Array<ISONode> peers;
	local ISONode next;
	local int cost, i;

	while (open.length > 0)
	{
		// Find the best node (lowest f). After sorting it
		// will be the last element in the array, and we
		// remove it from OPEN and also update its open flag.
		//open = open.sortOn('f', Array.DESCENDING | Array.NUMERIC);
		open.Sort(SmallestFSort);


		//var best:Object = open.pop();
		//best.open = 0;
		best = Pop(open);
		best.open = false;

		//`log("Open Count: " @open.Length @best.f @best.row @best.col @best.GetIndex() @i );

		// If we find the goal, we're done.
		if (goal.GetIndex() == best.GetIndex() )
		{
			ReconstructPath();
			return true;
		}

		// Add the neighbors of this node to OPEN
		//var next:Object = graph.nodeNeighbors(best.node);
		peers = graph.GetNeighbors(best, grid);

		//for (var j:int = 0; j != next.length; j++)
		foreach peers(next)
		{
			cost = GetCost(best, next);
			// This should never happen because the map zone has already been culled ~ag
			//if (!isFinite(c)) continue; // cannot pass

			// Every node needs to be in VISITED; be sure it's there.
			//var e:Object = visited[graph.nodeToString(next[j])];
			//if (!e)
			e = visited.Get(next.GetIndex());

			//if( !visited.ContainsKey(next.GetIndex()) )
			if( e==none )
			{
				//e = {node: next[j], open: 0, closed: 0, parent: null, g: Infinity, h: 0, f: 0};
				e = class'ISOPathNode'.static.Create(next);

				e.open  = false;
				e.closed= false;
				e.parent= none;
				e.g     = 999999;                    
				e.h     = 0;
				e.f     = 0;

				//visited[graph.nodeToString(next[j])] = e;
				//visited.AddItem(e);
				//hash.Put(e.GetIndex(),visited.Length-1);
				visited.Put(e.GetIndex(),e);

				//`log("Creating new Node for " @next.GetIndex() @next.row @next.col );
			}
			/*
			else
			{
				// Get from the hash table
				//e = visited[hash.Get(e.GetIndex())];
				e = visited.Get(e.GetIndex());
			}
			*/

			// We'll consider this node if the new cost (g) is
			// better than the old cost. The old cost starts
			// at Infinity, so it's always better the first
			// time we see this node.
			if (best.g + cost < e.g)
			{
				if (!e.open)
				{
					e.open = true;
					//open.push(e);
					Push(e, open);
				}
				
				e.g = best.g + cost;
				e.h = GetHeuristic(e, goal);
				e.f = (alpha*e.g + (1-alpha)*e.h)/ FMax(alpha, 1-alpha);
				e.parent = best;
			}
			i++;
		}
	}

	return false;
}


// Reconstruct the path from the goal back to the start
public function ReconstructPath()
{
	local ISOPathNode n;

	//var pathVisited:Object = visited[graph.nodeToString(goal)];
	//n = visited[hash.Get(goal.GetIndex())];
	n = visited.Get(goal.GetIndex());

	while (n!=none && n.GetIndex() != start.GetIndex() )
	{
		//path.push(pathVisited.node);
		path.InsertItem(0, grid.nodes[n.GetIndex()]);
		n = n.parent;
	}
	path.InsertItem(0,start);
}



/**
 * Get the distance between two nodes
 **
private function int GetHeuristic(ISONode a, ISONode b)
{
	return VSize(  a.GetCentroid() - b.GetCentroid() );
}
*/

private static function int GetHeuristic/*euclidianHeuristic*/(ISONode a, ISONode b, optional float cost = 1.0)
{
	local float dx, dy;
	
	dx = a.row - b.row;
	dy = a.col - b.col;
			
	return Sqrt( dx * dx + dy * dy ) * cost;
}

/**
 * Get the distance between two nodes
 **/
private function int GetCost(ISONode a, ISONode b)
{
	return Abs(VSize(  a.GetCentroid() - b.GetCentroid() ));
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


DefaultProperties
{
	// Alpha can be between 0 (BFS) and 1 (Dijkstra's), with 0.5 being A*
	alpha = 0.4999;
}

/*
public function FindPath(ISONode start, ISONode goal, MapZone zone)
{
	local bool bAtGoal;
	local ISOPathNode pnode;

	//create the open list of nodes, initially containing only our starting node
	pnode = class'ISOPathNode'.static.Create(start);
	path.AddItem(pnode);
	
	// create the closed list of nodes, initially empty
	// closed.Add(zone.nodes.Length);

	bAtGoal = false;
	while (!bAtGoal)
	{
       // consider the best node in the open list (the node with the lowest f value)
       if (this node is the goal) {
           then we're done
       }
       else {
           move the current node to the closed list and consider all of its neighbors
           for (each neighbor) {
               if (this neighbor is in the closed list and our current g value is lower) {
                   update the neighbor with the new, lower, g value 
                   change the neighbor's parent to our current node
               }
               else if (this neighbor is in the open list and our current g value is lower) {
                   update the neighbor with the new, lower, g value 
                   change the neighbor's parent to our current node
               }
               else this neighbor is not in either the open or closed list {
                   add the neighbor to the open list and set its g value
               }
           }
       }
   }
}
*/