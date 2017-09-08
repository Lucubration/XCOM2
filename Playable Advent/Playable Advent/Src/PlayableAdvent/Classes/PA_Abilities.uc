class PA_Abilities extends X2Ability config(PlayableAdvent);

var config int ViperMoltCooldown;
var config int PoisonSpitHeight;
var config int BasicSpitDamage;
var config int BasicSpitMobility;
var config int BasicSpitAim;
var config int EnhancedSpitDamage;
var config int EnhancedSpitMobility;
var config int EnhancedSpitAim;
var config bool EnhancedSpitDisorients;
var config int PA_MecMegaMissileRadius;
var config int PA_MecDrawFireDuration;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	`log ("davea debug ability-create-templates-enter");
	Templates.AddItem(PA_PoisonSpit());
	Templates.AddItem(PA_EnhancedSpit());
	Templates.AddItem(PA_ViperMolt());
	Templates.AddItem(PA_ViperBlendIn());
	Templates.AddItem(PA_ViperSlither());
	Templates.AddItem(PA_MecJiffyLube());
	Templates.AddItem(PA_MecDamageControl());
	// Templates.AddItem(PA_ChryssalidSlash());
	Templates.AddItem(PA_MecRegenerate());
	Templates.AddItem(PA_MecDrawFire());
	Templates.AddItem(PA_MecMegaMissiles());
	`log ("davea debug ability-create-templates-done");
	return Templates;
}

//------------------------------------------------------------------------------
// Poison Spit
//------------------------------------------------------------------------------

static function X2AbilityTemplate PA_PoisonSpit()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Cylinder     CylinderMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local X2AbilityCooldown_LocalAndGlobal  Cooldown;
	local X2Effect_PersistentStatChange	DisorientedEffect;
	local X2Condition_AbilityProperty 	DisorientSpitCondition;
	local X2Effect_PersistentStatChange	EnhancedEffect;
	local X2Condition_AbilityProperty 	EnhancedSpitCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'PA_PoisonSpit');
	Template.bDontDisplayInAbilitySummary = false;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_poisonspit";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityToHitCalc = default.DeadEye;
	
	Template.AddMultiTargetEffect(CreatePA_PoisonStatusEffect());

	if (default.EnhancedSpitDisorients) {
		DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
		DisorientSpitCondition = new class'X2Condition_AbilityProperty';
		DisorientSpitCondition.OwnerHasSoldierAbilities.AddItem('PA_EnhancedSpit');
		DisorientedEffect.TargetConditions.AddItem(DisorientSpitCondition);
		Template.AddMultiTargetEffect(DisorientedEffect);
	}

// var config bool EnhancedSpitAcid; causes hang
//	local X2Effect_Burning             	AcidEffect;
//	local X2Condition_AbilityProperty 	AcidSpitCondition;
//	if (default.EnhancedSpitAcid) {
//		AcidEffect = class'X2StatusEffects'.static.CreateAcidBurningStatusEffect(2,1);
//		AcidSpitCondition = new class'X2Condition_AbilityProperty';
//		AcidSpitCondition.OwnerHasSoldierAbilities.AddItem('PA_EnhancedSpit');
//		AcidEffect.TargetConditions.AddItem(AcidSpitCondition);
//		Template.AddMultiTargetEffect(AcidEffect);
//		Template.AddMultiTargetEffect(new class'X2Effect_ApplyAcidToWorld');
//	}

	EnhancedEffect = CreateEnhancedStatusEffect();
	EnhancedSpitCondition = new class'X2Condition_AbilityProperty';
	EnhancedSpitCondition.OwnerHasSoldierAbilities.AddItem('PA_EnhancedSpit');
	EnhancedEffect.TargetConditions.AddItem(EnhancedSpitCondition);
	Template.AddMultiTargetEffect(EnhancedEffect);

	// PA this only applies the normal (tiny) poison effect, not mine
	Template.AddMultiTargetEffect(new class'X2Effect_ApplyPoisonToWorld');

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	CylinderMultiTarget = new class'X2AbilityMultiTarget_Cylinder';
	CylinderMultiTarget.bUseWeaponRadius = true;
	CylinderMultiTarget.fTargetHeight = default.PoisonSpitHeight;
	CylinderMultiTarget.bUseOnlyGroundTiles = true;
	Template.AbilityMultiTargetStyle = CylinderMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition); 
	Template.AddShooterEffectExclusions();

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_viper_poisonspit";
	Template.bUseAmmoAsChargesForHUD = false;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Viper_PoisonSpit";

	Template.TargetingMethod = class'X2TargetingMethod_ViperSpit';

	// Cooldown on the ability
	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = 3;
	Cooldown.NumGlobalTurns = 1;
	Template.AbilityCooldown = Cooldown;

	// This action is considered 'hostile' and can be interrupted!
	Template.Hostility = eHostility_Offensive;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	return Template;
}

