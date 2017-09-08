//---------------------------------------------------------------------------------------
//  FILE:    X2EventListener_AbilityPoints.uc
//  AUTHOR:  Russell Aasland
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2EventListener_AbilityPoints extends X2EventListener
	config(GameCore)
	native(Core);

var const config int MaxTacticalEventAbilityPointsPerBattle;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem( AddHeightAdvantageShotTacticalEvent() );
	Templates.AddItem( AddFlankingShotTacticalEvent() );
	Templates.AddItem( AddComboKillTacticalEvent() );
	Templates.AddItem( AddAmbushKillTacticalEvent() );

	Templates.AddItem( AddChosenKilledEvent() );
	Templates.AddItem( AddChosenDefeatedEvent() );

	return Templates;
}

static function X2AbilityPointTemplate GetAbilityPointTemplate(name APTemplateName)
{
	local X2EventListenerTemplateManager TemplateManager;
	local X2AbilityPointTemplate APTemplate;

	TemplateManager = class'X2EventListenerTemplateManager'.static.GetEventListenerTemplateManager();
	APTemplate = X2AbilityPointTemplate(TemplateManager.FindEventListenerTemplate(APTemplateName));
	if(APTemplate == none)
	{
		`Redscreen("GetTemplateFriendlyName(): Could not find AbilityPointTemplate " $ APTemplateName);
	}

	return APTemplate;
}

// common reasons to filter out a game state event from checking whether or not to award ability points
static protected function bool ShouldIgnoreEventCommon(X2AbilityPointTemplate APTemplate, XComGameState_Unit SourceUnit, XComGameState_BattleData BattleData, XComGameStateContext Context )
{
	if (APTemplate == none) // bad template name
		return true;

	// no unit or not xcom
	if (SourceUnit == none || SourceUnit.GetTeam() != eTeam_XCom)
		return true;

	// missing battle data?
	if (BattleData == none)
		return true;

	// check for the per battle ability point cap
	if (APTemplate.TacticalEvent && (BattleData.TacticalEventAbilityPointsGained >= default.MaxTacticalEventAbilityPointsPerBattle))
		return true;

	// ignore abilities that have already successfully given out an ability point
	if (APTemplate.TacticalEvent && (BattleData.TacticalEventGameStates.Find( Context.GetFirstStateInEventChain().HistoryIndex ) != INDEX_NONE))
		return true;

	// ignore when in challenge mode
	if (`XCOMHISTORY.GetSingleGameStateObjectForClass( class'XComGameState_ChallengeData', true ) != none)
		return true;

	return false;
}

static function bool PassesWeaponCheck( XComGameStateContext_Ability AbilityContext, bool MeleeAllowed )
{
	local X2AbilityTemplate AbilityTemplate;
	local XComGameState_Item SourceItem;

	// only abilities with standard hit calculations care about to-hit triggers (no psi abilities)
	AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);
	if (AbilityTemplate.AbilityToHitCalc == none)
		return false;

	if (!MeleeAllowed && AbilityTemplate.IsMelee())
		return false;

	if (!AbilityTemplate.AbilityToHitCalc.IsA( 'X2AbilityToHitCalc_StandardAim' ) && !AbilityTemplate.AbilityToHitCalc.IsA( 'X2AbilityToHitCalc_StandardMelee' ))
		return false;

	// manually targeted aren't going to be valid for the to-hit triggers (no grenades)
	if (AbilityTemplate.AbilityTargetStyle.IsA( 'X2AbilityTarget_Cursor' ))
		return false;

	// only attacks made from weapons can gain weapon triggers (no gremlins)
	SourceItem = (AbilityContext.InputContext.ItemObject.ObjectID > 0) ? XComGameState_Item( `XCOMHISTORY.GetGameStateForObjectID( AbilityContext.InputContext.ItemObject.ObjectID ) ) : none;
	if ((SourceItem == none) || (X2WeaponTemplate(SourceItem.GetMyTemplate()) == none))
		return false;

	return true;
}

static protected function X2EventListenerTemplate AddHeightAdvantageShotTacticalEvent()
{
	local X2AbilityPointTemplate Template;

	`CREATE_X2TEMPLATE(class'X2AbilityPointTemplate', Template, 'HeightAdvantageShot');
	Template.AddEvent('AbilityActivated', CheckForHeightAdvantage);

	return Template;
}

