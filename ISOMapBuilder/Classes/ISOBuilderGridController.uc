class ISOBuilderGridController extends ISOGridController;

var private bool isSetup;
var MapZone zone;
var int debugCount;


/**
 * For game, this would just load
 * up from the config file. Instead
 * here this gets the data to be
 * written to the config file.
 **/
function Setup()
{
	// Create the grid
	grid = new GridClass;

	// Get the row/col info
	ConstructBounds();

	// Build the nodes
	ConstructRawNodes();

	// Register the player starting locations
	ConstructPlayerStarts();

	// Load the data up from the raw nodes
	grid.setup(NodeClass, self);

	//test();
}

/*
function test()
{
	local float h, uh;
	local int k;

	for( h=0;h<32;h+=0.05 )
	{
		k = class'GridUtil'.static.CountNodesInRange(grid.GetNode(30,30), h, grid);
		uh = h * class'ISONode'.const.NODE_SIZE;
		`log("Radial Checksum: " @h @uh @k );
	}
}
*/

/** 
 * Construct the bounds, and get
 * the rows and cols
 **/
function ConstructBounds()
{
	local Vector delta;

	super.ConstructBounds();
	delta = bounds.Max - bounds.Min;

	grid.rows = delta.X / class'ISONode'.const.NODE_SIZE;
	grid.cols = delta.Y / class'ISONode'.const.NODE_SIZE;
}

/**
 * Construct Player Starts
 *
 **/
function ConstructPlayerStarts()
{
	local PlayerStart start;
	local PlayerStartData startData;
	local ISONode node;

	foreach grid.PlayerStarts(startData)
		grid.PlayerStarts.RemoveItem(startData);
	
	// Get all the player starts....
    //foreach AllActors ( class'PlayerStart', start )
	foreach WorldInfo.AllNavigationPoints(class'PlayerStart', start)
    {
		// Get the node
		node = GetWorldspaceToGridspace(start.Location);

		startData.row   = node.row;
		startData.col   = node.col;
		startData.team  = start.GetTeamNum();

		grid.playerStarts.AddItem(startData);
    }
}

/******************************
 * Build the nodes from 'scratch'
 * 
 *****************************/
function ConstructRawNodes()
{
	local int r;
	local int c;
	local int i;
	local NodeData raw;
	local Vector hit;
	local Vector position;
	local Actor TraceActor;
	local ISONode temp;

	local array<Vector> SQUARE;


	SQUARE[0] = vect(8,8,0); // Centroid!

	grid.Data.Remove(0,grid.Data.Length);
	grid.data.Add(grid.Rows*grid.Cols);

	temp = new class'ISOBuilderNode';

	for( r=0;r<grid.rows;r++ )
	{
		for( c=0;c<grid.cols;c++ )
		{
			raw.row     = r;
			raw.col     = c;
			raw.height  = 0;
			raw.flags   = 0;
			hit         = vect(0,0,0);
			i++;

			temp.initialize(raw, self);
			position    = temp.location + SQUARE[0];


			hit = RaycastHeightAt(position, TraceActor);
			if( TraceActor != none )
			{
				// Lets special case for the editor nodes
				if( TraceActor.IsA('ISOChasimArea') )
				{
					hit.Z = bounds.Min.Z - class'ISONode'.const.NODE_SIZE;
				}
			}

			// If I cant hit anything at all, I must be a chasim
			if( TraceActor == None || hit.Z < bounds.Min.Z )
			{
				raw.flags   = raw.flags|class'ISONode'.const.NODE_CHASIM;
				hit.Z       = bounds.Min.Z;
			}
			raw.height = hit.Z / class'ISONode'.const.NODE_SIZE;

			// Finally, set the raw grid information
			grid.data[i] = raw;
		}
	}
}

/** 
 *  Save the config file
 **
function SaveMapData()
{
	SaveConfig();
}
*/

DefaultProperties
{
	NodeClass =class'ISOBuilderNode';
	isSetup = false;		
}