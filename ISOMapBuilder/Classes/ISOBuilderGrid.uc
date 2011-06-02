class ISOBuilderGrid extends ISOGrid;

var private bool isSetup;
var ISOEditorNode editor;

var NavMeshBoundsVolume navmesh;
var BrushComponent brushComp;
var Box bounds;
var BoxSphereBounds extent;

var MapZone zone;

var int debugCount;

/**
 * For game, this would just load
 * up from the config file. Instead
 * here this gets the data to be
 * written to the config file.
 **/
function setup()
{
	// Get the row/col info
	ConstructBounds();

	// Register the player starting locations
	ConstructPlayerStarts();

	// Build the nodes
	ConstructNodes();
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

	// Get all the player starts....
    foreach AllActors ( class'PlayerStart', start )
    {
		// Get the node
		node = GetNodeBy3D(start.Location);

		startData.row   = node.row;
		startData.col   = node.col;
		startData.team  = start.GetTeamNum();

		playerStarts.AddItem(startData);
    }
}

/******************************
 * Used by the builder to discover
 * what the rows/cols are. Also
 * founds out what the bounds & extent
 * are
 * 
 *****************************/
function ConstructBounds()
{
	local Vector delta;
	local NavMeshBoundsVolume nav;
	local BrushComponent brushc;
	
	// Get the rows and columns by the define navmesh
    foreach AllActors ( class'NavMeshBoundsVolume', nav )
    {
        navmesh = nav;
    }

	// Get the delta
	foreach navmesh.AllOwnedComponents(class'BrushComponent', brushc )
	{
		brushComp = brushc;
	}
	//brushc.GetComponentsBoundingBox(bounds);
	extent      = brushComp.Bounds;
	bounds.Max  = extent.BoxExtent - extent.Origin;
	bounds.Min  = extent.Origin - extent.BoxExtent;

	//nav.GetComponentsBoundingBox(bounds);
	delta = bounds.Max - bounds.Min;

	rows = delta.X / NODE_SIZE;
	cols = delta.Y / NODE_SIZE;

	// Set the grid origin
	gridOrigin = (delta/2) - navmesh.Location;
	gridOrigin.Z = -64;
}

/******************************
 * Build the nodes from 'scratch'
 * 
 *****************************/
function ConstructNodes()
{
	local int r;
	local int c;
	local int i;
	local int k;
	local NodeData raw;
	local Vector hit;
	local Vector cast;
	local Vector offset;
	local Actor TraceActor;

	local array<Vector> SQUARE;

	// It looks like just doing it on the very center part of each node gives the best results... so....
	//SQUARE[0].X = class'ISONode'.const.NODE_SIZE/2;
	//SQUARE[0].Y = class'ISONode'.const.NODE_SIZE/2;
	//SQUARE[0].Z = 0;
	SQUARE[0] = vect(8,8,0);
	//SQUARE[0] = vect(0,0,0);
	//SQUARE[1] = vect(16,0,0);
	//SQUARE[2] = vect(0,16,0);
	//SQUARE[3] = vect(16,16,0);

	for( r=0;r<rows;r++ )
	{
		for( c=0;c<cols;c++ )
		{
			raw.row = r;
			raw.col = c;
			k       = 0;
			hit     = vect(0,0,0);
			i++;

			nodes[i] = new(self) NodeClass;
			nodes[i].initialize(raw, self);

			// Raycast to get height
			//hit = RaycastHeightAt(nodes[i].location, TraceActor);

			// Multiple raycast
			foreach SQUARE(offset)
			{
				cast = RaycastHeightAt(nodes[i].location + offset, TraceActor);
				if( TraceActor != none )
				{
					// Lets special case for the editor nodes
					//if( ClassIsChildOf(TraceActor.Class, class'ISOEditorNode' ) )
					//{
						if( TraceActor.IsA('ISOChasimArea') )
						{
							hit.Z = -9999;
							k     = 1;
							break;
						}
					//}

					k++;
					hit += cast;
				}
			}
			if( k>0 )
				hit = hit / k;

			// If I cant hit anything at all, I must be a chasim
			if( hit.Z < bounds.Min.Z )
			{
				nodes[i].setChasim(true);
				nodes[i].location.Z = 0;//bounds.Min.Z;
			}
			else
			{
				nodes[i].location.z = hit.Z;
			}

			// Set the height as % 16
			nodes[i].height     = nodes[i].location.z / class'ISONode'.const.NODE_SIZE;
			nodes[i].location.z = nodes[i].height     * class'ISONode'.const.NODE_SIZE;

			nodes[i].centroid   = nodes[i].location;
			nodes[i].centroid.X += class'ISONode'.const.NODE_SIZE/2;
			nodes[i].centroid.Y += class'ISONode'.const.NODE_SIZE/2;

			//raw.height = nodes[i].location.Z;
			raw.height = nodes[i].height;
			data[i] = raw;
		}
	}
}

/**
 * Go from worldspace to gridspace
 **/
function ISONode GetNodeBy3D(Vector loc)
{
	loc += extent.BoxExtent;
	loc -= extent.Origin;

	// Process the offsets
	loc.Y += class'ISONode'.const.NODE_SIZE;

	return GetNode(loc.X / class'ISONode'.const.NODE_SIZE, loc.Y / class'ISONode'.const.NODE_SIZE);
}

/** 
 *  Save the config file
 **/
function SaveMapData()
{
	SaveConfig();
}

function Vector RaycastHeightAt(Vector pos, out Actor TraceActor)
{
	local Vector HitLocation;
	local Vector HitNormal;

	TraceActor = WorldInfo.Trace(HitLocation, HitNormal, pos + vect(0,0,-5000), pos, true);
	return HitLocation;
}

DefaultProperties
{
	NodeClass =class'ISOBuilderNode';
	isSetup = false;
	//C = from + vect(0,1,0)*size;
	//D = from + vect(1,1,0)*size;
		
}