// Copied from X2StatusEffects::CreatePoisonedStatusEffect() and customized
static function X2Effect_PersistentStatChange CreatePA_PoisonStatusEffect()
{
	local X2Effect_PersistentStatChange     PersistentStatChangeEffect;
	local X2Effect_ApplyWeaponDamage              DamageEffect;
	local X2Condition_UnitProperty UnitPropCondition;

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.EffectName = class'X2StatusEffects'.default.PoisonedName;
	PersistentStatChangeEffect.DuplicateResponse = eDupe_Refresh;
	PersistentStatChangeEffect.BuildPersistentEffect(class'X2StatusEffects'.default.POISONED_TURNS,, false,,eGameRule_PlayerTurnBegin);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.PoisonedFriendlyName, class'X2StatusEffects'.default.PoisonedFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_poisoned");
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.BasicSpitMobility);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Offense, default.BasicSpitAim);
	PersistentStatChangeEffect.iInitialShedChance = class'X2StatusEffects'.default.POISONED_INITIAL_SHED;
	PersistentStatChangeEffect.iPerTurnShedChance = 10; // class'X2StatusEffects'.default.POISONED_PER_TURN_SHED;
	PersistentStatChangeEffect.VisualizationFn = class'X2StatusEffects'.static.PoisonedVisualization;
	PersistentStatChangeEffect.EffectTickedVisualizationFn = class'X2StatusEffects'.static.PoisonedVisualizationTicked;
	PersistentStatChangeEffect.EffectRemovedVisualizationFn = class'X2StatusEffects'.static.PoisonedVisualizationRemoved;
	PersistentStatChangeEffect.DamageTypes.AddItem('Poison');
	PersistentStatChangeEffect.bRemoveWhenTargetDies = true;

	if (class'X2StatusEffects'.default.PoisonEnteredParticle_Name != "")
	{
		PersistentStatChangeEffect.VFXTemplateName = class'X2StatusEffects'.default.PoisonEnteredParticle_Name;
		PersistentStatChangeEffect.VFXSocket = class'X2StatusEffects'.default.PoisonEnteredSocket_Name;
		PersistentStatChangeEffect.VFXSocketsArrayName = class'X2StatusEffects'.default.PoisonEnteredSocketsArray_Name;
	}

	UnitPropCondition = new class'X2Condition_UnitProperty';
	UnitPropCondition.ExcludeFriendlyToSource = false;
	UnitPropCondition.ExcludeRobotic = true;
	PersistentStatChangeEffect.TargetConditions.AddItem(UnitPropCondition);

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.EffectDamageValue.Damage = default.BasicSpitDamage;
	DamageEffect.EffectDamageValue.DamageType = 'Poison';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.bBypassShields = true; // added for PA
	DamageEffect.DamageTypes.AddItem('Poison');
	PersistentStatChangeEffect.ApplyOnTick.AddItem(DamageEffect);

	return PersistentStatChangeEffect;
}

//------------------------------------------------------------------------------
// Enhanced Spit
// The ability does nothing, except display an icon in the lower left corner
// The magic happens in PA_PoisonSpit OwnerHasSoldierAbilities
//------------------------------------------------------------------------------

