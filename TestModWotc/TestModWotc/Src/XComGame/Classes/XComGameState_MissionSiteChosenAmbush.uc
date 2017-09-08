//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_MissionSiteChosenAmbush.uc
//  AUTHOR:  Joe Weinhoffer  --  07/22/2016
//  PURPOSE: This object represents the instance data for an Chosen Ambush mission site 
//			on the world map
//          
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_MissionSiteChosenAmbush extends XComGameState_MissionSite
	native(Core);

var() StateObjectReference CovertActionRef;

function bool RequiresAvenger()
{
	// Chosen Ambush does not require the Avenger at the mission site
	return false;
}

function SelectSquad()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_CovertAction ActionState;
	local XComGameState_StaffSlot SlotState;
	local array<StateObjectReference> MissionSoldiers;
	local int idx, NumSoldiers;
	
	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	ActionState = XComGameState_CovertAction(History.GetGameStateForObjectID(CovertActionRef.ObjectID));

	NumSoldiers = class'X2StrategyGameRulesetDataStructures'.static.GetMaxSoldiersAllowedOnMission(self);

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Set up Ambush Squad");
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	
	for (idx = 0; idx < NumSoldiers; idx++)
	{
		// If the Covert Action has a soldier in one of its staff slots, add them to the Ambush soldier list
		if (idx < ActionState.StaffSlots.Length)
		{
			SlotState = ActionState.GetStaffSlot(idx);
			if (SlotState != none && SlotState.IsSoldierSlot() && SlotState.IsSlotFilled())
			{
				MissionSoldiers.AddItem(SlotState.GetAssignedStaffRef());
			}
		}
	}
	
	// Replace the squad with the soldiers who were on the Covert Action
	XComHQ.Squad = MissionSoldiers;
	
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

function StartMission()
{
	local XGStrategy StrategyGame;
	
	BeginInteraction();
	
	StrategyGame = `GAME;
	StrategyGame.PrepareTacticalBattle(ObjectID);
	ConfirmMission(); // Transfer directly to the mission, no squad select. Squad is set up based on the covert action soldiers.
}