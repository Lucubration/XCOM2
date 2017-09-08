//---------------------------------------------------------------------------------------
//  FILE:    X2BreakthroughCondition_ItemType.uc
//  AUTHOR:  Russell Aasland
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2BreakthroughCondition_ItemType extends X2BreakthroughCondition 
	editinlinenew
	hidecategories(Object);

var name ItemTypeMatch;

function bool MeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Item ItemState;
	local X2ItemTemplate ItemTemplate;

	ItemState = XComGameState_Item( kTarget );
	if (ItemState == none) // not an item
		return false;

	ItemTemplate = ItemState.GetMyTemplate();
	if (ItemTemplate == none) // not a weapon
		return false;

	return ItemTemplate.ItemCat == ItemTypeMatch;
}