//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Ability_AdvPurifier extends X2Ability
	config(GameData_SoldierSkills);

var config int ADVPURIFIER_FLAMETHROWER_AMMOCOST;
var config int ADVPURIFIER_FLAMETHROWER_ACTIONPOINTCOST;
var config int ADVPURIFIER_FLAMETHROWER_TILE_LENGTH;
var config int ADVPURIFIER_FLAMETHROWER_TILE_WIDTH;
var config float ADVPURIFIER_FLAMETHROWER_FIRECHANCE_LVL1;
var config float ADVPURIFIER_FLAMETHROWER_FIRECHANCE_LVL2;
var config float ADVPURIFIER_FLAMETHROWER_FIRECHANCE_LVL3;
var config array<name> ADVPURIFIER_FLAMETHROWER_GUARANTEEHIT_TYPES;
var config int ADVPURIFIER_FLAMETHROWER_DMG_PER_TICK;
var config int ADVPURIFIER_FLAMETHROWER_SPREAD_PER_TICK;

var config float ADVPURIFIER_DEATH_EXPLOSION_RADIUS_METERS;
var config int ADVPURIFIER_EXPLOSION_ENV_DMG;
var config array<name> ADVPURIFIER_GUARANTEED_EXPLOSION_DAMAGE_TYPES;
var config int ADVPURIFIER_DEATH_EXPLOSION_PERCENT_CHANCE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(PurePassive('AdvPurifierImmunities', "img:///UILibrary_PerkIcons.UIPerk_immunities"));
	Templates.AddItem(CreateAdvPurifierFlamethrower());
	Templates.AddItem(CreatePurifierInit());
	Templates.AddItem(CreatePurifierDeathExplosion());
	
	return Templates;
}

static function X2AbilityTemplate CreateAdvPurifierFlamethrower()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2AbilityTarget_Cursor CursorTarget;
	local X2AbilityMultiTarget_Cone ConeMultiTarget;
	local X2Effect_ApplyFireToWorld FireToWorldEffect;
	local X2AbilityToHitCalc_StandardAim StandardAim;
	local X2Condition_UnitType UnitTypeCondition;
	local X2Effect_Burning BurningEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'AdvPurifierFlamethrower');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WrongSoldierClass');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_flamethrower";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.ARMOR_ACTIVE_PRIORITY;	

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.ADVPURIFIER_FLAMETHROWER_ACTIONPOINTCOST;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bAllowCrit = false;
	Template.AbilityToHitCalc = StandardAim;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Shooter conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.AddShooterEffectExclusions();

	Template.AbilityMultiTargetConditions.AddItem(default.LivingTargetOnlyProperty);

	FireToWorldEffect = new class'X2Effect_ApplyFireToWorld';
	FireToWorldEffect.bUseFireChanceLevel = true;
	FireToWorldEffect.bDamageFragileOnly = true;
	FireToWorldEffect.FireChance_Level1 = default.ADVPURIFIER_FLAMETHROWER_FIRECHANCE_LVL1;
	FireToWorldEffect.FireChance_Level2 = default.ADVPURIFIER_FLAMETHROWER_FIRECHANCE_LVL2;
	FireToWorldEffect.FireChance_Level3 = default.ADVPURIFIER_FLAMETHROWER_FIRECHANCE_LVL3;
	FireToWorldEffect.bCheckForLOSFromTargetLocation = false; //The flamethrower does its own LOS filtering
	Template.AddMultiTargetEffect(FireToWorldEffect);

	// Guaranteed to hit units don't get this damage
	UnitTypeCondition = new class'X2Condition_UnitType';
	UnitTypeCondition.ExcludeTypes = default.ADVPURIFIER_FLAMETHROWER_GUARANTEEHIT_TYPES;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.TargetConditions.AddItem(UnitTypeCondition);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.ADVPURIFIER_FLAMETHROWER_DMG_PER_TICK, default.ADVPURIFIER_FLAMETHROWER_SPREAD_PER_TICK);
	BurningEffect.TargetConditions.AddItem(UnitTypeCondition);
	Template.AddMultiTargetEffect(BurningEffect);

	// These are the effects that hit the guaranteed unit types
	UnitTypeCondition = new class'X2Condition_UnitType';
	UnitTypeCondition.IncludeTypes = default.ADVPURIFIER_FLAMETHROWER_GUARANTEEHIT_TYPES;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.TargetConditions.AddItem(UnitTypeCondition);
	WeaponDamageEffect.bApplyOnMiss = true;
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.ADVPURIFIER_FLAMETHROWER_DMG_PER_TICK, default.ADVPURIFIER_FLAMETHROWER_SPREAD_PER_TICK);
	BurningEffect.TargetConditions.AddItem(UnitTypeCondition);
	BurningEffect.bApplyOnMiss = true;
	Template.AddMultiTargetEffect(BurningEffect);

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.ConeEndDiameter = default.ADVPURIFIER_FLAMETHROWER_TILE_WIDTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.ADVPURIFIER_FLAMETHROWER_TILE_LENGTH * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.bCheckCollision = true;
	Template.bAffectNeighboringTiles = true;
	Template.bFragileDamageOnly = true;

	Template.ActionFireClass = class'X2Action_Fire_Flamethrower_Purifier';

	Template.TargetingMethod = class'X2TargetingMethod_Cone';

	Template.ActivationSpeech = 'Flamethrower';
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
//BEGIN AUTOGENERATED CODE: Template Overrides 'AdvPurifierFlamethrower'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'AdvPurifierFlamethrower'

	Template.DamagePreviewFn = AdvPurifierFlamethrower_DamagePreview;

	return Template;
}

