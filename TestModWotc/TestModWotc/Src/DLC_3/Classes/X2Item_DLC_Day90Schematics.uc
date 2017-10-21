//---------------------------------------------------------------------------------------
//  FILE:    X2Item_DLC_Day90Schematics.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Item_DLC_Day90Schematics extends X2Item;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Schematics;

	// Weapon Schematics
	Schematics.AddItem(CreateTemplate_SparkRifle_Magnetic_Schematic());
	Schematics.AddItem(CreateTemplate_SparkRifle_Beam_Schematic());

	// Armor Schematics
	Schematics.AddItem(CreateTemplate_PlatedSparkArmor_Schematic());
	Schematics.AddItem(CreateTemplate_PoweredSparkArmor_Schematic());
	
	return Schematics;
}

// **************************************************************************
// ***                       Weapon Schematics                            ***
// **************************************************************************

static function X2DataTemplate CreateTemplate_SparkRifle_Magnetic_Schematic()
{
	local X2SchematicTemplate Template;
	local StrategyRequirement AltReq;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'SparkRifle_MG_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_DLC3Images.MagSparkRifle";
	Template.PointsToComplete = 0;
	Template.Tier = 1;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'SparkRifle_MG';
	Template.HideIfPurchased = 'SparkRifle_BM_Schematic';

	// Narrative Requirements
	Template.Requirements.RequiredTechs.AddItem('GaussWeapons');
	Template.Requirements.RequiredEngineeringScore = 15;
	Template.Requirements.RequiredSoldierClass = 'Spark';
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	Template.Requirements.SpecialRequirementsFn = class'X2Helpers_DLC_Day90'.static.IsLostTowersNarrativeContentComplete;

	// Non-Narrative Requirements
	AltReq.RequiredTechs.AddItem('MechanizedWarfare');
	AltReq.RequiredTechs.AddItem('GaussWeapons');
	AltReq.RequiredEngineeringScore = 10;
	AltReq.RequiredSoldierClass = 'Spark';
	AltReq.bVisibleIfPersonnelGatesNotMet = true;
	Template.AlternateRequirements.AddItem(AltReq);

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 90;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 10;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateTemplate_SparkRifle_Beam_Schematic()
{
	local X2SchematicTemplate Template;
	local StrategyRequirement AltReq;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'SparkRifle_BM_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_DLC3Images.BeamSparkRifle";
	Template.PointsToComplete = 0;
	Template.Tier = 3;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'SparkRifle_BM';

	// Narrative Requirements
	Template.Requirements.RequiredTechs.AddItem('HeavyPlasma');
	Template.Requirements.RequiredEngineeringScore = 25;
	Template.Requirements.RequiredSoldierClass = 'Spark';
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	Template.Requirements.SpecialRequirementsFn = class'X2Helpers_DLC_Day90'.static.IsLostTowersNarrativeContentComplete;

	// Non-Narrative Requirements
	AltReq.RequiredTechs.AddItem('MechanizedWarfare');
	AltReq.RequiredTechs.AddItem('HeavyPlasma');
	AltReq.RequiredEngineeringScore = 20;
	AltReq.RequiredSoldierClass = 'Spark';
	AltReq.bVisibleIfPersonnelGatesNotMet = true;
	Template.AlternateRequirements.AddItem(AltReq);

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 175;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 20;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 10;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

// **************************************************************************
// ***                       Armor Schematics                             ***
// **************************************************************************

static function X2DataTemplate CreateTemplate_PlatedSparkArmor_Schematic()
{
	local X2SchematicTemplate Template;
	local StrategyRequirement AltReq;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'PlatedSparkArmor_Schematic');

	Template.ItemCat = 'armor';
	Template.strImage = "img:///UILibrary_DLC3Images.Inv_Spark_Plated_A";
	Template.PointsToComplete = 0;
	Template.Tier = 1;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'PlatedSparkArmor';
	Template.HideIfPurchased = 'PoweredSparkArmor_Schematic';

	// Narrative Requirements
	Template.Requirements.RequiredTechs.AddItem('PlatedArmor');
	Template.Requirements.RequiredSoldierClass = 'Spark';
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	Template.Requirements.SpecialRequirementsFn = class'X2Helpers_DLC_Day90'.static.IsLostTowersNarrativeContentComplete;

	// Non-Narrative Requirements
	AltReq.RequiredTechs.AddItem('MechanizedWarfare');
	AltReq.RequiredTechs.AddItem('PlatedArmor');
	AltReq.RequiredEngineeringScore = 10;
	AltReq.RequiredSoldierClass = 'Spark';
	AltReq.bVisibleIfPersonnelGatesNotMet = true;
	Template.AlternateRequirements.AddItem(AltReq);

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 100;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 15;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 5;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateTemplate_PoweredSparkArmor_Schematic()
{
	local X2SchematicTemplate Template;
	local StrategyRequirement AltReq;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'PoweredSparkArmor_Schematic');

	Template.ItemCat = 'armor';
	Template.strImage = "img:///UILibrary_DLC3Images.Inv_Spark_Powered_A";
	Template.PointsToComplete = 0;
	Template.Tier = 1;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'PoweredSparkArmor';

	// Narrative Requirements
	Template.Requirements.RequiredTechs.AddItem('PoweredArmor');
	Template.Requirements.RequiredSoldierClass = 'Spark';
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	Template.Requirements.SpecialRequirementsFn = class'X2Helpers_DLC_Day90'.static.IsLostTowersNarrativeContentComplete;

	// Non-Narrative Requirements
	AltReq.RequiredTechs.AddItem('MechanizedWarfare');
	AltReq.RequiredTechs.AddItem('PoweredArmor');
	AltReq.RequiredEngineeringScore = 20;
	AltReq.RequiredSoldierClass = 'Spark';
	AltReq.bVisibleIfPersonnelGatesNotMet = true;
	Template.AlternateRequirements.AddItem(AltReq);

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 200;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 10;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}