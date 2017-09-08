//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Effect_ChosenKeen extends X2Effect_Persistent;

function bool ForcesBleedoutWhenDamageSource(XComGameState NewGameState, XComGameState_Unit UnitState, XComGameState_Effect EffectState)
{
	return UnitState.CanBleedOut();
}

defaultproperties
{
	EffectName="ChosenKeen"
}