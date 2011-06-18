class ISOCorePlayerInput extends PlayerInput within ISOCorePlayerController;

var float x;
var float y;

var bool mLeft;
var bool mRight;

var float DELETEME;

function bool InputAxis( int ControllerId, name Key, float Delta, float DeltaTime, optional bool bGamepad )
{
	x = Delta;
	/*
	switch(Key)
	{
	case 'MouseX':
		ISOHUD(Outer.myHUD).moveMouseX(Delta);
		x = Delta;
		break;
	case 'MouseY':
		ISOHUD(Outer.myHUD).moveMouseY(-Delta);
		//Outer.mouseDragged = true;
		y = -Delta;
		break;
	}
	*/
	/*
	switch(Key)
	{
	case 'MouseX':
		RTSHUD(Outer.myHUD).moveMouseX(Delta);
		Outer.mouseDragged = true;
		break;
	case 'MouseY':
		RTSHUD(Outer.myHUD).moveMouseY(-Delta);
		Outer.mouseDragged = true;
		break;
	}
	*/
	return false;
}


simulated exec function ZoomIn()
{
	ISOCamera(PlayerCamera).zoomIn();
}

simulated exec function ZoomOut()
{
	ISOCamera(PlayerCamera).zoomOut();
}

simulated exec function LeftMousePressed()
{
	mLeft = true;
}

simulated exec function LeftMouseReleased()
{
	mLeft = false;
	// I decided to have all the mouse clicks come from the HUD,
	// because I wanted some of the UI action to be occluded by
	// the HUD itself ~ag
	//
	//Outer.onClick();
}

simulated exec function RightMousePressed()
{
	mRight = true;
}

simulated exec function RightMouseReleased()
{
	mRight = false;
}

// Postprocess the player's input.
event PlayerInput( float DeltaTime )
{
	local float FOVScale, TimeScale;

	// Save Raw values
	RawJoyUp		= aBaseY;
	RawJoyRight		= aStrafe;
	RawJoyLookRight	= aTurn;
	RawJoyLookUp	= aLookUp;

	// PlayerInput shouldn't take timedilation into account
	DeltaTime /= WorldInfo.TimeDilation;
	if (Outer.bDemoOwner && WorldInfo.NetMode == NM_Client)
	{
		DeltaTime /= WorldInfo.DemoPlayTimeDilation;
	}

	PreProcessInput( DeltaTime );

	// Scale to game speed
	TimeScale = 100.f*DeltaTime;

	aBaseY		*= TimeScale * MoveForwardSpeed;
	aStrafe		*= TimeScale * MoveStrafeSpeed;
	aUp			*= TimeScale * MoveStrafeSpeed;
	aTurn		*= TimeScale * LookRightScale;
	aLookUp		*= TimeScale * LookUpScale;

	PostProcessInput( DeltaTime );

	ProcessInputMatching(DeltaTime);

	// Check for Double click movement.
	CatchDoubleClickInput();

	// Take FOV into account (lower FOV == less sensitivity).

	if ( bEnableFOVScaling )
	{
		FOVScale = GetFOVAngle() * 0.01111; // 0.01111 = 1 / 90.0
	}
	else
	{
		FOVScale = 1.0;
	}

	AdjustMouseSensitivity(FOVScale);

	// If this is not removed from the input ini, then it gets factored in. It should not
	// TODO: Remove references completely
	aMouseX = 0;
	aMouseY = 0;

	// mouse smoothing
	if ( bEnableMouseSmoothing )
	{
		aMouseX = SmoothMouse(aMouseX, DeltaTime,bXAxis,0);
		aMouseY = SmoothMouse(aMouseY, DeltaTime,bYAxis,1);
	}

	aLookUp			*= FOVScale;
	aTurn			*= FOVScale;

	// Turning and strafing share the same axis.
	if( bStrafe > 0 )
		aStrafe		+= aBaseX + aMouseX;
	else
		aTurn		+= aBaseX + aMouseX;

	// Look up/down.
	aLookup += aMouseY;
	if (bInvertMouse)
	{
		aLookup *= -1.f;
	}

	if (bInvertTurn)
	{
		aTurn *= -1.f;
	}

	// Forward/ backward movement
	aForward		+= aBaseY;

	// Handle walking.
	HandleWalking();

	// check for turn locking
	if (bLockTurnUntilRelease)
	{
		if (RawJoyLookRight != 0)
		{
			aTurn = 0.f;
			if (AutoUnlockTurnTime > 0.f)
			{
				AutoUnlockTurnTime -= DeltaTime;
				if (AutoUnlockTurnTime < 0.f)
				{
					bLockTurnUntilRelease = FALSE;
				}
			}
		}
		else
		{
			bLockTurnUntilRelease = FALSE;
		}
	}

	// ignore move input
	// Do not clear RawJoy flags, as we still want to be able to read input.
	if( IsMoveInputIgnored() )
	{
		aForward	= 0.f;
		aStrafe		= 0.f;
		aUp			= 0.f;
	}

	// ignore look input
	// Do not clear RawJoy flags, as we still want to be able to read input.
	if( IsLookInputIgnored() )
	{
		aTurn		= 0.f;
		aLookup		= 0.f;
	}

	//aForward = 0.f;
}

defaultproperties
{
	OnReceivedNativeInputAxis=InputAxis
    MouseSamplingTotal=+0.0083
	MouseSamples=1
}
