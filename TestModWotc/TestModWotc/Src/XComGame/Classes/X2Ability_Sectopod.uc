//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    X2Ability_Sectopod.uc    
//  AUTHOR:  Alex Cheng  --  4/24/2015
//  PURPOSE: Sectopod ability definitions 
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Ability_Sectopod extends X2Ability
	config(GameData_SoldierSkills);

var name HighLowValueName;
var name HeightChangeEffectName;
var config int WRATH_CANNON_LOCAL_COOLDOWN;
var config int WRATH_CANNON_GLOBAL_COOLDOWN;
var config int WRATH_CANNON_ENVIRONMENT_DAMAGE_AMOUNT;
var config int LIGHTNINGFIELD_LOCAL_COOLDOWN;
var config int LIGHTNINGFIELD_GLOBAL_COOLDOWN;
var config float LIGHTNINGFIELD_TILE_RADIUS;
var config int HEIGHT_ADVANTAGE_BONUS;
var config int HEIGHT_CHANGE_DELTA;
var int HIGH_STANCE_ENV_DAMAGE_AMOUNT;
var int HIGH_STANCE_IMPULSE_AMOUNT;

var privatewrite name WrathCannonAbilityName;
var deprecated name WrathCannonStage1DelayEffectName;

var name WrathCannonStage1EffectName;

var privatewrite name WrathCannonStage1AbilityName;
var privatewrite name WrathCannonStage2AbilityName;

const SECTOPOD_LOW_VALUE=0;	// Arbitrary value designated as LOW value
const SECTOPOD_HIGH_VALUE=1;		// Arbitrary value designated as HIGH value

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateBlasterShotAbility()); // Standard shot that does not end the turn.
	Templates.AddItem(CreateBlasterShotDuringCannonAbility());
	Templates.AddItem(CreateWrathCannonStage1Ability()); // Main gun attack - AoE delayed action.
	Templates.AddItem(CreateWrathCannonStage2Ability());
	Templates.AddItem(CreateWrathCannonAbility());
	Templates.AddItem(CreateSectopodHighAbility());
	Templates.AddItem(CreateSectopodLowAbility());
	Templates.AddItem(CreateSectopodLightningFieldAbility());
	Templates.AddItem(CreateInitialStateAbility());
	Templates.AddItem(CreateTeamChangeHandlerAbility());
	Templates.AddItem(PurePassive('SectopodImmunities', "img:///UILibrary_PerkIcons.UIPerk_immunities"));

	return Templates;
}

// Wrath cannon.
static function X2AbilityTemplate CreateWrathCannonAbility()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCooldown_LocalAndGlobal Cooldown;
	local X2AbilityMultiTarget_Line         LineMultiTarget;
	local X2AbilityTarget_Cursor CursorTarget;
	local X2Condition_UnitProperty UnitProperty;
	local X2Effect_ApplyWeaponDamage DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.WrathCannonAbilityName);
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_sectopod_wrathcannon"; // TODO: Change this icon
	Template.Hostility = eHostility_Offensive;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.bShowActivation = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = default.WRATH_CANNON_LOCAL_COOLDOWN;
	Cooldown.NumGlobalTurns = default.WRATH_CANNON_GLOBAL_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	UnitProperty = new class'X2Condition_UnitProperty';
	UnitProperty.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitProperty);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AddShooterEffectExclusions();
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.TargetingMethod = class'X2TargetingMethod_Line'; 

	// The target locations are enemies
	UnitProperty = new class'X2Condition_UnitProperty';
	UnitProperty.ExcludeFriendlyToSource = true;
	UnitProperty.ExcludeCivilian = true;
	UnitProperty.ExcludeDead = true;
	UnitProperty.IsOutdoors = true;
	UnitProperty.HasClearanceToMaxZ = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitProperty);

	LineMultiTarget = new class'X2AbilityMultiTarget_Line';
	LineMultiTarget.TileWidthExtension = 1;
	Template.AbilityMultiTargetStyle = LineMultiTarget;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = 15;
	Template.AbilityTargetStyle = CursorTarget;

	// The MultiTarget Units are dealt this damage
	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.EnvironmentalDamageAmount = default.WRATH_CANNON_ENVIRONMENT_DAMAGE_AMOUNT;
	DamageEffect.bExplosiveDamage = true;
	Template.AddMultiTargetEffect(DamageEffect);
	Template.AddMultiTargetEffect(new class'X2Effect_ApplyFireToWorld');

	Template.CustomFireAnim = 'FF_WrathCannonFire';
	Template.ModifyNewContextFn = WrathCannon_ModifyActivatedAbilityContext;
	Template.BuildNewGameStateFn = WrathCannon_BuildGameState;
	Template.BuildVisualizationFn = WrathCannon_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.CinescriptCameraType = "Sectopod_WrathCannon_Stage2";
