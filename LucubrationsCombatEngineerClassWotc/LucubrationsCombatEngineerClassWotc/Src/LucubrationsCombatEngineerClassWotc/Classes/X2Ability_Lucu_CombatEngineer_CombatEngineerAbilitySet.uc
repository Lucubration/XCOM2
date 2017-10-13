class X2Ability_Lucu_CombatEngineer_CombatEngineerAbilitySet extends X2Ability
	config(Lucu_CombatEngineer_Ability);

var config int RakeCrippledMobilityAdjust;
var config int RakeCrippledDuration;
var config int DetPackCharges;
var config int SIMONCharges;
var config int DeployableCoverCharges;
var config int SentryCameraCharges;
var config int RapidDeploymentCooldown;
var config int PackmasterCharges;
var config float AcceptableTolerancesBonusRange;

var localized string CrippledEffectFriendlyName;
var localized string CrippledEffectFriendlyDesc;

var name MovingMeleeAbilityTemplateName;
var name CrippledEffectName;
var name DetPackAbilityTemplateName;
var name ThrowDetPackAbilityTemplateName;
var name DetPackEffectName;
var name DetonateAbilityTemplateName;
var name SIMONAbilityTemplateName;
var name LaunchSIMONAbilityTemplateName;
var name DeployableCoverAbilityTemplateName;
var name PlaceDeployableCoverAbilityTemplateName;
var string DeployableCoverLoArchetype;
var string DeployableCoverHiArchetype;
var name SentryCameraAbilityTemplateName;
var name ThrowSentryCameraAbilityTemplateName;
var name RapidDeploymentAbilityTemplateName;
var name RapidDeploymentEffectName;
var name PackmasterAbilityTemplateName;
var name SkirmisherAbilityTemplateName;
var name AcceptableTolerancesAbilityTemplateName;
    
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
    Templates.AddItem(MovingMelee());
	Templates.AddItem(DetPack());
	Templates.AddItem(ThrowDetPack());
    Templates.AddItem(Detonate());
    Templates.AddItem(SIMON());
    Templates.AddItem(LaunchSIMON());
    Templates.AddItem(DeployableCover());
    Templates.AddItem(PlaceDeployableCover());
	Templates.AddItem(RapidDeployment());
    Templates.AddItem(Skirmisher());
	Templates.AddItem(PurePassive(default.AcceptableTolerancesAbilityTemplateName, "img:///UILibrary_CombatEngineerClass.UIPerk_acceptableTolerances"));
	
	return Templates;
}

//---------------------------------------------------------------------------------------------------
// Melee
//---------------------------------------------------------------------------------------------------

static function X2AbilityTemplate MovingMelee()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2Effect_PersistentStatChange     CrippledEffect;
	local X2AbilityTarget_MovingMelee       MeleeTarget;
	local array<name>                       SkipExclusions;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.MovingMeleeAbilityTemplateName);

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_swordSlash";
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	MeleeTarget = new class'X2AbilityTarget_MovingMelee';
	MeleeTarget.MovementRangeAdjustment = 1;
	Template.AbilityTargetStyle = MeleeTarget;
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
    
    // Cripple Effect
	CrippledEffect = new class'X2Effect_PersistentStatChange';
	CrippledEffect.BuildPersistentEffect(default.RakeCrippledDuration, false, false, true, eGameRule_PlayerTurnBegin);
	CrippledEffect.SetDisplayInfo(ePerkBuff_Penalty, default.CrippledEffectFriendlyName, default.CrippledEffectFriendlyDesc, Template.IconImage, true);
	CrippledEffect.AddPersistentStatChange(eStat_Mobility, default.RakeCrippledMobilityAdjust);
	CrippledEffect.DuplicateResponse = eDupe_Refresh;
	CrippledEffect.EffectName = default.CrippledEffectName;
	Template.AddTargetEffect(CrippledEffect);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;

	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;
}

//---------------------------------------------------------------------------------------------------
// Det Pack
//---------------------------------------------------------------------------------------------------

