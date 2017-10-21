//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_DLC_Day60IcarusDropGrab extends X2Action;

//Cached info for performing the action
//*************************************
var bool                                    bSyncAction;

var	protected CustomAnimParams				Params;
var protected XComGameStateHistory			History;
var protected XComGameStateContext_Ability	AbilityContext;
var protected XComUnitPawn					TargetPawn;
var protected vector                        DesiredAnimLocation;
var private Actor							PartnerVisualizer;
var private XComUnitPawn					PartnerUnitPawn;
var private vector                          StartingLocation;
var private float                           DistanceFromStartSquared;
var private float                           StopDistanceSquared; // distance from the origin of the grapple past which we are done
var private vector                          UnitEndLoc, PartnerUnitEndLoc, UnitGameStateLoc, PartnerUnitGameStateLoc;
var private AnimNodeSequence                SourceAnim, TargetAnim;
var private float                           fFlyUpStopDistance;

var X2Camera_FollowMovingUnit               FollowCamera; // need to roll our own camera so we can frame the vertical movement nicely
//*************************************

function Init()
{
	local XComWorldData WorldData;
	local XComGameState_Unit UnitState, PartnerUnitState;
	local int PartnerObjID;

	super.Init();
	
	History = `XCOMHISTORY;
	WorldData = `XWORLD;

	AbilityContext = XComGameStateContext_Ability(StateChangeContext);

	UnitState = XComGameState_Unit(Metadata.StateObject_NewState);

	PartnerObjID = AbilityContext.InputContext.PrimaryTarget.ObjectID;
	if( PartnerObjID == UnitState.ObjectID )
	{
		PartnerObjID = AbilityContext.InputContext.SourceObject.ObjectID;
	}

	PartnerUnitState = XComGameState_Unit(History.GetGameStateForObjectID(PartnerObjID));
	PartnerVisualizer = PartnerUnitState.GetVisualizer();
	PartnerUnitPawn = XGUnit(PartnerVisualizer).GetPawn();

	// Get the ending locations for the GameState_Units
	UnitGameStateLoc = WorldData.GetPositionFromTileCoordinates(UnitState.TileLocation);
	PartnerUnitGameStateLoc = WorldData.GetPositionFromTileCoordinates(PartnerUnitState.TileLocation);

	// Find the X, Y values for mid point
	// THe Z value will be calulated below for each Unit Pawn
	DesiredAnimLocation = PartnerUnitPawn.Location; // Move the Archon onto the target's position

	UnitEndLoc.X = DesiredAnimLocation.X;
	UnitEndLoc.Y = DesiredAnimLocation.Y;
	UnitEndLoc.Z = Unit.GetDesiredZForLocation(UnitGameStateLoc, false); // Find the desired Z

	PartnerUnitEndLoc.X = DesiredAnimLocation.X;
	PartnerUnitEndLoc.Y = DesiredAnimLocation.Y;
	PartnerUnitEndLoc.Z = PartnerUnitPawn.GetDesiredZForLocation(PartnerUnitGameStateLoc, false); // Find the desired Z

	fFlyUpStopDistance = UnitPawn.GetAnimTreeController().ComputeAnimationRMADistance('NO_IcarusDrop_FlyUpStop');
//	`SHAPEMGR.DrawSphere(Unit.Location, vect(15,15,15), MakeLinearColor(1,0,0,1), true);
//	`SHAPEMGR.DrawSphere(PartnerUnitPawn.Location, vect(15,15,15), MakeLinearColor(0,1,0,1), true);
}

function ForceImmediateTimeout()
{
	// Do nothing. This is causing the animation to not finish. This animation has a fixup that
	// gets the two units to their desired positions.
}

