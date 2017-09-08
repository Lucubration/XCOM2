class X2Effect_Beags_Escalation_Assassinate extends X2Effect_Persistent;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_Beags_Escalation_Effect_Assassinate AssassinateEffectState;
	local X2EventManager EventMgr;
	local Object ListenerObj;

	if (GetAssassinateComponent(NewEffectState) == none)
	{
		TargetUnit = XComGameState_Unit(kNewTargetState);

		// Create component and attach it to GameState_Effect, adding the new state object to the NewGameState container
		AssassinateEffectState = XComGameState_Beags_Escalation_Effect_Assassinate(NewGameState.CreateStateObject(class'XComGameState_Beags_Escalation_Effect_Assassinate'));
		AssassinateEffectState.UnitRef = TargetUnit.GetReference();
		NewEffectState.AddComponentObject(AssassinateEffectState);
		NewGameState.AddStateObject(AssassinateEffectState);
	
		EventMgr = `XEVENTMGR;
	
		// The gamestate component should handle the callback
		ListenerObj = AssassinateEffectState;

		// This callback will intercept the unit's AbilityActivated notifications...
		EventMgr.RegisterForEvent(ListenerObj, 'AbilityActivated', AssassinateEffectState.OnAbilityActivated, ELD_OnStateSubmitted, , TargetUnit);
		// ... which is good because the unit is no longer receiving them, itself. Our callback will pass on the message if-and-when we want
		// the unit to break concealment
		EventMgr.UnRegisterFromEvent(TargetUnit, 'AbilityActivated');

		// Some missions the effect will be removed (e.g. extraction), some missions the tactical gameplay just stops. We'll GC our gamestate
		// by having the gamestate itself handle this callback
		EventMgr.RegisterForEvent(ListenerObj, 'TacticalGameEnd', AssassinateEffectState.OnTacticalGameEnd, ELD_OnStateSubmitted);

		`LOG("Beags Escalation: Assassinate passive effect registered for events.");
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

static function XComGameState_Beags_Escalation_Effect_Assassinate GetAssassinateComponent(XComGameState_Effect Effect)
{
    if (Effect != none) 
        return XComGameState_Beags_Escalation_Effect_Assassinate(Effect.FindComponentObject(class'XComGameState_Beags_Escalation_Effect_Assassinate'));
    return none;
}