static function X2AbilityTemplate DetPack()
{
	local X2AbilityTemplate									        Template;
	local X2Effect_PersistentStatChange						        StatChangeEffect;
	local X2Effect_Lucu_CombatEngineer_TransientUtilityItem	        TransientItemEffect;
    local X2Condition_Lucu_CombatEngineer_HasTech                   TechCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.DetPackAbilityTemplateName);

	Template.AdditionalAbilities.AddItem(default.ThrowDetPackAbilityTemplateName);
    Template.AdditionalAbilities.AddItem(default.DetonateAbilityTemplateName);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Lucu_CombatEngineer.UIPerk_item_detPack";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	// Expand the unit's utility items to allow the transient item. This goes before the transient item effect
	StatChangeEffect = new class'X2Effect_PersistentStatChange';
	StatChangeEffect.EffectName = 'Lucu_CombatEngineer_TransientDetPackUtilitySlot';
	StatChangeEffect.BuildPersistentEffect(1, true, false);
	StatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	StatChangeEffect.DuplicateResponse = eDupe_Allow;
	StatChangeEffect.AddPersistentStatChange(eStat_UtilityItems, 1);
	Template.AddTargetEffect(StatChangeEffect);

    // Conventional
	TransientItemEffect = new class'X2Effect_Lucu_CombatEngineer_TransientUtilityItem';
	TransientItemEffect.EffectName = 'Lucu_CombatEngineer_DetPack_CV';
	TransientItemEffect.BuildPersistentEffect(1, true, false);
	TransientItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	TransientItemEffect.DuplicateResponse = eDupe_Allow;
	TransientItemEffect.AbilityTemplateName = default.ThrowDetPackAbilityTemplateName;
	TransientItemEffect.ItemTemplateName = class'X2Item_Lucu_CombatEngineer_Weapons'.default.DetpackCVItemName;
    TransientItemEffect.ClipSize = default.DetPackCharges;
    TechCondition = new class'X2Condition_Lucu_CombatEngineer_HasTech';
    TechCondition.TechNames.AddItem(class'X2StrategyElement_Lucu_CombatEngineer_Techs'.default.PlasmaPackTechTemplateName);
    TechCondition.HasTech = false;
    TransientItemEffect.TargetConditions.AddItem(TechCondition);
	Template.AddTargetEffect(TransientItemEffect);

    // Magnetic
	TransientItemEffect = new class'X2Effect_Lucu_CombatEngineer_TransientUtilityItem';
	TransientItemEffect.EffectName = 'Lucu_CombatEngineer_DetPack_BM';
	TransientItemEffect.BuildPersistentEffect(1, true, false);
	TransientItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	TransientItemEffect.DuplicateResponse = eDupe_Allow;
	TransientItemEffect.AbilityTemplateName = default.ThrowDetPackAbilityTemplateName;
	TransientItemEffect.ItemTemplateName = class'X2Item_Lucu_CombatEngineer_Weapons'.default.DetpackBMItemName;
    TransientItemEffect.ClipSize = default.DetPackCharges;
    TechCondition = new class'X2Condition_Lucu_CombatEngineer_HasTech';
    TechCondition.TechNames.AddItem(class'X2StrategyElement_Lucu_CombatEngineer_Techs'.default.PlasmaPackTechTemplateName);
    TransientItemEffect.TargetConditions.AddItem(TechCondition);
	Template.AddTargetEffect(TransientItemEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	
	return Template;
}

static function X2AbilityTemplate ThrowDetPack()
{
	local X2AbilityTemplate						                    Template;
	local X2AbilityCost_Ammo				                        AmmoCost;
	local X2AbilityCost_Lucu_CombatEngineer_FreeAbilityEffect       ActionPointCost;
	local X2AbilityTarget_Lucu_CombatEngineer_Deployable            AbilityTarget;
	local X2AbilityMultiTarget_Lucu_CombatEngineer_DetPackRadius    RadiusMultiTarget;
	local X2Effect_Lucu_CombatEngineer_DetPack                      DetPackEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.ThrowDetPackAbilityTemplateName);	
	
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
    
	ActionPointCost = new class'X2AbilityCost_Lucu_CombatEngineer_FreeAbilityEffect';
	ActionPointCost.iNumPoints = 1;
    ActionPointCost.DoNotConsumeEffects.AddItem(default.RapidDeploymentEffectName);
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;

    Template.bHideAmmoWeaponDuringFire = true;
	
	AbilityTarget = new class'X2AbilityTarget_Lucu_CombatEngineer_Deployable';
	Template.AbilityTargetStyle = AbilityTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Lucu_CombatEngineer_DetPackRadius';
	RadiusMultiTarget.bUseWeaponRadius = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;
    
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
    
	Template.bRecordValidTiles = true;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	DetPackEffect = new class'X2Effect_Lucu_CombatEngineer_DetPack';
    DetPackEffect.EffectName = default.DetPackEffectName;
	DetPackEffect.DuplicateResponse = eDupe_Allow;
	DetPackEffect.TargetingIcon=Texture2D'UILibrary_XPACK_Common.target_claymore';
	DetPackEffect.bTargetableBySpawnedTeamOnly = true;
    DetPackEffect.BuildPersistentEffect(1, true, false, false);
	Template.AddShooterEffect(DetPackEffect);
    
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_GRENADE_PRIORITY;

	Template.ConcealmentRule = eConceal_Always;

	Template.bShowActivation = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = ThrowDetPack_BuildVisualization;
	Template.TargetingMethod = class'X2TargetingMethod_Lucu_CombatEngineer_DetPack';
	Template.CinescriptCameraType = "StandardGrenadeFiring";

	Template.Hostility = eHostility_Neutral;
	Template.bAllowUnderhandAnim = true;

	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.IconImage = "img:///UILibrary_Lucu_CombatEngineer.UIPerk_item_detPack";

	Template.BuildAppliedVisualizationSyncFn = DetPackVisualizationSync;
	Template.DamagePreviewFn = DetPackDamagePreview;

	return Template;	
}