function bool CheckInterrupted()
{
	return false;
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
	function AnimNodeSequence PlayFlyStartAnim(XComUnitPawn PlayOnPawn, vector FaceDir)
	{
		local vector UpdatedFaceDir;
		local BoneAtom StartingAtom;

		UpdatedFaceDir = FaceDir;
		UpdatedFaceDir.Z = 0;

		Params = default.Params;
		Params.AnimName = 'NO_IcarusDrop_FlyUpStart';
		StartingAtom.Translation = PlayOnPawn.Location;
		StartingAtom.Rotation = QuatFromRotator(Rotator(UpdatedFaceDir));
		StartingAtom.Scale = 1.0f;
		PlayOnPawn.GetAnimTreeController().GetDesiredEndingAtomFromStartingAtom(Params, StartingAtom);
	
		Params.DesiredEndingAtoms[0].Translation.X = DesiredAnimLocation.X;
		Params.DesiredEndingAtoms[0].Translation.Y = DesiredAnimLocation.Y;
		// Params.DesiredEndingAtom.Translation.Z is set by the call to GetDesiredEndingAtomFromStartingAtom above
		Params.DesiredEndingAtoms[0].Rotation = QuatFromRotator(Rotator(UpdatedFaceDir));
		Params.DesiredEndingAtoms[0].Scale = 1.0f;

		return PlayOnPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);
	}

	function AnimNodeSequence PlayFlyStopAnim(XComUnitPawn PlayOnPawn, const out vector EndLocation)
	{
		Params = default.Params;
		Params.AnimName = 'NO_IcarusDrop_FlyUpStop';
		Params.DesiredEndingAtoms.Add(1);
		Params.DesiredEndingAtoms[0].Translation = EndLocation;
		Params.DesiredEndingAtoms[0].Rotation = QuatFromRotator(PlayOnPawn.Rotation);
		Params.DesiredEndingAtoms[0].Scale = 1.0f;

		return PlayOnPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);
	}

	function PlayLoopAnim(XGUnit PlayOnUnit, XComUnitPawn PlayOnPawn)
	{
		Params = default.Params;
		Params.AnimName = 'NO_IcarusDrop_Loop';
		Params.Looping = true;

		PlayOnPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);

		PlayOnUnit.IdleStateMachine.PersistentEffectIdleName = 'NO_IcarusDrop_Loop';
		PlayOnPawn.GetAnimTreeController().SetAllowNewAnimations(false);
	}

Begin:
	
	while( UnitPawn.m_kGameUnit.IdleStateMachine.IsEvaluatingStance() ||
		   PartnerUnitPawn.m_kGameUnit.IdleStateMachine.IsEvaluatingStance() )
	{
		Sleep(0.01f);
	}

	FollowCamera = new class'X2Camera_FollowMovingUnit';
	FollowCamera.MoveAbility = AbilityContext;
	FollowCamera.Unit = Unit;
	`CAMERASTACK.AddCamera(FollowCamera);

	while(!FollowCamera.HasArrived)
	{
		Sleep(0.0f);
	}

	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	UnitPawn.bSkipIK = true;

	PartnerUnitPawn.EnableRMA(true, true);
	PartnerUnitPawn.EnableRMAInteractPhysics(true);
	PartnerUnitPawn.bSkipIK = true;
	PartnerUnitPawn.UpdateAnimations();

	if( !bSyncAction )
	{
		PlayFlyStartAnim(UnitPawn, (PartnerUnitGameStateLoc - UnitGameStateLoc));
		PlayFlyStartAnim(PartnerUnitPawn, (UnitGameStateLoc - PartnerUnitGameStateLoc));

		// to protect against overshoot, rather than check the distance to the target, we check the distance from the source.
		// Otherwise it is possible to go from too far away in front of the target, to too far away on the other side
		StartingLocation = UnitPawn.Location;
		StopDistanceSquared = Square(VSize(UnitEndLoc - StartingLocation) - fFlyUpStopDistance);

		DistanceFromStartSquared = 0;
		while( DistanceFromStartSquared < StopDistanceSquared )
		{
			Sleep(0.0f);
			DistanceFromStartSquared = VSizeSq(UnitPawn.Location - StartingLocation);

			MaybeNotifyEnvironmentDamage(UnitPawn);
			MaybeNotifyEnvironmentDamage(PartnerUnitPawn);
		}
	}

	SourceAnim = PlayFlyStopAnim(UnitPawn, UnitEndLoc);
	TargetAnim = PlayFlyStopAnim(PartnerUnitPawn, PartnerUnitEndLoc);

	FinishAnim(SourceAnim);
	FinishAnim(TargetAnim);

//	`SHAPEMGR.DrawSphere(UnitEndLoc, vect(15,15,15), MakeLinearColor(1,0,0,1), true);
//	`SHAPEMGR.DrawSphere(PartnerUnitEndLoc, vect(15,15,15), MakeLinearColor(0,1,0,1), true);
//	`SHAPEMGR.DrawSphere(Unit.Location, vect(15,15,15), MakeLinearColor(1,0,0,1), true);
//	`SHAPEMGR.DrawSphere(PartnerUnitPawn.Location, vect(15,15,15), MakeLinearColor(0,1,0,1), true);

	PlayLoopAnim(Unit, UnitPawn);
	PlayLoopAnim(XGUnit(PartnerVisualizer), PartnerUnitPawn);	

	CompleteAction();
}

function CompleteAction()
{
	super.CompleteAction();

	if(FollowCamera != none)
	{
		`CAMERASTACK.RemoveCamera(FollowCamera);
		FollowCamera = none;
	}
}

event bool BlocksAbilityActivation()
{
	return true;
}

DefaultProperties
{
	bSyncAction=false
}