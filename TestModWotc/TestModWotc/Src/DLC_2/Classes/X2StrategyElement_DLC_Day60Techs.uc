//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DLC_Day60Techs.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_DLC_Day60Techs extends X2StrategyElement;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Techs;

	// Alien Armor Techs
	Techs.AddItem(CreateAutopsyViperKingTemplate());
	Techs.AddItem(CreateAutopsyBerserkerQueenTemplate());
	Techs.AddItem(CreateAutopsyArchonKingTemplate());

	// Proving Grounds Projects
	Techs.AddItem(CreateRageSuitTemplate());
	Techs.AddItem(CreateSerpentSuitTemplate());
	Techs.AddItem(CreateIcarusArmorTemplate());

	// XPack Integration
	Techs.AddItem(CreateExperimentalWeaponsTemplate());
	Techs.AddItem(CreateBoltCasterTemplate());
	Techs.AddItem(CreateHuntersAxeTemplate());
	Techs.AddItem(CreateShadowkeeperTemplate());
	Techs.AddItem(CreateFrostbombTemplate());

	return Techs;
}

//---------------------------------------------------------------------------------------
// Helper function for calculating project time
static function int StafferXDays(int iNumScientists, int iNumDays)
{
	return (iNumScientists * 5) * (24 * iNumDays); // Scientists at base skill level
}

// #######################################################################################
// ---------------------- RULER AUTOPSIES ------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateAutopsyViperKingTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'AutopsyViperKing');
	Template.PointsToComplete = 1800;
	Template.strImage = "img:///UILibrary_DLC2Images.IC_AutopsyViperKing";
	Template.bAutopsy = true;
	Template.SortingTier = 2;

	Template.TechStartedNarrative = "DLC_60_NarrativeMoments.Autopsy_ViperKing";

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AlienBiotech');
	Template.Requirements.RequiredItems.AddItem('CorpseViperKing');

	// Cost
	Artifacts.ItemTemplateName = 'CorpseViperKing';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	return Template;
}

static function X2DataTemplate CreateAutopsyBerserkerQueenTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'AutopsyBerserkerQueen');
	Template.PointsToComplete = 2600;
	Template.strImage = "img:///UILibrary_DLC2Images.IC_AutopsyBerserkerQueen";
	Template.bAutopsy = true;
	Template.SortingTier = 2;

	Template.TechStartedNarrative = "DLC_60_NarrativeMoments.Autopsy_BerserkerQueen";

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AlienBiotech');
	Template.Requirements.RequiredItems.AddItem('CorpseBerserkerQueen');

	// Cost
	Artifacts.ItemTemplateName = 'CorpseBerserkerQueen';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	return Template;
}

static function X2DataTemplate CreateAutopsyArchonKingTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'AutopsyArchonKing');
	Template.PointsToComplete = 4000;
	Template.strImage = "img:///UILibrary_DLC2Images.IC_AutopsyArchonKing";
	Template.bAutopsy = true;
	Template.SortingTier = 2;

	Template.TechStartedNarrative = "DLC_60_NarrativeMoments.Autopsy_ArchonKing";

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AlienBiotech');
	Template.Requirements.RequiredItems.AddItem('CorpseArchonKing');
		
	// Cost
	Artifacts.ItemTemplateName = 'CorpseArchonKing';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	return Template;
}

// #######################################################################################
// -------------------- ALIEN RULER ARMOR TECHS ------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateRageSuitTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Artifacts;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'RAGESuit');
	Template.PointsToComplete = StafferXDays(1, 7);
	Template.SortingTier = 1;
	Template.strImage = "img:///UILibrary_DLC2Images.TECH_RageSuit";

	Template.bProvingGround = true;
	Template.bArmor = true;
	Template.ResearchCompletedFn = class'X2StrategyElement_DefaultTechs'.static.GiveItems;

	// Item Rewards
	Template.ItemRewards.AddItem('HeavyAlienArmor');

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyBerserkerQueen');

	// Cost
	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'EleriumCore';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	return Template;
}

static function X2DataTemplate CreateSerpentSuitTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Artifacts;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'SerpentSuit');
	Template.PointsToComplete = StafferXDays(1, 7);
	Template.SortingTier = 1;
	Template.strImage = "img:///UILibrary_DLC2Images.TECH_SerpentArmor";

	Template.bProvingGround = true;
	Template.bArmor = true;
	Template.ResearchCompletedFn = class'X2StrategyElement_DefaultTechs'.static.GiveItems;

	// Item Rewards
	Template.ItemRewards.AddItem('LightAlienArmor');

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyViperKing');

	// Cost
	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'EleriumCore';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	return Template;
}

