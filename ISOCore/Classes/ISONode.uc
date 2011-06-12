class ISONode extends ISOCoreObject;

//var FXNodeDecal newDecal;
const NODE_SIZE = 16.0f;

const NODE_NOTHING  = 0;
const NODE_BLOCKING = 1;
const NODE_CHASIM   = 2;
const NODE_PATH     = 4;

var Vector location;
var Vector centroid;
var int NodeFlags;
var int row;
var int col;
var int height;
var int index;

var ISOUnit unit;


var DecalMaterial   SelectionDecal;
var DecalMaterial   OwnedSelectionDecal;
var DecalMaterial   FriendlySelectionDecal;
var DecalMaterial   NeutralSelectionDecal;
var DecalMaterial   HostileSelectionDecal;

/*********************
 * Set the location for
 * this node
 ********************/
function initialize(NodeData raw, ISOGridController gc)
{
	row         = raw.row;
	col         = raw.col;
	height      = raw.height;

	location.X  = raw.row    * NODE_SIZE;
	location.Y  = raw.col    * NODE_SIZE;
	location   -= gc.gridOrigin;
	location.Z = raw.height * NODE_SIZE;

	NodeFlags = raw.flags;

	//`log("Raw: " @raw.row @raw.col @raw.height @raw.flags);
	//`log("Ori: " @gc.gridOrigin );
	//`log("Loc: " @location );
	//`log("Flg: " @NodeFlags @isChasim() );

	// Set the centroid
	centroid    = location;
	centroid.X += NODE_SIZE/2;
	centroid.Y += NODE_SIZE/2;

	// Setup the index for this node
	index       = gc.grid.GetNodeIndex(row, col);
}

function Vector GetCentroid()
{
	return centroid;
}

static final operator(22) bool   == ( ISONode A, ISONode B )
{
	return A.GetIndex() == B.GetIndex();
}
static final operator(22) bool   != ( ISONode A, ISONode B )
{
	return A.GetIndex() != B.GetIndex();
}

/**
 * Get the unit on this
 * ISO Node
 **/
function ISOUnit GetUnit()
{
	return unit;
}

public function string ToString()
{
	return "{" @ row @ "," @ col @ "}";
}

/**
 * Set the unit on this
 * ISO Node
 **/
function SetUnit(ISOUnit next)
{
	unit = next;
}

function int GetIndex()
{
	return index;
}

/** Flag Check ***********************/
function SetChasim(bool chasim)
{
	NodeFlags = NodeFlags|NODE_CHASIM;
}
function bool isChasim()
{
	return (NodeFlags&NODE_CHASIM) == NODE_CHASIM;
}
function SetBlocking(bool blocking)
{
	NodeFlags = NodeFlags|NODE_BLOCKING;
}
function bool IsBlocking()
{
	return (NodeFlags&NODE_BLOCKING) == NODE_BLOCKING;
}

/** 
 *  Not really needed for the basic implemntation, but its
 *  useful for the map builder
 *  
 **/
function kill()
{
}

function show(ISOHUD hud)
{
	//hud.DrawProjectedBox(location, NODE_SIZE, 0, 255, 255, 255 );


	/*
	local ISOGrid grid;
	local Color c;
	local Vector v;

	c = MakeColor(0, 255, 255, 255 );
	grid = ISOGrid(Outer);
	
	v = location + vect(1,0,0);

	Canvas.SetPos(location.x, location.y, location.z );
	Canvas.DrawBox(10,10);
	*/
	
	//grid.DrawDebugBox( location, vect(20,20,20), 0, 120, 0, TRUE );
	/*
	//local SimpleSelectionDecal newDecal;
	local DecalMaterial myMaterial;

	local ISOGrid grid;

	local DrawBoxComponent box;

	grid = ISOGrid(Outer);
	
	// Set the value of hidden-in-game
	box.SetHidden(false);

	//Canvas = HUD.Canvas;
	//Canvas.DrawBox(
	grid.DrawDebugBox( location, vect(2,2,2), 0, 120, 0, TRUE );
	//DrawDebugBox( OldLoc, vect(2,2,2), 0, 120, 0, TRUE );
	//DrawDebugBox( Pawn.Location, vect(3,3,3), 255, 255, 255, TRUE );
	//DrawDebugLine( Pawn.Location, OldLoc, 255, 255, 255, TRUE );
	//DrawDebugBox(self.Bounds.Origin,DisplayMesh.Bounds.BoxExtent,255,0,0,false);
	//box.HiddenGame = false;
	*/
	
	
	//DrawDebugBox(DisplayMesh.Bounds.Origin,DisplayMesh.Bounds.BoxExtent,255,0,0,false);
	
	/*

	myMaterial = HostileSelectionDecal;

	//TraceActor = Trace(MouseHitWorldLocation, MouseHitWorldNormal, WorldOrigin + WorldDirection * 5000, WorldOrigin, true);
	//TraceActor = Trace(MouseHitWorldLocation, MouseHitWorldNormal, WorldOrigin + WorldDirection * 5000, WorldOrigin, true);

	newDecal = grid.Spawn(class'FXNodeDecal');
	class'DecalManager'.static.SetDecalParameters(newDecal.Decal, myMaterial, location, Rotator(vect(0,0,-1)), NODE_SIZE, NODE_SIZE, 60, true, fRand() * 360, none, true, false, '', INDEX_NONE, INDEX_NONE, INDEX_NONE, class'Decalmanager'.default.DecalDepthBias, class'Decalmanager'.default.DecalBlendRange);
	newDecal.SetRotation(Rotator(vect(0,0,-90)));
	newDecal.SetLocation(location);
	*/
}

DefaultProperties
{
	/*
	OwnedSelectionDecal=DecalMaterial'RTSBasics.SelectionCircle_Owned'
	FriendlySelectionDecal=DecalMaterial'RTSBasics.SelectionCircle_Friendly'
	NeutralSelectionDecal=DecalMaterial'RTSBasics.SelectionCircle_Neutral'
	HostileSelectionDecal=DecalMaterial'RTSBasics.SelectionCircle_Hostile'
	SelectionDecal=DecalMaterial'RTSBasics.SelectionCircle'
*/
}
