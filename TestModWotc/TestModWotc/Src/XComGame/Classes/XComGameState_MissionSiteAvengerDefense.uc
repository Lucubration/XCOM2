//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_MissionSiteAvengerDefense.uc
//  AUTHOR:  Joe Weinhoffer  --  06/26/2015
//  PURPOSE: This object represents the instance data for an Avenger Defense mission site 
//			on the world map
//          
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_MissionSiteAvengerDefense extends XComGameState_MissionSiteAvengerAttack
	native(Core);

var() StateObjectReference AttackingUFO;

function TriggerMissionPopup()
{
	local XComGameState NewGameState;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Avenger Attacked Event");
	`XEVENTMGR.TriggerEvent('AvengerAttacked', , , NewGameState);
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

	`HQPRES.UIUFOAttack(self);
}