static function X2DataTemplate CreateIcarusArmorTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Artifacts;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'IcarusArmor');
	Template.PointsToComplete = StafferXDays(1, 10);
	Template.SortingTier = 1;
	Template.strImage = "img:///UILibrary_DLC2Images.TECH_IcarusArmor";
	
	Template.bProvingGround = true;
	Template.bArmor = true;
	Template.ResearchCompletedFn = class'X2StrategyElement_DefaultTechs'.static.GiveItems;

	// Item Rewards
	Template.ItemRewards.AddItem('MediumAlienArmor');

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyArchonKing');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 75;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 10;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 20;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'EleriumCore';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	return Template;
}

// #######################################################################################
// ---------------------- XPACK INTEGRATION ----------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateExperimentalWeaponsTemplate()
{
	local X2TechTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'ExperimentalWeapons');
	Template.PointsToComplete = StafferXDays(4, 5);
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.IC_BoltCaster_HuntingAxe";
	Template.SortingTier = 2;
	Template.bWeaponTech = true;

	// Requirements
	Template.Requirements.SpecialRequirementsFn = class'X2Helpers_DLC_Day60'.static.IsXPackIntegrationEnabled;
	Template.Requirements.RequiredObjectives.AddItem('T0_M1_WelcomeToLabs');
	Template.Requirements.bVisibleIfObjectivesNotMet = true;

	return Template;
}

static function X2DataTemplate CreateBoltCasterTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'BoltCaster');
	Template.PointsToComplete = StafferXDays(1, 5);
	Template.SortingTier = 1;
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.IC_BoltCaster";

	Template.bProvingGround = true;
	Template.ResearchCompletedFn = class'X2StrategyElement_DefaultTechs'.static.GiveItems;

	// Item Rewards
	Template.ItemRewards.AddItem('HunterRifle_CV_Schematic'); // Giving the schematic will also give the weapon

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('ExperimentalWeapons');
	Template.Requirements.SpecialRequirementsFn = class'X2Helpers_DLC_Day60'.static.IsXPackIntegrationEnabled;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 35;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateHuntersAxeTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'HuntersAxe');
	Template.PointsToComplete = StafferXDays(1, 5);
	Template.SortingTier = 1;
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.IC_HuntingAxe";

	Template.bProvingGround = true;
	Template.ResearchCompletedFn = class'X2StrategyElement_DefaultTechs'.static.GiveItems;

	// Item Rewards
	Template.ItemRewards.AddItem('HunterAxe_CV_Schematic'); // Giving the schematic will also give the weapon

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('ExperimentalWeapons');
	Template.Requirements.SpecialRequirementsFn = class'X2Helpers_DLC_Day60'.static.IsXPackIntegrationEnabled;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 30;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateShadowkeeperTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'Shadowkeeper');
	Template.PointsToComplete = StafferXDays(1, 5);
	Template.SortingTier = 1;
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.IC_HunterPistol";

	Template.bProvingGround = true;
	Template.ResearchCompletedFn = class'X2StrategyElement_DefaultTechs'.static.GiveItems;

	// Item Rewards
	Template.ItemRewards.AddItem('HunterPistol_CV_Schematic'); // Giving the schematic will also give the weapon

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('ExperimentalWeapons');
	Template.Requirements.SpecialRequirementsFn = class'X2Helpers_DLC_Day60'.static.IsXPackIntegrationEnabled;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateFrostbombTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'Frostbomb');
	Template.PointsToComplete = StafferXDays(1, 5);
	Template.SortingTier = 1;
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.IC_FrostBomb";

	Template.bProvingGround = true;
	Template.ResearchCompletedFn = class'X2StrategyElement_DefaultTechs'.static.GiveItems;

	// Item Rewards
	Template.ItemRewards.AddItem('Frostbomb_Schematic'); // Giving the schematic will also give the weapon

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('ExperimentalWeapons');
	Template.Requirements.SpecialRequirementsFn = class'X2Helpers_DLC_Day60'.static.IsXPackIntegrationEnabled;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}