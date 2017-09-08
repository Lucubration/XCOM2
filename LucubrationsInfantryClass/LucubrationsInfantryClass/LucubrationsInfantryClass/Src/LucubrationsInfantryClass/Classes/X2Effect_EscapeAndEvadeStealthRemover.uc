class X2Effect_EscapeAndEvadeStealthRemover extends X2Effect_PersistentStatChange;

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_Unit UnitState;

	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

	// Find the unit losing this effect
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (UnitState != none)
	{
		// Break concealment when this effect is removed
		`XEVENTMGR.TriggerEvent('EffectBreakUnitConcealment', UnitState, UnitState, NewGameState);

		//`LOG("Lucubration Infantry Class: Escape and Evade Stealth remover effect broke concealment on unit " @ UnitState.GetFullName() @ ".");
	}
}

DefaultProperties
{
	EffectName = "EscapeAndEvadeStealthRemover"
}