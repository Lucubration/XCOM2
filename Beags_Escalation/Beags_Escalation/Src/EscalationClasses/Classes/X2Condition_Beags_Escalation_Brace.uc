// I wanted to be more elegant than this, but the conditions are a small logic tree, so I'll just code it directly
class X2Condition_Beags_Escalation_Brace extends X2Condition;

function name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit UnitState;
	local XComGameState_Item ItemState;
	local X2ItemTemplate ItemTemplate;
	local X2WeaponTemplate WeaponTemplate;

	UnitState = XComGameState_Unit(kTarget);
	if (UnitState == none)
		return 'AA_NotAUnit';

	ItemState = UnitState.GetItemInSlot(eInvSlot_PrimaryWeapon);
	ItemTemplate = ItemState.GetMyTemplate();
	WeaponTemplate = X2WeaponTemplate(ItemTemplate);
	if (WeaponTemplate != none)
	{
		if (WeaponTemplate.WeaponCat == 'cannon' &&
			ItemState.Ammo < ItemState.GetClipSize())
		{
			return 'AA_Success';
		}
		else if (WeaponTemplate.WeaponCat == 'beags_escalation_hmg' &&
			(ItemState.Ammo < ItemState.GetClipSize() || (UnitState.AffectedByEffectNames.Find(class'X2Ability_Beags_Escalation_GunnerAbilitySet'.default.HMGMovedEffectName) != INDEX_NONE)))
		{
			return 'AA_Success';
		}
	}

	return 'AA_AbilityUnavailable';
}
