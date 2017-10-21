//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_DLC_3_BitBombard extends X2Action;

//Cached info for performing the action
//*************************************
var	protected CustomAnimParams				Params;
var protected XComGameStateContext_Ability	AbilityContext;
var private vector                          StartDropLoc, EndingLoc;
var private AnimNodeSequence                AnimSequence;
var protected XComGameState                 VisualizeGameState;
var private BoneAtom                        StartingAtom;
var private float                           DistanceMag;
var private XComUnitPawn					OwnerUnitPawn;
var private vector                          FixUpLoc;
var private vector                          StartingLocation;
var private float                           DistanceFromStartSquared;
var private float                           StopDistanceSquared; // distance from the origin of the grapple past which we are done
var private float                           DropStopDistance;
var private vector						    FixupOffset;			//The offset that needs to be applied to the mesh due to the desired z location change.

var XComGameState_Unit                      OwnerUnitState;
var float                                   WaitSecsPerTile;
//*************************************

function Init()
{
	local XComWorldData WorldData;
	local XComGameState_Unit UnitState;
	local TTile TargetTile;

	super.Init();
	WorldData = `XWORLD;

	AbilityContext = XComGameStateContext_Ability(StateChangeContext);
	VisualizeGameState = AbilityContext.GetLastStateInInterruptChain();

	UnitState = XComGameState_Unit(Metadata.StateObject_NewState);
	EndingLoc = WorldData.GetPositionFromTileCoordinates(UnitState.TileLocation);

	StartDropLoc = EndingLoc;
	StartDropLoc.Z = `TILESTOUNITS(WorldData.NumZ);

	EndingLoc.Z = UnitPawn.GetDesiredZForLocation(EndingLoc, false);

	OwnerUnitPawn = XGUnit(OwnerUnitState.GetVisualizer()).GetPawn();

	DistanceMag = VSize2D(StartDropLoc - OwnerUnitPawn.Location);
	DistanceMag = `UNITSTOTILES(DistanceMag);

	TargetTile = OwnerUnitState.GetDesiredTileForAttachedCosmeticUnit();
	
	// Set desired X and Y
	FixUpLoc = WorldData.GetPositionFromTileCoordinates(TargetTile);

	// Get our desired Z
	FixUpLoc.Z = UnitPawn.GetDesiredZForLocation(FixUpLoc, WorldData.IsFloorTile(TargetTile, UnitPawn));

	//The fixup only applies to the Z coordinate.
	FixupOffset.X = 0;
	FixupOffset.Y = 0;
	FixupOffset.Z = OwnerUnitPawn.fBaseZMeshTranslation - UnitPawn.fBaseZMeshTranslation;

	DropStopDistance = UnitPawn.GetAnimTreeController().ComputeAnimationRMADistance('FF_BombardStop');

//	`SHAPEMGR.DrawSphere(EndingLoc, vect(15,15,15), MakeLinearColor(1,0,0,1), true);
//	`SHAPEMGR.DrawSphere(FixUpLoc, vect(15,15,15), MakeLinearColor(0,1,0,1), true);
}

event OnAnimNotify(AnimNotify ReceiveNotify)
{
	local XComAnimNotify_NotifyTarget NotifyTarget;

	NotifyTarget = XComAnimNotify_NotifyTarget(ReceiveNotify);
	if(NotifyTarget != none)
	{
		DoNotifyTargetsAbilityApplied(VisualizeGameState, AbilityContext, CurrentHistoryIndex);
	}
}

function MaybeNotifyEnvironmentDamage(XComUnitPawn MovingPawn)
{
	local XComGameState_EnvironmentDamage EnvironmentDamage;	
	local TTile CurrentTile, DamageTile;
	local Vector PawnLocation;
	local int ZOffset;
	
	PawnLocation = MovingPawn.GetCollisionComponentLocation();
	CurrentTile = `XWORLD.GetTileCoordinatesFromPosition(PawnLocation);

	DamageTile = CurrentTile;
	++DamageTile.Z;
		
	foreach AbilityContext.AssociatedState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamage)
	{
		//Iterate upward a short distance from where we are, as this will sync the destruction better with the motion
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
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	UnitPawn.bSkipIK = true;

	UnitPawn.Mesh.SetTranslation(OwnerUnitPawn.Mesh.Translation + FixupOffset);

	// Play the Bit flying up part of Bombard
	Params = default.Params;
	Params.AnimName = 'FF_BombardStart';

	StartingAtom.Translation = FixUpLoc;
	StartingAtom.Rotation = QuatFromRotator(OwnerUnitPawn.GetGameUnit().Rotation);
	StartingAtom.Scale = 1.0f;

	UnitPawn.GetAnimTreeController().GetDesiredEndingAtomFromStartingAtom(Params, StartingAtom);

	AnimSequence = UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);

	while( AnimSequence.GetTimeLeft() != 0.0f )
	{
		Sleep(0.0f);

		MaybeNotifyEnvironmentDamage(UnitPawn);
	}
	
	// Move the Pawn above the target location
	UnitPawn.SetLocation(StartDropLoc);

	Sleep(WaitSecsPerTile * DistanceMag);

	// Play the Bit flying down part of Bombard
	StartingLocation = UnitPawn.Location;
	StopDistanceSquared = Square(VSize(EndingLoc - StartingLocation) - DropStopDistance);

	Params = default.Params;
	Params.AnimName = 'FF_BombardLoop';
	Params.Looping = true;
	AnimSequence = UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);

	DistanceFromStartSquared = 0;
	while( DistanceFromStartSquared < StopDistanceSquared )
	{
		Sleep(0.0f);
		DistanceFromStartSquared = VSizeSq(UnitPawn.Location - StartingLocation);

		MaybeNotifyEnvironmentDamage(UnitPawn);
	}

	// Play the Stop 
	Params = default.Params;
	Params.AnimName = 'FF_BombardStop';
	Params.BlendTime = 0.0f;

	Params.DesiredEndingAtoms.Add(1);
	Params.DesiredEndingAtoms[0].Translation = EndingLoc;
	Params.DesiredEndingAtoms[0].Rotation = QuatFromRotator(OwnerUnitPawn.GetGameUnit().Rotation);
	Params.DesiredEndingAtoms[0].Scale = 1.0f;

	AnimSequence = UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);
	FinishAnim(AnimSequence);

	CompleteAction();
}

defaultproperties
{
	WaitSecsPerTile=0.0f
}