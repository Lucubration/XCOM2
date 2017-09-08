//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_XPackAbilitySet.uc
//  AUTHOR:  Russell Aasland  --  02/13/2017
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Ability_XPackAbilitySet extends X2Ability
	config(GameCore);

var config int DISRUPTOR_RIFLE_PSI_CRIT;
var localized string DisruptorRifleCritDisplayText;

var config int WEAPON_TECH_BREAKTHROUGH_BONUS;
var config int WEAPON_TYPE_BREAKTHROUGH_BONUS;
var config float ARMOR_TYPE_BREAKTHROUGH_BONUS;
var config float PURIFIER_AUTOPSY_VEST_HEALTH_BONUS;

var config float INFORMATION_WAR_HACK_DEBUFF;
var localized string TacticalAnalysisFlyoverText;
var localized string TacticalAnalysisWorldMessageText;

var config WeaponDamageValue FEEDBACK_DAMAGE;
var localized string FeedbackFlyoverText;

/// <summary>
/// Creates the set of default abilities every unit should have in X-Com 2
/// </summary>
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	// Technology Breakthroughs
	Templates.AddItem( AddWeaponTechBreakthroughBonus() );
	Templates.AddItem( AddWeaponTypeBreakthroughBonus() );
	Templates.AddItem( AddArmorTypeBreakthroughBonus() );
	Templates.AddItem( AddPurifierAutopsyVestBonus() );

	// Resistance Policies
	Templates.AddItem( AddBetweenTheEyes() );
	Templates.AddItem( AddInformationWarDebuff() );
	Templates.AddItem( AddWeakPoints() );
	Templates.AddItem( AddTacticalAnalysis() );
	Templates.AddItem( AddFeedback() );

	Templates.AddItem(DisruptorRifleCrit());

	return Templates;
}

static function X2AbilityTemplate AddWeaponTechBreakthroughBonus()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_BonusWeaponDamage			BonusEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'WeaponTechBreakthroughBonus');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	BonusEffect = new class'X2Effect_BonusWeaponDamage';
	BonusEffect.BuildPersistentEffect(1, true, true, true);
	BonusEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, "", "", false);
	BonusEffect.BonusDmg = default.WEAPON_TECH_BREAKTHROUGH_BONUS;
	BonusEffect.bDisplayInSpecialDamageMessageUI = false;
	Template.AddTargetEffect(BonusEffect);

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddWeaponTypeBreakthroughBonus()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_BonusWeaponDamage			BonusEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'WeaponTypeBreakthroughBonus');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	BonusEffect = new class'X2Effect_BonusWeaponDamage';
	BonusEffect.BuildPersistentEffect(1, true, true, true);
	BonusEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, "", "", false );
	BonusEffect.BonusDmg = default.WEAPON_TYPE_BREAKTHROUGH_BONUS;
	BonusEffect.bDisplayInSpecialDamageMessageUI = false;
	Template.AddTargetEffect(BonusEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddArmorTypeBreakthroughBonus()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ArmorTypeBreakthroughBonus');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	//
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	// PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, default.MediumPlatedHealthBonusName, default.MediumPlatedHealthBonusDesc, Template.IconImage);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_HP, default.ARMOR_TYPE_BREAKTHROUGH_BONUS);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddPurifierAutopsyVestBonus()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'PurifierAutopsyVestBonus');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	//
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	// PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, default.MediumPlatedHealthBonusName, default.MediumPlatedHealthBonusDesc, Template.IconImage);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_HP, default.PURIFIER_AUTOPSY_VEST_HEALTH_BONUS);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddBetweenTheEyes()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_LethalWeaponDamage			BonusEffect;
	local X2Condition_UnitType					UnitTypeCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'BetweenTheEyes');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_betweentheeyes";

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	BonusEffect = new class'X2Effect_LethalWeaponDamage';
	BonusEffect.BuildPersistentEffect(1, true, true, true);
	BonusEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);

	UnitTypeCondition = new class'X2Condition_UnitType';
	UnitTypeCondition.IncludeTypes.AddItem('TheLost');
	BonusEffect.LethalDamageConditions.AddItem( UnitTypeCondition );

	Template.AddTargetEffect(BonusEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddInformationWarDebuff()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'InformationWar');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	//
	Template.AddTargetEffect( class'X2StatusEffects'.static.CreateHackDefenseChangeStatusEffect( -default.INFORMATION_WAR_HACK_DEBUFF ) );

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddWeakPoints( )
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_WeakPoint					WeakPointEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'WeakPoints');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	//
	WeakPointEffect = new class'X2Effect_WeakPoint';
	WeakPointEffect.BuildPersistentEffect(1, true, false, false);
	WeakPointEffect.GetValueFn = class'X2StrategyElement_XpackResistanceActions'.static.GetValueWeakPoints;
	// WeakPointEffect.SetDisplayInfo(ePerkBuff_Passive, default.MediumPlatedHealthBonusName, default.MediumPlatedHealthBonusDesc, Template.IconImage);
	Template.AddTargetEffect(WeakPointEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddTacticalAnalysis()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2Effect_Stunned				StunnedEffect;
	local X2Condition_UnitProperty UnitPropCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'TacticalAnalysis');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = class'X2Ability'.default.DeadEye;

	Template.AbilityTargetStyle = default.SelfTarget;

	StunnedEffect = new class'X2Effect_Stunned';
	StunnedEffect.BuildPersistentEffect(1, true, true, false, eGameRule_UnitGroupTurnBegin);
	StunnedEffect.ApplyChance = 100;
	StunnedEffect.StunLevel = 1;
	StunnedEffect.bIsImpairing = true;
	StunnedEffect.EffectName = 'TacticalAnalysis';
	StunnedEffect.EffectTickedVisualizationFn = TacticalAnalysisVisualizationTicked;
	StunnedEffect.EffectRemovedVisualizationFn = TacticalAnalysisVisualizationTicked;
	StunnedEffect.bRemoveWhenTargetDies = true;
	StunnedEffect.bCanTickEveryAction = true;
	StunnedEffect.bSkipAnimation = true;
	StunnedEffect.CustomIdleOverrideAnim = '';
	StunnedEffect.DamageTypes.Length = 0;

	UnitPropCondition = new class'X2Condition_UnitProperty';
	UnitPropCondition.ExcludeFriendlyToSource = false;
	UnitPropCondition.FailOnNonUnits = true;
	StunnedEffect.TargetConditions.AddItem(UnitPropCondition);
	Template.AddTargetEffect( StunnedEffect );

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;
	Template.FrameAbilityCameraType = eCameraFraming_Never;

	return Template;
}

