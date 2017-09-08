//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_IncreaseCohesion.uc
//  AUTHOR:  David Burchanowski  --  11/2/2016
//  PURPOSE: Effect to increase aim against enemies that are targeting your bondmate
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2Effect_IncreaseBondmateCohesion extends X2Effect
	config(GameCore);

var int CohesionAmount;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_Unit BondmateUnit;
	local StateObjectReference BondmateRef;

	TargetUnit = XComGameState_Unit(kNewTargetState);
	if(TargetUnit == none || !TargetUnit.HasSoldierBond(BondmateRef))
	{
		return;
	}

	BondmateUnit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', BondmateRef.ObjectID));

	class'X2StrategyGameRulesetDataStructures'.static.ModifySoldierCohesion(TargetUnit, BondmateUnit, CohesionAmount, true);
}

// Static function so that if we should make this more complex later, with visualization or something,
// all users will pick up the changes.
static function X2Effect_IncreaseBondmateCohesion CreateIncreaseBondmateCohesionEffect(int InCohesionAmount)
{
	local X2Effect_IncreaseBondmateCohesion CohesionEffect;

	CohesionEffect = new class'X2Effect_IncreaseBondmateCohesion';
	CohesionEffect.CohesionAmount = InCohesionAmount;

	return CohesionEffect;
}