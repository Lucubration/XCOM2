//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_ShadowRising.uc
//  AUTHOR:  Joshua Bouscher  --  7/8/2016
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Effect_ShadowRising extends X2Effect_Persistent;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	EventMgr.RegisterForEvent(EffectObj, 'UnitDied', EffectGameState.ShadowRisingUnitDied, ELD_OnStateSubmitted);
}