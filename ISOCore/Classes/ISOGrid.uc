//class ISOGrid extends DecalManager;
class ISOGrid extends Actor config(ISOMapBuilder) perobjectconfig;

struct PlayerStartData
{
	var int row;
	var int col;
	var int team;
};

var	class<ISONode> NodeClass;
var array<ISONode> nodes;

var Vector gridOrigin;

const NODE_SIZE = 16.0f;

// The following variables are loaded by the configuration file
var config int Rows;
var config int Cols;
var config array<NodeData> Data;
var config array<PlayerStartData> PlayerStarts;

/******************************
 * Construct the nodes from the 
 * defined node data
 * 
 *****************************/
function setup()
{
	local int r;
	local int c;
	local int i;

	for( r=0;r<rows;r++ )
	{
		for( c=0;c<cols;c++ )
		{
			i++;
			nodes[i] = new(self) NodeClass;
			nodes[i].initialize(data[i], self);
		}
	}
}

function ISONode GetNode(int r, int c)
{
	return nodes[GetNodeIndex(r,c)];
}

function int GetNodeIndex(int r, int c)
{
	return (r*cols)+c;
}

function showNodes(ISOHUD hud)
{
	local ISONode node;

	foreach nodes(node)
	{
		node.show(hud);
	}
}

/****************************
 * Simple accessors
 * 
 ***************************/
function int getRows()
{
	return rows;
}

function int getCols()
{
	return rows;
}

DefaultProperties
{
	NodeClass   = class'ISONode';
}
