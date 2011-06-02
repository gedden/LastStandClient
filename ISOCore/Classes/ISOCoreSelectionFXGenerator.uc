class ISOCoreSelectionFXGenerator extends ISOCoreFXGenerator;

var DecalMaterial   SelectionDecal;
var DecalMaterial   OwnedSelectionDecal;
var DecalMaterial   FriendlySelectionDecal;
var DecalMaterial   NeutralSelectionDecal;
var DecalMaterial   HostileSelectionDecal;

static function Actor generateEffect(Actor requestingActor, int size, int effectNumber) {
	local Vector groundLocation;
	local Vector groundNormal;
	local SimpleSelectionDecal newDecal;
	local DecalMaterial myMaterial;

	switch (effectNumber) {
		case 0: myMaterial = default.NeutralSelectionDecal;
		break;
		case 1: myMaterial = default.OwnedSelectionDecal;
		break;
		case 2: myMaterial = default.HostileSelectionDecal;
		break;
		case 3: myMaterial = default.FriendlySelectionDecal;
		break;
		default: myMaterial = default.SelectionDecal;
	}
	requestingActor.Trace(groundLocation, groundNormal, requestingActor.Location + vect(0,0,-500), requestingActor.Location + vect(0,0,400), true);
	`Log(groundNormal);
	newDecal = requestingActor.spawn(class'SimpleSelectionDecal', requestingActor, ,requestingActor.Location, Rotator(vect(0,0,-1)));
	class'DecalManager'.static.SetDecalParameters(newDecal.Decal, myMaterial, requestingActor.Location, Rotator(vect(0,0,-1)), size, size, 60, true, fRand() * 360, none, true, false, '', INDEX_NONE, INDEX_NONE, INDEX_NONE, class'Decalmanager'.default.DecalDepthBias, class'Decalmanager'.default.DecalBlendRange);
	newDecal.offsetFromOwner = groundLocation-requestingActor.Location+vect(0,0,-10);

	`log("Created Selection @ " $newDecal.Location );
	return newDecal;
}

DefaultProperties
{
	OwnedSelectionDecal     =   DecalMaterial'ISOSelection.SelectRed'
	FriendlySelectionDecal  =   DecalMaterial'ISOSelection.SelectWhite'
	NeutralSelectionDecal   =   DecalMaterial'ISOSelection.SelectWhite'
	HostileSelectionDecal   =   DecalMaterial'ISOSelection.SelectRed'
	SelectionDecal          =   DecalMaterial'ISOSelection.SelectWhite'
}

