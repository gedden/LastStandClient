class ISOFogHUD extends ISOHUD;

var ScriptedTexture					    STMask;
var int                                 MaskSightRadiusDeathPawn; //Sight radius for death pawn to draw in fog mask
var int                                 MaskSightModulation; // Additional pixels to make gradient fog from light to dark area
var Texture2D                           CircleTex;
var FogVolumeDensityInfo fi;

var vector2D MiniMapSize;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	CreateFogMask();
}

event PostRender()
{
	super.PostRender();
	DrawFogMaskUpdate();
}

function CreateFogMask()
{
	STMask = ScriptedTexture(class'ScriptedTexture'.static.Create(MiniMapSize.X, MiniMapSize.Y,, MakeLinearColor(0, 0, 0, 255), false));
	STMask.Render = FogMaskRender;
}

function FogMaskRender(Canvas aCanvas)
{
	local vector2D lUnitLocation;
	local ISOUnit Unit;
	local int lMaskSightRadius;

	foreach WorldInfo.AllActors( class 'ISOUnit', Unit )
	{
			// Reset Unit Pos to 0;
		lUnitLocation.X = 0;
		lUnitLocation.Y = 0;

		//lMaskSightRadius = Convert_SightRadius_Size_Map_To_MiniMap(Unit.SightRadius);
		lMaskSightRadius = 10;
	
		//lUnitLocation = Convert_Size_Map_To_MiniMap(Unit.Location, lMaskSightRadius);
		lUnitLocation = vect2d(10,10);

		aCanvas.SetDrawColor(255,0,0,255);
		aCanvas.SetPos(lUnitLocation.X, lUnitLocation.Y);

		//if (Unit.bIsDied) aCanvas.DrawTile(CircleTex, MaskSightRadiusDeathPawn, MaskSightRadiusDeathPawn, 0, 0, 64, 64, ,,BLEND_Additive);
		// else aCanvas.DrawTile(CircleTex, lMaskSightRadius, lMaskSightRadius, 0, 0, 64, 64,,,BLEND_Additive);
		aCanvas.DrawTile(CircleTex, lMaskSightRadius, lMaskSightRadius, 0, 0, 64, 64,,,BLEND_Additive);
	}
	//xT_GameInfo(WorldInfo.Game).LevelManager.UpdateFog(STMask);
	STMask.bNeedsUpdate = true;
	STMask.bSkipNextClear = true;
}
/*
function int Convert_SightRadius_Size_Map_To_MiniMap(float aSightRadius)
{
	local int lSightRadius;
	lSightRadius = (((aSightRadius / MapSize.X) * MiniMapSize.X) + ((aSightRadius / MapSize.Y) * MiniMapSize.Y))/2; 
	return lSightRadius;
}
*/

function DrawFogMaskUpdate()
{
	Canvas.SetPos(Canvas.ClipX-MiniMapSize.X, Canvas.ClipY-MiniMapSize.Y);
	Canvas.DrawTexture(STMask, 1.0);
}

DefaultProperties
{
	//MiniMapSize = (100,100);
	
}
