//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Executioner.uc
//  AUTHOR:  Joshua Bouscher  --  7/12/2016
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Effect_Executioner extends X2Effect_Persistent;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Item SourceWeapon;
	local WeaponDamageValue DamageValue;
	local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(TargetDamageable);

	//  only add bonus damage on a crit, flanking, while in shadow
	if(AppliedData.AbilityResultContext.HitResult == eHit_Crit && Attacker.IsSuperConcealed() && TargetUnit != none && TargetUnit.IsFlanked(Attacker.GetReference()))
	{
		SourceWeapon = AbilityState.GetSourceWeapon();
		SourceWeapon.GetBaseWeaponDamageValue(none, DamageValue);

		// Double the Crit damage
		return DamageValue.Crit;
	}

	return 0;
}

DefaultProperties
{
	EffectName = "Executioner"
	DuplicateResponse = eDupe_Ignore
	bDisplayInSpecialDamageMessageUI = true
}