class X2Effect_Lucu_Garage_AbsorptionField extends X2Effect_Persistent;

var float DamageModifier;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect)
{
	return int(float(CurrentDamage) * DamageModifier);
}
