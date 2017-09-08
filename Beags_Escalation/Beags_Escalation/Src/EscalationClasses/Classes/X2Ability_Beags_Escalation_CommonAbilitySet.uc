class X2Ability_Beags_Escalation_CommonAbilitySet extends X2Ability
	config(Beags_Escalation_Ability);

var config int ExecutionerCritBonus;
var config int ExecutionerHitBonus;
var config int FlushAmmoCost;
var config float FlushDamageMultiplier;
var config int FlushHitBonus;
var config array<int> LightningReflexesHitModifiers;
var config int RapidReactionBonusOverwatchShots;
var config float DangerZoneExplosiveRadiusBonus;
var config float DangerZoneSuppressionRadius;
var config float DangerZoneFlushRadius;
var config int DoubleTapCooldown;
var config array<name> DoubleTapAbilities;

var name LightningReflexesStateName;
var name LightningHandsPistolAbilityName;
var name FlushAbilityName;
var name FlushDamageAbilityName;
var name DangerZoneAbilityName;
var name DangerZoneFlushAbilityName;
var name DoubleTapActionPointName;

// This method is natively called for subclasses of X2DataSet. It'll create and return ability templates for our new class
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.Length = 0;
	Templates.AddItem(SwordSliceNoCharge());
	Templates.AddItem(PistolStandardShot());
	Templates.AddItem(PistolOverwatch());
	Templates.AddItem(Executioner());
	Templates.AddItem(Stealth());
	Templates.AddItem(LightningReflexes());
	Templates.AddItem(Opportunist());
	Templates.AddItem(LightningHandsPistol());
	Templates.AddItem(LightningHandsSword());
	Templates.AddItem(Flush());
	Templates.AddItem(FlushDamage());
	Templates.AddItem(HitAndRun());
	Templates.AddItem(SmokeAndMirrors());
	Templates.AddItem(Reaper());
	Templates.AddItem(RapidReaction());
	Templates.AddItem(ReadyForAnything());
	Templates.AddItem(DangerZone());
	Templates.AddItem(DangerZoneSuppression());
	Templates.AddItem(DangerZoneFlush());
	Templates.AddItem(DoubleTap());

	return Templates;
}


//---------------------------------------------------------------------------------------------------
// Sword Slice (No Charge)
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate SwordSliceNoCharge()
{
	local X2AbilityTemplate               					Template;
	local X2AbilityCost_ActionPoints      					ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee 					StandardMelee;
	local X2AbilityTarget_MovingMelee						MeleeTarget;
	local X2Effect_ApplyWeaponDamage       					WeaponDamageEffect;
	local X2Condition_Beags_Escalation_AbilitySourceWeapon	SwordCondition;
	local array<name>										SkipExclusions;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_SwordSliceNoCharge');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WeaponIncompatible');
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_swordSlash";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;
	
	MeleeTarget = new class'X2AbilityTarget_MovingMelee';
	MeleeTarget.MovementRangeAdjustment = 1;
	Template.AbilityTargetStyle = MeleeTarget;
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Damage Effect
	//
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	
	// Sword Condition
	SwordCondition = new class'X2Condition_Beags_Escalation_AbilitySourceWeapon';
	SwordCondition.MatchWeaponCat = 'sword';
	Template.AbilityShooterConditions.AddItem(SwordCondition);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Pistol Standard Shot
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate PistolStandardShot()
{
	local X2AbilityTemplate									Template;	
	local X2AbilityCost_Ammo								AmmoCost;
	local X2AbilityCost_ActionPoints						ActionPointCost;
	local X2Effect_ApplyWeaponDamage						WeaponDamageEffect;
	local X2Condition_Beags_Escalation_AbilitySourceWeapon	PistolCondition;
	local array<name>										SkipExclusions;
	local X2Effect_Knockback								KnockbackEffect;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_PistolStandardShot');

	// Icon Properties
	Template.bDontDisplayInAbilitySummary = true;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_standardpistol";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_PISTOL_SHOT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WeaponIncompatible');
	Template.HideErrors.AddItem('AA_CannotAfford_AmmoCost');
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.bHideOnClassUnlock = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_QuickdrawActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true; // 	

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = true;                                            // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	
	// Pistol Condition
	PistolCondition = new class'X2Condition_Beags_Escalation_AbilitySourceWeapon';
	PistolCondition.MatchWeaponCat = 'pistol';
	Template.AbilityShooterConditions.AddItem(PistolCondition);

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
	KnockbackEffect.bUseTargetLocation = true;
	Template.AddTargetEffect(KnockbackEffect);
	
	Template.AdditionalAbilities.AddItem('Beags_Escalation_PistolOverwatch');

	return Template;	
}


