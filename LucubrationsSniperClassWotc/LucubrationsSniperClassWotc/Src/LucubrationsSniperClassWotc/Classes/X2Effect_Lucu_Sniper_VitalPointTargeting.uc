class X2Effect_Lucu_Sniper_VitalPointTargeting extends X2Effect_Persistent;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Item SourceWeapon;
	local int ExtraDamage, Tier;
	
	if (AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
	{
		SourceWeapon = AbilityState.GetSourceWeapon();
		if (SourceWeapon != none)
        {
            Tier = SourceWeapon.GetMyTemplate().Tier;
            // Some custom weapons seem to have really outlandish weapon tiers. Always give them the average damage bonus?
            if (Tier >= class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.VitalPointTargetingDamageBonus.Length)
            {
                Tier = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.VitalPointTargetingDamageBonus.Length / 2;
            }
			ExtraDamage = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.VitalPointTargetingDamageBonus[Tier];
        }
	}

	return ExtraDamage;
}
