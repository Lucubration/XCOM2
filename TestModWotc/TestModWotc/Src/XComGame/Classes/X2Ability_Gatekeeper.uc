//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_Gatekeeper.uc
//  AUTHOR:  Alex Cheng  --  3/11/2015
//  PURPOSE: Provides ability definitions for Gatekeeper
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Ability_Gatekeeper extends X2Ability
	config(GameData_SoldierSkills);

var name OpenCloseAbilityName;		// Ability name referenced in code/script
var name ToggledOpenCloseUnitValue;	// Unit value name referenced in code/script
var name ClosedEffectName;			// Closed effect name referenced in code/script

var config int OpenCloseCooldown;	// Shared open/close ability cooldown duration.
var config StatCheck RETRACT_CHECK;
var config float RETRACT_DAMAGE_CHANCE_PER_ROLL;
var config int MASS_REANIMATION_LOCAL_COOLDOWN;
var config int MASS_REANIMATION_GLOBAL_COOLDOWN;
var config float MASS_REANIMATION_RADIUS_METERS;
var config float MASS_REANIMATION_RANGE_METERS;
var config float MASS_REANIMATION_ANIMATION_MIN_DELAY_SEC;
var config float MASS_REANIMATION_ANIMATION_MAX_DELAY_SEC;
var config int GATEKEEPER_CLOSED_ARMOR_ADJUST;
var config int GATEKEEPER_CLOSED_ARMORCHANCE_ADJUST;
var config int GATEKEEPER_CLOSED_SIGHT_ADJUST;
var config int GATEKEEPER_CLOSED_DEFENSE_ADJUST;
var config int ANIMA_CONSUME_RANGE_UNITS;
var config float ANIMA_CONSUME_LIFE_AMOUNT_MULTIPLIER;

const GATEKEEPER_CLOSED_VALUE=0;	// Arbitrary value designated as the closed value.
const GATEKEEPER_OPEN_VALUE=1;		// Arbitrary value designated as the open value.

var private name OpenedEffectName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(PurePassive('ProtectiveShell', "img:///UILibrary_PerkIcons.UIPerk_gatekeeper_armoredshell"));
	Templates.AddItem(CreateInitialStateAbility());
	Templates.AddItem(CreateGatekeeperOpenAbility());
	Templates.AddItem(CreateGatekeeperCloseAbility());
	Templates.AddItem(CreateGatekeeperCloseMoveBeginAbility());
	Templates.AddItem(CreateRetractDamageListenerAbility());
	Templates.AddItem(CreateRetractAbility());
	Templates.AddItem(CreateMassPsiReanimationAbility());
	Templates.AddItem(CreateAnimaConsumeAbility());
	Templates.AddItem(CreateAnimaGateAbility());
	Templates.AddItem(PurePassive('GatekeeperDeathExplosion', "img:///UILibrary_PerkIcons.UIPerk_gatekeeper_deathexplosion"));

	// MP Versions of Abilities
	Templates.AddItem(CreateMassPsiReanimationMPAbility());
	Templates.AddItem(CreateAnimaConsumeMPAbility());

	return Templates;
}

