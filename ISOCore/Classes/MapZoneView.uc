class MapZoneView extends Object;

var private MapZone zone;
var private MapPathZone pzone;
var private GridView view;
var private ISOGridController gc;

public function setup(out ISOGridController gcont)
{
	gc = gcont;
	// Setup the grid view
	view = class'GridView'.static.SpawnView(gc);
	zone = none;

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
	pzone = class'MapPathZone'.static.Create(unit.GetNode(), unit, unit.speed, GetGridController().grid);
}

/**
 * Building the movement view
 **/
public function DrawMapZone(optional Array<ISONode> path)
{
	//local Array<Vector2D>   vb;
	local Array<int>        vb;
	local Array<int>        cb;
	local ISONode           node;
	local float             size;
	local Vector            root;
	local Vector2D          v;
	local Array<ISONode>    nodes;


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

	// Setup the view
	view.SetLocation(root);

	view.SetHidden(false);
	//view.gfx.SetVertexBuffer(vb, cb);
	view.gfx.SetVertexBuffer(vb);
	view.gfx.SetColorBuffer(cb);
	view.gfx.DrawActiveNodes();
}


/**
 * Building the movement view
 **/
public function DrawMapZoneOLD(optional Array<ISONode> path)
{
	//local Array<Vector2D>   vb;
	local Array<int>        vb;
	local Array<int>        cb;
	local ISONode           node;
	local float             size;
	local Vector            root;
	local Vector2D          v;


	if( zone==None ) return;

	root = zone.root.GetCentroid();

	size = class'ISONode'.const.NODE_SIZE/2;

	foreach zone.nodes(node)
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

	// Setup the view
	view.SetLocation(root);

	view.SetHidden(false);
	//view.gfx.SetVertexBuffer(vb, cb);
	view.gfx.SetVertexBuffer(vb);
	view.gfx.SetColorBuffer(cb);
	view.gfx.DrawActiveNodes();
}

/**
 * Building the movement view
 **/
public function UpdateMapZone(const out ISOGrid grid, optional Array<ISONode> path)
{
	local Array<int> cb;
	local Array<ISOPathNode> pnodes;
	local ISOPathNode pnode;
	local ISONode node;
	if( pzone==None ) return;
	
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
	/*
	local Array<int>        cb;
	local ISONode           node;
	if( zone==None ) return;

	foreach zone.nodes(node)
	{		
		if( path.Length > 0 )
		{
			if( path.Find(node) > 0 )
				cb.AddItem(1);
			else
				cb.AddItem(2);
		}
	}
	*/

	view.gfx.SetColorBuffer(cb);
	view.gfx.DrawActiveNodes();
}

public function HideMapZone()
{
	view.SetHidden(true);
}

public function Vector2D WorldspaceToDecalspace(Vector root, Vector world)
{
	local Vector2D v2d;

	local Vector2D h;
	local Vector2D k;

	// ratio of viewport compared to native resolution
	view.gfx.GetVisibleFrameRect(h.x, h.y, k.x, k.y);

	v2d.X = world.X - root.X - (h.X - k.X)/2;
	v2d.Y = world.Y - root.Y - (h.Y - k.Y)/2;

	return v2d;
}


DefaultProperties
{
}