static function TacticalAnalysisVisualizationTicked(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(ActionMetadata.StateObject_NewState.ObjectID));
	if (UnitState == none)
		return;

	// dead units should not be reported
	if( !UnitState.IsAlive() )
	{
		return;
	}

	class'X2StatusEffects'.static.AddEffectCameraPanToAffectedUnitToTrack(ActionMetadata, VisualizeGameState.GetContext());
	class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), default.TacticalAnalysisFlyoverText, '', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_Stunned);
	class'X2StatusEffects'.static.AddEffectMessageToTrack(ActionMetadata,
														  default.TacticalAnalysisWorldMessageText,
														  VisualizeGameState.GetContext(),
														  class'UIEventNoticesTactical'.default.WillLostTitle,
														  class'UIUtilities_Image'.const.UnitStatus_Stunned,
														  eUIState_Bad);
	class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

static function X2AbilityTemplate AddFeedback( )
{
	local X2AbilityTemplate						Template;
	local X2AbilityTarget_Single				TargetStyle;
	local X2AbilityTrigger_EventListener		EventListener;
	local X2Effect_ApplyWeaponDamage			WeaponDamage;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Feedback');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Single';;
	Template.AbilityTargetStyle = TargetStyle;

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerFeedbackListener;
	EventListener.ListenerData.EventID = 'AbilityActivated';
	//EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

	WeaponDamage = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamage.EffectDamageValue = default.FEEDBACK_DAMAGE;
	WeaponDamage.bIgnoreArmor = true;
	WeaponDamage.bBypassShields = true;
	Template.AddTargetEffect( WeaponDamage );

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = FeedbackAbility_BuildVisualization;
	Template.bSkipFireAction = true;

	return Template;
}

static function FeedbackAbility_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateVisualizationMgr VisMgr;
	local X2Action_ApplyWeaponDamageToUnit UnitDamage;
	local X2Action_PlaySoundAndFlyOver FlyOverAction;
	local VisualizationActionMetadata ActionMetadata;

	TypicalAbility_BuildVisualization( VisualizeGameState );

	VisMgr = `XCOMVISUALIZATIONMGR;

	UnitDamage = X2Action_ApplyWeaponDamageToUnit( VisMgr.GetNodeOfType( VisMgr.BuildVisTree, class'X2Action_ApplyWeaponDamageToUnit' ) );
	`assert( UnitDamage != none );

	ActionMetadata = UnitDamage.Metadata;

	FlyOverAction = X2Action_PlaySoundAndFlyOver( class'X2Action_PlaySoundAndFlyOver'.static.CreateVisualizationAction( VisualizeGameState.GetContext() ) );
	FlyOverAction.SetSoundAndFlyOverParameters( none , default.FeedbackFlyoverText, '', eColor_Bad );

	class'X2Action'.static.AddActionToVisualizationTree( FlyOverAction, ActionMetadata, VisualizeGameState.GetContext(), true, UnitDamage.ParentActions[0] );
}

static function X2AbilityTemplate DisruptorRifleCrit()
{
	local X2AbilityTemplate             Template;
	local X2Effect_ToHitModifier        PersistentEffect;
	local X2Condition_UnitProperty		TargetCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'DisruptorRifleCrit');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeNonPsionic = true;
	PersistentEffect = new class'X2Effect_ToHitModifier';
	PersistentEffect.DuplicateResponse = eDupe_Ignore;
	PersistentEffect.BuildPersistentEffect(1, true, false);
	PersistentEffect.AddEffectHitModifier(eHit_Crit, default.DISRUPTOR_RIFLE_PSI_CRIT, default.DisruptorRifleCritDisplayText,,,,,,,,true);
	PersistentEffect.ToHitConditions.AddItem(TargetCondition);
	Template.AddTargetEffect(PersistentEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// Note: no visualization on purpose!
	
	return Template;
}