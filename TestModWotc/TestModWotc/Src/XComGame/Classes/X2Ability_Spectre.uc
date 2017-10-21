//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Ability_Spectre extends X2Ability
	config(GameData_SoldierSkills);

var localized string WillLostFriendlyName, WillLossString;
var localized string ShadowbindUnconsciousFriendlyName;

var config int VANISH_ACTIONPOINTCOST;
var config int VANISH_COOLDOWN_LOCAL;
var config int VANISH_COOLDOWN_GLOBAL;
var config float VANISH_MOBILITY_INCREASE;
var config int HORROR_ACTIONPOINTCOST;
var config int HORROR_COOLDOWN_LOCAL;
var config int HORROR_COOLDOWN_GLOBAL;
var config int HORROR_TOHIT_BASECHANCE;
var config int HORROR_WILL_DECREASE;
var config int SHADOWBIND_COOLDOWN_LOCAL;
var config int SHADOWBIND_COOLDOWN_GLOBAL;

var name ShadowboundLinkName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(CreateSpectreMoveBegin());
	Templates.AddItem(CreateSpectreMoveEnd());

	Templates.AddItem(CreateVanish());
	Templates.AddItem(CreateVanishReveal());
	Templates.AddItem(CreateHorror());
	Templates.AddItem(CreateShadowbind('Shadowbind', 'ShadowbindUnit'));
	Templates.AddItem(CreateShadowbind('ShadowbindM2', 'ShadowbindUnitM2'));
	Templates.AddItem(class'X2Ability_Sectoid'.static.AddLinkedEffectAbility(default.ShadowboundLinkName, default.ShadowboundLinkName, ShadowboundLink_BuildVisualizationSyncDelegate));
	Templates.AddItem(class'X2Ability_Sectoid'.static.AddKillLinkedUnits('KillShadowboundLinkedUnits', default.ShadowboundLinkName, class'X2Action_Death'));
	
	Templates.AddItem(CreateShadowUnitInitialize());
	
	// MP Versions of Abilities
	Templates.AddItem(CreateShadowbind('ShadowbindMP', 'ShadowbindUnitMP'));

	return Templates;
}

