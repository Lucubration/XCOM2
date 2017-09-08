//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_LethalWeaponDamage.uc
//  AUTHOR:  Russell Aasland
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2Effect_LethalWeaponDamage extends X2Effect_Persistent;

var array<X2Condition> LethalDamageConditions;

function bool FreeKillOnDamage(XComGameState_Unit Shooter, XComGameState_Unit Target, XComGameState GameState, const int ToKillTarget, const out EffectAppliedData ApplyEffectParameters)
{
	local XComGameState_Ability AbilityState;
	local X2Condition ConditionIter;

	AbilityState = XComGameState_Ability( `XCOMHISTORY.GetGameStateForObjectID( ApplyEffectParameters.AbilityStateObjectRef.ObjectID ) );
	if (AbilityState.SourceWeapon != ApplyEffectParameters.ItemStateObjectRef)
		return false;

	if (LethalDamageConditions.Length > 0)
	{
		foreach LethalDamageConditions( ConditionIter )
		{
			if (ConditionIter.MeetsCondition( Target ) != 'AA_Success')
				return false;
		}
	}

	return true;
}

defaultproperties
{
	bDisplayInSpecialDamageMessageUI = true
}