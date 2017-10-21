//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_DLC_Day60IcarusDropSlam extends X2Action
	config(Camera);

var config float START_CAM_HEIGHT;
var config float IMPACT_CAM_HEIGHT;

//Cached info for performing the action
//*************************************
var	protected CustomAnimParams				Params;

var protected XComGameStateHistory			History;
var protected XComGameStateContext_Ability	AbilityContext;
var protected XComGameState_Unit			UnitState, PartnerUnitState;
var protected XComUnitPawn					TargetPawn;
var protected String						AnimName;
var private Actor							PartnerVisualizer;
var private XComUnitPawn					PartnerUnitPawn;
var private vector                          StartingLocation;
var private float                           DistanceFromStartSquared;
var private float                           StopDistanceSquared; // distance from the origin of the slam past which we are done
var private vector                          UnitSlamLoc, UnitEndLoc, PartnerUnitEndLoc;
var private AnimNodeSequence                SourceAnim, TargetAnim;
var private float                           fFlySlamStopDistance;
var private bool                            bSourceSkipIK, bPartnerSkipIK;
var private name                            PartnerIdleAnimName;
var private float                           SlamCamImpactDisSq;
//*************************************

function Init()
{
	local XComWorldData WorldData;
	local X2Effect_Persistent OverridePersistentEffect;
	
	super.Init();

	History = `XCOMHISTORY;
	WorldData = `XWORLD;

	AbilityContext = XComGameStateContext_Ability(StateChangeContext);
	UnitState = XComGameState_Unit(Metadata.StateObject_NewState);

	// Save Partner info
	PartnerUnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
	PartnerVisualizer = PartnerUnitState.GetVisualizer();
	PartnerUnitPawn = XGUnit(PartnerVisualizer).GetPawn();
	PartnerUnitEndLoc = WorldData.GetPositionFromTileCoordinates(PartnerUnitState.TileLocation);
	PartnerUnitEndLoc.Z = PartnerUnitPawn.GetDesiredZForLocation(PartnerUnitEndLoc);
	bPartnerSkipIK = PartnerUnitPawn.bSkipIK;

	if( class'X2StatusEffects'.static.GetHighestEffectOnUnit(PartnerUnitState, OverridePersistentEffect, true) )
	{
		// There is a persistent effect with an override anim
		PartnerIdleAnimName = OverridePersistentEffect.CustomIdleOverrideAnim;
	}

	// Save Unit info
	UnitEndLoc = WorldData.GetPositionFromTileCoordinates(UnitState.TileLocation);
	UnitEndLoc.Z = Unit.GetDesiredZForLocation(UnitEndLoc);
	bSourceSkipIK = UnitPawn.bSkipIK;

	UnitSlamLoc.X = UnitPawn.Location.X;
	UnitSlamLoc.Y = UnitPawn.Location.Y;
	UnitSlamLoc.Z = UnitEndLoc.Z;

	fFlySlamStopDistance = UnitPawn.GetAnimTreeController().ComputeAnimationRMADistance('NO_IcarusDrop_FlySlamStop');

//	`SHAPEMGR.DrawSphere(UnitSlamLoc, vect(15,15,15), MakeLinearColor(1,0,0,1), true);
//	`SHAPEMGR.DrawSphere(UnitEndLoc, vect(15,15,15), MakeLinearColor(0,1,0,1), true);
}