static function X2AbilityTemplate PA_EnhancedSpit()
{
	local X2AbilityTemplate Template;
	local X2Effect_PersistentStatChange EnhancedEffect;
	local X2AbilityTrigger_UnitPostBeginPlay Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'PA_EnhancedSpit');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_poisonspit";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	// from RobotImmunities, always show icon in lower left
 	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
 	Template.AbilityTriggers.AddItem(Trigger);
	EnhancedEffect = new class'X2Effect_PersistentStatChange';
	EnhancedEffect.BuildPersistentEffect(1, true, true, true);
	EnhancedEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,, Template.AbilitySourceName);
	EnhancedEffect.AddPersistentStatChange(eStat_HP, 0);
	Template.AddTargetEffect(EnhancedEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

// Applies effects on top of basic damage, does not need its own visualization
static function X2Effect_PersistentStatChange CreateEnhancedStatusEffect()
{
	local X2Effect_PersistentStatChange     PersistentStatChangeEffect;
	local X2Effect_ApplyWeaponDamage              DamageEffect;
	local X2Condition_UnitProperty UnitPropCondition;

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.EffectName = class'X2StatusEffects'.default.PoisonedName;
	PersistentStatChangeEffect.DuplicateResponse = eDupe_Allow; // key point to add over basic damage
	PersistentStatChangeEffect.BuildPersistentEffect(class'X2StatusEffects'.default.POISONED_TURNS,, false,,eGameRule_PlayerTurnBegin);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.EnhancedSpitMobility);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Offense, default.EnhancedSpitAim);
	PersistentStatChangeEffect.iInitialShedChance = class'X2StatusEffects'.default.POISONED_INITIAL_SHED;
	PersistentStatChangeEffect.iPerTurnShedChance = 10; // class'X2StatusEffects'.default.POISONED_PER_TURN_SHED;
	PersistentStatChangeEffect.DamageTypes.AddItem('Poison');
	PersistentStatChangeEffect.bRemoveWhenTargetDies = true;

	UnitPropCondition = new class'X2Condition_UnitProperty';
	UnitPropCondition.ExcludeFriendlyToSource = false;
	UnitPropCondition.ExcludeRobotic = true;
	PersistentStatChangeEffect.TargetConditions.AddItem(UnitPropCondition);

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.EffectDamageValue.Damage = default.EnhancedSpitDamage;
	DamageEffect.EffectDamageValue.DamageType = 'Poison';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.bBypassShields = true; // added for PA
	DamageEffect.DamageTypes.AddItem('Poison');
	PersistentStatChangeEffect.ApplyOnTick.AddItem(DamageEffect);

	return PersistentStatChangeEffect;
}


//------------------------------------------------------------------------------
// Molt
//------------------------------------------------------------------------------


static function X2AbilityTemplate PA_ViperMolt()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2AbilityCooldown						Cooldown;
	local X2Condition_UnitEffects				ExcludeEffects;
	local PA_MoltCondition						Condition;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'PA_ViperMolt');
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ViperMoltCooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	
	// Rather than the normal shooter exclusion conditions, we're just going to exclude Carry Unit and Bound, as well as adding Mind Control
	ExcludeEffects = new class'X2Condition_UnitEffects';
	ExcludeEffects.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlled');
	ExcludeEffects.AddExcludeEffect(class'X2Ability_CarryUnit'.default.CarryUnitEffectName, 'AA_CarryingUnit');
	ExcludeEffects.AddExcludeEffect(class'X2AbilityTemplateManager'.default.BoundName, 'AA_UnitIsBound');
	Template.AbilityShooterConditions.AddItem(ExcludeEffects);
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Condition = new class'PA_MoltCondition';
	Template.AbilityTargetConditions.AddItem(Condition);

	// Remove all the things
	Template.AddTargetEffect(static.RemoveAllEffectsByDamageType(GetViperMoltDamageTypeNames()));
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.IconImage = "img:///UILibrary_PlayableAdvent.Viper_Molt";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.Hostility = eHostility_Defensive;
	Template.bDisplayInUITooltip = false;
	Template.bLimitTargetIcons = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.ActivationSpeech = 'CombatStim';
	
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;
	Template.bDontDisplayInAbilitySummary = false;
	Template.CustomSelfFireAnim = 'FF_FireMedkitSelf';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	
	return Template;
}

