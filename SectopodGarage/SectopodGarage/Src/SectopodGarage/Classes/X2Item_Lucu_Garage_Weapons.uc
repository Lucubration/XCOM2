class X2Item_Lucu_Garage_Weapons extends X2Item
	config(Lucu_Garage_DefaultConfig);

var config array<int> Breacher_Cnv_Range;
var config WeaponDamageValue Breacher_Cnv_BaseDamage;
var config int Breacher_Cnv_iClipSize;
var config int Breacher_Cnv_iSoundRange;
var config int Breacher_Cnv_iEnvironmentDamage;

var config WeaponDamageValue Breacher_Las_BaseDamage;
var config int Breacher_Las_iClipSize;
var config int Breacher_Las_iSoundRange;
var config int Breacher_Las_iEnvironmentDamage;

var config WeaponDamageValue Breacher_Mag_BaseDamage;
var config int Breacher_Mag_iClipSize;
var config int Breacher_Mag_iSoundRange;
var config int Breacher_Mag_iEnvironmentDamage;

var config WeaponDamageValue Breacher_Beam_BaseDamage;
var config int Breacher_Beam_iClipSize;
var config int Breacher_Beam_iSoundRange;
var config int Breacher_Beam_iEnvironmentDamage;

var config array<int> Shatterer_Cnv_Range;
var config WeaponDamageValue Shatterer_Cnv_BaseDamage;
var config int Shatterer_Cnv_CritChance;
var config int Shatterer_Cnv_iClipSize;
var config int Shatterer_Cnv_iSoundRange;
var config int Shatterer_Cnv_iEnvironmentDamage;

var config WeaponDamageValue Shatterer_Las_BaseDamage;
var config int Shatterer_Las_CritChance;
var config int Shatterer_Las_iClipSize;
var config int Shatterer_Las_iSoundRange;
var config int Shatterer_Las_iEnvironmentDamage;

var config WeaponDamageValue Shatterer_Mag_BaseDamage;
var config int Shatterer_Mag_CritChance;
var config int Shatterer_Mag_iClipSize;
var config int Shatterer_Mag_iSoundRange;
var config int Shatterer_Mag_iEnvironmentDamage;

var config WeaponDamageValue Shatterer_Beam_BaseDamage;
var config int Shatterer_Beam_CritChance;
var config int Shatterer_Beam_iClipSize;
var config int Shatterer_Beam_iSoundRange;
var config int Shatterer_Beam_iEnvironmentDamage;

var config array<int> Gun_Cnv_Range;
var config WeaponDamageValue Gun_Cnv_BaseDamage;
var config int Gun_Cnv_iClipSize;
var config int Gun_Cnv_iSoundRange;
var config int Gun_Cnv_iEnvironmentDamage;

var config WeaponDamageValue Gun_Las_BaseDamage;
var config int Gun_Las_iClipSize;
var config int Gun_Las_iSoundRange;
var config int Gun_Las_iEnvironmentDamage;

var config WeaponDamageValue Gun_Mag_BaseDamage;
var config int Gun_Mag_iClipSize;
var config int Gun_Mag_iSoundRange;
var config int Gun_Mag_iEnvironmentDamage;

var config WeaponDamageValue Gun_Beam_BaseDamage;
var config int Gun_Beam_iClipSize;
var config int Gun_Beam_iSoundRange;
var config int Gun_Beam_iEnvironmentDamage;

var config WeaponDamageValue MiniRocket_BaseDamage;
var config int MiniRocket_iSoundRange;
var config int MiniRocket_iClipSize;
var config int MiniRocket_IEnvironmentDamage;
var config int MiniRocket_Range;
var config int MiniRocket_Radius;

var config WeaponDamageValue BlasterCannon_BaseDamage;
var config int BlasterCannon_iSoundRange;
var config int BlasterCannon_IEnvironmentDamage;
var config int BlasterCannon_Range;
var config int BlasterCannon_Radius;

