class X2Effect_Lucu_Sniper_ZeroIn extends X2Effect_PersistentStatChange;

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	// Moving or attacking will cancel the bonus
	if (AbilityContext.InputContext.MovementPaths[0].MovementTiles.Length > 0 || kAbility.GetMyTemplate().Hostility == eHostility_Offensive)
	{
		EffectState.RemoveEffect(NewGameState, NewGameState);
	}

	return false;
}
