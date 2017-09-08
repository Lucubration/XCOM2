//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_TargetDamageDistanceBonus.uc
//  PURPOSE: Based on the distance from the source to target, this will add a bonus to the
//			 damage amount.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2Effect_TargetDamageDistanceBonus extends X2Effect_Persistent;

var float BonusDmg;
var EStatModOp BonusModType;
var int WithinTileDistance;
var bool bPrimaryTargetOnly;		//	only apply the damage mod from a single target attack

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState,
										const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local XComGameState_Unit TargetUnitState;
	local int TileDistance;

	TargetUnitState = XComGameState_Unit(TargetDamageable);

	if (TargetUnitState != none)
	{
		if (bPrimaryTargetOnly && AppliedData.AbilityInputContext.PrimaryTarget.ObjectID != TargetUnitState.ObjectID)
			return 0;

		TileDistance = Attacker.TileDistanceBetween(TargetUnitState);

		if( TileDistance <= WithinTileDistance )
		{
			if (BonusModType == MODOP_Addition)
			{
				return BonusDmg;
			}
			else if (BonusModType == MODOP_Multiplication)
			{
				return CurrentDamage * BonusDmg;
			}
		}
	}

	return 0;
}

defaultproperties
{
	BonusModType = MODOP_Addition
	bDisplayInSpecialDamageMessageUI = true
}
