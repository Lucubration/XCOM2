//---------------------------------------------------------------------------------------
//  FILE:    X2Item_DLC_Day90Weapons.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Item_DLC_Day90Weapons extends X2Item config(GameData_WeaponData);

var config WeaponDamageValue SPARKRIFLE_CONVENTIONAL_BASEDAMAGE;
var config WeaponDamageValue SPARKRIFLE_MAGNETIC_BASEDAMAGE;
var config WeaponDamageValue SPARKRIFLE_BEAM_BASEDAMAGE;

var config array <WeaponDamageValue> SPARKBIT_CONVENTIONAL_ABILITY_DAMAGE;
var config array <WeaponDamageValue> SPARKBIT_MAGNETIC_ABILITY_DAMAGE;
var config array <WeaponDamageValue> SPARKBIT_BEAM_ABILITY_DAMAGE;

var config array <WeaponDamageValue> GREMLINSHEN_ABILITYDAMAGE;

var config WeaponDamageValue LOSTTOWERSTURRETM1_WPN_BASEDAMAGE;

var config WeaponDamageValue SPARK_DEATH_EXPLOSION_BASEDAMAGE;
var config WeaponDamageValue SPARK_NOVA_MULTITARGET_BASEDAMAGE;
var config WeaponDamageValue SPARK_NOVA_SELF_BASEDAMAGE;

// ***** Core properties and variables for weapons *****
var config int SPARKRIFLE_CONVENTIONAL_AIM;
var config int SPARKRIFLE_CONVENTIONAL_CRITCHANCE;
var config int SPARKRIFLE_CONVENTIONAL_ICLIPSIZE;
var config int SPARKRIFLE_CONVENTIONAL_ISOUNDRANGE;
var config int SPARKRIFLE_CONVENTIONAL_IENVIRONMENTDAMAGE;
var config int SPARKRIFLE_CONVENTIONAL_IPOINTS;

var config int SPARKRIFLE_MAGNETIC_AIM;
var config int SPARKRIFLE_MAGNETIC_CRITCHANCE;
var config int SPARKRIFLE_MAGNETIC_ICLIPSIZE;
var config int SPARKRIFLE_MAGNETIC_ISOUNDRANGE;
var config int SPARKRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
var config int SPARKRIFLE_MAGNETIC_IPOINTS;

var config int SPARKRIFLE_BEAM_AIM;
var config int SPARKRIFLE_BEAM_CRITCHANCE;
var config int SPARKRIFLE_BEAM_ICLIPSIZE;
var config int SPARKRIFLE_BEAM_ISOUNDRANGE;
var config int SPARKRIFLE_BEAM_IENVIRONMENTDAMAGE;
var config int SPARKRIFLE_BEAM_IPOINTS;

var config int SPARKBIT_ISOUNDRANGE;
var config int SPARKBIT_IENVIRONMENTDAMAGE;
var config int SPARKBIT_IPOINTS;

var config int SPARKBIT_CONVENTIONAL_HACKBONUS;
var config int SPARKBIT_MAGNETIC_HACKBONUS;
var config int SPARKBIT_BEAM_HACKBONUS;

var config int GREMLINSHEN_HACKBONUS;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

	Weapons.AddItem(CreateTemplate_SparkRifle_Conventional());
	Weapons.AddItem(CreateTemplate_SparkRifle_Magnetic());
	Weapons.AddItem(CreateTemplate_SparkRifle_Beam());

	Weapons.AddItem(CreateTemplate_SparkBit_Conventional());
	Weapons.AddItem(CreateTemplate_SparkBit_Magnetic());
	Weapons.AddItem(CreateTemplate_SparkBit_Beam());

	// Lost Towers Shen's Rover
	Weapons.AddItem(CreateTemplate_GremlinDrone_Shen());

	// Lost Towers Turret Weapon
	Weapons.AddItem(CreateTemplate_LostTowersTurretM1_WPN());

	return Weapons;
}

