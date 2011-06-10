/**
 * The core 'playercontroller' for during a game. As a note, this controls the player
 * camera, not the pawns
 * 
 * 
 **/
class ISOCorePlayerController extends GamePlayerController;

var bool        ISOSelect;
var ISOUnit     selected;
var ISONode     hoverNode;



DefaultProperties
{
	CameraClass = class'ISOCamera'
	InputClass  = class'ISOCorePlayerInput'
}

// Functions that are defined in the state
exec function onClick();
exec function bool onRequestMove(ISOUnit unit, Vector loc);
exec function onSelect(ISOUnit unit);
exec function onDeselect(ISOUnit unit);
exec function onHoverOver(ISONode node);
exec function onHoverOut(ISONode node);

function setHover(ISONode node)
{

	// Check to see if I have a new hover node
	if( hoverNode != node )
	{
		onHoverOut(hoverNode);

		hoverNode = node;

		onHoverOver(node);
	}
}

simulated event PreBeginPlay()
{
}

/**
 * Lifts the player from the ground and makes him look down, also sets a Vector needed for 
 * calculations later on
**/
simulated event PostBeginPlay()
{
	local Rotator Rot;

	super.PostBeginPlay();

	Rot.Pitch = (-55.0f *DegToRad) * RadToUnrRot;
	Rot.Roll =  (0      *DegToRad) * RadToUnrRot;
	Rot.Yaw =   (30.0f  *DegToRad) * RadToUnrRot;
	
	SetRotation(Rot);
	SetLocation(Location + vect(0,0,156));

	//reComputeAxes();
}

exec function ZoomOut() {
	ISOCamera(PlayerCamera).zoomOut();
}

exec function ZoomIn() {
	ISOCamera(PlayerCamera).zoomIn();
}

state ISOBaseSpectating
{
	function bool IsSpectating()
	{
		return true;
	}

	/**
	  * Adjust spectator velocity if "out of bounds"
	  * (above stallz or below killz)
	  */
	function bool LimitSpectatorVelocity()
	{
		if ( Location.Z > WorldInfo.StallZ )
		{
			Velocity.Z = FMin(SpectatorCameraSpeed, WorldInfo.StallZ - Location.Z - 2.0);
			return true;
		}
		else if ( Location.Z < WorldInfo.KillZ )
		{
			Velocity.Z = FMin(SpectatorCameraSpeed, WorldInfo.KillZ - Location.Z + 2.0);
			return true;
		}
		return false;
	}

	/**
	 * Physically moves a the player camera according to the input in the player input
	 * 
	 **/
	function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
	{
		local float		VelSize;
		local float     AccSize;

		
		Acceleration = Normal(NewAccel) * SpectatorCameraSpeed;

		VelSize = VSize(Velocity);
		AccSize = VSize(Acceleration);

		/* smoothly accelerate and decelerate */
		if( VelSize > 0 )
		{
			//Velocity = Velocity - (Velocity - Normal(Acceleration) * VelSize) * FMin(DeltaTime * 8, 1);
			Velocity = Velocity - (Velocity - Normal(Acceleration) * AccSize) * FMin(DeltaTime * 8, 1);
		}

		Velocity = Velocity + Acceleration * DeltaTime;

		if( VSize(Velocity) > SpectatorCameraSpeed )
		{
			Velocity = Normal(Velocity) * SpectatorCameraSpeed;
		}

		LimitSpectatorVelocity();
		if( VSize(Velocity) > 0 )
		{
			// THIS IS WHAT ACTUALLY DOES THE MOVEMENT
			MoveSmooth( (1+bRun) * Velocity * DeltaTime );

			// correct if out of bounds after move
			if ( LimitSpectatorVelocity() )
			{
				MoveSmooth( Velocity.Z * vect(0,0,1) * DeltaTime );
			}
		}
	}

	function PlayerMove(float DeltaTime)
	{
		local vector X,Y,Z,xd;
		
		GetAxes(Rotation,X,Y,Z);

		xd = X * vect(1,1,0);
		//Acceleration = PlayerInput.aForward*X + PlayerInput.aStrafe*Y + PlayerInput.aUp*vect(0,0,1);
		Acceleration = PlayerInput.aForward*xd + PlayerInput.aStrafe*Y + PlayerInput.aUp*vect(0,0,1);
		UpdateRotation(DeltaTime);

		if (Role < ROLE_Authority) // then save this move and replicate it
		{
			ReplicateMove(DeltaTime, Acceleration, DCLICK_None, rot(0,0,0));
		}
		else
		{
			ProcessMove(DeltaTime, Acceleration, DCLICK_None, rot(0,0,0));
		}
	}

	/** when spectating, tells server where the client is (client is authoritative on location when spectating) */
	unreliable server function ServerSetSpectatorLocation(vector NewLoc)
	{
		SetLocation(NewLoc);
		if ( WorldInfo.TimeSeconds - LastSpectatorStateSynchTime > 2.0 )
		{
			ClientGotoState(GetStateName());
			LastSpectatorStateSynchTime = WorldInfo.TimeSeconds;
		}
	}

	function ReplicateMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
	{
		ProcessMove(DeltaTime, NewAccel, DoubleClickMove, DeltaRot);
		// when spectating, client position is authoritative
		ServerSetSpectatorLocation(Location);
	}


	event BeginState(Name PreviousStateName)
	{
		bCollideWorld = true;
	}

	event EndState(Name NextStateName)
	{
		bCollideWorld = false;
	}
}

