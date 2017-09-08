//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_AlterLostSpawningValues.uc
//  AUTHOR:  James Brawley - 11/8/2016
//  PURPOSE: Kismet action to change lost spawning parameters.  
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_AlterLostSpawningValues extends SequenceAction;

var() int NewLostMinSpawnCooldown; // Change the minimum ticks per lost swarm
var() int NewLostMaxSpawnCooldown; // Change the maximum ticks per lost swarm
var() int NewLostMaxWaves;  //Change the maximum number of lost waves that can deploy in this mission

var() int NewLostSpawningDistance; //Change the preferred distance of the lost spawns from XCOM

var() string NewLostGroupID; // Change the encounter ID used as the lost reinforcement group

event Activated()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_BattleData BattleData;
	
	History = `XCOMHISTORY;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Kismet Altered Lost Spawning Parameters");

	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	BattleData = XComGameState_BattleData(NewGameState.ModifyStateObject(class'XComGameState_BattleData', BattleData.ObjectID));
	
	if(NewLostMinSpawnCooldown > 0 || NewLostMaxSpawnCooldown > 0)
	{
		if(NewLostMinSpawnCooldown > 0 && NewLostMaxSpawnCooldown > 0)
		{
			if(NewLostMaxSpawnCooldown >= NewLostMinSpawnCooldown)
			{
				BattleData.KismetMinLostSpawnTurnOverride = NewLostMinSpawnCooldown;
				BattleData.KismetMaxLostSpawnTurnOverride = NewLostMaxSpawnCooldown;
			}
			else
			{
				`Redscreen("SeqAct_AlterLostSpawningValues: New max spawn cooldown is less than the minimum spawn cooldown. This is not a legal config.");
			}
		}
		else
		{
			`Redscreen("SeqAct_AlterLostSpawningValues: New min/max cooldown was provided but the counterpart value provided is blank. Check the node setup.");
		}
	}

	if(NewLostGroupID != "")
	{
		BattleData.LostGroupID = name(NewLostGroupID);
	}

	if(NewLostMaxWaves >= 0)
	{ 
		BattleData.LostMaxWaves = NewLostMaxWaves; 
	}

	if(NewLostSpawningDistance >= 0)
	{ 
		BattleData.LostSpawningDistance = NewLostSpawningDistance; 
	}

	`TACTICALRULES.SubmitGameState(NewGameState);
}

defaultproperties
{
	ObjCategory="Gameplay"
	ObjName="Lost - Alter Spawning Parameters"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	NewLostMinSpawnCooldown = 0
	NewLostMaxSpawnCooldown = 0
	NewLostMaxWaves = -1
	NewLostSpawningDistance = -1
	NewLostGroupID = ""

	VariableLinks(0)=(ExpectedType=class'SeqVar_Int',LinkDesc="NewLostMaxWaves",PropertyName=NewLostMaxWaves)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Int',LinkDesc="NewLostSpawningDistance",PropertyName=NewLostSpawningDistance)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Int',LinkDesc="NewLostMinSpawnCooldown",PropertyName=NewLostMinSpawnCooldown)
	VariableLinks(3)=(ExpectedType=class'SeqVar_Int',LinkDesc="NewLostMaxSpawnCooldown",PropertyName=NewLostMaxSpawnCooldown)
	VariableLinks(4)=(ExpectedType=class'SeqVar_String',LinkDesc="NewLostGroupID",PropertyName=NewLostGroupID)
}
