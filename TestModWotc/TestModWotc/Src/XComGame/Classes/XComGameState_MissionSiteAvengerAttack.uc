//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_MissionSiteAvengerAttack.uc
//  AUTHOR:  Joe Weinhoffer  --  06/26/2015
//  PURPOSE: This object represents the instance data for a mission on the world map
//			where the Avenger is attacked
//          
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_MissionSiteAvengerAttack extends XComGameState_MissionSite
	native(Core);

//---------------------------------------------------------------------------------------
//----------- XComGameState_GeoscapeEntity Implementation -------------------------------
//---------------------------------------------------------------------------------------

function bool RequiresAvenger()
{
	// Avenger Defense requires the Avenger at the mission site
	return true;
}

function SelectSquad()
{
	local XGStrategy StrategyGame;

	BeginInteraction();

	StrategyGame = `GAME;
	StrategyGame.PrepareTacticalBattle(ObjectID);
	`HQPRES.UISquadSelect(true); // prevent backing out of the squad select screen
}

// Complete the squad select interaction; the mission will not begin until this destination has been reached
function SquadSelectionCompleted()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Skyranger SkyrangerState;
	local XComGameState NewGameState;
	
	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Load Squad onto Skyranger");
	SkyrangerState = XComGameState_Skyranger(NewGameState.ModifyStateObject(class'XComGameState_Skyranger', XComHQ.SkyrangerRef.ObjectID));
	SkyrangerState.SquadOnBoard = true;
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

	// Transfer directly to the mission
	ConfirmMission();
}

function DestinationReached()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local array<XComGameState_Unit> AllSoldiers;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	AllSoldiers = XComHQ.GetSoldiers();

	if (AllSoldiers.Length == 0)
	{
		class'X2StrategyElement_DefaultAlienAI'.static.PlayerLossAction();
		return;
	}

	BeginInteraction();
	TriggerMissionPopup();
}

function TriggerMissionPopup()
{
	// This will be implemented in subclasses
}