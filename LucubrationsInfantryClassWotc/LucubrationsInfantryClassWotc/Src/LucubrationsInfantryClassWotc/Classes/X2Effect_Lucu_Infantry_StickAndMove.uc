// This class is the passive effect that sets up the listener for attacks that trigger the Stick and Move active effect
class X2Effect_Lucu_Infantry_StickAndMove extends X2Effect_Persistent
	config(LucubrationsInfantryClassWotc);

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_Lucu_Infantry_Effect_StickAndMove StickAndMoveEffectState;
	local X2EventManager EventMgr;
	local Object ListenerObj;

	if (GetStickAndMoveComponent(NewEffectState) == none)
	{
		TargetUnit = XComGameState_Unit(kNewTargetState);

		// Create component and attach it to GameState_Effect, adding the new state object to the NewGameState container
		StickAndMoveEffectState = XComGameState_Lucu_Infantry_Effect_StickAndMove(NewGameState.CreateStateObject(class'XComGameState_Lucu_Infantry_Effect_StickAndMove'));
		StickAndMoveEffectState.UnitRef = TargetUnit.GetReference();
		NewEffectState.AddComponentObject(StickAndMoveEffectState);
		NewGameState.AddStateObject(StickAndMoveEffectState);
	
		EventMgr = `XEVENTMGR;
	
		// The gamestate component should handle the callback
		ListenerObj = StickAndMoveEffectState;

		EventMgr.RegisterForEvent(ListenerObj, 'AbilityActivated', class'XComGameState_Lucu_Infantry_Effect_StickAndMove'.static.OnAbilityActivated, ELD_OnStateSubmitted);
		EventMgr.RegisterForEvent(ListenerObj, 'UnitMoveFinished', class'XComGameState_Lucu_Infantry_Effect_StickAndMove'.static.OnUnitMoveFinished, ELD_OnStateSubmitted);

		// Some missions the effect will be removed (e.g. extraction), some missions the tactical gameplay just stops. We'll GC our gamestate
		// by having the gamestate itself handle this callback
		EventMgr.RegisterForEvent(ListenerObj, 'TacticalGameEnd', class'XComGameState_Lucu_Infantry_Effect_StickAndMove'.static.OnTacticalGameEnd, ELD_OnStateSubmitted);

		`LOG("Lucubration Infantry Class: Stick and Move passive effect registered for events.");
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

static function XComGameState_Lucu_Infantry_Effect_StickAndMove GetStickAndMoveComponent(XComGameState_Effect Effect)
{
    if (Effect != none) 
        return XComGameState_Lucu_Infantry_Effect_StickAndMove(Effect.FindComponentObject(class'XComGameState_Lucu_Infantry_Effect_StickAndMove'));
    return none;
}