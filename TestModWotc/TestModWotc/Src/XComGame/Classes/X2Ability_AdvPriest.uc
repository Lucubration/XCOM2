//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Ability_AdvPriest extends X2Ability
	config(GameData_SoldierSkills);

var privatewrite name HolyWarriorEffectName;

var const config int HOLYWARRIOR_ACTIONPOINTCOST;
var const config int HOLYWARRIOR_COOLDOWN_LOCAL;
var const config int HOLYWARRIOR_COOLDOWN_GLOBAL;
var const config int HOLYWARRIOR_M1_MOBILITY;
var const config int HOLYWARRIOR_M1_OFFENSE;
var const config int HOLYWARRIOR_M1_CRIT;
var const config int HOLYWARRIOR_M1_HP;
var const config int HOLYWARRIOR_M2_MOBILITY;
var const config int HOLYWARRIOR_M2_OFFENSE;
var const config int HOLYWARRIOR_M2_CRIT;
var const config int HOLYWARRIOR_M2_HP;
var const config int HOLYWARRIOR_M3_MOBILITY;
var const config int HOLYWARRIOR_M3_OFFENSE;
var const config int HOLYWARRIOR_M3_CRIT;
var const config int HOLYWARRIOR_M3_HP;
var const config float HOLYWARRIOR_DEATH_DELAY_S;
var config array<name> HOLYWARRIOR_EXCLUDE_TYPES;

// MP Config
var const config int HOLYWARRIOR_MP_MOBILITY;
var const config int HOLYWARRIOR_MP_OFFENSE;
var const config int HOLYWARRIOR_MP_CRIT;
var const config int HOLYWARRIOR_MP_HP;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(CreateHolyWarrior('HolyWarriorM1', default.HOLYWARRIOR_M1_MOBILITY, default.HOLYWARRIOR_M1_OFFENSE, default.HOLYWARRIOR_M1_CRIT, default.HOLYWARRIOR_M1_HP));
	Templates.AddItem(CreateHolyWarrior('HolyWarriorM2', default.HOLYWARRIOR_M2_MOBILITY, default.HOLYWARRIOR_M2_OFFENSE, default.HOLYWARRIOR_M2_CRIT, default.HOLYWARRIOR_M2_HP));
	Templates.AddItem(CreateHolyWarrior('HolyWarriorM3', default.HOLYWARRIOR_M3_MOBILITY, default.HOLYWARRIOR_M3_OFFENSE, default.HOLYWARRIOR_M3_CRIT, default.HOLYWARRIOR_M3_HP));
	Templates.AddItem(CreateHolyWarriorDeath());
	Templates.AddItem(CreatePriestStasis());
	Templates.AddItem(CreatePriestMindControl());

	// MP Abilities
	Templates.AddItem(CreateHolyWarrior('HolyWarriorMP', default.HOLYWARRIOR_MP_MOBILITY, default.HOLYWARRIOR_MP_OFFENSE, default.HOLYWARRIOR_MP_CRIT, default.HOLYWARRIOR_MP_HP));
	Templates.AddItem(CreatePriestRemoved());
	
	return Templates;
}

static function X2DataTemplate CreateHolyWarrior(name AbilityName, int MobilityChange, int AimChange, int CritChange, int HPChange)
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCooldown_LocalAndGlobal Cooldown;
	local X2Condition_UnitProperty UnitPropertyCondition;
	local X2Effect_PersistentStatChange HolyWarriorEffect;
	local X2Condition_UnitEffects ExcludeEffectsCondition;
	local X2Condition_UnitType UnitTypeCondition;
	local X2Condition_UnitEffectsApplying ApplyingEffectsCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_holywarrior";
	Template.Hostility = eHostility_Offensive;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;

	Template.AdditionalAbilities.AddItem('HolyWarriorDeath');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.HOLYWARRIOR_ACTIONPOINTCOST;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = default.HOLYWARRIOR_COOLDOWN_LOCAL;
	Cooldown.NumGlobalTurns = default.HOLYWARRIOR_COOLDOWN_GLOBAL;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();	// Discuss with Jake/Design what exclusions are allowed here

	ApplyingEffectsCondition = new class'X2Condition_UnitEffectsApplying';
	ApplyingEffectsCondition.AddExcludeEffect(default.HolyWarriorEffectName, 'AA_AbilityUnavailable');
	ApplyingEffectsCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlling');
	Template.AbilityShooterConditions.AddItem(ApplyingEffectsCondition);

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	UnitTypeCondition = new class'X2Condition_UnitType';
	UnitTypeCondition.ExcludeTypes = default.HOLYWARRIOR_EXCLUDE_TYPES;
	Template.AbilityTargetConditions.AddItem(UnitTypeCondition);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.ExcludeCivilian = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	ExcludeEffectsCondition = new class'X2Condition_UnitEffects';
	ExcludeEffectsCondition.AddExcludeEffect(default.HolyWarriorEffectName, 'AA_DuplicateEffectIgnored');
	ExcludeEffectsCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlled');
	Template.AbilityTargetConditions.AddItem(ExcludeEffectsCondition);

	HolyWarriorEffect = new class'X2Effect_PersistentStatChange';
	HolyWarriorEffect.EffectName = default.HolyWarriorEffectName;
	HolyWarriorEffect.DuplicateResponse = eDupe_Ignore;
	HolyWarriorEffect.BuildPersistentEffect(1, true, false, true);
	HolyWarriorEffect.bRemoveWhenTargetDies = true;
	HolyWarriorEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	HolyWarriorEffect.AddPersistentStatChange(eStat_Mobility, MobilityChange);
	HolyWarriorEffect.AddPersistentStatChange(eStat_Offense, AimChange);
	HolyWarriorEffect.AddPersistentStatChange(eStat_CritChance, CritChange);
	HolyWarriorEffect.AddPersistentStatChange(eStat_ShieldHP, HPChange);
	Template.AddTargetEffect(HolyWarriorEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CustomFireAnim = 'HL_Psi_MindControl';
//BEGIN AUTOGENERATED CODE: Template Overrides 'HolyWarriorM1'
//BEGIN AUTOGENERATED CODE: Template Overrides 'HolyWarriorM2'
//BEGIN AUTOGENERATED CODE: Template Overrides 'HolyWarriorM3'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.CinescriptCameraType = "Psionic_FireAtUnit";
//END AUTOGENERATED CODE: Template Overrides 'HolyWarriorM3'
//END AUTOGENERATED CODE: Template Overrides 'HolyWarriorM2'
//END AUTOGENERATED CODE: Template Overrides 'HolyWarriorM1'
	Template.bShowActivation = true;

	//	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate CreateHolyWarriorDeath()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener DeathEventListener;
	local X2Condition_UnitEffectsWithAbilitySource TargetEffectCondition;
	local X2Effect_HolyWarriorDeath HolyWarriorDeathEffect;
	local X2Effect_RemoveEffects RemoveEffects;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'HolyWarriorDeath');
	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	// This ability fires when the unit dies
	DeathEventListener = new class'X2AbilityTrigger_EventListener';
	DeathEventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	DeathEventListener.ListenerData.EventID = 'UnitDied';
	DeathEventListener.ListenerData.Filter = eFilter_Unit;
	DeathEventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_SelfWithAdditionalTargets;
	Template.AbilityTriggers.AddItem(DeathEventListener);

	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllUnits';

	TargetEffectCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	TargetEffectCondition.AddRequireEffect(default.HolyWarriorEffectName, 'AA_UnitIsImmune');
	Template.AbilityMultiTargetConditions.AddItem(TargetEffectCondition);

	HolyWarriorDeathEffect = new class'X2Effect_HolyWarriorDeath';
	HolyWarriorDeathEffect.DelayTimeS = default.HOLYWARRIOR_DEATH_DELAY_S;
	Template.AddMultiTargetEffect(HolyWarriorDeathEffect);

	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(default.HolyWarriorEffectName);
	Template.AddMultiTargetEffect(RemoveEffects);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.MergeVisualizationFn = HolyWarriorDeath_MergeVisualization;
	
	Template.CinescriptCameraType = "HolyWarrior_Death";

	Template.bSkipFireAction = true;
	Template.FrameAbilityCameraType = eCameraFraming_Never;

	return Template;
}

