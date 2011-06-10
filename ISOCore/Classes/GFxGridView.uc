class GFxGridView extends GFxMoviePlayer;

function Initialize()
{	
	Start();
	Advance(0.0f);
}

function SetVertexBuffer(Array<Vector2D> verts, Array<int> colorIndices)
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