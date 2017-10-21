//---------------------------------------------------------------------------------------
//  FILE:    X2SparkCharacterTemplate_DLC_3.uc
//  AUTHOR:  Joshua Bouscher
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2SparkCharacterTemplate_DLC_3 extends X2CharacterTemplate;

function SparkCosmeticUnitCreated(XComGameState_Unit CosmeticUnit, XComGameState_Unit OwnerUnit, XComGameState_Item SourceItem, XComGameState StartGameState)
{
	local XComGameState_Item SparkHeavyWeapon, BitHeavyWeapon;

	SparkHeavyWeapon = OwnerUnit.GetItemInSlot(eInvSlot_HeavyWeapon);
	if (SparkHeavyWeapon != none)
	{
		BitHeavyWeapon = SparkHeavyWeapon.GetMyTemplate().CreateInstanceFromTemplate(StartGameState);
		CosmeticUnit.bIgnoreItemEquipRestrictions = true;
		CosmeticUnit.AddItemToInventory(BitHeavyWeapon, eInvSlot_HeavyWeapon, StartGameState);
		CosmeticUnit.bIgnoreItemEquipRestrictions = false;

		XGUnit(CosmeticUnit.GetVisualizer()).ApplyLoadoutFromGameState(CosmeticUnit, StartGameState);
	}
}

DefaultProperties
{
	OnCosmeticUnitCreatedFn=SparkCosmeticUnitCreated
}