function bool DetPackDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	local XComGameStateHistory History;
    local XComGameState_Item SourceItem;
    local X2DetPackTemplate_Lucu_CombatEngineer SourceItemTemplate;
    
	History = `XCOMHISTORY;

    // Find and set the destructible archetype just before the effect spawns it
    SourceItem = XComGameState_Item(History.GetGameStateForObjectID(AbilityState.SourceWeapon.ObjectID));
    `assert(SourceItem != none);

    SourceItemTemplate = X2DetPackTemplate_Lucu_CombatEngineer(SourceItem.GetMyTemplate());
    `assert(SourceItemTemplate != none);

    MinDamagePreview = SourceItemTemplate.BaseDamage;
    MaxDamagePreview = SourceItemTemplate.BaseDamage;
	return true;
}

function DetPackVisualizationSync(name EffectName, XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata)
{
	local XComGameState_Effect EffectState;
	local XComGameStateHistory History;
	local XComGameState_Destructible DestructibleState;
	local XComDestructibleActor DestructibleInstance;
	local X2Effect_Lucu_CombatEngineer_DetPack DetPackEffect;

	History = `XCOMHISTORY;
	foreach History.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		DetPackEffect = X2Effect_Lucu_CombatEngineer_DetPack(EffectState.GetX2Effect());
		if (DetPackEffect != none)
		{
			DestructibleState = XComGameState_Destructible(History.GetGameStateForObjectID(EffectState.CreatedObjectReference.ObjectID));
			DestructibleInstance = XComDestructibleActor(DestructibleState.FindOrCreateVisualizer());
			if (DestructibleInstance != none)
			{
				DestructibleInstance.TargetingIcon = DetPackEffect.TargetingIcon;
			}
		}
	}
}

function ThrowDetPack_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameState_Destructible DestructibleState;
	local VisualizationActionMetadata ActionMetadata;

	TypicalAbility_BuildVisualization(VisualizeGameState);

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Destructible', DestructibleState)
	{
		break;
	}
	`assert(DestructibleState != none);

	ActionMetadata.StateObject_NewState = DestructibleState;
	ActionMetadata.StateObject_OldState = DestructibleState;
	ActionMetadata.VisualizeActor = `XCOMHISTORY.GetVisualizer(DestructibleState.ObjectID);

	class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded);
	class'X2Action_ShowSpawnedDestructible'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded);
}

//---------------------------------------------------------------------------------------------------
// Detonate
//---------------------------------------------------------------------------------------------------