simulated function ShadowboundLink_BuildVisualizationSyncDelegate(name EffectName, XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata)
{
	local XComGameStateContext_Ability AbilityContext;

	local XComGameState_Unit ShadowboundState;
	local XComGameState_Unit DeadUnitState;

	local XComGameState_Ability UnitAbility;

	local X2Action_CreateDoppelganger DoppelgangerAction;

	//Only run on the ShadowboundLink effect
	if (EffectName != default.ShadowboundLinkName)
		return;

	//Find the context and unit states associated with the Psi Reanimation ability used
	AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	if (AbilityContext == None)
		return;

	ShadowboundState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
	DeadUnitState = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
	if (ShadowboundState == None || DeadUnitState == None)
		return;

	UnitAbility = XComGameState_Ability(VisualizeGameState.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
	if (UnitAbility == none)
		return;

	//Perform X2Action_CreateDoppelganger on the Unit, as we did when it was spawned, to grab the original unit's appearance and tether effect.
	DoppelgangerAction = X2Action_CreateDoppelganger(class'X2Action_CreateDoppelganger'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	DoppelgangerAction.OriginalUnitState = DeadUnitState;
	DoppelgangerAction.ShouldCopyAppearance = true;
	DoppelgangerAction.ReanimatorAbilityState = UnitAbility;
	DoppelgangerAction.bIgnorePose = true;
	DoppelgangerAction.bReplacingOriginalUnit = false;
}

// Move abilities
static function X2AbilityTemplate CreateSpectreMoveBegin()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener EventListener;
	local X2Condition_UnitEffects UnitEffects;
	local X2Effect_PerkAttachForFX PerkEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SpectreMoveBegin');
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDontDisplayInAbilitySummary = true;

	Template.AdditionalAbilities.AddItem('SpectreMoveEnd');

	Template.AbilityCosts.Length = 0;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	UnitEffects = new class'X2Condition_UnitEffects';
	UnitEffects.AddExcludeEffect('SpectreBeginMoveEffect', 'AA_DuplicateEffectIgnored');
	UnitEffects.AddExcludeEffect(class'X2Effect_Vanish'.default.EffectName, 'AA_DuplicateEffectIgnored');
	Template.AbilityShooterConditions.AddItem(UnitEffects);

	// At the start of a move, if the unit is open, have it close
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'ObjectMoved';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.SpectreStandardMoveListener;
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	PerkEffect = new class'X2Effect_PerkAttachForFX';
	PerkEffect.EffectName = 'SpectreBeginMoveEffect';
	Template.AddShooterEffect(PerkEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = SpectreMoveBegin_BuildVisualization;

	Template.bSkipFireAction = true;
	
	return Template;
}

simulated function SpectreMoveBegin_BuildVisualization(XComGameState VisualizeGameState)
{
	local X2Action_MoveBegin MoveBeginAction;
	local X2Action_MoveEnd MoveEndAction;
	local XComGameStateVisualizationMgr LocalVisualizationMgr;
	local XComGameStateHistory History;
	local VisualizationActionMetadata ActionMetaData;
	local array<X2Action> MoveEndActionParents;
	local XComGameStateContext_Ability Context;

	LocalVisualizationMgr = `XCOMVISUALIZATIONMGR;
	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(Context.InputContext.SourceObject.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(Context.InputContext.SourceObject.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(Context.InputContext.SourceObject.ObjectID);

	MoveBeginAction = X2Action_MoveBegin(LocalVisualizationMgr.GetNodeOfType(LocalVisualizationMgr.BuildVisTree, class'X2Action_MoveBegin', ActionMetadata.VisualizeActor));
	if( MoveBeginAction == none )
	{
		MoveBeginAction = X2Action_MoveBegin(LocalVisualizationMgr.GetNodeOfType(LocalVisualizationMgr.VisualizationTree, class'X2Action_MoveBegin', ActionMetadata.VisualizeActor));
	}
	
	MoveEndAction = X2Action_MoveEnd(LocalVisualizationMgr.GetNodeOfType(LocalVisualizationMgr.BuildVisTree, class'X2Action_MoveEnd', ActionMetadata.VisualizeActor));
	if( MoveEndAction == none )
	{
		MoveEndAction = X2Action_MoveEnd(LocalVisualizationMgr.GetNodeOfType(LocalVisualizationMgr.VisualizationTree, class'X2Action_MoveEnd', ActionMetadata.VisualizeActor));
	}

	if( MoveBeginAction == none ||
		MoveEndAction == none )
	{
		`RedScreen("SpectreMoveBegin_BuildVisualization: Failed to find move actions");
		return;
	}

	MoveEndActionParents.AddItem(MoveEndAction);

	SpectreMoveInsertTransform(VisualizeGameState, ActionMetaData, MoveBeginAction.ParentActions, MoveEndActionParents);
}

private function SpectreMoveInsertTransform(XComGameState VisualizeGameState, VisualizationActionMetadata ActionMetaData, array<X2Action> TransformStartParents, array<X2Action> TransformStopParents)
{
	local X2Action_PlayAnimation AnimAction;

	AnimAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetaData, VisualizeGameState.GetContext(), true, , TransformStartParents));
	AnimAction.Params.AnimName = 'HL_Transform_Start';

	AnimAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetaData, VisualizeGameState.GetContext(), true, , TransformStopParents));
	AnimAction.Params.AnimName = 'HL_Transform_Stop';
}

static function X2AbilityTemplate CreateSpectreMoveEnd()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener EventListener;
	local X2Condition_UnitEffects UnitEffects;
	local X2Effect_RemoveEffects PerkEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SpectreMoveEnd');
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilityCosts.Length = 0;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	UnitEffects = new class'X2Condition_UnitEffects';
	UnitEffects.AddRequireEffect('SpectreBeginMoveEffect', 'AA_MissingRequiredEffect');
	UnitEffects.AddExcludeEffect(class'X2Effect_Vanish'.default.EffectName, 'AA_DuplicateEffectIgnored');
	Template.AbilityShooterConditions.AddItem(UnitEffects);

	// At the start of a move, if the unit is open, have it close
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'ObjectMoved';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.SpectreStandardMoveListener;
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	PerkEffect = new class'X2Effect_RemoveEffects';
	PerkEffect.EffectNamesToRemove.AddItem('SpectreBeginMoveEffect');
	Template.AddShooterEffect(PerkEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2DataTemplate CreateVanish()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCooldown_LocalAndGlobal Cooldown;
	local X2Effect_RemoveEffects RemoveEffects;
	local X2Effect_Vanish VanishEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Vanish');
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_vanishingwind";
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;

	Template.AdditionalAbilities.AddItem('VanishReveal');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.VANISH_ACTIONPOINTCOST;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = default.VANISH_COOLDOWN_LOCAL;
	Cooldown.NumGlobalTurns = default.VANISH_COOLDOWN_GLOBAL;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityShooterConditions.AddItem(class'X2Effect_Vanish'.static.VanishShooterEffectsCondition());

	// Add remove suppression
	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2Effect_Suppression'.default.EffectName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2Effect_TargetDefinition'.default.EffectName);
	Template.AddTargetEffect(RemoveEffects);

	VanishEffect = new class'X2Effect_Vanish';
	VanishEffect.BuildPersistentEffect(1, true, false, true);
	VanishEffect.AddPersistentStatChange(eStat_Mobility, default.VANISH_MOBILITY_INCREASE, MODOP_Multiplication);
	VanishEffect.VanishRevealAnimName = 'HL_Vanish_Stop';
	VanishEffect.VanishSyncAnimName = 'ADD_Vanish_Restart';
	Template.AddTargetEffect(VanishEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.bShowActivation = true;

	Template.CinescriptCameraType = "VanishAbility";
//BEGIN AUTOGENERATED CODE: Template Overrides 'Vanish'
	Template.bSkipExitCoverWhenFiring = true;
	Template.CustomFireAnim = 'HL_Vanish_Start';
//END AUTOGENERATED CODE: Template Overrides 'Vanish'
	
	return Template;
}

