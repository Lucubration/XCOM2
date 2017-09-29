class X2Ability_Lucu_CombatEngineer_CombatEngineerAbilitySet extends X2Ability
	config(Lucu_CombatEngineer_Ability);

var config int DetPackCharges;
var config int SIMONCharges;
var config int PackmasterCharges;

var name ThrowDetPackAbilityTemplateName;
var name DetPackEffectName;
var name DetonateAbilityTemplateName;
var name SIMONAbilityTemplateName;
var name LaunchSIMONAbilityTemplateName;
var name SIMONFuseAbilityTemplateName;
var string DeployableCoverLoArchetype;
var string DeployableCoverHiArchetype;
var name PackmasterAbilityName;
    
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(ThrowDetPack());
    Templates.AddItem(Detonate());
    Templates.AddItem(SIMON());
    Templates.AddItem(LaunchSIMON());
    Templates.AddItem(SIMONFuse());
    Templates.AddItem(DeployableCover());
	
	return Templates;
}

//---------------------------------------------------------------------------------------------------
// Throw Det Pack
//---------------------------------------------------------------------------------------------------

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
    local X2Condition_Lucu_CombatEngineer_AbilitySourceWeaponTech   WeaponTechCondition;

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
	StatChangeEffect.AddPersistentStatChange(eStat_UtilityItems, 1); // Can't think of any clever way to make this value based on the item template, so I'll just hardcode the item size for now
	Template.AddTargetEffect(StatChangeEffect);

    // Two of these effects, to add two ammo. It's either this or change the template's clip size

    // Conventional
	TransientItemEffect = new class'X2Effect_Lucu_CombatEngineer_TransientUtilityItem';
	TransientItemEffect.EffectName = 'Lucu_CombatEngineer_SIMON_CV';
	TransientItemEffect.BuildPersistentEffect(1, true, false);
	TransientItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	TransientItemEffect.DuplicateResponse = eDupe_Allow;
	TransientItemEffect.AbilityTemplateName = default.LaunchSIMONAbilityTemplateName;
	TransientItemEffect.ItemTemplateName = class'X2Item_Lucu_CombatEngineer_Weapons'.default.SIMONCVItemName;
	TransientItemEffect.UseItemAsAmmo = true;
    WeaponTechCondition = new class'X2Condition_Lucu_CombatEngineer_AbilitySourceWeaponTech';
    WeaponTechCondition.WeaponTech.AddItem('conventional');
    TransientItemEffect.TargetConditions.AddItem(WeaponTechCondition);
	Template.AddTargetEffect(TransientItemEffect);

	TransientItemEffect = new class'X2Effect_Lucu_CombatEngineer_TransientUtilityItem';
	TransientItemEffect.EffectName = 'Lucu_CombatEngineer_SIMON_CV';
	TransientItemEffect.BuildPersistentEffect(1, true, false);
	TransientItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	TransientItemEffect.DuplicateResponse = eDupe_Allow;
	TransientItemEffect.AbilityTemplateName = default.LaunchSIMONAbilityTemplateName;
	TransientItemEffect.ItemTemplateName = class'X2Item_Lucu_CombatEngineer_Weapons'.default.SIMONCVItemName;
	TransientItemEffect.UseItemAsAmmo = true;
    WeaponTechCondition = new class'X2Condition_Lucu_CombatEngineer_AbilitySourceWeaponTech';
    WeaponTechCondition.WeaponTech.AddItem('conventional');
    TransientItemEffect.TargetConditions.AddItem(WeaponTechCondition);
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
    WeaponTechCondition = new class'X2Condition_Lucu_CombatEngineer_AbilitySourceWeaponTech';
    WeaponTechCondition.WeaponTech.AddItem('magnetic');
    TransientItemEffect.TargetConditions.AddItem(WeaponTechCondition);
	Template.AddTargetEffect(TransientItemEffect);

	TransientItemEffect = new class'X2Effect_Lucu_CombatEngineer_TransientUtilityItem';
	TransientItemEffect.EffectName = 'Lucu_CombatEngineer_SIMON_MG';
	TransientItemEffect.BuildPersistentEffect(1, true, false);
	TransientItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	TransientItemEffect.DuplicateResponse = eDupe_Allow;
	TransientItemEffect.AbilityTemplateName = default.LaunchSIMONAbilityTemplateName;
	TransientItemEffect.ItemTemplateName = class'X2Item_Lucu_CombatEngineer_Weapons'.default.SIMONMGItemName;
	TransientItemEffect.UseItemAsAmmo = true;
    WeaponTechCondition = new class'X2Condition_Lucu_CombatEngineer_AbilitySourceWeaponTech';
    WeaponTechCondition.WeaponTech.AddItem('magnetic');
    TransientItemEffect.TargetConditions.AddItem(WeaponTechCondition);
	Template.AddTargetEffect(TransientItemEffect);


    // Beam
	TransientItemEffect = new class'X2Effect_Lucu_CombatEngineer_TransientUtilityItem';
	TransientItemEffect.EffectName = 'Lucu_CombatEngineer_SIMON_BM';
	TransientItemEffect.BuildPersistentEffect(1, true, false);
	TransientItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	TransientItemEffect.DuplicateResponse = eDupe_Allow;
	TransientItemEffect.AbilityTemplateName = default.LaunchSIMONAbilityTemplateName;
	TransientItemEffect.ItemTemplateName = class'X2Item_Lucu_CombatEngineer_Weapons'.default.SIMONBMItemName;
	TransientItemEffect.UseItemAsAmmo = true;
    WeaponTechCondition = new class'X2Condition_Lucu_CombatEngineer_AbilitySourceWeaponTech';
    WeaponTechCondition.WeaponTech.AddItem('beam');
    WeaponTechCondition.WeaponTech.AddItem('alien');
    TransientItemEffect.TargetConditions.AddItem(WeaponTechCondition);
	Template.AddTargetEffect(TransientItemEffect);

	TransientItemEffect = new class'X2Effect_Lucu_CombatEngineer_TransientUtilityItem';
	TransientItemEffect.EffectName = 'Lucu_CombatEngineer_SIMON_BM';
	TransientItemEffect.BuildPersistentEffect(1, true, false);
	TransientItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	TransientItemEffect.DuplicateResponse = eDupe_Allow;
	TransientItemEffect.AbilityTemplateName = default.LaunchSIMONAbilityTemplateName;
	TransientItemEffect.ItemTemplateName = class'X2Item_Lucu_CombatEngineer_Weapons'.default.SIMONBMItemName;
	TransientItemEffect.UseItemAsAmmo = true;
    WeaponTechCondition = new class'X2Condition_Lucu_CombatEngineer_AbilitySourceWeaponTech';
    WeaponTechCondition.WeaponTech.AddItem('beam');
    WeaponTechCondition.WeaponTech.AddItem('alien');
    TransientItemEffect.TargetConditions.AddItem(WeaponTechCondition);
	Template.AddTargetEffect(TransientItemEffect);


	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	
	return Template;
}

