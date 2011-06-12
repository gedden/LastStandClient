class GFxGridView extends GFxMoviePlayer;

function Initialize()
{	
	Start();
	Advance(0.0f);
}

/*
function SetVertexBuffer(const out Array<Vector2D> verts, const out Array<int> colorIndices)
{
	local array<int> vb;
	local Vector2D v;

	foreach verts(v)
	{
		vb.AddItem(v.x);
		vb.AddItem(v.y);
	}
	SetVariableNumber("grid.indices",vb.Length);
	SetVariableIntArray("grid.vb",0, vb);
	SetVariableIntArray("grid.cb",0, colorIndices);	
}
*/

/**
 * Set the vertex buffer
 **/
function SetVertexBuffer(const out Array<int> vb)
{
	SetVariableNumber("grid.indices",vb.Length);
	SetVariableIntArray("grid.vb",0, vb);
}

/**
 * Set the index buffer
 **/
function SetColorBuffer(const out Array<int> colorIndices)
{
	SetVariableIntArray("grid.cb",0, colorIndices);	
}

function DrawActiveNodes()
{
	ActionScriptVoid("DrawActiveNodes");
}
function HideActiveNodes()
{
	ActionScriptVoid("HideActiveNodes");
}

DefaultProperties
{
	bDisplayWithHudOff=FALSE
	bEnableGammaCorrection=FALSE

	// Path to your package/flash file here.
	MovieInfo           = SwfMovie'ISOPackage.GradientCircle'
	RenderTexture       = TextureRenderTarget2D'ISOPackage.GradientCircleRenderTexture'
	RenderTextureMode   = RTM_AlphaComposite;
}