static function X2DataTemplate CreateVanishReveal()
{
	local X2AbilityTemplate Template;
	local X2Condition_UnitEffects UnitEffectsCondition;
	local X2Effect_RemoveEffects RemoveEffects;
	local X2AbilityTrigger_EventListener Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'VanishReveal');
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_vanishingwind";
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// This ability fires can when the unit gets hit by a scan
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = class'X2Effect_ScanningProtocol'.default.ScanningProtocolTriggeredEventName;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(Trigger);

	// This ability fires when the unit is flanked by an enemy
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_UnitIsFlankedByMovedUnit;
	Trigger.ListenerData.EventID = 'UnitMoveFinished';
	Template.AbilityTriggers.AddItem(Trigger);

	//	This functionality has been deprecated -jbouscher
	// This ability fires when a linked Shadowbound unit dies 
	//Trigger = new class'X2AbilityTrigger_EventListener';
	//Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	//Trigger.ListenerData.EventID = 'UnitDied';
	//Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.ShadowboundDeathRevealListener;
	//Template.AbilityTriggers.AddItem(Trigger);

	// This ability fires when the unit is damaged
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'UnitTakeEffectDamage';
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(Trigger);

	// This ability fires when the unit gets a certain effect added to it
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_VanishedUnitPersistentEffectAdded;
	Trigger.ListenerData.EventID = 'PersistentEffectAdded';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(Trigger);

	// The shooter must have the Vanish Effect
	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddRequireEffect(class'X2Effect_Vanish'.default.EffectName, 'AA_MissingRequiredEffect');
	Template.AbilityShooterConditions.AddItem(UnitEffectsCondition);

	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2Effect_Vanish'.default.EffectName);
	Template.AddShooterEffect(RemoveEffects);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.MergeVisualizationFn = class'X2Ability_ChosenAssassin'.static.VanishingWindReveal_MergeVisualization;

	Template.bSkipFireAction = true;
	Template.bShowPostActivation = true;
	Template.bFrameEvenWhenUnitIsHidden = true;

	Template.CinescriptCameraType = "VanishRevealAbility";
	
	return Template;
}