var config WeaponDamageValue PlasmaBeam_BaseDamage;
var config int PlasmaBeam_iSoundRange;
var config int PlasmaBeam_IEnvironmentDamage;
var config int PlasmaBeam_Range;
var config int PlasmaBeam_Radius;

var config WeaponDamageValue WrathCannon_BaseDamage;
var config int WrathCannon_iSoundRange;
var config int WrathCannon_IEnvironmentDamage;
var config int WrathCannon_Range;
var config int WrathCannon_Radius;

var config WeaponDamageValue ShredderCannon_BaseDamage;
var config int ShredderCannon_iSoundRange;
var config int ShredderCannon_iClipSize;
var config int ShredderCannon_IEnvironmentDamage;
var config int ShredderCannon_Range;
var config int ShredderCannon_Radius;

var config WeaponDamageValue Mortar_BaseDamage;
var config int Mortar_iSoundRange;
var config int Mortar_iClipSize;
var config int Mortar_IEnvironmentDamage;
var config int Mortar_Range;
var config int Mortar_Radius;

var config WeaponDamageValue Flamer_BaseDamage;
var config int Flamer_iSoundRange;
var config int Flamer_iClipSize;
var config int Flamer_IEnvironmentDamage;
var config int Flamer_Range;
var config int Flamer_Radius;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;
	
	Weapons.AddItem(Breacher_Cnv());
	Weapons.AddItem(Breacher_Las());
	Weapons.AddItem(Breacher_Mag());
	Weapons.AddItem(Breacher_Beam());
	Weapons.AddItem(Shatterer_Cnv());
	Weapons.AddItem(Shatterer_Las());
	Weapons.AddItem(Shatterer_Mag());
	Weapons.AddItem(Shatterer_Beam());
	Weapons.AddItem(Gun_Cnv());
	Weapons.AddItem(Gun_Las());
	Weapons.AddItem(Gun_Mag());
	Weapons.AddItem(Gun_Beam());
	Weapons.AddItem(MiniRocket());
	Weapons.AddItem(BlasterCannon());
	Weapons.AddItem(PlasmaBeam());
	Weapons.AddItem(WrathCannon());
	Weapons.AddItem(ShredderCannon());
	Weapons.AddItem(Mortar());
	Weapons.AddItem(Flamethrower());

	return Weapons;
}


// **************************************************************************
// ***                    Mini-Sectopod Breacher CV                       ***
// **************************************************************************


static function X2DataTemplate Breacher_Cnv()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Lucu_Garage_Breacher_Cnv');
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lucu_garage_weapon_primary';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///Lucu_Garage.Primary_Breacher_CV";
	Template.Tier = 1;
	
	Template.RangeAccuracy = default.Breacher_Cnv_Range;
	Template.BaseDamage = default.Breacher_Cnv_BaseDamage;
	Template.iClipSize = default.Breacher_Cnv_iClipSize;
	Template.iSoundRange = default.Breacher_Cnv_iSoundRange;
	Template.iEnvironmentDamage = default.Breacher_Cnv_iEnvironmentDamage;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Lucu_Garage_InitAmmoReserve');
	Template.Abilities.AddItem('Lucu_Garage_Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Garage_Breacher_CV.WP_Sectopod_Turret";

	Template.iPhysicsImpulse = 5;
	
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.StartingItem = true;

	Template.TradingPostValue = 30;

	return Template;
}


// **************************************************************************
// ***                    Mini-Sectopod Breacher LS                       ***
// **************************************************************************


static function X2DataTemplate Breacher_Las()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Lucu_Garage_Breacher_Las');
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lucu_garage_weapon_primary';
	Template.WeaponTech = 'laser';
	Template.strImage = "img:///Lucu_Garage.Primary_Breacher_LS";
	Template.Tier = 2;
	
	Template.RangeAccuracy = default.Breacher_Cnv_Range;
	Template.BaseDamage = default.Breacher_Las_BaseDamage;
	Template.iClipSize = default.Breacher_Las_iClipSize;
	Template.iSoundRange = default.Breacher_Las_iSoundRange;
	Template.iEnvironmentDamage = default.Breacher_Las_iEnvironmentDamage;
	Template.InfiniteAmmo = true;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('Lucu_Garage_StandardShotPower');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Garage_Breacher_LS.WP_Sectopod_Turret";

	Template.iPhysicsImpulse = 5;
	
	Template.CanBeBuilt = true;
	Template.bInfiniteItem = true;
	Template.StartingItem = true;

	Template.TradingPostValue = 30;

	return Template;
}


