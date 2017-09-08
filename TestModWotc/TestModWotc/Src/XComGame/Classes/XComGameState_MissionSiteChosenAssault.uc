//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_MissionSiteChosenAssault.uc
//  AUTHOR:  Joe Weinhoffer  --  06/26/2015
//  PURPOSE: This object represents the instance data for an Chosen Assault mission site 
//			on the world map
//          
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_MissionSiteChosenAssault extends XComGameState_MissionSiteAvengerAttack
	native(Core);

var() StateObjectReference AttackingChosen;

function TriggerMissionPopup()
{
	local XComGameState NewGameState;
	local XComGameState_AdventChosen ChosenState;

	ChosenState = XComGameState_AdventChosen(`XCOMHISTORY.GetGameStateForObjectID(AttackingChosen.ObjectID));

	// Trigger the Avenger Assault cinematic
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Chosen Assault Event");
	`XEVENTMGR.TriggerEvent(ChosenState.GetAvengerAssaultEvent(), , , NewGameState);
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

	`HQPRES.UIChosenAvengerAssaultMission(self);
}