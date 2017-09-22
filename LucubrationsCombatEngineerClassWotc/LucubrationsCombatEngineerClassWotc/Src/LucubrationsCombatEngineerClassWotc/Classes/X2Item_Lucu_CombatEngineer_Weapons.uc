class X2Item_Lucu_CombatEngineer_Weapons extends X2Item
    config(Lucu_CombatEngineer_Item);

var config int DetPackRange;
var config int DetPackRadius;
var config WeaponDamageValue DetPackDamage;
var config int DetPackEnvironmentalDamage;
var config string DetPackDestructibleArchetype;

var config int PlasmaPackRange;
var config int PlasmaPackRadius;
var config WeaponDamageValue PlasmaPackDamage;
var config int PlasmaPackEnvironmentalDamage;
var config string PlasmaPackDestructibleArchetype;

var config WeaponDamageValue SIMON_CV_BaseDamage;
var config int SIMON_CV_SoundRange;
var config int SIMON_CV_EnvironmentDamage;
var config int SIMON_CV_Supplies;
var config int SIMON_CV_TradingPostValue;
var config int SIMON_CV_Points;
var config int SIMON_CV_ClipSize;
var config float SIMON_CV_Range;
var config float SIMON_CV_Radius;
var config int SIMON_CV_Angle;

var name DetpackCVItemName;
var name DetpackBMItemName;
var name SIMONItemName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

	Weapons.AddItem(DetPack_CV());
	Weapons.AddItem(DetPack_BM());
	Weapons.AddItem(SIMON_CV());

	return Weapons;
}

static function X2DataTemplate DetPack_CV()
{
	local X2DetPackTemplate_Lucu_CombatEngineer Template;

	`CREATE_X2TEMPLATE(class'X2DetPackTemplate_Lucu_CombatEngineer', Template, default.DetpackCVItemName);
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.strImage = "img:///UILibrary_Lucu_CombatEngineer.X2InventoryIcons.Inv_X4";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lucu_combatengineer_detpack';
	Template.WeaponTech = 'conventional';
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
    
    // These parameters give us proper target visualizations when throwing detpacks
	Template.iRange = default.DetPackRange;
	Template.iRadius = default.DetPackRadius;
	Template.BaseDamage = default.DetPackDamage;
	Template.iEnvironmentDamage = default.DetPackEnvironmentalDamage; // For preview
    Template.Tier = 1;
	
	Template.GameArchetype = "UILibrary_Lucu_CombatEngineer.WP_Grenade_DetPack";
    Template.SpawnedDestructibleArchetype = default.DetPackDestructibleArchetype;

	Template.iPhysicsImpulse = 10;

    Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
    
	Template.HideIfResearched = class'X2StrategyElement_Lucu_CombatEngineer_Techs'.default.PlasmaPackTechTemplateName;

	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;
    
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.DetPackRange);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.DetPackRadius);
    Template.SetUIStatMarkup(class'XLocalizedData'.default.DamageLabel, , default.DetPackDamage.Damage);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , default.DetPackDamage.Shred);

	return Template;
}

static function X2DataTemplate DetPack_BM()
{
	local X2DetPackTemplate_Lucu_CombatEngineer Template;

	`CREATE_X2TEMPLATE(class'X2DetPackTemplate_Lucu_CombatEngineer', Template, default.DetpackBMItemName);
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.strImage = "img:///UILibrary_Lucu_CombatEngineer.X2InventoryIcons.Inv_X4";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lucu_combatengineer_detpack';
	Template.WeaponTech = 'beam';
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
    
    // These parameters give us proper target visualizations when throwing detpacks
	Template.iRange = default.PlasmaPackRange;
	Template.iRadius = default.PlasmaPackRadius;
	Template.BaseDamage = default.PlasmaPackDamage;
	Template.iEnvironmentDamage = default.PlasmaPackEnvironmentalDamage; // For preview
	Template.Tier = 2;
	
	Template.GameArchetype = "UILibrary_Lucu_CombatEngineer.WP_Grenade_PlasmaPack";
    Template.SpawnedDestructibleArchetype = default.PlasmaPackDestructibleArchetype;

	Template.iPhysicsImpulse = 10;
    
	Template.CreatorTemplateName = class'X2StrategyElement_Lucu_CombatEngineer_Techs'.default.PlasmaPackTechTemplateName; // The schematic which creates this item
	Template.BaseItem = default.DetpackCVItemName; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
    
	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;
    
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.PlasmaPackRange);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.PlasmaPackRadius);
    Template.SetUIStatMarkup(class'XLocalizedData'.default.DamageLabel, , default.PlasmaPackDamage.Damage);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , default.PlasmaPackDamage.Shred);

	return Template;
}

//---------------------------------------------------------------------------------------------------
// SIMON (Conventional)
//---------------------------------------------------------------------------------------------------

static function X2DataTemplate SIMON_CV()
{
	local X2SIMONTemplate_Lucu_CombatEngineer Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2Effect_Knockback KnockbackEffect;

	`CREATE_X2TEMPLATE(class'X2SIMONTemplate_Lucu_CombatEngineer', Template, default.SIMONItemName);

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Rocket_Launcher";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.AddAbilityIconOverride(class'X2Ability_Lucu_CombatEngineer_CombatEngineerAbilitySet'.default.LaunchSIMONAbilityTemplateName, "img:///UILibrary_PerkIcons.UIPerk_firerocket");

	Template.iRange = default.SIMON_CV_Range;
	Template.iRadius = default.SIMON_CV_Radius;
	Template.BaseDamage = default.SIMON_CV_BaseDamage;
	Template.iSoundRange = default.SIMON_CV_SoundRange;
	Template.iEnvironmentDamage = default.SIMON_CV_EnvironmentDamage;
	Template.TradingPostValue = default.SIMON_CV_TradingPostValue;
	Template.iClipSize = default.SIMON_CV_ClipSize;
	Template.Angle = default.SIMON_CV_Angle;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = -3;

	Template.Abilities.AddItem(class'X2Ability_Lucu_CombatEngineer_CombatEngineerAbilitySet'.default.LaunchSIMONAbilityTemplateName);
	Template.Abilities.AddItem(class'X2Ability_Lucu_CombatEngineer_CombatEngineerAbilitySet'.default.SIMONFuseAbilityTemplateName);
	
	Template.GameArchetype = "UILibrary_Lucu_CombatEngineer.WP_Grenade_SIMON_CV";

	Template.iPhysicsImpulse = 10;

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	Template.LaunchedGrenadeEffects.AddItem(WeaponDamageEffect);

    // Hide for higher-tier SIMON rounds?
	//Template.HideIfResearched = 'AdvancedGrenades';

	Template.OnThrowBarkSoundCue = 'ThrowGrenade';

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 4;
	Template.LaunchedGrenadeEffects.AddItem(KnockbackEffect);
	
	Template.WeaponPrecomputedPathData.InitialPathTime = 0.4f;
	Template.WeaponPrecomputedPathData.MaxPathTime = 0.8f;
	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;
    
	return Template;
}

DefaultProperties
{
	DetpackCVItemName="Lucu_CombatEngineer_DetPack_CV"
    DetpackBMItemName="Lucu_CombatEngineer_DetPack_BM"
    SIMONItemName="Lucu_CombatEngineer_SIMON"
}
