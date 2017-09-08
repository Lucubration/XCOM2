//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIEventNoticesTactical.uc
//  AUTHOR:  Brit Steiner
//  PURPOSE: Triggers notices in the tactical game. 
//---------------------------------------------------------------------------------------
//  Copyright (c) 2010-2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 
class UIEventNoticesTactical extends Object config(GameData);

var localized string RankUpMessage;
var localized string RankUpSubtitle;
var localized string LootDroppedTitle;
var localized string UnitDiedTitle;
var localized string WillLostTitle;
var localized string WatershedMomentTitle;
var localized string HackDefenseTitle;
var localized string BleedingTitle;
var localized string BleedingOutTitle;
var localized string BurningTitle;
var localized string AcidBurningTitle;
var localized string ConfusedTitle;
var localized string DisorientedTitle;
var localized string DominationTitle;
var localized string PoisonedTitle;
var localized string StunnedTitle;
var localized string UnconsciousTitle;
var localized string BoundTitle;
var localized string MarkedTitle;
var localized string TheLostTitle;
var localized string AbilityPointGainedTitle;
var localized string PanicCheckTitle;
var localized string BlindedTitle;
var localized string PanickedTitle;
var localized string DazedTitle;
var localized string FrozenTitle;
var localized string HackedTitle;
var localized string StasisTitle;

simulated function Init()
{
	local X2EventManager EventManager;
	local Object ThisObj;

	EventManager = `XEVENTMGR;
	ThisObj = self;

	EventManager.RegisterForEvent(ThisObj, 'RankUpMessage', RankUpMessageListener, ELD_OnStateSubmitted);
}

simulated function Uninit()
{
	local Object ThisObj;

	ThisObj = self;
	`XEVENTMGR.UnRegisterFromAllEvents(ThisObj);	
}

function EventListenerReturn RankUpMessageListener(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit UnitState;
	
	UnitState = XComGameState_Unit(EventSource);
	if (UnitState != None)
	{
		UnitState.RankUpTacticalVisualization();
	}

	return ELR_NoInterrupt;
}