static function X2AbilityTemplate Detonate()
{
	local X2AbilityTemplate                                         Template;
	local X2AbilityCost_ActionPoints                                ActionPointCost;
	local X2AbilityMultiTarget_Lucu_CombatEngineer_AllOwnDetPacks	MultiTargetingStyle;
	local X2Condition_Lucu_CombatEngineer_HasActiveDetPack          HasDetPackCondition;
    local X2Condition_Lucu_CombatEngineer_IsActiveDetPack           IsDetPackCondition;
	local X2Effect_RemoteStart                                      RemoteStartEffect;
	`CREATE_X2ABILITY_TEMPLATE(Template, default.DetonateAbilityTemplateName);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	Template.bLimitTargetIcons = true;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	// This ability self-targets the combat engineer, and pulls in all of their det packs as multi-targets
	Template.AbilityTargetStyle = default.SelfTarget;
	MultiTargetingStyle = new class'X2AbilityMultiTarget_Lucu_CombatEngineer_AllOwnDetPacks';
	MultiTargetingStyle.NumTargetsRequired = 1; //At least one det pack must exist
	Template.AbilityMultiTargetStyle = MultiTargetingStyle;

	// Target must have an active det pack effect
	HasDetPackCondition = new class'X2Condition_Lucu_CombatEngineer_HasActiveDetPack';
	Template.AbilityTargetConditions.AddItem(HasDetPackCondition);

    // Multi-targets be living det packs
    IsDetPackCondition = new class 'X2Condition_Lucu_CombatEngineer_IsActiveDetPack';
    Template.AbilityMultiTargetConditions.AddItem(IsDetPackCondition);
    
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	RemoteStartEffect = new class'X2Effect_RemoteStart';
	RemoteStartEffect.UnitDamageMultiplier = 1; // No reason to parameterize these; all bonus damage/radius is applied elsewhere
	RemoteStartEffect.DamageRadiusMultiplier = 1;
	Template.AddMultiTargetEffect(RemoteStartEffect);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bShowActivation = true;
	Template.bStationaryWeapon = true;
	Template.bSkipFireAction = true;
	Template.bSkipPerkActivationActions = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');
    
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_remotestart";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.Hostility = eHostility_Offensive;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.TargetingMethod = class'X2TargetingMethod_Lucu_CombatEngineer_Detonate';
    
	Template.FrameAbilityCameraType = eCameraFraming_Never;

	Template.ActivationSpeech = 'Explosion';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.bFrameEvenWhenUnitIsHidden = true;
    // The nuclear option. Must override to call custom X2AbilityMultiTarget methods outside of native code
	Template.OverrideAbilityAvailabilityFn = Detonate_OverrideAbilityAvailability;

	return Template;
}

function Detonate_OverrideAbilityAvailability(out AvailableAction Action, XComGameState_Ability AbilityState, XComGameState_Unit OwnerState)
{
    Action.AvailableCode = AbilityState.CanActivateAbility(OwnerState);

	if (Action.AvailableCode == 'AA_Success')
    {
        Action.AvailableCode = GatherDetonateAbilityTargets(AbilityState, Action.AvailableTargets);
    }
}

function name GatherDetonateAbilityTargets(const XComGameState_Ability Ability, out array<AvailableTarget> Targets)
{
	local int i, j;
	local XComGameState_Unit kOwner;
	local name AvailableCode;
	local XComGameStateHistory History;
    local X2AbilityTemplate AbilityTemplate;

	AbilityTemplate = Ability.GetMyTemplate();
	History = `XCOMHISTORY;
	kOwner = XComGameState_Unit(History.GetGameStateForObjectID(Ability.OwnerStateObject.ObjectID));

	if (AbilityTemplate != None)
	{
		AvailableCode = AbilityTemplate.AbilityTargetStyle.GetPrimaryTargetOptions(Ability, Targets);
		if (AvailableCode != 'AA_Success')
			return AvailableCode;
	
		for (i = Targets.Length - 1; i >= 0; --i)
		{
			AvailableCode = AbilityTemplate.CheckTargetConditions(Ability, kOwner, History.GetGameStateForObjectID(Targets[i].PrimaryTarget.ObjectID));
			if (AvailableCode != 'AA_Success')
			{
				Targets.Remove(i, 1);
			}
		}

		if (AbilityTemplate.AbilityMultiTargetStyle != none)
		{
			AbilityTemplate.AbilityMultiTargetStyle.GetMultiTargetOptions(Ability, Targets);
			for (i = Targets.Length - 1; i >= 0; --i)
			{
				for (j = Targets[i].AdditionalTargets.Length - 1; j >= 0; --j)
				{
					AvailableCode = AbilityTemplate.CheckMultiTargetConditions(Ability, kOwner, History.GetGameStateForObjectID(Targets[i].AdditionalTargets[j].ObjectID));
					if (AvailableCode != 'AA_Success' || (Targets[i].AdditionalTargets[j].ObjectID == Targets[i].PrimaryTarget.ObjectID) && !AbilityTemplate.AbilityMultiTargetStyle.bAllowSameTarget)
					{
						Targets[i].AdditionalTargets.Remove(j, 1);
					}
				}

				AvailableCode = AbilityTemplate.AbilityMultiTargetStyle.CheckFilteredMultiTargets(Ability, Targets[i]);
				if (AvailableCode != 'AA_Success')
					Targets.Remove(i, 1);
			}
		}

		//The Multi-target style may have deemed some primary targets invalid in calls to CheckFilteredMultiTargets - so CheckFilteredPrimaryTargets must come afterwards.
		AvailableCode = AbilityTemplate.AbilityTargetStyle.CheckFilteredPrimaryTargets(Ability, Targets);
		if (AvailableCode != 'AA_Success')
			return AvailableCode;
	}
	return 'AA_Success';
}