//BEGIN AUTOGENERATED CODE: Template Overrides 'WrathCannon'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'WrathCannon'

	return Template;
}
// Need to rebuild the multiple targets in our AoE.
simulated function WrathCannon_ModifyActivatedAbilityContext(XComGameStateContext Context)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameStateHistory History;
	local int i;
	local X2AbilityMultiTargetStyle LineMultiTarget;
	local XComGameState_Ability AbilityState;
	local AvailableTarget MultiTargets;

	History = `XCOMHISTORY;

	AbilityContext = XComGameStateContext_Ability(Context);

	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID, eReturnType_Reference));

	// Build the MultiTarget array based upon the impact points
	LineMultiTarget = AbilityState.GetMyTemplate().AbilityMultiTargetStyle;// new class'X2AbilityMultiTarget_Radius';
	for( i = 0; i < AbilityContext.InputContext.TargetLocations.Length; ++i )
	{
		LineMultiTarget.GetMultiTargetsForLocation(AbilityState, AbilityContext.InputContext.TargetLocations[i], MultiTargets);
	}

	AbilityContext.InputContext.MultiTargets = MultiTargets.AdditionalTargets;
}

function XComGameState WrathCannon_BuildGameState(XComGameStateContext Context)
{
	local XComGameState NewState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit UnitState;
	local Vector TargetLocation;
	local Vector UnitLocation;
	local TTile UnitTile;
	local Rotator DesiredOrientation;

	NewState = TypicalAbility_BuildGameState(Context);

	AbilityContext = XComGameStateContext_Ability(NewState.GetContext());
	UnitState = XComGameState_Unit(NewState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID, eReturnType_Reference));
	if( UnitState == None )
	{
		UnitState = XComGameState_Unit(NewState.ModifyStateObject(class'XComGameState_Unit', AbilityContext.InputContext.SourceObject.ObjectID));
	}

	TargetLocation = AbilityContext.InputContext.TargetLocations[0];
	UnitTile = UnitState.TileLocation;
	UnitLocation = `XWORLD.GetPositionFromTileCoordinates(UnitTile);

	DesiredOrientation = Rotator(TargetLocation - UnitLocation);
	DesiredOrientation.Pitch = 0;

	UnitState.MoveOrientation = DesiredOrientation;

	return NewState;
}

simulated function WrathCannon_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  AbilityContext;
	local StateObjectReference InteractingUnitRef;
	local X2AbilityTemplate AbilityTemplate;
	local VisualizationActionMetadata EmptyTrack, ActionMetadata;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyover;
	local X2Action_MoveTurn MoveTurnAction;


