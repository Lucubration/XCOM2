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

var name DetpackCVItemName;
var name DetpackBMItemName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

	Weapons.AddItem(DetPackCV());
	Weapons.AddItem(DetPackBM());

	return Weapons;
}

static function X2DataTemplate DetPackCV()
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

static function X2DataTemplate DetPackBM()
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

DefaultProperties
{
	DetpackCVItemName="Lucu_CombatEngineer_DetPack_CV"
    DetpackBMItemName="Lucu_CombatEngineer_DetPack_BM"
}
