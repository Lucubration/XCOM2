//---------------------------------------------------------------------------------------
//  FILE:    X2Item_DLC_Day60Weapons.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Item_DLC_Day60Weapons extends X2Item config(GameData_WeaponData);

var config int GENERIC_MELEE_ACCURACY;

var config WeaponDamageValue HUNTERRIFLE_CONVENTIONAL_BASEDAMAGE;
var config WeaponDamageValue HUNTERRIFLE_MAGNETIC_BASEDAMAGE;
var config WeaponDamageValue HUNTERRIFLE_BEAM_BASEDAMAGE;

var config WeaponDamageValue HUNTERPISTOL_CONVENTIONAL_BASEDAMAGE;
var config WeaponDamageValue HUNTERPISTOL_MAGNETIC_BASEDAMAGE;
var config WeaponDamageValue HUNTERPISTOL_BEAM_BASEDAMAGE;

var config WeaponDamageValue HUNTERAXE_CONVENTIONAL_BASEDAMAGE;
var config WeaponDamageValue HUNTERAXE_MAGNETIC_BASEDAMAGE;
var config WeaponDamageValue HUNTERAXE_BEAM_BASEDAMAGE;

var config WeaponDamageValue VIPERNEONATE_WPN_BASEDAMAGE;

var config WeaponDamageValue VIPERKING_WPN_BASEDAMAGE;
var config WeaponDamageValue VIPERKING_BIND_BASEDAMAGE;
var config WeaponDamageValue VIPERKING_BIND_SUSTAINDAMAGE;

var config WeaponDamageValue ARCHONKING_WPN_BASEDAMAGE;
var config WeaponDamageValue ARCHONKING_BLAZINGPINIONS_BASEDAMAGE;
var config WeaponDamageValue ARCHONKING_ICARUS_DROP_BASEDAMAGE;

var config WeaponDamageValue VIPERNEONATE_BIND_BASEDAMAGE;
var config WeaponDamageValue VIPERNEONATE_BIND_SUSTAINDAMAGE;

var config WeaponDamageValue RAGESUIT_RAGESTRIKE_BASEDAMAGE;

// ***** Core properties and variables for weapons *****
var config int HUNTERRIFLE_CONVENTIONAL_AIM;
var config int HUNTERRIFLE_CONVENTIONAL_CRITCHANCE;
var config int HUNTERRIFLE_CONVENTIONAL_ICLIPSIZE;
var config int HUNTERRIFLE_CONVENTIONAL_ISOUNDRANGE;
var config int HUNTERRIFLE_CONVENTIONAL_IENVIRONMENTDAMAGE;
var config int HUNTERRIFLE_CONVENTIONAL_IPOINTS;

var config int HUNTERRIFLE_MAGNETIC_AIM;
var config int HUNTERRIFLE_MAGNETIC_CRITCHANCE;
var config int HUNTERRIFLE_MAGNETIC_ICLIPSIZE;
var config int HUNTERRIFLE_MAGNETIC_ISOUNDRANGE;
var config int HUNTERRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
var config int HUNTERRIFLE_MAGNETIC_IPOINTS;

var config int HUNTERRIFLE_BEAM_AIM;
var config int HUNTERRIFLE_BEAM_CRITCHANCE;
var config int HUNTERRIFLE_BEAM_ICLIPSIZE;
var config int HUNTERRIFLE_BEAM_ISOUNDRANGE;
var config int HUNTERRIFLE_BEAM_IENVIRONMENTDAMAGE;
var config int HUNTERRIFLE_BEAM_IPOINTS;

var config int HUNTERRIFLE_STUN_CHANCE, HUNTERRIFLE_RULER_STUN_CHANCE;

