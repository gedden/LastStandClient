class ISOEditorNode extends Actor placeable;


//var() notforconsole string Text;

var DrawBoxComponent drawableBox;


/**
 * Get it!
 * 
 **/
function DrawBoxComponent GetDrawableBoxComponent()
{
	if( drawableBox == None )
	{
		foreach ComponentList(class'DrawBoxComponent', drawableBox) 
		{
			 return drawableBox;
		}
	}

	return drawableBox;
}


DefaultProperties
{
	Begin Object Class=DrawBoxComponent Name=Drawable
	    BoxColor=(R=128,G=128,B=0,A=255)
	    BoxExtent=(X=16.0, Y=16.0, Z=6.0)
		bDrawWireBox=true
		bDrawLitBox=false
		HiddenGame=False

		CollideActors = true;
		AlwaysCheckCollision = true;
		BlockActors = true;
		bSelectable = true;
		//DepthPriorityGroup=SDPG_PostProcess
		DepthPriorityGroup=SDPG_Foreground
	End Object

	/* Kinda slow
	Begin Object Class=DecalComponent Name=DrawableDecal
			HiddenEditor=false
			DecalMaterial=Material'ISOSelection.SelectRed'
			DecalTransform=DecalTransform_OwnerRelative
			Width=16
			Height=16
			bStaticDecal=false
			bMovableDecal=true
			NearPlane=0
			FarPlane=300
			SortOrder=100
			ParentRelativeOrientation=(Roll=0,Yaw=0x0000,Pitch=0xC000)

			bProjectOnBackfaces = false;
			bProjectOnBSP = true;
			bProjectOnSkeletalMeshes = false;
			bProjectOnStaticMeshes = true;
			bProjectOnTerrain = false;
	End Object
	Components.Add(DrawableDecal)
	*/
	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_Actor'
		bIsScreenSizeScaled=false
		ScreenSize=0.1
		U=0
		V=0
		UL=0
		VL=0
		SpriteCategoryName="Misc"
	End Object

	
	//Components.Add(Drawable)
	//CollisionComponent=Col;
	//Components.Add(Col)
	//Components.Add(InitialSkeletalMesh)
	//Components.Add(Sprite)

	bUpdateSimulatedPosition=true
	bCollideActors=true
	bBlockActors=true

	Begin Object Class=CylinderComponent Name=CollisionCylinder
		//CollisionRadius=+0032.000000
		//CollisionHeight=+0032.000000
		BlockNonZeroExtent=true
		BlockZeroExtent=true
		BlockActors=true
		CollideActors=true
		HiddenEditor=false;
	End Object

	bWorldGeometry = true;
	bCollideWorld=true;
	//components.add(Drawable)
	components.add(CollisionCylinder)
	CollisionComponent = CollisionCylinder;
	//components.add(CollisionCylinder)	
}
