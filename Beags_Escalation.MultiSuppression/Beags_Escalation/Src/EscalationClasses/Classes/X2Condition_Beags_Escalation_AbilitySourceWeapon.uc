class X2Condition_Beags_Escalation_AbilitySourceWeapon extends X2Condition;

var name MatchWeaponCat;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local XComGameState_Item SourceWeapon;
	local X2WeaponTemplate WeaponTemplate;

	SourceWeapon = kAbility.GetSourceWeapon();
	if (SourceWeapon == none)
		return 'AA_WeaponIncompatible';

	if (MatchWeaponCat != '')
	{
		WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
		if (WeaponTemplate == none || WeaponTemplate.WeaponCat != MatchWeaponCat)
			WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetLoadedAmmoTemplate(kAbility));
		if (WeaponTemplate == none || WeaponTemplate.WeaponCat != MatchWeaponCat)
			return 'AA_WeaponIncompatible';
	}

	return 'AA_Success';
}