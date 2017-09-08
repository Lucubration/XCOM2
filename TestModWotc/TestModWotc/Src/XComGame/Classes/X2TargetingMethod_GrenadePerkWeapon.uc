//---------------------------------------------------------------------------------------
//  FILE:    X2TargetingMethod_GrenadePerkWeapon.uc
//  AUTHOR:  Joshua Bouscher -- 07/25/2016
//  PURPOSE: Targeting method for throwing grenades and other such bouncy objects.
//			 Expects the weapon to come from an associated perk instead of the ability.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2TargetingMethod_GrenadePerkWeapon extends X2TargetingMethod_Grenade config(GameData_SoldierSkills);

struct AbilitySpecificPathData
{
	var PrecomputedPathData PathData;
	var name AbilityName;
};

var config array<AbilitySpecificPathData> AbilityPathData;

function GetGrenadeWeaponInfo(out XComWeapon WeaponEntity, out PrecomputedPathData WeaponPrecomputedPathData)
{
	local array<XComPerkContent> Perks;
	local int i;
	local XComWeapon Weapon;
	local PrecomputedPathData PathData;

	class'XComPerkContent'.static.GetAssociatedPerkDefinitions(Perks, FiringUnit.GetPawn(), Ability.GetMyTemplateName());

	for (i = 0; i < Perks.Length; ++i)
	{
		Weapon = Perks[i].PerkSpecificWeapon;
		if (Weapon != none)
		{
			WeaponEntity = FiringUnit.GetPawn().Spawn(class'XComWeapon', FiringUnit.GetPawn(), , , , Weapon);
			break;
		}
	}	
	if (WeaponEntity == none)
	{
		`RedScreen("Unable to find a perk weapon for" @ Ability.GetMyTemplateName());
	}
	i = AbilityPathData.Find('AbilityName', Ability.GetMyTemplateName());
	if (i != INDEX_NONE)
		PathData = AbilityPathData[i].PathData;

	WeaponPrecomputedPathData = PathData;
}