// This is straight from the Gremlin heal, but it takes care of all the stuff Molt should cleanse
static function X2Effect_RemoveEffectsByDamageType RemoveAllEffectsByDamageType(array<name> DamageTypeNames)
{
	local X2Effect_RemoveEffectsByDamageType RemoveEffectTypes;
	local name DamageTypeName;

	RemoveEffectTypes = new class'X2Effect_RemoveEffectsByDamageType';
	foreach DamageTypeNames(DamageTypeName)
	{
		RemoveEffectTypes.DamageTypesToRemove.AddItem(DamageTypeName);
	}

	return RemoveEffectTypes;
}

static function array<name> GetViperMoltDamageTypeNames()
{
	local array<name> DamageTypeNames;

	DamageTypeNames.Length = 0;
	DamageTypeNames.AddItem('Fire');
	DamageTypeNames.AddItem('Poison');
	DamageTypeNames.AddItem(class'X2Effect_ParthenogenicPoison'.default.ParthenogenicPoisonType);
	DamageTypeNames.AddItem('Acid');

	return DamageTypeNames;
}

//------------------------------------------------------------------------------
// Blend In
//------------------------------------------------------------------------------

static function X2AbilityTemplate PA_ViperBlendIn()
{
	local X2AbilityTemplate Template;
	local X2Effect_RangerStealth StealthEffect;
	local X2AbilityCooldown Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'PA_ViperBlendIn');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PlayableAdvent.Viper_BlendIn";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityCosts.AddItem(default.FreeActionCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 3;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityShooterConditions.AddItem(new class'X2Condition_Stealth');

	StealthEffect = new class'X2Effect_RangerStealth';
	StealthEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnEnd);
	StealthEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true);
	StealthEffect.bRemoveWhenTargetConcealmentBroken = true;
	Template.AddTargetEffect(StealthEffect);

	Template.AddTargetEffect(class'X2Effect_Spotted'.static.CreateUnspottedEffect());

	Template.ActivationSpeech = 'ActivateConcealment';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;

	return Template;
}

static function X2AbilityTemplate PA_ViperSlither()
{
	local X2AbilityTemplate Template;
	local X2Effect_PersistentStatChange SlitherEffect;
	local X2AbilityCooldown Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'PA_ViperSlither');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PlayableAdvent.Viper_Slither";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityCosts.AddItem(default.FreeActionCost);
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 4;
	Template.AbilityCooldown = Cooldown;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SlitherEffect = new class'X2Effect_PersistentStatChange';
	SlitherEffect.BuildPersistentEffect(2, false, false, false, eGameRule_PlayerTurnBegin);
	SlitherEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, , , Template.AbilitySourceName);
	SlitherEffect.AddPersistentStatChange(eStat_Mobility, 4);
	SlitherEffect.AddPersistentStatChange(eStat_Defense, 20);
	Template.AddTargetEffect(SlitherEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}


//------------------------------------------------------------------------------
// Jiffy Lube (fast healing)
// The ability does nothing, except display an icon in the lower left corner
// The magic happens in PA_GameStateContext_StrategyGameRule.uc
//------------------------------------------------------------------------------


static function X2AbilityTemplate PA_MecJiffyLube()
{
	local X2AbilityTemplate Template;
	local X2Effect_PersistentStatChange JiffyLubeEffect;
	local X2AbilityTrigger_UnitPostBeginPlay Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'PA_MecJiffyLube');
 	Template.IconImage = "img:///UILibrary_PlayableAdvent.MEC_JiffyLube";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	// from RobotImmunities, always show icon in lower left
 	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
 	Template.AbilityTriggers.AddItem(Trigger);
	JiffyLubeEffect = new class'X2Effect_PersistentStatChange';
	JiffyLubeEffect.BuildPersistentEffect(1, true, true, true);
	JiffyLubeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,, Template.AbilitySourceName);
	JiffyLubeEffect.AddPersistentStatChange(eStat_HP, 0);
	Template.AddTargetEffect(JiffyLubeEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}


