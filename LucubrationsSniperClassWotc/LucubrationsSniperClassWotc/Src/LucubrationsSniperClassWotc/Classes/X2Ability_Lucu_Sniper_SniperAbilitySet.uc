class X2Ability_Lucu_Sniper_SniperAbilitySet extends X2Ability
	config(Lucu_Sniper_Ability);

const SNIPER_TRAINING_PRIORITY = 380;

var config int Version;

var config int SniperTrainingAimPenalty;
var config int ZeroInAimBonus;
var config int ZeroInCritBonus;
var config float BallisticsExpertHitModRoot;
var config int PrecisionShotCooldown;
var config int PrecisionShotCritBonus;
var config array<int> PrecisionShotDamageBonus;
var config int TargetLeadingAimBonus;
var config int TargetLeadingGrazePenalty;
var config int HideCritBonus;
var config int FollowUpGrants;
var config int RelocationGrants;
var config int SabotRoundAmmo;
var config int SabotRoundCooldown;
var config int SabotRoundEnvironmentalDamage;
var config array<int> SabotRoundArmorPenetration;
var config array<int> SabotRoundDamageBonus;
var config array<int> VitalPointTargetingDamageBonus;

var localized string SetUpFriendlyDesc;
var localized string ZeroInFriendlyDesc;
var localized string CoverTargetFriendlyDesc;
var localized string FollowUpTargetFriendlyDesc;
var localized string SetUpLostString;
var localized string RelocationFriendlyName;
var localized string RelocationFriendlyDesc;

var name SetUpEffectName;
var name PrecisionShotAbilityName;
var name CoverTargetActionPoint;
var name CoverTargetEffectName;
var name CoveredTargetEffectName;
var name CoverTargetShotAbilityName;
var name CanHideName;
var name FollowUpName;
var name FollowUpActionPoint;
var name FollowUpShotAbilityName;
var name RelocationName;
var name RelocationActiveAbilityName;
var name RelocationActiveEffectName;
var name SabotRoundAbilityName;
var name SabotRoundSetUpAbilityName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	// Before building our templates, first perform any config versioning and load the user's config values into this class
	class'Lucu_Sniper_Config'.static.LoadUserConfig();

	Templates.Length = 0;
	Templates.AddItem(SniperTraining());
	Templates.AddItem(SniperRifleShot());
	Templates.AddItem(SniperRifleOverwatch());
	Templates.AddItem(SniperRifleOverwatch_SetUp());
	Templates.AddItem(PistolOverwatch());
	Templates.AddItem(SetUp());
	Templates.AddItem(ZeroIn());
	Templates.AddItem(LowProfile());
	Templates.AddItem(CoverTarget());
	Templates.AddItem(CoverTargetShot());
	Templates.AddItem(PrecisionShot());
	Templates.AddItem(PrecisionShotDamage());
	Templates.AddItem(TargetLeading());
	Templates.AddItem(Hide());
	Templates.AddItem(HideStealth());
	Templates.AddItem(FollowUp());
	Templates.AddItem(FollowUpShot());
	Templates.AddItem(Relocation());
	Templates.AddItem(RelocationActive());
	Templates.AddItem(Sharpshooter());
	Templates.AddItem(SabotRound());
	Templates.AddItem(SabotRoundDamage());
	Templates.AddItem(VitalPointTargeting());
	Templates.AddItem(InTheZone());
	Templates.AddItem(BallisticsExpert());

	return Templates;
}


