class X2Effect_Beags_Escalation_WeaponsTeam extends X2Effect_Beags_Escalation_RocketRangeModifySnapshot;

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	if (AbilityContext.InputContext.MovementPaths[0].MovementTiles.Length > 0)
	{
		// If the unit moved for any reason, remove this effect
		EffectState.RemoveEffect(NewGameState, NewGameState);
	}

	return false;
}
