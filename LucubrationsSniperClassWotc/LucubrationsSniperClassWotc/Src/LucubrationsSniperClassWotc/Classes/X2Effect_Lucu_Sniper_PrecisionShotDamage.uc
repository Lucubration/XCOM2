class X2Effect_Lucu_Sniper_PrecisionShotDamage extends X2Effect_Persistent;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Item SourceWeapon;
	local int ExtraDamage;
	
	if (AbilityState.GetMyTemplateName() == class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.PrecisionShotAbilityName)
	{
		SourceWeapon = AbilityState.GetSourceWeapon();
		if (SourceWeapon != none)
			ExtraDamage = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.PrecisionShotDamageBonus[SourceWeapon.GetMyTemplate().Tier];
	}

	return ExtraDamage;
}