// Add initial ability on PostBeginPlay to initialize Gatekeeper with Closed effects.
static function X2AbilityTemplate CreateInitialStateAbility()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_UnitPostBeginPlay Trigger;
	local X2Effect_PersistentStatChange		CloseGatekeeperEffect;
	local X2Effect_SetUnitValue				SetClosedValue;
	local X2Effect_DamageImmunity           DamageImmunity;
	local X2Effect_OverrideDeathAction      DeathActionEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'GatekeeperInitialState');

	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AdditionalAbilities.AddItem('GatekeeperOpen');
	Template.AdditionalAbilities.AddItem('GatekeeperClose');
	Template.AdditionalAbilities.AddItem('GatekeeperCloseMoveBegin');
	Template.AdditionalAbilities.AddItem('ProtectiveShell');
	Template.AdditionalAbilities.AddItem('GateKeeperDeathExplosion');

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	// Set initial effect - Closed persistent effect.
	CloseGatekeeperEffect = class'X2StatusEffects'.static.CreateGatekeeperClosedEffect();
	Template.AddTargetEffect(CloseGatekeeperEffect);

	// Set initial effect - Closed value.
	SetClosedValue = new class'X2Effect_SetUnitValue';
	SetClosedValue.UnitName = default.OpenCloseAbilityName;
	SetClosedValue.NewValueToSet = GATEKEEPER_CLOSED_VALUE;
	SetClosedValue.CleanupType = eCleanup_BeginTactical;
	Template.AddTargetEffect(SetClosedValue);

	// Build the immunities
	DamageImmunity = new class'X2Effect_DamageImmunity';
	DamageImmunity.BuildPersistentEffect(1, true, true, true);
	DamageImmunity.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.KnockbackDamageType);
	DamageImmunity.ImmuneTypes.AddItem('Fire');
	DamageImmunity.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.ParthenogenicPoisonType);
	DamageImmunity.EffectName = 'GatekeeperDamageImmunityEffect';
	Template.AddTargetEffect(DamageImmunity);

	DeathActionEffect = new class'X2Effect_OverrideDeathAction';
	DeathActionEffect.DeathActionClass = class'X2Action_ExplodingUnitDeathAction';
	DeathActionEffect.EffectName = 'GatekeeperDeathActionEffect';
	Template.AddTargetEffect(DeathActionEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate CreateGatekeeperOpenAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local X2Effect_SetUnitValue				SetOpenValue, SetToggledValue;
	local X2Condition_UnitValue				IsClosed;
	local X2Effect_RemoveEffects            RemoveClosedEffect;
	local X2Effect_PerkAttachForFX       	OpenGatekeeperEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'GatekeeperOpen');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_gatekeeper_open"; // TODO: This needs to be changed
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.Hostility = eHostility_Neutral;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	// Cooldown on the ability
	//Cooldown = new class'X2AbilityCooldown';
	//Cooldown.iNumTurns = default.OpenCloseCooldown;
	//Template.AbilityCooldown = Cooldown;
	
	// Set up conditions for Closed check.
	IsClosed = new class'X2Condition_UnitValue';
	IsClosed.AddCheckValue(default.OpenCloseAbilityName, GATEKEEPER_CLOSED_VALUE, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem( IsClosed );
	Template.AbilityShooterConditions.AddItem( default.LivingShooterProperty );

	// DISABLING shared cooldown
	//DidNotJustClosed = new class'X2Condition_UnitValue';
	//DidNotJustClosed.AddCheckValue(default.ToggledOpenCloseUnitValue, 0, eCheck_Exact);
	//Template.AbilityShooterConditions.AddItem(DidNotJustClosed);

	// ------------
	// Open effects.  Requires condition IsClosed.
	// 1. Remove Closed Effect.
	RemoveClosedEffect = new class'X2Effect_RemoveEffects';
	RemoveClosedEffect.EffectNamesToRemove.AddItem(default.ClosedEffectName);
	Template.AddTargetEffect(RemoveClosedEffect);
	// 2. Set value to Open.
	SetOpenValue = new class'X2Effect_SetUnitValue';
	SetOpenValue.UnitName = default.OpenCloseAbilityName;
	SetOpenValue.NewValueToSet = GATEKEEPER_OPEN_VALUE;
	SetOpenValue.CleanupType = eCleanup_BeginTactical;
	Template.AddTargetEffect(SetOpenValue);
	// 3. Set value toggled value.
	SetToggledValue = new class'X2Effect_SetUnitValue';
	SetToggledValue.UnitName = default.ToggledOpenCloseUnitValue;
	SetToggledValue.NewValueToSet = 1;
	SetToggledValue.CleanupType = eCleanup_BeginTurn;
	Template.AddTargetEffect(SetToggledValue);
	// 4. Set Open effect.
	OpenGatekeeperEffect = new class'X2Effect_PerkAttachForFX';
	OpenGatekeeperEffect.EffectName = default.OpenedEffectName;
	Template.AddTargetEffect(OpenGatekeeperEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = GatekeeperOpenClose_BuildVisualization;
	Template.bSkipFireAction = true;
	Template.CinescriptCameraType = "Gatekeeper_Open";

	return Template;
}

static function X2AbilityTemplate CreateGatekeeperCloseAbility(optional Name AbilityName = 'GatekeeperClose')
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local X2Effect_SetUnitValue				SetClosedValue, SetToggledValue;
	local X2Condition_UnitValue				IsOpen;
	local X2Effect_PersistentStatChange		CloseGatekeeperEffect;
	local X2Effect_RemoveEffects            RemoveOpenedEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_gatekepper_shut"; // TODO: This needs to be changed
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.Hostility = eHostility_Neutral;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	// Set up conditions for Open check.
	IsOpen = new class'X2Condition_UnitValue';
	IsOpen.AddCheckValue(default.OpenCloseAbilityName, GATEKEEPER_OPEN_VALUE, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsOpen);

	Template.AbilityShooterConditions.AddItem( default.LivingShooterProperty );

	// ------------
	// Closed effects.  Requires condition IsOpen
	// 1. Set Closed effect.
	CloseGatekeeperEffect = class'X2StatusEffects'.static.CreateGatekeeperClosedEffect();
	Template.AddTargetEffect(CloseGatekeeperEffect);
	// 2. Set value to Closed.
	SetClosedValue = new class'X2Effect_SetUnitValue';
	SetClosedValue.UnitName = default.OpenCloseAbilityName;
	SetClosedValue.NewValueToSet = GATEKEEPER_CLOSED_VALUE;
	SetClosedValue.CleanupType = eCleanup_BeginTactical;
	Template.AddTargetEffect(SetClosedValue);
	// 3. Set value toggled value.
	SetToggledValue = new class'X2Effect_SetUnitValue';
	SetToggledValue.UnitName = default.ToggledOpenCloseUnitValue;
	SetToggledValue.NewValueToSet = 1;
	SetToggledValue.CleanupType = eCleanup_BeginTurn;
	Template.AddTargetEffect(SetToggledValue);
	// 4. Remove Opened Effect.
	RemoveOpenedEffect = new class'X2Effect_RemoveEffects';
	RemoveOpenedEffect.EffectNamesToRemove.AddItem(default.OpenedEffectName);
	Template.AddTargetEffect(RemoveOpenedEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = GatekeeperOpenClose_BuildVisualization;
	Template.bSkipFireAction = true;
	Template.CinescriptCameraType = "Gatekeeper_Close";

	return Template;
}

// This is a special ability that interrupts movement to force a close
// if the Gatekeeper is open
static function X2AbilityTemplate CreateGatekeeperCloseMoveBeginAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger_EventListener    EventListener;

	Template = CreateGatekeeperCloseAbility('GatekeeperCloseMoveBegin');
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilityCosts.Length = 0;

	Template.AbilityTriggers.Length = 0;

	// At the start of a move, if the unit is open, have it close
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'ObjectMoved';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_InterruptSelf;
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	Template.CustomFireAnim = '';
	Template.BuildVisualizationFn = none;
	Template.bSkipFireAction = true;

	return Template;
}