//------------------------------------------------------------------------------
// Damage Control 
//------------------------------------------------------------------------------


static function X2AbilityTemplate PA_MecDamageControl()
{
	local X2AbilityTemplate Template;
	local X2Effect_Regeneration RegenerationEffect;
	local X2AbilityTrigger_UnitPostBeginPlay Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'PA_MecDamageControl');
 	Template.IconImage = "img:///UILibrary_PlayableAdvent.MEC_DamageControl";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	// from RobotImmunities, always show icon in lower left
 	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
 	Template.AbilityTriggers.AddItem(Trigger);
	RegenerationEffect = new class'X2Effect_Regeneration';
	RegenerationEffect.BuildPersistentEffect(1,  true, true, false, eGameRule_PlayerTurnBegin);
	RegenerationEffect.HealAmount = 2; // NYI unhardcode later
	RegenerationEffect.MaxHealAmount = 8; // NYI unhardcode later
	RegenerationEffect.HealthRegeneratedName = 'PA_MecDamageControl';
	RegenerationEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(RegenerationEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}


//------------------------------------------------------------------------------
// Chryssalid slash
// Do not allow slash on civilians or self (!)
//------------------------------------------------------------------------------

// static function X2AbilityTemplate PA_ChryssalidSlash()
// {
// 	local X2AbilityTemplate Template;
// 	local X2AbilityCost_ActionPoints ActionPointCost;
// 	local X2AbilityToHitCalc_StandardMelee MeleeHitCalc;
// 	local X2Condition_UnitProperty UnitPropertyCondition;
// 	local X2Effect_ApplyWeaponDamage PhysicalDamageEffect;
// 	local PA_ParthenoEffect Effect;
// 	local X2AbilityTarget_MovingMelee MeleeTarget;
// 
// 	`CREATE_X2ABILITY_TEMPLATE(Template, 'PA_ChryssalidSlash');
// 	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_chryssalid_slash";
// 	Template.Hostility = eHostility_Offensive;
// 	Template.AbilitySourceName = 'eAbilitySource_Standard';
// 
// 	ActionPointCost = new class'X2AbilityCost_ActionPoints';
// 	ActionPointCost.iNumPoints = 1;
// 	ActionPointCost.bConsumeAllPoints = true;
// 	Template.AbilityCosts.AddItem(ActionPointCost);
// 
// 	MeleeHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
// 	Template.AbilityToHitCalc = MeleeHitCalc;
// 
// 	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
// 	Template.AddShooterEffectExclusions();
// 
// 	UnitPropertyCondition = new class'X2Condition_UnitProperty';
// 	UnitPropertyCondition.ExcludeDead = true;
// 	// prevents attacks on civilians or self
// 	UnitPropertyCondition.ExcludeFriendlyToSource = true; // Disable this to allow civilians to be attacked.
// 	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
// 	
// 	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
// 
// 	Effect = new class'PA_ParthenoEffect';
// 	Effect.BuildPersistentEffect(class'X2Ability_Chryssalid'.default.POISON_DURATION, true, false, false, eGameRule_PlayerTurnEnd);
// 	Effect.SetDisplayInfo(ePerkBuff_Penalty, class'X2Ability_Chryssalid'.default.ParthenogenicPoisonFriendlyName, class'X2Ability_Chryssalid'.default.ParthenogenicPoisonFriendlyDesc, Template.IconImage, true);
// 	Effect.DuplicateResponse = eDupe_Ignore;
// 	Effect.SetPoisonDamageDamage();
// 
// 	UnitPropertyCondition = new class'X2Condition_UnitProperty';
// 	UnitPropertyCondition.ExcludeRobotic = true;
// 	UnitPropertyCondition.ExcludeAlive = false;
// 	UnitPropertyCondition.ExcludeDead = false;
// 	Effect.TargetConditions.AddItem(UnitPropertyCondition);
// 	Template.AddTargetEffect(Effect);
// 
// 	PhysicalDamageEffect = new class'X2Effect_ApplyWeaponDamage';
// 	PhysicalDamageEffect.EffectDamageValue = class'X2Item_DefaultWeapons'.default.CHRYSSALID_MELEEATTACK_BASEDAMAGE;
// 	PhysicalDamageEffect.EffectDamageValue.DamageType = 'Melee';
// 	Template.AddTargetEffect(PhysicalDamageEffect);
// 
// 	MeleeTarget = new class'X2AbilityTarget_MovingMelee';
// 	MeleeTarget.MovementRangeAdjustment = 0;
// 	Template.AbilityTargetStyle = MeleeTarget;
// 	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';
// 
// 	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_PlayerInput');
// 	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');
// 
// 	Template.CustomFireAnim = 'FF_Melee';
// 	Template.bSkipMoveStop = true;
// 	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
// 	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
// 	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
// 	Template.CinescriptCameraType = "Chryssalid_PoisonousClaws";
// 	
// 	return Template;
// }


