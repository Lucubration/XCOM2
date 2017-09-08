// This is the more powerful version of Cool Under Pressure from Long War called Opportunist, which eliminates the reaction fire aim penalty completely.
// We're not currently using it because it's probably a little too powerful
class X2Effect_Lucu_Infantry_Opportunist extends X2Effect_Persistent;

function bool AllowReactionFireCrit(XComGameState_Unit UnitState, XComGameState_Unit TargetState) 
{
	// Indicate that reaction fire is allowed to crit
	return true;
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	// Check if this is an overwatch ability
	if (kAbility.GetMyTemplate().DataName == 'Overwatch' || kAbility.GetMyTemplate().DataName == 'PistolOverwatch' || kAbility.GetMyTemplate().DataName == 'SniperRifleOverwatch' || kAbility.GetMyTemplate().DataName == 'LongWatch')
	{
		//`LOG("Lucubration Infantry Class: Opportunist 'PostAbilityCostPaid' override called for overwatch ability " @ kAbility.GetMyTemplate().DataName @ ".");

		// Set unit value to indicate we're "in concealment", which will prevent the reaction fire aim reduction from applying
		SourceUnit.SetUnitFloatValue(class'X2Ability_DefaultAbilitySet'.default.ConcealedOverwatchTurn, 1, eCleanup_BeginTurn);
	}
	return false;
}
