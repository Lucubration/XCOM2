class X2Item_Lucu_Garage_Plating extends X2Item
	config(Lucu_Garage_DefaultConfig);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(BasicPlating());
	Templates.AddItem(RhinoPlating());
	Templates.AddItem(RaptorPlating());
	
	return Templates;
}


// **************************************************************************
// ***                           Basic Plating                            ***
// **************************************************************************


static function X2DataTemplate BasicPlating()
{
	local X2ItemTemplate_Lucu_Garage Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate_Lucu_Garage', Template, 'Lucu_Garage_BasicPlating');
	Template.ItemCat = 'lucu_garage_plating';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Nano_Fiber_Vest";
	//Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Armor_Harness";
	//Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Hazmat_Vest";
	//Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Stasis_Vest";

	Template.StartingItem = true;
	Template.CanBeBuilt = true;
	Template.bInfiniteItem = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 0;
	
	Template.BonusAbilities.AddItem('Lucu_Garage_BasicPlating');

	Template.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel, eStat_ArmorMitigation, class'X2Ability_Lucu_Garage_ChassisAbilitySet'.default.BasicPlating_Armor, false);

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 15;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}


// **************************************************************************
// ***                           Rhino Plating                            ***
// **************************************************************************


static function X2DataTemplate RhinoPlating()
{
	local X2ItemTemplate_Lucu_Garage Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate_Lucu_Garage', Template, 'Lucu_Garage_RhinoPlating');
	Template.ItemCat = 'lucu_garage_plating';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Armor_Harness";

	Template.StartingItem = true;
	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 0;
	
	Template.BonusAbilities.AddItem('Lucu_Garage_RhinoPlating');
	Template.BonusAbilities.AddItem('Lucu_Garage_WallBreakingOn');

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, class'X2Ability_Lucu_Garage_ChassisAbilitySet'.default.RhinoPlating_Health, true);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel, eStat_ArmorMitigation, class'X2Ability_Lucu_Garage_ChassisAbilitySet'.default.RhinoPlating_Armor, true);

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 65;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}


// **************************************************************************
// ***                          Raptor Plating                            ***
// **************************************************************************


static function X2DataTemplate RaptorPlating()
{
	local X2ItemTemplate_Lucu_Garage Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate_Lucu_Garage', Template, 'Lucu_Garage_RaptorPlating');
	Template.ItemCat = 'lucu_garage_plating';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Stasis_Vest";

	Template.StartingItem = true;
	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 0;
	
	Template.BonusAbilities.AddItem('Lucu_Garage_RaptorPlating');
	Template.BonusAbilities.AddItem('RunAndGun');

	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_Lucu_Garage_ChassisAbilitySet'.default.RaptorPlating_Mobility, true);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.DodgeLabel, eStat_Dodge, class'X2Ability_Lucu_Garage_ChassisAbilitySet'.default.RaptorPlating_Dodge, true);

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 65;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}
