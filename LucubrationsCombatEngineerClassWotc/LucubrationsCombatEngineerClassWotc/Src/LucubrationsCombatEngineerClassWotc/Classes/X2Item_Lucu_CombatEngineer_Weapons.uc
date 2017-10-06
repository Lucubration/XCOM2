class X2Item_Lucu_CombatEngineer_Weapons extends X2Item
    config(Lucu_CombatEngineer_Item);

var config WeaponDamageValue FellingAxe_CV_BaseDamage;
var config int FellingAxe_CV_Aim;
var config int FellingAxe_CV_CritChance;
var config int FellingAxe_CV_iClipSize;
var config int FellingAxe_CV_iSoundRange;
var config int FellingAxe_CV_iEnvironmentDamage;

var config WeaponDamageValue FellingAxe_MG_BaseDamage;
var config int FellingAxe_MG_Aim;
var config int FellingAxe_MG_CritChance;
var config int FellingAxe_MG_iClipSize;
var config int FellingAxe_MG_iSoundRange;
var config int FellingAxe_MG_iEnvironmentDamage;

var config WeaponDamageValue FellingAxe_BM_BaseDamage;
var config int FellingAxe_BM_Aim;
var config int FellingAxe_BM_CritChance;
var config int FellingAxe_BM_iClipSize;
var config int FellingAxe_BM_iSoundRange;
var config int FellingAxe_BM_iEnvironmentDamage;

var config float DetPackRange;
var config int DetPackRadius;
var config WeaponDamageValue DetPackDamage;
var config int DetPackEnvironmentalDamage;
var config string DetPackDestructibleArchetype;

var config float PlasmaPackRange;
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
var config float SIMON_CV_Angle;

var config WeaponDamageValue SIMON_MG_BaseDamage;
var config int SIMON_MG_SoundRange;
var config int SIMON_MG_EnvironmentDamage;
var config int SIMON_MG_Supplies;
var config int SIMON_MG_TradingPostValue;
var config int SIMON_MG_Points;
var config int SIMON_MG_ClipSize;
var config float SIMON_MG_Range;
var config float SIMON_MG_Radius;
var config float SIMON_MG_Angle;
var config int SIMON_MG_StunLevel;
var config int SIMON_MG_StunChance;

var config int DeployableCover_Lo_Range;
var config string DeployableCover_Lo_DestructibleArchetype;

var config int DeployableCover_Hi_Range;
var config string DeployableCover_Hi_DestructibleArchetype;

var name FellingAxeCVItemName;
var name FellingAxeMGItemName;
var name FellingAxeBMItemName;
var name DetpackCVItemName;
var name DetpackBMItemName;
var name SIMONCVItemName;
var name SIMONMGItemName;
var name DeployableCoverLoItemName;
var name DeployableCoverHiItemName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

    Weapons.AddItem(FellingAxe_CV());
    Weapons.AddItem(FellingAxe_MG());
    Weapons.AddItem(FellingAxe_BM());
	Weapons.AddItem(DetPack_CV());
	Weapons.AddItem(DetPack_BM());
	Weapons.AddItem(SIMON_CV());
	Weapons.AddItem(SIMON_MG());
    Weapons.AddItem(DeployableCover_Lo());
    Weapons.AddItem(DeployableCover_Hi());

	return Weapons;
}

//---------------------------------------------------------------------------------------------------
// Felling Axe
//---------------------------------------------------------------------------------------------------

static function X2DataTemplate FellingAxe_CV()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, default.FellingAxeCVItemName);
	Template.WeaponPanelImage = "_HuntsmansAxe";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lucu_combatengineer_fellingaxe';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_DLC2Images.ConvHuntmansAxe";
	Template.EquipSound = "Sword_Equip_Conventional";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "DLC_60_WP_HunterAxe_CV.WP_HunterAxe_CV";
	Template.Tier = 0;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 1;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.FellingAxe_CV_BaseDamage;
	Template.Aim = default.FellingAxe_CV_Aim;
	Template.CritChance = default.FellingAxe_CV_CritChance;
	Template.iSoundRange = default.FellingAxe_CV_iSoundRange;
	Template.iEnvironmentDamage = default.FellingAxe_CV_IEnvironmentDamage;
	Template.BaseDamage.DamageType = 'Melee';
	
	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Melee';

	return Template;
}