static function X2AbilityTemplate LaunchSIMON()
{
	local X2AbilityTemplate					                Template;
	local X2AbilityCost_Ammo				                AmmoCost;
	local X2AbilityCost_ActionPoints                        ActionPointCost;
	local X2AbilityToHitCalc_StandardAim                    StandardAim;
	local X2AbilityTarget_Cursor                            CursorTarget;
	local X2AbilityMultiTarget_Lucu_CombatEngineer_SIMON    SIMONMultiTarget;
	local X2Condition_UnitProperty                          UnitPropertyCondition;
	local X2Condition_AbilitySourceWeapon	                GrenadeCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.LaunchSIMONAbilityTemplateName);

	Template.AbilityCosts.AddItem(default.WeaponActionTurnEnding);

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	AmmoCost.UseLoadedAmmo = true;
	Template.AbilityCosts.AddItem(AmmoCost);
    
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Salvo');
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

static function X2AbilityTemplate SIMONFuse()
{
	local X2AbilityTemplate                             Template;
	local X2AbilityCost_Ammo                            AmmoCost;
	local X2AbilityMultiTarget_Radius                   RadiusMultiTarget;
	local X2Condition_UnitProperty                      UnitPropertyCondition;
	local X2AbilityTrigger_EventListener                EventListener;
	local X2AbilityToHitCalc_StandardAim                StandardAim;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.SIMONFuseAbilityTemplateName);
	
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
		
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;

	Template.AbilityTargetStyle = default.SelfTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bAddPrimaryTargetAsMultiTarget = true;
	RadiusMultiTarget.bUseWeaponRadius = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.FailOnNonUnits = false; 
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.FuseListener;
	EventListener.ListenerData.EventID = class'X2Ability_PsiOperativeAbilitySet'.default.FuseEventName;
	EventListener.ListenerData.Filter = eFilter_None;
	Template.AbilityTriggers.AddItem(EventListener);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_firerocket";
	Template.bUseAmmoAsChargesForHUD = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.MergeVisualizationFn = FuseMergeVisualization;
	Template.bShowActivation = true;
	Template.bSkipExitCoverWhenFiring = true;
	Template.ActionFireClass = class'X2Action_Fire_IgniteFuse';
	Template.bHideWeaponDuringFire = true;
	Template.Hostility = eHostility_Offensive;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;

	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;	
}