// **************************************************************************
// ***                    Mini-Sectopod Breacher MG                       ***
// **************************************************************************


static function X2DataTemplate Breacher_Mag()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Lucu_Garage_Breacher_Mag');
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lucu_garage_weapon_primary';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///Lucu_Garage.Primary_Breacher_MG";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;
	
	Template.RangeAccuracy = default.Breacher_Cnv_Range;
	Template.BaseDamage = default.Breacher_Mag_BaseDamage;
	Template.iClipSize = default.Breacher_Mag_iClipSize;
	Template.iSoundRange = default.Breacher_Mag_iSoundRange;
	Template.iEnvironmentDamage = default.Breacher_Mag_iEnvironmentDamage;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Lucu_Garage_InitAmmoReserve');
	Template.Abilities.AddItem('Lucu_Garage_Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Garage_Breacher_MG.WP_Sectopod_Turret";

	Template.iPhysicsImpulse = 5;
	
	Template.CanBeBuilt = true;
	Template.bInfiniteItem = true;
	Template.StartingItem = true;

	Template.TradingPostValue = 30;

	return Template;
}


// **************************************************************************
// ***                    Mini-Sectopod Breacher BM                       ***
// **************************************************************************


static function X2DataTemplate Breacher_Beam()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Lucu_Garage_Breacher_Beam');
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lucu_garage_weapon_primary';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///Lucu_Garage.Primary_Breacher_BM";
	Template.Tier = 5;
	
	Template.RangeAccuracy = default.Breacher_Cnv_Range;
	Template.BaseDamage = default.Breacher_Beam_BaseDamage;
	Template.iClipSize = default.Breacher_Beam_iClipSize;
	Template.iSoundRange = default.Breacher_Beam_iSoundRange;
	Template.iEnvironmentDamage = default.Breacher_Beam_iEnvironmentDamage;
	Template.InfiniteAmmo = true;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('Lucu_Garage_StandardShotPower');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Garage_Breacher_BM.WP_Sectopod_Turret";

	Template.iPhysicsImpulse = 5;
	
	Template.CanBeBuilt = true;
	Template.bInfiniteItem = true;
	Template.StartingItem = true;

	Template.TradingPostValue = 30;

	return Template;
}


// **************************************************************************
// ***                   Mini-Sectopod Shatterer CV                       ***
// **************************************************************************


static function X2DataTemplate Shatterer_Cnv()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Lucu_Garage_Shatterer_Cnv');
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lucu_garage_weapon_primary';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///Lucu_Garage.Primary_Shatterer_CV";
	Template.Tier = 1;

	Template.RangeAccuracy = default.Shatterer_Cnv_Range;
	Template.BaseDamage = default.Shatterer_Cnv_BaseDamage;
	Template.CritChance = default.Shatterer_Cnv_CritChance;
	Template.iClipSize = default.Shatterer_Cnv_iClipSize;
	Template.iSoundRange = default.Shatterer_Cnv_iSoundRange;
	Template.iEnvironmentDamage = default.Shatterer_Cnv_iEnvironmentDamage;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Lucu_Garage_InitAmmoReserve');
	Template.Abilities.AddItem('Lucu_Garage_Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Lucu_Garage_ShattererDamage');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Garage_Shatterer_CV.WP_Sectopod_Turret";

	Template.iPhysicsImpulse = 5;
	
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.StartingItem = true;

	Template.TradingPostValue = 30;

	return Template;
}


// **************************************************************************
// ***                   Mini-Sectopod Shatterer LS                       ***
// **************************************************************************


