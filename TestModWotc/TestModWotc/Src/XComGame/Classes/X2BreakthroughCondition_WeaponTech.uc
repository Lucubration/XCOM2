//---------------------------------------------------------------------------------------
//  FILE:    X2BreakthroughCondition_WeaponTech.uc
//  AUTHOR:  Russell Aasland
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2BreakthroughCondition_WeaponTech extends X2BreakthroughCondition 
	editinlinenew
	hidecategories(Object);

var name WeaponTechMatch;

function bool MeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Item ItemState;
	local X2WeaponTemplate WeaponTemplate;

	ItemState = XComGameState_Item( kTarget );
	if (ItemState == none) // not an item
		return false;

	WeaponTemplate = X2WeaponTemplate( ItemState.GetMyTemplate() );
	if (WeaponTemplate == none) // not a weapon
		return false;

	// not a weapon-weapon
	if (WeaponTemplate.ItemCat != 'weapon')
		return false;

	return WeaponTemplate.WeaponTech == WeaponTechMatch;
}