// **************************************************************************
// ***                          Spark Rifle                               ***
// **************************************************************************
static function X2DataTemplate CreateTemplate_SparkRifle_Conventional()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'SparkRifle_CV');
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.EquipSound = "Conventional_Weapon_Equip";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sparkrifle';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_DLC3Images.ConvSparkRifle_base";
	Template.Tier = 0;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.SPARKRIFLE_CONVENTIONAL_BASEDAMAGE;
	Template.Aim = default.SPARKRIFLE_CONVENTIONAL_AIM;
	Template.CritChance = default.SPARKRIFLE_CONVENTIONAL_CRITCHANCE;
	Template.iClipSize = default.SPARKRIFLE_CONVENTIONAL_ICLIPSIZE;
	Template.iSoundRange = default.SPARKRIFLE_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SPARKRIFLE_CONVENTIONAL_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 1;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "DLC_3_WP_SparkRifle_CV.WP_SparkRifle_CV";

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	
	Template.iPhysicsImpulse = 5;

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	
	Template.fKnockbackDamageAmount = 5.0f;
	Template.fKnockbackDamageRadius = 0.0f;

	Template.DamageTypeTemplateName = 'Projectile_Conventional';
	
	return Template;
}

static function X2DataTemplate CreateTemplate_SparkRifle_Magnetic()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'SparkRifle_MG');
	Template.WeaponPanelImage = "_MagneticRifle";                       // used by the UI. Probably determines iconview of the weapon.

	Template.WeaponCat = 'sparkrifle';
	Template.WeaponTech = 'magnetic';
	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_DLC3Images.MagSparkRifle_base";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_MAGNETIC_RANGE;
	Template.BaseDamage = default.SPARKRIFLE_MAGNETIC_BASEDAMAGE;
	Template.Aim = default.SPARKRIFLE_MAGNETIC_AIM;
	Template.CritChance = default.SPARKRIFLE_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.SPARKRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.SPARKRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SPARKRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 2;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	Template.GameArchetype = "DLC_3_WP_SparkRifle_MG.WP_SparkRifle_MG";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	
	Template.iPhysicsImpulse = 5;

	Template.CreatorTemplateName = 'SparkRifle_MG_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'SparkRifle_CV'; // Which item this will be upgraded from
	
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}

static function X2DataTemplate CreateTemplate_SparkRifle_Beam()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'SparkRifle_BM');
	Template.WeaponPanelImage = "_BeamRifle";                       // used by the UI. Probably determines iconview of the weapon.

	Template.WeaponCat = 'sparkrifle';
	Template.WeaponTech = 'beam';
	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_DLC3Images.BeamSparkRifle_base";
	Template.EquipSound = "Beam_Weapon_Equip";
	Template.Tier = 5;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_BEAM_RANGE;
	Template.BaseDamage = default.SPARKRIFLE_BEAM_BASEDAMAGE;
	Template.Aim = default.SPARKRIFLE_BEAM_AIM;
	Template.CritChance = default.SPARKRIFLE_BEAM_CRITCHANCE;
	Template.iClipSize = default.SPARKRIFLE_BEAM_ICLIPSIZE;
	Template.iSoundRange = default.SPARKRIFLE_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SPARKRIFLE_BEAM_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 2;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	Template.GameArchetype = "DLC_3_WP_SparkRifle_BM.WP_SparkRifle_BM";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	
	Template.iPhysicsImpulse = 5;

	Template.CreatorTemplateName = 'SparkRifle_BM_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'SparkRifle_MG'; // Which item this will be upgraded from

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_BeamXCom';

	return Template;
}

// **************************************************************************
// ***                       SPARK Bit		                              ***
// **************************************************************************

static function X2DataTemplate CreateTemplate_SparkBit_Conventional()
{
	local X2GremlinTemplate Template;

	`CREATE_X2TEMPLATE(class'X2GremlinTemplate', Template, 'SparkBit_CV');
	Template.WeaponPanelImage = "_Gremlin";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sparkbit';
	Template.WeaponTech = 'conventional';
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	Template.strImage = "img:///UILibrary_DLC3Images.Inv_Bit_conv";
	Template.EquipSound = "Gremlin_Equip";
	Template.CosmeticUnitTemplate = "SparkBitMk1";
	Template.Tier = 0;

	Template.ExtraDamage = default.SPARKBIT_CONVENTIONAL_ABILITY_DAMAGE;
	Template.BaseDamage.Damage = 2;     //  combat protocol
	Template.BaseDamage.Pierce = 1000;  //  ignore armor
	Template.HackingAttemptBonus = default.SPARKBIT_CONVENTIONAL_HACKBONUS;

	Template.NumUpgradeSlots = 0;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;
	
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Electrical';

	Template.bHideDamageStat = true;
	
	return Template;
}

static function X2DataTemplate CreateTemplate_SparkBit_Magnetic()
{
	local X2GremlinTemplate Template;

	`CREATE_X2TEMPLATE(class'X2GremlinTemplate', Template, 'SparkBit_MG');
	Template.WeaponPanelImage = "_Gremlin";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sparkbit';
	Template.WeaponTech = 'magnetic';
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	Template.strImage = "img:///UILibrary_DLC3Images.Inv_Bit_mag";
	Template.EquipSound = "Gremlin_Equip";
	Template.CosmeticUnitTemplate = "SparkBitMk2";
	Template.Tier = 2;

	Template.ExtraDamage = default.SPARKBIT_MAGNETIC_ABILITY_DAMAGE;
	Template.BaseDamage.Damage = 2;     //  combat protocol
	Template.BaseDamage.Pierce = 1000;  //  ignore armor
	Template.HackingAttemptBonus = default.SPARKBIT_MAGNETIC_HACKBONUS;

	Template.NumUpgradeSlots = 0;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.CreatorTemplateName = 'PlatedSparkArmor_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'SparkBit_CV'; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Electrical';

	Template.bHideDamageStat = true;

	return Template;
}

