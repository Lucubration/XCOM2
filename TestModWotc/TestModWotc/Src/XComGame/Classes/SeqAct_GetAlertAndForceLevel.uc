//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_GetAlertAndForceLevel.uc
//  AUTHOR:  James Brawley - 1/20/2017
//  PURPOSE: Kismet action to retrieve the current battle's alert level and force level
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class SeqAct_GetAlertAndForceLevel extends SequenceAction;

var int OutputForceLevel;
var int OutputAlertLevel;

event Activated()
{
	local XComGameStateHistory History;
	local XComGameState_BattleData BattleData;
	
	History = `XCOMHISTORY;

	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	
	OutputAlertLevel = BattleData.GetAlertLevel();
	OutputForceLevel = BattleData.GetForceLevel();
}

defaultproperties
{
	ObjCategory="Gameplay"
	ObjName="Get Alert and Force Level"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks.Empty;
	VariableLinks(0)=(ExpectedType=class'SeqVar_Int', LinkDesc="ForceLevel", PropertyName=OutputForceLevel, bWriteable=TRUE)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Int', LinkDesc="AlertLevel", PropertyName=OutputAlertLevel, bWriteable=TRUE)
}
