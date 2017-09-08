//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_MoveClimbOnto extends X2Action_Move;

var vector  NewDirection;

var CustomAnimParams AnimParams;
var bool  bStoredSkipIK;
var Rotator DesiredRotation;

function Init()
{
	super.Init();
	PathTileIndex = FindPathTileIndex();
}

function ParsePathSetParameters(int InPathIndex, const out vector InDestination, float InDistance, const out vector InNewDirection)
{
	PathIndex = InPathIndex;	
	Destination = InDestination;
	Distance = InDistance;
	NewDirection = InNewDirection;
}

simulated state Executing
{
Begin:
	UnitPawn.Acceleration = vect(0,0,0);
	UnitPawn.vMoveDirection = vect(0,0,0);
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	Sleep(0);

	UnitPawn.SetFocalPoint(UnitPawn.Location + Vector(UnitPawn.Rotation) * 16.0f);

	`BATTLE.m_bSkipVisUpdate = true;
	
	bStoredSkipIK = UnitPawn.bSkipIK;
	UnitPawn.bSkipIK = true;
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	
	AnimParams.AnimName = 'MV_ClimbLowObject_Up';
	AnimParams.PlayRate = GetMoveAnimationSpeed();
	AnimParams.DesiredEndingAtoms.Add(1);
	AnimParams.DesiredEndingAtoms[0].Translation = Destination;
	AnimParams.DesiredEndingAtoms[0].Translation.Z = Unit.GetDesiredZForLocation(Destination);
	AnimParams.DesiredEndingAtoms[0].Scale = 1.0f;
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
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	UnitPawn.SnapToGround();

	UnitPawn.Acceleration = Vect(0, 0, 0);
	UnitPawn.vMoveDirection = Vect(0, 0, 0);

	UnitPawn.m_fDistanceMovedAlongPath = Distance;
	CompleteAction();
}

DefaultProperties
{
}