static function X2DataTemplate FellingAxe_MG()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, default.FellingAxeMGItemName);
	Template.WeaponPanelImage = "_HuntsmansAxe";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lucu_combatengineer_fellingaxe';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_DLC2Images.MagHuntmansAxe";
	Template.EquipSound = "Sword_Equip_Magnetic";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "DLC60_WP_HunterAxe_MG.WP_HunterAxe_MG";
	Template.Tier = 2;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.FellingAxe_MG_BaseDamage;
	Template.Aim = default.FellingAxe_MG_Aim;
	Template.CritChance = default.FellingAxe_MG_CritChance;
	Template.iSoundRange = default.FellingAxe_MG_ISoundRange;
	Template.iEnvironmentDamage = default.FellingAxe_MG_IEnvironmentDamage;
	Template.BaseDamage.DamageType='Melee';

	Template.CreatorTemplateName = class'X2Item_Lucu_CombatEngineer_Schematics'.default.FellingAxeMGSchematicTemplateName; // The schematic which creates this item
	Template.BaseItem = default.FellingAxeCVItemName; // Which item this will be upgraded from
	
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Melee';

	return Template;
}

static function X2DataTemplate FellingAxe_BM()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, default.FellingAxeBMItemName);
	Template.WeaponPanelImage = "_HuntsmansAxe";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lucu_combatengineer_fellingaxe';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_DLC2Images.BeamHuntmansAxe";
	Template.EquipSound = "Sword_Equip_Beam";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "DLC60_WP_HunterAxe_BM.WP_HunterAxe_BM";
	Template.Tier = 4;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.FellingAxe_BM_BaseDamage;
	Template.Aim = default.FellingAxe_BM_Aim;
	Template.CritChance = default.FellingAxe_BM_CritChance;
	Template.iSoundRange = default.FellingAxe_BM_ISoundRange;
	Template.iEnvironmentDamage = default.FellingAxe_BM_IEnvironmentDamage;
	Template.BaseDamage.DamageType='Melee';

	Template.CreatorTemplateName = class'X2Item_Lucu_CombatEngineer_Schematics'.default.FellingAxeBMSchematicTemplateName; // The schematic which creates this item
	Template.BaseItem = default.FellingAxeMGItemName; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Melee';
	
	return Template;
}

//---------------------------------------------------------------------------------------------------
// Det Pack
//---------------------------------------------------------------------------------------------------

static function X2DataTemplate DetPack_CV()
{
	local X2DetPackTemplate_Lucu_CombatEngineer Template;

	`CREATE_X2TEMPLATE(class'X2DetPackTemplate_Lucu_CombatEngineer', Template, default.DetpackCVItemName);
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.strImage = "img:///UILibrary_Lucu_CombatEngineer.X2InventoryIcons.Inv_X4";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.WeaponTech = 'conventional';
	Template.InventorySlot = eInvSlot_Utility;
    
    // These parameters give us proper target visualizations when throwing detpacks
	Template.fRange = default.DetPackRange;
	Template.iRadius = default.DetPackRadius;
	Template.BaseDamage = default.DetPackDamage;
	Template.iEnvironmentDamage = default.DetPackEnvironmentalDamage; // For preview
    Template.Tier = -3;
	
	Template.Abilities.AddItem(class'X2Ability_Lucu_CombatEngineer_CombatEngineerAbilitySet'.default.ThrowDetPackAbilityTemplateName);

	Template.GameArchetype = "Lucu_CombatEngineer_DetPack.WP_Grenade_DetPack";
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
	Template.WeaponTech = 'beam';
	Template.InventorySlot = eInvSlot_Utility;
    
    // These parameters give us proper target visualizations when throwing detpacks
	Template.fRange = default.PlasmaPackRange;
	Template.iRadius = default.PlasmaPackRadius;
	Template.BaseDamage = default.PlasmaPackDamage;
	Template.iEnvironmentDamage = default.PlasmaPackEnvironmentalDamage; // For preview
	Template.Tier = -2;
	
	Template.Abilities.AddItem(class'X2Ability_Lucu_CombatEngineer_CombatEngineerAbilitySet'.default.ThrowDetPackAbilityTemplateName);

	Template.GameArchetype = "Lucu_CombatEngineer_DetPack.WP_Grenade_PlasmaPack";
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
// SIMON
//---------------------------------------------------------------------------------------------------

static function X2DataTemplate SIMON_CV()
{
	local X2SIMONTemplate_Lucu_CombatEngineer Template;
	local X2Effect_Lucu_CombatEngineer_ApplySIMONDamage DamageEffect;
    local X2Effect_PersistentStatChange DisorientedEffect;
	local X2Effect_Knockback KnockbackEffect;

	`CREATE_X2TEMPLATE(class'X2SIMONTemplate_Lucu_CombatEngineer', Template, default.SIMONCVItemName);

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
	Template.fAngle = default.SIMON_CV_Angle;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = -3;

	Template.Abilities.AddItem(class'X2Ability_Lucu_CombatEngineer_CombatEngineerAbilitySet'.default.LaunchSIMONAbilityTemplateName);
	
	Template.GameArchetype = "Lucu_CombatEngineer_SIMON.WP_Grenade_SIMON_CV";

	Template.iPhysicsImpulse = 10;

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;
    
	DamageEffect = new class'X2Effect_Lucu_CombatEngineer_ApplySIMONDamage';
	DamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(DamageEffect);
	Template.LaunchedGrenadeEffects.AddItem(DamageEffect);
    
	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect( , , false);
	DisorientedEffect.bRemoveWhenSourceDies = false;
	Template.ThrownGrenadeEffects.AddItem(DisorientedEffect);
	Template.LaunchedGrenadeEffects.AddItem(DisorientedEffect);

	Template.OnThrowBarkSoundCue = 'ThrowGrenade';

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 4;
	Template.ThrownGrenadeEffects.AddItem(KnockbackEffect);
	Template.LaunchedGrenadeEffects.AddItem(KnockbackEffect);
	
	Template.WeaponPrecomputedPathData.InitialPathTime = 0.4f;
	Template.WeaponPrecomputedPathData.MaxPathTime = 0.8f;
	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;
    
	return Template;
}