function bool AdvPurifierFlamethrower_DamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	AbilityState.GetMyTemplate().AbilityMultiTargetEffects[1].GetDamagePreview(TargetRef, AbilityState, false, MinDamagePreview, MaxDamagePreview, AllowsShield);
	return true;
}

static function X2AbilityTemplate CreatePurifierInit()
{
	local X2AbilityTemplate Template;
	local X2Effect_DamageImmunity DamageImmunity;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'PurifierInit');

	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AdditionalAbilities.AddItem('PurifierDeathExplosion');

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	// Build the immunities
	DamageImmunity = new class'X2Effect_DamageImmunity';
	DamageImmunity.BuildPersistentEffect(1, true, false, true);
	DamageImmunity.ImmuneTypes.AddItem('Fire');
	DamageImmunity.ImmuneTypes.AddItem('Poison');
	DamageImmunity.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.ParthenogenicPoisonType);
	DamageImmunity.EffectName = 'AdvPurifierDamageImmunityEffect';
	Template.AddTargetEffect(DamageImmunity);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate CreatePurifierDeathExplosion()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener EventListener;
	local X2AbilityMultiTarget_Radius MultiTarget;
	local X2Condition_UnitProperty UnitPropertyCondition;
	local X2Effect_ApplyWeaponDamage DamageEffect;
	local X2Effect_KillUnit KillUnitEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'PurifierDeathExplosion');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_purifierdeathexplosion";

	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Offensive;

	// This ability is only valid if there has not been another death explosion on the unit
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeDeadFromSpecialDeath = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitDied';
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_PurifierIgnite;
	Template.AbilityTriggers.AddItem(EventListener);

	// Targets the unit so the blast center is its dead body
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityToHitCalc = default.DeadEye;

	// Target everything in this blast radius
	MultiTarget = new class'X2AbilityMultiTarget_Radius';
	MultiTarget.fTargetRadius = default.ADVPURIFIER_DEATH_EXPLOSION_RADIUS_METERS;
	Template.AbilityMultiTargetStyle = MultiTarget;

	Template.AddTargetEffect(new class'X2Effect_SetSpecialDeath');

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.FailOnNonUnits = false; //The grenade can affect interactive objects, others
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	// Everything in the blast radius receives physical damage
	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.EffectDamageValue = class'X2Item_XpackWeapons'.default.ADVPURIFIER_DEATH_EXPLOSION_BASEDAMAGE;
	DamageEffect.EnvironmentalDamageAmount = default.ADVPURIFIER_EXPLOSION_ENV_DMG;
	Template.AddMultiTargetEffect(DamageEffect);

	// If the unit is alive, kill it
	KillUnitEffect = new class'X2Effect_KillUnit';
	KillUnitEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnEnd);
	KillUnitEffect.EffectName = 'KillUnit';
	KillUnitEffect.DeathActionClass = class'X2Action_ExplodingPurifierDeathAction';
	Template.AddTargetEffect(KillUnitEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_Death'.static.DeathExplosion_BuildVisualization;
	Template.MergeVisualizationFn = class'X2Ability_Death'.static.DeathExplostion_MergeVisualization;
	//Template.VisualizationTrackInsertedFn = class'X2Ability_Death'.static.DeathExplosion_VisualizationTrackInsert;

	Template.FrameAbilityCameraType = eCameraFraming_Never;

	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'PurifierDeathExplosion'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'PurifierDeathExplosion'

	return Template;
}
