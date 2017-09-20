class X2StrategyElement_Lucu_CombatEngineer_Techs extends X2StrategyElement
    config(Lucu_CombatEngineer_Tech);

var config int PlasmaPack_PointsToComplete;
var config int PlasmaPack_SuppliesQuantity;
var config int PlasmaPack_EleriumCoreQuantity;
var config int PlasmaPack_AlienAlloyQuantity;
var config int PlasmaPack_EleriumDustQuantity;

var name PlasmaPackTechTemplateName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Techs;

	Techs.AddItem(CreatePlasmaPackTemplate());

	return Techs;
}

static function X2DataTemplate CreatePlasmaPackTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Artifacts;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, default.PlasmaPackTechTemplateName);
	Template.PointsToComplete = class'X2StrategyElement_DefaultTechs'.static.StafferXDays(1, default.PlasmaPack_PointsToComplete);
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Plasma_Grenade_Project";
	Template.bProvingGround = true;
	Template.SortingTier = 1;
	Template.ResearchCompletedFn = class'X2StrategyElement_DefaultTechs'.static.UpgradeItems;
	
	// Requirements
	//Template.Requirements.RequiredTechs.AddItem('AutopsyMuton');

	// Cost
 	Resources.ItemTemplateName = 'Supplies';
 	Resources.Quantity = default.PlasmaPack_SuppliesQuantity;
 	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'EleriumCore';
	Artifacts.Quantity = default.PlasmaPack_EleriumCoreQuantity;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = default.PlasmaPack_AlienAlloyQuantity;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = default.PlasmaPack_EleriumDustQuantity;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

DefaultProperties
{
    PlasmaPackTechTemplateName="Lucu_CombatEngineer_PlasmaPack"
}