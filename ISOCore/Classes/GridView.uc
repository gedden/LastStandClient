class GridView extends DecalActorMovable placeable;

var GFxGridView     gfx;

/**
 * Since all 'GridViews' use the same scriped texture, this
 * can only be initiated once
 **/
public static function GridView SpawnView(Actor act)
{
	local GridView view;
	local Rotator rot;

	view = act.Spawn(class'ISOCore.GridView');

	rot = Rotator(vect(0,0,-1));
	
	// Make the grid face the same direction as the rest of the game
	rot.Yaw+=-90*DegToRad*RadToUnrRot;
	view.SetRotation(rot);

	view.gfx = new class'GFxGridView';
	view.gfx.Initialize();

	view.SetHidden(true);

	return view;
}

DefaultProperties
{
	Begin Object Name=NewDecalComponent
		DecalTransform=DecalTransform_OwnerAbsolute
		DecalMaterial=DecalMaterial'ISOPackage.GridView.ProjectedArea'
		bStaticDecal=FALSE
		Width=1024;
		Height=1024;
		//Orientation=(Pitch=-16384,Yaw=0,Roll=0)
	End Object
	Decal=NewDecalComponent

	bNoDelete=FALSE
}
