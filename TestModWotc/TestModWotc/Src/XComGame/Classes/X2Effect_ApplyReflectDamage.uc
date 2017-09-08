class X2Effect_ApplyReflectDamage extends X2Effect_ApplyWeaponDamage;

function WeaponDamageValue GetBonusEffectDamageValue(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon, StateObjectReference TargetRef)
{
	local X2AbilityTemplate ReflectedAbilityTemplate;
	local WeaponDamageValue BaseDamageValue, TaggedDamageValue, BonusDamageValue, ReturnDamageValue, EmptyDamageValue;
	local X2Effect_ApplyWeaponDamage DamageEffect;
	local XComGameState_Item ReflectedWeapon;
	local XComGameState_BaseObject TargetState;
	local XComGameStateHistory History;
	local int i;

	ReflectedAbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(SourceUnit.ReflectedAbilityContext.InputContext.AbilityTemplateName);
	if (ReflectedAbilityTemplate != none)
	{
		History = `XCOMHISTORY;
		ReflectedWeapon = XComGameState_Item(History.GetGameStateForObjectID(SourceUnit.ReflectedAbilityContext.InputContext.ItemObject.ObjectID));
		TargetState = History.GetGameStateForObjectID(TargetRef.ObjectID);
		for (i = 0; i < ReflectedAbilityTemplate.AbilityTargetEffects.Length; ++i)
		{
			if (X2Effect_ApplyReflectDamage(ReflectedAbilityTemplate.AbilityTargetEffects[i]) != none)
				continue;

			DamageEffect = X2Effect_ApplyWeaponDamage(ReflectedAbilityTemplate.AbilityTargetEffects[i]);
			if (DamageEffect != none && DamageEffect.bApplyOnHit && DamageEffect.bCanBeRedirected)
			{
				BaseDamageValue = EmptyDamageValue;
				TaggedDamageValue = EmptyDamageValue;
				BonusDamageValue = EmptyDamageValue;

				if (ReflectedWeapon != none)
				{
					if (!DamageEffect.bIgnoreBaseDamage)
					{
						ReflectedWeapon.GetBaseWeaponDamageValue(TargetState, BaseDamageValue);
					}
					if (DamageEffect.DamageTag != '')
					{
						ReflectedWeapon.GetWeaponDamageValue(TargetState, DamageEffect.DamageTag, TaggedDamageValue);
					}
				}
				BonusDamageValue = DamageEffect.GetBonusEffectDamageValue(AbilityState, SourceUnit, ReflectedWeapon, TargetRef);

				ReturnDamageValue.Crit += BaseDamageValue.Crit + TaggedDamageValue.Crit + BonusDamageValue.Crit;
				ReturnDamageValue.Damage += BaseDamageValue.Damage + TaggedDamageValue.Damage + BonusDamageValue.Damage;
				ReturnDamageValue.Pierce += BaseDamageValue.Pierce + TaggedDamageValue.Pierce + BonusDamageValue.Pierce;
				ReturnDamageValue.Rupture += BaseDamageValue.Rupture + TaggedDamageValue.Rupture + BonusDamageValue.Rupture;
				ReturnDamageValue.Shred += BaseDamageValue.Shred + TaggedDamageValue.Shred + BonusDamageValue.Shred;
				ReturnDamageValue.Spread += BaseDamageValue.Spread + TaggedDamageValue.Spread + BonusDamageValue.Spread;
			}
		}
	}
	ReturnDamageValue.DamageType = EffectDamageValue.DamageType;
	return ReturnDamageValue;
}

DefaultProperties
{
	bAllowFreeKill = false
	bAllowWeaponUpgrade = false
	bIgnoreBaseDamage = true
}