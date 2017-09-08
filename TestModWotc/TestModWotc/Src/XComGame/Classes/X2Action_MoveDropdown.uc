//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_MoveDropdown extends X2Action_Move;

var bool    bClimbOver;
var float   fPawnHalfHeight;
var bool    bOverwatchWhenDone;            //  special missions
var int     iAttackChanceWhenDone;          
var int     StartAnim;
var int     StopAnim;
var int     m_iAimingIterations;
var bool    bStoredSkipIK;
var CustomAnimParams AnimParams;
var float   DropHeight;
var float	DistanceTraveledZ;
var float	StartingLocationZ;
var private BoneAtom StartingAtom;
var private AnimNodeSequence PlayingSequence;
var Rotator DesiredRotation;
var vector  NewDirection;

var private TTile DamageTile;

function Init()
{
	super.Init();

	StartingAtom.Translation = Unit.CurrentMoveData.MovementData[PathIndex].Position;

	fPawnHalfHeight = UnitPawn.CylinderComponent.CollisionHeight;

	PathTileIndex = FindPathTileIndex();
}

function ParsePathSetParameters(int InPathIndex, const out vector InDestination, float InDistance, const out vector InNewDirection)
{
	PathIndex = InPathIndex;	
	Destination = InDestination;
	Distance = InDistance;
	NewDirection = InNewDirection;
}


function MaybeNotifyEnvironmentDamage( )
{
	local XComGameState_EnvironmentDamage EnvironmentDamage;
	local TTile CurrentTile;
	local Vector PawnLocation;
	local int ZOffset;

	PawnLocation = UnitPawn.GetCollisionComponentLocation();
	CurrentTile = `XWORLD.GetTileCoordinatesFromPosition(PawnLocation);
	if (CurrentTile.Z > DamageTile.Z)
	{
		return;
	}

	DamageTile = CurrentTile;	
	--DamageTile.Z;

	foreach StateChangeContext.AssociatedState.IterateByClassType( class'XComGameState_EnvironmentDamage', EnvironmentDamage )
	{
		//Iterate downward a short distance from where we are, as this will sync the destruction better with the motion of the ragdoll
		for(ZOffset = 0; ZOffset > -4; --ZOffset)
		{	
			--CurrentTile.Z;
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
	bClimbOver = Unit.DoClimbOverCheck(Destination);

	bStoredSkipIK = UnitPawn.bSkipIK;
	UnitPawn.bSkipIK = true;	
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);

	Destination.Z = UnitPawn.GetDesiredZForLocation(Destination);
	
	DropHeight = UnitPawn.Location.Z - Destination.Z;

	AnimParams.PlayRate = GetMoveAnimationSpeed();
	if( DropHeight <= 256 )
	{
		AnimParams.AnimName = bClimbOver ?  'MV_ClimbDropLow_StartWall' : 'MV_ClimbDropLow_Start';
		if(!UnitPawn.GetAnimTreeController().CanPlayAnimation(AnimParams.AnimName))
		{
			// no low animation exists, use the high as a fallback
			AnimParams.AnimName = bClimbOver ?  'MV_ClimbDropHigh_StartWall' : 'MV_ClimbDropHigh_Start';
		}
	}
	else
	{
		AnimParams.AnimName = bClimbOver ? 'MV_ClimbDropHigh_StartWall' : 'MV_ClimbDropHigh_Start';
		if(!UnitPawn.GetAnimTreeController().CanPlayAnimation(AnimParams.AnimName))
		{
			// no hight animation exists, use the high as a fallback
			AnimParams.AnimName = bClimbOver ?  'MV_ClimbDropLow_StartWall' : 'MV_ClimbDropLow_Start';
		}
	}

	// Jwats: First fixup to the obstacle
	StartingAtom.Translation.Z = Unit.GetDesiredZForLocation(StartingAtom.Translation);
	StartingAtom.Scale = 1.0f;
	DesiredRotation = Normalize(Rotator(Destination - UnitPawn.Location));
	DesiredRotation.Pitch = 0;
	DesiredRotation.Roll = 0;
	StartingAtom.Rotation = QuatFromRotator(DesiredRotation);
	UnitPawn.GetAnimTreeController().GetDesiredEndingAtomFromStartingAtom(AnimParams, StartingAtom);
	PlayingSequence = UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams);

	DamageTile = `XWORLD.GetTileCoordinatesFromPosition( Unit.Location );
	
	DistanceTraveledZ = 0.0f;
	StartingLocationZ = Unit.Location.Z;
	while( DistanceTraveledZ < DropHeight )
	{
		if( !PlayingSequence.bRelevant || !PlayingSequence.bPlaying || PlayingSequence.AnimSeq == None )
		{
			if( DropHeight - DistanceTraveledZ > fPawnHalfHeight )
			{
				`RedScreen("Dropdown never made it to the destination");
			}
			break;
		}
		Sleep(0.0f);
		DistanceTraveledZ = StartingLocationZ - Unit.Location.Z;
		MaybeNotifyEnvironmentDamage( );
	}

	if( PredictedCoverState != eCS_None )
	{
		NewDirection = PredictedCoverDirection;
	}

	NewDirection.Z = 0.0f;
	if( abs(NewDirection.X) < 0.001f && abs(NewDirection.Y) < 0.001f )
	{
		NewDirection = vector(DesiredRotation);
	}

	AnimParams = default.AnimParams;
	AnimParams.PlayRate = GetMoveAnimationSpeed();
	AnimParams.DesiredEndingAtoms.Add(1);
	AnimParams.DesiredEndingAtoms[0].Translation = Destination;
	AnimParams.DesiredEndingAtoms[0].Rotation = QuatFromRotator(Rotator(NewDirection));
	AnimParams.DesiredEndingAtoms[0].Scale = 1.0f;
	if (DropHeight <= 256)
	{
		AnimParams.AnimName = 'MV_ClimbDropLow_Stop';
		if(!UnitPawn.AnimTreeController.CanPlayAnimation(AnimParams.AnimName))
		{
			AnimParams.AnimName = 'MV_ClimbDropHigh_Stop'; // no low animation exists, use the high as a fallback
		}
	}
	else 
	{
		AnimParams.AnimName = 'MV_ClimbDropHigh_Stop';
		if(!UnitPawn.AnimTreeController.CanPlayAnimation(AnimParams.AnimName))
		{
			AnimParams.AnimName = 'MV_ClimbDropLow_Stop'; // no high animation exists, use the low as a fallback
		}
	}

	UnitPawn.SnapToGround(); // In case we went slightly past the ground (based on dt) 
	UnitPawn.bSkipIK = bStoredSkipIK;
	FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams));

	UnitPawn.Acceleration = Vect(0, 0, 0);
	UnitPawn.vMoveDirection = Vect(0, 0, 0);
	UnitPawn.m_fDistanceMovedAlongPath = Distance;

	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	UnitPawn.SnapToGround();

	CompleteAction();
}

DefaultProperties
{
}