function HolyWarriorDeath_MergeVisualization(X2Action BuildTree, out X2Action VisualizationTree)
{
	local X2Action_Death PriestDeathAction;
	local X2Action BuildTreeStartNode, BuildTreeEndNode;
	local XComGameStateVisualizationMgr LocalVisualizationMgr;
	local XComGameStateContext_Ability AbilityContext;

	LocalVisualizationMgr = `XCOMVISUALIZATIONMGR;

	AbilityContext = XComGameStateContext_Ability(BuildTree.StateChangeContext);

	PriestDeathAction = X2Action_Death(LocalVisualizationMgr.GetNodeOfType(VisualizationTree, class'X2Action_Death', , AbilityContext.InputContext.SourceObject.ObjectID));
	BuildTreeStartNode = LocalVisualizationMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertBegin');
	BuildTreeEndNode = LocalVisualizationMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertEnd');
	LocalVisualizationMgr.InsertSubtree(BuildTreeStartNode, BuildTreeEndNode, PriestDeathAction);
}

static function X2DataTemplate CreatePriestRemoved()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener EventListener;
	local X2Condition_UnitEffectsWithAbilitySource TargetEffectCondition;
	local X2Effect_RemoveEffects RemoveEffects;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'PriestRemoved');
	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	//	Trigger if the source is removed from play (e.g. evacs)
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitRemovedFromPlay';
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_SelfIgnoreCache;
	EventListener.ListenerData.Priority = 75;	// We need this to happen before the unit is actually removed from play
	Template.AbilityTriggers.AddItem(EventListener);

	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllUnits';

	TargetEffectCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	TargetEffectCondition.AddRequireEffect(default.HolyWarriorEffectName, 'AA_UnitIsImmune');
	Template.AbilityMultiTargetConditions.AddItem(TargetEffectCondition);

	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(default.HolyWarriorEffectName);
	Template.AddMultiTargetEffect(RemoveEffects);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.bSkipFireAction = true;
	Template.FrameAbilityCameraType = eCameraFraming_Never;

	return Template;
}

static function X2DataTemplate CreatePriestStasis()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	Template = X2AbilityTemplate(class'X2Ability_PsiOperativeAbilitySet'.static.Stasis('PriestStasis'));
	`Assert(Template.AbilityCosts.Length == 1); // Base stasis ability only has one ability cost.  Replacing this here.
	Template.AbilityCosts.Length = 0;
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	return Template;
}

static function X2DataTemplate CreatePriestMindControl()
{
	local X2AbilityTemplate Template;
	local X2Condition_UnitEffectsApplying ApplyingEffectsCondition;

	Template = X2AbilityTemplate(class'X2Ability_PsiWitch'.static.CreatePsiMindControlAbility('PriestPsiMindControl'));

	ApplyingEffectsCondition = new class'X2Condition_UnitEffectsApplying';
	ApplyingEffectsCondition.AddExcludeEffect(default.HolyWarriorEffectName, 'AA_AbilityUnavailable');
	ApplyingEffectsCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlling');
	Template.AbilityShooterConditions.AddItem(ApplyingEffectsCondition);

	return Template;
}

defaultproperties
{
	HolyWarriorEffectName="HolyWarriorEffect"
}
