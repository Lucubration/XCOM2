class X2Effect_Oblivious extends X2Effect_Persistent;

var float DmgMod;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	if (Attacker.IsConcealed())
	{
		return CurrentDamage * DmgMod;
	}

	return 0;
}