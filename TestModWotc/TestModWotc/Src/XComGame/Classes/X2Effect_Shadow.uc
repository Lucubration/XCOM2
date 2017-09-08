//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Shadow.uc
//  AUTHOR:  Joshua Bouscher  --  7/6/2016
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Effect_Shadow extends X2Effect_RangerStealth;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit UnitState;

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
	
	UnitState = XComGameState_Unit(kNewTargetState);
	if (UnitState != none)
	{
		UnitState.SuperConcealmentLoss = 0;
	}
}

DefaultProperties
{
	EffectName = "Shadow"
}