//---------------------------------------------------------------------------------------
//  FILE:    X2Item_DLC_Day60Schematics.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Item_DLC_Day60Schematics extends X2Item;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Schematics;

	// Weapon Schematics
	Schematics.AddItem(CreateTemplate_HunterRifle_CV_Schematic());
	Schematics.AddItem(CreateTemplate_HunterRifle_MG_Schematic());
	Schematics.AddItem(CreateTemplate_HunterRifle_BM_Schematic());
	Schematics.AddItem(CreateTemplate_HunterPistol_CV_Schematic());
	Schematics.AddItem(CreateTemplate_HunterPistol_MG_Schematic());
	Schematics.AddItem(CreateTemplate_HunterPistol_BM_Schematic());
	Schematics.AddItem(CreateTemplate_HunterAxe_CV_Schematic());
	Schematics.AddItem(CreateTemplate_HunterAxe_MG_Schematic());
	Schematics.AddItem(CreateTemplate_HunterAxe_BM_Schematic());
	Schematics.AddItem(CreateTemplate_Frostbomb_Schematic());

	// Armor Schematics
	Schematics.AddItem(CreateTemplate_HeavyAlienArmorMk2_Schematic());
	Schematics.AddItem(CreateTemplate_LightAlienArmorMk2_Schematic());

	return Schematics;
}

// **************************************************************************
// ***                       Weapon Schematics                            ***
// **************************************************************************

