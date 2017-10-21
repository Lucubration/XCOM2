//---------------------------------------------------------------------------------------
//  FILE:    X2Condition_Stealth.uc
//  AUTHOR:  Joshua Bouscher  --  2/5/2015
//  PURPOSE: Special condition for activating the Ranger Stealth ability.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Condition_Stealth extends X2Condition;

var bool bCheckFlanking;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{ 
	local XComGameState_Unit UnitState;
	local array<XComGameState_Item> arrItems;
	local XComGameState_Item ItemIter;

	UnitState = XComGameState_Unit(kTarget);

	if (UnitState == none)
		return 'AA_NotAUnit';

	if (UnitState.IsConcealed())
		return 'AA_UnitIsConcealed';

	if (bCheckFlanking && class'X2TacticalVisibilityHelpers'.static.GetNumFlankingEnemiesOfTarget(kTarget.ObjectID) > 0)
		return 'AA_UnitIsFlanked';

	arrItems = UnitState.GetAllInventoryItems();
	foreach arrItems(ItemIter)
	{
		if (ItemIter.IsMissionObjectiveItem() && !ItemIter.GetMyTemplate().bOkayToConcealAsObjective)
			return 'AA_NotWithAnObjectiveItem';
	}

	return 'AA_Success'; 
}

DefaultProperties
{
	bCheckFlanking = true;
}