//---------------------------------------------------------------------------------------------------
// Sniper Training
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate SniperTraining()
{
	local X2AbilityTemplate						Template;
	local X2Effect_Lucu_Sniper_SniperTraining	Effect;
	
	`LOG("Lucubration Sniper Class: Sniper Training aim penalty=" @ string(default.SniperTrainingAimPenalty));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Sniper_SniperTraining');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Lucu_Sniper_Icons.UIPerk_snipertraining";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Effect = new class'X2Effect_Lucu_Sniper_SniperTraining';
	Effect.EffectName = 'Lucu_Sniper_SniperTraining';
	Effect.DuplicateResponse = eDupe_Ignore;
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Effect.AimPenalty = default.SniperTrainingAimPenalty;
	Template.AddTargetEffect(Effect);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	// This is our shot
	Template.AdditionalAbilities.AddItem('Lucu_Sniper_SniperRifleShot');
	// These just have different icons to indicate whether the soldier has squadsight
	Template.AdditionalAbilities.AddItem('Lucu_Sniper_SniperRifleOverwatch');
	Template.AdditionalAbilities.AddItem('Lucu_Sniper_SniperRifleOverwatch_SetUp');
	// This overrides the overwatch shot so that squadsight will apply if possible
	Template.AdditionalAbilities.AddItem('LongWatchShot');
	// This is just in here so I can order the shots correctly in the Overwatch All priority array
	Template.AdditionalAbilities.AddItem('Lucu_Sniper_PistolOverwatch');

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Sniper Rifle Shot
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate SniperRifleShot()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2Condition_Visibility            TargetVisibilityCondition;
	local array<name>                       SkipExclusions;
	local X2Effect_Knockback				KnockbackEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Sniper_SniperRifleShot');
	
	// Icon Properties
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_snipershot";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY;
	Template.DisplayTargetHitChance = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailableOrNoTargets;
	Template.AbilitySourceName = 'eAbilitySource_Standard';                                       // color of the icon
	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.bHideOnClassUnlock = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	
	// *** VALIDITY CHECKS *** //
	// Status condtions that do *not* prohibit this action.
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// *** TARGETING PARAMETERS *** //
	// Can only shoot visible enemies
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Action Point
	ActionPointCost = new class 'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;                                               // Consume all points
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true;

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = true;                                            // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	//  Various Soldier ability specific effects - effects check for the ability before applying	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

	// Damage Effect
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

	// Hit Calculation (Different weapons now have different calculations for range)
	Template.AbilityToHitCalc = default.SimpleStandardAim;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;

	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);
	
	Template.OverrideAbilities.AddItem('SniperStandardFire');

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Sniper Rifle Overwatch
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate SniperRifleOverwatch()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ReserveActionPoints      ReserveActionPointsEffect;
	local array<name>                       SkipExclusions;
	local X2Condition_UnitEffects			ExcludeEffects;
	local X2Effect_CoveringFire             CoveringFireEffect;
	local X2Condition_AbilityProperty       CoveringFireCondition;
	local X2Condition_UnitProperty          ConcealedCondition;
	local X2Effect_SetUnitValue             UnitValueEffect;
	local X2Condition_UnitEffects           SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Sniper_SniperRifleOverwatch');
	
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	AmmoCost.bFreeCost = true;                  //  ammo is consumed by the shot, not by this, but this should verify ammo is available
	Template.AbilityCosts.AddItem(AmmoCost);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.bFreeCost = true;           //  ReserveActionPoints effect will take all action points away
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);
	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);
	
	ExcludeEffects = new class'X2Condition_UnitEffects';
	ExcludeEffects.AddExcludeEffect(default.SetUpEffectName, 'AA_Lucu_Sniper_UnitIsSetUp');
	Template.AbilityShooterConditions.AddItem(ExcludeEffects);

	ReserveActionPointsEffect = new class'X2Effect_ReserveOverwatchPoints';
	Template.AddTargetEffect(ReserveActionPointsEffect);

	CoveringFireEffect = new class'X2Effect_CoveringFire';
	CoveringFireEffect.AbilityToActivate = 'LongWatchShot'; // Changing covering fire to use squadsight
	CoveringFireEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	CoveringFireCondition = new class'X2Condition_AbilityProperty';
	CoveringFireCondition.OwnerHasSoldierAbilities.AddItem('CoveringFire');
	CoveringFireEffect.TargetConditions.AddItem(CoveringFireCondition);
	Template.AddTargetEffect(CoveringFireEffect);

	ConcealedCondition = new class'X2Condition_UnitProperty';
	ConcealedCondition.ExcludeFriendlyToSource = false;
	ConcealedCondition.IsConcealed = true;
	UnitValueEffect = new class'X2Effect_SetUnitValue';
	UnitValueEffect.UnitName = class'X2Ability_DefaultAbilitySet'.default.ConcealedOverwatchTurn;
	UnitValueEffect.CleanupType = eCleanup_BeginTurn;
	UnitValueEffect.NewValueToSet = 1;
	UnitValueEffect.TargetConditions.AddItem(ConcealedCondition);
	Template.AddTargetEffect(UnitValueEffect);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_ActionPoints');
	Template.HideErrors.AddItem('AA_Lucu_Sniper_UnitIsSetUp');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_overwatch";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.OVERWATCH_PRIORITY;
	Template.bHideOnClassUnlock = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityConfirmSound = "Unreal2DSounds_OverWatch";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_DefaultAbilitySet'.static.OverwatchAbility_BuildVisualization;
	Template.CinescriptCameraType = "Overwatch";

	Template.Hostility = eHostility_Defensive;

	Template.OverrideAbilities.AddItem('SniperRifleOverwatch');

	Template.DefaultKeyBinding = class'UIUtilities_Input'.const.FXS_KEY_Y;
	Template.bNoConfirmationWithHotKey = true;

	return Template;	
}


//---------------------------------------------------------------------------------------------------
// Sniper Rifle Overwatch (Set Up)
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate SniperRifleOverwatch_SetUp()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ReserveActionPoints      ReserveActionPointsEffect;
	local array<name>                       SkipExclusions;
	local X2Condition_UnitEffects			RequiredEffects;
	local X2Effect_CoveringFire             CoveringFireEffect;
	local X2Condition_AbilityProperty       CoveringFireCondition;
	local X2Condition_UnitProperty          ConcealedCondition;
	local X2Effect_SetUnitValue             UnitValueEffect;
	local X2Condition_UnitEffects           SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Sniper_SniperRifleOverwatch_SetUp');
	
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	AmmoCost.bFreeCost = true;                  //  ammo is consumed by the shot, not by this, but this should verify ammo is available
	Template.AbilityCosts.AddItem(AmmoCost);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.bFreeCost = true;           //  ReserveActionPoints effect will take all action points away
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);
	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);
	
	RequiredEffects = new class'X2Condition_UnitEffects';
	RequiredEffects.AddRequireEffect(default.SetUpEffectName, 'AA_Lucu_Sniper_UnitIsNotSetUp');
	Template.AbilityShooterConditions.AddItem(RequiredEffects);

	ReserveActionPointsEffect = new class'X2Effect_ReserveOverwatchPoints';
	Template.AddTargetEffect(ReserveActionPointsEffect);

	CoveringFireEffect = new class'X2Effect_CoveringFire';
	CoveringFireEffect.AbilityToActivate = 'LongWatchShot'; // Changing covering fire to use squadsight
	CoveringFireEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	CoveringFireCondition = new class'X2Condition_AbilityProperty';
	CoveringFireCondition.OwnerHasSoldierAbilities.AddItem('CoveringFire');
	CoveringFireEffect.TargetConditions.AddItem(CoveringFireCondition);
	Template.AddTargetEffect(CoveringFireEffect);

	ConcealedCondition = new class'X2Condition_UnitProperty';
	ConcealedCondition.ExcludeFriendlyToSource = false;
	ConcealedCondition.IsConcealed = true;
	UnitValueEffect = new class'X2Effect_SetUnitValue';
	UnitValueEffect.UnitName = class'X2Ability_DefaultAbilitySet'.default.ConcealedOverwatchTurn;
	UnitValueEffect.CleanupType = eCleanup_BeginTurn;
	UnitValueEffect.NewValueToSet = 1;
	UnitValueEffect.TargetConditions.AddItem(ConcealedCondition);
	Template.AddTargetEffect(UnitValueEffect);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_ActionPoints');
	Template.HideErrors.AddItem('AA_Lucu_Sniper_UnitIsNotSetUp');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_long_watch";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.OVERWATCH_PRIORITY;
	Template.bHideOnClassUnlock = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityConfirmSound = "Unreal2DSounds_OverWatch";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_DefaultAbilitySet'.static.OverwatchAbility_BuildVisualization;
	Template.CinescriptCameraType = "Overwatch";

	Template.Hostility = eHostility_Defensive;

	Template.DefaultKeyBinding = class'UIUtilities_Input'.const.FXS_KEY_Y;
	Template.bNoConfirmationWithHotKey = true;

	return Template;	
}


//---------------------------------------------------------------------------------------------------
// Pistol Overwatch
//---------------------------------------------------------------------------------------------------

static function X2AbilityTemplate PistolOverwatch()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ReserveActionPoints      ReserveActionPointsEffect;
	local array<name>                       SkipExclusions;
	local X2Effect_CoveringFire             CoveringFireEffect;
	local X2Condition_AbilityProperty       CoveringFireCondition;
	local X2Condition_UnitProperty          ConcealedCondition;
	local X2Effect_SetUnitValue             UnitValueEffect;
	local X2Condition_UnitEffects           SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Sniper_PistolOverwatch');
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bConsumeAllPoints = true;   //  this will guarantee the unit has at least 1 action point
	ActionPointCost.bFreeCost = true;           //  ReserveActionPoints effect will take all action points away
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);
	
	ReserveActionPointsEffect = new class'X2Effect_ReserveOverwatchPoints';
	Template.AddTargetEffect(ReserveActionPointsEffect);

	CoveringFireEffect = new class'X2Effect_CoveringFire';
	CoveringFireEffect.AbilityToActivate = 'PistolOverwatchShot';
	CoveringFireEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	CoveringFireCondition = new class'X2Condition_AbilityProperty';
	CoveringFireCondition.OwnerHasSoldierAbilities.AddItem('CoveringFire');
	CoveringFireEffect.TargetConditions.AddItem(CoveringFireCondition);
	Template.AddTargetEffect(CoveringFireEffect);

	ConcealedCondition = new class'X2Condition_UnitProperty';
	ConcealedCondition.ExcludeFriendlyToSource = false;
	ConcealedCondition.IsConcealed = true;
	UnitValueEffect = new class'X2Effect_SetUnitValue';
	UnitValueEffect.UnitName = class'X2Ability_DefaultAbilitySet'.default.ConcealedOverwatchTurn;
	UnitValueEffect.CleanupType = eCleanup_BeginTurn;
	UnitValueEffect.NewValueToSet = 1;
	UnitValueEffect.TargetConditions.AddItem(ConcealedCondition);
	Template.AddTargetEffect(UnitValueEffect);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_pistoloverwatch";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.PISTOL_OVERWATCH_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityConfirmSound = "Unreal2DSounds_OverWatch";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_DefaultAbilitySet'.static.OverwatchAbility_BuildVisualization;
	Template.CinescriptCameraType = "Overwatch";

	Template.Hostility = eHostility_Defensive;
	
	Template.OverrideAbilities.AddItem('PistolOverwatch');

	Template.DefaultKeyBinding = class'UIUtilities_Input'.const.FXS_KEY_Y;
	Template.bNoConfirmationWithHotKey = true;

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Set Up
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate SetUp()
{
	local X2AbilityTemplate									Template;
	local X2AbilityCost_Lucu_Sniper_ReplaceActionPoints		ActionPointCost;
	local X2Condition_UnitEffects							ExcludeEffects;
	local X2Effect_Lucu_Sniper_SetUp						SetUpEffect;
	local X2Effect_Persistent								RelocationEffect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Sniper_SetUp');
	
	// Icon Properties
	Template.IconImage = "img:///UILibrary_Lucu_Sniper_Icons.UIPerk_setup";
	Template.ShotHUDPriority = SNIPER_TRAINING_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	ActionPointCost = new class'X2AbilityCost_Lucu_Sniper_ReplaceActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.ReplacementType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	ExcludeEffects = new class'X2Condition_UnitEffects';
	ExcludeEffects.AddExcludeEffect(default.SetUpEffectName, 'AA_Lucu_Sniper_UnitIsSetUp');
	Template.AbilityShooterConditions.AddItem(ExcludeEffects);

	SetUpEffect = new class'X2Effect_Lucu_Sniper_SetUp';
	SetUpEffect.EffectName = default.SetUpEffectName;
	SetUpEffect.DuplicateResponse = eDupe_Ignore;
	SetUpEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, default.SetUpFriendlyDesc, Template.IconImage,,,Template.AbilitySourceName);
	SetUpEffect.BuildPersistentEffect(1, true,,, eGameRule_PlayerTurnBegin);
	Template.AddTargetEffect(SetUpEffect);
	
	RelocationEffect = new class'X2Effect_Persistent';
	RelocationEffect.EffectName = default.RelocationActiveEffectName;
	RelocationEffect.BuildPersistentEffect(1,,,, eGameRule_PlayerTurnEnd);
	RelocationEffect.SetDisplayInfo(ePerkBuff_Bonus, default.RelocationFriendlyName, default.RelocationFriendlyDesc, Template.IconImage,,,Template.AbilitySourceName);
	RelocationEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(RelocationEffect);
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.Hostility = eHostility_Defensive;
	Template.bDisplayInUITooltip = false;
	Template.bLimitTargetIcons = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.ActivationSpeech = 'CombatStim';
	
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;
	Template.CustomSelfFireAnim = 'FF_FireMedkitSelf';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	
	Template.bCrossClassEligible = true;

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Zero In
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate ZeroIn()
{
	local X2AbilityTemplate             Template;
	local X2Effect_Persistent           PersistentEffect;
	local X2Effect_Lucu_Sniper_ZeroIn	StatChangeEffect;
	local X2Condition_UnitValue         ValueCondition;
	local X2Condition_PlayerTurns       TurnsCondition;
	
	`LOG("Lucubration Sniper Class: Zero In aim bonus=" @ string(default.ZeroInAimBonus));
	`LOG("Lucubration Sniper Class: Zero In crit bonus=" @ string(default.ZeroInCritBonus));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Sniper_ZeroIn');
	
	Template.IconImage = "img:///UILibrary_Lucu_Sniper_Icons.UIPerk_zeroin";
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	// This effect stays on the unit indefinitely
	PersistentEffect = new class'X2Effect_Persistent';
	PersistentEffect.EffectName = 'Lucu_Sniper_ZeroInPassive';
	PersistentEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnBegin);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true,,Template.AbilitySourceName);

	// Each turn this effect is applied
	StatChangeEffect = new class'X2Effect_Lucu_Sniper_ZeroIn';
	StatChangeEffect.EffectName = 'Lucu_Sniper_ZeroIn';
	StatChangeEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	StatChangeEffect.AddPersistentStatChange(eStat_Offense, default.ZeroInAimBonus);
	StatChangeEffect.AddPersistentStatChange(eStat_CritChance, default.ZeroInCritBonus);
	StatChangeEffect.DuplicateResponse = eDupe_Refresh;
	StatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, default.ZeroInFriendlyDesc, Template.IconImage, true);

	// This condition check guarantees the unit did not move last turn before allowing the bonus to be applied
	ValueCondition = new class'X2Condition_UnitValue';
	ValueCondition.AddCheckValue('MovesLastTurn', 0, eCheck_Exact);
	StatChangeEffect.TargetConditions.AddItem(ValueCondition);
	// This condition guarantees the player has started more than 1 turn. the first turn of the game does not count for steady hands, as there was no "previous" turn.
	TurnsCondition = new class'X2Condition_PlayerTurns';
	TurnsCondition.NumTurnsCheck.CheckType = eCheck_GreaterThan;
	TurnsCondition.NumTurnsCheck.Value = 1;
	StatChangeEffect.TargetConditions.AddItem(TurnsCondition);

	PersistentEffect.ApplyOnTick.AddItem(StatChangeEffect);
	Template.AddShooterEffect(PersistentEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Low Profile
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate LowProfile()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTargetStyle				TargetStyle;
	local X2AbilityTrigger					Trigger;
	local X2Effect_LowProfile				LowProfileEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Sniper_LowProfile');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Lucu_Sniper_Icons.UIPerk_lowprofile";

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	LowProfileEffect = new class'X2Effect_Lucu_Sniper_LowProfile';
	LowProfileEffect.EffectName = 'Lucu_Sniper_LowProfile';
	LowProfileEffect.BuildPersistentEffect(1, true, false);
	LowProfileEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	LowProfileEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(LowProfileEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	
	Template.bCrossClassEligible = true;
	
	return Template;
}


//---------------------------------------------------------------------------------------------------
// Precision Shot
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate PrecisionShot()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2Condition_Visibility            TargetVisibilityCondition;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local int								i;
	
	`LOG("Lucubration Sniper Class: Precision Shot cooldown=" @ string(default.PrecisionShotCooldown));
	`LOG("Lucubration Sniper Class: Precision Shot crit bonus=" @ string(default.PrecisionShotCritBonus));
	for (i = 0; i < default.PrecisionShotDamageBonus.Length; i++)
		`LOG("Lucubration Sniper Class: Precision Shot tech level " @ string(i) @ " damage bonus=" @ string(default.PrecisionShotDamageBonus[i]));

	`CREATE_X2ABILITY_TEMPLATE(Template, default.PrecisionShotAbilityName);
	
	Template.IconImage = "img:///UILibrary_Lucu_Sniper_Icons.UIPerk_precisionshot";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.PrecisionShotCooldown;
	Template.AbilityCooldown = Cooldown;

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.BuiltInCritMod = default.PrecisionShotCritBonus;
	Template.AbilityToHitCalc = ToHitCalc;

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

	Template.bAllowAmmoEffects = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.AdditionalAbilities.AddItem('Lucu_Sniper_PrecisionShotDamage');
	
	Template.bCrossClassEligible = true;
	
	return Template;
}

static function X2AbilityTemplate PrecisionShotDamage()
{
	local X2AbilityTemplate							Template;
	local X2Effect_Lucu_Sniper_PrecisionShotDamage	DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Sniper_PrecisionShotDamage');
	Template.IconImage = "img:///UILibrary_Lucu_Sniper_Icons.UIPerk_precisionshot";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'X2Effect_Lucu_Sniper_PrecisionShotDamage';
	DamageEffect.EffectName = 'Lucu_Sniper_PrecisionShotDamage';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	DamageEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Cover Target
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate CoverTarget()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ReserveActionPoints      ReserveActionPointsEffect;
	local array<name>                       SkipExclusions;
	local X2Condition_Visibility            VisibilityCondition;
	local X2Effect_CoveringFire             CoveringFireEffect;
	local X2Effect_ModifyReactionFire		ModifyReactionFireEffect;
	local X2Condition_UnitProperty          ConcealedCondition;
	local X2Effect_SetUnitValue             UnitValueEffect;
	local X2Effect_Persistent				CoverTargetEffect;
	local X2Condition_UnitEffects           SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Sniper_CoverTarget');
	
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	AmmoCost.bFreeCost = true;                  //  ammo is consumed by the shot, not by this, but this should verify ammo is available
	Template.AbilityCosts.AddItem(AmmoCost);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.bFreeCost = true;           //  ReserveActionPoints effect will take all action points away
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);
	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	ReserveActionPointsEffect = new class'X2Effect_ReserveActionPoints';
	ReserveActionPointsEffect.ReserveType = default.CoverTargetActionPoint;
	Template.AddShooterEffect(ReserveActionPointsEffect);

	// Activates the shot if the target attacks
	CoveringFireEffect = new class'X2Effect_CoveringFire';
	CoveringFireEffect.AbilityToActivate = default.CoverTargetShotAbilityName;
	CoveringFireEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	Template.AddShooterEffect(CoveringFireEffect);

	// Allows crit on the shot
	ModifyReactionFireEffect = new class'X2Effect_ModifyReactionFire';
	ModifyReactionFireEffect.EffectName = default.CoverTargetEffectName;
	ModifyReactionFireEffect.bAllowCrit = true;
	Template.AddShooterEffect(ModifyReactionFireEffect);

	// Removes reaction fire penalties if we fire from concealment
	ConcealedCondition = new class'X2Condition_UnitProperty';
	ConcealedCondition.ExcludeFriendlyToSource = false;
	ConcealedCondition.IsConcealed = true;
	UnitValueEffect = new class'X2Effect_SetUnitValue';
	UnitValueEffect.UnitName = class'X2Ability_DefaultAbilitySet'.default.ConcealedOverwatchTurn;
	UnitValueEffect.CleanupType = eCleanup_BeginTurn;
	UnitValueEffect.NewValueToSet = 1;
	UnitValueEffect.TargetConditions.AddItem(ConcealedCondition);
	Template.AddShooterEffect(UnitValueEffect);

	// Allows the shot at the target
	CoverTargetEffect = new class'X2Effect_Persistent';
	CoverTargetEffect.EffectName = default.CoveredTargetEffectName;
	CoverTargetEffect.BuildPersistentEffect(1, false,,, eGameRule_PlayerTurnBegin);
	CoverTargetEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, default.CoverTargetFriendlyDesc, Template.IconImage,,,Template.AbilitySourceName);
	CoverTargetEffect.bUseSourcePlayerState = true;
	Template.AddTargetEffect(CoverTargetEffect);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_ActionPoints');
	Template.IconImage = "img:///UILibrary_Lucu_Sniper_Icons.UIPerk_covertarget";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.OVERWATCH_PRIORITY - 1;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityConfirmSound = "Unreal2DSounds_OverWatch";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_DefaultAbilitySet'.static.OverwatchAbility_BuildVisualization;
	Template.CinescriptCameraType = "Overwatch";

	Template.Hostility = eHostility_Defensive;

	Template.AdditionalAbilities.AddItem(default.CoverTargetShotAbilityName);
	
	Template.bCrossClassEligible = true;
	
	return Template;	
}


static function X2AbilityTemplate CoverTargetShot()
{
	local X2AbilityTemplate							Template;	
	local X2AbilityCost_Ammo						AmmoCost;
	local X2AbilityCost_ReserveActionPoints			ReserveActionPointCost;
	local X2AbilityToHitCalc_StandardAim			StandardAim;
	local X2AbilityTarget_Single					SingleTarget;
	local X2AbilityTrigger_Event					Trigger;
	local array<name>								SkipExclusions;
	local X2Condition_Visibility					TargetVisibilityCondition;
	local X2Condition_UnitEffectsWithAbilitySource	RequiredEffects;
	local X2Effect_Lucu_Sniper_RemoveEffects		RemoveEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.CoverTargetShotAbilityName);
	
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;	
	Template.AbilityCosts.AddItem(AmmoCost);
	
	ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ReserveActionPointCost.iNumPoints = 1;
	ReserveActionPointCost.AllowedTypes.AddItem(default.CoverTargetActionPoint);
	Template.AbilityCosts.AddItem(ReserveActionPointCost);
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bReactionFire = true;
	Template.AbilityToHitCalc = StandardAim;
	Template.AbilityToHitOwnerOnMissCalc = StandardAim;

	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bDisablePeeksOnMovement = true;
	TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(new class'X2Condition_EverVigilant');
	Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());
	
	RequiredEffects = new class'X2Condition_UnitEffectsWithAbilitySource';
	RequiredEffects.AddRequireEffect(default.CoveredTargetEffectName, 'AA_UnitIsImmune');
	Template.AbilityTargetConditions.AddItem(RequiredEffects);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);	

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);
	Template.bAllowAmmoEffects = true;
	
	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
	Template.AbilityTargetStyle = SingleTarget;

	// Trigger on movement - interrupt the move
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_Lucu_Sniper_Icons.UIPerk_covertarget";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.OVERWATCH_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.DisplayTargetHitChance = false;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bAllowFreeFireWeaponUpgrade = false;

	// Remove the Cover Target effect on the shooter (which allows the crit)
	RemoveEffect = new class'X2Effect_Lucu_Sniper_RemoveEffects';
	RemoveEffect.EffectNamesToRemove.AddItem(default.CoverTargetEffectName);
	RemoveEffect.bApplyOnMiss = true;
	RemoveEffect.bCheckTarget = true;
	Template.AddShooterEffect(RemoveEffect);

	// Remove the Cover Target effect on the target (which allows the shot)
	RemoveEffect = new class'X2Effect_Lucu_Sniper_RemoveEffects';
	RemoveEffect.EffectNamesToRemove.AddItem(default.CoveredTargetEffectName);
	RemoveEffect.bApplyOnMiss = true;
	RemoveEffect.bCheckSource = true;
	Template.AddTargetEffect(RemoveEffect);

	//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	// Damage Effect
	//
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	
	return Template;	
}


//---------------------------------------------------------------------------------------------------
// Target Leading
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate TargetLeading()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle					TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_Lucu_Sniper_TargetLeading	TargetLeadingEffect;

	`LOG("Lucubration Sniper Class: Target Leading aim bonus=" @ string(default.TargetLeadingAimBonus));
	`LOG("Lucubration Sniper Class: Target Leading graze penalty=" @ string(default.TargetLeadingGrazePenalty));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Sniper_TargetLeading');

	Template.IconImage = "img:///UILibrary_Lucu_Sniper_Icons.UIPerk_targetleading";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	TargetLeadingEffect = new class'X2Effect_Lucu_Sniper_TargetLeading';
	TargetLeadingEffect.EffectName = 'Lucu_Sniper_TargetLeading';
	TargetLeadingEffect.ReactionModifier = default.TargetLeadingAimBonus;
	TargetLeadingEffect.AddEffectHitModifier(eHit_Graze, default.TargetLeadingGrazePenalty, Template.LocFriendlyName);
	TargetLeadingEffect.BuildPersistentEffect(1, true, true, true);
	TargetLeadingEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	TargetLeadingEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(TargetLeadingEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Hide
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate Hide()
{
	local X2AbilityTemplate							Template;
	local X2AbilityTargetStyle						TargetStyle;
	local X2AbilityTrigger							Trigger;
	local X2Effect_Lucu_Sniper_Hide					HideEffect;

	`LOG("Lucubration Sniper Class: Hide crit bonus=" @ string(default.HideCritBonus));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Sniper_Hide');

	Template.IconImage = "img:///UILibrary_Lucu_Sniper_Icons.UIPerk_hide";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	HideEffect = new class'X2Effect_Lucu_Sniper_Hide';
	HideEffect.EffectName = 'Lucu_Sniper_Hide';
	HideEffect.StealthCritBonus = default.HideCritBonus;
	HideEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnEnd);
	HideEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	HideEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(HideEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	
	Template.AdditionalAbilities.AddItem('Lucu_Sniper_HideStealth');
	
	return Template;
}


