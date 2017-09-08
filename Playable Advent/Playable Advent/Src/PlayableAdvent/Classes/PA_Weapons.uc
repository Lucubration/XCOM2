class PA_Weapons extends X2Item
	config(PlayableAdvent);

// var config int PoisonSpitCharges;
var config int PoisonSpitRadius;
var config int PoisonSpitRange;
var config WeaponDamageValue PA_MecGunDamage;
var config WeaponDamageValue PA_MecGunBeamDamage;
var config WeaponDamageValue PA_MecMissileDamage;
var config WeaponDamageValue PA_MecMissilePlasmaDamage;
var config int PA_MecGunAim;
var config int PA_MecGunBeamAim;
var config int PA_ViperTongueAim;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> ModWeapons;
	`log ("davea debug weapon-create-templates enter");
	ModWeapons.AddItem(CreateTemplate_PA_ViperTongue());
	ModWeapons.AddItem(CreateTemplate_PA_PoisonSpitGlob());
	ModWeapons.AddItem(CreateTemplate_PA_MecGun());
	ModWeapons.AddItem(CreateTemplate_PA_MecGunBeam());
	ModWeapons.AddItem(CreateTemplate_PA_MecMissile());
	ModWeapons.AddItem(CreateTemplate_PA_MecMissilePlasma());
	ModWeapons.AddItem(CreateTemplate_PA_MutonGun());
	ModWeapons.AddItem(CreateTemplate_PA_MutonBayonet());
	`log ("davea debug weapon-create-templates done");

	return ModWeapons;
}

static function X2DataTemplate CreateTemplate_PA_ViperTongue()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'PA_ViperTongue');

	Template.WeaponPanelImage = "_ConventionalRifle";
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'PA_ViperTongueCat';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_PlayableAdvent.ViperTongue";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);
	Template.Aim = default.PA_ViperTongueAim;
	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = class'X2Item_DefaultWeapons'.default.VIPER_WPN_BASEDAMAGE;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = class'X2Item_DefaultWeapons'.default.VIPER_IDEALRANGE;
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	// grant in classdata.ini instead: Template.Abilities.AddItem('GetOverHere');
	Template.GameArchetype = "WP_Viper_Strangle_and_Pull.WP_Viper_Strangle_and_Pull";
	Template.iPhysicsImpulse = 5;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.TradingPostValue = 30;
	return Template;
}

static function X2DataTemplate CreateTemplate_PA_PoisonSpitGlob()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'PA_PoisonSpitGlob');

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'PA_PoisonSpitGlobCat';
	Template.strImage = "img:///UILibrary_PlayableAdvent.ViperTongue";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.GameArchetype = "WP_Viper_PoisonSpit.WP_Viper_PoisonSpit";
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.iRange = default.PoisonSpitRange;
	Template.iRadius = default.PoisonSpitRadius;
	Template.iClipSize = 7;
	Template.InfiniteAmmo = true;
	Template.bHideClipSizeStat = true;
	Template.iSoundRange = 6;
	Template.bSoundOriginatesFromOwnerLocation = true;
	Template.InventorySlot = eInvSlot_Unknown; // was utility
	Template.StowedLocation = eSlot_None;
	Template.Abilities.AddItem('PA_PoisonSpit');
	Template.WeaponPrecomputedPathData.InitialPathTime = 0.5;
	Template.WeaponPrecomputedPathData.MaxPathTime = 1.0;
	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;

	return Template;
}

// Vanilla weapon has WeaponCat rifle, so anybody could use it
static function X2DataTemplate CreateTemplate_PA_MecGun()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'PA_MecGun');

	Template.WeaponPanelImage = "_ConventionalRifle";
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'PA_MecGunCat';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_PlayableAdvent.INV_AdventMec1Gun";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);
	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.PA_MecGunDamage;
	Template.Aim = default.PA_MecGunAim;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = class'X2Item_DefaultWeapons'.default.ADVMEC_M1_IDEALRANGE;
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.GameArchetype = "WP_AdvMec_Gun.WP_AdvMecGun";
	Template.iPhysicsImpulse = 5;
	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;
	Template.bInfiniteItem = true;
	Template.DamageTypeTemplateName = 'Projectile_Conventional';

	// Upgrade slots and related graphics
	Template.NumUpgradeSlots = 1;
	Template.AddDefaultAttachment('Mag', "ConvSniper.Meshes.SM_ConvSniper_MagA", , "img:///UILibrary_PlayableAdvent.AdventMecGun_Mag");
	Template.AddDefaultAttachment('Optic', "ConvSniper.Meshes.SM_ConvSniper_OpticA", , "img:///UILibrary_PlayableAdvent.AdventMecGun_Optic");
	Template.AddDefaultAttachment('Stock', "ConvSniper.Meshes.SM_ConvSniper_StockA", , "img:///UILibrary_PlayableAdvent.AdventMecGun_Stock");
	Template.AddDefaultAttachment('Trigger', "ConvSniper.Meshes.SM_ConvSniper_TriggerA", , "img:///UILibrary_PlayableAdvent.AdventMecGun_Trigger");

	return Template;
}

