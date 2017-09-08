//---------------------------------------------------------------------------------------
//  FILE:    X2Item_XpackUtilityItems.uc
//  AUTHOR:  Joe Weinhoffer  --  11/11/2016
//  PURPOSE: Create Xpack utility item templates
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Item_XpackUtilityItems extends X2Item config(GameCore);

var config int ULTRASONICLURE_RANGE;
var config int ULTRASONICLURE_RADIUS;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Items;

	Items.AddItem(CreateSustainingSphere());
	Items.AddItem(CreateRefractionField());
	Items.AddItem(CreateUltrasonicLure());

	return Items;
}

static function X2DataTemplate CreateSustainingSphere()
{
	local X2WeaponTemplate Template;
	local ArtifactCost Resources;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'SustainingSphere');
	Template.ItemCat = 'utility';
	Template.WeaponCat = 'utility';

	Template.InventorySlot = eInvSlot_Utility;
	Template.StowedLocation = eSlot_RearBackPack;
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_SustainSphere";
	Template.EquipSound = "StrategyUI_Mindshield_Equip";

	Template.Abilities.AddItem('SustainingSphereAbility');

	Template.GameArchetype = "WP_Medikit.WP_CombatStim";

	Template.CanBeBuilt = true;
	Template.TradingPostValue = 10;
	Template.Tier = 2;

	Template.bShouldCreateDifficultyVariants = true;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventPriest');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 50;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'CorpseAdventPriest';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	return Template;
}

static function X2DataTemplate CreateRefractionField()
{
	local X2WeaponTemplate Template;
	local ArtifactCost Resources;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'RefractionField');
	Template.ItemCat = 'utility';
	Template.WeaponCat = 'utility';

	Template.InventorySlot = eInvSlot_Utility;
	Template.StowedLocation = eSlot_RearBackPack;
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_RefractionField";
	Template.EquipSound = "StrategyUI_Medkit_Equip";

	Template.Abilities.AddItem('RefractionFieldAbility');

	Template.GameArchetype = "WP_Grenade_MimicBeacon.WP_Grenade_MimicBeacon";

	Template.CanBeBuilt = true;
	Template.bMergeAmmo = true;
	Template.iClipSize = 1;
	Template.Tier = 1;

	Template.bShouldCreateDifficultyVariants = true;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsySpectre');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 50;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'CorpseSpectre';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	return Template;
}

static function X2WeaponTemplate CreateUltrasonicLure()
{
	local X2GrenadeTemplate Template;
	local ArtifactCost Resources;
	local X2Condition_UnitType UnitTypeCondition;
	local X2Effect_Persistent LureEffect;
	local X2Effect_AlertTheLost LostActivateEffect;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'UltrasonicLure');

	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_UltrasonicLure";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.AddAbilityIconOverride('ThrowGrenade', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_ultrasoniclure");
	Template.AddAbilityIconOverride('LaunchGrenade', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_ultrasoniclure");
	Template.GameArchetype = "WP_Ultrasonic_Lure.WP_Ultrasonic_Lure";

	Template.Abilities.AddItem('ThrowGrenade');
	Template.Abilities.AddItem('GrenadeFuse');

	Template.ItemCat = 'tech';
	Template.WeaponCat = 'utility';
	Template.WeaponTech = 'conventional';
	Template.InventorySlot = eInvSlot_Utility;
	Template.StowedLocation = eSlot_BeltHolster;
	Template.bMergeAmmo = true;
	Template.iClipSize = 2;
	Template.Tier = 1;

	Template.bShouldCreateDifficultyVariants = true;

	Template.iRadius = default.ULTRASONICLURE_RADIUS;
	Template.iRange = default.ULTRASONICLURE_RANGE;
	Template.bIgnoreRadialBlockingCover = true;

	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;
	Template.TradingPostValue = 6;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.ULTRASONICLURE_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.ULTRASONICLURE_RADIUS);

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyTheLost');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 30;
	Template.Cost.ResourceCosts.AddItem(Resources);

	// Apply an effect on all non-lost units in the grenade range, to paint as targets.
	UnitTypeCondition = new class'X2Condition_UnitType';
	UnitTypeCondition.ExcludeTypes.AddItem('TheLost');
	LureEffect = class'X2StatusEffects'.static.CreateUltrasonicLureTargetStatusEffect();
	LureEffect.TargetConditions.AddItem(UnitTypeCondition);
	Template.ThrownGrenadeEffects.AddItem(LureEffect);

	// Apply an effect on all lost units within sight range, to activate inactive lost groups.
	LostActivateEffect = new class'X2Effect_AlertTheLost';
	Template.ThrownGrenadeEffects.AddItem(LostActivateEffect);
	Template.LaunchedGrenadeEffects = Template.ThrownGrenadeEffects;

	Template.bFriendlyFireWarning = false;

	return Template;
}