//	local X2Action_PersistentEffect	PersistentEffectAction;
	local X2Action_Fire FireAction;
	local X2Action_PlayAnimation PlayAnimation;
	local X2Action_PlayAnimation ResumeAnimation;
	local XComGameState_EnvironmentDamage EnvironmentDamageEvent;
	local XComGameState_WorldEffectTileData WorldDataUpdate;
	local array<X2Effect>               MultiTargetEffects;
	local int i, j, EffectIndex;
	local X2VisualizerInterface TargetVisualizerInterface;

	History = `XCOMHISTORY;

	AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = AbilityContext.InputContext.SourceObject;

	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);

	//****************************************************************************************
	//Configure the visualization track for the source
	//****************************************************************************************
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocFlyOverText, '', eColor_Good);

	// Turn to face the target action. The target location is the center of the ability's radius, stored in the 0 index of the TargetLocations
	MoveTurnAction = X2Action_MoveTurn(class'X2Action_MoveTurn'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	MoveTurnAction.m_vFacePoint = AbilityContext.InputContext.TargetLocations[0];

	// Play the start animation to prepare to fire.
	PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	PlayAnimation.Params.AnimName = 'NO_WrathCannonStart';

	// Play the firing action.  (Animation set in template.)
	FireAction = X2Action_Fire(class'X2Action_Fire'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	FireAction.SetFireParameters(true);

	// Play the animation to get him to his looping idle
	ResumeAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	ResumeAnimation.Params.AnimName = 'NO_WrathCannonStopA';

	
	//If there are effects added to the shooter, add the visualizer actions for them
	for( EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityShooterEffects.Length; ++EffectIndex )
	{
		AbilityTemplate.AbilityShooterEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, AbilityContext.FindShooterEffectApplyResult(AbilityTemplate.AbilityShooterEffects[EffectIndex]));
	}

	//****************************************************************************************
	//Configure the visualization track for the targets
	//****************************************************************************************
	for( i = 0; i < AbilityContext.InputContext.MultiTargets.Length; ++i )
	{
		InteractingUnitRef = AbilityContext.InputContext.MultiTargets[i];
		ActionMetadata = EmptyTrack;
		ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
		ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
		ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, AbilityContext);
		for( j = 0; j < AbilityContext.ResultContext.MultiTargetEffectResults[i].Effects.Length; ++j )
		{
			AbilityContext.ResultContext.MultiTargetEffectResults[i].Effects[j].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, AbilityContext.ResultContext.MultiTargetEffectResults[i].ApplyResults[j]);
		}

		TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
		if( TargetVisualizerInterface != none )
		{
			//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
		}
	}
	MultiTargetEffects = AbilityTemplate.AbilityMultiTargetEffects;
	//****************************************************************************************
	//Configure the visualization tracks for the environment
	//****************************************************************************************
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamageEvent)
	{
		ActionMetadata = EmptyTrack;
		ActionMetadata.VisualizeActor = none;
		ActionMetadata.StateObject_NewState = EnvironmentDamageEvent;
		ActionMetadata.StateObject_OldState = EnvironmentDamageEvent;

		//Wait until signaled by the shooter that the projectiles are hitting
		if( !AbilityTemplate.bSkipFireAction )
		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, AbilityContext);

		for( EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityShooterEffects.Length; ++EffectIndex )
		{
			AbilityTemplate.AbilityShooterEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');
		}

		for( EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex )
		{
			AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');
		}

		for( EffectIndex = 0; EffectIndex < MultiTargetEffects.Length; ++EffectIndex )
		{
			MultiTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');
		}

			}

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_WorldEffectTileData', WorldDataUpdate)
	{
		ActionMetadata = EmptyTrack;
		ActionMetadata.VisualizeActor = none;
		ActionMetadata.StateObject_NewState = WorldDataUpdate;
		ActionMetadata.StateObject_OldState = WorldDataUpdate;

		//Wait until signaled by the shooter that the projectiles are hitting
		if( !AbilityTemplate.bSkipFireAction )
		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, AbilityContext);

		for( EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityShooterEffects.Length; ++EffectIndex )
		{
			AbilityTemplate.AbilityShooterEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');
		}

		for( EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex )
		{
			AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');
		}

		for( EffectIndex = 0; EffectIndex < MultiTargetEffects.Length; ++EffectIndex )
		{
			MultiTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');
		}

			}
	//****************************************************************************************
}



// - Blaster Shot -  Similar to standard shot, except it does not end the turn.
static function X2AbilityTemplate CreateBlasterShotAbility(optional Name TemplateName = 'Blaster')
{
	local X2AbilityTemplate	Template;
	local int				AbilityCostIndex;

	Template = class'X2Ability_WeaponCommon'.static.Add_StandardShot(TemplateName);
	
	// Set to not end the turn.
	for( AbilityCostIndex = 0; AbilityCostIndex < Template.AbilityCosts.Length; ++AbilityCostIndex )
	{
		if( Template.AbilityCosts[AbilityCostIndex].IsA('X2AbilityCost_ActionPoints') )
		{
			X2AbilityCost_ActionPoints(Template.AbilityCosts[AbilityCostIndex]).bConsumeAllPoints = false;
		}
	}

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideIfOtherAvailable;
	Template.HideIfAvailable.AddItem('BlasterDuringCannon');
//BEGIN AUTOGENERATED CODE: Template Overrides 'Blaster'
//BEGIN AUTOGENERATED CODE: Template Overrides 'BlasterDuringCannon'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'BlasterDuringCannon'
//END AUTOGENERATED CODE: Template Overrides 'Blaster'

	return Template;
}

static function X2AbilityTemplate CreateBlasterShotDuringCannonAbility()
{
	local X2AbilityTemplate	Template;
	local X2Condition_UnitEffects UnitEffects;

	Template = CreateBlasterShotAbility('BlasterDuringCannon');
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.HideIfAvailable.Length = 0;

	Template.bDontDisplayInAbilitySummary = true;
	UnitEffects = new class'X2Condition_UnitEffects';
	UnitEffects.AddRequireEffect(default.WrathCannonStage1EffectName, 'AA_AbilityUnavailable');
	Template.AbilityShooterConditions.AddItem(UnitEffects);

	Template.CustomFireAnim = 'FF_FireWeaponA';
	Template.ActionFireClass = class'X2Action_Fire_WeaponOnly';

	return Template;
}

static function X2Effect_Persistent CreateHeightChangeStatusEffect( )
{
	local X2Effect_Persistent   PersistentEffect;

	PersistentEffect = new class'X2Effect_Persistent';
	PersistentEffect.EffectName = default.HeightChangeEffectName;
	PersistentEffect.DuplicateResponse = eDupe_Ignore;
	PersistentEffect.BuildPersistentEffect( 1, true, false );
	PersistentEffect.EffectAddedFn = StandUpEffectAdded;
	PersistentEffect.EffectRemovedFn = StandUpEffectRemoved;

	return PersistentEffect;
}

static function StandUpEffectAdded( X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState )
{
	local XComGameState_Unit UnitState;

	// change the height
	UnitState = XComGameState_Unit( NewGameState.ModifyStateObject( class'XComGameState_Unit', ApplyEffectParameters.TargetStateObjectRef.ObjectID ) );
	UnitState.UnitHeight += default.HEIGHT_CHANGE_DELTA;

	// trigger a move event for new visibility state/tile occupancy
	`XEVENTMGR.TriggerEvent( 'UnitMoveFinished', UnitState, UnitState, NewGameState );
}