//------------------------------------------------------------------------------
// Mec regenerate
// Based on medikit heal but custom effect to reduce shredded to 0
//------------------------------------------------------------------------------

static function X2AbilityTemplate PA_MecRegenerate() 
{
	local X2AbilityTemplate	Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local PA_RegenerateEffect RegenEffect; 
	local X2AbilityCooldown Cooldown;
	local PA_RegenerateProperty UnitPropertyCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'PA_MecRegenerate'); 
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.IconImage = "img:///UILibrary_PlayableAdvent.MEC_Regenerate";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.Hostility = eHostility_Defensive;
	Template.bDisplayInUITooltip = false;
	Template.bLimitTargetIcons = true;
	Template.CustomSelfFireAnim = 'FF_FireMedkitSelf';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bOverrideWeapon = false; // allow medikit heal animation

	UnitPropertyCondition = new class'PA_RegenerateProperty';
	UnitPropertyCondition.ExcludeFullHealth = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 6; // NYI unhardcode later
	Template.AbilityCooldown = Cooldown;

	RegenEffect = new class'PA_RegenerateEffect'; 
	Template.AddTargetEffect(RegenEffect);

	return Template;
}


//------------------------------------------------------------------------------
// Mec Draw Fire
// Apply Advent Captain "Marked" effect to draw fire
//------------------------------------------------------------------------------

static function X2AbilityTemplate PA_MecDrawFire()
{
	local X2AbilityTemplate Template;
	local X2AbilityCooldown Cooldown;
	local X2Effect_Persistent Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'PA_MecDrawFire');
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_item_mimicbeacon";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityCosts.AddItem(default.FreeActionCost);
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 4;
	Template.AbilityCooldown = Cooldown;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Effect = class'X2StatusEffects'.static.CreateMarkedEffect(default.PA_MecDrawFireDuration, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, , , Template.AbilitySourceName);
	Template.AddTargetEffect(Effect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

//------------------------------------------------------------------------------
// Mec tier 2 missiles
//------------------------------------------------------------------------------

static function X2DataTemplate PA_MecMegaMissiles()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_Ammo AmmoCost;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2Effect_ApplyWeaponDamage WeaponEffect;
	local X2AbilityTarget_Cursor CursorTarget;
	local X2AbilityMultiTarget_Radius RadiusMultiTarget;
	local X2AbilityCooldown_LocalAndGlobal Cooldown;
	local X2AbilityToHitCalc_StandardAim    StandardAim;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'PA_MegaMissiles');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_fanfire";
	Template.Hostility = eHostility_Offensive;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.bUseAmmoAsChargesForHUD = true;
	Template.TargetingMethod = class'X2TargetingMethod_MECMicroMissile';
	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = 0;
	Cooldown.NumGlobalTurns = 1;
	Template.AbilityCooldown = Cooldown;
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;
	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.PA_MecMegaMissileRadius;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;
	WeaponEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddMultiTargetEffect(WeaponEffect);
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "MEC_MicroMissiles";

	return Template;
}
