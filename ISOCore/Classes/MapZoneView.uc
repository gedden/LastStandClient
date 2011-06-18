class MapZoneView extends Object;

var private MapZone zone;
var private MapPathZone pzone;
var private GridView view;
var private GridPreview preview;
var private ISOGridController gc;
var private Vector2D rect;

public function setup(out ISOGridController gcont)
{
	local Vector2D h;
	local Vector2D k;
	local Rotator rot;

	gc = gcont;
	// Setup the grid view
	view = class'GridView'.static.SpawnView(gc);
	zone = none;

	// ratio of viewport compared to native resolution
	if( view != none )
	{
		view.gfx.GetVisibleFrameRect(h.x, h.y, k.x, k.y);
		rect.X = h.X - k.X;
		rect.Y = h.Y - k.Y;
	}
	else
	{
		rect.X = 500;
		rect.Y = 500;
	}

	// Spawn the new version
	preview = gc.Spawn(class'GridPreview');
	`log("Spawning the preview....." @preview);
	rot     = Rotator(vect(0,0,-1));
	// Make the grid face the same direction as the rest of the game
	rot.Yaw+=-90*DegToRad*RadToUnrRot;
	preview.SetRotation(rot);
}

/**
 * Get the current map zone
 **/
public function MapPathZone GetPathZone()
{
	return pzone;
}

/**
 * Get the current map zone
 **/
public function MapZone GetZone()
{
	return zone;
}

/**
 * Simple private accessor method
 **/
private function ISOGridController GetGridController()
{
	return gc;
}

/**
 * Building the movement view
 **/
function BuildMovementView(ISOUnit unit)
{
	// Cant build a movement zone for nothing!
	if( unit == none ) return;
		
	// Build the map zone

	//zone = class'MapZone'.static.Create(unit.GetNode(), unit.speed, GetGridController().grid, unit);
	pzone = class'MapPathZone'.static.Create(unit.GetNode(), unit, unit.GetSpeed(), GetGridController().grid);
}

/**
 * Building the movement view
 **/
public function DrawMapZone(optional Array<ISONode> path)
{
	local Vector root;


	`log("Showing the preview!" @pzone);
	if( pzone==None ) return;
	root = pzone.root.GetCentroid();

	root.Z += 64;
	preview.SetLocation(root);
	preview.SetUpdateZone(pzone);
	
	/*
	//local Array<Vector2D>   vb;
	local Array<int>        vb;
	local Array<int>        cb;
	local ISONode           node;
	local float             size;
	local Vector            root;
	local Vector2D          v;
	local Array<ISONode>    nodes;

	//if( view == none ) return;
	if( pzone==None ) return;

	root = pzone.root.GetCentroid();

	size = class'ISONode'.const.NODE_SIZE/2;

	nodes = pzone.GetNodes();
	`log("#NODE COUNT" @nodes.length );
	//pzone.nodes.toLog();
	
	
	foreach nodes(node)
	{
		v = WorldspaceToDecalspace(root, node.GetCentroid() + vect(-1, 1,0)*size);
		vb.AddItem(v.X);
		vb.AddItem(v.Y);

		v = WorldspaceToDecalspace(root, node.GetCentroid() + vect( 1, 1,0)*size);
		vb.AddItem(v.X);
		vb.AddItem(v.Y);
		
		v = WorldspaceToDecalspace(root, node.GetCentroid() + vect( 1,-1,0)*size);
		vb.AddItem(v.X);
		vb.AddItem(v.Y);

		v = WorldspaceToDecalspace(root, node.GetCentroid() + vect(-1,-1,0)*size);
		vb.AddItem(v.X);
		vb.AddItem(v.Y);

		//vb.AddItem(WorldspaceToDecalspace(root, node.GetCentroid() + vect(-1, 1,0)*size) );
		//vb.AddItem(WorldspaceToDecalspace(root, node.GetCentroid() + vect( 1, 1,0)*size) );
		//vb.AddItem(WorldspaceToDecalspace(root, node.GetCentroid() + vect( 1,-1,0)*size) );
		//vb.AddItem(WorldspaceToDecalspace(root, node.GetCentroid() + vect(-1,-1,0)*size) );

		
		if( path.Length > 0 )
		{
			if( path.Find(node) > 0 )
				cb.AddItem(1);
			else
				cb.AddItem(2);
		}
	}

	root.Z += 64;
	if( view == none ) return;
	// Setup the view
	view.SetLocation(root);

	view.SetHidden(false);
	//view.gfx.SetVertexBuffer(vb, cb);
	view.gfx.SetVertexBuffer(vb);
	view.gfx.SetColorBuffer(cb);
	view.gfx.DrawActiveNodes();
	*/
}



/**
 * Building the movement view
 **/
public function UpdateMapZone(const out ISOGrid grid, optional Array<ISONode> path)
{
	preview.ShowPath(path);
	/*
	local Array<int> cb;
	local Array<ISOPathNode> pnodes;
	local ISOPathNode pnode;
	local ISONode node;

	if( pzone==None ) return;
	if( view == none ) return;
	pnodes = pzone.GetNodes();

	foreach pnodes(pnode)
	{		
		// Get the path node
		node = grid.nodes[pnode.GetIndex()];

		if( path.Find(node) == INDEX_NONE )
			cb.AddItem(1);
		else
			cb.AddItem(2);
	}

	view.gfx.SetColorBuffer(cb);
	view.gfx.DrawActiveNodes();
	*/
}

public function HideMapZone()
{
	view.SetHidden(true);
	preview.Hide();
}

public function Vector2D WorldspaceToDecalspace(Vector root, Vector world)
{
	local Vector2D v2d;

	v2d.X = world.X - root.X - (rect.X)/2;
	v2d.Y = world.Y - root.Y - (rect.Y)/2;

	return v2d;
}


DefaultProperties
{
}
