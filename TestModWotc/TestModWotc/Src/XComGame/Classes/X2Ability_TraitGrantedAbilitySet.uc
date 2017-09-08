//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_TraitGrantedAbilitySet.uc
//  AUTHOR:  Dan Kaplan  --  10/24/2016
//  PURPOSE: Defines abilities made available to XCom soldiers through their personal traits in X-Com 2. 
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Ability_TraitGrantedAbilitySet extends X2Ability
	dependson (XComGameStateContext_Ability) config(GameCore);

var localized const string DemoralizedString;

var config int HUNTER_OF_X_DAMAGE_BONUS;

var protected const config WillEventRollData InsubordinateSquadmateWillRollData;
var protected const config WillEventRollData CriticSquadmateWillRollData;

/// <summary>
/// Creates the set of abilities granted to units through their personal traits in X-Com 2
/// </summary>
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	//Templates.AddItem(BuildHunterOfX('HunterOfVipersPassive', 'Viper', "img:///UILibrary_XPACK_Common.PerkIcons.strx_viperhunter"));
	//Templates.AddItem(BuildHunterOfX('HunterOfStunLancersPassive', 'AdventStunLancer', "img:///UILibrary_XPACK_Common.PerkIcons.strx_lancerhunter"));
	//Templates.AddItem(BuildHunterOfX('HunterOfArchonsPassive', 'Archon', "img:///UILibrary_XPACK_Common.PerkIcons.strx_archonhunter"));
	//Templates.AddItem(BuildHunterOfX('HunterOfMutonsPassive', 'Muton', "img:///UILibrary_XPACK_Common.PerkIcons.strx_mutonhunter"));
	//Templates.AddItem(BuildHunterOfX('HunterOfTheLostPassive', 'TheLost', "img:///UILibrary_XPACK_Common.PerkIcons.strx_losthunter"));
	//Templates.AddItem(BuildHunterOfX('HunterOfMecsPassive', 'AdventMEC', "img:///UILibrary_XPACK_Common.PerkIcons.strx_mechunter"));
	//Templates.AddItem(BuildHunterOfX('HunterOfFacelessPassive', 'Faceless', "img:///UILibrary_XPACK_Common.PerkIcons.strx_facelesshunter"));

	Templates.AddItem(PurePassive('FearOfChosenPassive', "img:///UILibrary_XPACK_Common.PerkIcons.weakx_fearofchosen", , 'eAbilitySource_Debuff'));
	Templates.AddItem(PurePassive('FearOfVipersPassive', "img:///UILibrary_XPACK_Common.PerkIcons.weakx_fearofvipers", , 'eAbilitySource_Debuff'));
	Templates.AddItem(PurePassive('FearOfStunLancersPassive', "img:///UILibrary_XPACK_Common.PerkIcons.weakx_fearoflancers", , 'eAbilitySource_Debuff'));
	Templates.AddItem(PurePassive('FearOfArchonsPassive', "img:///UILibrary_XPACK_Common.PerkIcons.weakx_fearofarchons", , 'eAbilitySource_Debuff'));
	Templates.AddItem(PurePassive('FearOfMutonsPassive', "img:///UILibrary_XPACK_Common.PerkIcons.weakx_fearofmutons", , 'eAbilitySource_Debuff'));
	Templates.AddItem(PurePassive('FearOfTheLostPassive', "img:///UILibrary_XPACK_Common.PerkIcons.weakx_fearoflost", , 'eAbilitySource_Debuff'));
	Templates.AddItem(PurePassive('FearOfMecsPassive', "img:///UILibrary_XPACK_Common.PerkIcons.weakx_fearofmecs", , 'eAbilitySource_Debuff'));
	Templates.AddItem(PurePassive('FearOfFacelessPassive', "img:///UILibrary_XPACK_Common.PerkIcons.weakx_fearoffaceless", , 'eAbilitySource_Debuff'));
	Templates.AddItem(PurePassive('FearOfSectoidsPassive', "img:///UILibrary_XPACK_Common.PerkIcons.weakx_fearofsectoids", , 'eAbilitySource_Debuff'));

	Templates.AddItem(PurePassive('FearOfPanicPassive', "img:///UILibrary_XPACK_Common.weakx_fearofpanic", , 'eAbilitySource_Debuff'));
	Templates.AddItem(PurePassive('FearOfVertigoPassive', "img:///UILibrary_XPACK_Common.PerkIcons.weakx_vertigo", , 'eAbilitySource_Debuff'));
	Templates.AddItem(PurePassive('FearOfNoMovementPassive', "img:///UILibrary_XPACK_Common.PerkIcons.weakx_antsy", , 'eAbilitySource_Debuff'));
	Templates.AddItem(PurePassive('FearOfSquadmateMissedShotsPassive', "img:///UILibrary_XPACK_Common.PerkIcons.weakx_fearofmissedshots", , 'eAbilitySource_Debuff'));
	Templates.AddItem(PurePassive('FearOfMissedShotsPassive', "img:///UILibrary_XPACK_Common.PerkIcons.weakx_fearofmissedshots", , 'eAbilitySource_Debuff'));
	Templates.AddItem(PurePassive('FearOfBreakingConcealmentPassive', "img:///UILibrary_XPACK_Common.PerkIcons.weakx_fearofbreakingconcealment", , 'eAbilitySource_Debuff'));

	// behavior passives
	Templates.AddItem(PurePassive('TraitAbility_Cautious', "img:///UILibrary_XPACK_Common.PerkIcons.weakx_cautious", , 'eAbilitySource_Debuff'));
	Templates.AddItem(PurePassive('TraitAbility_ObsessiveReloader', "img:///UILibrary_XPACK_Common.PerkIcons.weakx_reload", , 'eAbilitySource_Debuff'));
	Templates.AddItem(PurePassive('TraitAbility_Aggressive', "img:///UILibrary_XPACK_Common.PerkIcons.weakx_aggressive", , 'eAbilitySource_Debuff'));
	//Templates.AddItem(PurePassive('TraitAbility_Insubordinate', "img:///UILibrary_XPACK_Common.PerkIcons.weakx_insubordinate", , 'eAbilitySource_Debuff'));
	//Templates.AddItem(PurePassive('TraitAbility_Critic', "img:///UILibrary_XPACK_Common.PerkIcons.weakx_critical", , 'eAbilitySource_Debuff'));

	// behavior panics
	Templates.AddItem(PanickedReaction_HunkerAbility());
	Templates.AddItem(PanickedReaction_ObsessiveReloaderAbility());
	Templates.AddItem(PanickedReaction_AggressiveAbility());
	Templates.AddItem(PanickedReaction_AggressivePistolAbility());
	//Templates.AddItem(PanickedReaction_SquadDemoralizationAbility('PanickedReaction_Insubordinate', InsubordinateAbility_BuildGameState));
	//Templates.AddItem(PanickedReaction_SquadDemoralizationAbility('PanickedReaction_Critic', CriticAbility_BuildGameState));

	return Templates;
}

