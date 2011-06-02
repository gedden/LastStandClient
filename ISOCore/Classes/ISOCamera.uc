class ISOCamera extends Camera;

var int TargetFreeCamDistance;
var int zoomPerSecond;
var int zoomAmmout;
var int maxZoom;
var int minZoom;

/**
 * Adjust the *desired* camera distance
**/
function zoomIn() {
	TargetFreeCamDistance = FMax(TargetFreeCamDistance - zoomAmmout, minZoom);
}
function zoomOut() {
	TargetFreeCamDistance = FMin(TargetFreeCamDistance + zoomAmmout, maxZoom);
}

function correctZoom(float dt) {
	if (TargetFreeCamDistance < FreeCamDistance) {
		FreeCamDistance = FMax(FreeCamDistance - dt * zoomPerSecond, TargetFreeCamDistance);
	} else {
		FreeCamDistance = FMin(FreeCamDistance + dt * zoomPerSecond, TargetFreeCamDistance);
	}
}

/**
 * Calculates the new zooming distance give zooming speed, desired zoom etc.
 * Then sets the camera zooming distance behind the player and facing the 
 * same direction as the player
**/
function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime)
{
	correctZoom(DeltaTime);
	OutVT.POV.FOV = DefaultFOV;
	OutVT.POV.Location = PCOwner.Location - Vector(PCOwner.Rotation) * FreeCamDistance;
	OutVT.POV.Rotation = PCOwner.Rotation;
	
	ApplyCameraModifiers(DeltaTime, OutVT.POV);
}

defaultproperties
{
	DefaultFOV=90.f
	TargetFreeCamDistance=256
	zoomPerSecond=256
	zoomAmmout=32
	maxZoom=9000
	minZoom=32
}