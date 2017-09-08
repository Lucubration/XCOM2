//---------------------------------------------------------------------------------------
//  FILE:    SeqEvent_LostThresholdPassed.uc
//  AUTHOR:  James Brawley  --  11/8/2016
//  PURPOSE: Reports to Kismet when Lost passed a sound threshold
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqEvent_LostThresholdPassed extends SeqEvent_GameEventTriggered;

var int NewLostStrength;

function EventListenerReturn EventTriggered(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	local XComGameState_BattleData BattleData;

	BattleData = XComGameState_BattleData(EventSource);

	if(BattleData == none)
	{
		`Redscreen("The event was changed without updating this class!");
	}
	else
	{
		NewLostStrength = BattleData.LostQueueStrength;
		
		CheckActivate(`BATTLE, none); // the actor isn't used for game state events, so any old actor will do 
	}

	return ELR_NoInterrupt;
}

DefaultProperties
{
	ObjName="Lost Threshold Passed"
	EventID="LostThresholdPassed"

	VariableLinks(0)=(ExpectedType=class'SeqVar_Int',LinkDesc="NewLostStrength",PropertyName=NewLostStrength,bWriteable=TRUE)

}