//---------------------------------------------------------------------------------------------------
// SIMON
//---------------------------------------------------------------------------------------------------

static function X2AbilityTemplate SIMON()
{
	local X2AbilityTemplate									        Template;
	local X2Effect_PersistentStatChange						        StatChangeEffect;
	local X2Effect_Lucu_CombatEngineer_TransientUtilityItem	        TransientItemEffect;
    local X2Condition_Lucu_CombatEngineer_HasTech                   TechCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.SIMONAbilityTemplateName);

	Template.AdditionalAbilities.AddItem(default.LaunchSIMONAbilityTemplateName);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_firerocket";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	// Expand the unit's utility items to allow the transient item. This goes before the transient item effect
	StatChangeEffect = new class'X2Effect_PersistentStatChange';
	StatChangeEffect.EffectName = 'Lucu_CombatEngineer_TransientSIMONUtilitySlot';
	StatChangeEffect.BuildPersistentEffect(1, true, false);
	StatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	StatChangeEffect.DuplicateResponse = eDupe_Allow;
	StatChangeEffect.AddPersistentStatChange(eStat_UtilityItems, 1);
	Template.AddTargetEffect(StatChangeEffect);

    // Conventional
	TransientItemEffect = new class'X2Effect_Lucu_CombatEngineer_TransientUtilityItem';
	TransientItemEffect.EffectName = 'Lucu_CombatEngineer_SIMON_CV';
	TransientItemEffect.BuildPersistentEffect(1, true, false);
	TransientItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	TransientItemEffect.DuplicateResponse = eDupe_Allow;
	TransientItemEffect.AbilityTemplateName = default.LaunchSIMONAbilityTemplateName;
	TransientItemEffect.ItemTemplateName = class'X2Item_Lucu_CombatEngineer_Weapons'.default.SIMONCVItemName;
	TransientItemEffect.UseItemAsAmmo = true;
    TransientItemEffect.ClipSize = default.SIMONCharges;
    TechCondition = new class'X2Condition_Lucu_CombatEngineer_HasTech';
    TechCondition.TechNames.AddItem(class'X2StrategyElement_Lucu_CombatEngineer_Techs'.default.SIMONMKIITechTemplateName);
    TechCondition.HasTech = false;
    TransientItemEffect.TargetConditions.AddItem(TechCondition);
	Template.AddTargetEffect(TransientItemEffect);

    // Magnetic
	TransientItemEffect = new class'X2Effect_Lucu_CombatEngineer_TransientUtilityItem';
	TransientItemEffect.EffectName = 'Lucu_CombatEngineer_SIMON_MG';
	TransientItemEffect.BuildPersistentEffect(1, true, false);
	TransientItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	TransientItemEffect.DuplicateResponse = eDupe_Allow;
	TransientItemEffect.AbilityTemplateName = default.LaunchSIMONAbilityTemplateName;
	TransientItemEffect.ItemTemplateName = class'X2Item_Lucu_CombatEngineer_Weapons'.default.SIMONMGItemName;
	TransientItemEffect.UseItemAsAmmo = true;
    TransientItemEffect.ClipSize = default.SIMONCharges;
    TechCondition = new class'X2Condition_Lucu_CombatEngineer_HasTech';
    TechCondition.TechNames.AddItem(class'X2StrategyElement_Lucu_CombatEngineer_Techs'.default.SIMONMKIITechTemplateName);
    TransientItemEffect.TargetConditions.AddItem(TechCondition);
	Template.AddTargetEffect(TransientItemEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	
	return Template;
}