static function X2DataTemplate SIMON_MG()
{
	local X2SIMONTemplate_Lucu_CombatEngineer Template;
	local X2Effect_Lucu_CombatEngineer_ApplySIMONDamage DamageEffect;
    local X2Effect_PersistentStatChange DisorientedEffect;
    local X2Effect_Stunned StunnedEffect;
	local X2Effect_Knockback KnockbackEffect;

	`CREATE_X2TEMPLATE(class'X2SIMONTemplate_Lucu_CombatEngineer', Template, default.SIMONMGItemName);

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Rocket_Launcher";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.AddAbilityIconOverride(class'X2Ability_Lucu_CombatEngineer_CombatEngineerAbilitySet'.default.LaunchSIMONAbilityTemplateName, "img:///UILibrary_PerkIcons.UIPerk_firerocket");

	Template.iRange = default.SIMON_MG_Range;
	Template.iRadius = default.SIMON_MG_Radius;
	Template.BaseDamage = default.SIMON_MG_BaseDamage;
	Template.iSoundRange = default.SIMON_MG_SoundRange;
	Template.iEnvironmentDamage = default.SIMON_MG_EnvironmentDamage;
	Template.TradingPostValue = default.SIMON_MG_TradingPostValue;
	Template.iClipSize = default.SIMON_MG_ClipSize;
	Template.fAngle = default.SIMON_MG_Angle;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = -3;

	Template.Abilities.AddItem(class'X2Ability_Lucu_CombatEngineer_CombatEngineerAbilitySet'.default.LaunchSIMONAbilityTemplateName);
	
	Template.GameArchetype = "Lucu_CombatEngineer_SIMON.WP_Grenade_SIMON_MG";

	Template.iPhysicsImpulse = 10;

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;
    
	DamageEffect = new class'X2Effect_Lucu_CombatEngineer_ApplySIMONDamage';
	DamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(DamageEffect);
	Template.LaunchedGrenadeEffects.AddItem(DamageEffect);
    
	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect( , , false);
	DisorientedEffect.bRemoveWhenSourceDies = false;
	Template.ThrownGrenadeEffects.AddItem(DisorientedEffect);
	Template.LaunchedGrenadeEffects.AddItem(DisorientedEffect);

	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.SIMON_MG_StunLevel, default.SIMON_MG_StunChance, false);
	StunnedEffect.bRemoveWhenSourceDies = false;
	Template.ThrownGrenadeEffects.AddItem(StunnedEffect);
	Template.LaunchedGrenadeEffects.AddItem(StunnedEffect);

	Template.OnThrowBarkSoundCue = 'ThrowGrenade';

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 4;
	Template.ThrownGrenadeEffects.AddItem(KnockbackEffect);
	Template.LaunchedGrenadeEffects.AddItem(KnockbackEffect);
	
	Template.WeaponPrecomputedPathData.InitialPathTime = 0.4f;
	Template.WeaponPrecomputedPathData.MaxPathTime = 0.8f;
	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;
    
	return Template;
}

static function X2DataTemplate DeployableCover_Lo()
{
	local X2DeployableCoverTemplate_Lucu_CombatEngineer Template;

	`CREATE_X2TEMPLATE(class'X2DeployableCoverTemplate_Lucu_CombatEngineer', Template, default.DeployableCoverLoItemName);

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Storage_Module";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.AddAbilityIconOverride(class'X2Ability_Lucu_CombatEngineer_CombatEngineerAbilitySet'.default.PlaceDeployableCoverAbilityTemplateName, "img:///UILibrary_Lucu_CombatEngineer.UIPerk_deployablecover");

	Template.WeaponTech = 'conventional';
	Template.InventorySlot = eInvSlot_Utility;
	Template.StowedLocation = eSlot_RightBack;
	Template.bMergeAmmo = true;
	Template.iClipSize = 1;
	Template.Tier = -3;
    
	Template.Abilities.AddItem(class'X2Ability_Lucu_CombatEngineer_CombatEngineerAbilitySet'.default.PlaceDeployableCoverAbilityTemplateName);
    
	Template.iPhysicsImpulse = 10;

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;
    
	Template.GameArchetype = "Lucu_CombatEngineer_DeployableCover.WP_Grenade_DeployableCover_Lo";
    Template.SpawnedDestructibleArchetype = default.DeployableCover_Lo_DestructibleArchetype;

	Template.iRadius = 1;
	Template.fRange = default.DeployableCover_Lo_Range;
    
	return Template;
}

