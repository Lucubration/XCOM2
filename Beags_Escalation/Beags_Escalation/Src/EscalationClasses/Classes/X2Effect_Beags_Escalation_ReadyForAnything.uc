// This class is the passive effect that sets up the listener for ability activation
class X2Effect_Beags_Escalation_ReadyForAnything extends X2Effect_Persistent;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_Player PlayerState;
	local XComGameState_Beags_Escalation_Effect_ReadyForAnything ReadyForAnythingEffectState;
	local X2EventManager EventMgr;
	local Object ListenerObj;

	if (GetReadyForAnythingComponent(NewEffectState) == none)
	{
		TargetUnit = XComGameState_Unit(kNewTargetState);

		// Create component and attach it to GameState_Effect, adding the new state object to the NewGameState container
		ReadyForAnythingEffectState = XComGameState_Beags_Escalation_Effect_ReadyForAnything(NewGameState.CreateStateObject(class'XComGameState_Beags_Escalation_Effect_ReadyForAnything'));
		ReadyForAnythingEffectState.UnitRef = TargetUnit.GetReference();
		NewEffectState.AddComponentObject(ReadyForAnythingEffectState);
		NewGameState.AddStateObject(ReadyForAnythingEffectState);

		EventMgr = `XEVENTMGR;
	
		// The gamestate component should handle the callback
		ListenerObj = ReadyForAnythingEffectState;

		PlayerState = XComGameState_Player(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.PlayerStateObjectRef.ObjectID));

		// This event should handle the case where the unit spends all of their action points during their turn	
		EventMgr.RegisterForEvent(ListenerObj, 'AbilityActivated', ReadyForAnythingEffectState.OnAbilityActivated, ELD_OnStateSubmitted, , TargetUnit);
		// This event should handle the case where the unit doesn't spend all of their action points during their turn
		EventMgr.RegisterForEvent(ListenerObj, 'PlayerTurnEnded', ReadyForAnythingEffectState.OnPlayerTurnEnded, ELD_OnStateSubmitted, , PlayerState);

		// Some missions the effect will be removed (e.g. extraction), some missions the tactical gameplay just stops. We'll GC our gamestate
		// by having the gamestate itself handle this callback
		EventMgr.RegisterForEvent(ListenerObj, 'TacticalGameEnd', ReadyForAnythingEffectState.OnTacticalGameEnd, ELD_OnStateSubmitted);

		`LOG("Beags Escalation: Ready for Anything passive effect registered for events.");
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

static function XComGameState_Beags_Escalation_Effect_ReadyForAnything GetReadyForAnythingComponent(XComGameState_Effect Effect)
{
    if (Effect != none) 
        return XComGameState_Beags_Escalation_Effect_ReadyForAnything(Effect.FindComponentObject(class'XComGameState_Beags_Escalation_Effect_ReadyForAnything'));
    return none;
}