static function X2AbilityTemplate LaunchSIMON()
{
	local X2AbilityTemplate					                    Template;
	local X2AbilityCost_Ammo				                    AmmoCost;
	local X2AbilityCost_Lucu_CombatEngineer_FreeAbilityEffect   ActionPointCost;
	local X2AbilityToHitCalc_StandardAim                        StandardAim;
	local X2AbilityTarget_Cursor                                CursorTarget;
	local X2AbilityMultiTarget_Lucu_CombatEngineer_SIMON        SIMONMultiTarget;
	local X2Condition_UnitProperty                              UnitPropertyCondition;
	local X2Condition_AbilitySourceWeapon	                    GrenadeCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.LaunchSIMONAbilityTemplateName);

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	AmmoCost.UseLoadedAmmo = true;
	Template.AbilityCosts.AddItem(AmmoCost);
    
	ActionPointCost = new class'X2AbilityCost_Lucu_CombatEngineer_FreeAbilityEffect';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
    ActionPointCost.DoNotConsumeEffects.AddItem(default.RapidDeploymentEffectName);
    ActionPointCost.DoNotConsumeAllEffects.AddItem(default.RapidDeploymentEffectName);
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bIndirectFire = true;
	StandardAim.bAllowCrit = false;
	Template.AbilityToHitCalc = StandardAim;
	
	Template.bUseLaunchedGrenadeEffects = true;
	Template.bHideAmmoWeaponDuringFire = true; // hide the grenade
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;
    
	SIMONMultiTarget = new class'X2AbilityMultiTarget_Lucu_CombatEngineer_SIMON';
	SIMONMultiTarget.bUseWeaponRadius = true;
	SIMONMultiTarget.bUseWeaponBlockingCoverFlag = true;
	Template.AbilityMultiTargetStyle = SIMONMultiTarget;
    
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	GrenadeCondition = new class'X2Condition_AbilitySourceWeapon';
	GrenadeCondition.CheckGrenadeFriendlyFire = true;
	Template.AbilityMultiTargetConditions.AddItem(GrenadeCondition);
    
	Template.AddShooterEffectExclusions();
    
	Template.bRecordValidTiles = true;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
    
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_AmmoCost');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_firerocket";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_GRENADE_PRIORITY;
	Template.bUseAmmoAsChargesForHUD = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
    
	// Scott W says a Launcher VO cue doesn't exist, so I should use this one.  mdomowicz 2015_08_24
	Template.ActivationSpeech = 'ThrowGrenade';
    
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.TargetingMethod = class'X2TargetingMethod_Lucu_CombatEngineer_SIMON';
	Template.CinescriptCameraType = "Grenadier_GrenadeLauncher";
    
	// This action is considered 'hostile' and can be interrupted!
	Template.Hostility = eHostility_Offensive;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.ActionFireClass = class'X2Action_Lucu_CombatEngineer_FireOnce';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;

	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;
}

//---------------------------------------------------------------------------------------------------
// Deployable Cover
//---------------------------------------------------------------------------------------------------

