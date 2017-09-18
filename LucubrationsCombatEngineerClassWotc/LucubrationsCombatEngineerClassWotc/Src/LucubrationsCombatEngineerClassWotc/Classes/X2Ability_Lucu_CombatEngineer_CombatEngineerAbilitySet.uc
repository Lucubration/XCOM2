class X2Ability_Lucu_CombatEngineer_CombatEngineerAbilitySet extends X2Ability
	config(Lucu_CombatEngineer_Ability);

var config int DetPackCharges;
var config WeaponDamageValue DetPackDamage;
var config string DetPackDestructibleArchetype;
var config int PackmasterCharges;

var name ThrowDetPackAbilityTemplateName;
var name DetPackEffectName;
var name DetonateAbilityTemplateName;
var name PackmasterAbilityName;
    
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(ThrowDetPack());
    Templates.AddItem(Detonate());
	
	return Templates;
}

static function X2AbilityTemplate ThrowDetPack()
{
	local X2AbilityTemplate						                    Template;	
	local X2AbilityCost_ActionPoints			                    ActionPointCost;
	local X2AbilityTarget_Cursor				                    CursorTarget;
	local X2AbilityMultiTarget_Lucu_CombatEngineer_DetPackRadius    RadiusMultiTarget;
	local X2Effect_Lucu_CombatEngineer_DetPack                      DetPackEffect;
	local X2AbilityCharges						                    Charges;
	local X2AbilityCost_Charges					                    ChargeCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.ThrowDetPackAbilityTemplateName);	
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);

	ChargeCost = new class'X2AbilityCost_Charges';
	Template.AbilityCosts.AddItem(ChargeCost);

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.DetPackCharges;
	Charges.AddBonusCharge(default.PackmasterAbilityName, default.PackmasterCharges);
	Template.AbilityCharges = Charges;
	
	Template.AbilityToHitCalc = default.DeadEye;

    Template.bHideAmmoWeaponDuringFire = true;
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

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
	DetPackEffect.DestructibleArchetype = default.DetPackDestructibleArchetype;
	Template.AddShooterEffect(DetPackEffect);

	//if (TemplateName != 'ThrowClaymore')
	//	Template.OverrideAbilities.AddItem('ThrowClaymore');
	
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
    MinDamagePreview = default.DetPackDamage;
    MaxDamagePreview = default.DetPackDamage;
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
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_HideSpecificErrors;
    Template.HideErrors.AddItem('AA_NoTargets');
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
    Action.AvailableCode = GatherDetonateAbilityTargets(AbilityState, Action.AvailableTargets);
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

DefaultProperties
{
	ThrowDetPackAbilityTemplateName="Lucu_CombatEngineer_ThrowDetPack"
    DetPackEffectName="Lucu_CombatEngineer_DetPack"
    DetonateAbilityTemplateName="Lucu_CombatEngineer_Detonate"
    PackmasterAbilityName="Lucu_CombatEngineer_Packmaster"
}
