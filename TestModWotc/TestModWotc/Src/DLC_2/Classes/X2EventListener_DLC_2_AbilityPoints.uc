//---------------------------------------------------------------------------------------
//  FILE:    X2EventListener_DLC_2_AbilityPoints.uc
//  AUTHOR:  Russell Aasland
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2EventListener_DLC_2_AbilityPoints extends X2EventListener_AbilityPoints
	config(GameCore);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem( CreateRulerEscapesEvent() );
	Templates.AddItem( CreateRulerDefeatedEvent() );

	return Templates;
}

static function X2AbilityPointTemplate CreateRulerEscapesEvent()
{
	local X2AbilityPointTemplate Template;

	`CREATE_X2TEMPLATE(class'X2AbilityPointTemplate', Template, 'RulerEscapes');
	Template.AddEvent('AbilityActivated', CheckForRulerEscapes);

	return Template;
}

static protected function EventListenerReturn CheckForRulerEscapes(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit SourceUnit;
	local XComGameState_BattleData BattleData;
	local X2AbilityPointTemplate APTemplate;
	local XComGameStateContext_Ability AbilityContext;
	local int Roll;
	local XComGameStateContext_AbilityPointEvent EventContext;

	SourceUnit = XComGameState_Unit( EventSource );
	BattleData = XComGameState_BattleData( `XCOMHISTORY.GetSingleGameStateObjectForClass( class'XComGameState_BattleData' ) );
	APTemplate = GetAbilityPointTemplate( 'RulerEscapes' );
	AbilityContext = XComGameStateContext_Ability( GameState.GetContext() );

	// bad data somewhere
	if ((APTemplate == none) || (BattleData == none) || (SourceUnit == none) || (AbilityContext == none))
		return ELR_NoInterrupt;

	if (AbilityContext.InputContext.AbilityTemplateName != 'AlienRulerEscape')
		return ELR_NoInterrupt;

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

static function X2AbilityPointTemplate CreateRulerDefeatedEvent()
{
	local X2AbilityPointTemplate Template;

	`CREATE_X2TEMPLATE(class'X2AbilityPointTemplate', Template, 'RulerDefeated');
	Template.AddEvent('UnitDied', CheckForRulerDefeated);

	return Template;
}

static protected function EventListenerReturn CheckForRulerDefeated(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit KilledUnit;
	local XComGameState_BattleData BattleData;
	local X2AbilityPointTemplate APTemplate;
	local int Roll;
	local XComGameStateContext_AbilityPointEvent EventContext;

	KilledUnit = XComGameState_Unit(EventSource);
	BattleData = XComGameState_BattleData( `XCOMHISTORY.GetSingleGameStateObjectForClass( class'XComGameState_BattleData' ) );
	APTemplate = GetAbilityPointTemplate( 'RulerDefeated' );

	// bad data somewhere
	if ((APTemplate == none) || (BattleData == none) || (KilledUnit == none))
		return ELR_NoInterrupt;

	// ignore everybody who is not an Alien Ruler
	if (KilledUnit.GetMyTemplate().Abilities.Find('AlienRulerInitialState') == INDEX_NONE)
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