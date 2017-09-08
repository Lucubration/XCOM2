//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_DisableAIFallback.uc
//  AUTHOR:  James Brawley - 2/16/2017
//  PURPOSE: Kismet action to disable AI fallback behavior for the remainder of the mission
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_DisableAIFallback extends SequenceAction;

function ModifyKismetGameState(out XComGameState GameState)
{
	local XGAIPlayer AIPlayer;
	local XComGameState_AIPlayerData AIData;

	AIPlayer = XGAIPlayer(XGBattle_SP(`BATTLE).GetAIPlayer());

	AIData = XComGameState_AIPlayerData(GameState.ModifyStateObject(class'XComGameState_AIPlayerData', AIPlayer.GetAIDataID()));
	AIData.RetreatCap = 0;
}

defaultproperties
{
	ObjCategory="AI"
	ObjName="Disable AI Fallback"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
}
