//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_DLC_3StrikeDamage.uc
//  AUTHOR:  Joshua Bouscher
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Effect_DLC_3StrikeDamage extends X2Effect_ApplyWeaponDamage;

function WeaponDamageValue GetBonusEffectDamageValue(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon, StateObjectReference TargetRef)
{
	local X2SparkArmorTemplate_DLC_3 SparkArmorTemplate;
	local XComGameState_Item ArmorState;
	local XComGameState_Unit UnitState;
	local XComGameStateHistory History;
	local WeaponDamageValue DamageValue;

	History = `XCOMHISTORY;
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
	ArmorState = UnitState.GetItemInSlot(eInvSlot_Armor);
	SparkArmorTemplate = X2SparkArmorTemplate_DLC_3(ArmorState.GetMyTemplate());
	if (SparkArmorTemplate != none)
	{
		DamageValue = SparkArmorTemplate.StrikeDamage;
	}
	return DamageValue;
}