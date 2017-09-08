class X2Effect_Beags_Escalation_FireSuperiority extends X2Effect_Persistent;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_Beags_Escalation_Effect_FireSuperiority FireSuperiorityEffectState;
	local X2EventManager EventMgr;
	local Object ListenerObj;

	if (GetFireSuperiorityComponent(NewEffectState) == none)
	{
		TargetUnit = XComGameState_Unit(kNewTargetState);

		// Create component and attach it to GameState_Effect, adding the new state object to the NewGameState container
		FireSuperiorityEffectState = XComGameState_Beags_Escalation_Effect_FireSuperiority(NewGameState.CreateStateObject(class'XComGameState_Beags_Escalation_Effect_FireSuperiority'));
		FireSuperiorityEffectState.UnitRef = TargetUnit.GetReference();
		NewEffectState.AddComponentObject(FireSuperiorityEffectState);
		NewGameState.AddStateObject(FireSuperiorityEffectState);
	
		EventMgr = `XEVENTMGR;
	
		// The gamestate component should handle the callback
		ListenerObj = FireSuperiorityEffectState;

		// This callback will handle restoring action points if the dead unit was killed by the target of this effect
		EventMgr.RegisterForEvent(ListenerObj, 'AbilityActivated', FireSuperiorityEffectState.OnAbilityActivated, ELD_OnStateSubmitted);

		// Some missions the effect will be removed (e.g. extraction), some missions the tactical gameplay just stops. We'll GC our gamestate
		// by having the gamestate itself handle this callback
		EventMgr.RegisterForEvent(ListenerObj, 'TacticalGameEnd', FireSuperiorityEffectState.OnTacticalGameEnd, ELD_OnStateSubmitted);

		`LOG("Beags Escalation: Fire Superiority passive effect registered for events.");
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

static function XComGameState_Beags_Escalation_Effect_FireSuperiority GetFireSuperiorityComponent(XComGameState_Effect Effect)
{
    if (Effect != none) 
        return XComGameState_Beags_Escalation_Effect_FireSuperiority(Effect.FindComponentObject(class'XComGameState_Beags_Escalation_Effect_FireSuperiority'));
    return none;
}
