class X2Item_Lucu_Garage_Utility extends X2Item
	config(Lucu_Garage_DefaultConfig);

var config int AutoLoader_Limit;
var config int MunitionsStorage_Limit;
var config int ExtraCapacitors_Limit;
var config int AuxiliaryGenerator_Limit;
var config int TargetingUplink_Limit;
var config int AdaptiveCamo_Limit;
var config int HardenedArmor_Limit;
var config int LaserTargeter_Limit;
var config int AdvancedOptics_Limit;
var config int RedundantSystems_Limit;
var config int Smokescreen_Limit;
var config int AbsorptionField_Limit;
var config int ShieldGenerator_Limit;
var config int Smokescreen_Radius;
var config int Smokescreen_SoundRange;
var config int Smokescreen_ClipSize;
	
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(AutoLoader());
	Templates.AddItem(MunitionsStorage());
	Templates.AddItem(ExtraCapacitors());
	Templates.AddItem(AuxiliaryGenerator());
	Templates.AddItem(TargetingUplink());
	Templates.AddItem(AdaptiveCamo());
	Templates.AddItem(HardenedArmor());
	Templates.AddItem(LaserTargeter());
	Templates.AddItem(AdvancedOptics());
	Templates.AddItem(RedundantSystems());
	Templates.AddItem(SmokescreenItem());
	Templates.AddItem(SmokescreenWeapon());
	Templates.AddItem(AbsorptionField());
	Templates.AddItem(ShieldGenerator());
	
	return Templates;
}


// **************************************************************************
// ***                           Auto-Loader                              ***
// **************************************************************************


static function X2DataTemplate AutoLoader()
{
	local X2UtilityItemTemplate_Lucu_Garage Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2UtilityItemTemplate_Lucu_Garage', Template, 'Lucu_Garage_AutoLoader');
	Template.ItemCat = 'lucu_garage_utility';
	Template.strImage = "img:///Lucu_Garage.Util_Ammo_Reload";

	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 0;
	
	Template.BonusAbilities.AddItem('Lucu_Garage_FreeReload');

	Template.Limit = default.AutoLoader_Limit;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 55;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}


// **************************************************************************
// ***                        Munitions Storage                           ***
// **************************************************************************


static function X2DataTemplate MunitionsStorage()
{
	local X2UtilityItemTemplate_Lucu_Garage Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2UtilityItemTemplate_Lucu_Garage', Template, 'Lucu_Garage_MunitionsStorage');
	Template.ItemCat = 'lucu_garage_utility';
	Template.strImage = "img:///Lucu_Garage.Util_Ammo_Storage";

	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 0;
	
	Template.BonusAbilities.AddItem('Lucu_Garage_MunitionsStorage');

	Template.Limit = default.MunitionsStorage_Limit;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 55;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}


// **************************************************************************
// ***                         Extra Capacitors                           ***
// **************************************************************************


static function X2DataTemplate ExtraCapacitors()
{
	local X2UtilityItemTemplate_Lucu_Garage Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2UtilityItemTemplate_Lucu_Garage', Template, 'Lucu_Garage_ExtraCapacitors');
	Template.ItemCat = 'lucu_garage_utility';
	Template.strImage = "img:///Lucu_Garage.Util_Power_Capacitors";

	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 0;
	
	Template.BonusAbilities.AddItem('Lucu_Garage_ExtraCapacitors');

	Template.Limit = default.ExtraCapacitors_Limit;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 55;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}


// **************************************************************************
// ***                       Auxiliary Generator                          ***
// **************************************************************************


static function X2DataTemplate AuxiliaryGenerator()
{
	local X2UtilityItemTemplate_Lucu_Garage Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2UtilityItemTemplate_Lucu_Garage', Template, 'Lucu_Garage_AuxiliaryGenerator');
	Template.ItemCat = 'lucu_garage_utility';
	Template.strImage = "img:///Lucu_Garage.Util_Power_Generator";

	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 0;
	
	Template.BonusAbilities.AddItem('Lucu_Garage_AuxiliaryGenerator');

	Template.Limit = default.AuxiliaryGenerator_Limit;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 55;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}


