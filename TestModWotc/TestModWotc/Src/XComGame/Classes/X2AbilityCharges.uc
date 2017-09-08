//---------------------------------------------------------------------------------------
//  FILE:    X2AbilityCharges.uc
//  AUTHOR:  Joshua Bouscher  --  2/5/2015
//  PURPOSE: Base class for setting charges on an X2AbilityTemplate.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2AbilityCharges extends Object
	editinlinenew
	hidecategories(Object);

struct BonusCharge
{
	var() name AbilityName;
	var() int NumCharges;
};

var() int InitialCharges;

var() array<BonusCharge> BonusCharges;

function int GetInitialCharges(XComGameState_Ability Ability, XComGameState_Unit Unit) 
{ 
	local int Charges;
	local BonusCharge BonusIter;

	Charges = InitialCharges;
	foreach BonusCharges(BonusIter)
	{
		if (Unit.HasSoldierAbility(BonusIter.AbilityName))
			Charges += BonusIter.NumCharges;
	}
	
	return Charges; 
}

function AddBonusCharge(const name AbilityName, const int NumCharges)
{
	local BonusCharge NewBonus;

	NewBonus.AbilityName = AbilityName;
	NewBonus.NumCharges = NumCharges;
	BonusCharges.AddItem(NewBonus);
}