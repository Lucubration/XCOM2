//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_SitRepGrantedAbilitySet.uc
//  AUTHOR:  Dan Kaplan  --  11/2/2016
//  PURPOSE: Defines abilities made available to XCom soldiers through active SitReps
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Ability_SitRepGrantedAbilitySet extends X2Ability
	dependson (XComGameStateContext_Ability)
	config(GameCore);

var const config float LowVisibilitySightReduction; // as a fractional percentage, 0.0-1.0 

/// <summary>
/// Creates the set of abilities granted to units through their personal traits in X-Com 2
/// </summary>
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(CreateLowVisibilityTemplate());
	//Templates.AddItem(CreateJuggernautTemplate());
	Templates.AddItem(CreateBlackOpsTemplate());
	Templates.AddItem(CreateSitRepStealth());

	return Templates;
}

static function X2AbilityTemplate CreateLowVisibilityTemplate()
{
	local X2AbilityTemplate             Template;
	local X2Effect_PersistentStatChange PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LowVisibility');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_item_nanofibervest";

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_UnitPostBeginPlay');

	// Reduces the unit's visibility range by half
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, true);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_SightRadius, default.LowVisibilitySightReduction, MODOP_Multiplication);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionRadius, default.LowVisibilitySightReduction, MODOP_Multiplication);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_SeeMovement, default.LowVisibilitySightReduction, MODOP_Multiplication);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate CreateJuggernautTemplate()
{
	local X2AbilityTemplate             Template;
	local X2AbilityTrigger_EventListener EventTrigger;
	local X2Effect_DamageImmunity ImmunityEffect;

	Template = PurePassive('Juggernaut', "img:///UILibrary_PerkIcons.UIPerk_item_nanofibervest",,, true);
	
	// fire an event to check for interuption when an enemy takes a turn
	EventTrigger = new class'X2AbilityTrigger_EventListener';
	EventTrigger.ListenerData.EventID = 'AbilityActivated';
	EventTrigger.ListenerData.EventFn = CheckForInitiativeInterrupt;
	EventTrigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Template.AbilityTriggers.AddItem(EventTrigger);

	// The Juggernaut is a lone unit, and needs to be immune to mental effects because of it.
	// Otherwise you'll just get one shot mind-controlled, and the mission is over
	ImmunityEffect = new class'X2Effect_DamageImmunity';
	ImmunityEffect.EffectName = 'JuggernautImmunity';
	ImmunityEffect.ImmuneTypes.AddItem('Mental');
	Template.AddTargetEffect(ImmunityEffect);

	return Template;
}

static function EventListenerReturn CheckForInitiativeInterrupt(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState NewGameState;
	local XComGameState_Ability AbilityState;
	local X2AbilityTemplate AbilityTemplate;
	local XComGameState_Unit SourceUnit;
	local X2TacticalGameRuleset TacticalRules;
	local XComGameState_Ability InitiativeAbility;
	local XComGameState_Unit InitiativeUnit;

	SourceUnit = XComGameState_Unit(EventSource);
	`assert(SourceUnit != none);

	AbilityState = XComGameState_Ability(EventData);
	`assert(AbilityState != none);

	AbilityTemplate = AbilityState.GetMyTemplate();
	`assert(AbilityTemplate != none);
	if(AbilityTemplate.IsFreeCost(AbilityState))
	{
		return ELR_NoInterrupt;
	}

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	`assert(AbilityContext != none);
	if (!AbilityContext.bFirstEventInChain || AbilityContext.InterruptionStatus == eInterruptionStatus_Interrupt)
	{
		return ELR_NoInterrupt;
	}

	History = `XCOMHISTORY;
	InitiativeAbility = XComGameState_Ability(CallbackData);
	InitiativeUnit = XComGameState_Unit(History.GetGameStateForObjectId(InitiativeAbility.OwnerStateObject.ObjectID));

	if(!InitiativeUnit.IsEnemyUnit(SourceUnit))
	{
		return ELR_NoInterrupt;
	}

	// only if we can see the enemy unit
	if(SourceUnit.IsUnrevealedAI(GameState.HistoryIndex))
	{
		return ELR_NoInterrupt;
	}

	// We get initiative
	TacticalRules = `TACTICALRULES;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Juggernaut Turn Initiative");
	TacticalRules.InterruptInitiativeTurn(NewGameState, InitiativeUnit.GetGroupMembership().GetReference());
	TacticalRules.SubmitGameState(NewGameState);

	return ELR_NoInterrupt;
}

static function X2AbilityTemplate CreateBlackOpsTemplate()
{
	local X2AbilityTemplate             Template;
	local X2AbilityTrigger_EventListener EventTrigger;

	Template = PurePassive('BlackOps', "img:///UILibrary_PerkIcons.UIPerk_item_nanofibervest",,, true);
	
	// fire an event to check for reconcealment at the end of the turn
	EventTrigger = new class'X2AbilityTrigger_EventListener';
	EventTrigger.ListenerData.EventID = 'PlayerTurnEnded';
	EventTrigger.ListenerData.EventFn = CheckForBlackOpsEffect;
	EventTrigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Template.AbilityTriggers.AddItem(EventTrigger);

	return Template;
}

static function EventListenerReturn CheckForBlackOpsEffect(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameState_Ability AbilityState;
	local XComGameState_Unit AbilityUnit;
	local XComGameState_Unit UnitIt;
	local XComGameState_Player TurnEndingPlayer;

	History = `XCOMHISTORY;

	TurnEndingPlayer = XComGameState_Player(EventSource);
	`assert(TurnEndingPlayer != none);

	// make sure we have the most recent version of the player, and not the one that triggered the event. If
	// there is more than one unit on the squad, only one of them should be reactivating concealment for the squad
	TurnEndingPlayer = XComGameState_Player(History.GetGameStateForObjectID(TurnEndingPlayer.ObjectID));
	if(TurnEndingPlayer.bSquadIsConcealed)
	{
		return ELR_NoInterrupt;
	}

	AbilityState = XComGameState_Ability(CallbackData);
	AbilityUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
	`assert(AbilityState != none && AbilityUnit != none);

	if(AbilityUnit.ControllingPlayer.ObjectID != TurnEndingPlayer.ObjectID)
	{
		return ELR_NoInterrupt; // not our player
	}

	// If no living aliens have knowledge of XCom, reenable concealment
	foreach History.IterateByClassType(class'XComGameState_Unit', UnitIt)
	{
		if(UnitIt.IsEnemyUnit(AbilityUnit) && UnitIt.IsInCombat())
		{
			return ELR_NoInterrupt;
		}
	}

	// Nobody is aware we are here, conceal!
	TurnEndingPlayer.SetSquadConcealment(true);

	return ELR_NoInterrupt;
}

static function X2AbilityTemplate CreateSitRepStealth()
{
	return class'X2Ability_RangerAbilitySet'.static.Stealth( 'SitRepStealth' );
}