static function StandUpEffectRemoved( X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed )
{
	local XComGameState_Unit UnitState;

	// change the height
	UnitState = XComGameState_Unit( NewGameState.ModifyStateObject( class'XComGameState_Unit', ApplyEffectParameters.TargetStateObjectRef.ObjectID ) );
	UnitState.UnitHeight -= default.HEIGHT_CHANGE_DELTA;

	// trigger a move event for new visibility state/tile occupancy
	`XEVENTMGR.TriggerEvent( 'UnitMoveFinished', UnitState, UnitState, NewGameState );
}

static function X2AbilityTemplate CreateSectopodHighAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local X2Effect_SetUnitValue				SetHighValue;
	local X2Condition_UnitValue				IsLow;
	local X2Condition_UnitValue				IsNotImmobilized;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SectopodHigh');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_sectopod_heightchange"; // TODO: This needs to be changed
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

	// Set up conditions for Low check.
	IsLow = new class'X2Condition_UnitValue';
	IsLow.AddCheckValue(default.HighLowValueName, SECTOPOD_LOW_VALUE, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsLow);

	IsNotImmobilized = new class'X2Condition_UnitValue';
	IsNotImmobilized.AddCheckValue(class'X2Ability_DefaultAbilitySet'.default.ImmobilizedValueName, 0);
	Template.AbilityShooterConditions.AddItem(IsNotImmobilized);

	Template.AbilityShooterConditions.AddItem( default.LivingShooterProperty );

	// ------------
	// High effect.  
	// Set value to High.
	SetHighValue = new class'X2Effect_SetUnitValue';
	SetHighValue.UnitName = default.HighLowValueName;
	SetHighValue.NewValueToSet = SECTOPOD_HIGH_VALUE;
	SetHighValue.CleanupType = eCleanup_BeginTactical;
	Template.AddTargetEffect(SetHighValue);

	Template.AddTargetEffect( CreateHeightChangeStatusEffect() );

	Template.BuildNewGameStateFn = SectopodHigh_BuildGameState;
	Template.BuildVisualizationFn = SectopodHighLow_BuildVisualization;
	Template.bSkipFireAction = true;
	Template.CinescriptCameraType = "Sectopod_HighStance";
	
	return Template;
}

function XComGameState SectopodHigh_BuildGameState(XComGameStateContext Context)
{
	local XComGameState NewState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit UnitState, OldUnitState;
	local Vector UnitLocation;
	local TTile UnitTile;
	local XComGameState_EnvironmentDamage DamageEvent;
	local array<TTile> OldTiles, NewTiles;

	NewState = TypicalAbility_BuildGameState(Context);

	AbilityContext = XComGameStateContext_Ability(NewState.GetContext());
	UnitState = XComGameState_Unit(NewState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID, eReturnType_Reference));

	UnitTile = UnitState.TileLocation;
	UnitTile.Z += UnitState.UnitHeight;
	UnitLocation = `XWORLD.GetPositionFromTileCoordinates(UnitTile);
	DamageEvent = XComGameState_EnvironmentDamage(NewState.CreateNewStateObject(class'XComGameState_EnvironmentDamage'));
	DamageEvent.DEBUG_SourceCodeLocation = "UC: X2Ability_Sectopod:SectopodHigh_BuildGameState";
	DamageEvent.DamageAmount = HIGH_STANCE_ENV_DAMAGE_AMOUNT;
	DamageEvent.DamageTypeTemplateName = 'NoFireExplosion';
	DamageEvent.HitLocation = UnitLocation;
	DamageEvent.PhysImpulse = HIGH_STANCE_IMPULSE_AMOUNT;

	// This unit gamestate should already be in the high position at this point.  Destroy stuff in these tiles.
	// Update - only destroy stuff in the tiles that have become occupied.
	OldUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID, eReturnType_Reference));
	OldUnitState.GetVisibilityLocation(OldTiles);
	UnitState.GetVisibilityLocation(NewTiles); 
	class'Helpers'.static.RemoveTileSubset(DamageEvent.DamageTiles, NewTiles, OldTiles);

	DamageEvent.DamageCause = UnitState.GetReference();
	DamageEvent.DamageSource = DamageEvent.DamageCause;

	return NewState;
}
static function X2AbilityTemplate CreateSectopodLowAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local X2Effect_SetUnitValue				SetLowValue;
	local X2Condition_UnitValue				IsHigh;
	local X2Condition_UnitValue				IsNotImmobilized;
	local X2Effect_RemoveEffects			RemoveEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SectopodLow');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_sectopod_lowstance";
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

	// Set up conditions for High check.
	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueName, SECTOPOD_HIGH_VALUE, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	IsNotImmobilized = new class'X2Condition_UnitValue';
	IsNotImmobilized.AddCheckValue(class'X2Ability_DefaultAbilitySet'.default.ImmobilizedValueName, 0);
	Template.AbilityShooterConditions.AddItem(IsNotImmobilized);

	Template.AbilityShooterConditions.AddItem( default.LivingShooterProperty );

	// ------------
	// Low effects.  
	// Set value to Low.
	SetLowValue = new class'X2Effect_SetUnitValue';
	SetLowValue.UnitName = default.HighLowValueName;
	SetLowValue.NewValueToSet = SECTOPOD_LOW_VALUE;
	SetLowValue.CleanupType = eCleanup_BeginTactical;
	Template.AddTargetEffect(SetLowValue);

	RemoveEffect = new class'X2Effect_RemoveEffects';
	RemoveEffect.EffectNamesToRemove.AddItem( default.HeightChangeEffectName );
	Template.AddTargetEffect( RemoveEffect );

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = SectopodHighLow_BuildVisualization;
	Template.bSkipFireAction = true;
	
	return Template;
}

