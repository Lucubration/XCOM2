//---------------------------------------------------------------------------------------
//  FILE:    SeqEvent_LostSoundLevelChanged.uc
//  AUTHOR:  James Brawley  --  11/8/2016
//  PURPOSE: Reports to Kismet when the sound level of the Lost in the battle data changes
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqEvent_LostSoundLevelChanged extends SeqEvent_GameEventTriggered;

var int NewSoundLevel;
var int SoundMagnitude;

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
		NewSoundLevel = BattleData.LostSpawningLevel;
		SoundMagnitude = BattleData.LostLastSoundMagnitude;
		CheckActivate(`BATTLE, none); // the actor isn't used for game state events, so any old actor will do 
	}

	return ELR_NoInterrupt;
}

DefaultProperties
{
	ObjName="Lost Sound Level Changed"
	EventID="LostSoundLevelChanged"

	VariableLinks(0)=(ExpectedType=class'SeqVar_Int',LinkDesc="NewSoundLevel",PropertyName=NewSoundLevel,bWriteable=TRUE)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Int',LinkDesc="SoundMagnitude",PropertyName=SoundMagnitude,bWriteable=TRUE)
}