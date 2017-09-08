//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_MoveJumpUp extends X2Action_Move;

var vector				NewDirection;
var CustomAnimParams	AnimParams;
var AnimNodeSequence	PlayingSequence;
var BoneAtom			StartingAtom;
var float				fPawnHalfHeight;
var bool				bStoredSkipIK;
var vector				DesiredFacing;
var bool				bClimbOver;
var TTile				DamageTile;

function Init()
{
	super.Init();

	PathTileIndex = FindPathTileIndex();
	fPawnHalfHeight = UnitPawn.CylinderComponent.CollisionHeight;
}

function ParsePathSetParameters(int InPathIndex, const out vector InDestination, float InDistance, const out vector InNewDirection)
{
	PathIndex = InPathIndex;	
	Destination = InDestination;
	Distance = InDistance;
	NewDirection = InNewDirection;
}

// Copied from Action_MoveDropdown and tweaked for the UP motion instead of DOWN.
function MaybeNotifyEnvironmentDamage( )
{
	local XComGameState_EnvironmentDamage EnvironmentDamage;
	local TTile CurrentTile;
	local Vector PawnLocation;
	local int ZOffset;

	PawnLocation = UnitPawn.GetCollisionComponentLocation();
	CurrentTile = `XWORLD.GetTileCoordinatesFromPosition(PawnLocation);
	if (CurrentTile.Z < DamageTile.Z)
	{
		return;
	}

	DamageTile = CurrentTile;	
	++DamageTile.Z;

	foreach StateChangeContext.AssociatedState.IterateByClassType( class'XComGameState_EnvironmentDamage', EnvironmentDamage )
	{
		//Iterate downward a short distance from where we are, as this will sync the destruction better with the motion of the ragdoll
		for(ZOffset = 0; ZOffset < 4; ++ZOffset)
		{	
			++CurrentTile.Z;
			if(EnvironmentDamage.HitLocationTile == DamageTile)
			{				
				`XEVENTMGR.TriggerEvent('Visualizer_WorldDamage', EnvironmentDamage, self);
			}
		}

	}
}

simulated state Executing
{
Begin:
	bStoredSkipIK = UnitPawn.bSkipIK;
	UnitPawn.bSkipIK = true;
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);

	Destination.Z = Unit.GetDesiredZForLocation(Destination);

	DesiredFacing = Destination - UnitPawn.Location;
	DesiredFacing.Z = 0;
	DesiredFacing = Normal(DesiredFacing);

	AnimParams.AnimName = 'MV_ClimbHighJump_Start';
	AnimParams.PlayRate = GetMoveAnimationSpeed();
	StartingAtom.Translation = UnitPawn.Location;
	StartingAtom.Rotation = QuatFromRotator(Rotator(DesiredFacing));
	StartingAtom.Scale = 1.0f;
	UnitPawn.GetAnimTreeController().GetDesiredEndingAtomFromStartingAtom(AnimParams, StartingAtom);
	PlayingSequence = UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams);

	DamageTile = `XWORLD.GetTileCoordinatesFromPosition( Unit.Location );

	while( UnitPawn.Location.Z <= Destination.Z )
	{
		if( !PlayingSequence.bRelevant || !PlayingSequence.bPlaying || PlayingSequence.AnimSeq == None )
		{
			`RedScreen("JumpUp never made it to the destination");
			UnitPawn.SetLocation(Destination);
			break;
		}
		Sleep(0.0f);
		MaybeNotifyEnvironmentDamage( );
	}

	// Do the climb over check once we are at the right z height
	bClimbOver = Unit.DoClimbOverCheck(Destination);

	if( bClimbOver )
	{
		AnimParams.AnimName = 'MV_ClimbHighJump_StopWall';
	}
	else
	{
		AnimParams.AnimName = 'MV_ClimbHighJump_Stop';
	}
	
	AnimParams.DesiredEndingAtoms[0].Translation = Destination;
	AnimParams.DesiredEndingAtoms[0].Rotation = QuatFromRotator(Rotator(DesiredFacing));
	AnimParams.DesiredEndingAtoms[0].Scale = 1.0f;

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
	
	UnitPawn.Acceleration = Vect(0, 0, 0);
	UnitPawn.vMoveDirection = Vect(0, 0, 0);
	UnitPawn.m_fDistanceMovedAlongPath = Distance;
	UnitPawn.bSkipIK = bStoredSkipIK;

	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	UnitPawn.SnapToGround();

	CompleteAction();
}

DefaultProperties
{
}