static function X2AbilityTemplate CreateSectopodLightningFieldAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2Condition_UnitProperty UnitProperty;
	local X2Effect_ApplyWeaponDamage DamageEffect;
	local X2AbilityCooldown_LocalAndGlobal Cooldown;
	
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'SectopodLightningField');
	//IconImage needs to be changed once there is an icon for this
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_lightningfield";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	
	UnitProperty = new class'X2Condition_UnitProperty';
	UnitProperty.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitProperty);
	Template.AbilityToHitCalc = default.DeadEye;

	// Targets enemies
	UnitProperty = new class'X2Condition_UnitProperty';
	UnitProperty.ExcludeFriendlyToSource = true;
	UnitProperty.ExcludeDead = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitProperty);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	//Triggered by player or AI
	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	//fire from self, with a radius amount
	Template.AbilityTargetStyle = default.SelfTarget;
	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.LIGHTNINGFIELD_TILE_RADIUS * class'XComWorldData'.const.WORLD_StepSize * class'XComWorldData'.const.WORLD_UNITS_TO_METERS_MULTIPLIER;
	RadiusMultiTarget.bIgnoreBlockingCover = false;
	RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	//Weapon damage to all affected
	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.EffectDamageValue = class'X2Item_DefaultWeapons'.default.SECTOPOD_LIGHTINGFIELD_BASEDAMAGE;
	Template.AddMultiTargetEffect(DamageEffect);

	//Cooldowns
	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = default.LIGHTNINGFIELD_LOCAL_COOLDOWN;
	Cooldown.NumGlobalTurns = default.LIGHTNINGFIELD_GLOBAL_COOLDOWN;
	Template.AbilityCooldown = Cooldown;
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;
	Template.bSkipExitCoverWhenFiring = true;
	Template.CustomFireAnim = 'NO_LightningFieldA';
	Template.CinescriptCameraType = "Sectopod_LightningField";
//BEGIN AUTOGENERATED CODE: Template Overrides 'SectopodLightningField'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'SectopodLightningField'
	
	return Template;
}

simulated function SectopodHighLow_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          UnitRef;
	local X2Action_AnimSetTransition	SectopodTransition;
	local XComGameState_Unit			Sectopod;
	local UnitValue						HighLowValue;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        ActionMetadata;
	local XComGameStateHistory		History;
	local XComGameState_EnvironmentDamage EnvironmentDamageEvent;

	History = `XCOMHISTORY;
	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	UnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(UnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(UnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(UnitRef.ObjectID);
	Sectopod = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	SectopodTransition = X2Action_AnimSetTransition(class'X2Action_AnimSetTransition'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	SectopodTransition.Params.AnimName = 'HL_Stand2Crouch'; // Low by default.

	if( Sectopod.GetUnitValue(HighLowValueName, HighLowValue) )
	{
		if( HighLowValue.fValue == SECTOPOD_HIGH_VALUE )
		{
			SectopodTransition.Params.AnimName = 'LL_Crouch2Stand';
		}
	}

		//****************************************************************************************
	//Configure the visualization tracks for the environment
	//****************************************************************************************
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamageEvent)
	{
		ActionMetadata = EmptyTrack;
		ActionMetadata.VisualizeActor = none;
		ActionMetadata.StateObject_NewState = EnvironmentDamageEvent;
		ActionMetadata.StateObject_OldState = EnvironmentDamageEvent;

		// Apply damage to terrain instantly. 
		class'X2Action_ApplyWeaponDamageToTerrain'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded); //This is my weapon, this is my gun

			}
	//****************************************************************************************
}

static function X2AbilityTemplate CreateInitialStateAbility()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_UnitPostBeginPlay Trigger;
	local X2Effect_OverrideDeathAction      DeathActionEffect;
	local X2Effect_DamageImmunity DamageImmunity;
	local X2Effect_TurnStartActionPoints ThreeActionPoints;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SectopodInitialState');

	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AdditionalAbilities.AddItem('SectopodImmunities');

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	DeathActionEffect = new class'X2Effect_OverrideDeathAction';
	DeathActionEffect.DeathActionClass = class'X2Action_ExplodingUnitDeathAction';
	DeathActionEffect.EffectName = 'SectopodDeathActionEffect';
	Template.AddTargetEffect(DeathActionEffect);

	// Build the immunities
	DamageImmunity = new class'X2Effect_DamageImmunity';
	DamageImmunity.BuildPersistentEffect(1, true, true, true);
	DamageImmunity.ImmuneTypes.AddItem('Fire');
	DamageImmunity.ImmuneTypes.AddItem('Poison');
	DamageImmunity.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.ParthenogenicPoisonType);
	DamageImmunity.ImmuneTypes.AddItem('Unconscious');
	DamageImmunity.ImmuneTypes.AddItem('Panic');

	Template.AddTargetEffect(DamageImmunity);

	// Add 3rd action point per turn
	ThreeActionPoints = new class'X2Effect_TurnStartActionPoints';
	ThreeActionPoints.ActionPointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
	ThreeActionPoints.NumActionPoints = 1;
	ThreeActionPoints.bInfiniteDuration = true;
	Template.AddTargetEffect(ThreeActionPoints);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}


static function X2AbilityTemplate CreateTeamChangeHandlerAbility()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	Trigger;
	local X2Effect_RemoveEffects RemoveEffects;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SectopodNewTeamState');

	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'UnitChangedTeam';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(Trigger);

	// remove these effects when hacked.
	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(default.WrathCannonStage1EffectName);
	Template.AddShooterEffect(RemoveEffects);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

// Wrath cannon.
static function X2AbilityTemplate CreateWrathCannonStage1Ability()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCooldown_LocalAndGlobal Cooldown;
	local X2AbilityMultiTarget_Line         LineMultiTarget;
	local X2AbilityTarget_Cursor CursorTarget;
	local X2Condition_UnitProperty UnitProperty;
	local X2Effect_Persistent				WrathCannonStage1Effect;
	local X2Effect_SetUnitValue				SetImmobilizedValue;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.WrathCannonStage1AbilityName);
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_sectopod_wrathcannon"; // TODO: Change this icon
	Template.Hostility = eHostility_Offensive;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.bShowActivation = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AdditionalAbilities.AddItem(default.WrathCannonStage2AbilityName);
	Template.TwoTurnAttackAbility = default.WrathCannonStage2AbilityName;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false; // !!!
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = default.WRATH_CANNON_LOCAL_COOLDOWN;
	Cooldown.NumGlobalTurns = default.WRATH_CANNON_GLOBAL_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	UnitProperty = new class'X2Condition_UnitProperty';
	UnitProperty.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitProperty);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AddShooterEffectExclusions();
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.TargetingMethod = class'X2TargetingMethod_Line';

	// The target locations are enemies
	UnitProperty = new class'X2Condition_UnitProperty';
	UnitProperty.ExcludeFriendlyToSource = true;
	UnitProperty.ExcludeCivilian = true;
	UnitProperty.ExcludeDead = true;
	UnitProperty.IsOutdoors = true;
	UnitProperty.HasClearanceToMaxZ = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitProperty);

	LineMultiTarget = new class'X2AbilityMultiTarget_Line';
	LineMultiTarget.TileWidthExtension = 1;
	Template.AbilityMultiTargetStyle = LineMultiTarget;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = 15;
	Template.AbilityTargetStyle = CursorTarget;

	WrathCannonStage1Effect = new class'X2Effect_Persistent';
	WrathCannonStage1Effect.BuildPersistentEffect(1, true, true, true);
	WrathCannonStage1Effect.EffectName = default.WrathCannonStage1EffectName;
	WrathCannonStage1Effect.VisionArcDegreesOverride = 180.0f;
	WrathCannonStage1Effect.EffectRemovedVisualizationFn = WrathCannonStage1RemovedVisualization;
	WrathCannonStage1Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), "", true, , Template.AbilitySourceName);
	Template.AddShooterEffect(WrathCannonStage1Effect);

	// Immobilize Sectopod for the turn when the wrath cannon is activated.
	SetImmobilizedValue = new class'X2Effect_SetUnitValue';
	SetImmobilizedValue.UnitName = class'X2Ability_DefaultAbilitySet'.default.ImmobilizedValueName;
	SetImmobilizedValue.NewValueToSet = 1;
	SetImmobilizedValue.CleanupType = eCleanup_BeginTurn;
	Template.AddShooterEffect(SetImmobilizedValue);

	Template.BuildNewGameStateFn = WrathCannonStage1_BuildGameState;
	Template.BuildVisualizationFn = WrathCannonStage1_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildAffectedVisualizationSyncFn = WrathCannon_BuildAffectedVisualization;
	Template.CinescriptCameraType = "Sectopod_WrathCannon_Stage1";
//BEGIN AUTOGENERATED CODE: Template Overrides 'WrathCannonStage1'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'WrathCannonStage1'

	return Template;
}

function XComGameState WrathCannonStage1_BuildGameState(XComGameStateContext Context)
{
	local XComGameState NewState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit UnitState;
	local Vector TargetLocation;
	local Vector UnitLocation;
	local TTile UnitTile;
	local Rotator DesiredOrientation;

	NewState = TypicalAbility_BuildGameState(Context);

	AbilityContext = XComGameStateContext_Ability(NewState.GetContext());
	UnitState = XComGameState_Unit(NewState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID, eReturnType_Reference));
	if( UnitState == None )
	{
		UnitState = XComGameState_Unit(NewState.ModifyStateObject(class'XComGameState_Unit', AbilityContext.InputContext.SourceObject.ObjectID));
	}

	TargetLocation = AbilityContext.InputContext.TargetLocations[0];
	UnitTile = UnitState.TileLocation;
	UnitLocation = `XWORLD.GetPositionFromTileCoordinates(UnitTile);

	DesiredOrientation = Rotator(TargetLocation - UnitLocation);
	DesiredOrientation.Pitch = 0;

	UnitState.MoveOrientation = DesiredOrientation;

	return NewState;
}

