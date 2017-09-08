//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_DisableInterceptMovement.uc
//  PURPOSE: Kismet action to disable intercept movement.  Implemented for Compound Rescue
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class SeqAct_DisableInterceptMovement extends SequenceAction;

event Activated()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_BattleData BattleData;
	
	History = `XCOMHISTORY;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Kismet Disabled Intercept Movement");

	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	BattleData = XComGameState_BattleData(NewGameState.ModifyStateObject(class'XComGameState_BattleData', BattleData.ObjectID));
	
	if(InputLinks[0].bHasImpulse)
	{
		BattleData.bKismetDisabledInterceptMovement = true;
	}
	else if(InputLinks[1].bHasImpulse)
	{
		BattleData.bKismetDisabledInterceptMovement = false;
	}

	`TACTICALRULES.SubmitGameState(NewGameState);
}

defaultproperties
{
	ObjCategory="AI"
	ObjName="Disable Intercept Movement"

	InputLinks(0)=(LinkDesc="Disable")
	InputLinks(1)=(LinkDesc="ReEnable")

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
}
