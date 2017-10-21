//---------------------------------------------------------------------------------------
//  FILE:    X2EventListener_DLC_3_AbilityPoints.uc
//  AUTHOR:  Russell Aasland
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2EventListener_DLC_3_AbilityPoints extends X2EventListener_AbilityPoints
	config(GameCore);


static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem( CreateJulianDefeatedEvent() );

	return Templates;
}

static function X2AbilityPointTemplate CreateJulianDefeatedEvent()
{
	local X2AbilityPointTemplate Template;

	`CREATE_X2TEMPLATE(class'X2AbilityPointTemplate', Template, 'JulianDefeated');
	Template.AddEvent('UnitDied', CheckForJulianDefeated);

	return Template;
}

static protected function EventListenerReturn CheckForJulianDefeated(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit KilledUnit;
	local XComGameState_BattleData BattleData;
	local X2AbilityPointTemplate APTemplate;
	local int Roll;
	local XComGameStateContext_AbilityPointEvent EventContext;

	KilledUnit = XComGameState_Unit(EventSource);
	BattleData = XComGameState_BattleData( `XCOMHISTORY.GetSingleGameStateObjectForClass( class'XComGameState_BattleData' ) );
	APTemplate = GetAbilityPointTemplate( 'JulianDefeated' );

	// bad data somewhere
	if ((APTemplate == none) || (BattleData == none) || (KilledUnit == none))
		return ELR_NoInterrupt;

	// ignore everybody who is not Julian's final form
	if (KilledUnit.GetMyTemplateName() != 'Sectopod_Markov')
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