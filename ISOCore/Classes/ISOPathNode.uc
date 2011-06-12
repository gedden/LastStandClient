class ISOPathNode extends ISONode;

var bool open;
var bool closed;
var int valid;
var ISOPathNode parent;

var float g; // The exact cost to reach this node from the starting node. 
var float h; // the estimated(heuristic) cost to reach the destination from here. 
var float f; // As the algorithm runs the F value of a node tells us how expensive we think it will be to reach our goal by way of that node. 
var bool travesable;

public static function ISOPathNode Create(ISONode node)
{
	local ISOPathNode pnode;

	pnode = new class'ISOPathNode';
	pnode.Build(node);

	return pnode;
}

function Build(ISONode node)
{
	row = node.row;
	col = node.col;
	index = node.index;
	centroid = node.GetCentroid();
}

DefaultProperties
{
	open    = false;
	closed  = false;
	parent  = none;
	travesable = false;
}
