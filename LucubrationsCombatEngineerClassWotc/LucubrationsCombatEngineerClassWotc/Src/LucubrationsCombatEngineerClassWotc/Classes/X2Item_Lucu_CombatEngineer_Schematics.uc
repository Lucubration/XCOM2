class X2Item_Lucu_CombatEngineer_Schematics extends X2Item
    config(Lucu_CombatEngineer_Tech);
    
var config int FellingAxe_MG_SuppliesQuantity;
var config int FellingAxe_MG_AlienAlloyQuantity;

var config int FellingAxe_BM_SuppliesQuantity;
var config int FellingAxe_BM_AlienAlloyQuantity;
var config int FellingAxe_BM_EleriumDustQuantity;

var name FellingAxeMGSchematicTemplateName;
var name FellingAxeBMSchematicTemplateName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Techs;

	Techs.AddItem(CreateFellingAxeMGTemplate());
	Techs.AddItem(CreateFellingAxeBMTemplate());

	return Techs;
}

static function X2DataTemplate CreateFellingAxeMGTemplate()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, default.FellingAxeMGSchematicTemplateName);
	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_DLC2Images.MagHuntmansAxe";
	Template.PointsToComplete = 0;
	Template.Tier = 3;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;
	
	// Reference Item
	Template.ReferenceItemTemplate = class'X2Item_Lucu_CombatEngineer_Weapons'.default.FellingAxeMGItemName;
	Template.HideIfPurchased = default.FellingAxeBMSchematicTemplateName;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventStunLancer');
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
 	Resources.ItemTemplateName = 'Supplies';
 	Resources.Quantity = default.FellingAxe_MG_SuppliesQuantity;
 	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = default.FellingAxe_MG_AlienAlloyQuantity;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateFellingAxeBMTemplate()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, default.FellingAxeBMSchematicTemplateName);
	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_DLC2Images.BeamHuntmansAxe";
	Template.PointsToComplete = 0;
	Template.Tier = 1;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;
	
	// Reference Item
	Template.ReferenceItemTemplate = class'X2Item_Lucu_CombatEngineer_Weapons'.default.FellingAxeBMItemName;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyArchon');
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
 	Resources.ItemTemplateName = 'Supplies';
 	Resources.Quantity = default.FellingAxe_BM_SuppliesQuantity;
 	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = default.FellingAxe_BM_AlienAlloyQuantity;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = default.FellingAxe_BM_EleriumDustQuantity;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

DefaultProperties
{
    FellingAxeMGSchematicTemplateName="Lucu_CombatEngineer_FellingAxe_MG_Schematic"
    FellingAxeBMSchematicTemplateName="Lucu_CombatEngineer_FellingAxe_BM_Schematic"
}