// **************************************************************************
// ***                         Targeting Uplink                           ***
// **************************************************************************


static function X2DataTemplate TargetingUplink()
{
	local X2UtilityItemTemplate_Lucu_Garage Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2UtilityItemTemplate_Lucu_Garage', Template, 'Lucu_Garage_TargetingUplink');
	Template.ItemCat = 'lucu_garage_utility';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Amp_Booster";

	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 0;
	
	Template.BonusAbilities.AddItem('Squadsight');

	Template.Limit = default.TargetingUplink_Limit;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 75;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}


// **************************************************************************
// ***                          Adaptive Camo                             ***
// **************************************************************************


static function X2DataTemplate AdaptiveCamo()
{
	local X2UtilityItemTemplate_Lucu_Garage Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2UtilityItemTemplate_Lucu_Garage', Template, 'Lucu_Garage_AdaptiveCamo');
	Template.ItemCat = 'lucu_garage_utility';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Hellweave";

	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 0;
	
	Template.BonusAbilities.AddItem('Lucu_Garage_AdaptiveCamoPhantom');
	Template.BonusAbilities.AddItem('Lucu_Garage_AdaptiveCamoStealth');

	Template.Limit = default.AdaptiveCamo_Limit;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 75;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}


// **************************************************************************
// ***                          Hardened Armor                            ***
// **************************************************************************


static function X2DataTemplate HardenedArmor()
{
	local X2UtilityItemTemplate_Lucu_Garage Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2UtilityItemTemplate_Lucu_Garage', Template, 'Lucu_Garage_HardenedArmor');
	Template.ItemCat = 'lucu_garage_utility';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_MindShield";

	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 0;
	
	Template.BonusAbilities.AddItem('Lucu_Garage_HardenedArmor');

	Template.Limit = default.HardenedArmor_Limit;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 45;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}


// **************************************************************************
// ***                          Laser Targeter                            ***
// **************************************************************************


static function X2DataTemplate LaserTargeter()
{
	local X2UtilityItemTemplate_Lucu_Garage Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2UtilityItemTemplate_Lucu_Garage', Template, 'Lucu_Garage_LaserTargeter');
	Template.ItemCat = 'lucu_garage_utility';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticB_inv";

	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 0;
	
	Template.BonusAbilities.AddItem('Lucu_Garage_LaserTargeter');

	Template.Limit = default.LaserTargeter_Limit;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 45;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}


// **************************************************************************
// ***                         Advanced Optics                            ***
// **************************************************************************


static function X2DataTemplate AdvancedOptics()
{
	local X2UtilityItemTemplate_Lucu_Garage Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2UtilityItemTemplate_Lucu_Garage', Template, 'Lucu_Garage_AdvancedOptics');
	Template.ItemCat = 'lucu_garage_utility';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_CombatSim_Perception";

	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 0;
	
	Template.BonusAbilities.AddItem('Lucu_Garage_AdvancedOptics');

	Template.Limit = default.AdvancedOptics_Limit;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel, eStat_Offense, class'X2Ability_Lucu_Garage_UtilityItemAbilitySet'.default.AdvancedOpticsAimModifier, true);

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 65;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}


// **************************************************************************
// ***                         Redundant Systems                          ***
// **************************************************************************


static function X2DataTemplate RedundantSystems()
{
	local X2UtilityItemTemplate_Lucu_Garage Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2UtilityItemTemplate_Lucu_Garage', Template, 'Lucu_Garage_RedundantSystems');
	Template.ItemCat = 'lucu_garage_utility';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_CombatSim_Metabolism";

	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 0;
	
	Template.BonusAbilities.AddItem('Lucu_Garage_RedundantSystems');

	Template.Limit = default.RedundantSystems_Limit;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel, eStat_HP, class'X2Ability_Lucu_Garage_UtilityItemAbilitySet'.default.RedundantSystemsHealthModifier, true);

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 65;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}


