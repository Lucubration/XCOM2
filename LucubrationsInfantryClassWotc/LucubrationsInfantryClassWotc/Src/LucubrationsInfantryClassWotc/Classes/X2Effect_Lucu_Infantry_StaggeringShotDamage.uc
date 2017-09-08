class X2Effect_Lucu_Infantry_StaggeringShotDamage extends X2Effect_Persistent
	config(LucubrationsInfantryClassWotc);

var config float DamageMultiplier;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local float ExtraDamage;

	if (AbilityState.GetMyTemplateName() == 'Lucu_Infantry_StaggeringShot')
	{
		ExtraDamage = float(CurrentDamage) * DamageMultiplier;

		if (CurrentDamage + ExtraDamage < 1)
			ExtraDamage = 1 - CurrentDamage;

		//`LOG("Lucubration Infantry Class: Calculated Staggering Shot damage modifier=" @ string(ExtraDamage) @ " (base=" @ string(CurrentDamage) @ " * mult=" @ string(DamageMultiplier) @ ", min=" @ string(1 - CurrentDamage) @ ").");
	}
	else
	{
		//`LOG("Lucubration Infantry Class: Calculated Staggering Shot damage modifier not applied.");
	}

	return int(ExtraDamage);
}