//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_ActivateGameEvent.uc
//  AUTHOR:  David Burchanowski
//  PURPOSE: Allows Kismet to trigger X2EventManager events
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_ActivateGameEvent extends SequenceAction;

// the event to trigger
var() string EventName;

// source and data objects to pass along to the event, if any
var XComGameState_BaseObject EventSource;
var XComGameState_BaseObject EventData;

event Activated()
{
	local XComGameState NewGameState;

	if(EventName == "")
	{
		`Redscreen("SeqAct_ActivateGameEvent was not provided with an event to fire");
		return;
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Kismet SeqAct_ActivateGameEvent:"@EventName);
	`XEVENTMGR.TriggerEvent(name(EventName), EventSource, EventData, NewGameState);
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

defaultproperties
{
	ObjCategory="Gameplay"
	ObjName="Activate Game Event"
	bCallHandler=false
	
	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_String',LinkDesc="Event Name",PropertyName=EventName)
	VariableLinks(1)=(ExpectedType=class'SeqVar_GameStateObject',LinkDesc="Source Unit",PropertyName=EventSource)
	VariableLinks(2)=(ExpectedType=class'SeqVar_GameStateObject',LinkDesc="Data Unit",PropertyName=EventData)
}