static function X2AbilityTemplate CreateHorror()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCooldown_LocalAndGlobal Cooldown;
	local X2AbilityToHitCalc_RollStat RollStat;
	local X2Condition_UnitProperty UnitPropertyCondition;
	local X2Condition_UnitImmunities UnitImmunityCondition;
	local X2Effect_ApplyWeaponDamage HorrorDamageEffect;
	local X2Effect_PerkAttachForFX WillLossEffect;
	local X2Effect_LifeSteal LifeStealEffect;
	local array<name> SkipExclusions;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Horror');

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_horror";
	Template.Hostility = eHostility_Offensive;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.HORROR_ACTIONPOINTCOST;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = default.HORROR_COOLDOWN_LOCAL;
	Cooldown.NumGlobalTurns = default.HORROR_COOLDOWN_GLOBAL;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// This will be a stat contest
	RollStat = new class'X2AbilityToHitCalc_RollStat';
	RollStat.StatToRoll = eStat_Will;
	RollStat.BaseChance = default.HORROR_TOHIT_BASECHANCE;
	Template.AbilityToHitCalc = RollStat;

	// Shooter conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Target conditions
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.ExcludeAlien = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Mental');
	UnitImmunityCondition.bOnlyOnCharacterTemplate = true;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	// Target Effects
	WillLossEffect = new class'X2Effect_PerkAttachForFX';
	WillLossEffect.BuildPersistentEffect(1, false, false);
	WillLossEffect.DuplicateResponse = eDupe_Allow;
	WillLossEffect.EffectName = 'HorrorWillLossEffect';
	Template.AddTargetEffect(WillLossEffect);

	HorrorDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	HorrorDamageEffect.bIgnoreBaseDamage = true;
	HorrorDamageEffect.DamageTag = 'Horror';
	HorrorDamageEffect.bIgnoreArmor = true;
	Template.AddTargetEffect(HorrorDamageEffect);

	LifeStealEffect = new class'X2Effect_LifeSteal';
	Template.AddTargetEffect(LifeStealEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.bShowActivation = true;

	Template.CinescriptCameraType = "Spectre_Horror";

	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	Template.PostActivationEvents.AddItem('HorrorActivated');
//BEGIN AUTOGENERATED CODE: Template Overrides 'Horror'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.ActionFireClass = class'XComGame.X2Action_Fire_Horror';
	Template.CustomFireAnim = 'HL_Horror_StartA';
//END AUTOGENERATED CODE: Template Overrides 'Horror'

	return Template;
}

static function X2DataTemplate CreateShadowbind(name AbilityTemplateName, name UnitToSpawnName)
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2Condition_UnitProperty UnitPropertyCondition;
	local X2Condition_UnitImmunities UnitImmunityCondition;
	local X2Effect_RemoveEffects RemoveEffects;
	local X2Effect_SpawnShadowbindUnit SpawnShadowbindUnit;
	local X2AbilityCooldown_LocalAndGlobal Cooldown;
	local X2Effect_OverrideDeathAction DeathActionEffect;
	local X2Effect_Persistent UnconsciousEffect;
	local X2Condition_UnitType UnitTypeCondition;
	local array<name> SkipExclusions;

	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityTemplateName);
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_shadowbind";
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = default.SHADOWBIND_COOLDOWN_LOCAL;
	Cooldown.NumGlobalTurns = default.SHADOWBIND_COOLDOWN_GLOBAL;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityShooterConditions.AddItem(new class'X2Condition_UnblockedNeighborTile');
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	UnitTypeCondition = new class'X2Condition_UnitType';
	UnitTypeCondition.ExcludeTypes.AddItem('TheLost');
	Template.AbilityTargetConditions.AddItem(UnitTypeCondition);

	// The Target must be alive and a humanoid
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeAlien = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.ExcludeImpaired = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Unconscious');
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2Effect_ParthenogenicPoison'.default.EffectName);
	Template.AddTargetEffect(RemoveEffects);

	DeathActionEffect = new class'X2Effect_OverrideDeathAction';
	DeathActionEffect.DeathActionClass = class'X2Action_ShadowbindTarget';
	DeathActionEffect.EffectName = 'ShadowbindUnconcious';
	Template.AddTargetEffect(DeathActionEffect);

	UnconsciousEffect = class'X2StatusEffects'.static.CreateUnconsciousStatusEffect();
	UnconsciousEffect.bRemoveWhenSourceDies = false;
	UnconsciousEffect.VisualizationFn = ShadowbindUnconsciousVisualization;
	Template.AddTargetEffect(UnconsciousEffect);

	SpawnShadowbindUnit = new class'X2Effect_SpawnShadowbindUnit';
	SpawnShadowbindUnit.BuildPersistentEffect(1, true, false, true);
	SpawnShadowbindUnit.bRemoveWhenTargetDies = false;
	SpawnShadowbindUnit.UnitToSpawnName = UnitToSpawnName;
	Template.AddTargetEffect(SpawnShadowbindUnit);

	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = Shadowbind_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;

	Template.CinescriptCameraType = "Spectre_Shadowbind";
	
//BEGIN AUTOGENERATED CODE: Template Overrides 'Shadowbind'
//BEGIN AUTOGENERATED CODE: Template Overrides 'ShadowbindM2'	
	Template.CustomFireAnim = 'HL_Shadowbind';
//END AUTOGENERATED CODE: Template Overrides 'ShadowbindM2'
//END AUTOGENERATED CODE: Template Overrides 'Shadowbind'

	return Template;
}

static function ShadowbindUnconsciousVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	if (EffectApplyResult != 'AA_Success')
	{
		return;
	}
	if (XComGameState_Unit(ActionMetadata.StateObject_NewState) == none)
		return;

	class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), default.ShadowbindUnconsciousFriendlyName, '', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_Unconscious);
	class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

simulated function Shadowbind_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateVisualizationMgr VisMgr;
	local XComGameStateHistory History;
	local XComGameStateContext_Ability Context;
	local VisualizationActionMetadata ShadowMetaData, CosmeticUnitMetaData;
	local XComGameState_Unit ShadowUnit, ShadowbindTargetUnit, TargetUnitState, CosmeticUnit;
	local UnitValue ShadowUnitValue;
	local X2Effect_SpawnShadowbindUnit SpawnShadowEffect;
	local int j;
	local name SpawnShadowEffectResult;
	local X2Action_Fire SourceFire;
	local X2Action_MoveBegin SourceMoveBegin;
	local Actor SourceUnit;
	local array<X2Action> TransformStopParents;
	local VisualizationActionMetadata SourceMetaData, TargetMetaData;
	local X2Action_MoveTurn MoveTurnAction;
	local X2Action_PlayAnimation AddAnimAction, AnimAction;
	local X2Action_ShadowbindTarget TargetShadowbind;
	local XComGameState_Item ItemState;
	local X2GremlinTemplate GremlinTemplate;
	local Array<X2Action> FoundNodes;
	local int ScanNodes;
	local X2Action_MarkerNamed JoinAction;

	TypicalAbility_BuildVisualization(VisualizeGameState);

	VisMgr = `XCOMVISUALIZATIONMGR;
	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	TargetMetaData.StateObject_OldState = History.GetGameStateForObjectID(Context.InputContext.PrimaryTarget.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	TargetMetaData.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(Context.InputContext.PrimaryTarget.ObjectID);
	TargetMetaData.VisualizeActor = History.GetVisualizer(Context.InputContext.PrimaryTarget.ObjectID);
	TargetUnitState = XComGameState_Unit(TargetMetaData.StateObject_OldState);

	VisMgr.GetNodesOfType(VisMgr.BuildVisTree, class'X2Action_MarkerNamed', FoundNodes);
	for( ScanNodes = 0; ScanNodes < FoundNodes.Length; ++ScanNodes )
	{
		JoinAction = X2Action_MarkerNamed(FoundNodes[ScanNodes]);
		if( JoinAction.MarkerName == 'Join' )
		{
			break;
		}
	}

	// Find the Fire and MoveBegin for the Source
	SourceFire = X2Action_Fire(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_Fire', , Context.InputContext.SourceObject.ObjectID));
	SourceUnit = SourceFire.Metadata.VisualizeActor;

	SourceMoveBegin = X2Action_MoveBegin(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_MoveBegin', SourceUnit));

	// Find the Target's Shadowbind
	TargetShadowbind = X2Action_ShadowbindTarget(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_ShadowbindTarget', , Context.InputContext.PrimaryTarget.ObjectID));

	SourceMetaData.StateObject_OldState = SourceFire.Metadata.StateObject_OldState;
	SourceMetaData.StateObject_NewState = SourceFire.Metadata.StateObject_NewState;
	SourceMetaData.VisualizeActor = SourceFire.Metadata.VisualizeActor;

	if (Context.InputContext.MovementPaths.Length > 0)
	{
		// If moving, need to set the facing and pre/post transforms
		MoveTurnAction = X2Action_MoveTurn(class'X2Action_MoveTurn'.static.AddToVisualizationTree(SourceMetaData, Context, true, , SourceFire.ParentActions));
		MoveTurnAction.m_vFacePoint = `XWORLD.GetPositionFromTileCoordinates(TargetUnitState.TileLocation);
		MoveTurnAction.ForceSetPawnRotation = true;

		VisMgr.ConnectAction(JoinAction, VisMgr.BuildVisTree, false, MoveTurnAction);

		TransformStopParents.AddItem(MoveTurnAction);

		SpectreMoveInsertTransform(VisualizeGameState, SourceMetaData, SourceMoveBegin.ParentActions, TransformStopParents);
	}

	// Line up the Source's Fire, Target's React, and Shadow's anim
	if( TargetShadowbind != None && TargetShadowbind.ParentActions.Length != 0 )
	{
		VisMgr.ConnectAction(JoinAction, VisMgr.BuildVisTree, false, , TargetShadowbind.ParentActions);
	}
	
	VisMgr.DisconnectAction(TargetShadowbind);
	VisMgr.ConnectAction(TargetShadowbind, VisMgr.BuildVisTree, false, , SourceFire.ParentActions);

	SpawnShadowEffectResult = 'AA_UnknownError';
	for (j = 0; j < Context.ResultContext.TargetEffectResults.Effects.Length; ++j)
	{
		SpawnShadowEffect = X2Effect_SpawnShadowbindUnit(Context.ResultContext.TargetEffectResults.Effects[j]);

		if (SpawnShadowEffect != none)
		{
			SpawnShadowEffectResult = Context.ResultContext.TargetEffectResults.ApplyResults[j];
			break;
		}
	}

	if (SpawnShadowEffectResult == 'AA_Success')
	{
		ShadowbindTargetUnit = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(Context.InputContext.PrimaryTarget.ObjectID));
		`assert(ShadowbindTargetUnit != none);
		ShadowbindTargetUnit.GetUnitValue(class'X2Effect_SpawnUnit'.default.SpawnedUnitValueName, ShadowUnitValue);

		ShadowMetaData.StateObject_OldState = History.GetGameStateForObjectID(ShadowUnitValue.fValue, eReturnType_Reference, VisualizeGameState.HistoryIndex);
		ShadowMetaData.StateObject_NewState = ShadowMetaData.StateObject_OldState;
		ShadowUnit = XComGameState_Unit(ShadowMetaData.StateObject_NewState);
		`assert(ShadowUnit != none);
		ShadowMetaData.VisualizeActor = History.GetVisualizer(ShadowUnit.ObjectID);
		
		SpawnShadowEffect.AddSpawnVisualizationsToTracks(Context, ShadowUnit, ShadowMetaData, ShadowbindTargetUnit);

		AnimAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ShadowMetaData, Context, true, TargetShadowbind));
		AnimAction.Params.AnimName = 'HL_Shadowbind_TargetShadow';
		AnimAction.Params.BlendTime = 0.0f;

		VisMgr.ConnectAction(JoinAction, VisMgr.BuildVisTree, false, AnimAction);

		AddAnimAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ShadowMetaData, Context, false, TargetShadowbind));
		AddAnimAction.bFinishAnimationWait = false;
		AddAnimAction.Params.AnimName = 'ADD_HL_Shadowbind_FadeIn';
		AddAnimAction.Params.Additive = true;
		AddAnimAction.Params.BlendTime = 0.0f;

		VisMgr.ConnectAction(JoinAction, VisMgr.BuildVisTree, false, AddAnimAction);

		// Look for a gremlin that got copied
		ItemState = ShadowUnit.GetSecondaryWeapon();
		
		GremlinTemplate = X2GremlinTemplate(ItemState.GetMyTemplate());
		if( GremlinTemplate != none )
		{
			// This is a newly spawned unit so it should have its own gremlin
			CosmeticUnit = XComGameState_Unit(History.GetGameStateForObjectID(ItemState.CosmeticUnitRef.ObjectID));

			History.GetCurrentAndPreviousGameStatesForObjectID(CosmeticUnit.ObjectID, CosmeticUnitMetaData.StateObject_OldState, CosmeticUnitMetaData.StateObject_NewState, , VisualizeGameState.HistoryIndex);
			CosmeticUnitMetaData.VisualizeActor = CosmeticUnit.GetVisualizer();

			AddAnimAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(CosmeticUnitMetaData, Context, false, TargetShadowbind));
			AddAnimAction.bFinishAnimationWait = false;
			AddAnimAction.Params.AnimName = 'ADD_HL_Shadowbind_FadeIn';
			AddAnimAction.Params.Additive = true;
			AddAnimAction.Params.BlendTime = 0.0f;

			VisMgr.ConnectAction(JoinAction, VisMgr.BuildVisTree, false, AddAnimAction);
		}
	}
}

static function X2AbilityTemplate CreateShadowUnitInitialize()
{
	local X2AbilityTemplate Template;
	local X2Effect_SpectralArmyUnit SpectralArmyUnitEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ShadowUnitInitialize');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	SpectralArmyUnitEffect = new class'X2Effect_ShadowUnit';
	SpectralArmyUnitEffect.BuildPersistentEffect(1, true, true, true);
	SpectralArmyUnitEffect.bRemoveWhenTargetDies = true;
	Template.AddShooterEffect(SpectralArmyUnitEffect);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

defaultproperties
{
	ShadowboundLinkName="ShadowboundLink"
}