static function X2AbilityTemplate DeployableCover()
{
	local X2AbilityTemplate                                         Template;
	local X2AbilityTarget_Lucu_CombatEngineer_DeployableCover	    Cursor;
	local X2AbilityMultiTarget_Lucu_CombatEngineer_DeployableCover  RadiusMultiTarget;
	local X2AbilityCost_ActionPoints                                ActionPointCost;
	local X2Effect_SpawnDestructible                                SpawnCoverEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_CombatEngineer_DeployableCover')

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.TargetingMethod = class'X2TargetingMethod_Pillar';

	Cursor = new class'X2AbilityTarget_Lucu_CombatEngineer_DeployableCover';
    Cursor.FixedAbilityRange = 1;
	Template.AbilityTargetStyle = Cursor;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Lucu_CombatEngineer_DeployableCover';
	RadiusMultiTarget.fTargetRadius = 0.25; // small amount so it just grabs one tile
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
    
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Defensive;
	Template.IconImage = "img:///UILibrary_Lucu_CombatEngineer.UIPerk_deployablecover";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.ConcealmentRule = eConceal_Always;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	SpawnCoverEffect = new class'X2Effect_SpawnDestructible';
    SpawnCoverEffect.EffectName = 'Lucu_CombatEngineer_DeployableCover';
	SpawnCoverEffect.DuplicateResponse = eDupe_Allow;
    SpawnCoverEffect.BuildPersistentEffect(1, true, false, false);
	SpawnCoverEffect.DestructibleArchetype = default.DeployableCoverLoArchetype;
	Template.AddShooterEffect(SpawnCoverEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = DeployableCover_BuildVisualization;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
    
	Template.CinescriptCameraType = "Loot";

	return Template;
}

function DeployableCover_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local VisualizationActionMetadata ActionMetadata;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit SourceUnit;
	local X2Action_PlayAnimation PlayAnimAction;
	local XComGameState_Destructible DestructibleState;
	local VisualizationActionMetadata BuildTrack;
    
	History = `XCOMHISTORY;
	AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID,,VisualizeGameState.HistoryIndex));

	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(SourceUnit.ObjectID,, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = SourceUnit;
	ActionMetadata.VisualizeActor = SourceUnit.GetVisualizer();

	class'X2Action_ExitCover'.static.AddToVisualizationTree(ActionMetadata, AbilityContext);

	PlayAnimAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	PlayAnimAction.bFinishAnimationWait = true;
	PlayAnimAction.Params.AnimName = 'HL_LootBodyStart';

	PlayAnimAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	PlayAnimAction.bFinishAnimationWait = true;
	PlayAnimAction.Params.AnimName = 'HL_LootStop';

	class'X2Action_EnterCover'.static.AddToVisualizationTree(ActionMetadata, AbilityContext);

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

DefaultProperties
{
	ThrowDetPackAbilityTemplateName="Lucu_CombatEngineer_ThrowDetPack"
    DetPackEffectName="Lucu_CombatEngineer_DetPack"
    DetonateAbilityTemplateName="Lucu_CombatEngineer_Detonate"
    SIMONAbilityTemplateName="Lucu_CombatEngineer_SIMON"
    LaunchSIMONAbilityTemplateName="Lucu_CombatEngineer_LaunchSIMON"
    SIMONFuseAbilityTemplateName="Lucu_CombatEngineer_SIMONFuse"
    DeployableCoverLoArchetype="Lucu_CombatEngineer_DeployableCover.Archetypes.ARC_Lucu_CombatEngineer_DeployableCover_1_Lo"
    DeployableCoverHiArchetype="Lucu_CombatEngineer_DeployableCover.Archetypes.ARC_Lucu_CombatEngineer_DeployableCover_1_Hi"
    PackmasterAbilityName="Lucu_CombatEngineer_Packmaster"
}