static function X2AbilityTemplate DeployableCover()
{
	local X2AbilityTemplate									        Template;
	local X2Effect_PersistentStatChange						        StatChangeEffect;
	local X2Effect_Lucu_CombatEngineer_TransientUtilityItem	        TransientItemEffect;
    local X2Condition_Lucu_CombatEngineer_HasTech                   TechCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.DeployableCoverAbilityTemplateName);

	Template.AdditionalAbilities.AddItem(default.PlaceDeployableCoverAbilityTemplateName);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Lucu_CombatEngineer.UIPerk_deployablecover";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	// Expand the unit's utility items to allow the transient item. This goes before the transient item effect
	StatChangeEffect = new class'X2Effect_PersistentStatChange';
	StatChangeEffect.EffectName = 'Lucu_CombatEngineer_TransientDeployableCoverUtilitySlot';
	StatChangeEffect.BuildPersistentEffect(1, true, false);
	StatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	StatChangeEffect.DuplicateResponse = eDupe_Allow;
	StatChangeEffect.AddPersistentStatChange(eStat_UtilityItems, 1);
	Template.AddTargetEffect(StatChangeEffect);

    // Lo Cover
	TransientItemEffect = new class'X2Effect_Lucu_CombatEngineer_TransientUtilityItem';
	TransientItemEffect.EffectName = 'Lucu_CombatEngineer_DeployableCover_Lo';
	TransientItemEffect.BuildPersistentEffect(1, true, false);
	TransientItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	TransientItemEffect.DuplicateResponse = eDupe_Allow;
	TransientItemEffect.AbilityTemplateName = default.PlaceDeployableCoverAbilityTemplateName;
	TransientItemEffect.ItemTemplateName = class'X2Item_Lucu_CombatEngineer_Weapons'.default.DeployableCoverLoItemName;
    TransientItemEffect.ClipSize = default.DeployableCoverCharges;
    TechCondition = new class'X2Condition_Lucu_CombatEngineer_HasTech';
    TechCondition.TechNames.AddItem(class'X2StrategyElement_Lucu_CombatEngineer_Techs'.default.DeployableCoverMKIITechTemplateName);
    TechCondition.HasTech = false;
    TransientItemEffect.TargetConditions.AddItem(TechCondition);
	Template.AddTargetEffect(TransientItemEffect);

    // Hi Cover
	TransientItemEffect = new class'X2Effect_Lucu_CombatEngineer_TransientUtilityItem';
	TransientItemEffect.EffectName = 'Lucu_CombatEngineer_DeployableCover_Hi';
	TransientItemEffect.BuildPersistentEffect(1, true, false);
	TransientItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	TransientItemEffect.DuplicateResponse = eDupe_Allow;
	TransientItemEffect.AbilityTemplateName = default.PlaceDeployableCoverAbilityTemplateName;
	TransientItemEffect.ItemTemplateName = class'X2Item_Lucu_CombatEngineer_Weapons'.default.DeployableCoverHiItemName;
    TransientItemEffect.ClipSize = default.DeployableCoverCharges;
    TechCondition = new class'X2Condition_Lucu_CombatEngineer_HasTech';
    TechCondition.TechNames.AddItem(class'X2StrategyElement_Lucu_CombatEngineer_Techs'.default.DeployableCoverMKIITechTemplateName);
    TransientItemEffect.TargetConditions.AddItem(TechCondition);
	Template.AddTargetEffect(TransientItemEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	
	return Template;
}

static function X2AbilityTemplate PlaceDeployableCover()
{
	local X2AbilityTemplate                                         Template;
	local X2AbilityCost_Ammo				                        AmmoCost;
	local X2AbilityCost_Lucu_CombatEngineer_FreeAbilityEffect       ActionPointCost;
	local X2AbilityTarget_Lucu_CombatEngineer_Deployable    	    AbilityTarget;
	local X2AbilityMultiTarget_Lucu_CombatEngineer_DeployableCover  RadiusMultiTarget;
	local X2Effect_Lucu_CombatEngineer_SpawnDeployable              SpawnDeployableEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.PlaceDeployableCoverAbilityTemplateName);
    
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
    
	ActionPointCost = new class'X2AbilityCost_Lucu_CombatEngineer_FreeAbilityEffect';
	ActionPointCost.iNumPoints = 1;
    ActionPointCost.DoNotConsumeEffects.AddItem(default.RapidDeploymentEffectName);
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.TargetingMethod = class'X2TargetingMethod_Pillar';

	AbilityTarget = new class'X2AbilityTarget_Lucu_CombatEngineer_Deployable';
	Template.AbilityTargetStyle = AbilityTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Lucu_CombatEngineer_DeployableCover';
	RadiusMultiTarget.fTargetRadius = 0.25; // small amount so it just grabs one tile
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Template.AbilitySourceName = 'eAbilitySource_Perk';
    
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Defensive;
	Template.IconImage = "img:///UILibrary_Lucu_CombatEngineer.UIPerk_deployablecover";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.ConcealmentRule = eConceal_Always;
	Template.bUseAmmoAsChargesForHUD = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
    Template.bSkipExitCoverWhenFiring = true;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	SpawnDeployableEffect = new class'X2Effect_Lucu_CombatEngineer_SpawnDeployable';
    SpawnDeployableEffect.EffectName = 'Lucu_CombatEngineer_DeployableCover';
	SpawnDeployableEffect.DuplicateResponse = eDupe_Allow;
    SpawnDeployableEffect.BuildPersistentEffect(1, true, false, false);
	Template.AddShooterEffect(SpawnDeployableEffect);
    
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = DeployableCover_BuildVisualization;
	Template.CustomFireAnim = 'HL_LootBodyStart';
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
    
	Template.CinescriptCameraType = "StandardGrenadeFiring";

	return Template;
}

