class PA_Schematics extends X2Item_DefaultSchematics;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Schematics;
	Schematics.AddItem(CreateTemplate_PA_MecGunBeam_Schematic());
	Schematics.AddItem(CreateTemplate_PA_MecMissilePlasma_Schematic());
	Schematics.AddItem(CreateTemplate_PA_MecHeavyArmor_Schematic());
	return Schematics;
}

static function X2DataTemplate CreateTemplate_PA_MecGunBeam_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'PA_MecGunBeam_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Beam_Rifle";
	Template.PointsToComplete = 0;
	Template.Tier = 3;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'PA_MecGunBeam';

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('PlasmaRifle');
	Template.Requirements.RequiredEngineeringScore = 0; // 20=3 engrs
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}


static function X2DataTemplate CreateTemplate_PA_MecMissilePlasma_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'PA_MecMissilePlasma_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Beam_Rifle";
	Template.PointsToComplete = 0;
	Template.Tier = 3;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'PA_MecMissilePlasma';

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('PlasmaRifle');
	Template.Requirements.RequiredEngineeringScore = 0; // 20=3 engrs
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateTemplate_PA_MecHeavyArmor_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'PA_MecHeavyArmor_Schematic');

	Template.ItemCat = 'armor';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Predator_Armor";
	Template.PointsToComplete = 0;
	Template.Tier = 3;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'PA_MecArmor';

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('PoweredArmor');
	Template.Requirements.RequiredEngineeringScore = 0; // 20=3 engrs
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