simulated function GatekeeperOpenClose_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          UnitRef;
	local X2Action_AnimSetTransition	GatekeeperTransition;
	local XComGameState_Unit			Gatekeeper;
	local UnitValue						OpenClosedValue;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        ActionMetadata;
	local XComGameStateHistory		History;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	if( Context.IsResultContextHit() )
	{
		History = `XCOMHISTORY;	
		UnitRef = Context.InputContext.SourceObject;

		//Configure the visualization track for the shooter
		//****************************************************************************************
		ActionMetadata = EmptyTrack;
		ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(UnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
		ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(UnitRef.ObjectID);
		ActionMetadata.VisualizeActor = History.GetVisualizer(UnitRef.ObjectID);
		Gatekeeper = XComGameState_Unit(ActionMetadata.StateObject_NewState);

		GatekeeperTransition = X2Action_AnimSetTransition(class'X2Action_AnimSetTransition'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		GatekeeperTransition.Params.AnimName = 'NO_Close'; // Closed by default.

		if( Gatekeeper.GetUnitValue(OpenCloseAbilityName, OpenClosedValue) )
		{
			if( OpenClosedValue.fValue == GATEKEEPER_OPEN_VALUE )
			{
				GatekeeperTransition.Params.AnimName = 'NO_Open';
			}
		}

			}
	//****************************************************************************************
}

static function X2AbilityTemplate CreateRetractDamageListenerAbility()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener EventListener;
	local X2Effect_RunBehaviorTree RetractBehaviorEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RetractDamageListener');
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.bDontDisplayInAbilitySummary = true;

	// This ability fires when the unit takes damage
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitTakeEffectDamage';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	Template.AbilityTargetStyle = default.SelfTarget;

	RetractBehaviorEffect = new class'X2Effect_RunBehaviorTree';
	RetractBehaviorEffect.BehaviorTreeName = 'TryRetract';
	Template.AddTargetEffect(RetractBehaviorEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

// Retract has a chance to close based on a stat contest btwn damage amount and Gatekeeper will.
static function X2AbilityTemplate CreateRetractAbility()
{
	local X2AbilityTemplate Template;
	local X2Condition_UnitValue				IsOpen;
	local X2Effect_SetUnitValue				SetClosedValue;
	local X2Effect_PersistentStatChange		CloseGatekeeperEffect;
	local X2Effect_RemoveEffects            RemoveOpenedEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Retract');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_gatekeeper_retract"; // TODO: This needs to be changed

	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Defensive;

	Template.AdditionalAbilities.AddItem('RetractDamageListener');

	IsOpen = new class'X2Condition_UnitValue';
	IsOpen.AddCheckValue(default.OpenCloseAbilityName, GATEKEEPER_OPEN_VALUE, eCheck_Exact);

	Template.AbilityShooterConditions.AddItem(IsOpen);
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	// 1. Set Closed effect.  
	CloseGatekeeperEffect = class'X2StatusEffects'.static.CreateGatekeeperClosedEffect();
	Template.AddTargetEffect(CloseGatekeeperEffect);
	// 2. Set value to Closed.
	SetClosedValue = new class'X2Effect_SetUnitValue';
	SetClosedValue.UnitName = default.OpenCloseAbilityName;
	SetClosedValue.NewValueToSet = GATEKEEPER_CLOSED_VALUE;
	SetClosedValue.CleanupType = eCleanup_BeginTactical;
	Template.AddTargetEffect(SetClosedValue);
	// 4. Remove Opened Effect.
	RemoveOpenedEffect = new class'X2Effect_RemoveEffects';
	RemoveOpenedEffect.EffectNamesToRemove.AddItem(default.OpenedEffectName);
	Template.AddTargetEffect(RemoveOpenedEffect);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = GatekeeperOpenClose_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate CreateMassPsiReanimationAbility()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCooldown_LocalAndGlobal Cooldown;
	local X2AbilityMultiTarget_Radius RadiusMultiTarget;
	local X2AbilityTarget_Cursor CursorTarget;
	local X2Effect_Knockback KnockbackEffect;
	local X2Effect_ApplyWeaponDamage PsiDamageEffect;
	local X2Condition_UnitProperty UnitPropertyCondition;
	local X2Condition_UnitValue UnitValue;
	local X2Effect_SpawnPsiZombie SpawnZombieEffect;
	local X2Condition_UnitValue	IsOpen;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'AnimaInversion');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_gatekeeper_animainversion";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = true;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = default.MASS_REANIMATION_LOCAL_COOLDOWN;
	Cooldown.NumGlobalTurns = default.MASS_REANIMATION_GLOBAL_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Only available if the Gatekeeper is Open
	IsOpen = new class'X2Condition_UnitValue';
	IsOpen.AddCheckValue(default.OpenCloseAbilityName, GATEKEEPER_OPEN_VALUE, eCheck_Exact, , , 'AA_GatekeeperClosed');
	Template.AbilityShooterConditions.AddItem(IsOpen);

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.MASS_REANIMATION_RADIUS_METERS;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	RadiusMultiTarget.bAllowDeadMultiTargetUnits = true;
	RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	CursorTarget.FixedAbilityRange = default.MASS_REANIMATION_RANGE_METERS;
	Template.AbilityTargetStyle = CursorTarget;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.TargetingMethod = class'X2TargetingMethod_MassPsiReanimation';

	// Everything in the blast radius receives psi damage
	PsiDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	PsiDamageEffect.EffectDamageValue = class'X2Item_DefaultWeapons'.default.GATEKEEPER_MASS_PSI_REANIMATION_BASEDAMAGE;
	PsiDamageEffect.EffectDamageValue.DamageType = 'Psi';
	PsiDamageEffect.bIgnoreArmor = true;
	PsiDamageEffect.bAlwaysKillsCivilians = true;

	// Targets for damage must be alive
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeAlive = false;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	PsiDamageEffect.TargetConditions.AddItem(UnitPropertyCondition);

	Template.AddMultiTargetEffect(PsiDamageEffect);

	// DO NOT CHANGE THE ORDER OF THE DAMAGE AND THIS EFFECT
	// Everything in the blast radius receives the knockback
	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	KnockbackEffect.OverrideRagdollFinishTimerSec = 2.0f;

	// Targets for knockback could have just died must be alive
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeAlive = false;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.FailOnNonUnits = true;
	KnockbackEffect.TargetConditions.AddItem(UnitPropertyCondition);

	Template.AddMultiTargetEffect(KnockbackEffect);
	// DO NOT CHANGE THE ORDER OF THE DAMAGE AND THIS EFFECT

	// DO NOT CHANGE THE ORDER OF THE DAMAGE AND THIS EFFECT
	// Apply this effect to any units that are dead. This will include units
	// killed by the X2Effect_ApplyWeaponDamage above.
	SpawnZombieEffect = new class'X2Effect_SpawnPsiZombie';
	SpawnZombieEffect.AnimationName = 'HL_GetUp_Multi';
	SpawnZombieEffect.BuildPersistentEffect(1);
	SpawnZombieEffect.DamageTypes.AddItem('psi');
	SpawnZombieEffect.StartAnimationMinDelaySec = default.MASS_REANIMATION_ANIMATION_MIN_DELAY_SEC;
	SpawnZombieEffect.StartAnimationMaxDelaySec = default.MASS_REANIMATION_ANIMATION_MAX_DELAY_SEC;

	// The unit must be organic, dead, and not an alien
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeAlive = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeOrganic = false;
	UnitPropertyCondition.ExcludeAlien = true;
	UnitPropertyCondition.ExcludeCivilian = false;
	UnitPropertyCondition.ExcludeCosmetic = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.FailOnNonUnits = true;
	SpawnZombieEffect.TargetConditions.AddItem(UnitPropertyCondition);

	// This effect is only valid if the target has not yet been turned into a zombie
	UnitValue = new class'X2Condition_UnitValue';
	UnitValue.AddCheckValue(class'X2Effect_SpawnPsiZombie'.default.TurnedZombieName, 1, eCheck_LessThan);
	SpawnZombieEffect.TargetConditions.AddItem(UnitValue);

	Template.AddMultiTargetEffect(SpawnZombieEffect);
	// DO NOT CHANGE THE ORDER OF THE DAMAGE AND THIS EFFECT

	Template.bSkipPerkActivationActions = true;
	Template.bSkipPerkActivationActionsSync = false;
	Template.CustomFireAnim = 'NO_AnimaInversion';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = AnimaInversion_BuildVisualization;
	Template.CinescriptCameraType = "Gatekeeper_AnimaInversion";
//BEGIN AUTOGENERATED CODE: Template Overrides 'AnimaInversion'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'AnimaInversion'

	return Template;
}

simulated function AnimaInversion_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability Context;
	local StateObjectReference InteractingUnitRef;
	local VisualizationActionMetadata EmptyTrack;
	local VisualizationActionMetadata GatekeeperTrack, ActionMetadata, ZombieTrack;
	local XComGameState_Unit SpawnedUnit, DeadUnit;
	local UnitValue SpawnedUnitValue;
	local X2Effect_SpawnPsiZombie SpawnPsiZombieEffect;
	local int i, j;
	local name SpawnPsiZombieEffectResult;
	local X2VisualizerInterface TargetVisualizerInterface;
	local X2Action ExitCoverAction;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	GatekeeperTrack = EmptyTrack;
	GatekeeperTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	GatekeeperTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	GatekeeperTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	class'X2Action_AbilityPerkStart'.static.AddToVisualizationTree(GatekeeperTrack, Context);
	ExitCoverAction = class'X2Action_ExitCover'.static.AddToVisualizationTree(GatekeeperTrack, Context);

	//If we were interrupted, insert a marker node for the interrupting visualization code to use. In the move path version above, it is expected for interrupts to be 
	//done during the move.
	if (Context.InterruptionStatus != eInterruptionStatus_None)
	{
		//Insert markers for the subsequent interrupt to insert into
		class'X2Action'.static.AddInterruptMarkerPair(GatekeeperTrack, Context, ExitCoverAction);
	}

	class'X2Action_Fire'.static.AddToVisualizationTree(GatekeeperTrack, Context);
	class'X2Action_EnterCover'.static.AddToVisualizationTree(GatekeeperTrack, Context);
	class'X2Action_AbilityPerkEnd'.static.AddToVisualizationTree(GatekeeperTrack, Context);

	// Configure the visualization track for the multi targets
	//******************************************************************************************
	for( i = 0; i < Context.InputContext.MultiTargets.Length; ++i )
	{
		InteractingUnitRef = Context.InputContext.MultiTargets[i];
		ActionMetadata = EmptyTrack;
		ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
		ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
		ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

		for( j = 0; j < Context.ResultContext.MultiTargetEffectResults[i].Effects.Length; ++j )
		{
			SpawnPsiZombieEffect = X2Effect_SpawnPsiZombie(Context.ResultContext.MultiTargetEffectResults[i].Effects[j]);
			SpawnPsiZombieEffectResult = 'AA_UnknownError';

			if( SpawnPsiZombieEffect != none )
			{
				SpawnPsiZombieEffectResult = Context.ResultContext.MultiTargetEffectResults[i].ApplyResults[j];
			}
			else
			{
				Context.ResultContext.MultiTargetEffectResults[i].Effects[j].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.ResultContext.MultiTargetEffectResults[i].ApplyResults[j]);
			}
		}

		TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
		if( TargetVisualizerInterface != none )
		{
			//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
		}

		if( SpawnPsiZombieEffectResult == 'AA_Success' )
		{
			DeadUnit = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID));
			`assert(DeadUnit != none);
			DeadUnit.GetUnitValue(class'X2Effect_SpawnUnit'.default.SpawnedUnitValueName, SpawnedUnitValue);

			ZombieTrack = EmptyTrack;
			ZombieTrack.StateObject_OldState = History.GetGameStateForObjectID(SpawnedUnitValue.fValue, eReturnType_Reference, VisualizeGameState.HistoryIndex);
			ZombieTrack.StateObject_NewState = ZombieTrack.StateObject_OldState;
			SpawnedUnit = XComGameState_Unit(ZombieTrack.StateObject_NewState);
			`assert(SpawnedUnit != none);
			ZombieTrack.VisualizeActor = History.GetVisualizer(SpawnedUnit.ObjectID);

			SpawnPsiZombieEffect.AddSpawnVisualizationsToTracks(Context, SpawnedUnit, ZombieTrack, DeadUnit, ActionMetadata);
		}
	}

	TypicalAbility_AddEffectRedirects(VisualizeGameState, GatekeeperTrack);
}

static function X2AbilityTemplate CreateAnimaConsumeAbility()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2Condition_UnitValue	IsOpen;
	local X2Condition_UnitProperty TargetPropertyCondition;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2Effect_LifeSteal LifeStealEffect;
	local X2Effect_SpawnPsiZombie SpawnZombieEffect;
	local X2Condition_UnitValue UnitValue;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'AnimaConsume');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_gatekeeper_animaconsume";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';

	Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Set up conditions for Open check.
	IsOpen = new class'X2Condition_UnitValue';
	IsOpen.AddCheckValue(default.OpenCloseAbilityName, GATEKEEPER_OPEN_VALUE, eCheck_Exact, , , 'AA_GatekeeperClosed');
	Template.AbilityShooterConditions.AddItem(IsOpen);

	// Target Conditions
	// This may target friendly or hostile units within melee range
	TargetPropertyCondition = new class'X2Condition_UnitProperty';
	TargetPropertyCondition.ExcludeDead = true;
	TargetPropertyCondition.ExcludeFriendlyToSource = false;
	TargetPropertyCondition.ExcludeHostileToSource = false;
	TargetPropertyCondition.FailOnNonUnits = true;
	TargetPropertyCondition.RequireWithinRange = true;
	TargetPropertyCondition.WithinRange = default.ANIMA_CONSUME_RANGE_UNITS;

	Template.AbilityTargetConditions.AddItem(TargetPropertyCondition);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	Template.AddShooterEffectExclusions();

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue = class'X2Item_DefaultWeapons'.default.Gatekeeper_AnimaConsume_BaseDamage;
	Template.AddTargetEffect(WeaponDamageEffect);

	// Life Steal Effect - Same as damage target but must be organic
	TargetPropertyCondition = new class'X2Condition_UnitProperty';
	TargetPropertyCondition.ExcludeDead = false;
	TargetPropertyCondition.ExcludeFriendlyToSource = false;
	TargetPropertyCondition.ExcludeHostileToSource = false;
	TargetPropertyCondition.FailOnNonUnits = true;
	TargetPropertyCondition.ExcludeRobotic = true;

	LifeStealEffect = new class'X2Effect_LifeSteal';
	LifeStealEffect.LifeAmountMultiplier = default.ANIMA_CONSUME_LIFE_AMOUNT_MULTIPLIER;
	LifeStealEffect.TargetConditions.AddItem(TargetPropertyCondition);
	LifeStealEffect.DamageTypes.AddItem('psi');
	Template.AddTargetEffect(LifeStealEffect);

	// DO NOT CHANGE THE ORDER OF THE DAMAGE AND THIS EFFECT
	// Apply this effect to the target if it died
	SpawnZombieEffect = new class'X2Effect_SpawnPsiZombie';
	SpawnZombieEffect.BuildPersistentEffect(1);
	SpawnZombieEffect.DamageTypes.AddItem('psi');

	// The unit must be organic, dead, and not an alien
	TargetPropertyCondition = new class'X2Condition_UnitProperty';
	TargetPropertyCondition.ExcludeDead = false;
	TargetPropertyCondition.ExcludeAlive = true;
	TargetPropertyCondition.ExcludeRobotic = true;
	TargetPropertyCondition.ExcludeOrganic = false;
	TargetPropertyCondition.ExcludeAlien = true;
	TargetPropertyCondition.ExcludeCivilian = false;
	TargetPropertyCondition.ExcludeCosmetic = true;
	TargetPropertyCondition.ExcludeFriendlyToSource = false;
	TargetPropertyCondition.ExcludeHostileToSource = false;
	TargetPropertyCondition.FailOnNonUnits = true;
	SpawnZombieEffect.TargetConditions.AddItem(TargetPropertyCondition);

	// This effect is only valid if the target has not yet been turned into a zombie
	UnitValue = new class'X2Condition_UnitValue';
	UnitValue.AddCheckValue(class'X2Effect_SpawnPsiZombie'.default.TurnedZombieName, 1, eCheck_LessThan);
	SpawnZombieEffect.TargetConditions.AddItem(UnitValue);

	Template.AddTargetEffect(SpawnZombieEffect);
	// DO NOT CHANGE THE ORDER OF THE DAMAGE AND THIS EFFECT

	Template.CustomFireAnim = 'NO_AnimaConsume';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = AnimaConsume_BuildVisualization;
	Template.CinescriptCameraType = "Gatekeeper_Probe";

	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'AnimaConsume'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'AnimaConsume'

	return Template;
}

simulated function AnimaConsume_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability Context;
	local StateObjectReference InteractingUnitRef;

	local VisualizationActionMetadata EmptyTrack;
	local VisualizationActionMetadata SourceTrack, ActionMetadata, ZombieTrack;
	local XComGameState_Unit SpawnedUnit, DeadUnit;
	local UnitValue SpawnedUnitValue;
	local X2Effect_SpawnPsiZombie SpawnPsiZombieEffect;
	local X2Action ExitCoverAction;
	local int j;
	local name SpawnPsiZombieEffectResult;
	local X2VisualizerInterface TargetVisualizerInterface;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	SourceTrack = EmptyTrack;
	SourceTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	SourceTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	SourceTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	ExitCoverAction = class'X2Action_ExitCover'.static.AddToVisualizationTree(SourceTrack, Context);

	if (Context.InterruptionStatus != eInterruptionStatus_None)
	{
		//Insert markers for the subsequent interrupt to insert into
		class'X2Action'.static.AddInterruptMarkerPair(SourceTrack, Context, ExitCoverAction);
	}

	class'X2Action_Fire'.static.AddToVisualizationTree(SourceTrack, Context);
	class'X2Action_EnterCover'.static.AddToVisualizationTree(SourceTrack, Context);

	// Configure the visualization track for the psi zombie
	//******************************************************************************************
	InteractingUnitRef = Context.InputContext.PrimaryTarget;
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

	for( j = 0; j < Context.ResultContext.TargetEffectResults.Effects.Length; ++j )
	{
		SpawnPsiZombieEffect = X2Effect_SpawnPsiZombie(Context.ResultContext.TargetEffectResults.Effects[j]);
		SpawnPsiZombieEffectResult = 'AA_UnknownError';

		if( SpawnPsiZombieEffect != none )
		{
			SpawnPsiZombieEffectResult = Context.ResultContext.TargetEffectResults.ApplyResults[j];
		}
		else
		{
			// Target effect visualization
			Context.ResultContext.TargetEffectResults.Effects[j].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.ResultContext.TargetEffectResults.ApplyResults[j]);

			// Source effect visualization
			Context.ResultContext.TargetEffectResults.Effects[j].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceTrack, Context.ResultContext.TargetEffectResults.ApplyResults[j]);
		}
	}

	TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
	if( TargetVisualizerInterface != none )
	{
		//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
		TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
	}

	if( SpawnPsiZombieEffectResult == 'AA_Success' )
	{
		DeadUnit = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID));
		`assert(DeadUnit != none);
		DeadUnit.GetUnitValue(class'X2Effect_SpawnUnit'.default.SpawnedUnitValueName, SpawnedUnitValue);

		ZombieTrack = EmptyTrack;
		ZombieTrack.StateObject_OldState = History.GetGameStateForObjectID(SpawnedUnitValue.fValue, eReturnType_Reference, VisualizeGameState.HistoryIndex);
		ZombieTrack.StateObject_NewState = ZombieTrack.StateObject_OldState;
		SpawnedUnit = XComGameState_Unit(ZombieTrack.StateObject_NewState);
		`assert(SpawnedUnit != none);
		ZombieTrack.VisualizeActor = History.GetVisualizer(SpawnedUnit.ObjectID);

		SpawnPsiZombieEffect.AddSpawnVisualizationsToTracks(Context, SpawnedUnit, ZombieTrack, DeadUnit, ActionMetadata);
	}
}

static function X2AbilityTemplate CreateAnimaGateAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2Condition_Visibility            TargetVisibilityCondition;
	local X2Condition_UnitValue				IsClosed;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, 'AnimaGate');

	// Icon Properties
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_standard";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';                                       // color of the icon
	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	//  Normal effect restrictions (except disoriented)
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Set up conditions for Closed check.
	IsClosed = new class'X2Condition_UnitValue';
	IsClosed.AddCheckValue(default.OpenCloseAbilityName, GATEKEEPER_CLOSED_VALUE, eCheck_Exact, , , 'AA_GatekeeperOpened');
	Template.AbilityShooterConditions.AddItem( IsClosed );

	// Targeting Details

	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
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

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue = class'X2Item_DefaultWeapons'.default.GATEKEEPER_WPN_BASEDAMAGE;
	Template.AddTargetEffect(WeaponDamageEffect);

	// Hit Calculation (Different weapons now have different calculations for range)
	Template.AbilityToHitCalc = default.SimpleStandardAim;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;
		
	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;

	Template.AssociatedPassives.AddItem('HoloTargeting');

	// MAKE IT LIVE!
	Template.CustomFireAnim = 'FF_AnimaGate';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "StandardGunFiring";

	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'AnimaGate'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'AnimaGate'

	return Template;	
}

// #######################################################################################
// -------------------- MP Abilities -----------------------------------------------------
// #######################################################################################

static function X2AbilityTemplate CreateMassPsiReanimationMPAbility()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCooldown_LocalAndGlobal Cooldown;
	local X2AbilityMultiTarget_Radius RadiusMultiTarget;
	local X2AbilityTarget_Cursor CursorTarget;
	local X2Effect_Knockback KnockbackEffect;
	local X2Effect_ApplyWeaponDamage PsiDamageEffect;
	local X2Condition_UnitProperty UnitPropertyCondition;
	local X2Condition_UnitValue UnitValue;
	local X2Effect_SpawnPsiZombie SpawnZombieEffect;
	local X2Condition_UnitValue	IsOpen;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'AnimaInversionMP');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_gatekeeper_animainversion";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = true;
	//Template.MP_PerkOverride = 'AnimaInversion';

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = default.MASS_REANIMATION_LOCAL_COOLDOWN;
	Cooldown.NumGlobalTurns = default.MASS_REANIMATION_GLOBAL_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Only available if the Gatekeeper is Open
	IsOpen = new class'X2Condition_UnitValue';
	IsOpen.AddCheckValue(default.OpenCloseAbilityName, GATEKEEPER_OPEN_VALUE, eCheck_Exact, , , 'AA_GatekeeperClosed');
	Template.AbilityShooterConditions.AddItem(IsOpen);

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.MASS_REANIMATION_RADIUS_METERS;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	RadiusMultiTarget.bAllowDeadMultiTargetUnits = true;
	RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	CursorTarget.FixedAbilityRange = default.MASS_REANIMATION_RANGE_METERS;
	Template.AbilityTargetStyle = CursorTarget;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.TargetingMethod = class'X2TargetingMethod_MassPsiReanimation';

	// Everything in the blast radius receives psi damage
	PsiDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	PsiDamageEffect.EffectDamageValue = class'X2Item_DefaultWeapons'.default.GATEKEEPER_MASS_PSI_REANIMATION_BASEDAMAGE;
	PsiDamageEffect.EffectDamageValue.DamageType = 'Psi';
	PsiDamageEffect.bIgnoreArmor = true;
	PsiDamageEffect.bAlwaysKillsCivilians = true;

	// Targets for damage must be alive
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeAlive = false;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	PsiDamageEffect.TargetConditions.AddItem(UnitPropertyCondition);

	Template.AddMultiTargetEffect(PsiDamageEffect);

	// DO NOT CHANGE THE ORDER OF THE DAMAGE AND THIS EFFECT
	// Everything in the blast radius receives the knockback
	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	KnockbackEffect.OverrideRagdollFinishTimerSec = 2.0f;

	// Targets for knockback could have just died must be alive
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeAlive = false;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.FailOnNonUnits = true;
	KnockbackEffect.TargetConditions.AddItem(UnitPropertyCondition);

	Template.AddMultiTargetEffect(KnockbackEffect);
	// DO NOT CHANGE THE ORDER OF THE DAMAGE AND THIS EFFECT

	// DO NOT CHANGE THE ORDER OF THE DAMAGE AND THIS EFFECT
	// Apply this effect to any units that are dead. This will include units
	// killed by the X2Effect_ApplyWeaponDamage above.
	SpawnZombieEffect = new class'X2Effect_SpawnPsiZombie';
	SpawnZombieEffect.UnitToSpawnName = 'PsiZombieMP';
	SpawnZombieEffect.AltUnitToSpawnName = 'PsiZombieHumanMP';
	SpawnZombieEffect.AnimationName = 'HL_GetUp_Multi';
	SpawnZombieEffect.BuildPersistentEffect(1);
	SpawnZombieEffect.DamageTypes.AddItem('psi');
	SpawnZombieEffect.StartAnimationMinDelaySec = default.MASS_REANIMATION_ANIMATION_MIN_DELAY_SEC;
	SpawnZombieEffect.StartAnimationMaxDelaySec = default.MASS_REANIMATION_ANIMATION_MAX_DELAY_SEC;

	// The unit must be organic, dead, and not an alien
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeAlive = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeOrganic = false;
	UnitPropertyCondition.ExcludeAlien = true;
	UnitPropertyCondition.ExcludeCivilian = false;
	UnitPropertyCondition.ExcludeCosmetic = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.FailOnNonUnits = true;
	SpawnZombieEffect.TargetConditions.AddItem(UnitPropertyCondition);

	// This effect is only valid if the target has not yet been turned into a zombie
	UnitValue = new class'X2Condition_UnitValue';
	UnitValue.AddCheckValue(class'X2Effect_SpawnPsiZombie'.default.TurnedZombieName, 1, eCheck_LessThan);
	SpawnZombieEffect.TargetConditions.AddItem(UnitValue);

	Template.AddMultiTargetEffect(SpawnZombieEffect);
	// DO NOT CHANGE THE ORDER OF THE DAMAGE AND THIS EFFECT

	Template.bSkipPerkActivationActions = true;
	Template.bSkipPerkActivationActionsSync = false;
	Template.CustomFireAnim = 'NO_AnimaInversion';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = AnimaInversion_BuildVisualization;
	Template.CinescriptCameraType = "Gatekeeper_AnimaInversion";
//BEGIN AUTOGENERATED CODE: Template Overrides 'AnimaInversionMP'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'AnimaInversionMP'

	return Template;
}

simulated function AnimaInversionMP_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability Context;
	local StateObjectReference InteractingUnitRef;
	local VisualizationActionMetadata EmptyTrack;
	local VisualizationActionMetadata GatekeeperTrack, ActionMetadata, ZombieTrack;
	local XComGameState_Unit SpawnedUnit, DeadUnit;
	local UnitValue SpawnedUnitValue;
	local X2Effect_SpawnPsiZombie SpawnPsiZombieEffect;
	local int i, j;
	local name SpawnPsiZombieEffectResult;
	local X2VisualizerInterface TargetVisualizerInterface;
	local X2Action ExitCoverAction;

	History = `XCOMHISTORY;

		Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	GatekeeperTrack = EmptyTrack;
	GatekeeperTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	GatekeeperTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	GatekeeperTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	class'X2Action_AbilityPerkStart'.static.AddToVisualizationTree(GatekeeperTrack, Context);
	ExitCoverAction = class'X2Action_ExitCover'.static.AddToVisualizationTree(GatekeeperTrack, Context);

	//If we were interrupted, insert a marker node for the interrupting visualization code to use. In the move path version above, it is expected for interrupts to be 
	//done during the move.
	if (Context.InterruptionStatus != eInterruptionStatus_None)
	{
		//Insert markers for the subsequent interrupt to insert into
		class'X2Action'.static.AddInterruptMarkerPair(GatekeeperTrack, Context, ExitCoverAction);
	}

	class'X2Action_Fire'.static.AddToVisualizationTree(GatekeeperTrack, Context);
	class'X2Action_EnterCover'.static.AddToVisualizationTree(GatekeeperTrack, Context);
	class'X2Action_AbilityPerkEnd'.static.AddToVisualizationTree(GatekeeperTrack, Context);

	// Configure the visualization track for the multi targets
	//******************************************************************************************
	for(i = 0; i < Context.InputContext.MultiTargets.Length; ++i)
	{
		InteractingUnitRef = Context.InputContext.MultiTargets[i];
		ActionMetadata = EmptyTrack;
		ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
		ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
		ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

		for(j = 0; j < Context.ResultContext.MultiTargetEffectResults[i].Effects.Length; ++j)
		{
			SpawnPsiZombieEffect = X2Effect_SpawnPsiZombie(Context.ResultContext.MultiTargetEffectResults[i].Effects[j]);
			SpawnPsiZombieEffectResult = 'AA_UnknownError';

			if(SpawnPsiZombieEffect != none)
			{
				SpawnPsiZombieEffectResult = Context.ResultContext.MultiTargetEffectResults[i].ApplyResults[j];
			}
			else
			{
				Context.ResultContext.MultiTargetEffectResults[i].Effects[j].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.ResultContext.MultiTargetEffectResults[i].ApplyResults[j]);
			}
		}

		TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
		if(TargetVisualizerInterface != none)
		{
			//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
		}

		if(SpawnPsiZombieEffectResult == 'AA_Success')
		{
			DeadUnit = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID));
			`assert(DeadUnit != none);
			DeadUnit.GetUnitValue(class'X2Effect_SpawnUnit'.default.SpawnedUnitValueName, SpawnedUnitValue);

			ZombieTrack = EmptyTrack;
			ZombieTrack.StateObject_OldState = History.GetGameStateForObjectID(SpawnedUnitValue.fValue, eReturnType_Reference, VisualizeGameState.HistoryIndex);
			ZombieTrack.StateObject_NewState = ZombieTrack.StateObject_OldState;
			SpawnedUnit = XComGameState_Unit(ZombieTrack.StateObject_NewState);
			`assert(SpawnedUnit != none);
			ZombieTrack.VisualizeActor = History.GetVisualizer(SpawnedUnit.ObjectID);

			SpawnPsiZombieEffect.AddSpawnVisualizationsToTracks(Context, SpawnedUnit, ZombieTrack, DeadUnit, ActionMetadata);
		}
	}
}