// **************************************************************************
// ***                            Smokescreen                             ***
// **************************************************************************


static function X2DataTemplate SmokescreenItem()
{
	local X2UtilityItemTemplate_Lucu_Garage Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2UtilityItemTemplate_Lucu_Garage', Template, 'Lucu_Garage_SmokescreenItem');
	Template.ItemCat = 'lucu_garage_utility';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Smoke_Grenade";
	
	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 0;
	
	Template.BonusAbilities.AddItem('Lucu_Garage_SmokescreenItem');
	
	Template.Limit = default.Smokescreen_Limit;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 35;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate SmokescreenWeapon()
{
	local X2GrenadeTemplate Template;
	local X2Effect_ApplySmokeGrenadeToWorld WeaponEffect;
	local X2Effect_SmokeGrenade Effect;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'Lucu_Garage_SmokescreenWeapon');
	Template.ItemCat = 'utility';
	Template.WeaponCat = 'utility';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Smoke_Grenade";
	
	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 0;
	
	Template.InventorySlot = eInvSlot_Utility;
	Template.bMergeAmmo = true;
	Template.bFriendlyFireWarning = false;

	Template.iRadius = default.Smokescreen_Radius;
	Template.iSoundRange = default.Smokescreen_SoundRange;
	Template.iClipSize = default.Smokescreen_ClipSize;

	Template.Abilities.AddItem('Lucu_Garage_SmokescreenWeapon');
	
	WeaponEffect = new class'X2Effect_ApplySmokeGrenadeToWorld';	
	Template.ThrownGrenadeEffects.AddItem(WeaponEffect);

	Effect = new class'X2Effect_SmokeGrenade';
	Effect.BuildPersistentEffect(class'X2Ability_Lucu_Garage_UtilityItemAbilitySet'.default.SmokescreenDuration, false, false, false, eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, class'X2Item_DefaultGrenades'.default.SmokeGrenadeEffectDisplayName, class'X2Item_DefaultGrenades'.default.SmokeGrenadeEffectDisplayDesc, "img:///UILibrary_PerkIcons.UIPerk_grenade_smoke");
	Effect.HitMod = class'X2Ability_Lucu_Garage_UtilityItemAbilitySet'.default.SmokescreenHitMod;
	Effect.DuplicateResponse = eDupe_Refresh;
	Template.ThrownGrenadeEffects.AddItem(Effect);

	Template.GameArchetype = "WP_Grenade_Smoke.WP_Grenade_Smoke";

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 35;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}


// **************************************************************************
// ***                         Absorption Field                           ***
// **************************************************************************


static function X2DataTemplate AbsorptionField()
{
	local X2UtilityItemTemplate_Lucu_Garage Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2UtilityItemTemplate_Lucu_Garage', Template, 'Lucu_Garage_AbsorptionField');
	Template.ItemCat = 'lucu_garage_utility';
	Template.strImage = "img:///Lucu_Garage.Util_Absorption_Field";

	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 0;
	
	Template.BonusAbilities.AddItem('Lucu_Garage_AbsorptionField');

	Template.Limit = default.ShieldGenerator_Limit;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 75;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}


// **************************************************************************
// ***                         Shield Generator                           ***
// **************************************************************************


static function X2DataTemplate ShieldGenerator()
{
	local X2UtilityItemTemplate_Lucu_Garage Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2UtilityItemTemplate_Lucu_Garage', Template, 'Lucu_Garage_ShieldGenerator');
	Template.ItemCat = 'lucu_garage_utility';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_MindShield";

	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 0;
	
	Template.BonusAbilities.AddItem('Lucu_Garage_ShieldGenerator');

	Template.Limit = default.ShieldGenerator_Limit;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 75;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}