// ******************* Behavior Traits ********************************
static function X2AbilityTemplate PanickedReaction_HunkerAbility()
{
	local X2AbilityTemplate                 Template;

	Template = class'X2Ability_DefaultAbilitySet'.static.AddHunkerDownAbility('PanickedReaction_Hunker');

	Template.AbilityTriggers.Length = 0;
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder'); // triggered from panic roll during a will event

	Template.AbilitySourceName = 'eAbilitySource_Debuff';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	return Template;
}

static function X2AbilityTemplate PanickedReaction_ObsessiveReloaderAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;

	Template = class'X2Ability_DefaultAbilitySet'.static.AddReloadAbility('PanickedReaction_ObsessiveReloader');

	Template.AbilityCosts.Length = 0;
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityTriggers.Length = 0;
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder'); // triggered from panic roll during a will event

	Template.AbilitySourceName = 'eAbilitySource_Debuff';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

static function X2AbilityTemplate PanickedReaction_AggressiveAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ReserveActionPoints        ActionPointCost;
	local X2AbilityTarget_Single SingleTarget;

	Template = class'X2Ability_WeaponCommon'.static.Add_StandardShot('PanickedReaction_Aggressive');

	Template.AbilityCosts.Length = 0;
	ActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.OverwatchReserveActionPoint);
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityTriggers.Length = 0;
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder'); // triggered from panic roll during a will event

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;
//BEGIN AUTOGENERATED CODE: Template Overrides 'PanickedReaction_Aggressive'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilitySourceName = 'eAbilitySource_Debuff';
//END AUTOGENERATED CODE: Template Overrides 'PanickedReaction_Aggressive'

	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
	Template.AbilityTargetStyle = SingleTarget;

	return Template;
}

static function X2AbilityTemplate PanickedReaction_AggressivePistolAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ReserveActionPoints        ActionPointCost;
	local X2AbilityTarget_Single SingleTarget;

	Template = class'X2Ability_WeaponCommon'.static.Add_PistolStandardShot('PanickedReaction_AggressivePistol');

	Template.AbilityCosts.Length = 0;
	ActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.OverwatchReserveActionPoint);
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityTriggers.Length = 0;
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder'); // triggered from panic roll during a will event

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilitySourceName = 'eAbilitySource_Debuff';

	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
	Template.AbilityTargetStyle = SingleTarget;

	return Template;
}