/** 
 * Basic Turn state for a player. This allows them
 * to both select and de-select units
 **/
auto state ISOPlayerTurn extends ISOBaseSpectating
{
	simulated event BeginState(Name PreviousStateName)
	{
		if ( PlayerReplicationInfo != None )
		{
			PlayerReplicationInfo.SetWaitingPlayer(true);
		}
		bCollideWorld = true;
	}

	event EndState(Name NextStateName)
	{
		if ( PlayerReplicationInfo != None )
		{
			PlayerReplicationInfo.SetWaitingPlayer(false);
		}
		bCollideWorld = false;
	}

	/** 
	 *  Main entry point for mouse clicks from
	 *  the player
	 **/
	exec function onClick()
	{
		local ISOUnit next;
		local Vector loc;

		// Get the next selection
		next = GetNextSelection(loc);

		// Nothing to do
		if( next == selected ) return;

		// I selected somthing that was not what I had before... deselect current
		if( selected != none )
		{
			if( next == none && onRequestMove(selected, loc) ) return;

			onDeselect(selected);
			
		}

		if( next == none )
		{
			selected = none;
		}
		else
		{
			selected = next;

			onSelect(selected);
		}
	}

	/**
	 * Select a unit
	 **/
	exec function onSelect(ISOUnit unit)
	{
		selected.onSelect();
	}

	/**
	 * Select a unit
	 **/
	exec function onDeselect(ISOUnit unit)
	{
		unit.onDeselect();
	}

	/**
	 * Get the next selection
	 **/
	exec function ISOUnit GetNextSelection(out Vector loc)
	{
		local Actor traceActor;
		local Vector norm;

		// Check to see if I have clicked on some unit
		ISOHUD(myHUD).getStuffUnderMouse(loc, norm, traceActor);

		if( traceActor != None && traceActor.IsA('ISOUnit') )
			return ISOUnit(traceActor);
		return None;
	}

	/**
	 * Request move. Return true to deselect afterwords
	 **/
	exec function bool onRequestMove(ISOUnit unit, Vector loc)
	{
		return false;
	}

	/*
	exec function onSelect()
	{
		local Vector loc;
		local Vector norm;
		local ISOUnit nextUnit;

		ISOSelect = !ISOSelect;

		ISOHUD(myHUD).getStuffUnderMouse(loc, norm, selected);

		if( unit != none && unit.isSelected )
		{
			unit.MoveTo(loc);
		}

		nextUnit = ISOUnit(selected);

		// De-select the old unit
		if( nextUnit==none || nextUnit!=unit )
		{
			unit.onDeselect(true);
			unit = nextUnit;
		}


		if( unit != none )
		{
			if( !unit.isSelected )
			{
				unit.onSelect();
			}

		}
	}
	*/
}