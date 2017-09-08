class X2Effect_Lucu_Sniper_InTheZone extends X2Effect_Persistent;

var int InTheZoneEventPriority;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_Effect_Lucu_Sniper_InTheZone InTheZoneEffectState;
	local X2EventManager EventMgr;
	local Object ListenerObj;

	if (GetInTheZoneComponent(NewEffectState) == none)
	{
		TargetUnit = XComGameState_Unit(kNewTargetState);

		// Create component and attach it to GameState_Effect, adding the new state object to the NewGameState container
		InTheZoneEffectState = XComGameState_Effect_Lucu_Sniper_InTheZone(NewGameState.CreateStateObject(class'XComGameState_Effect_Lucu_Sniper_InTheZone'));
		InTheZoneEffectState.UnitRef = TargetUnit.GetReference();
		NewEffectState.AddComponentObject(InTheZoneEffectState);
		NewGameState.AddStateObject(InTheZoneEffectState);
	
		EventMgr = `XEVENTMGR;
	
		// The gamestate component should handle the callback
		ListenerObj = InTheZoneEffectState;

		// This callback will handle restoring action points if the dead unit was killed by the target of this effect
		EventMgr.RegisterForEvent(ListenerObj, 'AbilityActivated', InTheZoneEffectState.OnAbilityActivated, ELD_OnStateSubmitted, default.InTheZoneEventPriority, TargetUnit);

		// Some missions the effect will be removed (e.g. extraction), some missions the tactical gameplay just stops. We'll GC our gamestate
		// by having the gamestate itself handle this callback
		EventMgr.RegisterForEvent(ListenerObj, 'TacticalGameEnd', InTheZoneEffectState.OnTacticalGameEnd, ELD_OnStateSubmitted);

		`LOG("Lucubration Sniper Class: In The Zone passive effect registered for events.");
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

static function XComGameState_Effect_Lucu_Sniper_InTheZone GetInTheZoneComponent(XComGameState_Effect Effect)
{
    if (Effect != none) 
        return XComGameState_Effect_Lucu_Sniper_InTheZone(Effect.FindComponentObject(class'XComGameState_Effect_Lucu_Sniper_InTheZone'));
    return none;
}

DefaultProperties
{
	// This higher priority for In the Zone should ensure that it is processed before effects such as Hit and Run, which has limited uses
	InTheZoneEventPriority=55
}