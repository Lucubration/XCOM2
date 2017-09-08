class X2Ability_Lucu_Garage_ProtocolAbilitySet extends X2Ability
	config(Lucu_Garage_DefaultConfig);
	
var localized string CoveredTargetFriendlyDesc;

var name CoverTargetActionPoint;
var name CoverTargetEffectName;
var name CoveredTargetEffectName;
var name CoverTargetShotAbilityName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(DefaultPower());
	Templates.AddItem(HighStance());
	Templates.AddItem(LowStance());
	Templates.AddItem(CoverTarget());
	Templates.AddItem(CoverTargetShot());

	return Templates;
}


//---------------------------------------------------------------------------------------------------
// Default Power
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate DefaultPower()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_Lucu_Garage_PowerMax		PowerMaxEffect;
	local X2Effect_Lucu_Garage_PowerRegen	PowerRegenEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_DefaultPower');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///UILibrary_Lucu_Garage_Icons.UIPerk_powerregen";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	PowerMaxEffect = new class'X2Effect_Lucu_Garage_PowerMax';
	PowerMaxEffect.EffectName = 'Lucu_Garage_DefaultPowerMax';
	PowerMaxEffect.BuildPersistentEffect(1, true, false);
	PowerMaxEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
	PowerMaxEffect.DuplicateResponse = eDupe_Ignore;
	PowerMaxEffect.Amount = class'Lucu_Garage_Config'.default.PowerMaxDefault;
	Template.AddTargetEffect(PowerMaxEffect);

	PowerRegenEffect = new class'X2Effect_Lucu_Garage_PowerRegen';
	PowerRegenEffect.EffectName = 'Lucu_Garage_DefaultPowerRegen';
	PowerRegenEffect.BuildPersistentEffect(1, true, false, , eGameRule_PlayerTurnBegin);
	PowerRegenEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
	PowerRegenEffect.Amount = class'Lucu_Garage_Config'.default.PowerRegenDefault;
	PowerRegenEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(PowerRegenEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	
	return Template;
}


//---------------------------------------------------------------------------------------------------
// High Stance
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate HighStance()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local X2Effect_SetUnitValue				SetHighValue;
	local X2Condition_UnitValue				IsLow;
	local X2Condition_UnitValue				IsNotImmobilized;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_HighStance');
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
	IsLow.AddCheckValue(class'X2Ability_Sectopod'.default.HighLowValueName, class'X2Ability_Sectopod'.const.SECTOPOD_LOW_VALUE, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsLow);

	IsNotImmobilized = new class'X2Condition_UnitValue';
	IsNotImmobilized.AddCheckValue(class'X2Ability_DefaultAbilitySet'.default.ImmobilizedValueName, 0);
	Template.AbilityShooterConditions.AddItem(IsNotImmobilized);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// ------------
	// High effect.  
	// Set value to High.
	SetHighValue = new class'X2Effect_SetUnitValue';
	SetHighValue.UnitName = class'X2Ability_Sectopod'.default.HighLowValueName;
	SetHighValue.NewValueToSet = class'X2Ability_Sectopod'.const.SECTOPOD_HIGH_VALUE;
	SetHighValue.CleanupType = eCleanup_BeginTactical;
	Template.AddTargetEffect(SetHighValue);

	Template.AddTargetEffect(class'X2Ability_Sectopod'.static.CreateHeightChangeStatusEffect());

	Template.BuildNewGameStateFn = SectopodHigh_BuildGameState;
	Template.BuildVisualizationFn = SectopodHighLow_BuildVisualization;
	Template.bSkipFireAction = true;
	Template.CinescriptCameraType = "Sectopod_HighStance";
	
	return Template;
}


//---------------------------------------------------------------------------------------------------
// Low Stance
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate LowStance()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local X2Effect_SetUnitValue				SetLowValue;
	local X2Condition_UnitValue				IsHigh;
	local X2Condition_UnitValue				IsNotImmobilized;
	local X2Effect_RemoveEffects			RemoveEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_LowStance');
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
	IsHigh.AddCheckValue(class'X2Ability_Sectopod'.default.HighLowValueName, class'X2Ability_Sectopod'.const.SECTOPOD_HIGH_VALUE, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	IsNotImmobilized = new class'X2Condition_UnitValue';
	IsNotImmobilized.AddCheckValue(class'X2Ability_DefaultAbilitySet'.default.ImmobilizedValueName, 0);
	Template.AbilityShooterConditions.AddItem(IsNotImmobilized);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// ------------
	// Low effects.  
	// Set value to Low.
	SetLowValue = new class'X2Effect_SetUnitValue';
	SetLowValue.UnitName = class'X2Ability_Sectopod'.default.HighLowValueName;
	SetLowValue.NewValueToSet = class'X2Ability_Sectopod'.const.SECTOPOD_LOW_VALUE;
	SetLowValue.CleanupType = eCleanup_BeginTactical;
	Template.AddTargetEffect(SetLowValue);

	RemoveEffect = new class'X2Effect_RemoveEffects';
	RemoveEffect.EffectNamesToRemove.AddItem(class'X2Ability_Sectopod'.default.HeightChangeEffectName);
	Template.AddTargetEffect(RemoveEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = SectopodHighLow_BuildVisualization;
	Template.bSkipFireAction = true;
	
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
	DamageEvent = XComGameState_EnvironmentDamage(NewState.CreateStateObject(class'XComGameState_EnvironmentDamage'));
	DamageEvent.DEBUG_SourceCodeLocation = "UC: X2Ability_Sectopod:SectopodHigh_BuildGameState";
	DamageEvent.DamageAmount = class'X2Ability_Sectopod'.default.HIGH_STANCE_ENV_DAMAGE_AMOUNT;
	DamageEvent.DamageTypeTemplateName = 'NoFireExplosion';
	DamageEvent.HitLocation = UnitLocation;
	DamageEvent.PhysImpulse = class'X2Ability_Sectopod'.default.HIGH_STANCE_IMPULSE_AMOUNT;

	// This unit gamestate should already be in the high position at this point.  Destroy stuff in these tiles.
	// Update - only destroy stuff in the tiles that have become occupied.
	OldUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID, eReturnType_Reference));
	OldUnitState.GetVisibilityLocation(OldTiles);
	UnitState.GetVisibilityLocation(NewTiles); 
	class'Helpers'.static.RemoveTileSubset(DamageEvent.DamageTiles, NewTiles, OldTiles);

	DamageEvent.DamageCause = UnitState.GetReference();
	DamageEvent.DamageSource = DamageEvent.DamageCause;
	NewState.AddStateObject(DamageEvent);

	return NewState;
}