static function X2DataTemplate CreateTemplate_HunterRifle_CV_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'HunterRifle_CV_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_DLC2Images.ConvBoltCaster";
	Template.PointsToComplete = 0;
	Template.Tier = 0;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.GiveItems;
	Template.bSquadUpgrade = false;

	// Items to Reward
	Template.ItemRewards.AddItem('AlienHunterRifle_CV');
	Template.ReferenceItemTemplate = 'AlienHunterRifle_CV';

	// Requirements
	Template.Requirements.SpecialRequirementsFn = AreConventionalHunterWeaponsAvailable;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 35;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateTemplate_HunterRifle_MG_Schematic()
{
	local X2SchematicTemplate Template;
	local StrategyRequirement AltReq;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'HunterRifle_MG_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_DLC2Images.MagBoltCaster";
	Template.PointsToComplete = 0;
	Template.Tier = 1;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;
	Template.bSquadUpgrade = false;

	// Reference Item
	Template.ReferenceItemTemplate = 'AlienHunterRifle_MG';
	Template.HideIfPurchased = 'HunterRifle_BM_Schematic';

	// Narrative Requirements
	Template.Requirements.RequiredTechs.AddItem('MagnetizedWeapons');
	Template.Requirements.RequiredEquipment.AddItem('AlienHunterRifle_CV');
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	Template.Requirements.SpecialRequirementsFn = IsAlienHuntersNarrativeContentComplete;
	
	// Non-Narrative Requirements
	AltReq.RequiredItems.AddItem('HunterRifle_CV_Schematic');
	AltReq.RequiredEquipment.AddItem('AlienHunterRifle_CV');
	AltReq.RequiredTechs.AddItem('MagnetizedWeapons');
	AltReq.RequiredEngineeringScore = 10;
	AltReq.bVisibleIfPersonnelGatesNotMet = true;
	Template.AlternateRequirements.AddItem(AltReq);

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 60;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateTemplate_HunterRifle_BM_Schematic()
{
	local X2SchematicTemplate Template;
	local StrategyRequirement AltReq;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'HunterRifle_BM_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_DLC2Images.BeamBoltCaster";
	Template.PointsToComplete = 0;
	Template.Tier = 3;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;
	Template.bSquadUpgrade = false;

	// Reference Item
	Template.ReferenceItemTemplate = 'AlienHunterRifle_BM';

	// Narrative Requirements
	Template.Requirements.RequiredTechs.AddItem('PlasmaRifle');
	Template.Requirements.RequiredEquipment.AddItem('AlienHunterRifle_CV');
	Template.Requirements.RequiredEquipment.AddItem('AlienHunterRifle_MG');
	Template.Requirements.bDontRequireAllEquipment = true;
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	Template.Requirements.SpecialRequirementsFn = IsAlienHuntersNarrativeContentComplete;

	// Non-Narrative Requirements
	AltReq.RequiredItems.AddItem('HunterRifle_CV_Schematic');
	AltReq.RequiredEquipment.AddItem('AlienHunterRifle_CV');
	AltReq.RequiredEquipment.AddItem('AlienHunterRifle_MG');
	AltReq.bDontRequireAllEquipment = true;
	AltReq.RequiredTechs.AddItem('PlasmaRifle');
	AltReq.RequiredEngineeringScore = 20;
	AltReq.bVisibleIfPersonnelGatesNotMet = true;
	Template.AlternateRequirements.AddItem(AltReq);

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 125;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 15;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateTemplate_HunterPistol_CV_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'HunterPistol_CV_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_DLC2Images.ConvShadowKeeper";
	Template.PointsToComplete = 0;
	Template.Tier = 0;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.GiveItems;
	Template.bSquadUpgrade = false;

	// Items to Reward
	Template.ItemRewards.AddItem('AlienHunterPistol_CV');
	Template.ReferenceItemTemplate = 'AlienHunterPistol_CV';

	// Requirements
	Template.Requirements.SpecialRequirementsFn = AreConventionalHunterWeaponsAvailable;
	
	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateTemplate_HunterPistol_MG_Schematic()
{
	local X2SchematicTemplate Template;
	local StrategyRequirement AltReq;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'HunterPistol_MG_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_DLC2Images.MagShadowKeeper";
	Template.PointsToComplete = 0;
	Template.Tier = 1;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;
	Template.bSquadUpgrade = false;

	// Reference Item
	Template.ReferenceItemTemplate = 'AlienHunterPistol_MG';
	Template.HideIfPurchased = 'HunterPistol_BM_Schematic';

	// Narrative Requirements
	Template.Requirements.RequiredTechs.AddItem('MagnetizedWeapons');
	Template.Requirements.RequiredEquipment.AddItem('AlienHunterPistol_CV');
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	Template.Requirements.SpecialRequirementsFn = IsAlienHuntersNarrativeContentComplete;

	// Non-Narrative Requirements
	AltReq.RequiredItems.AddItem('HunterPistol_CV_Schematic');
	AltReq.RequiredEquipment.AddItem('AlienHunterPistol_CV');
	AltReq.RequiredTechs.AddItem('MagnetizedWeapons');
	AltReq.RequiredEngineeringScore = 10;
	AltReq.bVisibleIfPersonnelGatesNotMet = true;
	Template.AlternateRequirements.AddItem(AltReq);

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 45;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateTemplate_HunterPistol_BM_Schematic()
{
	local X2SchematicTemplate Template;
	local StrategyRequirement AltReq;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'HunterPistol_BM_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_DLC2Images.BeamShadowKeeper";
	Template.PointsToComplete = 0;
	Template.Tier = 3;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;
	Template.bSquadUpgrade = false;

	// Reference Item
	Template.ReferenceItemTemplate = 'AlienHunterPistol_BM';

	// Narrative Requirements
	Template.Requirements.RequiredTechs.AddItem('PlasmaRifle');
	Template.Requirements.RequiredEquipment.AddItem('AlienHunterPistol_CV');
	Template.Requirements.RequiredEquipment.AddItem('AlienHunterPistol_MG');
	Template.Requirements.bDontRequireAllEquipment = true;
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	Template.Requirements.SpecialRequirementsFn = IsAlienHuntersNarrativeContentComplete;

	// Non-Narrative Requirements
	AltReq.RequiredItems.AddItem('HunterPistol_CV_Schematic');
	AltReq.RequiredEquipment.AddItem('AlienHunterPistol_CV');
	AltReq.RequiredEquipment.AddItem('AlienHunterPistol_MG');
	AltReq.bDontRequireAllEquipment = true;
	AltReq.RequiredTechs.AddItem('PlasmaRifle');
	AltReq.RequiredEngineeringScore = 20;
	AltReq.bVisibleIfPersonnelGatesNotMet = true;
	Template.AlternateRequirements.AddItem(AltReq);

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 100;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 10;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateTemplate_HunterAxe_CV_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'HunterAxe_CV_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_DLC2Images.ConvHuntmansAxe";
	Template.PointsToComplete = 0;
	Template.Tier = 0;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.GiveItems;
	Template.bSquadUpgrade = false;

	// Items to Reward
	Template.ItemRewards.AddItem('AlienHunterAxe_CV');
	Template.ReferenceItemTemplate = 'AlienHunterAxe_CV';

	// Requirements
	Template.Requirements.SpecialRequirementsFn = AreConventionalHunterWeaponsAvailable;
	
	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 30;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateTemplate_HunterAxe_MG_Schematic()
{
	local X2SchematicTemplate Template;
	local StrategyRequirement AltReq;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'HunterAxe_MG_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_DLC2Images.MagHuntmansAxe";
	Template.PointsToComplete = 0;
	Template.Tier = 1;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;
	Template.bSquadUpgrade = false;

	// Reference Items
	Template.ReferenceItemTemplate = 'AlienHunterAxe_MG';
	Template.HideIfPurchased = 'HunterAxe_BM_Schematic';

	// Narrative Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventStunLancer');
	Template.Requirements.RequiredEquipment.AddItem('AlienHunterAxe_CV');
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	Template.Requirements.SpecialRequirementsFn = IsAlienHuntersNarrativeContentComplete;

	// Non-Narrative Requirements
	AltReq.RequiredItems.AddItem('HunterAxe_CV_Schematic');
	AltReq.RequiredEquipment.AddItem('AlienHunterAxe_CV');
	AltReq.RequiredTechs.AddItem('AutopsyAdventStunLancer');
	AltReq.RequiredEngineeringScore = 10;
	AltReq.bVisibleIfPersonnelGatesNotMet = true;
	Template.AlternateRequirements.AddItem(AltReq);

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 65;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateTemplate_HunterAxe_BM_Schematic()
{
	local X2SchematicTemplate Template;
	local StrategyRequirement AltReq;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'HunterAxe_BM_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_DLC2Images.BeamHuntmansAxe";
	Template.PointsToComplete = 0;
	Template.Tier = 3;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;
	Template.bSquadUpgrade = false;

	// Reference Items
	Template.ReferenceItemTemplate = 'AlienHunterAxe_BM';

	// Narrative Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyArchon');
	Template.Requirements.RequiredEquipment.AddItem('AlienHunterAxe_CV');
	Template.Requirements.RequiredEquipment.AddItem('AlienHunterAxe_MG');
	Template.Requirements.bDontRequireAllEquipment = true;
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	Template.Requirements.SpecialRequirementsFn = IsAlienHuntersNarrativeContentComplete;

	// Non-Narrative Requirements
	AltReq.RequiredItems.AddItem('HunterAxe_CV_Schematic');
	AltReq.RequiredEquipment.AddItem('AlienHunterAxe_CV');
	AltReq.RequiredEquipment.AddItem('AlienHunterAxe_MG');
	AltReq.bDontRequireAllEquipment = true;
	AltReq.RequiredTechs.AddItem('AutopsyArchon');
	AltReq.RequiredEngineeringScore = 20;
	AltReq.bVisibleIfPersonnelGatesNotMet = true;
	Template.AlternateRequirements.AddItem(AltReq);

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 130;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 10;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateTemplate_Frostbomb_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'Frostbomb_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_DLC2Images.Inv_Frost_Bomb";
	Template.PointsToComplete = 0;
	Template.Tier = 0;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.GiveItems;
	Template.bSquadUpgrade = false;

	// Items to Reward
	Template.ItemRewards.AddItem('Frostbomb');
	Template.ReferenceItemTemplate = 'Frostbomb';

	// Requirements
	Template.Requirements.SpecialRequirementsFn = AreConventionalHunterWeaponsAvailable;
	
	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

// **************************************************************************
// ***                       Armor Schematics                             ***
// **************************************************************************

static function X2DataTemplate CreateTemplate_HeavyAlienArmorMk2_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'HeavyAlienArmorMk2_Schematic');

	Template.ItemCat = 'armor';
	Template.strImage = "img:///UILibrary_DLC2Images.Inv_RageSuit";
	Template.PointsToComplete = 0;
	Template.Tier = 2;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;
	Template.bSquadUpgrade = false;

	// Item Reference
	Template.ReferenceItemTemplate = 'HeavyAlienArmorMk2';

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyBerserkerQueen');
	Template.Requirements.RequiredTechs.AddItem('RAGESuit');
	Template.Requirements.RequiredTechs.AddItem('PoweredArmor');
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 75;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 15;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateTemplate_LightAlienArmorMk2_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'LightAlienArmorMk2_Schematic');

	Template.ItemCat = 'armor';
	Template.strImage = "img:///UILibrary_DLC2Images.Inv_SerpentArmor";
	Template.PointsToComplete = 0;
	Template.Tier = 2;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;
	Template.bSquadUpgrade = false;

	// Reference Item
	Template.ReferenceItemTemplate = 'LightAlienArmorMk2';

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyViperKing');
	Template.Requirements.RequiredTechs.AddItem('SerpentSuit');
	Template.Requirements.RequiredTechs.AddItem('PoweredArmor');
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 75;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 10;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 10;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

// **************************************************************************
// ***                       Delegate Functions                           ***
// **************************************************************************

static function bool AreConventionalHunterWeaponsAvailable()
{
	local XComGameState_CampaignSettings CampaignSettings;

	CampaignSettings = XComGameState_CampaignSettings(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));

	if (CampaignSettings.HasIntegratedDLCEnabled())
	{
		return false; // Conventional AH Weapons are not displayed if XPack Integration is turned on
	}

	// Otherwise check if the narrative has been disabled
	return (!CampaignSettings.HasOptionalNarrativeDLCEnabled(name(class'X2DownloadableContentInfo_DLC_Day60'.default.DLCIdentifier)));
}

//---------------------------------------------------------------------------------------
// Only returns true if narrative content is enabled AND completed
static function bool IsAlienHuntersNarrativeContentComplete()
{
	local XComGameState_CampaignSettings CampaignSettings;

	CampaignSettings = XComGameState_CampaignSettings(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));

	if (CampaignSettings.HasOptionalNarrativeDLCEnabled(name(class'X2DownloadableContentInfo_DLC_Day60'.default.DLCIdentifier)))
	{
		if (class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('DLC_AlienNestMissionComplete'))
		{
			return true;
		}
	}

	return false;
}