class X2Condition_Lucu_Garage_WeaponInfiniteAmmo extends X2Condition;

var bool HasInfiniteAmmo;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local XComGameState_Item SourceWeapon;

	SourceWeapon = kAbility.GetSourceWeapon();
	if (SourceWeapon != none)
	{
		if (SourceWeapon.HasInfiniteAmmo())
		{
			if (!HasInfiniteAmmo)
				return 'AA_WeaponIncompatible';
		}
		else if (HasInfiniteAmmo)
			return 'AA_WeaponIncompatible';
	}
	return 'AA_Success';
}
