class X2Effect_Beags_Escalation_Reaper extends X2Effect_Persistent;

var int ReaperEventPriority;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_Beags_Escalation_Effect_Reaper ReaperEffectState;
	local X2EventManager EventMgr;
	local Object ListenerObj;

	if (GetReaperComponent(NewEffectState) == none)
	{
		TargetUnit = XComGameState_Unit(kNewTargetState);

		// Create component and attach it to GameState_Effect, adding the new state object to the NewGameState container
		ReaperEffectState = XComGameState_Beags_Escalation_Effect_Reaper(NewGameState.CreateStateObject(class'XComGameState_Beags_Escalation_Effect_Reaper'));
		ReaperEffectState.UnitRef = TargetUnit.GetReference();
		NewEffectState.AddComponentObject(ReaperEffectState);
		NewGameState.AddStateObject(ReaperEffectState);
	
		EventMgr = `XEVENTMGR;
	
		// The gamestate component should handle the callback
		ListenerObj = ReaperEffectState;

		// This callback will handle restoring action points if the dead unit was killed by the target of this effect
		//EventMgr.RegisterForEvent(ListenerObj, 'UnitDied', ReaperEffectState.OnUnitDied, ELD_OnStateSubmitted, default.ReaperEventPriority);
		EventMgr.RegisterForEvent(ListenerObj, 'AbilityActivated', ReaperEffectState.OnAbilityActivated, ELD_OnStateSubmitted, default.ReaperEventPriority, TargetUnit);

		// Some missions the effect will be removed (e.g. extraction), some missions the tactical gameplay just stops. We'll GC our gamestate
		// by having the gamestate itself handle this callback
		EventMgr.RegisterForEvent(ListenerObj, 'TacticalGameEnd', ReaperEffectState.OnTacticalGameEnd, ELD_OnStateSubmitted);

		`LOG("Beags Escalation: Reaper passive effect registered for events.");
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

static function XComGameState_Beags_Escalation_Effect_Reaper GetReaperComponent(XComGameState_Effect Effect)
{
    if (Effect != none) 
        return XComGameState_Beags_Escalation_Effect_Reaper(Effect.FindComponentObject(class'XComGameState_Beags_Escalation_Effect_Reaper'));
    return none;
}

DefaultProperties
{
	// This higher priority for Reaper should ensure that it is processed before effects such as Hit and Run, which has limited uses
	ReaperEventPriority=55
}