//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_MovePlayAnimation extends X2Action_Move;

var Name        AnimName;
var vector  NewDirection;
var Actor       InteractWithActor;
var StateObjectReference InteractiveObjectReference;
var CustomAnimParams AnimParams;
var Rotator DesiredRotation;
var bool    bStoredSkipIK;

function Init()
{
	super.Init();

	FindActorByIdentifier(Unit.CurrentMoveData.MovementData[PathIndex].ActorId, InteractWithActor);
	if( XComInteractiveLevelActor(InteractWithActor) != none )
	{
		InteractiveObjectReference = `XCOMHISTORY.GetGameStateForObjectID(XComInteractiveLevelActor(InteractWithActor).ObjectID).GetReference();
	}

	PathTileIndex = FindPathTileIndex();
}

function ParsePathSetParameters(int InPathIndex, const out vector InDestination, float InDistance, Name InAnim, const out vector InNewDirection)
{
	PathIndex = InPathIndex;	
	Destination = InDestination;
	Distance = InDistance;
	AnimName = InAnim;	
	NewDirection = InNewDirection;
}

event OnAnimNotify(AnimNotify ReceiveNotify)
{
	local AnimNotify_KickDoor KickDoorNotify;

	super.OnAnimNotify(ReceiveNotify);

	KickDoorNotify = AnimNotify_KickDoor(ReceiveNotify);
	if( KickDoorNotify != none && InteractiveObjectReference.ObjectID > 0 )
	{
		`XEVENTMGR.TriggerEvent('Visualizer_KickDoor', InteractWithActor, self);		
	}
}

simulated state Executing
{
Begin:
	UnitPawn.EnableRMA(true,true);
	UnitPawn.EnableRMAInteractPhysics(true);
	bStoredSkipIK = UnitPawn.bSkipIK;
	UnitPawn.bSkipIK = true;

	Destination.Z = Unit.GetDesiredZForLocation(Destination);

	// Start the animation
	AnimParams.AnimName = AnimName;
	AnimParams.PlayRate = GetMoveAnimationSpeed();
	AnimParams.DesiredEndingAtoms.Add(1);
	AnimParams.DesiredEndingAtoms[0].Scale = 1.0f;
	AnimParams.DesiredEndingAtoms[0].Translation = Destination;
	DesiredRotation = Normalize(Rotator(Destination - UnitPawn.Location));
	DesiredRotation.Pitch = 0;
	DesiredRotation.Roll = 0;
	AnimParams.DesiredEndingAtoms[0].Rotation = QuatFromRotator(DesiredRotation);

	// Jwats: Add another fixup for the direction you will run after the path.
	if( PredictedCoverState != eCS_None )
	{
		NewDirection = PredictedCoverDirection;
	}

	NewDirection.Z = 0.0f;
	if( abs(NewDirection.X) < 0.001f && abs(NewDirection.Y) < 0.001f )
	{
		NewDirection = vector(UnitPawn.Rotation);
	}
	AnimParams.DesiredEndingAtoms.AddItem(AnimParams.DesiredEndingAtoms[0]);
	AnimParams.DesiredEndingAtoms[1].Rotation = QuatFromRotator(Rotator(NewDirection));

	FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams));

	UnitPawn.bSkipIK = bStoredSkipIK;
	UnitPawn.EnableRMA(true,true);
	UnitPawn.EnableRMAInteractPhysics(true);

	UnitPawn.Acceleration = vect(0,0,0);
	UnitPawn.vMoveDirection = vect(0,0,0);
	// Tell the pawn he's moved
	if (Distance != 0.0f)
	{
		UnitPawn.m_fDistanceMovedAlongPath = Distance;
	}

	CompleteAction();
}

DefaultProperties
{
	OutputEventIDs.Add( "Visualizer_KickDoor" ) //Get door kick notifies from movement actions
}
