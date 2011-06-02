class ISOBuilderNode extends ISONode;

var ISOEditorNode editorNode;

var Color wireColor;

function SetChasim(bool chasim)
{
	super.SetChasim(chasim);
}

function Color GetColor()
{
	if( isChasim() )
		return MakeColor(255,255,0,255);
	return MakeColor(0,255,0,255);
}

DefaultProperties
{
}