static function X2DataTemplate CreateTemplate_SparkBit_Beam()
{
	local X2GremlinTemplate Template;

	`CREATE_X2TEMPLATE(class'X2GremlinTemplate', Template, 'SparkBit_BM');
	Template.WeaponPanelImage = "_Gremlin";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sparkbit';
	Template.WeaponTech = 'beam';
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	Template.strImage = "img:///UILibrary_DLC3Images.Inv_Bit_beam";
	Template.EquipSound = "Gremlin_Equip";
	Template.CosmeticUnitTemplate = "SparkBitMk3";
	Template.Tier = 4;

	Template.ExtraDamage = default.SPARKBIT_BEAM_ABILITY_DAMAGE;
	Template.BaseDamage.Damage = 2;     //  combat protocol
	Template.BaseDamage.Pierce = 1000;  //  ignore armor
	Template.HackingAttemptBonus = default.SPARKBIT_BEAM_HACKBONUS;

	Template.NumUpgradeSlots = 0;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.CreatorTemplateName = 'PoweredSparkArmor_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'SparkBit_MG'; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Electrical';

	Template.bHideDamageStat = true;

	return Template;
}

// **************************************************************************
// ***                       Gremlin Weapons                              ***
// **************************************************************************

static function X2DataTemplate CreateTemplate_GremlinDrone_Shen()
{
	local X2GremlinTemplate Template;

	`CREATE_X2TEMPLATE(class'X2GremlinTemplate', Template, 'Gremlin_Shen');
	Template.WeaponPanelImage = "_Gremlin";                       // used by the UI. Probably determines iconview of the weapon.
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Gremlin_Drone";
	Template.EquipSound = "Gremlin_Equip";

	Template.CosmeticUnitTemplate = "RovR";
	Template.Tier = 5;

	Template.ExtraDamage = default.GREMLINSHEN_ABILITYDAMAGE;
	Template.HackingAttemptBonus = default.GREMLINSHEN_HACKBONUS;
	Template.AidProtocolBonus = 20;
	Template.HealingBonus = 2;
	Template.RevivalChargesBonus = 1;
	Template.ScanningChargesBonus = 1;
	Template.BaseDamage.Damage = 6;     //  combat protocol
	Template.BaseDamage.Pierce = 1000;  //  ignore armor

	Template.iRange = 2;
	Template.iRadius = 40;              //  only for scanning protocol
	Template.NumUpgradeSlots = 1;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;
	
	Template.DamageTypeTemplateName = 'Electrical';

	Template.bHideDamageStat = true;
	Template.SetUIStatMarkup(class'XLocalizedData'.default.TechBonusLabel, eStat_Hacking, default.GREMLINSHEN_HACKBONUS, true);

	return Template;
}

// **************************************************************************
// ***                  Lost Towers Turret Weapon                         ***
// **************************************************************************

static function X2DataTemplate CreateTemplate_LostTowersTurretM1_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'LostTowersTurretM1_WPN');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventTurret";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.LOSTTOWERSTURRETM1_WPN_BASEDAMAGE;
	Template.iClipSize = 1;
	Template.InfiniteAmmo = true;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = class'X2Item_DefaultWeapons'.default.ADVTURRETM1_IDEALRANGE;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot_NoEnd'); // UPDATE - All turrets can TakeTwo shots (was- deliberately different from the mk2 and mk3).
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Turret_MG.WP_Turret_MG";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	Template.DamageTypeTemplateName = 'Projectile_Conventional';

	return Template;
}


defaultproperties
{
	bShouldCreateDifficultyVariants = true
}