var config int HUNTERPISTOL_CONVENTIONAL_AIM;
var config int HUNTERPISTOL_CONVENTIONAL_CRITCHANCE;
var config int HUNTERPISTOL_CONVENTIONAL_ICLIPSIZE;
var config int HUNTERPISTOL_CONVENTIONAL_ISOUNDRANGE;
var config int HUNTERPISTOL_CONVENTIONAL_IENVIRONMENTDAMAGE;
var config int HUNTERPISTOL_CONVENTIONAL_IPOINTS;

var config int HUNTERPISTOL_MAGNETIC_AIM;
var config int HUNTERPISTOL_MAGNETIC_CRITCHANCE;
var config int HUNTERPISTOL_MAGNETIC_ICLIPSIZE;
var config int HUNTERPISTOL_MAGNETIC_ISOUNDRANGE;
var config int HUNTERPISTOL_MAGNETIC_IENVIRONMENTDAMAGE;
var config int HUNTERPISTOL_MAGNETIC_IPOINTS;

var config int HUNTERPISTOL_BEAM_AIM;
var config int HUNTERPISTOL_BEAM_CRITCHANCE;
var config int HUNTERPISTOL_BEAM_ICLIPSIZE;
var config int HUNTERPISTOL_BEAM_ISOUNDRANGE;
var config int HUNTERPISTOL_BEAM_IENVIRONMENTDAMAGE;
var config int HUNTERPISTOL_BEAM_IPOINTS;

var config int HUNTERAXE_CONVENTIONAL_AIM;
var config int HUNTERAXE_CONVENTIONAL_CRITCHANCE;
var config int HUNTERAXE_CONVENTIONAL_ICLIPSIZE;
var config int HUNTERAXE_CONVENTIONAL_ISOUNDRANGE;
var config int HUNTERAXE_CONVENTIONAL_IENVIRONMENTDAMAGE;
var config int HUNTERAXE_CONVENTIONAL_IPOINTS;

var config int HUNTERAXE_MAGNETIC_AIM;
var config int HUNTERAXE_MAGNETIC_CRITCHANCE;
var config int HUNTERAXE_MAGNETIC_ICLIPSIZE;
var config int HUNTERAXE_MAGNETIC_ISOUNDRANGE;
var config int HUNTERAXE_MAGNETIC_IENVIRONMENTDAMAGE;
var config int HUNTERAXE_MAGNETIC_IPOINTS;
var config int HUNTERAXE_MAGNETIC_STUNCHANCE;

var config int HUNTERAXE_BEAM_AIM;
var config int HUNTERAXE_BEAM_CRITCHANCE;
var config int HUNTERAXE_BEAM_ICLIPSIZE;
var config int HUNTERAXE_BEAM_ISOUNDRANGE;
var config int HUNTERAXE_BEAM_IENVIRONMENTDAMAGE;
var config int HUNTERAXE_BEAM_IPOINTS;

var config int VIPERKING_IDEALRANGE;

var config int ARCHONKING_IDEALRANGE;
var config int ARCHONKING_BLAZINGPINIONS_ENVDAMAGE;

// ***** Range Modifier Tables *****
var config array<int> SHORT_CONVENTIONAL_RANGE;
var config array<int> SHORT_MAGNETIC_RANGE;
var config array<int> SHORT_BEAM_RANGE;
var config array<int> MEDIUM_CONVENTIONAL_RANGE;
var config array<int> MEDIUM_MAGNETIC_RANGE;
var config array<int> MEDIUM_BEAM_RANGE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

	Weapons.AddItem(CreateTemplate_AlienHunterRifle_Conventional());
	Weapons.AddItem(CreateTemplate_AlienHunterRifle_Magnetic());
	Weapons.AddItem(CreateTemplate_AlienHunterRifle_Beam());

	Weapons.AddItem(CreateTemplate_AlienHunterPistol_Conventional());
	Weapons.AddItem(CreateTemplate_AlienHunterPistol_Magnetic());
	Weapons.AddItem(CreateTemplate_AlienHunterPistol_Beam());

	Weapons.AddItem(CreateTemplate_AlienHunterAxe_Conventional());
	Weapons.AddItem(CreateTemplate_AlienHunterAxe_Magnetic());
	Weapons.AddItem(CreateTemplate_AlienHunterAxe_Beam());
	Weapons.AddItem(CreateTemplate_AlienHunterAxeThrown_Conventional());
	Weapons.AddItem(CreateTemplate_AlienHunterAxeThrown_Magnetic());
	Weapons.AddItem(CreateTemplate_AlienHunterAxeThrown_Beam());

	// Alien Rulers
	Weapons.AddItem(CreateTemplate_ViperNeonate_WPN());
	Weapons.AddItem(CreateTemplate_ViperKing_WPN());
	Weapons.AddItem(CreateTemplate_ViperKing_Tongue_WPN());
	Weapons.AddItem(CreateTemplate_ArchonKing_WPN());
	Weapons.AddItem(CreateTemplate_ArchonKing_Blazing_Pinions_WPN());
	Weapons.AddItem(CreateTemplate_ArchonKing_MeleeAttack());

	return Weapons;
}