// Beam variant, modeled after AssaultRifle_Beam
static function X2DataTemplate CreateTemplate_PA_MecGunBeam()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'PA_MecGunBeam');

	Template.WeaponPanelImage = "_ConventionalRifle";
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'PA_MecGunCat';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_PlayableAdvent.INV_AdventMec2Gun";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);
	Template.Tier = 4;
	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_BEAM_RANGE;
	Template.BaseDamage = default.PA_MecGunBeamDamage;
	Template.Aim = default.PA_MecGunBeamAim;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_BEAM_IENVIRONMENTDAMAGE;
	Template.iIdealRange = class'X2Item_DefaultWeapons'.default.ADVMEC_M1_IDEALRANGE;
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.GameArchetype = "WP_AdvMec_Gun.WP_AdvMecGun";
	Template.iPhysicsImpulse = 5;
	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;
	Template.bInfiniteItem = true;
	Template.DamageTypeTemplateName = 'Projectile_BeamXCom';
	Template.CreatorTemplateName = 'PA_MecGunBeam_Schematic';
	Template.BaseItem = 'PA_MecGun';

	// Upgrade slots and related graphics
	Template.NumUpgradeSlots = 2;
	Template.AddDefaultAttachment('Mag', "ConvSniper.Meshes.SM_ConvSniper_MagA", , "img:///UILibrary_PlayableAdvent.AdventMecGun_Mag");
	Template.AddDefaultAttachment('Optic', "ConvSniper.Meshes.SM_ConvSniper_OpticA", , "img:///UILibrary_PlayableAdvent.AdventMecGun_Optic");
	Template.AddDefaultAttachment('Stock', "ConvSniper.Meshes.SM_ConvSniper_StockA", , "img:///UILibrary_PlayableAdvent.AdventMecGun_Stock");
	Template.AddDefaultAttachment('Trigger', "ConvSniper.Meshes.SM_ConvSniper_TriggerA", , "img:///UILibrary_PlayableAdvent.AdventMecGun_Trigger");

	return Template;
}

static function X2DataTemplate CreateTemplate_PA_MecMissile()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'PA_MecMissile');
	
	Template.WeaponPanelImage = "_ConventionalRifle";
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shoulder_launcher';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventMecGun";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);
	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.PA_MecMissileDamage;
	Template.iClipSize = 2;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = class'X2Item_DefaultWeapons'.default.ADVMEC_M2_IDEALRANGE;
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('MicroMissiles');
	Template.Abilities.AddItem('MicroMissileFuse');
	Template.GameArchetype = "WP_AdvMec_Launcher.WP_AdvMecLauncher";
	Template.iPhysicsImpulse = 5;
	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;
	Template.iRange = 20;
	Template.bInfiniteItem = true;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.WeaponPrecomputedPathData.InitialPathTime = 1.5;
	Template.WeaponPrecomputedPathData.MaxPathTime = 2.5;
	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;

	return Template;
}


static function X2DataTemplate CreateTemplate_PA_MecMissilePlasma()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'PA_MecMissilePlasma');
	
	Template.WeaponPanelImage = "_ConventionalRifle";
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shoulder_launcher';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventMecGun";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);
	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.PA_MecMissilePlasmaDamage;
	Template.iClipSize = 4;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = 20; // pretty large actually
	Template.iIdealRange = class'X2Item_DefaultWeapons'.default.ADVMEC_M2_IDEALRANGE;
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('PA_MegaMissiles');
	Template.Abilities.AddItem('MicroMissileFuse');
	Template.GameArchetype = "WP_AdvMec_Launcher.WP_AdvMecLauncher";
	Template.iPhysicsImpulse = 5;
	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;
	Template.iRange = 20;
	Template.bInfiniteItem = true;
	Template.WeaponPrecomputedPathData.InitialPathTime = 1.5;
	Template.WeaponPrecomputedPathData.MaxPathTime = 2.5;
	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.CreatorTemplateName = 'PA_MecMissilePlasma_Schematic';
	Template.BaseItem = 'PA_MecMissile';

	return Template;
}


// Vanilla weapon has WeaponCat rifle, so anybody could use it
static function X2DataTemplate CreateTemplate_PA_MutonGun()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'PA_MutonGun');

	Template.WeaponPanelImage = "_ConventionalRifle";
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'PA_MutonGunCat';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.MutonRifle";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);
	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = class'X2Item_DefaultWeapons'.default.MUTON_WPN_BASEDAMAGE;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = class'X2Item_DefaultWeapons'.default.MUTON_IDEALRANGE;
	Template.DamageTypeTemplateName = 'Heavy';
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	// added as class levels up: Template.Abilities.AddItem('Suppression');
	// added as class levels up: Template.Abilities.AddItem('Execute');
	Template.GameArchetype = "WP_Muton_Rifle.WP_MutonRifle";
	Template.iPhysicsImpulse = 5;
	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;
	Template.bInfiniteItem = true;

	return Template;
}

// Vanilla weapon has broken image
static function X2DataTemplate CreateTemplate_PA_MutonBayonet()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'PA_MutonBayonet');

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'PA_MutonBayonetCat';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_PlayableAdvent.MutonBayonet";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	Template.GameArchetype = "WP_Muton_Bayonet.WP_MutonBayonet";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);
	Template.iRange = 0;
	Template.iRadius = 1;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;
	Template.iIdealRange = 1;
	Template.BaseDamage = class'X2Item_DefaultWeapons'.default.MUTON_MELEEATTACK_BASEDAMAGE;
	Template.BaseDamage.DamageType='Melee';
	Template.iSoundRange = 2;
	Template.iEnvironmentDamage = 10;
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.Abilities.AddItem('Bayonet');
	// Added in classdata initial level: Template.Abilities.AddItem('CounterattackBayonet');

	return Template;
}