//---------------------------------------------------------------------------------------------------
// Pistol Overwatch
//---------------------------------------------------------------------------------------------------

static function X2AbilityTemplate PistolOverwatch()
{
	local X2AbilityTemplate									Template;	
	local X2AbilityCost_ActionPoints						ActionPointCost;
	local X2Effect_ReserveActionPoints						ReserveActionPointsEffect;
	local array<name>										SkipExclusions;
	local X2Condition_Beags_Escalation_AbilitySourceWeapon	PistolCondition;
	local X2Effect_CoveringFire								CoveringFireEffect;
	local X2Condition_AbilityProperty						CoveringFireCondition;
	local X2Condition_UnitProperty							ConcealedCondition;
	local X2Effect_SetUnitValue								UnitValueEffect;
	local X2Condition_UnitEffects							SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_PistolOverwatch');
	
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
	
	// Pistol Condition
	PistolCondition = new class'X2Condition_Beags_Escalation_AbilitySourceWeapon';
	PistolCondition.MatchWeaponCat = 'pistol';
	Template.AbilityShooterConditions.AddItem(PistolCondition);

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
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WeaponIncompatible');
	Template.HideErrors.AddItem('AA_CannotAfford_AmmoCost');
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
// Executioner
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate Executioner()
{
	local X2AbilityTemplate								Template;
	local X2AbilityTargetStyle							TargetStyle;
	local X2AbilityTrigger								Trigger;
	local X2Effect_Beags_Escalation_Executioner			ExecutionerEffect;
	
	`LOG("Beags Escalation: Executioner hit bonus=" @ string(default.ExecutionerHitBonus));
	`LOG("Beags Escalation: Executioner crit bonus=" @ string(default.ExecutionerCritBonus));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_Executioner');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_executioner";

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	ExecutionerEffect = new class'X2Effect_Beags_Escalation_Executioner';
	ExecutionerEffect.EffectName = 'Beags_Escalation_Executioner';
	ExecutionerEffect.BuildPersistentEffect(1, true, false);
	ExecutionerEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	ExecutionerEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(ExecutionerEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	Template.bCrossClassEligible = true;

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Concealment
//---------------------------------------------------------------------------------------------------

// Just an empty container that grants both Phantom and Concealment from the vanilla game
static function X2AbilityTemplate Stealth()
{
	local X2AbilityTemplate								Template;
	local X2AbilityTargetStyle							TargetStyle;
	local X2AbilityTrigger								Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_Stealth');
	
	Template.AdditionalAbilities.AddItem('Phantom');
	Template.AdditionalAbilities.AddItem('Stealth');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_phantom";

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	Template.bCrossClassEligible = true;

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Lightning Reflexes
//---------------------------------------------------------------------------------------------------

static function X2AbilityTemplate LightningReflexes()
{
	local X2AbilityTemplate								Template;
	local X2AbilityTargetStyle							TargetStyle;
	local X2AbilityTrigger								Trigger;
	local X2Effect_Beags_Escalation_LightningReflexes	ReflexesEffect;
	local int											i;

	for (i = 0; i < default.LightningReflexesHitModifiers.Length; i++)
		`LOG("Beags Escalation: Lightning Reflexes grants=" @ string(i) @ " hit modifier=" @ string(default.LightningReflexesHitModifiers[i]));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_LightningReflexes');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_lightningreflexes";

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	ReflexesEffect = new class'X2Effect_Beags_Escalation_LightningReflexes';
	ReflexesEffect.EffectName = 'Beags_Escalation_LightningReflexes';
	ReflexesEffect.BuildPersistentEffect(1, true, false,, eGameRule_PlayerTurnBegin);
	ReflexesEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	ReflexesEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(ReflexesEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	Template.bCrossClassEligible = true;

	return Template;
}
	

//---------------------------------------------------------------------------------------------------
// Opportunist
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate Opportunist()
{
	local X2AbilityTemplate							Template;
	local X2Effect_Beags_Escalation_Opportunist		Effect;

	// This is some sort of macro by Firaxis that sets up an ability template with localized text from XComGame.int (and maybe some other stuff?)
	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_Opportunist');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow; // This ability doesn't show up on the action HUD (can't click to activate it)
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_opportunist";

	Template.AbilityToHitCalc = default.DeadEye; // Always hits
	Template.AbilityTargetStyle = default.SelfTarget; // Applies to the unit with the ability
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger); // Basically begins immediately when the unit is spawned with the ability

	Effect = new class'X2Effect_Beags_Escalation_Opportunist';
	Effect.EffectName = 'Beags_Escalation_Opportunist';
	Effect.DuplicateResponse = eDupe_Ignore; // Shouldn't be a case where multiple copies of the passive effect are applied, but if they are ignore the new one
	Effect.BuildPersistentEffect(1, true, false,, eGameRule_PlayerTurnBegin); // Lasts forever, ticks at the start of the turn
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(Effect); // Effects added to the primary target of an ability. In this case, that's our unit

	// Function delegate for setting up a standard XComGameState_Ability object for this ability
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	
	Template.bCrossClassEligible = true;

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Lightning Hands
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate LightningHandsPistol()
{
	local X2AbilityTemplate									Template;
	local X2AbilityCost_Ammo								AmmoCost;
	local X2Effect_ApplyWeaponDamage						WeaponDamageEffect;
	local array<name>										SkipExclusions;
	local X2AbilityCooldown									Cooldown;
	local X2Condition_Beags_Escalation_AbilitySourceWeapon	PistolCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.LightningHandsPistolAbilityName);

	// Icon Properties
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_lightninghands";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WeaponIncompatible');
	Template.HideErrors.AddItem('AA_CannotAfford_AmmoCost');
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 4;
	Template.AbilityCooldown = Cooldown;

	// *** VALIDITY CHECKS *** //
	//  Normal effect restrictions (except disoriented)
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true; // 	

	Template.AbilityCosts.AddItem(default.FreeActionCost);

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);

	// Hit Calculation (Different weapons now have different calculations for range)
	Template.AbilityToHitCalc = default.SimpleStandardAim;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;
	
	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";
	
	// Pistol Condition
	PistolCondition = new class'X2Condition_Beags_Escalation_AbilitySourceWeapon';
	PistolCondition.MatchWeaponCat = 'pistol';
	Template.AbilityShooterConditions.AddItem(PistolCondition);

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	return Template;
}

static function X2AbilityTemplate LightningHandsSword()
{
	local X2AbilityTemplate									Template;
	local X2AbilityToHitCalc_StandardMelee					StandardMelee;
	local X2AbilityTarget_MovingMelee						MeleeTarget;
	local X2Effect_ApplyWeaponDamage						WeaponDamageEffect;
	local array<name>										SkipExclusions;
	local X2AbilityCooldown									Cooldown;
	local X2Condition_Beags_Escalation_AbilitySourceWeapon	SwordCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_LightningHandsSword');
	
	Template.AdditionalAbilities.AddItem(default.LightningHandsPistolAbilityName);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WeaponIncompatible');
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_lightninghands";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 4;
	Template.AbilityCooldown = Cooldown;

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;
	
	MeleeTarget = new class'X2AbilityTarget_MovingMelee';
	MeleeTarget.MovementRangeAdjustment = 1;
	Template.AbilityTargetStyle = MeleeTarget;
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Damage Effect
	//
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	
	// Sword Condition
	SwordCondition = new class'X2Condition_Beags_Escalation_AbilitySourceWeapon';
	SwordCondition.MatchWeaponCat = 'sword';
	Template.AbilityShooterConditions.AddItem(SwordCondition);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Flush
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate Flush()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local array<name>                       SkipExclusions;
	local X2Condition_Visibility			VisibilityCondition;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Effect_GrantActionPoints		ActionPointsEffect;
	local X2Effect_RunBehaviorTree			FlushBehaviorEffect;
	
	`LOG("Beags Escalation: Flush hit bonus=" @ string(default.FlushHitBonus));
	`LOG("Beags Escalation: Flush ammo cost=" @ string(default.FlushAmmoCost));
	`LOG("Beags Escalation: Flush damage multiplier=" @ string(default.FlushDamageMultiplier));

	`CREATE_X2ABILITY_TEMPLATE(Template, default.FlushAbilityName);
	
	Template.AdditionalAbilities.AddItem(default.FlushDamageAbilityName);

	// Icon Properties
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_flush";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.DisplayTargetHitChance = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	//  Normal effect restrictions (except disoriented)
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = default.FlushAmmoCost;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true;

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = true; // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	// Allows this attack to work with the Holo-Targeting and Shredder perks, in case of AWC perkage
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

	// There's some nice stuff built into the standard aim calculations, including a place to apply the aim bonus
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.BuiltInHitMod = default.FlushHitBonus;
	Template.AbilityToHitCalc = StandardAim;
		
	// Targeting Method. There's other ones that let you do grenade spheres, cones, etc. This is the standard, single-target selection
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";

	// Give the enemy a move action point
	ActionPointsEffect = new class'X2Effect_GrantActionPoints';
	ActionPointsEffect.NumActionPoints = 1;
	ActionPointsEffect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
	ActionPointsEffect.bApplyOnMiss = true;
	ActionPointsEffect.TargetConditions.AddItem(new class'X2Condition_Beags_Escalation_InCover');
	Template.AddTargetEffect(ActionPointsEffect);
	
	// Make the enemy scamper
	FlushBehaviorEffect = new class'X2Effect_RunBehaviorTree';
	FlushBehaviorEffect.BehaviorTreeName = 'BeagsEscalationMoveForFlush';
	FlushBehaviorEffect.bApplyOnMiss = true;
	FlushBehaviorEffect.TargetConditions.AddItem(new class'X2Condition_Beags_Escalation_InCover');
	Template.AddTargetEffect(FlushBehaviorEffect);
	
	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	
	Template.bCrossClassEligible = true;

	return Template;	
}

// The damage reduction is a seperate effect because it affects the shooter, not the shooter's target. It's a persistent
// effect that hangs around on the shooter and just modifies the damage for the Staggering Shot ability when it sees it
static function X2AbilityTemplate FlushDamage()
{
	local X2AbilityTemplate										Template;
	local X2Effect_Beags_Escalation_AbilityDamageMultiplier		DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, default.FlushDamageAbilityName);
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_flush";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'X2Effect_Beags_Escalation_AbilityDamageMultiplier';
	DamageEffect.EffectName = 'Beags_Escalation_FlushDamage';
	DamageEffect.DamageMultiplier = default.FlushDamageMultiplier;
	DamageEffect.AbilityNames.AddItem(default.FlushAbilityName);
	DamageEffect.AbilityNames.AddItem(default.DangerZoneFlushAbilityName);
	DamageEffect.BuildPersistentEffect(1, true, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	DamageEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Hit and Run
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate HitAndRun()
{
	local X2AbilityTemplate							Template;
	local X2Effect_Beags_Escalation_HitAndRun		Effect;

	// This is some sort of macro by Firaxis that sets up an ability template with localized text from XComGame.int (and maybe some other stuff?)
	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_HitAndRun');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow; // This ability doesn't show up on the action HUD (can't click to activate it)
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_hitandrun";

	Template.AbilityToHitCalc = default.DeadEye; // Always hits
	Template.AbilityTargetStyle = default.SelfTarget; // Applies to the unit with the ability
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger); // Basically begins immediately when the unit is spawned with the ability

	Effect = new class'X2Effect_Beags_Escalation_HitAndRun';
	Effect.EffectName = 'Beags_Escalation_HitAndRun';
	Effect.DuplicateResponse = eDupe_Ignore; // Shouldn't be a case where multiple copies of the passive effect are applied, but if they are ignore the new one
	Effect.BuildPersistentEffect(1, true, false); // Lasts forever
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(Effect); // Effects added to the primary target of an ability. In this case, that's our unit

	// Function delegate for setting up a standard XComGameState_Ability object for this ability
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	
	Template.bCrossClassEligible = true;

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Smoke and Mirrors
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate SmokeAndMirrors()
{
	local X2AbilityTemplate									Template;
	local X2AbilityTargetStyle								TargetStyle;
	local X2AbilityTrigger									Trigger;
	local X2Effect_Beags_Escalation_BonusItemAmmo			AmmoEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_SmokeAndMirrors');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_smokeandmirrors";

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	// This will tick once during application at the start of the player's turn and increase ammo of the specified items by the specified amounts
	AmmoEffect = new class'X2Effect_Beags_Escalation_BonusItemAmmo';
	AmmoEffect.EffectName = 'Beags_Escalation_SmokeAndMirrors';
	AmmoEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); // Delay this until player turn begin so that any transient item effects are already applied
	AmmoEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	AmmoEffect.DuplicateResponse = eDupe_Allow;
	AmmoEffect.AmmoCount = 1;
	AmmoEffect.ItemTemplateNames.Length = 0;
	AmmoEffect.ItemTemplateNames.AddItem('BattleScanner');
	AmmoEffect.ItemTemplateNames.AddItem('FlashbangGrenade');
	AmmoEffect.ItemTemplateNames.AddItem('SmokeGrenade');
	AmmoEffect.ItemTemplateNames.AddItem('SmokeGrenadeMk2');
	Template.AddTargetEffect(AmmoEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	
	Template.bCrossClassEligible = true;

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Reaper
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate Reaper()
{
	local X2AbilityTemplate						Template;
	local X2Effect_Beags_Escalation_Reaper		Effect;

	// This is some sort of macro by Firaxis that sets up an ability template with localized text from XComGame.int (and maybe some other stuff?)
	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_Reaper');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow; // This ability doesn't show up on the action HUD (can't click to activate it)
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_reaper";

	Template.AbilityToHitCalc = default.DeadEye; // Always hits
	Template.AbilityTargetStyle = default.SelfTarget; // Applies to the unit with the ability
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger); // Basically begins immediately when the unit is spawned with the ability

	Effect = new class'X2Effect_Beags_Escalation_Reaper';
	Effect.EffectName = 'Beags_Escalation_Reaper';
	Effect.DuplicateResponse = eDupe_Ignore; // Shouldn't be a case where multiple copies of the passive effect are applied, but if they are ignore the new one
	Effect.BuildPersistentEffect(1, true, false); // Lasts forever
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(Effect); // Effects added to the primary target of an ability. In this case, that's our unit

	// Function delegate for setting up a standard XComGameState_Ability object for this ability
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	
	Template.bCrossClassEligible = true;

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Rapid Reaction
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate RapidReaction()
{
	local X2AbilityTemplate							Template;
	local X2Effect_Beags_Escalation_RapidReaction	Effect;
	
	`LOG("Beags Escalation: Rapid Reaction bonus Overwatch shots=" @ string(default.RapidReactionBonusOverwatchShots));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_RapidReaction');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_rapidreaction";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Effect = new class'X2Effect_Beags_Escalation_RapidReaction';
	Effect.EffectName = 'RapidReaction';
	Effect.DuplicateResponse = eDupe_Ignore;
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,, Template.AbilitySourceName);
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Ready for Anything
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate ReadyForAnything()
{
	local X2AbilityTemplate								Template;
	local X2Effect_Beags_Escalation_ReadyForAnything	Effect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_ReadyForAnything');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_readyforanything";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Effect = new class'X2Effect_Beags_Escalation_ReadyForAnything';
	Effect.EffectName = 'ReadyForAnything';
	Effect.DuplicateResponse = eDupe_Ignore;
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,, Template.AbilitySourceName);
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Danger Zone
//---------------------------------------------------------------------------------------------------


static function X2DataTemplate DangerZone()
{
	local X2AbilityTemplate		Template;
	local X2Effect_Persistent	PersistentEffect;

	`LOG("Beags Escalation: Danger Zone explosive radius bonus=" @ string(default.DangerZoneExplosiveRadiusBonus));
	
	`CREATE_X2ABILITY_TEMPLATE(Template, default.DangerZoneAbilityName);

	Template.AdditionalAbilities.AddItem('Beags_Escalation_DangerZoneSuppression');
	Template.AdditionalAbilities.AddItem(default.DangerZoneFlushAbilityName);
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_dangerzone";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	PersistentEffect = new class'X2Effect_Persistent';
	PersistentEffect.BuildPersistentEffect(1, true, false);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage,,, Template.AbilitySourceName);
	Template.AddTargetEffect(PersistentEffect);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Danger Zone Suppression
//---------------------------------------------------------------------------------------------------

// Replaces Suppression default ability when the soldier has Danger Zone
static function X2AbilityTemplate DangerZoneSuppression()
{
	local X2AbilityTemplate								Template;
	local X2AbilityCost_ActionPoints					ActionPointCost;
	local X2AbilityCost_Ammo							AmmoCost;
	local X2Effect_ReserveActionPoints					ReserveActionPointsEffect;
	local X2AbilityMultiTarget_Radius					RadiusMultiTarget;
	local X2Condition_UnitProperty						UnitPropertyCondition;
	local X2Condition_Beags_Escalation_UnitHasAbility	SuppressionAbilityCondition;
	local X2Effect_Suppression							SuppressionEffect;
	
	`LOG("Beags Escalation: Danger Zone Suppression radius=" @ string(default.DangerZoneSuppressionRadius));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_DangerZoneSuppression');
	
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_supression";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bConsumeAllPoints = true;   //  this will guarantee the unit has at least 1 action point
	ActionPointCost.bFreeCost = true;           //  ReserveActionPoints effect will take all action points away
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 2;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	Template.AddShooterEffectExclusions();
	
	ReserveActionPointsEffect = new class'X2Effect_ReserveActionPoints';
	ReserveActionPointsEffect.ReserveType = 'Suppression';
	Template.AddShooterEffect(ReserveActionPointsEffect);
	
	Template.AbilityToHitCalc = default.DeadEye;	
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Cursor';
	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = `UNITSTOMETERS(default.DangerZoneSuppressionRadius);
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Template.TargetingMethod = class'X2TargetingMethod_Beags_Escalation_Radius';

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
	SuppressionAbilityCondition = new class'X2Condition_Beags_Escalation_UnitHasAbility';
	SuppressionAbilityCondition.MatchAbilityTemplateName = 'Suppression';
	Template.AbilityShooterConditions.AddItem(SuppressionAbilityCondition);
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	
	SuppressionEffect = new class'X2Effect_Suppression';
	SuppressionEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	SuppressionEffect.bRemoveWhenTargetDies = true;
	SuppressionEffect.bRemoveWhenSourceDamaged = true;
	SuppressionEffect.bBringRemoveVisualizationForward = true;
	SuppressionEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, class'X2Ability_GrenadierAbilitySet'.default.SuppressionTargetEffectDesc, Template.IconImage);
	SuppressionEffect.SetSourceDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, class'X2Ability_GrenadierAbilitySet'.default.SuppressionSourceEffectDesc, Template.IconImage);
	Template.AddMultiTargetEffect(SuppressionEffect);
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.bAllowAmmoEffects = true;

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_AbilityUnavailable');
	Template.bDisplayInUITooltip = false;
	Template.AdditionalAbilities.AddItem('SuppressionShot');
	Template.bIsASuppressionEffect = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	
	Template.AssociatedPassives.AddItem('HoloTargeting');
	
	Template.CinescriptCameraType = "StandardSuppression";
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = DangerZoneSuppressionBuildVisualization;
	Template.BuildAppliedVisualizationSyncFn = class'X2Ability_GrenadierAbilitySet'.static.SuppressionBuildVisualizationSync;
	
	Template.OverrideAbilities.AddItem('Suppression');

	return Template;
}

simulated function DangerZoneSuppressionBuildVisualization(XComGameState VisualizeGameState, out array<VisualizationTrack> OutVisualizationTracks)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          InteractingUnitRef;

	local VisualizationTrack        EmptyTrack;
	local VisualizationTrack        BuildTrack;

	local int i;
	local XComGameState_Ability         Ability;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;

	local XComUnitPawn					UnitPawn;
	local XComWeapon					Weapon;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.TrackActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	// Check the actor's pawn and weapon, see if they can play the suppression effect
	UnitPawn = XGUnit(BuildTrack.TrackActor).GetPawn();
	Weapon = XComWeapon(UnitPawn.Weapon);
	if (Weapon != None &&
		!UnitPawn.GetAnimTreeController().CanPlayAnimation(Weapon.WeaponSuppressionFireAnimSequenceName) &&
		!UnitPawn.GetAnimTreeController().CanPlayAnimation(class'XComWeapon'.default.WeaponSuppressionFireAnimSequenceName))
	{
		// The unit can't play their weapon's suppression effect. Replace it with the normal fire effect so at least they'll look like they're shooting
		Weapon.WeaponSuppressionFireAnimSequenceName = Weapon.WeaponFireAnimSequenceName;
	}
	
	class'X2Action_ExitCover'.static.AddToVisualizationTrack(BuildTrack, Context);
	class'X2Action_StartSuppression'.static.AddToVisualizationTrack(BuildTrack, Context);
	OutVisualizationTracks.AddItem(BuildTrack);
	//****************************************************************************************
	//Configure the visualization track for the targets
	for (i = 0; i < Context.InputContext.MultiTargets.Length; i++)
	{
		// Fake it out by assigning the first multi-target as the primary target
		if (Context.InputContext.PrimaryTarget.ObjectID == 0)
			Context.InputContext.PrimaryTarget = Context.InputContext.MultiTargets[i];

		InteractingUnitRef = Context.InputContext.MultiTargets[i];
		Ability = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));
		BuildTrack = EmptyTrack;
		BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
		BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
		BuildTrack.TrackActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTrack(BuildTrack, Context));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Ability.GetMyTemplate().LocFlyOverText, '', eColor_Bad);
		if (XComGameState_Unit(BuildTrack.StateObject_OldState).ReserveActionPoints.Length != 0 && XComGameState_Unit(BuildTrack.StateObject_NewState).ReserveActionPoints.Length == 0)
		{
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTrack(BuildTrack, Context));
			SoundAndFlyOver.SetSoundAndFlyOverParameters(none, class'XLocalizedData'.default.OverwatchRemovedMsg, '', eColor_Bad);
		}
		OutVisualizationTracks.AddItem(BuildTrack);
	}
}


