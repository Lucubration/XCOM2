class X2Ability_Beags_Escalation_ScoutAbilitySet extends X2Ability
	config(Beags_Escalation_Ability);

var config float AwarenessRadius;
var config float GhostDetectionRadiusModifier;
var config float ReconSightRadiusBonus;

var name AwarenessActiveEffectName;
var name AwarenessPassiveAbilityName;
var name AwarenessPassiveEffectName;

// This method is natively called for subclasses of X2DataSet. It'll create and return ability templates for our new class
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.Length = 0;
	Templates.AddItem(BattleScanner());
	Templates.AddItem(Assassinate());
	Templates.AddItem(Awareness());
	Templates.AddItem(AwarenessPassive());
	Templates.AddItem(Ghost());
	Templates.AddItem(Recon());
	Templates.AddItem(LowProfile());

	return Templates;
}


//---------------------------------------------------------------------------------------------------
// Battle Scanner
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate BattleScanner()
{
	local X2AbilityTemplate									Template;
	local X2AbilityTargetStyle								TargetStyle;
	local X2AbilityTrigger									Trigger;
	local X2Effect_PersistentStatChange						StatChangeEffect;
	local X2Effect_Beags_Escalation_TransientUtilityItem	TransientItemEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_BattleScanner');

	// Give the normal BattleScanner ability so that it will always show up in tactical, even without the item equipped
	Template.AdditionalAbilities.AddItem('BattleScanner');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_item_battlescanner";

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	// Expand the unit's utility items to allow the transient item. This goes before the transient item effect
	StatChangeEffect = new class'X2Effect_PersistentStatChange';
	StatChangeEffect.EffectName = 'Beags_Escalation_TransientBattleScannerUtilitySlot';
	StatChangeEffect.BuildPersistentEffect(1, true, false);
	StatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	StatChangeEffect.DuplicateResponse = eDupe_Ignore;
	StatChangeEffect.AddPersistentStatChange(eStat_UtilityItems, 1); // Can't think of any clever way to make this value based on the item template, so I'll just hardcode the item size for now
	Template.AddTargetEffect(StatChangeEffect);

	TransientItemEffect = new class'X2Effect_Beags_Escalation_TransientUtilityItem';
	TransientItemEffect.EffectName = 'Beags_Escalation_TransientBattleScanner';
	TransientItemEffect.BuildPersistentEffect(1, true, false);
	TransientItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	TransientItemEffect.DuplicateResponse = eDupe_Ignore;
	TransientItemEffect.AbilityTemplateName = 'BattleScanner';
	TransientItemEffect.ItemTemplateName = 'BattleScanner';
	Template.AddTargetEffect(TransientItemEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	
	Template.bCrossClassEligible = true;

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Assassinate
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate Assassinate()
{
	local X2AbilityTemplate								Template;
	local X2AbilityTargetStyle							TargetStyle;
	local X2AbilityTrigger								Trigger;
	local X2Effect_Beags_Escalation_Assassinate			AssassinateEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_Assassinate');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_assassinate";

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	AssassinateEffect = new class'X2Effect_Beags_Escalation_Assassinate';
	AssassinateEffect.EffectName = 'Beags_Escalation_Assassinate';
	AssassinateEffect.BuildPersistentEffect(1, true, false);
	AssassinateEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	AssassinateEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(AssassinateEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Awareness
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate Awareness()
{
	local X2AbilityTemplate								Template;
	local X2AbilityTrigger_EventListener				EventListener;
	local X2Effect_Beags_Escalation_Awareness			AwarenessEffect;
	local X2Condition_UnitProperty						DistanceCondition;
	local X2Condition_UnitProperty						EnemyCondition;
	local X2Condition_Beags_Escalation_VisibleToPlayer	VisibleCondition;
	
	`LOG("Beags Escalation: Awareness radius=" @ string(default.AwarenessRadius));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_Awareness');
	
	Template.AdditionalAbilities.AddItem(default.AwarenessPassiveAbilityName);

	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_awareness";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitMoveFinished';
	EventListener.ListenerData.Filter = eFilter_None;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.SolaceCleanseListener; // This seems pretty generic. Should work for our use
	Template.AbilityTriggers.AddItem(EventListener);

	AwarenessEffect = new class'X2Effect_Beags_Escalation_Awareness';
	AwarenessEffect.EffectName = default.AwarenessActiveEffectName;
	AwarenessEffect.BuildPersistentEffect(1, true, true);
	AwarenessEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, false,, Template.AbilitySourceName);
	AwarenessEffect.DuplicateResponse = eDupe_Ignore;
	AwarenessEffect.bRemoveWhenTargetDies = true;
	EnemyCondition = new class'X2Condition_UnitProperty';
	EnemyCondition.ExcludeFriendlyToSource = true;
	EnemyCondition.ExcludeHostileToSource = false;
	AwarenessEffect.TargetConditions.AddItem(EnemyCondition);
	VisibleCondition = new class'X2Condition_Beags_Escalation_VisibleToPlayer';
	VisibleCondition.IsVisible = false;
	AwarenessEffect.TargetConditions.AddItem(VisibleCondition);
	Template.AddTargetEffect(AwarenessEffect);

	DistanceCondition = new class'X2Condition_UnitProperty';
	DistanceCondition.RequireWithinRange = true;
	DistanceCondition.WithinRange = default.AwarenessRadius;
	DistanceCondition.ExcludeFriendlyToSource = false;
	DistanceCondition.ExcludeHostileToSource = false;
	Template.AbilityTargetConditions.AddItem(DistanceCondition);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate AwarenessPassive()
{
	local X2AbilityTemplate								Template;
	local X2Effect_Beags_Escalation_AwarenessPassive	AwarenessEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.AwarenessPassiveAbilityName);

	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_awareness";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	//  This is a dummy effect so that an icon shows up in the UI.
	AwarenessEffect = new class'X2Effect_Beags_Escalation_AwarenessPassive';
	AwarenessEffect.EffectName = default.AwarenessPassiveEffectName;
	AwarenessEffect.BuildPersistentEffect(1, true, false);
	AwarenessEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(AwarenessEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// Note: no visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Ghost
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate Ghost()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTargetStyle				TargetStyle;
	local X2AbilityTrigger					Trigger;
	local X2Effect_PersistentStatChange		GhostEffect;

	`LOG("Beags Escalation: Ghost detection radius modifier=" @ string(default.GhostDetectionRadiusModifier));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_Ghost');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_ghost";

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	GhostEffect = new class'X2Effect_PersistentStatChange';
	GhostEffect.EffectName = 'Beags_Escalation_Ghost';
	GhostEffect.AddPersistentStatChange(eStat_DetectionModifier, default.GhostDetectionRadiusModifier);
	GhostEffect.BuildPersistentEffect(1, true, false);
	GhostEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	GhostEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(GhostEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Recon
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate Recon()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTargetStyle				TargetStyle;
	local X2AbilityTrigger					Trigger;
	local X2Effect_PersistentStatChange		ReconEffect;

	`LOG("Beags Escalation: Recon sight radius bonus=" @ string(default.ReconSightRadiusBonus));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_Recon');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_recon";

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	ReconEffect = new class'X2Effect_PersistentStatChange';
	ReconEffect.EffectName = 'Beags_Escalation_Recon';
	ReconEffect.AddPersistentStatChange(eStat_SightRadius, `UNITSTOTILES(default.ReconSightRadiusBonus));
	ReconEffect.BuildPersistentEffect(1, true, false);
	ReconEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	ReconEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(ReconEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Low Profile
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate LowProfile()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTargetStyle				TargetStyle;
	local X2AbilityTrigger					Trigger;
	local X2Effect_LowProfile				LowProfileEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_LowProfile');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_lowprofile";

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	LowProfileEffect = new class'X2Effect_LowProfile';
	LowProfileEffect.EffectName = 'Beags_Escalation_LowProfile';
	LowProfileEffect.BuildPersistentEffect(1, true, false);
	LowProfileEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	LowProfileEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(LowProfileEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


DefaultProperties
{
	AwarenessActiveEffectName="Beags_Escalation_Awareness"
	AwarenessPassiveAbilityName="Beags_Escalation_AwarenessPassive"
	AwarenessPassiveEffectName="Beags_Escalation_AwarenessPassive"
}