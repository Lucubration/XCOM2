//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_MoveVisibleTeleport extends X2Action_Move;

//Cached info for the unit performing the action
//*************************************
var bool PlayAnim;
var bool WaitForTeleportEvent;
var	CustomAnimParams ParamsStart;
var CustomAnimParams ParamsStop;
var bool bLookAtEndPos;

var private X2Camera_LookAtLocationTimed LookAtCam;
var private Actor FOWViewer;					// The current FOW Viewer actor
var private TTile CurrentTile;
//*************************************

function ParsePathSetParameters(int InPathIndex, const out vector InDestination, float InDistance)
{
	PathIndex = InPathIndex;	
	Destination = InDestination;
	Distance = InDistance;
}

function bool CheckInterrupted()
{
	return false;
}

function RespondToParentEventReceived(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	if( Event == 'Visualizer_TeleportNow' )
	{
		WaitForTeleportEvent = false;
	}

	super.RespondToParentEventReceived(EventData, EventSource, GameState, Event, CallbackData);
}

simulated state Executing
{
	private function RequestLookAtCamera()
	{
		if (ShouldAddCameras())
		{
			LookAtCam = new class'X2Camera_LookAtLocationTimed';
			LookAtCam.LookAtLocation = Destination;
			LookAtCam.UseTether = false;
			`CAMERASTACK.AddCamera(LookAtCam);

			FOWViewer = `XWORLD.CreateFOWViewer(Unit.GetLocation(), 3 * class'XComWorldData'.const.WORLD_StepSize);
		}
	}

	private function ClearLookAtCamera()
	{
		`CAMERASTACK.RemoveCamera(LookAtCam);
		LookAtCam = None;

		if( FOWViewer != None )
		{
			`XWORLD.DestroyFOWViewer(FOWViewer);
			FOWViewer = None;
		}
	}
Begin:
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);

	// Play the teleport start animation
	if( ParamsStart.AnimName == '' )
	{
		ParamsStart.AnimName = 'HL_TeleportStart';
	}
	ParamsStart.PlayRate = GetMoveAnimationSpeed();
	if( PlayAnim )
	{
		FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(ParamsStart));
	}

	while( WaitForTeleportEvent )
	{
		sleep(0.0f);
	}

	`XEVENTMGR.TriggerEvent('Visualizer_TeleportNow', self, self);

	// If have look at camera, move it to the second part here
	if( bLookAtEndPos )
	{
		Unit.SetForceVisibility(eForceNotVisible);
		Unit.GetPawn().UpdatePawnVisibility();

		RequestLookAtCamera();
		while( LookAtCam != None && !LookAtCam.HasArrived && LookAtCam.IsLookAtValid() )
		{
			Sleep(0.0);
		}

		Unit.SetForceVisibility(eForceVisible);
		Unit.GetPawn().UpdatePawnVisibility();
	}

	// Move the pawn to the end position
	Destination.Z = UnitPawn.GetDesiredZForLocation(Destination, true) + UnitPawn.GetAnimTreeController().ComputeAnimationRMADistance('HL_TeleportStop');	
	UnitPawn.SetLocation(Destination);		
	Unit.ProcessNewPosition( );

	// Play the teleport stop animation
	if( ParamsStop.AnimName == '' )
	{
		ParamsStop.AnimName = 'HL_TeleportStop';
	}
	ParamsStop.BlendTime = 0;
	ParamsStop.DesiredEndingAtoms.Add(1);
	ParamsStop.DesiredEndingAtoms[0].Translation = UnitPawn.Location;
	ParamsStop.DesiredEndingAtoms[0].Translation.Z = UnitPawn.GetDesiredZForLocation(UnitPawn.Location);
	ParamsStop.DesiredEndingAtoms[0].Rotation = QuatFromRotator(UnitPawn.Rotation);
	ParamsStop.DesiredEndingAtoms[0].Scale = 1.0f;

	if( PlayAnim )
	{
		FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(ParamsStop));
	}

	if( bLookAtEndPos )
	{
		ClearLookAtCamera();
	}

	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);

	UnitPawn.Acceleration = Vect(0, 0, 0);
	UnitPawn.vMoveDirection = Vect(0, 0, 0);

	UnitPawn.m_fDistanceMovedAlongPath = Distance;

	CompleteAction();
}

defaultproperties
{
	InputEventIDs.Add( "Visualizer_TeleportNow" )
	PlayAnim=true
}