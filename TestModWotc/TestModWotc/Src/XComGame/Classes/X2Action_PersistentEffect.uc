//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_PersistentEffect extends X2Action;

var private CustomAnimParams	Params;
var Name						IdleAnimName, AnimName;

function Init()
{
	local XComGameState_Unit UnitState;
	local X2Effect_Persistent OverridePersistentEffect;
	local XComGameStateHistory History;

	super.Init();

	History = `XCOMHISTORY;

	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(Metadata.StateObject_NewState.ObjectID, eReturnType_Reference, StateChangeContext.AssociatedState.HistoryIndex));

	AnimName = IdleAnimName;
	if( class'X2StatusEffects'.static.GetHighestEffectOnUnit(UnitState, OverridePersistentEffect, true) )
	{
		// There is a persistent effect with higher importance, use that override anim instead
		AnimName = OverridePersistentEffect.CustomIdleOverrideAnim;
	}

}
simulated state Executing
{
Begin:
	Unit.IdleStateMachine.PersistentEffectIdleName = AnimName;
	UnitPawn.GetAnimTreeController().SetAllowNewAnimations(AnimName == '');

	CompleteAction();
}

event bool BlocksAbilityActivation()
{
	return false;
}