static function X2DataTemplate DeployableCover_Hi()
{
	local X2DeployableCoverTemplate_Lucu_CombatEngineer Template;

	`CREATE_X2TEMPLATE(class'X2DeployableCoverTemplate_Lucu_CombatEngineer', Template, default.DeployableCoverHiItemName);
    
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Storage_Module";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.AddAbilityIconOverride(class'X2Ability_Lucu_CombatEngineer_CombatEngineerAbilitySet'.default.PlaceDeployableCoverAbilityTemplateName, "img:///UILibrary_Lucu_CombatEngineer.UIPerk_deployablecover");
    
	Template.WeaponTech = 'conventional';
	Template.InventorySlot = eInvSlot_Utility;
	Template.StowedLocation = eSlot_RightBack;
	Template.bMergeAmmo = true;
	Template.iClipSize = 1;
	Template.Tier = -2;

	Template.Abilities.AddItem(class'X2Ability_Lucu_CombatEngineer_CombatEngineerAbilitySet'.default.PlaceDeployableCoverAbilityTemplateName);

	Template.GameArchetype = "Lucu_CombatEngineer_DeployableCover.WP_Grenade_DeployableCover_Hi";
    Template.SpawnedDestructibleArchetype = default.DeployableCover_Hi_DestructibleArchetype;

	Template.iPhysicsImpulse = 10;

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;
    
	Template.iRadius = 1;
	Template.fRange = default.DeployableCover_Hi_Range;
    
	return Template;
}

DefaultProperties
{
    FellingAxeCVItemName="Lucu_CombatEngineer_FellingAxe_CV"
    FellingAxeMGItemName="Lucu_CombatEngineer_FellingAxe_MG"
    FellingAxeBMItemName="Lucu_CombatEngineer_FellingAxe_BM"
	DetpackCVItemName="Lucu_CombatEngineer_DetPack_CV"
    DetpackBMItemName="Lucu_CombatEngineer_DetPack_BM"
    SIMONCVItemName="Lucu_CombatEngineer_SIMON_CV"
    SIMONMGItemName="Lucu_CombatEngineer_SIMON_MG"
    DeployableCoverLoItemName="Lucu_CombatEngineer_DeployableCover_Lo"
    DeployableCoverHiItemName="Lucu_CombatEngineer_DeployableCover_Hi"
}
