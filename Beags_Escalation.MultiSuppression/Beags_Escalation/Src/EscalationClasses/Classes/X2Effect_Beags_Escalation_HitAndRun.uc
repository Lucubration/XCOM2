class X2Effect_Beags_Escalation_HitAndRun extends X2Effect_Persistent;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'Beags_Escalation_HitAndRunTriggered', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_Beags_Escalation_Effect_HitAndRun HitAndRunEffectState;
	local X2EventManager EventMgr;
	local Object ListenerObj;

	if (GetHitAndRunComponent(NewEffectState) == none)
	{
		TargetUnit = XComGameState_Unit(kNewTargetState);

		// Create component and attach it to GameState_Effect, adding the new state object to the NewGameState container
		HitAndRunEffectState = XComGameState_Beags_Escalation_Effect_HitAndRun(NewGameState.CreateStateObject(class'XComGameState_Beags_Escalation_Effect_HitAndRun'));
		HitAndRunEffectState.UnitRef = TargetUnit.GetReference();
		NewEffectState.AddComponentObject(HitAndRunEffectState);
		NewGameState.AddStateObject(HitAndRunEffectState);
	
		EventMgr = `XEVENTMGR;
	
		// The gamestate component should handle the callback
		ListenerObj = HitAndRunEffectState;

		// This callback will handle restoring action points if the target was flanked or uncovered
		EventMgr.RegisterForEvent(ListenerObj, 'AbilityActivated', HitAndRunEffectState.OnAbilityActivated, ELD_OnStateSubmitted, , TargetUnit);

		// Some missions the effect will be removed (e.g. extraction), some missions the tactical gameplay just stops. We'll GC our gamestate
		// by having the gamestate itself handle this callback
		EventMgr.RegisterForEvent(ListenerObj, 'TacticalGameEnd', HitAndRunEffectState.OnTacticalGameEnd, ELD_OnStateSubmitted);

		`LOG("Beags Escalation: HitAndRun passive effect registered for events.");
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

static function XComGameState_Beags_Escalation_Effect_HitAndRun GetHitAndRunComponent(XComGameState_Effect Effect)
{
    if (Effect != none) 
        return XComGameState_Beags_Escalation_Effect_HitAndRun(Effect.FindComponentObject(class'XComGameState_Beags_Escalation_Effect_HitAndRun'));
    return none;
}