static function X2AbilityTemplate PanickedReaction_SquadDemoralizationAbility(name TemplateName, delegate<X2AbilityTemplate.BuildNewGameStateDelegate> BuildGameStateFn)
{
	local X2AbilityTemplate                 Template;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Template.AbilityTriggers.Length = 0;
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder'); // triggered from panic roll during a will event

	Template.AbilitySourceName = 'eAbilitySource_Debuff';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.BuildNewGameStateFn = BuildGameStateFn;
	Template.BuildVisualizationFn = SquadDemoralizationAbility_BuildVisualization;

	return Template;
}

static function XComGameState InsubordinateAbility_BuildGameState(XComGameStateContext Context)
{
	return SquadDemoralizationAbility_BuildGameState(Context, default.InsubordinateSquadmateWillRollData, 'Ability_Insubordinate');
}

static function XComGameState CriticAbility_BuildGameState(XComGameStateContext Context)
{
	return SquadDemoralizationAbility_BuildGameState(Context, default.CriticSquadmateWillRollData, 'Ability_Critic');
}

static function XComGameState SquadDemoralizationAbility_BuildGameState(XComGameStateContext Context, const out WillEventRollData RollData, name RollSource)
{
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local StateObjectReference SquadmateRef;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit UnitState;

	AbilityContext = XComGameStateContext_Ability(Context);
	XComHQ = `XCOMHQ;
	History = `XCOMHISTORY;
	NewGameState = History.CreateNewGameState(true, Context);

	// perform the will rolls on everyone except the source
	foreach XComHQ.Squad(SquadmateRef)
	{
		if( SquadmateRef.ObjectID != AbilityContext.InputContext.SourceObject.ObjectID )
		{
			UnitState = XComGameState_Unit(History.GetGameStateForObjectID(SquadmateRef.ObjectID));
			class'XComGameStateContext_WillRoll'.static.PerformWillRollOnUnitForNewGameState(RollData, UnitState, RollSource, NewGameState);
		}
	}

	TypicalAbility_FillOutGameState(NewGameState); //Costs applied here.

	return NewGameState;
}

function SquadDemoralizationAbility_BuildVisualization(XComGameState VisualizeGameState)
{
	local VisualizationActionMetadata ActionMetadata;
	local X2Action_PlaySoundAndFlyover FlyoverAction;
	local X2Action_PlayMessageBanner WorldMessageAction;
	local XComGameState_Unit UnitState, OldUnitState;
	local XGParamTag Tag;
	local int WillLossTotal;

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		OldUnitState = XComGameState_Unit(UnitState.GetPreviousVersion());

		WillLossTotal = OldUnitState.GetCurrentStat(eStat_Will) - UnitState.GetCurrentStat(eStat_Will);

		if( WillLossTotal > 0 )
		{
			ActionMetadata.StateObject_OldState = OldUnitState;
			ActionMetadata.StateObject_NewState = UnitState;

			Tag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
			Tag.StrValue0 = default.DemoralizedString;
			Tag.IntValue0 = WillLossTotal;
			FlyoverAction = X2Action_PlaySoundAndFlyover(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext()));
			FlyoverAction.SetSoundAndFlyOverParameters(none, `XEXPAND.ExpandString(class'XComGameStateContext_WillRoll'.default.LostWillFlyover), '', eColor_Bad);

			Tag.StrValue1 = UnitState.GetFullName();
			WorldMessageAction = X2Action_PlayMessageBanner(class'X2Action_PlayMessageBanner'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext()));
			WorldMessageAction.AddMessageBanner(class'UIEventNoticesTactical'.default.WillLostTitle,
										   ,
										   UnitState.GetName(eNameType_RankFull),
										   `XEXPAND.ExpandString(class'XComGameStateContext_WillRoll'.default.LostWillWorldMessage),
										   eUIState_Warning);
		}
	}
}

// ******************* Positive Traits ********************************
static function X2AbilityTemplate BuildHunterOfX(Name NewTemplateName, Name LimitUnitType, string IconImage)
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_ConditionalDamageModifier		DamageModifierEffect;
	local X2Condition_UnitType				UnitTypeCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, NewTemplateName);

	Template.IconImage = IconImage;

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	// Bonus to damage against X
	//
	DamageModifierEffect = new class'X2Effect_ConditionalDamageModifier';
	DamageModifierEffect.BuildPersistentEffect(1, true, false, false);
	DamageModifierEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true, , Template.AbilitySourceName);
	DamageModifierEffect.bModifyOutgoingDamage = true;
	DamageModifierEffect.bDisplayInSpecialDamageMessageUI = true;
	DamageModifierEffect.DamageBonus = default.HUNTER_OF_X_DAMAGE_BONUS;

	UnitTypeCondition = new class'X2Condition_UnitType';
	UnitTypeCondition.IncludeTypes.AddItem(LimitUnitType);

	DamageModifierEffect.ApplyDamageModConditions.AddItem(UnitTypeCondition);
	Template.AddTargetEffect(DamageModifierEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}


DefaultProperties
{
}