static function X2AbilityTemplate CreateAnimaConsumeMPAbility()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2Condition_UnitValue	IsOpen;
	local X2Condition_UnitProperty TargetPropertyCondition;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2Effect_LifeSteal LifeStealEffect;
	local X2Effect_SpawnPsiZombie SpawnZombieEffect;
	local X2Condition_UnitValue UnitValue;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'AnimaConsumeMP');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_gatekeeper_animaconsume";
	Template.MP_PerkOverride = 'AnimaConsume';

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';

	Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Set up conditions for Open check.
	IsOpen = new class'X2Condition_UnitValue';
	IsOpen.AddCheckValue(default.OpenCloseAbilityName, GATEKEEPER_OPEN_VALUE, eCheck_Exact, , , 'AA_GatekeeperClosed');
	Template.AbilityShooterConditions.AddItem(IsOpen);

	// Target Conditions
	// This may target friendly or hostile units within melee range
	TargetPropertyCondition = new class'X2Condition_UnitProperty';
	TargetPropertyCondition.ExcludeDead = true;
	TargetPropertyCondition.ExcludeFriendlyToSource = false;
	TargetPropertyCondition.ExcludeHostileToSource = false;
	TargetPropertyCondition.FailOnNonUnits = true;
	TargetPropertyCondition.RequireWithinRange = true;
	TargetPropertyCondition.WithinRange = default.ANIMA_CONSUME_RANGE_UNITS;

	Template.AbilityTargetConditions.AddItem(TargetPropertyCondition);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	Template.AddShooterEffectExclusions();

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue = class'X2Item_DefaultWeapons'.default.Gatekeeper_AnimaConsume_BaseDamage;
	Template.AddTargetEffect(WeaponDamageEffect);

	// Life Steal Effect - Same as damage target but must be organic
	TargetPropertyCondition = new class'X2Condition_UnitProperty';
	TargetPropertyCondition.ExcludeDead = false;
	TargetPropertyCondition.ExcludeFriendlyToSource = false;
	TargetPropertyCondition.ExcludeHostileToSource = false;
	TargetPropertyCondition.FailOnNonUnits = true;
	TargetPropertyCondition.ExcludeRobotic = true;

	LifeStealEffect = new class'X2Effect_LifeSteal';
	LifeStealEffect.LifeAmountMultiplier = default.ANIMA_CONSUME_LIFE_AMOUNT_MULTIPLIER;
	LifeStealEffect.TargetConditions.AddItem(TargetPropertyCondition);
	LifeStealEffect.DamageTypes.AddItem('psi');
	Template.AddTargetEffect(LifeStealEffect);

	// DO NOT CHANGE THE ORDER OF THE DAMAGE AND THIS EFFECT
	// Apply this effect to the target if it died
	SpawnZombieEffect = new class'X2Effect_SpawnPsiZombie';
	SpawnZombieEffect.UnitToSpawnName = 'PsiZombieMP';
	SpawnZombieEffect.AltUnitToSpawnName = 'PsiZombieHumanMP';
	SpawnZombieEffect.BuildPersistentEffect(1);
	SpawnZombieEffect.DamageTypes.AddItem('psi');

	// The unit must be organic, dead, and not an alien
	TargetPropertyCondition = new class'X2Condition_UnitProperty';
	TargetPropertyCondition.ExcludeDead = false;
	TargetPropertyCondition.ExcludeAlive = true;
	TargetPropertyCondition.ExcludeRobotic = true;
	TargetPropertyCondition.ExcludeOrganic = false;
	TargetPropertyCondition.ExcludeAlien = true;
	TargetPropertyCondition.ExcludeCivilian = false;
	TargetPropertyCondition.ExcludeCosmetic = true;
	TargetPropertyCondition.ExcludeFriendlyToSource = false;
	TargetPropertyCondition.ExcludeHostileToSource = false;
	TargetPropertyCondition.FailOnNonUnits = true;
	SpawnZombieEffect.TargetConditions.AddItem(TargetPropertyCondition);

	// This effect is only valid if the target has not yet been turned into a zombie
	UnitValue = new class'X2Condition_UnitValue';
	UnitValue.AddCheckValue(class'X2Effect_SpawnPsiZombie'.default.TurnedZombieName, 1, eCheck_LessThan);
	SpawnZombieEffect.TargetConditions.AddItem(UnitValue);

	Template.AddTargetEffect(SpawnZombieEffect);
	// DO NOT CHANGE THE ORDER OF THE DAMAGE AND THIS EFFECT

	Template.CustomFireAnim = 'NO_AnimaConsume';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = AnimaConsumeMP_BuildVisualization;
	Template.CinescriptCameraType = "Gatekeeper_Probe";