//---------------------------------------------------------------------------------------------------
// Hide (Stealth)
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate HideStealth()
{
	local X2AbilityTemplate						Template;
	local X2Condition_UnitEffects				RequiredEffects;
	local X2Condition_UnitValue					ValueCondition;
	local X2Effect_Lucu_Sniper_HideStealth		StealthEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Sniper_HideStealth');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Lucu_Sniper_Icons.UIPerk_hide";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityCosts.AddItem(default.FreeActionCost);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityShooterConditions.AddItem(new class'X2Condition_Stealth');
	
	RequiredEffects = new class'X2Condition_UnitEffects';
	RequiredEffects.AddRequireEffect(default.SetUpEffectName, 'AA_Lucu_Sniper_UnitIsNotSetUp');
	Template.AbilityShooterConditions.AddItem(RequiredEffects);

	ValueCondition = new class'X2Condition_UnitValue';
	ValueCondition.AddCheckValue(default.CanHideName, 1, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(ValueCondition);

	StealthEffect = new class'X2Effect_Lucu_Sniper_HideStealth';
	StealthEffect.EffectName = 'Lucu_Sniper_HideStealth';
	StealthEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnEnd);
	StealthEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
	StealthEffect.bRemoveWhenTargetConcealmentBroken = true;
	StealthEffect.DuplicateResponse = eDupe_Refresh;
	Template.AddTargetEffect(StealthEffect);

	Template.AddTargetEffect(class'X2Effect_Spotted'.static.CreateUnspottedEffect());

	Template.ActivationSpeech = 'ActivateConcealment';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Follow-Up
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate FollowUp()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTargetStyle				TargetStyle;
	local X2AbilityTrigger					Trigger;
	local X2Effect_Lucu_Sniper_FollowUp		FollowUpEffect;

	`LOG("Lucubration Sniper Class: Follow-Up grants=" @ string(default.FollowUpGrants));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Sniper_FollowUp');

	Template.IconImage = "img:///UILibrary_Lucu_Sniper_Icons.UIPerk_followupshot";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	FollowUpEffect = new class'X2Effect_Lucu_Sniper_FollowUp';
	FollowUpEffect.EffectName = 'Lucu_Sniper_FollowUp';
	FollowUpEffect.Grants = default.FollowUpGrants;
	FollowUpEffect.BuildPersistentEffect(1, true, true, true);
	FollowUpEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	FollowUpEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(FollowUpEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	Template.AdditionalAbilities.AddItem(default.FollowUpShotAbilityName);

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Follow-Up Shot
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate FollowUpShot()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2AbilityCost_Ammo					AmmoCost;
	local X2Condition_Visibility				TargetVisibilityCondition;
	local array<name>							SkipExclusions;
	local X2Condition_UnitEffects				RequiredEffects;
	local X2Effect_Persistent					FollowUpTargetEffect;
	local X2Effect_Lucu_Sniper_RemoveEffects	RemoveEffect;
	local X2Effect_Knockback					KnockbackEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.FollowUpShotAbilityName);
	
	// Icon Properties
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_snipershot";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY;
	Template.DisplayTargetHitChance = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.AbilitySourceName = 'eAbilitySource_Standard';                                       // color of the icon
	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.bHideOnClassUnlock = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	
	// *** VALIDITY CHECKS *** //
	// Status condtions that do *not* prohibit this action.
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// *** TARGETING PARAMETERS *** //
	// Can only shoot visible enemies
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Action Point
	ActionPointCost = new class 'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.AllowedTypes.Length = 0;
	ActionPointCost.AllowedTypes.AddItem(default.FollowUpActionPoint);
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true;

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = true;                                            // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects
	
	// Require the Follow-Up Target effect on the target
	RequiredEffects = new class'X2Condition_UnitEffects';
	RequiredEffects.AddRequireEffect('Lucu_Sniper_FollowUpTarget', 'AA_UnitIsImmune');
	Template.AbilityTargetConditions.AddItem(RequiredEffects);

	// Apply the Follow-Up Target effect to the target. This is here just because I'm lazy and I don't want to create a new
	// ability just to house this effect. It also amuses me that the engine will apply it and then immediate remove it when
	// the Follow-Up Shot is resolved
	FollowUpTargetEffect = new class'X2Effect_Persistent';
	FollowUpTargetEffect.EffectName = 'Lucu_Sniper_FollowUpTarget';
	FollowUpTargetEffect.BuildPersistentEffect(1,,,, eGameRule_PlayerTurnBegin);
	FollowUpTargetEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, default.FollowUpTargetFriendlyDesc, Template.IconImage,,,Template.AbilitySourceName);
	FollowUpTargetEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(FollowUpTargetEffect);
	
	// Remove the Cover Target effect on the target (which allows the shot)
	RemoveEffect = new class'X2Effect_Lucu_Sniper_RemoveEffects';
	RemoveEffect.EffectNamesToRemove.AddItem('Lucu_Sniper_FollowUpTarget');
	RemoveEffect.bApplyOnMiss = true;
	RemoveEffect.bCheckSource = true;
	Template.AddTargetEffect(RemoveEffect);

	//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	//  Various Soldier ability specific effects - effects check for the ability before applying	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

	// Damage Effect
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

	// Hit Calculation (Different weapons now have different calculations for range)
	Template.AbilityToHitCalc = default.SimpleStandardAim;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;

	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);
	
	Template.OverrideAbilities.AddItem('SniperStandardFire');

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Relocation
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate Relocation()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTargetStyle				TargetStyle;
	local X2AbilityTrigger					Trigger;
	local X2Effect_Lucu_Sniper_Relocation	RelocationEffect;

	`LOG("Lucubration Sniper Class: Relocation grants=" @ string(default.RelocationGrants));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Sniper_Relocation');

	Template.IconImage = "img:///UILibrary_Lucu_Sniper_Icons.UIPerk_relocation";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	RelocationEffect = new class'X2Effect_Lucu_Sniper_Relocation';
	RelocationEffect.EffectName = 'Lucu_Sniper_Relocation';
	RelocationEffect.BuildPersistentEffect(1, true, true, true);
	RelocationEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	RelocationEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(RelocationEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	
	Template.AdditionalAbilities.AddItem(default.RelocationActiveAbilityName);

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Relocation (Active)
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate RelocationActive()
{
	local X2AbilityTemplate				Template;
	local X2AbilityTargetStyle			TargetStyle;
	local X2AbilityTrigger				Trigger;
	local X2Effect_Persistent			Effect;
	local X2Effect_GrantActionPoints	ActionPointEffect;

	`LOG("Lucubration Sniper Class: Relocation grants=" @ string(default.RelocationGrants));

	`CREATE_X2ABILITY_TEMPLATE(Template, default.RelocationActiveAbilityName);

	Template.IconImage = "img:///UILibrary_Lucu_Sniper_Icons.UIPerk_relocation";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_Placeholder';
	Template.AbilityTriggers.AddItem(Trigger);

	Effect = new class'X2Effect_Persistent';
	Effect.EffectName = default.RelocationActiveEffectName;
	Effect.BuildPersistentEffect(1,,,, eGameRule_PlayerTurnEnd);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Effect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(Effect);
	
	ActionPointEffect = new class'X2Effect_GrantActionPoints';
	ActionPointEffect.NumActionPoints = 1;
	ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
	Template.AddTargetEffect(ActionPointEffect);

	Template.bShowActivation = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Sharpshooter
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate Sharpshooter()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle					TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_Lucu_Sniper_Sharpshooter		SharpshooterEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Sniper_Sharpshooter');

	Template.IconImage = "img:///UILibrary_Lucu_Sniper_Icons.UIPerk_sharpshooter";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	SharpshooterEffect = new class'X2Effect_Lucu_Sniper_Sharpshooter';
	SharpshooterEffect.EffectName = 'Lucu_Sniper_Sharpshooter';
	SharpshooterEffect.BuildPersistentEffect(1, true, true, true);
	SharpshooterEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	SharpshooterEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(SharpshooterEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	
	Template.bCrossClassEligible = true;
	
	return Template;
}


//---------------------------------------------------------------------------------------------------
// Sabot Round
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate SabotRound()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage		ShredderDamageEffect;
	local int								i;
	
	`LOG("Lucubration Sniper Class: Sabot Round environmental damage=" @ string(default.SabotRoundEnvironmentalDamage));
	for (i = 0; i < default.SabotRoundArmorPenetration.Length; i++)
		`LOG("Lucubration Sniper Class: Sabot Round tech level " @ string(i) @ " armor penetration=" @ string(default.SabotRoundArmorPenetration[i]));
	for (i = 0; i < default.SabotRoundDamageBonus.Length; i++)
		`LOG("Lucubration Sniper Class: Sabot Round tech level " @ string(i) @ " damage bonus=" @ string(default.SabotRoundDamageBonus[i]));

	`CREATE_X2ABILITY_TEMPLATE(Template, default.SabotRoundAbilityName);
	
	Template.IconImage = "img:///UILibrary_Lucu_Sniper_Icons.UIPerk_sabotround";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_ActionPoints');
	Template.Hostility = eHostility_Offensive;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.TargetingMethod = class'X2TargetingMethod_Lucu_Sniper_SabotRound';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";
	
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTargetStyle_Lucu_Sniper_SabotRound';

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.SabotRoundCooldown;
	Template.AbilityCooldown = Cooldown;

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bMultiTargetOnly = true;
	Template.AbilityToHitCalc = ToHitCalc;

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = default.SabotRoundAmmo;
	Template.AbilityCosts.AddItem(AmmoCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	ShredderDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	ShredderDamageEffect.EnvironmentalDamageAmount = default.SabotRoundEnvironmentalDamage;
	Template.AddTargetEffect(ShredderDamageEffect);
	Template.AddMultiTargetEffect(ShredderDamageEffect);

	Template.bAllowAmmoEffects = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.AdditionalAbilities.AddItem('Lucu_Sniper_SabotRoundDamage');

	Template.bCrossClassEligible = true;
	
	return Template;
}

static function X2AbilityTemplate SabotRoundDamage()
{
	local X2AbilityTemplate							Template;
	local X2Effect_Lucu_Sniper_SabotRoundDamage		DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Sniper_SabotRoundDamage');
	Template.IconImage = "img:///UILibrary_Lucu_Sniper_Icons.UIPerk_sabotround";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'X2Effect_Lucu_Sniper_SabotRoundDamage';
	DamageEffect.EffectName = 'Lucu_Sniper_SabotRoundDamage';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	DamageEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Vital Point Targeting
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate VitalPointTargeting()
{
	local X2AbilityTemplate							Template;
	local X2Effect_Lucu_Sniper_VitalPointTargeting		DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Sniper_VitalPointTargeting');
	Template.IconImage = "img:///UILibrary_Lucu_Sniper_Icons.UIPerk_vitalpointtargeting";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'X2Effect_Lucu_Sniper_VitalPointTargeting';
	DamageEffect.EffectName = 'Lucu_Sniper_VitalPointTargeting';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	DamageEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	
	Template.bCrossClassEligible = true;
	
	return Template;
}


//---------------------------------------------------------------------------------------------------
// In the Zone
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate InTheZone()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle					TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_Lucu_Sniper_InTheZone		InTheZoneEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Sniper_InTheZone');

	Template.IconImage = "img:///UILibrary_Lucu_Sniper_Icons.UIPerk_inthezone";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	InTheZoneEffect = new class'X2Effect_Lucu_Sniper_InTheZone';
	InTheZoneEffect.EffectName = 'Lucu_Sniper_InTheZone';
	InTheZoneEffect.BuildPersistentEffect(1, true, true, true);
	InTheZoneEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	InTheZoneEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(InTheZoneEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	
	Template.bCrossClassEligible = true;
	
	return Template;
}


//---------------------------------------------------------------------------------------------------
// Ballistics Expert
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate BallisticsExpert()
{
	local X2AbilityTemplate						Template;
	local X2Effect_Lucu_Sniper_BallisticsExpert	Effect;
	
	`LOG("Lucubration Sniper Class: Ballistics Expert hit mod root=" @ string(default.BallisticsExpertHitModRoot));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Sniper_BallisticsExpert');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Lucu_Sniper_Icons.UIPerk_ballisticsexpert";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Effect = new class'X2Effect_Lucu_Sniper_BallisticsExpert';
	Effect.EffectName = 'Lucu_Sniper_BallisticsExpert';
	Effect.DuplicateResponse = eDupe_Ignore;
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Effect.HitModRoot = default.BallisticsExpertHitModRoot;
	Template.AddTargetEffect(Effect);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


DefaultProperties
{
	SetUpEffectName="Squadsight"
	PrecisionShotAbilityName="Lucu_Sniper_PrecisionShot"
	CoverTargetActionPoint="lucu_sniper_covertarget"
	CoverTargetEffectName="Lucu_Sniper_CoverTarget"
	CoveredTargetEffectName="Lucu_Sniper_CoveredTarget"
	CoverTargetShotAbilityName="Lucu_Sniper_CoverTargetShot"
	CanHideName="Lucu_Sniper_CanHide"
	FollowUpName="Lucu_Sniper_FollowUp"
	FollowUpActionPoint="lucu_sniper_followup"
	FollowUpShotAbilityName="Lucu_Sniper_FollowUpShot"
	RelocationName="Lucu_Sniper_Relocation"
	RelocationActiveAbilityName="Lucu_Sniper_RelocationActive"
	RelocationActiveEffectName="Lucu_Sniper_RelocationActive"
	SabotRoundAbilityName="Lucu_Sniper_SabotRound"
	SabotRoundSetUpAbilityName="Lucu_Sniper_SabotRound_SetUp"
}
