class X2Effect_ArcWaveMultiDamage extends X2Effect_ApplyWeaponDamage;

function WeaponDamageValue GetBonusEffectDamageValue(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon, StateObjectReference TargetRef)
{
	local WeaponDamageValue Damage;
	local int FocusLevel;

	if (TargetRef.ObjectID > 0)
	{
		FocusLevel = SourceUnit.GetTemplarFocusLevel();
		if (FocusLevel > 0)
		{
			Damage.Damage = FocusLevel * 2;
		}
		else
		{
			Damage.Damage = 1;
		}
	}
	return Damage;
}

DefaultProperties
{
	bIgnoreBaseDamage = true
	bAllowFreeKill = false
	bAllowWeaponUpgrade = false
	bBypassShields = false
	bIgnoreArmor = true
	DamageTypes(0)="psi"
}