static function X2DataTemplate Shatterer_Las()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Lucu_Garage_Shatterer_Las');
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lucu_garage_weapon_primary';
	Template.WeaponTech = 'laser';
	Template.strImage = "img:///Lucu_Garage.Primary_Shatterer_LS";
	Template.Tier = 2;

	Template.RangeAccuracy = default.Shatterer_Cnv_Range;
	Template.BaseDamage = default.Shatterer_Las_BaseDamage;
	Template.CritChance = default.Shatterer_Las_CritChance;
	Template.iClipSize = default.Shatterer_Las_iClipSize;
	Template.iSoundRange = default.Shatterer_Las_iSoundRange;
	Template.iEnvironmentDamage = default.Shatterer_Las_iEnvironmentDamage;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('Lucu_Garage_StandardShotPower');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Lucu_Garage_ShattererDamage');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Garage_Shatterer_LS.WP_Sectopod_Turret";

	Template.iPhysicsImpulse = 5;
	
	Template.CanBeBuilt = true;
	Template.bInfiniteItem = true;
	Template.StartingItem = true;

	Template.TradingPostValue = 30;

	return Template;
}


// **************************************************************************
// ***                   Mini-Sectopod Shatterer MG                       ***
// **************************************************************************


static function X2DataTemplate Shatterer_Mag()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Lucu_Garage_Shatterer_Mag');
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lucu_garage_weapon_primary';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///Lucu_Garage.Primary_Shatterer_MG";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.RangeAccuracy = default.Shatterer_Cnv_Range;
	Template.BaseDamage = default.Shatterer_Mag_BaseDamage;
	Template.CritChance = default.Shatterer_Mag_CritChance;
	Template.iClipSize = default.Shatterer_Mag_iClipSize;
	Template.iSoundRange = default.Shatterer_Mag_iSoundRange;
	Template.iEnvironmentDamage = default.Shatterer_Mag_iEnvironmentDamage;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Lucu_Garage_InitAmmoReserve');
	Template.Abilities.AddItem('Lucu_Garage_Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Lucu_Garage_ShattererDamage');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Garage_Shatterer_MG.WP_Sectopod_Turret";

	Template.iPhysicsImpulse = 5;
	
	Template.CanBeBuilt = true;
	Template.bInfiniteItem = true;
	Template.StartingItem = true;

	Template.TradingPostValue = 30;

	return Template;
}


// **************************************************************************
// ***                   Mini-Sectopod Shatterer BM                       ***
// **************************************************************************


static function X2DataTemplate Shatterer_Beam()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Lucu_Garage_Shatterer_Beam');
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lucu_garage_weapon_primary';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///Lucu_Garage.Primary_Shatterer_BM";
	Template.EquipSound = "Beam_Weapon_Equip";
	Template.Tier = 5;

	Template.RangeAccuracy = default.Shatterer_Cnv_Range;
	Template.BaseDamage = default.Shatterer_Beam_BaseDamage;
	Template.CritChance = default.Shatterer_Beam_CritChance;
	Template.iClipSize = default.Shatterer_Beam_iClipSize;
	Template.iSoundRange = default.Shatterer_Beam_iSoundRange;
	Template.iEnvironmentDamage = default.Shatterer_Beam_iEnvironmentDamage;
	Template.InfiniteAmmo = true;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('Lucu_Garage_StandardShotPower');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Lucu_Garage_ShattererDamage');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Garage_Shatterer_BM.WP_Sectopod_Turret";

	Template.iPhysicsImpulse = 5;
	
	Template.CanBeBuilt = true;
	Template.bInfiniteItem = true;
	Template.StartingItem = true;

	Template.TradingPostValue = 30;

	return Template;
}


// **************************************************************************
// ***                    Mini-Sectopod Gun CV                         ***
// **************************************************************************


