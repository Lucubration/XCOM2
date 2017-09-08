class X2Item_Beags_Escalation_WeaponUpgrades extends X2Item
	config (Beags_Escalation_Item);

var config WeaponDamageValue Beags_Escalation_ShredderUpgrade_Bsc;
var config WeaponDamageValue Beags_Escalation_ShredderUpgrade_Adv;
var config WeaponDamageValue Beags_Escalation_ShredderUpgrade_Sup;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Items;

	Items.AddItem(CreateBasicShredderUpgrade());
	Items.AddItem(CreateAdvancedShredderUpgrade());
	Items.AddItem(CreateSuperiorShredderUpgrade());
	
	return Items;
}

static function X2DataTemplate CreateBasicShredderUpgrade()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'Beags_Escalation_ShredderUpgrade_Bsc');

	SetUpShredderUpgrade(Template);
	class'X2Item_DefaultUpgrades'.static.SetUpTier1Upgrade(Template);

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticB_inv";
	Template.BonusDamage = default.Beags_Escalation_ShredderUpgrade_Bsc;
	
	return Template;
}

static function X2DataTemplate CreateAdvancedShredderUpgrade()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'Beags_Escalation_ShredderUpgrade_Adv');

	SetUpShredderUpgrade(Template);
	class'X2Item_DefaultUpgrades'.static.SetUpTier2Upgrade(Template);

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.MagSniper_OpticB_inv";
	Template.BonusDamage = default.Beags_Escalation_ShredderUpgrade_Adv;

	return Template;
}

static function X2DataTemplate CreateSuperiorShredderUpgrade()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'Beags_Escalation_ShredderUpgrade_Sup');

	SetUpShredderUpgrade(Template);
	class'X2Item_DefaultUpgrades'.static.SetUpTier3Upgrade(Template);

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_OpticB_inv";
	Template.BonusDamage = default.Beags_Escalation_ShredderUpgrade_Sup;
	
	return Template;
}

static function SetUpShredderUpgrade(out X2WeaponUpgradeTemplate Template)
{
	class'X2Item_DefaultUpgrades'.static.SetUpWeaponUpgrade(Template);

	Template.MutuallyExclusiveUpgrades.AddItem('Beags_Escalation_ShredderUpgrade_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('Beags_Escalation_ShredderUpgrade_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('Beags_Escalation_ShredderUpgrade_Sup');
}
