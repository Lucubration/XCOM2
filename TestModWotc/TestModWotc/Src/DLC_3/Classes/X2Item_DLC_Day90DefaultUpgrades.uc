//---------------------------------------------------------------------------------------
//  FILE:    X2Item_DLC_Day90DefaultUpgrades.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Item_DLC_Day90DefaultUpgrades extends X2Item_DefaultUpgrades;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Items;
	
	Items.AddItem(CreateBasicCritUpgrade());
	Items.AddItem(CreateAdvancedCritUpgrade());
	Items.AddItem(CreateSuperiorCritUpgrade());

	Items.AddItem(CreateBasicAimUpgrade());
	Items.AddItem(CreateAdvancedAimUpgrade());
	Items.AddItem(CreateSuperiorAimUpgrade());

	Items.AddItem(CreateBasicClipSizeUpgrade());
	Items.AddItem(CreateAdvancedClipSizeUpgrade());
	Items.AddItem(CreateSuperiorClipSizeUpgrade());

	Items.AddItem(CreateBasicFreeFireUpgrade());
	Items.AddItem(CreateAdvancedFreeFireUpgrade());
	Items.AddItem(CreateSuperiorFreeFireUpgrade());

	Items.AddItem(CreateBasicReloadUpgrade());
	Items.AddItem(CreateAdvancedReloadUpgrade());
	Items.AddItem(CreateSuperiorReloadUpgrade());

	Items.AddItem(CreateBasicMissDamageUpgrade());
	Items.AddItem(CreateAdvancedMissDamageUpgrade());
	Items.AddItem(CreateSuperiorMissDamageUpgrade());

	Items.AddItem(CreateBasicFreeKillUpgrade());
	Items.AddItem(CreateAdvancedFreeKillUpgrade());
	Items.AddItem(CreateSuperiorFreeKillUpgrade());

	return Items;
}

// #######################################################################################
// -------------------- CRIT UPGRADES ----------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateBasicCritUpgrade()
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(Super.CreateBasicCritUpgrade());
	
	SetUpSparkCritUpgrade(Template);

	return Template;
}

static function X2DataTemplate CreateAdvancedCritUpgrade()
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(Super.CreateAdvancedCritUpgrade());

	SetUpSparkCritUpgrade(Template);

	return Template;
}

static function X2DataTemplate CreateSuperiorCritUpgrade()
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(Super.CreateSuperiorCritUpgrade());

	SetUpSparkCritUpgrade(Template);

	return Template;
}

static function SetUpSparkCritUpgrade(out X2WeaponUpgradeTemplate Template)
{
	Template.AddUpgradeAttachment('Optic', '', "", "", 'SparkRifle_CV', , "img:///UILibrary_Common.ConvCannon.ConvCannon_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvCannon_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', '', "", "", 'SparkRifle_MG', , "img:///UILibrary_Common.UI_MagCannon.MagCannon_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagCannon_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', '', "", "", 'SparkRifle_BM', , "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_OpticA", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamCannon_OpticA_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
}

// #######################################################################################
// -------------------- AIM UPGRADES ----------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateBasicAimUpgrade()
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(Super.CreateBasicAimUpgrade());

	SetUpSparkAimUpgrade(Template);

	return Template;
}

static function X2DataTemplate CreateAdvancedAimUpgrade()
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(Super.CreateAdvancedAimUpgrade());

	SetUpSparkAimUpgrade(Template);

	return Template;
}

static function X2DataTemplate CreateSuperiorAimUpgrade()
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(Super.CreateSuperiorAimUpgrade());

	SetUpSparkAimUpgrade(Template);

	return Template;
}

static function SetUpSparkAimUpgrade(out X2WeaponUpgradeTemplate Template)
{
	Template.AddUpgradeAttachment('Optic', '', "", "", 'SparkRifle_CV', , "img:///UILibrary_Common.ConvCannon.ConvCannon_OpticsC", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvCannon_OpticsC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', '', "", "", 'SparkRifle_MG', , "img:///UILibrary_Common.UI_MagCannon.MagCannon_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagCannon_OpticC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', '', "", "", 'SparkRifle_BM', , "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamCannon_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
}

// #######################################################################################
// -------------------- EXPANDED MAG UPGRADES --------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateBasicClipSizeUpgrade()
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(Super.CreateBasicClipSizeUpgrade());

	SetUpSparkClipSizeUpgrade(Template);

	return Template;
}

static function X2DataTemplate CreateAdvancedClipSizeUpgrade()
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(Super.CreateAdvancedClipSizeUpgrade());

	SetUpSparkClipSizeUpgrade(Template);

	return Template;
}

static function X2DataTemplate CreateSuperiorClipSizeUpgrade()
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(Super.CreateSuperiorClipSizeUpgrade());

	SetUpSparkClipSizeUpgrade(Template);

	return Template;
}