// **************************************************************************
// ***                          AssaultRifle                              ***
// **************************************************************************
static function X2DataTemplate CreateTemplate_AlienHunterRifle_Conventional()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AlienHunterRifle_CV');
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.EquipSound = "Conventional_Weapon_Equip";
	Template.EquipNarrative = "DLC_60_NarrativeMoments.DLC2_S_Hunters_Boltgun_Equipped";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_DLC2Images.ConvBoltCaster_base";
	Template.Tier = 0;

	Template.bCanBeDodged = false;
	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.HUNTERRIFLE_CONVENTIONAL_BASEDAMAGE;
	Template.Aim = default.HUNTERRIFLE_CONVENTIONAL_AIM;
	Template.CritChance = default.HUNTERRIFLE_CONVENTIONAL_CRITCHANCE;
	Template.iClipSize = default.HUNTERRIFLE_CONVENTIONAL_ICLIPSIZE;
	Template.iSoundRange = default.HUNTERRIFLE_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.HUNTERRIFLE_CONVENTIONAL_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 0;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "DLC_60_WP_BoltCaster_CV.WP_BoltCaster_CV";
	
	Template.BonusWeaponEffects.AddItem(BoltCasterStunEffect());

	Template.iPhysicsImpulse = 5;

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;
	
	Template.fKnockbackDamageAmount = 5.0f;
	Template.fKnockbackDamageRadius = 0.0f;

	Template.DamageTypeTemplateName = 'Projectile_Conventional';

	Template.SetUIStatMarkup(class'XLocalizedData'.default.StunChanceLabel, , default.HUNTERRIFLE_STUN_CHANCE, , , "%");

	return Template;
}

static function X2DataTemplate CreateTemplate_AlienHunterRifle_Magnetic()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AlienHunterRifle_MG');
	Template.WeaponPanelImage = "_MagneticRifle";                       // used by the UI. Probably determines iconview of the weapon.

	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_DLC2Images.MagBoltCaster_base";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.EquipNarrative = "DLC_60_NarrativeMoments.DLC2_S_Hunters_Boltgun_Equipped";
	Template.Tier = 3;

	Template.bCanBeDodged = false;
	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_MAGNETIC_RANGE;
	Template.BaseDamage = default.HUNTERRIFLE_MAGNETIC_BASEDAMAGE;
	Template.Aim = default.HUNTERRIFLE_MAGNETIC_AIM;
	Template.CritChance = default.HUNTERRIFLE_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.HUNTERRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.HUNTERRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.HUNTERRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 0;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	Template.GameArchetype = "DLC_60_WP_BoltCaster_MG.WP_BoltCaster_MG";

	Template.BonusWeaponEffects.AddItem(BoltCasterStunEffect());

	Template.iPhysicsImpulse = 5;

	Template.CreatorTemplateName = 'HunterRifle_MG_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'AlienHunterRifle_CV'; // Which item this will be upgraded from

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	Template.SetUIStatMarkup(class'XLocalizedData'.default.StunChanceLabel, , default.HUNTERRIFLE_STUN_CHANCE, , , "%");

	return Template;
}

