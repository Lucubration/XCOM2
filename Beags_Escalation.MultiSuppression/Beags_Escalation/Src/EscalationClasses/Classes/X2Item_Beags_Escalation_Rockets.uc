class X2Item_Beags_Escalation_Rockets extends X2Item
	config(Beags_Escalation_Item);

var config int RocketLauncher_CV_SoundRange;
var config int RocketLauncher_CV_EnvironmentDamage;
var config int RocketLauncher_CV_TradingPostValue;
var config int RocketLauncher_CV_ClipSize;
var config float RocketLauncher_CV_RadiusBonus;
var config float RocketLauncher_CV_RangeBonus;
var config float RocketLauncher_CV_MaxScatter;
var config float RocketLauncher_CV_MoveRangePenalty;
var config float RocketLauncher_CV_MaxAimPenalty;
var config int RocketLauncher_CV_SuppressionRangePenalty;

var config WeaponDamageValue Rocket_HighExplosive_BaseDamage;
var config int Rocket_HighExplosive_SoundRange;
var config int Rocket_HighExplosive_EnvironmentDamage;
var config int Rocket_HighExplosive_Supplies;
var config int Rocket_HighExplosive_TradingPostValue;
var config int Rocket_HighExplosive_Points;
var config int Rocket_HighExplosive_ClipSize;
var config float Rocket_HighExplosive_Range;
var config float Rocket_HighExplosive_Radius;
var config int Rocket_HighExplosive_IgnoreBlockingCover;

var config WeaponDamageValue Rocket_Shredder_BaseDamage;
var config int Rocket_Shredder_SoundRange;
var config int Rocket_Shredder_EnvironmentDamage;
var config int Rocket_Shredder_Supplies;
var config int Rocket_Shredder_TradingPostValue;
var config int Rocket_Shredder_Points;
var config int Rocket_Shredder_ClipSize;
var config float Rocket_Shredder_Range;
var config float Rocket_Shredder_Radius;
var config int Rocket_Shredder_IgnoreBlockingCover;

var config WeaponDamageValue Rocket_HighExplosive_Mk2_BaseDamage;
var config int Rocket_HighExplosive_Mk2_SoundRange;
var config int Rocket_HighExplosive_Mk2_EnvironmentDamage;
var config int Rocket_HighExplosive_Mk2_Supplies;
var config int Rocket_HighExplosive_Mk2_TradingPostValue;
var config int Rocket_HighExplosive_Mk2_Points;
var config int Rocket_HighExplosive_Mk2_ClipSize;
var config float Rocket_HighExplosive_Mk2_Range;
var config float Rocket_HighExplosive_Mk2_Radius;
var config int Rocket_HighExplosive_Mk2_IgnoreBlockingCover;

var config WeaponDamageValue Rocket_Shredder_Mk2_BaseDamage;
var config int Rocket_Shredder_Mk2_SoundRange;
var config int Rocket_Shredder_Mk2_EnvironmentDamage;
var config int Rocket_Shredder_Mk2_Supplies;
var config int Rocket_Shredder_Mk2_TradingPostValue;
var config int Rocket_Shredder_Mk2_Points;
var config int Rocket_Shredder_Mk2_ClipSize;
var config float Rocket_Shredder_Mk2_Range;
var config float Rocket_Shredder_Mk2_Radius;
var config int Rocket_Shredder_Mk2_IgnoreBlockingCover;

var config WeaponDamageValue Rocket_BunkerBuster_BaseDamage;
var config int Rocket_BunkerBuster_SoundRange;
var config int Rocket_BunkerBuster_EnvironmentDamage;
var config int Rocket_BunkerBuster_Supplies;
var config int Rocket_BunkerBuster_TradingPostValue;
var config int Rocket_BunkerBuster_Points;
var config int Rocket_BunkerBuster_ClipSize;
var config float Rocket_BunkerBuster_Range;
var config float Rocket_BunkerBuster_Radius;
var config int Rocket_BunkerBuster_IgnoreBlockingCover;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Rockets;

	Rockets.AddItem(RocketLauncher());
	Rockets.AddItem(HighExplosiveRocket());
	Rockets.AddItem(ShredderRocket());
	Rockets.AddItem(HighExplosiveRocketMk2());
	Rockets.AddItem(ShredderRocketMk2());
	Rockets.AddItem(BunkerBuster());

	return Rockets;
}


//---------------------------------------------------------------------------------------------------
// Rocket Launchers
//---------------------------------------------------------------------------------------------------


