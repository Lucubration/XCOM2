//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_MissionSiteLostTowers.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_MissionSiteLostTowers extends XComGameState_MissionSiteOutsideRegions;

function MissionSelected()
{
	local XComHQPresentationLayer Pres;
	local UIMission_LostTowers kScreen;

	Pres = `HQPRES;

	// Show the lost towers mission
	if (!Pres.ScreenStack.GetCurrentScreen().IsA('UIMission_LostTowers'))
	{
		kScreen = Pres.Spawn(class'UIMission_LostTowers');
		kScreen.MissionRef = GetReference();
		Pres.ScreenStack.Push(kScreen);
	}

	if (`GAME.GetGeoscape().IsScanning())
	{
		Pres.StrategyMap2D.ToggleScan();
	}
}

function SelectSquad()
{
	local XComGameState NewGameState;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger Event: Lost Towers Squad Select");
	`XEVENTMGR.TriggerEvent('LostTowersMissionSquadSelect', , , NewGameState);
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

	Super.SelectSquad();
}

function string GetUIButtonIcon()
{
	return "img:///UILibrary_DLC3Images.MissionIcon_Tower";
}