static function X2DataTemplate Gun_Cnv()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Lucu_Garage_Gun_Cnv');
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lucu_garage_weapon_primary';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///Lucu_Garage.Primary_Turret_CV";
	Template.Tier = 1;

	Template.RangeAccuracy = default.Gun_Cnv_Range;
	Template.BaseDamage = default.Gun_Cnv_BaseDamage;
	Template.iClipSize = default.Gun_Cnv_iClipSize;
	Template.iSoundRange = default.Gun_Cnv_iSoundRange;
	Template.iEnvironmentDamage = default.Gun_Cnv_iEnvironmentDamage;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Lucu_Garage_InitAmmoReserve');
	Template.Abilities.AddItem('Lucu_Garage_Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Garage_Gun_CV.WP_Sectopod_Turret";

	Template.iPhysicsImpulse = 5;
	
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.StartingItem = true;

	Template.TradingPostValue = 30;

	return Template;
}


// **************************************************************************
// ***                    Mini-Sectopod Gun LS                         ***
// **************************************************************************


static function X2DataTemplate Gun_Las()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Lucu_Garage_Gun_Las');
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lucu_garage_weapon_primary';
	Template.WeaponTech = 'laser';
	Template.strImage = "img:///Lucu_Garage.Primary_Turret_LS";
	Template.Tier = 2;

	Template.RangeAccuracy = default.Gun_Cnv_Range;
	Template.BaseDamage = default.Gun_Las_BaseDamage;
	Template.iClipSize = default.Gun_Las_iClipSize;
	Template.iSoundRange = default.Gun_Las_iSoundRange;
	Template.iEnvironmentDamage = default.Gun_Las_iEnvironmentDamage;
	Template.InfiniteAmmo = true;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('Lucu_Garage_StandardShotPower');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Garage_Gun_LS.WP_Sectopod_Turret";

	Template.iPhysicsImpulse = 5;
	
	Template.CanBeBuilt = true;
	Template.bInfiniteItem = true;
	Template.StartingItem = true;

	Template.TradingPostValue = 30;

	return Template;
}


// **************************************************************************
// ***                    Mini-Sectopod Gun MG                         ***
// **************************************************************************


static function X2DataTemplate Gun_Mag()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Lucu_Garage_Gun_Mag');
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lucu_garage_weapon_primary';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///Lucu_Garage.Primary_Turret_MG";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.RangeAccuracy = default.Gun_Cnv_Range;
	Template.BaseDamage = default.Gun_Mag_BaseDamage;
	Template.iClipSize = default.Gun_Mag_iClipSize;
	Template.iSoundRange = default.Gun_Mag_iSoundRange;
	Template.iEnvironmentDamage = default.Gun_Mag_iEnvironmentDamage;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Lucu_Garage_InitAmmoReserve');
	Template.Abilities.AddItem('Lucu_Garage_Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Garage_Gun_MG.WP_Sectopod_Turret";

	Template.iPhysicsImpulse = 5;
	
	Template.CanBeBuilt = true;
	Template.bInfiniteItem = true;
	Template.StartingItem = true;

	Template.TradingPostValue = 30;

	return Template;
}


// **************************************************************************
// ***                    Mini-Sectopod Gun BM                         ***
// **************************************************************************


static function X2DataTemplate Gun_Beam()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Lucu_Garage_Gun_Beam');
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lucu_garage_weapon_primary';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///Lucu_Garage.Primary_Turret_BM";
	Template.EquipSound = "Beam_Weapon_Equip";
	Template.Tier = 5;

	Template.RangeAccuracy = default.Gun_Cnv_Range;
	Template.BaseDamage = default.Gun_Beam_BaseDamage;
	Template.iClipSize = default.Gun_Beam_iClipSize;
	Template.iSoundRange = default.Gun_Beam_iSoundRange;
	Template.iEnvironmentDamage = default.Gun_Beam_iEnvironmentDamage;
	Template.InfiniteAmmo = true;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('Lucu_Garage_StandardShotPower');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Garage_Gun_BM.WP_Sectopod_Turret";

	Template.iPhysicsImpulse = 5;
	
	Template.CanBeBuilt = true;
	Template.bInfiniteItem = true;
	Template.StartingItem = true;

	Template.TradingPostValue = 30;

	return Template;
}


