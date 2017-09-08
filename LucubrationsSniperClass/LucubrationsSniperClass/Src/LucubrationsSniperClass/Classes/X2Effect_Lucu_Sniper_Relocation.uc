class X2Effect_Lucu_Sniper_Relocation extends X2Effect_PersistentStatChange;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_Effect_Lucu_Sniper_Relocation RelocationEffectState;
	local X2EventManager EventMgr;
	local Object ListenerObj;

	if (GetRelocationComponent(NewEffectState) == none)
	{
		TargetUnit = XComGameState_Unit(kNewTargetState);

		// Create component and attach it to GameState_Effect, adding the new state object to the NewGameState container
		RelocationEffectState = XComGameState_Effect_Lucu_Sniper_Relocation(NewGameState.CreateStateObject(class'XComGameState_Effect_Lucu_Sniper_Relocation'));
		RelocationEffectState.UnitRef = TargetUnit.GetReference();
		NewEffectState.AddComponentObject(RelocationEffectState);
		NewGameState.AddStateObject(RelocationEffectState);

		EventMgr = `XEVENTMGR;
	
		// The gamestate component should handle the callback
		ListenerObj = RelocationEffectState;
	
		EventMgr.RegisterForEvent(ListenerObj, 'AbilityActivated', RelocationEffectState.OnAbilityActivated, ELD_OnStateSubmitted);
		
		// Some missions the effect will be removed (e.g. extraction), some missions the tactical gameplay just stops. We'll GC our gamestate
		// by having the gamestate itself handle this callback
		EventMgr.RegisterForEvent(ListenerObj, 'TacticalGameEnd', RelocationEffectState.OnTacticalGameEnd, ELD_OnStateSubmitted);

		`LOG("Lucubration Sniper Class: Relocation passive effect registered for events.");
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

static function XComGameState_Effect_Lucu_Sniper_Relocation GetRelocationComponent(XComGameState_Effect Effect)
{
    if (Effect != none) 
        return XComGameState_Effect_Lucu_Sniper_Relocation(Effect.FindComponentObject(class'XComGameState_Effect_Lucu_Sniper_Relocation'));
    return none;
}