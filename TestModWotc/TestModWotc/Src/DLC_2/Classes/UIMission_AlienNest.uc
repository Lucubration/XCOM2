//---------------------------------------------------------------------------------------
//  FILE:    UIMission_AlienNest.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class UIMission_AlienNest extends UIMission;

//----------------------------------------------------------------------------
// MEMBERS

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	local XComGameState NewGameState;

	super.InitScreen(InitController, InitMovie, InitName);

	FindMission('MissionSource_AlienNest');

	if (CanTakeMission())
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger Central Alien Nest Mission Dialogue");
		`XEVENTMGR.TriggerEvent('OnViewAlienNestMission', , , NewGameState);
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}

	BuildScreen();
}

simulated function Name GetLibraryID()
{
	return 'Alert_SpecialMission';
}

// Override, because we use a DefaultPanel in teh structure. 
simulated function BindLibraryItem()
{
	local Name AlertLibID;
	local UIPanel DefaultPanel;

	AlertLibID = GetLibraryID();
	if (AlertLibID != '')
	{
		LibraryPanel = Spawn(class'UIPanel', self);
		LibraryPanel.bAnimateOnInit = false;
		LibraryPanel.InitPanel('', AlertLibID);
		LibraryPanel.SetSelectedNavigation();

		DefaultPanel = Spawn(class'UIPanel', LibraryPanel);
		DefaultPanel.bAnimateOnInit = false;
		DefaultPanel.bCascadeFocus = false;
		DefaultPanel.InitPanel('DefaultPanel');
		DefaultPanel.SetSelectedNavigation();

		ConfirmButton = Spawn(class'UIButton', DefaultPanel);
		ConfirmButton.SetResizeToText(false);
		ConfirmButton.InitButton('ConfirmButton', "", OnLaunchClicked);

		ButtonGroup = Spawn(class'UIPanel', DefaultPanel);
		ButtonGroup.InitPanel('ButtonGroup', '');
		ButtonGroup.SetSelectedNavigation();

		Button1 = Spawn(class'UIButton', ButtonGroup);
		Button1.SetResizeToText(false);
		Button1.InitButton('Button0', "");

		Button2 = Spawn(class'UIButton', ButtonGroup);
		Button2.SetResizeToText(false);
		Button2.InitButton('Button1', "");

		Button3 = Spawn(class'UIButton', ButtonGroup);
		Button3.SetResizeToText(false);
		Button3.InitButton('Button2', "");

		ShadowChamber = Spawn(class'UIAlertShadowChamberPanel', LibraryPanel);
		ShadowChamber.InitPanel('UIAlertShadowChamberPanel', 'Alert_ShadowChamber');

		SitrepPanel = Spawn(class'UIAlertSitRepPanel', LibraryPanel);
		SitrepPanel.InitPanel('SitRep', 'Alert_SitRep');
		SitrepPanel.SetTitle(m_strSitrepTitle);


		ChosenPanel = Spawn(class'UIPanel', LibraryPanel);
		ChosenPanel.InitPanel(, 'Alert_ChosenRegionInfo');
		ChosenPanel.DisableNavigation();
	}
}

simulated function BuildScreen()
{
	PlaySFX("GeoscapeFanfares_AlienFacility");
	XComHQPresentationLayer(Movie.Pres).CAMSaveCurrentLocation();

	if (bInstantInterp)
	{
		XComHQPresentationLayer(Movie.Pres).CAMLookAtEarth(GetMission().Get2DLocation(), CAMERA_ZOOM, 0);
	}
	else
	{
		XComHQPresentationLayer(Movie.Pres).CAMLookAtEarth(GetMission().Get2DLocation(), CAMERA_ZOOM);
	}
	// Add Interception warning and Shadow Chamber info 
	super.BuildScreen();
}

simulated function BuildMissionPanel()
{
	// Send over to flash ---------------------------------------------------

	LibraryPanel.MC.BeginFunctionOp("UpdateGoldenPathInfoBlade");
	LibraryPanel.MC.QueueString(""); //class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(GetRegion().GetMyTemplate().DisplayName) AlienNest doesn't have a region
	LibraryPanel.MC.QueueString(GetMissionTitle());
	LibraryPanel.MC.QueueString(GetMissionImage());
	LibraryPanel.MC.QueueString(GetOpName());
	LibraryPanel.MC.QueueString(m_strMissionObjective);
	LibraryPanel.MC.QueueString(GetObjectiveString());
	LibraryPanel.MC.QueueString(GetMissionDescString());
	if (GetMission().GetRewardAmountString() != "")
	{
		LibraryPanel.MC.QueueString(m_strReward $":");
		LibraryPanel.MC.QueueString(GetMission().GetRewardAmountString());
	}
	LibraryPanel.MC.EndOp();
}

simulated function BuildOptionsPanel()
{
	// ---------------------

	LibraryPanel.MC.BeginFunctionOp("UpdateGoldenPathButtonBlade");
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString(m_strLaunchMission);
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.default.m_strGenericCancel);
	LibraryPanel.MC.EndOp();

	// ---------------------
	Button1.OnClickedDelegate = OnLaunchClicked;
	Button2.OnClickedDelegate = OnCancelClicked;

	Button1.SetGood(true);
	Button2.SetGood(true); 

	Button3.Hide();
	ConfirmButton.Hide();
}

//-------------- EVENT HANDLING --------------------------------------------------------

//-------------- GAME DATA HOOKUP --------------------------------------------------------
simulated function bool CanTakeMission()
{
	return true;
}
simulated function EUIState GetLabelColor()
{
	return eUIState_Bad;
}

//==============================================================================

defaultproperties
{
	InputState = eInputState_Consume;
	Package = "/ package/gfxAlerts/Alerts";
}