static function SetUpSparkClipSizeUpgrade(out X2WeaponUpgradeTemplate Template)
{
	Template.AddUpgradeAttachment('Mag', '', "", "", 'SparkRifle_CV', , "img:///UILibrary_Common.ConvCannon.ConvCannon_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvCannon_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoReloadUpgradePresent);
	Template.AddUpgradeAttachment('Mag', '', "", "", 'SparkRifle_MG', , "img:///UILibrary_Common.UI_MagCannon.MagCannon_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagCannon_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoReloadUpgradePresent);
	Template.AddUpgradeAttachment('Mag', '', "", "", 'SparkRifle_BM', , "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamCannon_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
}

// #######################################################################################
// ------------------------ FREE FIRE UPGRADES -------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateBasicFreeFireUpgrade()
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(Super.CreateBasicFreeFireUpgrade());

	SetUpSparkFreeFireUpgrade(Template);

	return Template;
}

static function X2DataTemplate CreateAdvancedFreeFireUpgrade()
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(Super.CreateAdvancedFreeFireUpgrade());

	SetUpSparkFreeFireUpgrade(Template);

	return Template;
}

static function X2DataTemplate CreateSuperiorFreeFireUpgrade()
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(Super.CreateSuperiorFreeFireUpgrade());

	SetUpSparkFreeFireUpgrade(Template);

	return Template;
}

static function SetUpSparkFreeFireUpgrade(out X2WeaponUpgradeTemplate Template)
{
	Template.AddUpgradeAttachment('Reargrip', '', "", "", 'SparkRifle_CV', , "img:///UILibrary_Common.ConvCannon.ConvCannon_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvCannon_TriggerB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Reargrip', '', "", "", 'SparkRifle_MG', , "img:///UILibrary_Common.UI_MagCannon.MagCannon_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagCannon_TriggerB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Core', '', "", "", 'SparkRifle_BM', , "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_CoreB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamCannon_CoreB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Core_Teeth', '', "", "", 'SparkRifle_BM', , "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_Teeth", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamCannon_Teeth_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
}

// #######################################################################################
// ------------------------ RELOAD UPGRADES ----------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateBasicReloadUpgrade()
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(Super.CreateBasicReloadUpgrade());

	SetUpSparkReloadUpgrade(Template);

	return Template;
}

static function X2DataTemplate CreateAdvancedReloadUpgrade()
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(Super.CreateAdvancedReloadUpgrade());

	SetUpSparkReloadUpgrade(Template);

	return Template;
}

static function X2DataTemplate CreateSuperiorReloadUpgrade()
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(Super.CreateSuperiorReloadUpgrade());

	SetUpSparkReloadUpgrade(Template);

	return Template;
}

static function SetUpSparkReloadUpgrade(out X2WeaponUpgradeTemplate Template)
{
	Template.AddUpgradeAttachment('Mag', '', "", "", 'SparkRifle_CV', , "img:///UILibrary_Common.ConvCannon.ConvCannon_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvCannon_MagC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', '', "", "", 'SparkRifle_CV', , "img:///UILibrary_Common.ConvCannon.ConvCannon_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvCannon_MagD_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", ClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', '', "", "", 'SparkRifle_MG', , "img:///UILibrary_Common.UI_MagCannon.MagCannon_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagCannon_MagC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', '', "", "", 'SparkRifle_MG', , "img:///UILibrary_Common.UI_MagCannon.MagCannon_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagCannon_MagD_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", ClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('AutoLoader', '', "", "", 'SparkRifle_BM', , "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_AutoLoader", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamCannon_AutoLoader_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
}

// #######################################################################################
// ------------------------ OVERWATCH UPGRADES -------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateBasicMissDamageUpgrade()
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(Super.CreateBasicMissDamageUpgrade());

	SetUpSparkMissDamageUpgrade(Template);

	return Template;
}

static function X2DataTemplate CreateAdvancedMissDamageUpgrade()
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(Super.CreateAdvancedMissDamageUpgrade());

	SetUpSparkMissDamageUpgrade(Template);

	return Template;
}

static function X2DataTemplate CreateSuperiorMissDamageUpgrade()
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(Super.CreateSuperiorMissDamageUpgrade());

	SetUpSparkMissDamageUpgrade(Template);

	return Template;
}

static function SetUpSparkMissDamageUpgrade(out X2WeaponUpgradeTemplate Template)
{
	Template.AddUpgradeAttachment('Stock', '', "", "", 'SparkRifle_CV', , "img:///UILibrary_Common.ConvCannon.ConvCannon_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvCannon_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('Foregrip', '', "", "", 'SparkRifle_MG', , "img:///UILibrary_Common.UI_MagCannon.MagCannon_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagCannon_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('HeatSink', '', "", "", 'SparkRifle_BM', , "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_HeatsinkB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamCannon_HeatsinkB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
}

// #######################################################################################
// ------------------------ FREE KILL UPGRADES -------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateBasicFreeKillUpgrade()
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(Super.CreateBasicFreeKillUpgrade());

	SetUpSparkFreeKillUpgrade(Template);

	return Template;
}

static function X2DataTemplate CreateAdvancedFreeKillUpgrade()
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(Super.CreateAdvancedFreeKillUpgrade());

	SetUpSparkFreeKillUpgrade(Template);

	return Template;
}

static function X2DataTemplate CreateSuperiorFreeKillUpgrade()
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(Super.CreateSuperiorFreeKillUpgrade());

	SetUpSparkFreeKillUpgrade(Template);

	return Template;
}

static function SetUpSparkFreeKillUpgrade(out X2WeaponUpgradeTemplate Template)
{
	Template.AddUpgradeAttachment('Suppressor', '', "", "", 'SparkRifle_CV', , "img:///UILibrary_Common.ConvCannon.ConvCannon_SuppressorB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvCannon_SuppressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', '', "", "", 'SparkRifle_MG', , "img:///UILibrary_Common.UI_MagCannon.MagCannon_SuppressorB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagCannon_SuppressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', '', "", "", 'SparkRifle_BM', , "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_SupressorB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamCannon_SupressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
}