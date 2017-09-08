class X2Effect_Beags_Escalation_FlushDamage extends X2Effect_Persistent
	config(Beags_Escalation_Ability);

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage)
{
	local float ExtraDamage;

	if (AbilityState.GetMyTemplateName() == class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.FlushAbilityName)
	{
		ExtraDamage = FFloor(float(CurrentDamage) * class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.FlushDamageMultiplier);

		if (CurrentDamage + ExtraDamage < 1)
			ExtraDamage = 1 - CurrentDamage;
	}

	return int(ExtraDamage);
}