simulated function WrathCannonStage1_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  AbilityContext;
	local StateObjectReference InteractingUnitRef;
	local X2AbilityTemplate AbilityTemplate;
	local VisualizationActionMetadata EmptyTrack, ActionMetadata;
	local int EffectIndex;
	local X2Action_MoveTurn MoveTurnAction;
	local X2Action_PlayAnimation PlayAnimation;
	local X2Action_PersistentEffect	PersistentEffectAction;

	History = `XCOMHISTORY;

		AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = AbilityContext.InputContext.SourceObject;

	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);

	//****************************************************************************************
	//Configure the visualization track for the source
	//****************************************************************************************
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	// Turn to face the target action. The target location is the center of the ability's radius, stored in the 0 index of the TargetLocations
	MoveTurnAction = X2Action_MoveTurn(class'X2Action_MoveTurn'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	MoveTurnAction.m_vFacePoint = AbilityContext.InputContext.TargetLocations[0];

	// Play the animation to get him to his looping idle
	PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	PlayAnimation.Params.AnimName = 'NO_WrathCannonStart';

	// Set the idle animation to the preparing to fire idle
	PersistentEffectAction = X2Action_PersistentEffect(class'X2Action_PersistentEffect'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	PersistentEffectAction.IdleAnimName = 'NO_WrathCannonIdle';

	
	//If there are effects added to the shooter, add the visualizer actions for them
	for( EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityShooterEffects.Length; ++EffectIndex )
	{
		AbilityTemplate.AbilityShooterEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, AbilityContext.FindShooterEffectApplyResult(AbilityTemplate.AbilityShooterEffects[EffectIndex]));
	}
}

function WrathCannon_BuildAffectedVisualization(name EffectName, XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata)
{
	local XComGameStateContext_Ability Context;
	local X2Action_PersistentEffect	PersistentEffectAction;

	if( EffectName == WrathCannonStage1EffectName )
	{
		Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
		if( Context == none )
		{
			return;
		}

		PersistentEffectAction = X2Action_PersistentEffect(class'X2Action_PersistentEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		PersistentEffectAction.IdleAnimName = 'NO_WrathCannonIdle';
	}
}

static function X2DataTemplate CreateWrathCannonStage2Ability()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener DelayedEventListener;
	local X2Effect_RemoveEffects RemoveEffects;
	local X2Effect_ApplyWeaponDamage DamageEffect;
	local X2AbilityMultiTarget_Line         LineMultiTarget;
	local X2AbilityTarget_Cursor CursorTarget;
	local X2Condition_UnitProperty UnitProperty;
	local X2Effect_TurnStartActionPoints ReducedActionPoint;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.WrathCannonStage2AbilityName);
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;

	Template.bDontDisplayInAbilitySummary = true;

	Template.AbilityToHitCalc = default.DeadEye;
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = 15;
	Template.AbilityTargetStyle = CursorTarget;

	UnitProperty = new class'X2Condition_UnitProperty';
	UnitProperty.ExcludeImpaired = true;
	Template.AbilityShooterConditions.AddItem(UnitProperty);
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// This ability fires when the event DelayedExecuteRemoved fires on this unit
	DelayedEventListener = new class'X2AbilityTrigger_EventListener';
	DelayedEventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	DelayedEventListener.ListenerData.EventID = 'PlayerTurnBegun';
	DelayedEventListener.ListenerData.Filter = eFilter_Player;
	DelayedEventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_WrathCannon;
	DelayedEventListener.ListenerData.Priority = 1;
	Template.AbilityTriggers.AddItem(DelayedEventListener);

	// Remove the Stage1 effect.
	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(default.WrathCannonStage1EffectName);
	Template.AddShooterEffect(RemoveEffects);

	// Add an effect that will reduce one action point for this turn.
	ReducedActionPoint = new class'X2Effect_TurnStartActionPoints';
	ReducedActionPoint.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	ReducedActionPoint.DuplicateResponse = eDupe_Ignore;
	ReducedActionPoint.ActionPointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
	ReducedActionPoint.NumActionPoints = 1;
	ReducedActionPoint.bActionPointsRemoved = true;
	Template.AddShooterEffect(ReducedActionPoint);

	LineMultiTarget = new class'X2AbilityMultiTarget_Line';
	LineMultiTarget.TileWidthExtension = 1;
	Template.AbilityMultiTargetStyle = LineMultiTarget;

	// The MultiTarget Units are dealt this damage
	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.EnvironmentalDamageAmount = default.WRATH_CANNON_ENVIRONMENT_DAMAGE_AMOUNT;
	DamageEffect.bExplosiveDamage = true;
	Template.AddMultiTargetEffect(DamageEffect);
	Template.AddMultiTargetEffect(new class'X2Effect_ApplyFireToWorld');

	Template.CustomFireAnim = 'FF_WrathCannonFire';

	Template.ModifyNewContextFn = WrathCannonStage2_ModifyActivatedAbilityContext;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = WrathCannonStage2_BuildVisualization;
	Template.CinescriptCameraType = "Sectopod_WrathCannon_Stage2";

	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.HeavyWeaponLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'WrathCannonStage2'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'WrathCannonStage2'

	return Template;
}

// Need to rebuild the multiple targets in our AoE.
simulated function WrathCannonStage2_ModifyActivatedAbilityContext(XComGameStateContext Context)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameStateHistory History;
	local int i;
	local X2AbilityMultiTargetStyle LineMultiTarget;
	local XComGameState_Ability AbilityState;
	local AvailableTarget MultiTargets;

	History = `XCOMHISTORY;

		AbilityContext = XComGameStateContext_Ability(Context);

	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID, eReturnType_Reference));

	// Build the MultiTarget array based upon the impact points
	LineMultiTarget = AbilityState.GetMyTemplate().AbilityMultiTargetStyle;// new class'X2AbilityMultiTarget_Radius';
	for( i = 0; i < AbilityContext.InputContext.TargetLocations.Length; ++i )
	{
		LineMultiTarget.GetMultiTargetsForLocation(AbilityState, AbilityContext.InputContext.TargetLocations[i], MultiTargets);
	}

	AbilityContext.InputContext.MultiTargets = MultiTargets.AdditionalTargets;
}
simulated function WrathCannonStage2_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  AbilityContext;
	local StateObjectReference InteractingUnitRef;
	local X2AbilityTemplate AbilityTemplate;
	local VisualizationActionMetadata EmptyTrack;
	local VisualizationActionMetadata ActionMetadata, SourceTrack;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyover;
	local X2Action_Fire FireAction;
	local X2Action_PersistentEffect	PersistentEffectAction;
	local X2Action_PlayAnimation PlayAnimation;
	local XComGameState_EnvironmentDamage EnvironmentDamageEvent;
	local XComGameState_WorldEffectTileData WorldDataUpdate;
	local array<X2Effect>               MultiTargetEffects;
	local int i, j, EffectIndex;
	local X2VisualizerInterface TargetVisualizerInterface;

	History = `XCOMHISTORY;

		AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = AbilityContext.InputContext.SourceObject;

	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);

	//****************************************************************************************
	//Configure the visualization track for the source
	//****************************************************************************************
	SourceTrack = EmptyTrack;
	SourceTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	SourceTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	SourceTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(SourceTrack, AbilityContext));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocFlyOverText, '', eColor_Good);

	// Remove the override idle animation
	PersistentEffectAction = X2Action_PersistentEffect(class'X2Action_PersistentEffect'.static.AddToVisualizationTree(SourceTrack, AbilityContext));
	PersistentEffectAction.IdleAnimName = '';

	// Play the firing action.  (Animation set in template.)
	FireAction = X2Action_Fire(class'X2Action_Fire'.static.AddToVisualizationTree(SourceTrack, AbilityContext));
	FireAction.SetFireParameters(true);

	// Play the animation to get him to his looping idle
	PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(SourceTrack, AbilityContext));
	PlayAnimation.Params.AnimName = 'NO_WrathCannonStopA';

	for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityShooterEffects.Length; ++EffectIndex)
	{
		AbilityTemplate.AbilityShooterEffects[ EffectIndex ].AddX2ActionsForVisualization( VisualizeGameState, SourceTrack, 'AA_Success' );
	}

	//****************************************************************************************

	//****************************************************************************************
	//Configure the visualization track for the targets
	//****************************************************************************************
	for( i = 0; i < AbilityContext.InputContext.MultiTargets.Length; ++i )
	{
		InteractingUnitRef = AbilityContext.InputContext.MultiTargets[i];
		ActionMetadata = EmptyTrack;
		ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
		ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
		ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, AbilityContext);
		for( j = 0; j < AbilityContext.ResultContext.MultiTargetEffectResults[i].Effects.Length; ++j )
		{
			AbilityContext.ResultContext.MultiTargetEffectResults[i].Effects[j].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, AbilityContext.ResultContext.MultiTargetEffectResults[i].ApplyResults[j]);
		}

		TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
		if( TargetVisualizerInterface != none )
		{
			//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
		}
	}
	TypicalAbility_AddEffectRedirects(VisualizeGameState, SourceTrack);
	MultiTargetEffects = AbilityTemplate.AbilityMultiTargetEffects;
	//****************************************************************************************
	//Configure the visualization tracks for the environment
	//****************************************************************************************
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamageEvent)
	{
		ActionMetadata = EmptyTrack;
		ActionMetadata.VisualizeActor = none;
		ActionMetadata.StateObject_NewState = EnvironmentDamageEvent;
		ActionMetadata.StateObject_OldState = EnvironmentDamageEvent;

		//Wait until signaled by the shooter that the projectiles are hitting
		if( !AbilityTemplate.bSkipFireAction )
		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, AbilityContext);

		for( EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityShooterEffects.Length; ++EffectIndex )
		{
			AbilityTemplate.AbilityShooterEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');
		}

		for( EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex )
		{
			AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');
		}

		for( EffectIndex = 0; EffectIndex < MultiTargetEffects.Length; ++EffectIndex )
		{
			MultiTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');
		}

			}

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_WorldEffectTileData', WorldDataUpdate)
	{
		ActionMetadata = EmptyTrack;
		ActionMetadata.VisualizeActor = none;
		ActionMetadata.StateObject_NewState = WorldDataUpdate;
		ActionMetadata.StateObject_OldState = WorldDataUpdate;

		//Wait until signaled by the shooter that the projectiles are hitting
		if( !AbilityTemplate.bSkipFireAction )
		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, AbilityContext);

		for( EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityShooterEffects.Length; ++EffectIndex )
		{
			AbilityTemplate.AbilityShooterEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');
		}

		for( EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex )
		{
			AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');
		}

		for( EffectIndex = 0; EffectIndex < MultiTargetEffects.Length; ++EffectIndex )
		{
			MultiTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');
		}

			}
	//****************************************************************************************
}

// Sectopod's wrath cannon visualization is customized to animate the WrathCannon_Start, followed by the WrathCannonIdle.
// We need a custom visualization to remove the custom idle, particularly when it is removed by unnatural means (i.e. hacking)
static function WrathCannonStage1RemovedVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_PersistentEffect	PersistentEffectAction;

	// Clear the Sectopod's custom wrath cannon idle animation when this effect is removed.
	PersistentEffectAction = X2Action_PersistentEffect(class'X2Action_PersistentEffect'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext()));
	PersistentEffectAction.IdleAnimName = '';
}


defaultproperties
{
	WrathCannonAbilityName = "WrathCannon"
	WrathCannonStage1AbilityName = "WrathCannonStage1"
	WrathCannonStage2AbilityName = "WrathCannonStage2"
	WrathCannonStage1EffectName = "WrathCannonStage1Effect"
	HeightChangeEffectName = "SectopodStandUp"
	HighLowValueName = "HighLowValue"
	HIGH_STANCE_ENV_DAMAGE_AMOUNT = 30
	HIGH_STANCE_IMPULSE_AMOUNT = 10
}
