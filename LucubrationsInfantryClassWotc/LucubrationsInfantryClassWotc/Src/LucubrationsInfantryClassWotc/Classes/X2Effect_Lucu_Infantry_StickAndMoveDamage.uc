class X2Effect_Lucu_Infantry_StickAndMoveDamage extends X2Effect_PersistentStatChange;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{ 
	local XComGameState_Item SourceWeaponState;
	local X2EquipmentTemplate SourceWeaponTemplate;

	// Only add bonus damage on a hit, crit, or graze
	if (AppliedData.AbilityResultContext.HitResult == eHit_Success || AppliedData.AbilityResultContext.HitResult == eHit_Crit || AppliedData.AbilityResultContext.HitResult == eHit_Graze)
	{
		SourceWeaponState = AbilityState.GetSourceWeapon();
		SourceWeaponTemplate = X2EquipmentTemplate(SourceWeaponState.GetMyTemplate());
		if (SourceWeaponTemplate.InventorySlot == eInvSlot_PrimaryWeapon ||
			SourceWeaponTemplate.InventorySlot == eInvSlot_SecondaryWeapon)
		{
			// It's a primary or secondary weapon ability; apply the damage bonus
			return class'X2Ability_Lucu_Infantry_InfantryAbilitySet'.default.StickAndMoveDamageBonus;
		}
	}

	return 0;
}