//BEGIN AUTOGENERATED CODE: Template Overrides 'AnimaConsumeMP'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'AnimaConsumeMP'

	return Template;
}

simulated function AnimaConsumeMP_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability Context;
	local StateObjectReference InteractingUnitRef;

	local VisualizationActionMetadata EmptyTrack;
	local VisualizationActionMetadata SourceTrack, ActionMetadata, ZombieTrack;
	local XComGameState_Unit SpawnedUnit, DeadUnit;
	local UnitValue SpawnedUnitValue;
	local X2Effect_SpawnPsiZombie SpawnPsiZombieEffect;
	local int j;
	local name SpawnPsiZombieEffectResult;
	local X2VisualizerInterface TargetVisualizerInterface;
	local X2Action ExitCoverAction;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	SourceTrack = EmptyTrack;
	SourceTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	SourceTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	SourceTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	ExitCoverAction = class'X2Action_ExitCover'.static.AddToVisualizationTree(SourceTrack, Context);

	//If we were interrupted, insert a marker node for the interrupting visualization code to use. In the move path version above, it is expected for interrupts to be 
	//done during the move.
	if (Context.InterruptionStatus != eInterruptionStatus_None)
	{
		//Insert markers for the subsequent interrupt to insert into
		class'X2Action'.static.AddInterruptMarkerPair(SourceTrack, Context, ExitCoverAction);
	}

	class'X2Action_Fire'.static.AddToVisualizationTree(SourceTrack, Context);
	class'X2Action_EnterCover'.static.AddToVisualizationTree(SourceTrack, Context);

	// Configure the visualization track for the psi zombie
	//******************************************************************************************
	InteractingUnitRef = Context.InputContext.PrimaryTarget;
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

	for(j = 0; j < Context.ResultContext.TargetEffectResults.Effects.Length; ++j)
	{
		SpawnPsiZombieEffect = X2Effect_SpawnPsiZombie(Context.ResultContext.TargetEffectResults.Effects[j]);
		SpawnPsiZombieEffectResult = 'AA_UnknownError';

		if(SpawnPsiZombieEffect != none)
		{
			SpawnPsiZombieEffectResult = Context.ResultContext.TargetEffectResults.ApplyResults[j];
		}
		else
		{
			// Target effect visualization
			Context.ResultContext.TargetEffectResults.Effects[j].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.ResultContext.TargetEffectResults.ApplyResults[j]);

			// Source effect visualization
			Context.ResultContext.TargetEffectResults.Effects[j].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceTrack, Context.ResultContext.TargetEffectResults.ApplyResults[j]);
		}
	}

	TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
	if(TargetVisualizerInterface != none)
	{
		//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
		TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
	}

	if(SpawnPsiZombieEffectResult == 'AA_Success')
	{
		DeadUnit = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID));
		`assert(DeadUnit != none);
		DeadUnit.GetUnitValue(class'X2Effect_SpawnUnit'.default.SpawnedUnitValueName, SpawnedUnitValue);

		ZombieTrack = EmptyTrack;
		ZombieTrack.StateObject_OldState = History.GetGameStateForObjectID(SpawnedUnitValue.fValue, eReturnType_Reference, VisualizeGameState.HistoryIndex);
		ZombieTrack.StateObject_NewState = ZombieTrack.StateObject_OldState;
		SpawnedUnit = XComGameState_Unit(ZombieTrack.StateObject_NewState);
		`assert(SpawnedUnit != none);
		ZombieTrack.VisualizeActor = History.GetVisualizer(SpawnedUnit.ObjectID);

		SpawnPsiZombieEffect.AddSpawnVisualizationsToTracks(Context, SpawnedUnit, ZombieTrack, DeadUnit, ActionMetadata);
	}
}

DefaultProperties
{
	OpenCloseAbilityName="Open/ClosedState"
	ToggledOpenCloseUnitValue="ToggledOpenCloseUnitValue"
	ClosedEffectName="GatekeeperClosedEffect"
	OpenedEffectName="GatekeeperOpenEffect"
}
