class X2Effect_Lucu_Infantry_EstablishedDefensesArmorBonus extends X2Effect_BonusArmor;

function int GetArmorChance(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
	return 100;
}

function int GetArmorMitigation(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
	// The new stacking armor method will just apply multiple of these effects as required to provide multiple points of armor
	return 1;
}