static function X2DataTemplate RocketLauncher()
{
	local X2RocketLauncherTemplate_Beags_Escalation Template;

	`CREATE_X2TEMPLATE(class'X2RocketLauncherTemplate_Beags_Escalation', Template, 'Beags_Escalation_RocketLauncher_CV');

	Template.strImage = "img:///UILibrary_Common.ConvSecondaryWeapons.ConvGrenade";
	Template.EquipSound = "Secondary_Weapon_Equip_Conventional";

	Template.WeaponTech = 'conventional';
	Template.iSoundRange = default.RocketLauncher_CV_SoundRange;
	Template.iEnvironmentDamage = default.RocketLauncher_CV_EnvironmentDamage;
	Template.TradingPostValue = default.RocketLauncher_CV_TradingPostValue;
	Template.iClipSize = default.RocketLauncher_CV_ClipSize;
	Template.Tier = 0;

	Template.IncreaseRocketRadius = default.RocketLauncher_CV_RadiusBonus;
	Template.IncreaseRocketRange = `UNITSTOTILES(default.RocketLauncher_CV_RangeBonus);
	Template.MaxRocketScatter = `UNITSTOTILES(default.RocketLauncher_CV_MaxScatter);
	Template.MoveRangePenalty = `UNITSTOTILES(default.RocketLauncher_CV_MoveRangePenalty);
	Template.MaxAimPenalty = default.RocketLauncher_CV_MaxAimPenalty;
	Template.SuppressionRangePenalty = default.RocketLauncher_CV_SuppressionRangePenalty;

	Template.Abilities.AddItem(class'X2Ability_Beags_Escalation_RocketeerAbilitySet'.default.RocketLauncherMovementPenaltyAbilityName);

	Template.GameArchetype = "WP_GrenadeLauncher_CV.WP_GrenadeLauncher_CV";
	
	Template.StartingItem = true;
	Template.CanBeBuilt = false;

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Rockets (Tier 0)
//---------------------------------------------------------------------------------------------------


static function X2DataTemplate HighExplosiveRocket()
{
	local X2RocketTemplate_Beags_Escalation Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2Effect_Knockback KnockbackEffect;

	`CREATE_X2TEMPLATE(class'X2RocketTemplate_Beags_Escalation', Template, 'Beags_Escalation_Rocket_HighExplosive');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Rocket_Launcher";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.AddAbilityIconOverride('Beags_Escalation_LaunchRocket', "img:///UILibrary_Beags_Escalation_Icons.UIPerk_firerocket");

	Template.iRange = default.Rocket_HighExplosive_Range;
	Template.iRadius = default.Rocket_HighExplosive_Radius;
	Template.BaseDamage = default.Rocket_HighExplosive_BaseDamage;
	Template.iSoundRange = default.Rocket_HighExplosive_SoundRange;
	Template.iEnvironmentDamage = default.Rocket_HighExplosive_EnvironmentDamage;
	Template.TradingPostValue = default.Rocket_HighExplosive_TradingPostValue;
	Template.iClipSize = default.Rocket_HighExplosive_ClipSize;
	Template.IgnoreBlockingCover = bool(default.Rocket_HighExplosive_IgnoreBlockingCover);
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = 0;

	Template.Abilities.AddItem('Beags_Escalation_LaunchRocket');
	Template.Abilities.AddItem(class'X2Ability_Beags_Escalation_RocketeerAbilitySet'.default.RocketMobilityPenaltyAbilityName);
	Template.Abilities.AddItem('RocketFuse');
	
	Template.GameArchetype = "WP_Heavy_RocketLauncher.WP_Heavy_RocketLauncher";

	Template.iPhysicsImpulse = 10;

	Template.StartingItem = true;
	Template.CanBeBuilt = false;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	Template.LaunchedGrenadeEffects.AddItem(WeaponDamageEffect);

	Template.HideIfResearched = 'AdvancedGrenades';

	Template.OnThrowBarkSoundCue = 'ThrowGrenade';

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.bUseTargetLocation = true; //This looks better for the animations used even though the source location should be used for grenades.
	KnockbackEffect.KnockbackDistance = 2;
	Template.LaunchedGrenadeEffects.AddItem(KnockbackEffect);
	
	return Template;
}

static function X2DataTemplate ShredderRocket()
{
	local X2RocketTemplate_Beags_Escalation Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2Effect_Knockback KnockbackEffect;

	`CREATE_X2TEMPLATE(class'X2RocketTemplate_Beags_Escalation', Template, 'Beags_Escalation_Rocket_Shredder');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Rocket_Launcher_PLATED";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.AddAbilityIconOverride('Beags_Escalation_LaunchRocket', "img:///UILibrary_Beags_Escalation_Icons.UIPerk_shredderrocket");

	Template.iRange = default.Rocket_Shredder_Range;
	Template.iRadius = default.Rocket_Shredder_Radius;
	Template.BaseDamage = default.Rocket_Shredder_BaseDamage;
	Template.iSoundRange = default.Rocket_Shredder_SoundRange;
	Template.iEnvironmentDamage = default.Rocket_Shredder_EnvironmentDamage;
	Template.TradingPostValue = default.Rocket_Shredder_TradingPostValue;
	Template.iClipSize = default.Rocket_Shredder_ClipSize;
	Template.IgnoreBlockingCover = bool(default.Rocket_Shredder_IgnoreBlockingCover);
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = 0;

	Template.Abilities.AddItem('Beags_Escalation_LaunchRocket');
	Template.Abilities.AddItem(class'X2Ability_Beags_Escalation_RocketeerAbilitySet'.default.RocketMobilityPenaltyAbilityName);
	Template.Abilities.AddItem('RocketFuse');
	
	Template.GameArchetype = "WP_Heavy_RocketLauncher.WP_Heavy_RocketLauncher";

	Template.iPhysicsImpulse = 10;

	Template.StartingItem = true;
	Template.CanBeBuilt = false;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	Template.LaunchedGrenadeEffects.AddItem(WeaponDamageEffect);

	Template.HideIfResearched = 'AdvancedGrenades';

	Template.OnThrowBarkSoundCue = 'ThrowGrenade';

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.bUseTargetLocation = true; //This looks better for the animations used even though the source location should be used for grenades.
	KnockbackEffect.KnockbackDistance = 2;
	Template.LaunchedGrenadeEffects.AddItem(KnockbackEffect);
	
	return Template;
}


//---------------------------------------------------------------------------------------------------
// Rockets (Tier 2)
//---------------------------------------------------------------------------------------------------


static function X2DataTemplate HighExplosiveRocketMk2()
{
	local X2RocketTemplate_Beags_Escalation Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2Effect_Knockback KnockbackEffect;

	`CREATE_X2TEMPLATE(class'X2RocketTemplate_Beags_Escalation', Template, 'Beags_Escalation_Rocket_HighExplosive_Mk2');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Rocket_Launcher";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.AddAbilityIconOverride('Beags_Escalation_LaunchRocket', "img:///UILibrary_Beags_Escalation_Icons.UIPerk_firerocket");

	Template.iRange = default.Rocket_HighExplosive_Mk2_Range;
	Template.iRadius = default.Rocket_HighExplosive_Mk2_Radius;
	Template.BaseDamage = default.Rocket_HighExplosive_Mk2_BaseDamage;
	Template.iSoundRange = default.Rocket_HighExplosive_Mk2_SoundRange;
	Template.iEnvironmentDamage = default.Rocket_HighExplosive_Mk2_EnvironmentDamage;
	Template.TradingPostValue = default.Rocket_HighExplosive_Mk2_TradingPostValue;
	Template.iClipSize = default.Rocket_HighExplosive_Mk2_ClipSize;
	Template.IgnoreBlockingCover = bool(default.Rocket_HighExplosive_Mk2_IgnoreBlockingCover);
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = 2;

	Template.Abilities.AddItem('Beags_Escalation_LaunchRocket');
	Template.Abilities.AddItem(class'X2Ability_Beags_Escalation_RocketeerAbilitySet'.default.RocketMobilityPenaltyAbilityName);
	Template.Abilities.AddItem('RocketFuse');
	
	// We could make this a "plasma rocket" but to be honest it doesn't look great right now. It's more like
	// a plasma cannon or something because the timing's too fast and it doesn't leave the smoke trail (obviously)
	// from the rocket launcher
	//Template.GameArchetype = "WP_Heavy_BlasterLauncher.WP_Heavy_BlasterLauncher";
	Template.GameArchetype = "WP_Heavy_RocketLauncher.WP_Heavy_RocketLauncher";
	
	Template.iPhysicsImpulse = 10;
	
	Template.CreatorTemplateName = 'AdvancedGrenades'; // The schematic which creates this item
	Template.BaseItem = 'Beags_Escalation_Rocket_HighExplosive'; // Which item this will be upgraded from

	Template.bInfiniteItem = true;
	Template.StartingItem = false;
	Template.CanBeBuilt = false;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	Template.LaunchedGrenadeEffects.AddItem(WeaponDamageEffect);

	Template.OnThrowBarkSoundCue = 'ThrowGrenade';

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.bUseTargetLocation = true; //This looks better for the animations used even though the source location should be used for grenades.
	KnockbackEffect.KnockbackDistance = 4;
	Template.LaunchedGrenadeEffects.AddItem(KnockbackEffect);
	
	return Template;
}

static function X2DataTemplate ShredderRocketMk2()
{
	local X2RocketTemplate_Beags_Escalation Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2Effect_Knockback KnockbackEffect;

	`CREATE_X2TEMPLATE(class'X2RocketTemplate_Beags_Escalation', Template, 'Beags_Escalation_Rocket_Shredder_Mk2');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Rocket_Launcher_PLATED";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.AddAbilityIconOverride('Beags_Escalation_LaunchRocket', "img:///UILibrary_Beags_Escalation_Icons.UIPerk_shredderrocket");

	Template.iRange = default.Rocket_Shredder_Mk2_Range;
	Template.iRadius = default.Rocket_Shredder_Mk2_Radius;
	Template.BaseDamage = default.Rocket_Shredder_Mk2_BaseDamage;
	Template.iSoundRange = default.Rocket_Shredder_Mk2_SoundRange;
	Template.iEnvironmentDamage = default.Rocket_Shredder_Mk2_EnvironmentDamage;
	Template.TradingPostValue = default.Rocket_Shredder_Mk2_TradingPostValue;
	Template.iClipSize = default.Rocket_Shredder_Mk2_ClipSize;
	Template.IgnoreBlockingCover = bool(default.Rocket_Shredder_Mk2_IgnoreBlockingCover);
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = 2;

	Template.Abilities.AddItem('Beags_Escalation_LaunchRocket');
	Template.Abilities.AddItem(class'X2Ability_Beags_Escalation_RocketeerAbilitySet'.default.RocketMobilityPenaltyAbilityName);
	Template.Abilities.AddItem('RocketFuse');
	
	Template.GameArchetype = "WP_Heavy_RocketLauncher.WP_Heavy_RocketLauncher";

	Template.iPhysicsImpulse = 10;
	
	Template.CreatorTemplateName = 'AdvancedGrenades'; // The schematic which creates this item
	Template.BaseItem = 'Beags_Escalation_Rocket_Shredder'; // Which item this will be upgraded from

	Template.bInfiniteItem = true;
	Template.StartingItem = false;
	Template.CanBeBuilt = false;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	Template.LaunchedGrenadeEffects.AddItem(WeaponDamageEffect);

	Template.OnThrowBarkSoundCue = 'ThrowGrenade';

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.bUseTargetLocation = true; //This looks better for the animations used even though the source location should be used for grenades.
	KnockbackEffect.KnockbackDistance = 4;
	Template.LaunchedGrenadeEffects.AddItem(KnockbackEffect);
	
	return Template;
}


//---------------------------------------------------------------------------------------------------
// Rockets (Tier Uber)
//---------------------------------------------------------------------------------------------------


static function X2DataTemplate BunkerBuster()
{
	local X2RocketTemplate_Beags_Escalation Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2Effect_Knockback KnockbackEffect;

	`CREATE_X2TEMPLATE(class'X2RocketTemplate_Beags_Escalation', Template, 'Beags_Escalation_Rocket_BunkerBuster');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Rocket_Launcher";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.AddAbilityIconOverride('Beags_Escalation_LaunchBunkerBuster', "img:///UILibrary_Beags_Escalation_Icons.UIPerk_bunkerbuster");
	Template.WeaponCat = 'beags_escalation_bunkerbuster';

	Template.iRange = default.Rocket_BunkerBuster_Range;
	Template.iRadius = default.Rocket_BunkerBuster_Radius;
	Template.BaseDamage = default.Rocket_BunkerBuster_BaseDamage;
	Template.iSoundRange = default.Rocket_BunkerBuster_SoundRange;
	Template.iEnvironmentDamage = default.Rocket_BunkerBuster_EnvironmentDamage;
	Template.TradingPostValue = default.Rocket_BunkerBuster_TradingPostValue;
	Template.iClipSize = default.Rocket_BunkerBuster_ClipSize;
	Template.IgnoreBlockingCover = bool(default.Rocket_BunkerBuster_IgnoreBlockingCover);
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = 0;

	Template.Abilities.AddItem('Beags_Escalation_LaunchBunkerBuster');
	Template.Abilities.AddItem('RocketFuse');
	
	Template.GameArchetype = "WP_Heavy_RocketLauncher.WP_Heavy_RocketLauncher";

	Template.iPhysicsImpulse = 10;

	Template.StartingItem = false;
	Template.CanBeBuilt = false;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	Template.LaunchedGrenadeEffects.AddItem(WeaponDamageEffect);

	Template.OnThrowBarkSoundCue = 'ThrowGrenade';

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.bUseTargetLocation = true; //This looks better for the animations used even though the source location should be used for grenades.
	KnockbackEffect.KnockbackDistance = 7;
	Template.LaunchedGrenadeEffects.AddItem(KnockbackEffect);
	
	return Template;
}
