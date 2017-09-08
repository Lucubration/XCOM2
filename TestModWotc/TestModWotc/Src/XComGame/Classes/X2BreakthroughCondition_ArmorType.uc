//---------------------------------------------------------------------------------------
//  FILE:    X2BreakthroughCondition_ArmorType.uc
//  AUTHOR:  Russell Aasland
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2BreakthroughCondition_ArmorType extends X2BreakthroughCondition 
	editinlinenew
	hidecategories(Object);

var name ArmorTypeMatch;

function bool MeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Item ItemState;
	local X2ArmorTemplate ArmorTemplate;

	ItemState = XComGameState_Item( kTarget );
	if (ItemState == none) // not an item
		return false;

	ArmorTemplate = X2ArmorTemplate( ItemState.GetMyTemplate() );
	if (ArmorTemplate == none) // not a weapon
		return false;

	// not a weapon-weapon
	if (ArmorTemplate.ItemCat != 'armor')
		return false;

	return ArmorTemplate.ArmorClass == ArmorTypeMatch;
}