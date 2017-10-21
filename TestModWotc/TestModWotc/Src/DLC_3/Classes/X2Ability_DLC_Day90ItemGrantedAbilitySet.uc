//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_DLC_Day90ItemGrantedAbilitySet.uc
//  AUTHOR:  Joe Weinhoffer  --  2/09/2016
//  PURPOSE: Defines abilities made available to XCom soldiers through their equipped inventory items in X-Com 2. 
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Ability_DLC_Day90ItemGrantedAbilitySet extends X2Ability
	dependson(XComGameStateContext_Ability) config(GameCore);

var config int SPARK_PLATED_HEALTH_BONUS;
var config int SPARK_PLATED_MOBILITY_BONUS;
var config int SPARK_PLATED_MITIGATION_AMOUNT;
var config int SPARK_PLATED_MITIGATION_CHANCE;

var config int SPARK_POWERED_HEALTH_BONUS;
var config int SPARK_POWERED_MOBILITY_BONUS;
var config int SPARK_POWERED_MITIGATION_AMOUNT;
var config int SPARK_POWERED_MITIGATION_CHANCE;

/// <summary>
/// Creates the set of abilities granted to units through their equipped items in X-Com 2
/// </summary>
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(SparkPlatedArmorStats());
	Templates.AddItem(SparkPoweredArmorStats());

	return Templates;
}

static function X2AbilityTemplate SparkPlatedArmorStats()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'PlatedSparkArmorStats');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);
	// Template.IconImage  -- no icon needed for armor stats

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	// giving health here; medium plated doesn't have mitigation
	//
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	// PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, default.MediumPlatedHealthBonusName, default.MediumPlatedHealthBonusDesc, Template.IconImage);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_HP, default.SPARK_PLATED_HEALTH_BONUS);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.SPARK_PLATED_MOBILITY_BONUS);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorChance, default.SPARK_PLATED_MITIGATION_CHANCE);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, default.SPARK_PLATED_MITIGATION_AMOUNT);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate SparkPoweredArmorStats()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'PoweredSparkArmorStats');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);
	// Template.IconImage  -- no icon needed for armor stats

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	// PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, default.MediumPlatedHealthBonusName, default.MediumPlatedHealthBonusDesc, Template.IconImage);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_HP, default.SPARK_POWERED_HEALTH_BONUS);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.SPARK_POWERED_MOBILITY_BONUS);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorChance, default.SPARK_POWERED_MITIGATION_CHANCE);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, default.SPARK_POWERED_MITIGATION_AMOUNT);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}