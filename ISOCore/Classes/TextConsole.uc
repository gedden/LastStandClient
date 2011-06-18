class TextConsole extends Actor placeable;

var() int ConsoleMaterialIndex;
var() MaterialInterface ConsoleMaterialTemplate;
var() name CanvasTextureParamName;

var MaterialInstanceConstant ConsoleMaterial;
var ScriptedTexture CanvasTexture;
var() float ScrollAmount;
var() float TextScale;
var() LinearColor ClearColor;
var() Color TextColor;
var() Color RedColor;

var string ConsoleText;
var Vector2D Pos;

var() editinline const StaticMeshComponent Mesh;

function PostBeginPlay()
{
   super.PostBeginPlay();
   
   CanvasTexture = ScriptedTexture(class'ScriptedTexture'.static.Create(1024, 1024,, ClearColor));
   CanvasTexture.Render = OnRender;

   if(ConsoleMaterialTemplate != none)
   {
      ConsoleMaterial = Mesh.CreateAndSetMaterialInstanceConstant(ConsoleMaterialIndex);
      if(ConsoleMaterial != none)
      {
         ConsoleMaterial.SetParent(ConsoleMaterialTemplate);
   
         if(CanvasTextureParamName != '')
         {
            ConsoleMaterial.SetTextureParameterValue(CanvasTextureParamName, CanvasTexture);
         }
      }
   }
   
   SetConsoleText("Console Display Text");
   Pos.X = CanvasTexture.SizeX;
}

function SetConsoleText(string text)
{
   ConsoleText = text;
}

function OnRender(Canvas C)
{
   local Vector2D TextSize;

   C.TextSize(ConsoleText, TextSize.X, TextSize.Y);
   TextSize *= TextScale;
   Pos.Y = (CanvasTexture.SizeY / 2) - (TextSize.Y / 2);
   Pos.X = CanvasTexture.SizeX / 2;//WorldInfo.DeltaSeconds * ScrollAmount;
   if(Pos.X < -TextSize.X)
   {
      Pos.X = CanvasTexture.SizeX;
   }

   C.SetOrigin(0,0);
   C.SetClip(CanvasTexture.SizeX + TextSize.X, CanvasTexture.SizeY + TextSize.Y);
   C.SetPos(Pos.X, Pos.Y);

   C.SetDrawColorStruct(TextColor);

   C.DrawText(ConsoleText,, TextScale, TextScale);

   C.SetDrawColorStruct(RedColor);
   C.DrawRect(50, 50);

   //CanvasTexture.bNeedsUpdate = true;
}

defaultproperties
{
   ClearColor=(R=0.0,G=0.0,B=0.0,A=0.0)
   TextColor=(R=255,G=255,B=255,A=255)
   RedColor=(R=255,G=0,B=0,A=255)
   ScrollAmount=150.0
   TextScale=1.0

   Begin Object class=StaticMeshComponent Name=StaticMeshComp1
      StaticMesh=StaticMesh'dwStaticMeshes.Plane'
   End Object

   Mesh = StaticMeshComp1
   Components.Add(StaticMeshComp1)
}