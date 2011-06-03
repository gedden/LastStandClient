/**
 * Controls the grid
 * 
 * The ISOGridController should understand world space, where the ISOGrid should only 
 * understand gridspace
 **/
class ISOGridController extends Actor;

var ISOGrid grid;
var BrushComponent brushComp;
var Box bounds;
var BoxSphereBounds extent;
var Vector gridOrigin;

var	class<ISOGrid> GridClass;
var	class<ISONode> NodeClass;

/**
 * Setup the grid
 **/
function Setup()
{
	// Construct the grid bounds
	ConstructBounds();

	// Create the grid
	grid = new (none, GetMapName()) GridClass;
	grid.setup(NodeClass, self);	
}

function String GetMapName()
{
	return WorldInfo.GetMapName();
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
	local NavMeshBoundsVolume navmesh;
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

	//rows = delta.X / NODE_SIZE;
	//cols = delta.Y / NODE_SIZE;

	// Set the grid origin
	gridOrigin = (delta/2) - navmesh.Location;
	//gridOrigin.Z = -64;
}


/**
 * Go from worldspace to gridspace
 **/
function ISONode GetWorldspaceToGridspace(Vector loc)
{
	loc += extent.BoxExtent;
	loc -= extent.Origin;

	// Process the offsets
	//loc.Y += class'ISONode'.const.NODE_SIZE;

	return grid.GetNode(loc.X / class'ISONode'.const.NODE_SIZE, loc.Y / class'ISONode'.const.NODE_SIZE);
}

function Vector RaycastHeightAt(Vector pos, out Actor TraceActor)
{
	local Vector HitLocation;
	local Vector HitNormal;

	//TraceActor = WorldInfo.Trace(HitLocation, HitNormal, pos - vect(0,0,5000), pos, true);
	TraceActor = WorldInfo.Trace(HitLocation, HitNormal, pos, pos + vect(0,0,5000), true);
	return HitLocation;
}

/**
 * Get the centroid for a node that may or may not
 * actually exist
 **/
function Vector GetVirtualCentroid(int row, int col, int height)
{
	local Vector centroid;
	centroid.X  = (row * class'ISONode'.const.NODE_SIZE);
	centroid.Y  = (col * class'ISONode'.const.NODE_SIZE);
	centroid    -= gridOrigin;
	centroid.Z  = height * class'ISONode'.const.NODE_SIZE;

	// Set the centroid
	centroid.X += class'ISONode'.const.NODE_SIZE/2;
	centroid.Y += class'ISONode'.const.NODE_SIZE/2;

	return centroid;
}

DefaultProperties
{
	GridClass   = class'ISOCore.ISOGrid'
	NodeClass   = class'ISONode';
}