//---------------------------------------------------------------------------------------------------
// Danger Zone Flush
//---------------------------------------------------------------------------------------------------

// Replaces Flush default ability when the soldier has Danger Zone
static function X2AbilityTemplate DangerZoneFlush()
{
	local X2AbilityTemplate								Template;
	local X2AbilityCost_Ammo							AmmoCost;
	local X2AbilityCost_ActionPoints					ActionPointCost;
	local array<name>									SkipExclusions;
	local X2AbilityToHitCalc_StandardAim				StandardAim;
	local X2AbilityMultiTarget_Radius					RadiusMultiTarget;
	local X2Condition_Beags_Escalation_UnitHasAbility	FlushAbilityCondition;
	local X2Effect_GrantActionPoints					ActionPointsEffect;
	local X2Effect_RunBehaviorTree						FlushBehaviorEffect;
	
	`LOG("Beags Escalation: Danger Zone Flush radius=" @ string(default.DangerZoneFlushRadius));

	`CREATE_X2ABILITY_TEMPLATE(Template, default.DangerZoneFlushAbilityName);
	
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_flush";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_AbilityUnavailable');
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.DisplayTargetHitChance = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	//  Normal effect restrictions (except disoriented)
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	Template.AbilityMultiTargetConditions.AddItem(default.GameplayVisibilityCondition);
	Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileTargetProperty);
	FlushAbilityCondition = new class'X2Condition_Beags_Escalation_UnitHasAbility';
	FlushAbilityCondition.MatchAbilityTemplateName = default.FlushAbilityName;
	Template.AbilityShooterConditions.AddItem(FlushAbilityCondition);
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Cursor';

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = default.FlushAmmoCost;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true;

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = true; // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.BuiltInHitMod = default.FlushHitBonus;
	Template.AbilityToHitCalc = StandardAim;
		
	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = `UNITSTOMETERS(default.DangerZoneFlushRadius);
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;
	Template.TargetingMethod = class'X2TargetingMethod_Beags_Escalation_Radius';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";
	
	Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

	// Give the enemy a move action point
	ActionPointsEffect = new class'X2Effect_GrantActionPoints';
	ActionPointsEffect.NumActionPoints = 1;
	ActionPointsEffect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
	ActionPointsEffect.bApplyOnMiss = true;
	ActionPointsEffect.TargetConditions.AddItem(new class'X2Condition_Beags_Escalation_InCover');
	Template.AddMultiTargetEffect(ActionPointsEffect);
	
	// Make the enemy scamper
	FlushBehaviorEffect = new class'X2Effect_RunBehaviorTree';
	FlushBehaviorEffect.BehaviorTreeName = 'BeagsEscalationMoveForFlush';
	FlushBehaviorEffect.bApplyOnMiss = true;
	FlushBehaviorEffect.TargetConditions.AddItem(new class'X2Condition_Beags_Escalation_InCover');
	Template.AddMultiTargetEffect(FlushBehaviorEffect);
	
	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	
	Template.OverrideAbilities.AddItem(default.FlushAbilityName);

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Double Tap
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate DoubleTap()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2AbilityCooldown						Cooldown;
	local X2Effect_Beags_Escalation_DoubleTap	DoubleTapEffect;
	local X2Condition_UnitValue					MoveCondition;
	
	`LOG("Beags Escalation: Double Tap cooldown=" @ string(default.DoubleTapCooldown));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_DoubleTap');
	
	// Icon Properties
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_doubletap";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	MoveCondition = new class'X2Condition_UnitValue';
	MoveCondition.AddCheckValue('MovesThisTurn', 0, eCheck_Exact,,, 'AA_AbilityUnavailable');
	Template.AbilityShooterConditions.AddItem(MoveCondition);
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.DoubleTapCooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	
	DoubleTapEffect = new class'X2Effect_Beags_Escalation_DoubleTap';
	DoubleTapEffect.BuildPersistentEffect(1,,,, eGameRule_PlayerTurnEnd);
	DoubleTapEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage,,, Template.AbilitySourceName);
	Template.AddTargetEffect(DoubleTapEffect);

	Template.Hostility = eHostility_Defensive;
	Template.bDisplayInUITooltip = false;
	Template.bLimitTargetIcons = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	
	Template.bCrossClassEligible = true;

	return Template;
}

