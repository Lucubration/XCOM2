//---------------------------------------------------------------------------------------
//  FILE:    X2AbilityToHitCalc_PercentChange.uc
//  AUTHOR:  David Burchanowki
//           
//  Allows specifying a different hit percentage inside and outside of the buddy zone
//
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2AbilityToHitCalc_PercentChanceWithBuddyZone extends X2AbilityToHitCalc_PercentChance;

var() int PercentToHitInBuddyZone;

protected function int GetPercentToHit(XComGameState_Ability kAbility, AvailableTarget kTarget)
{
	local XComGameStateHistory History;
	local XComGameState_Unit SourceUnit;
	local StateObjectReference BondmateRef;
	
	History = `XCOMHISTORY;

	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	if(SourceUnit.HasSoldierBond(BondmateRef))
	{
		return PercentToHitInBuddyZone;
	}
	
	return super.GetPercentToHit(kAbility, kTarget);
}

defaultproperties
{
	PercentToHitInBuddyZone=100;
}