// This is the old passive Escape and Evade effect. It has been replaced by the active effect
class X2Effect_EscapeAndEvade extends X2Effect_PersistentStatChange;

var name AbilityToActivate;
var name ActionPointName;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_Effect_EscapeAndEvade EscapeAndEvadeEffectState;
	local X2EventManager EventMgr;
	local Object ListenerObj;

	if (GetEscapeAndEvadeComponent(NewEffectState) == none)
	{
		TargetUnit = XComGameState_Unit(kNewTargetState);

		// Create component and attach it to GameState_Effect, adding the new state object to the NewGameState container
		EscapeAndEvadeEffectState = XComGameState_Effect_EscapeAndEvade(NewGameState.CreateStateObject(class'XComGameState_Effect_EscapeAndEvade'));
		EscapeAndEvadeEffectState.AbilityToActivate = AbilityToActivate;
		EscapeAndEvadeEffectState.ActionPointName = ActionPointName;
		EscapeAndEvadeEffectState.UnitRef = TargetUnit.GetReference();
		NewEffectState.AddComponentObject(EscapeAndEvadeEffectState);
		NewGameState.AddStateObject(EscapeAndEvadeEffectState);

		EventMgr = `XEVENTMGR;
	
		// The gamestate component should handle the callback
		ListenerObj = EscapeAndEvadeEffectState;
	
		EventMgr.RegisterForEvent(ListenerObj, 'AbilityActivated', class'XComGameState_Effect_EscapeAndEvade'.static.OnAbilityActivated, ELD_OnStateSubmitted);
		
		// Some missions the effect will be removed (e.g. extraction), some missions the tactical gameplay just stops. We'll GC our gamestate
		// by having the gamestate itself handle this callback
		EventMgr.RegisterForEvent(ListenerObj, 'TacticalGameEnd', class'XComGameState_Effect_EscapeAndEvade'.static.OnTacticalGameEnd, ELD_OnStateSubmitted);

		`LOG("Lucubration Infantry Class: Escape and Evade passive effect registered for events.");
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

static function XComGameState_Effect_EscapeAndEvade GetEscapeAndEvadeComponent(XComGameState_Effect Effect)
{
    if (Effect != none) 
        return XComGameState_Effect_EscapeAndEvade(Effect.FindComponentObject(class'XComGameState_Effect_EscapeAndEvade'));
    return none;
}