// **************************************************************************
// ***                Secondary Weapon: Mini-Rocket                       ***
// **************************************************************************


static function X2WeaponTemplate MiniRocket()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Lucu_Garage_MiniRocket');
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lucu_garage_weapon_secondary';
	Template.WeaponTech = 'heavy';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Rocket_Launcher";

	Template.BaseDamage = default.MiniRocket_BaseDamage;
	Template.iSoundRange = default.MiniRocket_iSoundRange;
	Template.iEnvironmentDamage = default.MiniRocket_iEnvironmentDamage;
	Template.iClipSize = default.MiniRocket_iClipSize;
	Template.iRange = default.MiniRocket_Range;
	Template.iRadius = default.MiniRocket_Radius;
	
	Template.DamageTypeTemplateName = 'Explosion';
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('Lucu_Garage_MiniRocket');
	Template.Abilities.AddItem('RocketFuse');

	Template.GameArchetype = "WP_Garage_RocketLauncher_Small.WP_Wrath_Cannon_Small";
	
	Template.iPhysicsImpulse = 5;
	
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.bMergeAmmo = true;
	Template.StartingItem = true;

	Template.TradingPostValue = 30;
	
	return Template;
}


// **************************************************************************
// ***                Secondary Weapon: Blaster Cannon                    ***
// **************************************************************************


static function X2WeaponTemplate BlasterCannon()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Lucu_Garage_BlasterCannon');
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lucu_garage_weapon_secondary';
	Template.WeaponTech = 'heavy';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Blaster_Launcher";

	Template.BaseDamage = default.BlasterCannon_BaseDamage;
	Template.iSoundRange = default.BlasterCannon_iSoundRange;
	Template.iEnvironmentDamage = default.BlasterCannon_iEnvironmentDamage;
	Template.iRange = default.BlasterCannon_Range;
	Template.iRadius = default.BlasterCannon_Radius;
	
	Template.DamageTypeTemplateName = 'Explosion';
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('Lucu_Garage_BlasterCannon');

	Template.GameArchetype = "WP_Garage_BlasterLauncher_Small.WP_Wrath_Cannon_Small";
	
	Template.iPhysicsImpulse = 5;
	
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.bMergeAmmo = true;
	Template.StartingItem = true;

	Template.TradingPostValue = 30;
	
	return Template;
}


// **************************************************************************
// ***                  Secondary Weapon: Plasma Beam                     ***
// **************************************************************************


static function X2WeaponTemplate PlasmaBeam()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Lucu_Garage_PlasmaBeam');
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lucu_garage_weapon_secondary';
	Template.WeaponTech = 'heavy';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Plasma_Blaster";

	Template.BaseDamage = default.PlasmaBeam_BaseDamage;
	Template.iSoundRange = default.PlasmaBeam_iSoundRange;
	Template.iEnvironmentDamage = default.PlasmaBeam_iEnvironmentDamage;
	Template.iRange = default.PlasmaBeam_Range;
	Template.iRadius = default.PlasmaBeam_Radius;
	
	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('Lucu_Garage_PlasmaBeam');

	Template.GameArchetype = "WP_Garage_PlasmaBlaster_Small.WP_Wrath_Cannon_Small";
	
	Template.iPhysicsImpulse = 5;
	
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.bMergeAmmo = true;
	Template.StartingItem = true;

	Template.TradingPostValue = 30;
	
	return Template;
}


// **************************************************************************
// ***                 Secondary Weapon: Wrath Cannon                     ***
// **************************************************************************