simulated function SectopodHighLow_BuildVisualization(XComGameState VisualizeGameState, out array<VisualizationTrack> OutVisualizationTracks)
{
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          UnitRef;
	local X2Action_AnimSetTransition	SectopodTransition;
	local XComGameState_Unit			Sectopod;
	local UnitValue						HighLowValue;

	local VisualizationTrack        EmptyTrack;
	local VisualizationTrack        BuildTrack;
	local XComGameStateHistory		History;
	local XComGameState_EnvironmentDamage EnvironmentDamageEvent;

	History = `XCOMHISTORY;
	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	UnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(UnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(UnitRef.ObjectID);
	BuildTrack.TrackActor = History.GetVisualizer(UnitRef.ObjectID);
	Sectopod = XComGameState_Unit(BuildTrack.StateObject_NewState);

	SectopodTransition = X2Action_AnimSetTransition(class'X2Action_AnimSetTransition'.static.AddToVisualizationTrack(BuildTrack, Context));
	SectopodTransition.Params.AnimName = 'HL_Stand2Crouch'; // Low by default.

	if (Sectopod.GetUnitValue(class'X2Ability_Sectopod'.default.HighLowValueName, HighLowValue))
	{
		if (HighLowValue.fValue == class'X2Ability_Sectopod'.const.SECTOPOD_HIGH_VALUE)
		{
			SectopodTransition.Params.AnimName = 'LL_Crouch2Stand';
		}
	}

	OutVisualizationTracks.AddItem(BuildTrack);
	//****************************************************************************************
	//Configure the visualization tracks for the environment
	//****************************************************************************************
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamageEvent)
	{
		BuildTrack = EmptyTrack;
		BuildTrack.TrackActor = none;
		BuildTrack.StateObject_NewState = EnvironmentDamageEvent;
		BuildTrack.StateObject_OldState = EnvironmentDamageEvent;

		// Apply damage to terrain instantly. 
		class'X2Action_ApplyWeaponDamageToTerrain'.static.AddToVisualizationTrack(BuildTrack, Context); //This is my weapon, this is my gun

		OutVisualizationTracks.AddItem(BuildTrack);
	}
	//****************************************************************************************
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
	local X2Condition_AbilityProperty		CoveringFireCondition;
	local X2Effect_ModifyReactionFire		ModifyReactionFireEffect;
	local X2Condition_UnitProperty          ConcealedCondition;
	local X2Effect_SetUnitValue             UnitValueEffect;
	local X2Effect_Persistent				CoverTargetEffect;
	local X2Condition_UnitEffects           SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_CoverTarget');
	
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	AmmoCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.bFreeCost = true;
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
	CoveringFireCondition = new class'X2Condition_AbilityProperty';
	CoveringFireCondition.OwnerHasSoldierAbilities.AddItem('CoveringFire');
	CoveringFireEffect.TargetConditions.AddItem(CoveringFireCondition);
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
	CoverTargetEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, default.CoveredTargetFriendlyDesc, Template.IconImage,,,Template.AbilitySourceName);
	CoverTargetEffect.bUseSourcePlayerState = true;
	Template.AddTargetEffect(CoverTargetEffect);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_ActionPoints');
	Template.IconImage = "img:///UILibrary_Lucu_Garage_Icons.UIPerk_covertarget";
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
	local X2Effect_Lucu_Garage_RemoveEffects		RemoveEffect;

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
	Template.IconImage = "img:///UILibrary_Lucu_Garage_Icons.UIPerk_covertarget";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.OVERWATCH_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.DisplayTargetHitChance = false;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bAllowFreeFireWeaponUpgrade = false;

	// Remove the Cover Target effect on the shooter (which allows the crit)
	RemoveEffect = new class'X2Effect_Lucu_Garage_RemoveEffects';
	RemoveEffect.EffectNamesToRemove.AddItem(default.CoverTargetEffectName);
	RemoveEffect.bApplyOnMiss = true;
	RemoveEffect.bCheckTarget = true;
	Template.AddShooterEffect(RemoveEffect);

	// Remove the Cover Target effect on the target (which allows the shot)
	RemoveEffect = new class'X2Effect_Lucu_Garage_RemoveEffects';
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

DefaultProperties
{
	CoverTargetActionPoint="lucu_garage_covertarget"
	CoverTargetEffectName="Lucu_Garage_CoverTarget"
	CoveredTargetEffectName="Lucu_Garage_CoveredTarget"
	CoverTargetShotAbilityName="Lucu_Garage_CoverTargetShot"
}
