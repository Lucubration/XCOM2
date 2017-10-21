//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_MissionSiteAlienNest.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_MissionSiteAlienNest extends XComGameState_MissionSiteOutsideRegions;

function MissionSelected()
{
	local XComHQPresentationLayer Pres;
	local UIMission_AlienNest kScreen;

	Pres = `HQPRES;

	// Show the alien nest mission
	if (!Pres.ScreenStack.GetCurrentScreen().IsA('UIMission_AlienNest'))
	{
		kScreen = Pres.Spawn(class'UIMission_AlienNest');
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

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger Event: Alien Nest Squad Select");
	`XEVENTMGR.TriggerEvent('NestMissionSquadSelect', , , NewGameState);
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

	Super.SelectSquad();
}

function string GetUIButtonIcon()
{
	return "img:///UILibrary_DLC2Images.MissionIcon_AlienNest";
}