static function X2WeaponTemplate WrathCannon()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Lucu_Garage_WrathCannon');
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lucu_garage_weapon_secondary';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventAssaultRifle";

	Template.BaseDamage = default.WrathCannon_BaseDamage;
	Template.iSoundRange = default.WrathCannon_iSoundRange;
	Template.iEnvironmentDamage = default.WrathCannon_iEnvironmentDamage;
	Template.iRange = default.WrathCannon_Range;
	Template.iRadius = default.WrathCannon_Radius;
	
	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('Lucu_Garage_WrathCannon');

	Template.GameArchetype = "WP_Garage_Wrath_Cannon_Small.WP_Wrath_Cannon_Small";
	
	Template.iPhysicsImpulse = 5;
	
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.bMergeAmmo = true;
	Template.StartingItem = true;

	Template.TradingPostValue = 30;
	
	return Template;
}


// **************************************************************************
// ***                Secondary Weapon: Shredder Cannon                   ***
// **************************************************************************


static function X2WeaponTemplate ShredderCannon()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Lucu_Garage_ShredderCannon');
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lucu_garage_weapon_secondary';
	Template.WeaponTech = 'heavy';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Shredstorm_Cannon";

	Template.BaseDamage = default.ShredderCannon_BaseDamage;
	Template.iSoundRange = default.ShredderCannon_iSoundRange;
	Template.iEnvironmentDamage = default.ShredderCannon_iEnvironmentDamage;
	Template.iClipSize = default.ShredderCannon_iClipSize;
	Template.iRange = default.ShredderCannon_Range;
	Template.iRadius = default.ShredderCannon_Radius;
	
	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('Lucu_Garage_ShredderCannon');

	Template.GameArchetype = "WP_Garage_ShredstormCannon_Small.WP_Wrath_Cannon_Small";
	
	Template.iPhysicsImpulse = 5;
	
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.bMergeAmmo = true;
	Template.StartingItem = true;

	Template.TradingPostValue = 30;
	
	return Template;
}


// **************************************************************************
// ***                     Secondary Weapon: Mortar                       ***
// **************************************************************************


static function X2WeaponTemplate Mortar()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Lucu_Garage_Mortar');
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lucu_garage_weapon_secondary';
	Template.WeaponTech = 'heavy';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Mortar";

	Template.BaseDamage = default.Mortar_BaseDamage;
	Template.iSoundRange = default.Mortar_iSoundRange;
	Template.iEnvironmentDamage = default.Mortar_iEnvironmentDamage;
	Template.iClipSize = default.Mortar_iClipSize;
	Template.iRange = default.Mortar_Range;
	Template.iRadius = default.Mortar_Radius;
	
	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('Lucu_Garage_Mortar');

	Template.GameArchetype = "WP_Garage_Mortar_Small.WP_Wrath_Cannon_Small";
	
	Template.iPhysicsImpulse = 15;
	
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.bMergeAmmo = true;
	Template.StartingItem = true;

	Template.TradingPostValue = 30;

	// This controls how much arc this projectile may have and how many times it may bounce
	Template.WeaponPrecomputedPathData.InitialPathTime = 4.0;
	Template.WeaponPrecomputedPathData.MaxPathTime = 20.0;
	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;
	
	return Template;
}


// **************************************************************************
// ***                  Secondary Weapon: Flamethrower                    ***
// **************************************************************************


static function X2WeaponTemplate Flamethrower()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Lucu_Garage_Flamethrower');
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lucu_garage_weapon_secondary';
	Template.WeaponTech = 'heavy';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_FlameThrower";

	Template.BaseDamage = default.Flamer_BaseDamage;
	Template.iSoundRange = default.Flamer_iSoundRange;
	Template.iEnvironmentDamage = default.Flamer_iEnvironmentDamage;
	Template.iClipSize = default.Flamer_iClipSize;
	Template.iRange = default.Flamer_Range;
	Template.iRadius = default.Flamer_Radius;
	Template.DamageTypeTemplateName = 'Fire';
	Template.fCoverage = 33.0f;
	
	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('Lucu_Garage_Flamethrower');

	Template.GameArchetype = "WP_Garage_FlameThrower_Small.WP_Wrath_Cannon_Small";
	
	Template.iPhysicsImpulse = 5;
	
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.bMergeAmmo = true;
	Template.StartingItem = true;

	Template.TradingPostValue = 30;
	
	return Template;
}