static protected function EventListenerReturn CheckForHeightAdvantage(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit SourceUnit, TargetUnit;
	local XComGameState_BattleData BattleData;
	local X2AbilityPointTemplate APTemplate;
	local int Roll;
	local XComGameStateContext_AbilityPointEvent EventContext;

	SourceUnit = XComGameState_Unit(EventSource);
	BattleData = XComGameState_BattleData( `XCOMHISTORY.GetSingleGameStateObjectForClass( class'XComGameState_BattleData' ) );
	APTemplate = GetAbilityPointTemplate( 'HeightAdvantageShot' );

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext == none)
		return ELR_NoInterrupt;

	if (ShouldIgnoreEventCommon( APTemplate, SourceUnit, BattleData, AbilityContext ))
		return ELR_NoInterrupt;

	if (!PassesWeaponCheck( AbilityContext, false ))
		return ELR_NoInterrupt;

	// ignore team mates
	TargetUnit = XComGameState_Unit( `XCOMHISTORY.GetGameStateForObjectID( AbilityContext.InputContext.PrimaryTarget.ObjectID ) );
	if( (TargetUnit == none) || (SourceUnit.GetTeam() == TargetUnit.GetTeam()))
		return ELR_NoInterrupt;

	if(AbilityContext.bFirstEventInChain && AbilityContext.IsResultContextHit())
	{
		if (SourceUnit.HasHeightAdvantageOver(TargetUnit, true))
		{
			Roll = class'Engine'.static.GetEngine().SyncRand(100, "RollForAbilityPoint");
			if (Roll < APTemplate.Chance)
			{
				EventContext = XComGameStateContext_AbilityPointEvent( class'XComGameStateContext_AbilityPointEvent'.static.CreateXComGameStateContext() );
				EventContext.AbilityPointTemplateName = APTemplate.DataName;
				EventContext.AssociatedUnitRef = SourceUnit.GetReference( );
				EventContext.TriggerHistoryIndex = AbilityContext.GetFirstStateInEventChain().HistoryIndex;

				`TACTICALRULES.SubmitGameStateContext( EventContext );
			}
		}
	}

	return ELR_NoInterrupt;
}

static function X2AbilityPointTemplate AddFlankingShotTacticalEvent()
{
	local X2AbilityPointTemplate Template;

	`CREATE_X2TEMPLATE(class'X2AbilityPointTemplate', Template, 'FlankingShot');
	Template.AddEvent('AbilityActivated', CheckForFlankingShot);

	return Template;
}

static protected function EventListenerReturn CheckForFlankingShot(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit SourceUnit, TargetUnit;
	local XComGameState_BattleData BattleData;
	local X2AbilityPointTemplate APTemplate;
	local array<StateObjectReference> FlankingEnemies;
	local int Roll, FlankIdx;
	local XComGameStateContext_AbilityPointEvent EventContext;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	SourceUnit = XComGameState_Unit(EventSource);
	BattleData = XComGameState_BattleData( History.GetSingleGameStateObjectForClass( class'XComGameState_BattleData' ) );
	APTemplate = GetAbilityPointTemplate( 'FlankingShot' );

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

	if (AbilityContext == none)
		return ELR_NoInterrupt;

	if (ShouldIgnoreEventCommon( APTemplate, SourceUnit, BattleData, AbilityContext ))
		return ELR_NoInterrupt;

	if (!PassesWeaponCheck( AbilityContext, false ))
		return ELR_NoInterrupt;

	// ignore non-cover taking units, and team mates
	TargetUnit = XComGameState_Unit( History.GetGameStateForObjectID( AbilityContext.InputContext.PrimaryTarget.ObjectID ) );
	if( (TargetUnit == none) || !TargetUnit.GetMyTemplate().bCanTakeCover || (SourceUnit.GetTeam() == TargetUnit.GetTeam()))
		return ELR_NoInterrupt;

	// not really flanking if the target is standing out in the open.
	if (TargetUnit.GetCoverTypeFromLocation() == CT_None)
		return ELR_NoInterrupt;

	if(AbilityContext.bFirstEventInChain && AbilityContext.IsResultContextHit())
	{
		class'X2TacticalVisibilityHelpers'.static.GetFlankingEnemiesOfTarget(TargetUnit.ObjectID, FlankingEnemies);
		FlankIdx = FlankingEnemies.Find( 'ObjectID', SourceUnit.ObjectID );

		if (FlankIdx != INDEX_NONE)
		{
			Roll = class'Engine'.static.GetEngine().SyncRand(100, "RollForAbilityPoint");
			if (Roll < APTemplate.Chance)
			{
				EventContext = XComGameStateContext_AbilityPointEvent( class'XComGameStateContext_AbilityPointEvent'.static.CreateXComGameStateContext() );
				EventContext.AbilityPointTemplateName = APTemplate.DataName;
				EventContext.AssociatedUnitRef = SourceUnit.GetReference( );
				EventContext.TriggerHistoryIndex = AbilityContext.GetFirstStateInEventChain().HistoryIndex;

				`TACTICALRULES.SubmitGameStateContext( EventContext );
			}
		}
	}

	return ELR_NoInterrupt;
}

static function X2AbilityPointTemplate AddAmbushKillTacticalEvent()
{
	local X2AbilityPointTemplate Template;

	`CREATE_X2TEMPLATE(class'X2AbilityPointTemplate', Template, 'AmbushKill');
	Template.AddEvent('UnitDied', CheckForAmbushKill);

	return Template;
}

static protected function EventListenerReturn CheckForAmbushKill(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit SourceUnitTurnStart, KilledUnit;
	local XComGameState_BattleData BattleData;
	local X2AbilityPointTemplate APTemplate;
	local int Roll;
	local XComGameStateContext_AbilityPointEvent EventContext;
	local XComGameStateHistory History;
	local XComGameStateContext_TacticalGameRule RuleContext;

	History = `XCOMHISTORY;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext == none)
		return ELR_NoInterrupt;

	// find the start of the current player turn
	foreach History.IterateContextsByClassType(class'XComGameStateContext_TacticalGameRule', RuleContext)
	{
		if(RuleContext.GameRuleType == eGameRule_PlayerTurnBegin)
		{
			break;
		}
	}

	SourceUnitTurnStart = XComGameState_Unit( History.GetGameStateForObjectID( AbilityContext.InputContext.SourceObject.ObjectID, , RuleContext.AssociatedState.HistoryIndex ) );
	KilledUnit = XComGameState_Unit(EventSource);
	BattleData = XComGameState_BattleData( History.GetSingleGameStateObjectForClass( class'XComGameState_BattleData' ) );
	APTemplate = GetAbilityPointTemplate( 'AmbushKill' );

	if (ShouldIgnoreEventCommon( APTemplate, SourceUnitTurnStart, BattleData, AbilityContext ))
		return ELR_NoInterrupt;

	if (KilledUnit.GetTeam() != eTeam_Alien && KilledUnit.GetTeam() != eTeam_TheLost)
		return ELR_NoInterrupt;

	if (!SourceUnitTurnStart.IsConcealed())
		return ELR_NoInterrupt;

	Roll = class'Engine'.static.GetEngine().SyncRand(100, "RollForAbilityPoint");
	if (Roll < APTemplate.Chance)
	{
		EventContext = XComGameStateContext_AbilityPointEvent( class'XComGameStateContext_AbilityPointEvent'.static.CreateXComGameStateContext() );
		EventContext.AbilityPointTemplateName = APTemplate.DataName;
		EventContext.AssociatedUnitRef = SourceUnitTurnStart.GetReference( );
		EventContext.TriggerHistoryIndex = AbilityContext.GetFirstStateInEventChain().HistoryIndex;

		`TACTICALRULES.SubmitGameStateContext( EventContext );
	}

	return ELR_NoInterrupt;
}

static function X2AbilityPointTemplate AddChosenKilledEvent()
{
	local X2AbilityPointTemplate Template;

	`CREATE_X2TEMPLATE(class'X2AbilityPointTemplate', Template, 'ChosenKilled');
	Template.AddEvent('UnitDied', CheckForChosenKilled);

	return Template;
}

static protected function EventListenerReturn CheckForChosenKilled(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit KilledUnit;
	local XComGameState_BattleData BattleData;
	local X2AbilityPointTemplate APTemplate;
	local int Roll, ObjectiveTagIdx;
	local XComGameStateContext_AbilityPointEvent EventContext;

	KilledUnit = XComGameState_Unit(EventSource);
	BattleData = XComGameState_BattleData( `XCOMHISTORY.GetSingleGameStateObjectForClass( class'XComGameState_BattleData' ) );
	APTemplate = GetAbilityPointTemplate( 'ChosenKilled' );

	// bad data somewhere
	if ((APTemplate == none) || (BattleData == none) || (KilledUnit == none))
		return ELR_NoInterrupt;

	// ignore everybody who is not a chosen
	if (!KilledUnit.GetMyTemplate().bIsChosen)
		return ELR_NoInterrupt;

	// ignore kills during the chosen showdown climax missions
	ObjectiveTagIdx = BattleData.MapData.ActiveMission.RequiredPlotObjectiveTags.Find( "ChosenShowdown" );
	if (ObjectiveTagIdx != INDEX_NONE)
		return ELR_NoInterrupt;

	Roll = class'Engine'.static.GetEngine().SyncRand(100, "RollForAbilityPoint");
	if (Roll < APTemplate.Chance)
	{
		EventContext = XComGameStateContext_AbilityPointEvent( class'XComGameStateContext_AbilityPointEvent'.static.CreateXComGameStateContext() );
		EventContext.AbilityPointTemplateName = APTemplate.DataName;
		EventContext.AssociatedUnitRef = KilledUnit.GetReference( );
		EventContext.TriggerHistoryIndex = GameState.GetContext().GetFirstStateInEventChain().HistoryIndex;

		`TACTICALRULES.SubmitGameStateContext( EventContext );
	}
}

static function X2AbilityPointTemplate AddChosenDefeatedEvent()
{
	local X2AbilityPointTemplate Template;

	`CREATE_X2TEMPLATE(class'X2AbilityPointTemplate', Template, 'ChosenDefeated');
	Template.AddEvent('ChosenDefeated', CheckForChosenDefeated);

	return Template;
}

static protected function EventListenerReturn CheckForChosenDefeated(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit KilledUnit;
	local XComGameState_BattleData BattleData;
	local X2AbilityPointTemplate APTemplate;
	local int Roll;
	local XComGameStateContext_AbilityPointEvent EventContext;

	KilledUnit = XComGameState_Unit(EventSource);
	BattleData = XComGameState_BattleData( `XCOMHISTORY.GetSingleGameStateObjectForClass( class'XComGameState_BattleData' ) );
	APTemplate = GetAbilityPointTemplate( 'ChosenDefeated' );

	// bad data somewhere
	if ((APTemplate == none) || (BattleData == none) || (KilledUnit == none))
		return ELR_NoInterrupt;

	// ignore everybody who is not a chosen
	if (!KilledUnit.GetMyTemplate().bIsChosen)
		return ELR_NoInterrupt;

	Roll = class'Engine'.static.GetEngine().SyncRand(100, "RollForAbilityPoint");
	if (Roll < APTemplate.Chance)
	{
		EventContext = XComGameStateContext_AbilityPointEvent( class'XComGameStateContext_AbilityPointEvent'.static.CreateXComGameStateContext() );
		EventContext.AbilityPointTemplateName = APTemplate.DataName;
		EventContext.AssociatedUnitRef = KilledUnit.GetReference( );
		EventContext.TriggerHistoryIndex = GameState.GetContext().GetFirstStateInEventChain().HistoryIndex;

		`TACTICALRULES.SubmitGameStateContext( EventContext );
	}
}

static function X2AbilityPointTemplate AddComboKillTacticalEvent()
{
	local X2AbilityPointTemplate Template;

	`CREATE_X2TEMPLATE(class'X2AbilityPointTemplate', Template, 'ComboKill');
	Template.AddEvent('UnitDied', CheckForComboKill);

	return Template;
}

static protected function EventListenerReturn CheckForComboKill(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit SourceUnit, KilledUnit;
	local XComGameState_BattleData BattleData;
	local X2AbilityPointTemplate APTemplate;
	local int Roll;
	local XComGameStateContext_AbilityPointEvent EventContext;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	KilledUnit = XComGameState_Unit(EventSource);
	BattleData = XComGameState_BattleData( History.GetSingleGameStateObjectForClass( class'XComGameState_BattleData' ) );
	APTemplate = GetAbilityPointTemplate( 'ComboKill' );

	// death by other not considered
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext == none)
		return ELR_NoInterrupt;

	SourceUnit = XComGameState_Unit( History.GetGameStateForObjectID( AbilityContext.InputContext.SourceObject.ObjectID ) );

	if (ShouldIgnoreEventCommon( APTemplate, SourceUnit, BattleData, AbilityContext ))
		return ELR_NoInterrupt;

	// check for the combo instances
	if (CheckForRuptureKill(AbilityContext, KilledUnit) || 
		CheckForHolotargetingKill(AbilityContext, KilledUnit) ||
		CheckForFrozenKill(AbilityContext, KilledUnit))
	{
		Roll = class'Engine'.static.GetEngine().SyncRand(100, "RollForAbilityPoint");
		if (Roll < APTemplate.Chance)
		{
			EventContext = XComGameStateContext_AbilityPointEvent( class'XComGameStateContext_AbilityPointEvent'.static.CreateXComGameStateContext() );
			EventContext.AbilityPointTemplateName = APTemplate.DataName;
			EventContext.AssociatedUnitRef = SourceUnit.GetReference( );
			EventContext.TriggerHistoryIndex = AbilityContext.GetFirstStateInEventChain().HistoryIndex;

			`TACTICALRULES.SubmitGameStateContext( EventContext );
		}
	}

	return ELR_NoInterrupt;
}

static protected function bool CheckForRuptureKill(XComGameStateContext_Ability AbilityContext, XComGameState_Unit KilledUnit)
{
	local XComGameState_Unit KilledUnitPrev;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	// were they already ruptured
	KilledUnitPrev = XComGameState_Unit( History.GetGameStateForObjectID( KilledUnit.ObjectID, , AbilityContext.AssociatedState.HistoryIndex - 1 ) );
	if (KilledUnitPrev.GetRupturedValue() == 0)
		return false;

	return true;
}

static protected function bool CheckForHolotargetingKill(XComGameStateContext_Ability AbilityContext, XComGameState_Unit KilledUnit)
{
	local XComGameState_Unit KilledUnitPrev;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	// was the unit holotargeted before this ability
	KilledUnitPrev = XComGameState_Unit( History.GetGameStateForObjectID( KilledUnit.ObjectID, , AbilityContext.AssociatedState.HistoryIndex - 1 ) );
	if (KilledUnitPrev.AffectedByEffectNames.Find('HoloTarget') == INDEX_NONE)
		return false;

	if (!PassesWeaponCheck( AbilityContext, true ))
		return false;

	return true;
}

static protected function bool CheckForFrozenKill(XComGameStateContext_Ability AbilityContext, XComGameState_Unit KilledUnit)
{
	local XComGameState_Unit KilledUnitPrev;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	// was the unit frozen before this ability
	KilledUnitPrev = XComGameState_Unit( History.GetGameStateForObjectID( KilledUnit.ObjectID, , AbilityContext.AssociatedState.HistoryIndex - 1 ) );
	if (KilledUnitPrev.AffectedByEffectNames.Find('Freeze') == INDEX_NONE)
		return false;

	if (!PassesWeaponCheck( AbilityContext, true ))
		return false;

	return true;
}