//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_TargetDamageTypeBonus.uc
//  PURPOSE: Based on the damage type for the ability, this will add a bonus to the
//			 damage amount.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2Effect_TargetDamageTypeBonus extends X2Effect_Persistent;

var float BonusDmg;
var EStatModOp BonusModType;
var array<name> BonusDamageTypes;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState,
										const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local array<name> EffectDamageTypes;
	local int i;

	WeaponDamageEffect.GetEffectDamageTypes(AbilityState.GetParentGameState(), AppliedData, EffectDamageTypes);

	for (i = 0; i < BonusDamageTypes.Length; ++i)
	{
		if (EffectDamageTypes.Find(BonusDamageTypes[i]) != INDEX_NONE)
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

function int ModifyDamageFromDestructible(XComGameState_Destructible DestructibleState, int IncomingDamage, XComGameState_Unit TargetUnit, XComGameState_Effect EffectState)
{
	if (BonusDamageTypes.Find('Explosion') != INDEX_NONE)
	{
		if (BonusModType == MODOP_Addition)
		{
			return BonusDmg;
		}
		else if (BonusModType == MODOP_Multiplication)
		{
			return IncomingDamage * BonusDmg;
		}
	}
	return 0;
}

defaultproperties
{
	BonusModType = MODOP_Addition
	bDisplayInSpecialDamageMessageUI = true
}
