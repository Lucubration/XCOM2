//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_SilentKiller.uc
//  AUTHOR:  Joshua Bouscher  --  7/11/2016
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Effect_SilentKiller extends X2Effect_Persistent config(GameData_SoldierSkills);

var config int ConcealAmountDivisor;
var config array<name> AllowedWeaponCategories;

function bool AdjustSuperConcealModifier(XComGameState_Unit UnitState, XComGameState_Effect EffectState, XComGameState_Ability AbilityState, XComGameState RespondToGameState, const int BaseModifier, out int Modifier)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit TargetUnit;
	local XComGameState_Item SourceWeapon;

	if (RespondToGameState == none)
		return false;	// nothing special is previewed for this effect

	AbilityContext = XComGameStateContext_Ability(RespondToGameState.GetContext());
	TargetUnit = XComGameState_Unit(RespondToGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
	if (TargetUnit != None && TargetUnit.IsDead())
	{
		SourceWeapon = AbilityState.GetSourceWeapon();
		if (SourceWeapon != None && default.AllowedWeaponCategories.Find(SourceWeapon.GetWeaponCategory()) != INDEX_NONE)
		{
			// @mnauta Silent Killer now simply doesn't increase the reveal chance at all on kills
			Modifier = 0;
			return true;
		}
	}
	return false;
}

DefaultProperties
{
	DuplicateResponse = eDupe_Ignore
	EffectName = "SilentKiller"
}