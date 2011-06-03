//class ISOGrid extends DecalManager;
class ISOGrid extends Object config(MapData) perobjectconfig;

struct PlayerStartData
{
	var int row;
	var int col;
	var int team;
};

var array<ISONode> nodes;
var ISOGridController gc;

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
function setup(class<ISONode> NodeClass, ISOGridController controller)
{
	local int r;
	local int c;
	local int i;

	for( r=0;r<rows;r++ )
	{
		for( c=0;c<cols;c++ )
		{
			nodes[i] = new(self) NodeClass;
			nodes[i].initialize(data[i], controller );
			i++;
		}
	}
	gc = controller;
}

function ISOGridController GetController()
{
	return gc;
}

function ISONode GetNode(int r, int c)
{
	return nodes[GetNodeIndex(r,c)];
}

function int GetNodeIndex(int r, int c)
{
	return (r*cols)+(c+1);
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

/** 
 *  Save the config file
 **/
function SaveMapData()
{
	`Log("Saving Config");
	SaveConfig();
}

DefaultProperties
{
}
