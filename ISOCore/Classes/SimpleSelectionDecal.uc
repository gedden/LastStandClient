class SimpleSelectionDecal extends DecalActorMovable;

var Vector offsetFromOwner;

function Tick(float DeltaTime)
{
	local Rotator DecalRotation;
	if (Owner.bDeleteMe) Destroy();
	DecalRotation = Rotation;

	DecalRotation.Yaw += 6000*DeltaTime;
	//DecalRotation.Pitch += 6000*DeltaTime;
	SetLocation(Owner.Location + offsetFromOwner);
	SetRotation(DecalRotation);
}

DefaultProperties
{
	bNoDelete=FALSE
}
