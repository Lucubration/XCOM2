//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_WeakPoint.uc
//  AUTHOR:  Russell Aasland
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2Effect_WeakPoint extends X2Effect_Persistent;

var Delegate<GetValueDelegate> GetValueFn;

delegate int GetValueDelegate();

function int GetConditionalExtraShredValue(int UnconditionalShred, XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData)
{
	if (UnconditionalShred > 0)
	{
		return GetValueFn( );
	}

	return 0;
}