class X2Item_Beags_Escalation_HMG extends X2Item
	config(Beags_Escalation_Item);

var config WeaponDamageValue HMG_Conventional_BaseDamage;
var config int HMG_Conventional_Aim;
var config int HMG_Conventional_CritChance;
var config int HMG_Conventional_iClipSize;
var config int HMG_Conventional_iSoundRange;
var config int HMG_Conventional_iEnvironmentDamage;
var config int HMG_Conventional_NumUpgradeSlots;

var config WeaponDamageValue HMG_Magnetic_BaseDamage;
var config int HMG_Magnetic_Aim;
var config int HMG_Magnetic_CritChance;
var config int HMG_Magnetic_iClipSize;
var config int HMG_Magnetic_iSoundRange;
var config int HMG_Magnetic_iEnvironmentDamage;
var config int HMG_Magnetic_NumUpgradeSlots;

var config WeaponDamageValue HMG_Beam_BaseDamage;
var config int HMG_Beam_Aim;
var config int HMG_Beam_CritChance;
var config int HMG_Beam_iClipSize;
var config int HMG_Beam_iSoundRange;
var config int HMG_Beam_iEnvironmentDamage;
var config int HMG_Beam_NumUpgradeSlots;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Rockets;

	Rockets.AddItem(HMGConventional());
	Rockets.AddItem(HMGMagnetic());
	Rockets.AddItem(HMGBeam());

	return Rockets;
}


//---------------------------------------------------------------------------------------------------
// Heavy Machine Guns
//---------------------------------------------------------------------------------------------------


static function X2DataTemplate HMGConventional()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Beags_Escalation_HMG_CV');
	Template.WeaponPanelImage = "_ConventionalCannon";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'beags_escalation_hmg';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_Common.ConvCannon.ConvCannon_Base";
	Template.EquipSound = "Conventional_Weapon_Equip";
	Template.Tier = 0;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.HMG_Conventional_BaseDamage;
	Template.Aim = default.HMG_Conventional_Aim;
	Template.CritChance = default.HMG_Conventional_CritChance;
	Template.iClipSize = default.HMG_Conventional_iClipSize;
	Template.iSoundRange = default.HMG_Conventional_iSoundRange;
	Template.iEnvironmentDamage = default.HMG_Conventional_iEnvironmentDamage;
	Template.NumUpgradeSlots = default.HMG_Conventional_NumUpgradeSlots;
	Template.bIsLargeWeapon = true;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Beags_Escalation_HMGOverwatch');
	Template.Abilities.AddItem('LongWatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Beags_Escalation_HMGMovementObserver');
	Template.Abilities.AddItem('Beags_Escalation_HMGMoved');
	Template.Abilities.AddItem('Beags_Escalation_HMGSquadsight');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Cannon_CV.WP_Cannon_CV";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Cannon';
	Template.AddDefaultAttachment('Mag', 		"ConvCannon.Meshes.SM_ConvCannon_MagA", , "img:///UILibrary_Common.ConvCannon.ConvCannon_MagA");
	Template.AddDefaultAttachment('Reargrip',   "ConvCannon.Meshes.SM_ConvCannon_ReargripA"/*REARGRIP INCLUDED IN TRIGGER IMAGE*/);
	Template.AddDefaultAttachment('Stock', 		"ConvCannon.Meshes.SM_ConvCannon_StockA", , "img:///UILibrary_Common.ConvCannon.ConvCannon_StockA");
	Template.AddDefaultAttachment('StockSupport', "ConvCannon.Meshes.SM_ConvCannon_StockA_Support");
	Template.AddDefaultAttachment('Suppressor', "ConvCannon.Meshes.SM_ConvCannon_SuppressorA");
	Template.AddDefaultAttachment('Trigger', "ConvCannon.Meshes.SM_ConvCannon_TriggerA", , "img:///UILibrary_Common.ConvCannon.ConvCannon_TriggerA");
	Template.AddDefaultAttachment('Light', "ConvAttachments.Meshes.SM_ConvFlashLight");

	Template.iPhysicsImpulse = 5;

	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_Conventional';

	return Template;
}


