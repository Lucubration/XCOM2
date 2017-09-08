//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_AdvanceLostActivation.uc
//  AUTHOR:  James Brawley - 3/29/2017
//  PURPOSE: Kismet action to add lost activation credit (or force immediate activation)  
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_AdvanceLostActivation extends SequenceAction;

var() int ActivationAmount; // The strength of the sound
var() bool SoundAdvance; // If true, play a warning message to the player
var() bool ForceImmediateActivation; // If true, immediately triggers the next lost group

event Activated()
{
	local XComGameStateHistory History;
	local XComGameState_BattleData BattleData;
	
	History = `XCOMHISTORY;
	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));

	BattleData.AdvanceLostSpawning(ActivationAmount, SoundAdvance, ForceImmediateActivation);
}

defaultproperties
{
	ObjCategory="Gameplay"
	ObjName="Lost - Advance Lost Activation"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	ActivationAmount = 0
	SoundAdvance = false
	ForceImmediateActivation = false

	VariableLinks(0)=(ExpectedType=class'SeqVar_Int',LinkDesc="Amount",PropertyName=ActivationAmount)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Bool',LinkDesc="SoundAdvance",PropertyName=SoundAdvance)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Bool',LinkDesc="ForceActivation",PropertyName=ForceImmediateActivation)
}
