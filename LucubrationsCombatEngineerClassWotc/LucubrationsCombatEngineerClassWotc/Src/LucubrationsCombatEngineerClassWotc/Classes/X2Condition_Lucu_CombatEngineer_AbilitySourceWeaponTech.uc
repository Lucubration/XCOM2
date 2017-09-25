class X2Condition_Lucu_CombatEngineer_AbilitySourceWeaponTech extends X2Condition;

var array<name> WeaponTech;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local XComGameState_Item SourceWeapon;
	local X2WeaponTemplate WeaponTemplate;

	SourceWeapon = kAbility.GetSourceWeapon();
	if (SourceWeapon == none)
	{
        return 'AA_WeaponIncompatible';
    }

    WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
    if (WeaponTemplate == none)
    {
        return 'AA_WeaponIncompatible';
    }

    if (WeaponTech.Find(WeaponTemplate.WeaponTech) != INDEX_NONE)
        return 'AA_Success';

	return 'AA_WeaponIncompatible';
}