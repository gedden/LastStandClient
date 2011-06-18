class GridPreview extends DecalActorMovable placeable;

var() name CanvasTextureParamName;
var name BlurRadiusName;

var MaterialInstanceConstant ConsoleMaterial;
var ScriptedTexture CanvasTexture;
var() LinearColor ClearColor;
var Color OtherColor;
var Color WhiteColor;

var Color PathColor;
var Color BoxColor;

var string ConsoleText;
var Vector2D Pos;

// Good production blur?
//const TEXTURE_SIZE=64;
const TEXTURE_SIZE=1024;
const DECAL_SIZE  =1024;



var private MapPathZone pzone;
var private Array<ISONode> path;

function PostBeginPlay()
{
	super.PostBeginPlay();

	CanvasTexture = ScriptedTexture(class'ScriptedTexture'.static.Create(TEXTURE_SIZE, TEXTURE_SIZE,, ClearColor));
	CanvasTexture.Render = OnRender;

	// Create a new MaterialInstanceConstant
	ConsoleMaterial = new(self) class'MaterialInstanceConstant';

	ConsoleMaterial.SetParent(Decal.GetDecalMaterial());
	Decal.SetDecalMaterial(ConsoleMaterial);
	Decal.Width = DECAL_SIZE;
	Decal.Height = DECAL_SIZE;

	ConsoleMaterial.SetTextureParameterValue(CanvasTextureParamName, CanvasTexture);
	// Good Production Blur?
	//ConsoleMaterial.SetScalarParameterValue(BlurRadiusName, 0.03);
	ConsoleMaterial.SetScalarParameterValue(BlurRadiusName, 0.00);

	// Set the canvas texture to require at least one render update
	CanvasTexture.bNeedsUpdate = true;
}

/**
 * Set the map path zone
 **/
function SetUpdateZone(const out MapPathZone pzoneIn)
{
	SetHidden(false);
	pzone = pzoneIn;
	CanvasTexture.bNeedsUpdate = true;
}

/**
 * Set the map path zone
 **/
function ShowPath(const out Array<ISONode> pathIn)
{
	path = pathIn;
	CanvasTexture.bNeedsUpdate = true;
}

/**
 * Set the map path zone
 **/
function Hide()
{
	// respect your elders!
	SetHidden(true);

	if( pzone != none )
	{
		// Clear the array
		path.Remove(0, path.Length);
		pzone = none;
		
		CanvasTexture.bNeedsUpdate = true;
	}
}

function OnRender(Canvas canvas)
{
	local Vector         root;
	local Vector         current;
	local Array<ISOPathNode> nodes;
	local ISOPathNode        node;
	local float          ratio;
	local float          nodeSize;


	ratio = TEXTURE_SIZE / DECAL_SIZE;

	nodeSize = class'ISONode'.const.NODE_SIZE * ratio;

	/*
	canvas.SetOrigin(0,0);
	canvas.SetDrawColorStruct(OtherColor);
	canvas.DrawRect(SIZE, SIZE);
	*/

	// Sanity check!
	if( pzone == none ) return;

	// Get the root
	root = pzone.root.GetCentroid();

	// Since this a decal projection, I can ignore depth
	canvas.SetOrigin(0,0);
	canvas.SetDrawColorStruct(BoxColor);


	// Draw all the rectangs
	nodes = pzone.GetNodes();

	foreach nodes(node)
	{
		// Not all nodes in a movement zone are pathable (I can occupy spaces I cant walk to)
		if( !node.IsPathableNode() ) continue;

		if( IsInPath(node) )
		{
			canvas.SetDrawColorStruct(PathColor);
		}
		else
		{
			canvas.SetDrawColorStruct(BoxColor);
		}

		current = node.GetCentroid() - root;
		current.X += DECAL_SIZE/2;
		current.Y += DECAL_SIZE/2;
		canvas.SetPos(current.X * ratio,current.Y * ratio);
		canvas.DrawRect(nodeSize, nodeSize);
	}
}


/**
 * This a relatively CPU intensive operation,
 * but its not done 'that often', so it should be ok ~ag
 **/
private function bool IsInPath(ISONode node)
{
	local ISONode n;
	if( path.Length == 0 ) return false;

	
	foreach path(n)
	{
		//`log("looking for "@node.GetIndex() @" vs " @n.GetIndex() @" = " @(node==n) );
		if( n.GetIndex() == node.GetIndex() ) return true;
	}
	return false;
}

defaultproperties
{
	ClearColor=(R=0.0,G=0.0,B=0.0,A=0.0)
	WhiteColor=(R=255,G=255,B=255,A=255)
	BoxColor=(R=0,G=128,B=128,A=255)
	PathColor=(R=128,G=0,B=128,A=255)
	OtherColor=(R=128,G=0,B=128,A=255)
	CanvasTextureParamName  = "CanvasTexture"
	BlurRadiusName          = "BlurRange"

	Begin Object Name=NewDecalComponent
		//DecalMaterial  =   DecalMaterial'ISOPackage.GridPreview.ScriptedDecalMaterial'
		DecalMaterial  =   DecalMaterial'ISOPackage.GridPreview.ScriptedDecalMaterial8Blur'
	End Object

	bNoDelete=FALSE
}