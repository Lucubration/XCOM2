class X2Effect_Shredder extends X2Effect_ApplyWeaponDamage
	config(GameData_SoldierSkills);

var config int ConventionalShred, MagneticShred, BeamShred;

function WeaponDamageValue GetBonusEffectDamageValue(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon, StateObjectReference TargetRef)
{
	local WeaponDamageValue ShredValue;
	local X2WeaponTemplate WeaponTemplate;

	ShredValue = EffectDamageValue;             //  in case someone has set other fields in here, but not likely

	if ((SourceWeapon != none) &&
		(SourceUnit != none) &&
		SourceUnit.HasSoldierAbility('Shredder'))
	{
		WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
		if (WeaponTemplate != none)
		{
			if (WeaponTemplate.WeaponTech == 'magnetic')
				ShredValue.Shred += default.MagneticShred;
			else if (WeaponTemplate.WeaponTech == 'beam')
				ShredValue.Shred += default.BeamShred;
			else
				ShredValue.Shred += default.ConventionalShred;
		}
	}

	return ShredValue;
}

DefaultProperties
{
	bAllowFreeKill=true
	bIgnoreBaseDamage=false
}