// Not used, but maybe useful to someone
static function array<X2AbilityTemplate> GetDoubleTapAbilities()
{
	local X2AbilityTemplateManager TemplateManager;
	local X2AbilityTemplate Template;
	local X2DataTemplate DataTemplate;
	local array<X2AbilityTemplate> DoubleTapAbilityTemplates;

	TemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	// We're just going to explicitly name the abilities that double-tap applies to
	foreach TemplateManager.IterateTemplates(DataTemplate, none)
	{
		Template = X2AbilityTemplate(DataTemplate);
		if (Template != none && default.DoubleTapAbilities.Find(Template.DataName) != INDEX_NONE)
			DoubleTapAbilityTemplates.AddItem(Template);
	}

	return DoubleTapAbilityTemplates;
}

static function bool IsDoubleTapAbility(name templateName)
{
	return (default.DoubleTapAbilities.Find(templateName) != INDEX_NONE);
}


DefaultProperties
{
	LightningReflexesStateName="LightningReflexesGrants"
	LightningHandsPistolAbilityName="Beags_Escalation_LightningHandsPistol"
	FlushAbilityName="Beags_Escalation_Flush"
	FlushDamageAbilityName="Beags_Escalation_FlushDamage"
	DangerZoneAbilityName="Beags_Escalation_DangerZone"
	DangerZoneFlushAbilityName="Beags_Escalation_DangerZoneFlush"
	DoubleTapActionPointName="Beags_Escalation_DoubleTap"
}