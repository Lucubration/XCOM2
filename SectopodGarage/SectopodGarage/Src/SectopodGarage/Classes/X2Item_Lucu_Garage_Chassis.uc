class X2Item_Lucu_Garage_Chassis extends X2Item
	config(Lucu_Garage_DefaultConfig);

var config int BasicChassisUpgrade_UtilitySlots;
var config int AdvancedChassisUpgrade_UtilitySlots;
var config int AlloyChassisUpgrade_UtilitySlots;
var config int ExperimentalChassisUpgrade_UtilitySlots;
	
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(XtopodChassis());
	Templates.AddItem(BasicChassisUpgrade());
	Templates.AddItem(AdvancedChassisUpgrade());
	Templates.AddItem(AlloyChassisUpgrade());
	Templates.AddItem(ExperimentalChassisUpgrade());
	
	return Templates;
}


// **************************************************************************
// ***                         Xtopod Chassis                             ***
// **************************************************************************


static function X2DataTemplate XtopodChassis()
{
	local X2ChassisTemplate_Lucu_Garage Template;

	`CREATE_X2TEMPLATE(class'X2ChassisTemplate_Lucu_Garage', Template, 'Lucu_Garage_XtopodChassis');
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Kevlar_Armor";
	Template.CanBeBuilt = false;
	Template.ItemCat = 'armor';
	Template.ArmorTechCat = 'conventional';
	Template.InventorySlot = eInvSlot_Armor;
	Template.Tier = 0;
	Template.iItemSize = 0;
	Template.EquipSound = "StrategyUI_Armor_Equip_Conventional";

	return Template;
}


// **************************************************************************
// ***                       Basic Chassis Upgrade                        ***
// **************************************************************************


static function X2DataTemplate BasicChassisUpgrade()
{
	local X2ChassisUpgradeTemplate_Lucu_Garage Template;

	`CREATE_X2TEMPLATE(class'X2ChassisUpgradeTemplate_Lucu_Garage', Template, 'Lucu_Garage_BasicChassisUpgrade');
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Kevlar_Armor";
	Template.bInfiniteItem = true;
	Template.CanBeBuilt = false;
	Template.ItemCat = 'lucu_garage_chassis';
	Template.Tier = 1;
	
	Template.BonusAbilities.AddItem('Lucu_Garage_BasicChassisUpgrade');

	Template.UtilitySlots = default.BasicChassisUpgrade_UtilitySlots;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, class'X2Ability_Lucu_Garage_ChassisAbilitySet'.default.BasicChassisUpgrade_Health, false);
	
	return Template;
}


// **************************************************************************
// ***                     Advanced Chassis Upgrade                       ***
// **************************************************************************


static function X2DataTemplate AdvancedChassisUpgrade()
{
	local X2ChassisUpgradeTemplate_Lucu_Garage Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2ChassisUpgradeTemplate_Lucu_Garage', Template, 'Lucu_Garage_AdvancedChassisUpgrade');
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Predator_Armor";
	Template.CanBeBuilt = true;
	Template.ItemCat = 'lucu_garage_chassis';
	Template.Tier = 2;
	
	Template.BonusAbilities.AddItem('Lucu_Garage_AdvancedChassisUpgrade');

	Template.UtilitySlots = default.AdvancedChassisUpgrade_UtilitySlots;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, class'X2Ability_Lucu_Garage_ChassisAbilitySet'.default.AdvancedChassisUpgrade_Health, false);
	
	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 150;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}


// **************************************************************************
// ***                       Alloy Chassis Upgrade                        ***
// **************************************************************************


static function X2DataTemplate AlloyChassisUpgrade()
{
	local X2ChassisUpgradeTemplate_Lucu_Garage Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2ChassisUpgradeTemplate_Lucu_Garage', Template, 'Lucu_Garage_AlloyChassisUpgrade');
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Warden_Armor";
	Template.CanBeBuilt = true;
	Template.ItemCat = 'lucu_garage_chassis';
	Template.Tier = 3;
	
	Template.BonusAbilities.AddItem('Lucu_Garage_AlloyChassisUpgrade');

	Template.UtilitySlots = default.AlloyChassisUpgrade_UtilitySlots;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, class'X2Ability_Lucu_Garage_ChassisAbilitySet'.default.AlloyChassisUpgrade_Health, false);
	
	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 250;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}


// **************************************************************************
// ***                   Experimental Chassis Upgrade                     ***
// **************************************************************************


static function X2DataTemplate ExperimentalChassisUpgrade()
{
	local X2ChassisUpgradeTemplate_Lucu_Garage Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2ChassisUpgradeTemplate_Lucu_Garage', Template, 'Lucu_Garage_ExperimentalChassisUpgrade');
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Marauder_Armor";
	Template.CanBeBuilt = true;
	Template.ItemCat = 'lucu_garage_chassis';
	Template.Tier = 4;
	
	Template.BonusAbilities.AddItem('Lucu_Garage_ExperimentalChassisUpgrade');

	Template.UtilitySlots = default.ExperimentalChassisUpgrade_UtilitySlots;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, class'X2Ability_Lucu_Garage_ChassisAbilitySet'.default.ExperimentalChassisUpgrade_Health, false);
	
	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 400;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}
