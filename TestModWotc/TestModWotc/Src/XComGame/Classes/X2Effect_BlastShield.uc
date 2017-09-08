class X2Effect_BlastShield extends X2Effect_Persistent;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local array<name> IncomingTypes;
	local name ImmuneType;

	WeaponDamageEffect.GetEffectDamageTypes(NewGameState, AppliedData, IncomingTypes);

	foreach class'X2Ability_Chosen'.default.CHOSEN_IMMUNE_EXPLOSION_DMG_TYPES(ImmuneType)
	{
		if (IncomingTypes.Find(ImmuneType) != INDEX_NONE)
			return -CurrentDamage;
	}
	
	return 0;
}

function int ModifyDamageFromDestructible(XComGameState_Destructible DestructibleState, int IncomingDamage, XComGameState_Unit TargetUnit, XComGameState_Effect EffectState)
{
	//	destructible damage is always considered to be explosive
	return -IncomingDamage;
}

DefaultProperties
{
	bDisplayInSpecialDamageMessageUI=true
}