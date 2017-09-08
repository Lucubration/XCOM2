//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_ViperBindEnd extends X2Action;

var StateObjectReference                    PartnerUnitRef;

//Cached info for performing the action
//*************************************
var private CustomAnimParams				Params;
var private XComGameState_Unit				UnitState, PartnerUnitState;
var private Vector							DesiredLocation;
var private XGUnit				            PartnerVisualizer;
var private XComUnitPawn		            PartnerUnitPawn;
var private bool                            bUnitIsAliveAndConcious, bPartnerIsAliveAndConcious;
var private bool                            bUnitIsAlive, bPartnerIsAlive; // deprecated
var private AnimNodeSequence	            UnitAnimSeq, PartnerAnimSeq;
//*************************************

function Init()
{
	local XComGameStateHistory History;

	super.Init();

	History = `XCOMHISTORY;

	UnitState = Unit.GetVisualizedGameState(CurrentHistoryIndex);

	`assert(PartnerUnitRef.ObjectID != 0);

	PartnerVisualizer = XGUnit(History.GetVisualizer(PartnerUnitRef.ObjectID));
	PartnerUnitPawn = PartnerVisualizer.GetPawn();
	PartnerUnitState = PartnerVisualizer.GetVisualizedGameState(CurrentHistoryIndex);

	bUnitIsAliveAndConcious = UnitState.IsAlive() && !UnitState.IsUnconscious() && !UnitState.IsBleedingOut();
	bPartnerIsAliveAndConcious = PartnerUnitState.IsAlive() && !PartnerUnitState.IsUnconscious() && !PartnerUnitState.IsBleedingOut();
}

simulated state Executing
{
	function AnimNodeSequence EndBind(XComGameState_Unit PlayOnGameStateUnit, XGUnit PlayOnUnit, XComUnitPawn PlayOnPawn)
	{
		PlayOnPawn.EnableRMA(true,true);
		PlayOnPawn.EnableRMAInteractPhysics(true);

		Params = default.Params;
		Params.AnimName = 'NO_BindStop';
		DesiredLocation = `XWORLD.GetPositionFromTileCoordinates(PlayOnGameStateUnit.TileLocation);
	
		// Set Z so our feet are on the ground
		DesiredLocation.Z = PlayOnUnit.GetDesiredZForLocation(DesiredLocation);
		Params.DesiredEndingAtoms.Add(1);
		Params.DesiredEndingAtoms[0].Translation = DesiredLocation;
		Params.DesiredEndingAtoms[0].Rotation = QuatFromRotator(PlayOnPawn.Rotation);
		Params.DesiredEndingAtoms[0].Scale = 1.0f;

		PlayOnUnit.IdleStateMachine.PersistentEffectIdleName = '';
		PlayOnPawn.GetAnimTreeController().SetAllowNewAnimations(true);
		return PlayOnPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);
	}

Begin:

	if( bUnitIsAliveAndConcious )
	{
		UnitAnimSeq = EndBind(UnitState, Unit, UnitPawn);
	}

	if( bPartnerIsAliveAndConcious )
	{
		PartnerAnimSeq = EndBind(PartnerUnitState, PartnerVisualizer, PartnerUnitPawn);
	}

	FinishAnim(UnitAnimSeq);
	FinishAnim(PartnerAnimSeq);
	
	UnitPawn.bSkipIK = false;
	PartnerUnitPawn.bSkipIK = false;

	CompleteAction();
}

event bool BlocksAbilityActivation()
{
	return true;
}