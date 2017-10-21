//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_DLC_3Rainmaker.uc
//  AUTHOR:  Joshua Bouscher
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2Effect_DLC_3Rainmaker extends X2Effect_Persistent;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	switch (AbilityState.GetMyTemplateName())
	{
	case 'SparkRocketLauncher':
		return class'X2Ability_SparkAbilitySet'.default.RAINMAKER_DMG_ROCKETLAUNCHER;
	case 'SparkShredderGun':
		return class'X2Ability_SparkAbilitySet'.default.RAINMAKER_DMG_SHREDDERGUN;
	case 'SparkShredstormCannon':
		return class'X2Ability_SparkAbilitySet'.default.RAINMAKER_DMG_SHREDSTORM;
	case 'SparkFlamethrower':
		return class'X2Ability_SparkAbilitySet'.default.RAINMAKER_DMG_FLAMETHROWER;
	case 'SparkFlamethrowerMk2':
		return class'X2Ability_SparkAbilitySet'.default.RAINMAKER_DMG_FLAMETHROWER2;
	case 'SparkBlasterLauncher':
		return class'X2Ability_SparkAbilitySet'.default.RAINMAKER_DMG_BLASTERLAUNCHER;
	case 'SparkPlasmaBlaster':
		return class'X2Ability_SparkAbilitySet'.default.RAINMAKER_DMG_PLASMABLASTER;
	}
	return 0;
}

defaultproperties
{
	bDisplayInSpecialDamageMessageUI = true
}
