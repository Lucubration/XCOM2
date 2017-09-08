class X2Effect_ManualOverride extends X2Effect;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local XComGameState_Ability AbilityState;
	local int i;

	History = `XCOMHISTORY;
	UnitState = XComGameState_Unit(kNewTargetState);
	for (i = 0; i < UnitState.Abilities.Length; ++i)
	{
		AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(UnitState.Abilities[i].ObjectID));
		if (AbilityState != none && AbilityState.iCooldown > 0)
		{
			AbilityState = XComGameState_Ability(NewGameState.ModifyStateObject(AbilityState.Class, AbilityState.ObjectID));
			AbilityState.iCooldown--;
		}
	}
}