function OnAnimNotify(AnimNotify ReceiveNotify)
{
	local XComAnimNotify_TriggerDecal DecalNotify;
	local vector StartLocation, EndLocation;
	local XComWorldData World;

	super.OnAnimNotify(ReceiveNotify);

	DecalNotify = XComAnimNotify_TriggerDecal(ReceiveNotify);
	if( DecalNotify != none )
	{	
		World = `XWORLD;

		StartLocation = UnitSlamLoc;
		StartLocation.Z += 0.5f;    // Offset by a bit to make sure we have an acutal travel direction
		EndLocation = UnitSlamLoc;
		EndLocation.Z = World.GetFloorZForPosition(EndLocation, false) - 0.5f;  // Offset by a bit to make sure we have an acutal travel direction

		Unit.AddDecalProjectile(StartLocation, EndLocation, AbilityContext);
	}
}

function bool CheckInterrupted()
{
	return false;
}

simulated state Executing
{
	function AnimNodeSequence PlaySlamStartAnim(XGUnit PlayOnUnit, XComUnitPawn PlayOnPawn)
	{
		PlayOnUnit.IdleStateMachine.PersistentEffectIdleName = '';
		PlayOnPawn.GetAnimTreeController().SetAllowNewAnimations(true);

		Params.AnimName = 'NO_IcarusDrop_FlySlamStart';

		return PlayOnPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);
	}

	function AnimNodeSequence PlayFlyStopAnim(XComUnitPawn PlayOnPawn, const out vector EndLocation, bool bStoredSkipIK, optional bool bHasDesiredEndingAtom=false)
	{
		// Possibly passed the ground
		PlayOnPawn.SnapToGround();
		PlayOnPawn.bSkipIK = bStoredSkipIK;

		Params = default.Params;
		Params.AnimName = 'NO_IcarusDrop_FlySlamStop';
		Params.BlendTime = 0.0f;

		if( bHasDesiredEndingAtom )
		{
			Params.DesiredEndingAtoms.Add(1);
			Params.DesiredEndingAtoms[0].Translation = EndLocation;
			Params.DesiredEndingAtoms[0].Rotation = QuatFromRotator(PlayOnPawn.Rotation);
			Params.DesiredEndingAtoms[0].Scale = 1.0f;
		}

		return PlayOnPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);
	}

Begin:
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	UnitPawn.bSkipIK = true;

	PartnerUnitPawn.EnableRMA(true, true);
	PartnerUnitPawn.EnableRMAInteractPhysics(true);
	PartnerUnitPawn.bSkipIK = true;

	`CAMERASTACK.OnCinescriptAnimNotify("SlamStart");

	PlaySlamStartAnim(Unit, UnitPawn);
	PlaySlamStartAnim(XGUnit(PartnerVisualizer), PartnerUnitPawn);

	// to protect against overshoot, rather than check the distance to the target, we check the distance from the source.
	// Otherwise it is possible to go from too far away in front of the target, to too far away on the other side
	StartingLocation = UnitPawn.Location;
	StopDistanceSquared = Square(VSize(UnitSlamLoc - StartingLocation) - fFlySlamStopDistance);
	SlamCamImpactDisSq = Square(VSize(UnitSlamLoc - StartingLocation) - default.IMPACT_CAM_HEIGHT);

	DistanceFromStartSquared = 0;

	// Loop on distance until we need to trigger to the impact cam cut
	while( DistanceFromStartSquared <= SlamCamImpactDisSq )
	{
		Sleep(0.0f);
		DistanceFromStartSquared = VSizeSq(UnitPawn.Location - StartingLocation);
		if(DistanceFromStartSquared > SlamCamImpactDisSq)
		{
			`CAMERASTACK.OnCinescriptAnimNotify("SlamImpact");
		}
	}

	while( DistanceFromStartSquared < StopDistanceSquared )
	{
		Sleep(0.0f);
		DistanceFromStartSquared = VSizeSq(UnitPawn.Location - StartingLocation);
	}

	SourceAnim = PlayFlyStopAnim(UnitPawn, UnitEndLoc, bSourceSkipIK, true);
	TargetAnim = PlayFlyStopAnim(PartnerUnitPawn, PartnerUnitEndLoc, bPartnerSkipIK);

	// Let the Target track run, showing the damage dealt/death
	// VISUALIZATION REWRITE - MESSAGE

	FinishAnim(TargetAnim);

	// Play the Target's Get Up anim
	Params = default.Params;
	Params.AnimName = 'HL_GetUp';
	Params.BlendTime = 0.0f;
	TargetAnim = PartnerUnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);
	PartnerUnitPawn.GetAnimTreeController().SetAllowNewAnimations(false);

	// Get up done, allow new anims again (if there is not an idle anim that needs to play)
	FinishAnim(TargetAnim);
	XGUnit(PartnerVisualizer).IdleStateMachine.PersistentEffectIdleName = PartnerIdleAnimName;
	PartnerUnitPawn.GetAnimTreeController().SetAllowNewAnimations(PartnerIdleAnimName == '');

	// Let the Target track run the rest of its actions
	// VISUALIZATION REWRITE - MESSAGE

	// The Archon's slam stop anims should completely finish
	FinishAnim(SourceAnim);

	CompleteAction();
}

event bool BlocksAbilityActivation()
{
	return true;
}

DefaultProperties
{
}