static function X2DataTemplate CreateTemplate_AlienHunterRifle_Beam()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AlienHunterRifle_BM');
	Template.WeaponPanelImage = "_BeamRifle";                       // used by the UI. Probably determines iconview of the weapon.

	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'beam';
	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_DLC2Images.BeamBoltCaster_base";
	Template.EquipSound = "Beam_Weapon_Equip";
	Template.EquipNarrative = "DLC_60_NarrativeMoments.DLC2_S_Hunters_Boltgun_Equipped";
	Template.Tier = 5;

	Template.bCanBeDodged = false;
	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_BEAM_RANGE;
	Template.BaseDamage = default.HUNTERRIFLE_BEAM_BASEDAMAGE;
	Template.Aim = default.HUNTERRIFLE_BEAM_AIM;
	Template.CritChance = default.HUNTERRIFLE_BEAM_CRITCHANCE;
	Template.iClipSize = default.HUNTERRIFLE_BEAM_ICLIPSIZE;
	Template.iSoundRange = default.HUNTERRIFLE_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.HUNTERRIFLE_BEAM_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 0;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	Template.GameArchetype = "DLC_60_WP_BoltCaster_BM.WP_BoltCaster_BM";
	
	Template.BonusWeaponEffects.AddItem(BoltCasterStunEffect());

	Template.iPhysicsImpulse = 5;

	Template.CreatorTemplateName = 'HunterRifle_BM_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'AlienHunterRifle_MG'; // Which item this will be upgraded from

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_BeamXCom';

	Template.SetUIStatMarkup(class'XLocalizedData'.default.StunChanceLabel, , default.HUNTERRIFLE_STUN_CHANCE, , , "%");

	return Template;
}

static function X2Effect_Stunned BoltCasterStunEffect()
{
	local X2Effect_Stunned StunEffect;

	StunEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, 0, false);
	StunEffect.ApplyChanceFn = BoltCasterStunChance;
	return StunEffect;
}

