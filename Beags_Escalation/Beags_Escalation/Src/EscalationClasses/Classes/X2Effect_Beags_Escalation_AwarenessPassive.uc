class X2Effect_Beags_Escalation_AwarenessPassive extends X2Effect_Persistent;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_Beags_Escalation_Effect_AwarenessPassive AwarenessPassiveEffectState;
	local X2EventManager EventMgr;
	local Object ListenerObj;

	if (GetAwarenessPassiveComponent(NewEffectState) == none)
	{
		TargetUnit = XComGameState_Unit(kNewTargetState);

		// Create component and attach it to GameState_Effect, adding the new state object to the NewGameState container
		AwarenessPassiveEffectState = XComGameState_Beags_Escalation_Effect_AwarenessPassive(NewGameState.CreateStateObject(class'XComGameState_Beags_Escalation_Effect_AwarenessPassive'));
		AwarenessPassiveEffectState.UnitRef = TargetUnit.GetReference();
		NewEffectState.AddComponentObject(AwarenessPassiveEffectState);
		NewGameState.AddStateObject(AwarenessPassiveEffectState);
	
		EventMgr = `XEVENTMGR;
	
		// The gamestate component should handle the callback
		ListenerObj = AwarenessPassiveEffectState;

		// This callback will handle removing the active effects created by the passive effect's target
		EventMgr.RegisterForEvent(ListenerObj, 'ObjectMoved', AwarenessPassiveEffectState.OnObjectMoved, ELD_OnStateSubmitted, , TargetUnit);
		// This callback will handle removing the active effects caused by changes in visibility due to non-move action. It's much more
		// broad-scope than it needs to be, but I can't think of any more discrete way of doing it
		EventMgr.RegisterForEvent(ListenerObj, 'AbilityActivated', AwarenessPassiveEffectState.OnAbilityActivated, ELD_OnVisualizationBlockCompleted);

		// Some missions the effect will be removed (e.g. extraction), some missions the tactical gameplay just stops. We'll GC our gamestate
		// by having the gamestate itself handle this callback
		EventMgr.RegisterForEvent(ListenerObj, 'TacticalGameEnd', AwarenessPassiveEffectState.OnTacticalGameEnd, ELD_OnStateSubmitted);

		`LOG("Beags Escalation: Awareness passive effect registered for events.");
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

static function XComGameState_Beags_Escalation_Effect_AwarenessPassive GetAwarenessPassiveComponent(XComGameState_Effect Effect)
{
    if (Effect != none) 
        return XComGameState_Beags_Escalation_Effect_AwarenessPassive(Effect.FindComponentObject(class'XComGameState_Beags_Escalation_Effect_AwarenessPassive'));
    return none;
}