function DeployableCover_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameState_Destructible DestructibleState;
	local VisualizationActionMetadata BuildTrack;

	TypicalAbility_BuildVisualization(VisualizeGameState);

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Destructible', DestructibleState)
	{
		break;
	}
	`assert(DestructibleState != none);

	BuildTrack.StateObject_NewState = DestructibleState;
	BuildTrack.StateObject_OldState = DestructibleState;
	BuildTrack.VisualizeActor = `XCOMHISTORY.GetVisualizer(DestructibleState.ObjectID);

	class'X2Action_ShowSpawnedDestructible'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext());
}

//---------------------------------------------------------------------------------------------------
// Rapid Deployment
//---------------------------------------------------------------------------------------------------

// TODO: Update to apply to all utility items and heavy weapons

static function X2AbilityTemplate RapidDeployment()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCooldown				Cooldown;
	local X2Effect_Persistent           Effect;
	local X2AbilityCost_ActionPoints    ActionPointCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.RapidDeploymentAbilityTemplateName);

	Template.DisplayTargetHitChance = false;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///UILibrary_Lucu_CombatEngineer.UIPerk_rapidDeployment";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.RapidDeploymentCooldown;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Effect = new class'X2Effect_Persistent';
    Effect.EffectName = default.RapidDeploymentEffectName;
	Effect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddTargetEffect(Effect);

	Template.AbilityTargetStyle = default.SelfTarget;	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate Skirmisher()
{
	local X2AbilityTemplate Template;
    local X2Effect_Lucu_CombatEngineer_Skirmisher SkirmisherEffect;
    
	`CREATE_X2ABILITY_TEMPLATE(Template, default.SkirmisherAbilityTemplateName);

	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Momentum";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;
    
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
    
	SkirmisherEffect = new class'X2Effect_Lucu_CombatEngineer_Skirmisher';
	SkirmisherEffect.BuildPersistentEffect(1, true, false);
	SkirmisherEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(SkirmisherEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// Note: no visualization on purpose!

	Template.bCrossClassEligible = true;

	return Template;
}

//---------------------------------------------------------------------------------------------------
// Sentry Camera
//---------------------------------------------------------------------------------------------------

// TODO: Add Sentry Camera item and throw abilities
// TODO: Add Sentry Camera destructible archetype

DefaultProperties
{
    MovingMeleeAbilityTemplateName="Lucu_CombatEngineer_MovingMelee"
    CrippledEffectName="Lucu_CombatEngineer_Cripple"
    DetPackAbilityTemplateName="Lucu_CombatEngineer_DetPack"
	ThrowDetPackAbilityTemplateName="Lucu_CombatEngineer_ThrowDetPack"
    DetPackEffectName="Lucu_CombatEngineer_DetPack"
    DetonateAbilityTemplateName="Lucu_CombatEngineer_Detonate"
    SIMONAbilityTemplateName="Lucu_CombatEngineer_SIMON"
    LaunchSIMONAbilityTemplateName="Lucu_CombatEngineer_LaunchSIMON"
    DeployableCoverAbilityTemplateName="Lucu_CombatEngineer_DeployableCover"
    PlaceDeployableCoverAbilityTemplateName="Lucu_CombatEngineer_PlaceDeployableCover"
    DeployableCoverLoArchetype="Lucu_CombatEngineer_DeployableCover.Archetypes.ARC_DeployableCover_1_Lo"
    DeployableCoverHiArchetype="Lucu_CombatEngineer_DeployableCover.Archetypes.ARC_DeployableCover_1_Hi"
    SentryCameraAbilityTemplateName="Lucu_CombatEngineer_SentryCamera"
    ThrowSentryCameraAbilityTemplateName="Lucu_CombatEngineer_ThrowSentryCamera"
    RapidDeploymentAbilityTemplateName="Lucu_CombatEngineer_RapidDeployment"
    RapidDeploymentEffectName="Lucu_CombatEngineer_RapidDeployment"
    PackmasterAbilityTemplateName="Lucu_CombatEngineer_Packmaster"
    SkirmisherAbilityTemplateName="Lucu_CombatEngineer_Skirmisher"
    AcceptableTolerancesAbilityTemplateName="Lucu_CombatEngineer_AcceptableTolerances"
}