static function X2DataTemplate HMGMagnetic()
{
	local X2WeaponTemplate Template;
	
	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Beags_Escalation_HMG_MG');
	Template.WeaponPanelImage = "_MagneticCannon";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'beags_escalation_hmg';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.UI_MagCannon.MagCannon_Base";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_MAGNETIC_RANGE;
	Template.BaseDamage = default.HMG_Magnetic_BaseDamage;
	Template.Aim = default.HMG_Magnetic_Aim;
	Template.CritChance = default.HMG_Magnetic_CritChance;
	Template.iClipSize = default.HMG_Magnetic_iClipSize;
	Template.iSoundRange = default.HMG_Magnetic_iSoundRange;
	Template.iEnvironmentDamage = default.HMG_Magnetic_iEnvironmentDamage;
	Template.NumUpgradeSlots = default.HMG_Magnetic_NumUpgradeSlots;
	Template.bIsLargeWeapon = true;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Beags_Escalation_HMGOverwatch');
	Template.Abilities.AddItem('LongWatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Beags_Escalation_HMGMovementObserver');
	Template.Abilities.AddItem('Beags_Escalation_HMGMoved');
	Template.Abilities.AddItem('Beags_Escalation_HMGSquadsight');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Cannon_MG.WP_Cannon_MG";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Cannon';
	Template.AddDefaultAttachment('Mag', "MagCannon.Meshes.SM_MagCannon_MagA", , "img:///UILibrary_Common.UI_MagCannon.MagCannon_MagA");
	Template.AddDefaultAttachment('Reargrip',   "MagCannon.Meshes.SM_MagCannon_ReargripA");
	Template.AddDefaultAttachment('Foregrip', "MagCannon.Meshes.SM_MagCannon_StockA", , "img:///UILibrary_Common.UI_MagCannon.MagCannon_StockA");
	Template.AddDefaultAttachment('Trigger', "MagCannon.Meshes.SM_MagCannon_TriggerA", , "img:///UILibrary_Common.UI_MagCannon.MagCannon_TriggerA");
	Template.AddDefaultAttachment('Light', "ConvAttachments.Meshes.SM_ConvFlashLight");

	Template.iPhysicsImpulse = 5;

	Template.CreatorTemplateName = 'Cannon_MG_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'Beags_Escalation_HMG_CV'; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}


static function X2DataTemplate HMGBeam()
{
	local X2WeaponTemplate Template;
	
	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Beags_Escalation_HMG_BM');
	Template.WeaponPanelImage = "_BeamCannon";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'beags_escalation_hmg';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_Base";
	Template.EquipSound = "Beam_Weapon_Equip";
	Template.Tier = 5;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_BEAM_RANGE;
	Template.BaseDamage = default.HMG_Beam_BaseDamage;
	Template.Aim = default.HMG_Beam_Aim;
	Template.CritChance = default.HMG_Beam_CritChance;
	Template.iClipSize = default.HMG_Beam_iClipSize;
	Template.iSoundRange = default.HMG_Beam_iSoundRange;
	Template.iEnvironmentDamage = default.HMG_Beam_iEnvironmentDamage;
	Template.NumUpgradeSlots = default.HMG_Beam_NumUpgradeSlots;
	Template.bIsLargeWeapon = true;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Beags_Escalation_HMGOverwatch');
	Template.Abilities.AddItem('LongWatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Beags_Escalation_HMGMovementObserver');
	Template.Abilities.AddItem('Beags_Escalation_HMGMoved');
	Template.Abilities.AddItem('Beags_Escalation_HMGSquadsight');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Cannon_BM.WP_Cannon_BM";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Cannon';
	Template.AddDefaultAttachment('Mag', "BeamCannon.Meshes.SM_BeamCannon_MagA", , "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_MagA");
	Template.AddDefaultAttachment('Core', "BeamCannon.Meshes.SM_BeamCannon_CoreA", , "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_CoreA");
	Template.AddDefaultAttachment('Core_Center',"BeamCannon.Meshes.SM_BeamCannon_CoreA_Center");
	Template.AddDefaultAttachment('HeatSink', "BeamCannon.Meshes.SM_BeamCannon_HeatSinkA", , "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_HeatsinkA");
	Template.AddDefaultAttachment('Suppressor', "BeamCannon.Meshes.SM_BeamCannon_SuppressorA", , "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_SupressorA");
	Template.AddDefaultAttachment('Light', "BeamAttachments.Meshes.BeamFlashLight");

	Template.iPhysicsImpulse = 5;

	Template.CreatorTemplateName = 'Cannon_BM_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'Beags_Escalation_HMG_MG'; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_BeamXCom';

	return Template;
}
