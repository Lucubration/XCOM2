//---------------------------------------------------------------------------------------
//  FILE:    X2Item_DLC_Day60Grenades.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Item_DLC_Day60Grenades extends X2Item config(GameData_WeaponData);

var config WeaponDamageValue FROSTBOMB_BASEDAMAGE;
var config int FROSTBOMB_ISOUNDRANGE;
var config int FROSTBOMB_IENVIRONMENTDAMAGE;
var config int FROSTBOMB_ICLIPSIZE;
var config int FROSTBOMB_RANGE;
var config int FROSTBOMB_RADIUS;
var config int FROSTBOMB_MIN_RULER_FREEZE_DURATION;
var config int FROSTBOMB_MAX_RULER_FREEZE_DURATION;

var config WeaponDamageValue FROSTBITE_BASEDAMAGE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Grenades;

	Grenades.AddItem(CreateFrostbomb());

	// Alien Rulers
	Grenades.AddItem(CreateFrostbiteGlob());

	return Grenades;
}

static function X2DataTemplate CreateFrostbomb()
{
	local X2GrenadeTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2Effect_DLC_Day60Freeze FreezeEffect;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'Frostbomb');

	Template.strImage = "img:///UILibrary_DLC2Images.Inv_Frost_Bomb";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.EquipNarrative = "DLC_60_NarrativeMoments.DLC2_S_Hunters_Grenade_Equipped";
	Template.AddAbilityIconOverride('ThrowGrenade', "img:///UILibrary_DLC2Images.UIPerk_frostbomb");
	Template.AddAbilityIconOverride('LaunchGrenade', "img:///UILibrary_DLC2Images.UIPerk_frostbomb");

	Template.iRange = default.FROSTBOMB_RANGE;
	Template.iRadius = default.FROSTBOMB_RADIUS;
	Template.fCoverage = 50;
	Template.bAllowVolatileMix = false;

	Template.BaseDamage = default.FROSTBOMB_BASEDAMAGE;
	Template.iSoundRange = default.FROSTBOMB_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.FROSTBOMB_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = 0;
	Template.PointsToComplete = 0;
	Template.iClipSize = default.FROSTBOMB_ICLIPSIZE;
	Template.Tier = 0;

	Template.Abilities.AddItem('ThrowGrenade');
	Template.Abilities.AddItem('GrenadeFuse');

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	FreezeEffect = class'X2Effect_DLC_Day60Freeze'.static.CreateFreezeEffect(default.FROSTBOMB_MIN_RULER_FREEZE_DURATION, default.FROSTBOMB_MAX_RULER_FREEZE_DURATION);
	FreezeEffect.bApplyRulerModifiers = true;
	Template.ThrownGrenadeEffects.AddItem(FreezeEffect);
	Template.ThrownGrenadeEffects.AddItem(class'X2Effect_DLC_Day60Freeze'.static.CreateFreezeRemoveEffects());
	Template.LaunchedGrenadeEffects = Template.ThrownGrenadeEffects;

	Template.GameArchetype = "DLC_60_WP_Frost_Bomb.WP_Frost_Bomb";

	Template.iPhysicsImpulse = 10;

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.FROSTBOMB_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.FROSTBOMB_RADIUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , default.FROSTBOMB_BASEDAMAGE.Shred);

	return Template;
}

// Alien Rulers
static function X2DataTemplate CreateFrostbiteGlob()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'FrostbiteGlob');

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'grenade';
	Template.strImage = "img:///UILibrary_StrategyImages.InventoryIcons.Inv_SmokeGrenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.GameArchetype = "DLC_60_WP_Viper_Frost_Spit.WP_Viper_Frost_Spit";
	Template.CanBeBuilt = false;	

	Template.iRange = 12;
	Template.iRadius = 4;
	Template.iClipSize = 1;
	Template.InfiniteAmmo = true;

	Template.iSoundRange = 6;
	Template.bSoundOriginatesFromOwnerLocation = true;

	Template.BaseDamage.DamageType = 'Frost';
	Template.BaseDamage = default.FROSTBITE_BASEDAMAGE;

	Template.InventorySlot = eInvSlot_Utility;
	Template.StowedLocation = eSlot_None;
	Template.Abilities.AddItem('Frostbite');

	// This controls how much arc this projectile may have and how many times it may bounce
	Template.WeaponPrecomputedPathData.InitialPathTime = 0.5;
	Template.WeaponPrecomputedPathData.MaxPathTime = 1.0;
	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;

	return Template;
}