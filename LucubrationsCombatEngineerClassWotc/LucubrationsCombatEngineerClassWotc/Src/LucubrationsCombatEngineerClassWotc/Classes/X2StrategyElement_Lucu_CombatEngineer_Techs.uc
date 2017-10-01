class X2StrategyElement_Lucu_CombatEngineer_Techs extends X2StrategyElement
    config(Lucu_CombatEngineer_Tech);

var config int PlasmaPack_PointsToComplete;
var config int PlasmaPack_SuppliesQuantity;
var config int PlasmaPack_EleriumCoreQuantity;
var config int PlasmaPack_AlienAlloyQuantity;
var config int PlasmaPack_EleriumDustQuantity;

var config int SIMON_MKII_PointsToComplete;
var config int SIMON_MKII_SuppliesQuantity;
var config int SIMON_MKII_EleriumCoreQuantity;
var config int SIMON_MKII_AlienAlloyQuantity;
var config int SIMON_MKII_EleriumDustQuantity;

var config int DeployableCover_MKII_PointsToComplete;
var config int DeployableCover_MKII_SuppliesQuantity;
var config int DeployableCover_MKII_AlienAlloyQuantity;
var config int DeployableCover_MKII_EleriumDustQuantity;

var name PlasmaPackTechTemplateName;
var name SIMONMKIITechTemplateName;
var name DeployableCoverMKIITechTemplateName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Techs;

	Techs.AddItem(CreatePlasmaPackTemplate());
	Techs.AddItem(CreateSIMONMKIITemplate());
	Techs.AddItem(CreateDeployableCoverMKIITemplate());

	return Techs;
}

static function X2DataTemplate CreatePlasmaPackTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, default.PlasmaPackTechTemplateName);
	Template.PointsToComplete = class'X2StrategyElement_DefaultTechs'.static.StafferXDays(1, default.PlasmaPack_PointsToComplete);
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Plasma_Grenade_Project";
	Template.bProvingGround = true;
	Template.SortingTier = 1;
	Template.ResearchCompletedFn = class'X2StrategyElement_DefaultTechs'.static.UpgradeItems;
	
	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyMuton');

	// Cost
 	Resources.ItemTemplateName = 'Supplies';
 	Resources.Quantity = default.PlasmaPack_SuppliesQuantity;
 	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = default.PlasmaPack_EleriumCoreQuantity;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = default.PlasmaPack_AlienAlloyQuantity;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = default.PlasmaPack_EleriumDustQuantity;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateSIMONMKIITemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, default.SIMONMKIITechTemplateName);
	Template.PointsToComplete = class'X2StrategyElement_DefaultTechs'.static.StafferXDays(1, default.SIMON_MKII_PointsToComplete);
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Advanced_Grenade_Project";
	Template.bProvingGround = true;
	Template.SortingTier = 1;
	Template.ResearchCompletedFn = class'X2StrategyElement_DefaultTechs'.static.UpgradeItems;
	
	// Requirements
	Template.Requirements.RequiredTechs.AddItem('MagnetizedWeapons');

	// Cost
 	Resources.ItemTemplateName = 'Supplies';
 	Resources.Quantity = default.SIMON_MKII_SuppliesQuantity;
 	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = default.SIMON_MKII_EleriumCoreQuantity;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = default.SIMON_MKII_AlienAlloyQuantity;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = default.SIMON_MKII_EleriumDustQuantity;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateDeployableCoverMKIITemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, default.DeployableCoverMKIITechTemplateName);
	Template.PointsToComplete = class'X2StrategyElement_DefaultTechs'.static.StafferXDays(1, default.PlasmaPack_PointsToComplete);
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Nanofiber_Materials";
	Template.bProvingGround = true;
	Template.SortingTier = 1;
	Template.ResearchCompletedFn = class'X2StrategyElement_DefaultTechs'.static.UpgradeItems;
	
	// Requirements
	Template.Requirements.RequiredTechs.AddItem('PlatedArmor');

	// Cost
 	Resources.ItemTemplateName = 'Supplies';
 	Resources.Quantity = default.DeployableCover_MKII_SuppliesQuantity;
 	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = default.DeployableCover_MKII_AlienAlloyQuantity;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = default.DeployableCover_MKII_EleriumDustQuantity;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

DefaultProperties
{
    PlasmaPackTechTemplateName="Lucu_CombatEngineer_PlasmaPack"
    SIMONMKIITechTemplateName="Lucu_CombatEngineer_SIMONMKII"
    DeployableCoverMKIITechTemplateName="Lucu_CombatEngineer_DeployableCoverMKII"
}