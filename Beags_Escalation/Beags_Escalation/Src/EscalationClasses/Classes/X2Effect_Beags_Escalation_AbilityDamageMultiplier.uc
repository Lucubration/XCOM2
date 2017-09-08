class X2Effect_Beags_Escalation_AbilityDamageMultiplier extends X2Effect_Persistent;

var array<name> AbilityNames;
var float DamageMultiplier;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local float ExtraDamage;

	if (AbilityNames.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
	{
		ExtraDamage = FFloor(float(CurrentDamage) * class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.FlushDamageMultiplier);

		if (CurrentDamage + ExtraDamage < 1)
			ExtraDamage = 1 - CurrentDamage;
	}

	return int(ExtraDamage);
}