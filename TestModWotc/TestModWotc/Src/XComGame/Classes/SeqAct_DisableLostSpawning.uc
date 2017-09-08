//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_DisableLostSpawning.uc
//  AUTHOR:  James Brawley - 9/21/2016
//  PURPOSE: Kismet action to disable further lost spawning for the battle.  
//			 Used to stop further lost spawns when sweep objectives are cleared.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class SeqAct_DisableLostSpawning extends SequenceAction;

event Activated()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_BattleData BattleData;
	
	History = `XCOMHISTORY;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Kismet Disabled Lost Spawns");

	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	BattleData = XComGameState_BattleData(NewGameState.ModifyStateObject(class'XComGameState_BattleData', BattleData.ObjectID));
	
	if(InputLinks[0].bHasImpulse)
	{
		BattleData.bLostSpawningDisabledViaKismet = true;
	}
	else if(InputLinks[1].bHasImpulse)
	{
		BattleData.bLostSpawningDisabledViaKismet = false;
	}

	`TACTICALRULES.SubmitGameState(NewGameState);
}

defaultproperties
{
	ObjCategory="Gameplay"
	ObjName="Lost - Enable/Disable Spawning"

	InputLinks(0)=(LinkDesc="Disable")
	InputLinks(1)=(LinkDesc="ReEnable")

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
}