function name BoltCasterStunChance(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	local XComGameState_Unit TargetUnit;
	local int Chance;

	TargetUnit = XComGameState_Unit(kNewTargetState);
	if (TargetUnit != none)
	{
		if (class'X2Helpers_DLC_Day60'.static.IsUnitAlienRuler(TargetUnit))
		{
			// Get the Stun Chance modifier for individual Ruler and subtract it
			Chance = default.HUNTERRIFLE_RULER_STUN_CHANCE - class'X2Helpers_DLC_Day60'.static.GetRulerStunChanceModifier(TargetUnit);
		}
		else
		{
			Chance = default.HUNTERRIFLE_STUN_CHANCE;
		}
		if (`SYNC_RAND(100) < Chance)
		{
			return 'AA_Success';
		}
	}
	return 'AA_EffectChanceFailed';
}

// **************************************************************************
// ***                          Pistol                                    ***
// **************************************************************************
static function X2DataTemplate CreateTemplate_AlienHunterPistol_Conventional()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AlienHunterPistol_CV');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_DLC2Images.ConvShadowKeeper";
	Template.EquipSound = "Secondary_Weapon_Equip_Conventional";
	Template.EquipNarrative = "DLC_60_NarrativeMoments.DLC2_S_Hunters_Pistol_Equipped";
	Template.Tier = 0;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.HUNTERPISTOL_CONVENTIONAL_BASEDAMAGE;
	Template.Aim = default.HUNTERPISTOL_CONVENTIONAL_AIM;
	Template.CritChance = default.HUNTERPISTOL_CONVENTIONAL_CRITCHANCE;
	Template.iClipSize = default.HUNTERPISTOL_CONVENTIONAL_ICLIPSIZE;
	Template.iSoundRange = default.HUNTERPISTOL_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.HUNTERPISTOL_CONVENTIONAL_IENVIRONMENTDAMAGE;

	Template.InfiniteAmmo = true;
	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('Shadowfall');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotConvA');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "DLC_60_WP_HunterPistol_CV.WP_HunterPistol_CV";

	Template.iPhysicsImpulse = 5;

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_Conventional';

	Template.bHideClipSizeStat = true;

	return Template;
}

static function X2DataTemplate CreateTemplate_AlienHunterPistol_Magnetic()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AlienHunterPistol_MG');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_DLC2Images.MagShadowKeeper";
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
	Template.EquipNarrative = "DLC_60_NarrativeMoments.DLC2_S_Hunters_Pistol_Equipped";
	Template.Tier = 3;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_MAGNETIC_RANGE;
	Template.BaseDamage = default.HUNTERPISTOL_MAGNETIC_BASEDAMAGE;
	Template.Aim = default.HUNTERPISTOL_MAGNETIC_AIM;
	Template.CritChance = default.HUNTERPISTOL_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.HUNTERPISTOL_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.HUNTERPISTOL_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.HUNTERPISTOL_MAGNETIC_IENVIRONMENTDAMAGE;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('Shadowfall');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotMagA');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "DLC_60_WP_HunterPistol_MG.WP_HunterPistol_MG";

	Template.iPhysicsImpulse = 5;

	Template.CreatorTemplateName = 'HunterPistol_MG_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'AlienHunterPistol_CV'; // Which item this will be upgraded from

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	Template.bHideClipSizeStat = true;

	return Template;
}

static function X2DataTemplate CreateTemplate_AlienHunterPistol_Beam()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AlienHunterPistol_BM');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_DLC2Images.BeamShadowKeeper";
	Template.EquipSound = "Secondary_Weapon_Equip_Beam";
	Template.EquipNarrative = "DLC_60_NarrativeMoments.DLC2_S_Hunters_Pistol_Equipped";
	Template.Tier = 5;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_BEAM_RANGE;
	Template.BaseDamage = default.HUNTERPISTOL_BEAM_BASEDAMAGE;
	Template.Aim = default.HUNTERPISTOL_BEAM_AIM;
	Template.CritChance = default.HUNTERPISTOL_BEAM_CRITCHANCE;
	Template.iClipSize = default.HUNTERPISTOL_BEAM_ICLIPSIZE;
	Template.iSoundRange = default.HUNTERPISTOL_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.HUNTERPISTOL_BEAM_IENVIRONMENTDAMAGE;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('Shadowfall');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotBeamA');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "DLC_60_WP_HunterPistol_BM.WP_HunterPistol_BM";

	Template.iPhysicsImpulse = 5;

	Template.CreatorTemplateName = 'HunterPistol_BM_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'AlienHunterPistol_MG'; // Which item this will be upgraded from

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_BeamXCom';

	Template.bHideClipSizeStat = true;

	return Template;
}

// **************************************************************************
// ***                       Melee Weapons                                ***
// **************************************************************************

static function X2DataTemplate CreateTemplate_AlienHunterAxe_Conventional()
{
	local X2PairedWeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2PairedWeaponTemplate', Template, 'AlienHunterAxe_CV');
	Template.PairedSlot = eInvSlot_TertiaryWeapon;
	Template.PairedTemplateName = 'AlienHunterAxeThrown_CV';

	Template.WeaponPanelImage = "_Sword";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sword';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_DLC2Images.ConvHuntmansAxe";
	Template.EquipSound = "Sword_Equip_Conventional";
	Template.EquipNarrative = "DLC_60_NarrativeMoments.DLC2_S_Hunters_Axe_Equipped";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "DLC_60_WP_HunterAxe_CV.WP_HunterAxe_CV";
	Template.Tier = 0;

	Template.iRadius = 1;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.HUNTERAXE_CONVENTIONAL_BASEDAMAGE;
	Template.Aim = default.HUNTERAXE_CONVENTIONAL_AIM;
	Template.CritChance = default.HUNTERAXE_CONVENTIONAL_CRITCHANCE;
	Template.iSoundRange = default.HUNTERAXE_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.HUNTERAXE_CONVENTIONAL_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Melee';

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Melee';

	return Template;
}

static function X2DataTemplate CreateTemplate_AlienHunterAxe_Magnetic()
{
	local X2PairedWeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2PairedWeaponTemplate', Template, 'AlienHunterAxe_MG');
	Template.PairedSlot = eInvSlot_TertiaryWeapon;
	Template.PairedTemplateName = 'AlienHunterAxeThrown_MG';

	Template.WeaponPanelImage = "_Sword";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sword';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_DLC2Images.MagHuntmansAxe";
	Template.EquipSound = "Sword_Equip_Magnetic";
	Template.EquipNarrative = "DLC_60_NarrativeMoments.DLC2_S_Hunters_Axe_Equipped";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "DLC60_WP_HunterAxe_MG.WP_HunterAxe_MG";
	Template.Tier = 3;

	Template.iRadius = 1;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.HUNTERAXE_MAGNETIC_BASEDAMAGE;
	Template.Aim = default.HUNTERAXE_MAGNETIC_AIM;
	Template.CritChance = default.HUNTERAXE_MAGNETIC_CRITCHANCE;
	Template.iSoundRange = default.HUNTERAXE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.HUNTERAXE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Melee';

	Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, default.HUNTERAXE_MAGNETIC_STUNCHANCE, false));

	Template.CreatorTemplateName = 'HunterAxe_MG_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'AlienHunterAxe_CV'; // Which item this will be upgraded from

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Melee';

	Template.SetUIStatMarkup(class'XLocalizedData'.default.StunChanceLabel, , default.HUNTERAXE_MAGNETIC_STUNCHANCE, , , "%");

	return Template;
}

static function X2DataTemplate CreateTemplate_AlienHunterAxe_Beam()
{
	local X2PairedWeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2PairedWeaponTemplate', Template, 'AlienHunterAxe_BM');
	Template.PairedSlot = eInvSlot_TertiaryWeapon;
	Template.PairedTemplateName = 'AlienHunterAxeThrown_BM';

	Template.WeaponPanelImage = "_Sword";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sword';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_DLC2Images.BeamHuntmansAxe";
	Template.EquipSound = "Sword_Equip_Beam";
	Template.EquipNarrative = "DLC_60_NarrativeMoments.DLC2_S_Hunters_Axe_Equipped";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "DLC60_WP_HunterAxe_BM.WP_HunterAxe_BM";
	Template.Tier = 5;

	Template.iRadius = 1;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.HUNTERAXE_BEAM_BASEDAMAGE;
	Template.Aim = default.HUNTERAXE_BEAM_AIM;
	Template.CritChance = default.HUNTERAXE_BEAM_CRITCHANCE;
	Template.iSoundRange = default.HUNTERAXE_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.HUNTERAXE_BEAM_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Melee';

	Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateBurningStatusEffect(2, 0));

	Template.CreatorTemplateName = 'HunterAxe_BM_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'AlienHunterAxe_MG'; // Which item this will be upgraded from

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Melee';

	return Template;
}

static function X2DataTemplate CreateTemplate_AlienHunterAxeThrown_Conventional()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AlienHunterAxeThrown_CV');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sword';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_DLC2Images.ConvHuntmansAxe";
	Template.EquipSound = "Sword_Equip_Conventional";
	Template.EquipNarrative = "DLC_60_NarrativeMoments.DLC2_S_Hunters_Axe_Equipped";
	Template.InventorySlot = eInvSlot_TertiaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "DLC_60_WP_HunterAxe_CV.WP_HunterAxe_Thrown_CV";
	Template.Tier = 0;

	Template.iRadius = 1;
	Template.InfiniteAmmo = false;
	Template.iClipSize = 1;
	Template.iPhysicsImpulse = 5;
	Template.bHideWithNoAmmo = true;

	Template.iRange = 0;
	Template.BaseDamage = default.HUNTERAXE_CONVENTIONAL_BASEDAMAGE;
	Template.Aim = default.HUNTERAXE_CONVENTIONAL_AIM;
	Template.CritChance = default.HUNTERAXE_CONVENTIONAL_CRITCHANCE;
	Template.iSoundRange = default.HUNTERAXE_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.HUNTERAXE_CONVENTIONAL_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Melee';

	Template.WeaponPrecomputedPathData.InitialPathTime = 0.5;
	Template.WeaponPrecomputedPathData.MaxPathTime = 1.0;
	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Melee';
	Template.Abilities.AddItem('ThrowAxe');

	return Template;
}

static function X2DataTemplate CreateTemplate_AlienHunterAxeThrown_Magnetic()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AlienHunterAxeThrown_MG');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sword';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_DLC2Images.MagHuntmansAxe";
	Template.EquipSound = "Sword_Equip_Magnetic";
	Template.EquipNarrative = "DLC_60_NarrativeMoments.DLC2_S_Hunters_Axe_Equipped";
	Template.InventorySlot = eInvSlot_TertiaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "DLC60_WP_HunterAxe_MG.WP_HunterAxe_Thrown_MG";
	Template.Tier = 3;

	Template.iRadius = 1;
	Template.InfiniteAmmo = false;
	Template.iClipSize = 1;
	Template.iPhysicsImpulse = 5;
	Template.bHideWithNoAmmo = true;

	Template.iRange = 0;
	Template.BaseDamage = default.HUNTERAXE_MAGNETIC_BASEDAMAGE;
	Template.Aim = default.HUNTERAXE_MAGNETIC_AIM;
	Template.CritChance = default.HUNTERAXE_MAGNETIC_CRITCHANCE;
	Template.iSoundRange = default.HUNTERAXE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.HUNTERAXE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Melee';

	Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, default.HUNTERAXE_MAGNETIC_STUNCHANCE, false));
	
	Template.WeaponPrecomputedPathData.InitialPathTime = 0.5;
	Template.WeaponPrecomputedPathData.MaxPathTime = 1.0;
	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Melee';
	Template.Abilities.AddItem('ThrowAxe');

	return Template;
}

static function X2DataTemplate CreateTemplate_AlienHunterAxeThrown_Beam()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AlienHunterAxeThrown_BM');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sword';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_DLC2Images.BeamHuntmansAxe";
	Template.EquipSound = "Sword_Equip_Beam";
	Template.EquipNarrative = "DLC_60_NarrativeMoments.DLC2_S_Hunters_Axe_Equipped";
	Template.InventorySlot = eInvSlot_TertiaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "DLC60_WP_HunterAxe_BM.WP_HunterAxe_Thrown_BM";
	Template.Tier = 5;

	Template.iRadius = 1;
	Template.InfiniteAmmo = false;
	Template.iClipSize = 1;
	Template.iPhysicsImpulse = 5;
	Template.bHideWithNoAmmo = true;

	Template.iRange = 0;
	Template.BaseDamage = default.HUNTERAXE_BEAM_BASEDAMAGE;
	Template.Aim = default.HUNTERAXE_BEAM_AIM;
	Template.CritChance = default.HUNTERAXE_BEAM_CRITCHANCE;
	Template.iSoundRange = default.HUNTERAXE_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.HUNTERAXE_BEAM_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Melee';

	Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateBurningStatusEffect(2, 0));
	
	Template.WeaponPrecomputedPathData.InitialPathTime = 0.5;
	Template.WeaponPrecomputedPathData.MaxPathTime = 1.0;
	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Melee';
	Template.Abilities.AddItem('ThrowAxe');

	return Template;
}

// Alien Rulers
static function X2DataTemplate CreateTemplate_ViperNeonate_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ViperNeonate_WPN');

	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_DLC2Images.ConvBoltCaster_base";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.VIPERNEONATE_WPN_BASEDAMAGE;
	Template.iClipSize = default.HUNTERRIFLE_CONVENTIONAL_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = class'X2Item_DefaultWeapons'.default.ADVTROOPERM1_IDEALRANGE;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "DLC_60_ProxyWeapons.WP_ViperNeonateGun";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	Template.DamageTypeTemplateName = 'Projectile_Conventional';

	return Template;
}

static function X2DataTemplate CreateTemplate_ViperKing_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ViperKing_WPN');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_DLC2Images.ConvBoltCaster_base";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy =  class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.VIPERKING_WPN_BASEDAMAGE;
	Template.iClipSize = default.HUNTERRIFLE_CONVENTIONAL_ICLIPSIZE;
	Template.iSoundRange =  class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage =  class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.VIPERKING_IDEALRANGE;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot_NoEnd');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "DLC_60_ProxyWeapons.WP_ViperKing_BoltCaster";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}

static function X2DataTemplate CreateTemplate_ViperKing_Tongue_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ViperKing_Tongue_WPN');

	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.ViperRifle";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.Aim = 20;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = class'X2Item_DefaultWeapons'.default.VIPER_WPN_BASEDAMAGE;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = class'X2Item_DefaultWeapons'.default.VIPER_IDEALRANGE;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('KingGetOverHere');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Viper_Strangle_and_Pull.WP_Viper_Strangle_and_Pull";
	
	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}

static function X2DataTemplate CreateTemplate_ArchonKing_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ArchonKing_WPN');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.ArchonStaff";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy =  class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.ARCHONKING_WPN_BASEDAMAGE;
	Template.iClipSize =  class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange =  class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage =  class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.ARCHONKING_IDEALRANGE;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot_NoEnd');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_ArchonKing_Staff.WP_ArchonKing_Staff";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}

static function X2DataTemplate CreateTemplate_ArchonKing_Blazing_Pinions_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ArchonKing_Blazing_Pinions_WPN');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.ArchonStaff";

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.ARCHONKING_BLAZINGPINIONS_BASEDAMAGE;
	Template.iClipSize = 0;
	Template.iSoundRange = 0;
	Template.iEnvironmentDamage = default.ARCHONKING_BLAZINGPINIONS_ENVDAMAGE;
	Template.iIdealRange = 0;
	Template.iPhysicsImpulse = 5;
	Template.DamageTypeTemplateName = 'BlazingPinions';

	Template.InventorySlot = eInvSlot_Utility;
	Template.Abilities.AddItem('ArchonKingBlazingPinionsStage2');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "DLC_60_WP_Archon_Devastate.WP_Devastate_CV";

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 0;

	return Template;
}

static function X2DataTemplate CreateTemplate_ArchonKing_MeleeAttack()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ArchonKingStaff');

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'baton';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.ArchonStaff";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Archon_Staff.WP_ArchonStaff";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.Aim = class'X2Item_DefaultWeapons'.default.GENERIC_MELEE_ACCURACY; // DLC60 also has a GENERIC_MELEE_ACCURACY, but it is not being used, and not set in the config file.

	Template.iRange = 0;
	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;
	Template.iIdealRange = 1;

	Template.BaseDamage = class'X2Item_DefaultWeapons'.default.ARCHON_MELEEATTACK_BASEDAMAGE;
	Template.BaseDamage.DamageType = 'Melee';
	Template.iSoundRange = 2;
	Template.iEnvironmentDamage = 10;

	//Build Data
	Template.StartingItem = false;
	Template.CanBeBuilt = false;

	Template.Abilities.AddItem('StandardMelee_NoEnd');
	Template.AddAbilityIconOverride('StandardMelee', "img:///UILibrary_PerkIcons.UIPerk_archon_beatdown");

	return Template;
}

defaultproperties
{
	bShouldCreateDifficultyVariants = true
}