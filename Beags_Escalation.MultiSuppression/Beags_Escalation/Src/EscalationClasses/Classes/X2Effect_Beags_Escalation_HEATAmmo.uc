class X2Effect_Beags_Escalation_HEATAmmo extends X2Effect_Persistent;

var name MatchWeaponCat;

function int GetExtraArmorPiercing(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData)
{
	local XComGameState_Item SourceWeapon;
	local X2WeaponTemplate WeaponTemplate;
	local int i, ArmorPierce;

	SourceWeapon = AbilityState.GetSourceWeapon();
	if (SourceWeapon != none)
	{
		if (MatchWeaponCat != '')
		{
			WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
			if (WeaponTemplate == none || WeaponTemplate.WeaponCat != MatchWeaponCat)
				WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetLoadedAmmoTemplate(AbilityState));
			if (WeaponTemplate != none && WeaponTemplate.WeaponCat == MatchWeaponCat)
			{
				i = Min(class'X2Ability_Beags_Escalation_RocketeerAbilitySet'.default.HEATWarheadsArmorPierce.Length, WeaponTemplate.Tier);

				ArmorPierce = class'X2Ability_Beags_Escalation_RocketeerAbilitySet'.default.HEATWarheadsArmorPierce[i];
			}
		}
	}

	//`LOG("Beags Escalation: HEAT Warheads bonus armor pierce=" @ string(ArmorPierce));

	return ArmorPierce;
}
