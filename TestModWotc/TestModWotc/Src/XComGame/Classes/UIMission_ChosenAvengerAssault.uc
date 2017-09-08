//---------------------------------------------------------------------------------------
//  FILE:    UIMission_ChosenAvengerAssault.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class UIMission_ChosenAvengerAssault extends UIMission;

var public localized String m_strTitle;
var public localized String m_strConfirmMission;
var public localized String m_strAvengerAssaultObjective;
var public localized String m_strAvengerAssaultObjectiveDesc;

var UIPanel DefaultPanel;

//----------------------------------------------------------------------------
// MEMBERS

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	local XComGameState NewGameState;
	local XComGameState_AdventChosen ChosenState;

	ChosenState = GetChosen();
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger Event: On Chosen Avenger Assault");
	`XEVENTMGR.TriggerEvent('OnViewAvengerAssaultMission', , , NewGameState);
	`XEVENTMGR.TriggerEvent(ChosenState.GetAvengerAssaultCommentEvent(), , , NewGameState);
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

	super.InitScreen(InitController, InitMovie, InitName);

	FindMission('MissionSource_ChosenAvengerAssault');
	
	BuildScreen();
}

simulated function Name GetLibraryID()
{
	return 'Alert_ChosenBlades';
}

simulated function BindLibraryItem()
{
	local Name AlertLibID;

	AlertLibID = GetLibraryID();
	if (AlertLibID != '')
	{
		LibraryPanel = Spawn(class'UIPanel', self);
		LibraryPanel.bAnimateOnInit = false;
		LibraryPanel.InitPanel('', AlertLibID);
		
		ConfirmButton = Spawn(class'UIButton', LibraryPanel);
		ConfirmButton.SetResizeToText(false);
		ConfirmButton.InitButton('ConfirmButton', "", OnLaunchClicked);

		ButtonGroup = Spawn(class'UIPanel', LibraryPanel);
		ButtonGroup.InitPanel('ButtonGroup', '');

		Button1 = Spawn(class'UIButton', ButtonGroup);
		Button1.SetResizeToText(false);
		Button1.InitButton('Button0', "");

		Button2 = Spawn(class'UIButton', ButtonGroup);
		Button2.SetResizeToText(false);
		Button2.InitButton('Button1', "");

		ShadowChamber = Spawn(class'UIAlertShadowChamberPanel', LibraryPanel);
		ShadowChamber.InitPanel('UIAlertShadowChamberPanel', 'Alert_ShadowChamber');

		SitrepPanel = Spawn(class'UIAlertSitRepPanel', LibraryPanel);
		SitrepPanel.InitPanel('SitRep', 'Alert_SitRep');
		SitrepPanel.SetTitle(m_strSitrepTitle);

		ChosenPanel = Spawn(class'UIPanel', LibraryPanel).InitPanel(, 'Alert_ChosenRegionInfo');
		ChosenPanel.DisableNavigation();
	}
}

simulated function RefreshNavigation()
{
	if (ConfirmButton.bIsVisible)
	{
		ConfirmButton.EnableNavigation();
	}
	else
	{
		ConfirmButton.DisableNavigation();
	}

	if (Button1.bIsVisible)
	{
		Button1.EnableNavigation();
	}
	else
	{
		Button1.DisableNavigation();
	}

	if (Button2.bIsVisible)
	{
		Button2.EnableNavigation();
	}
	else
	{
		Button2.DisableNavigation();
	}

	LibraryPanel.bCascadeFocus = false;
	LibraryPanel.SetSelectedNavigation();
	ButtonGroup.bCascadeFocus = false;
	ButtonGroup.SetSelectedNavigation();

	if (Button1.bIsNavigable)
		Button1.SetSelectedNavigation();
	else if (Button2.bIsNavigable)
		Button2.SetSelectedNavigation();
	else if (ConfirmButton.bIsNavigable)
		ConfirmButton.SetSelectedNavigation();

	if (ShadowChamber != none)
		ShadowChamber.DisableNavigation();
}

simulated function BuildScreen()
{
	local XComGameState_AdventChosen ChosenState;

	ChosenState = GetChosen();
	if (ChosenState != none)
	{
		PlaySFX(ChosenState.GetMyTemplate().FanfareEvent);
	}

	// Add Interception warning and Shadow Chamber info 
	super.BuildScreen();
}

simulated function BuildMissionPanel()
{
	local XComGameState_AdventChosen ChosenState;

	ChosenState = GetChosen();

	BuildChosenIcon(ChosenState.GetChosenIcon());
	// Send over to flash ---------------------------------------------------

	LibraryPanel.MC.BeginFunctionOp("UpdateChosenInfoBlade");
	LibraryPanel.MC.QueueString(m_strTitle); // Title
	LibraryPanel.MC.QueueString(ChosenState.GetChosenClassName()); // Chosen Type
	LibraryPanel.MC.QueueString(ChosenState.GetChosenName()); // Chosen Name
	LibraryPanel.MC.QueueString(ChosenState.GetChosenNickname()); // Chosen Nickname
	LibraryPanel.MC.QueueString(GetMissionImage()); // Image
	LibraryPanel.MC.QueueString(GetOpName()); // Mission Value
	LibraryPanel.MC.QueueString(m_strAvengerAssaultObjective); // Objective Label
	LibraryPanel.MC.QueueString(m_strAvengerAssaultObjectiveDesc); // Objective Value
	LibraryPanel.MC.QueueString(GetMissionDescString()); // Objective Details
	LibraryPanel.MC.EndOp();
}

simulated function BuildOptionsPanel()
{
	// ---------------------

	LibraryPanel.MC.BeginFunctionOp("UpdateChosenButtonBlade");
	LibraryPanel.MC.QueueString(m_strConfirmLabel);
	LibraryPanel.MC.QueueString(m_strConfirmMission);
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.default.m_strGenericCancel);
	LibraryPanel.MC.EndOp();

	// ---------------------

	Button1.SetBad(true);
	Button1.OnClickedDelegate = OnLaunchClicked;

	Button2.Hide();
	ConfirmButton.Hide();
}

function BuildChosenIcon(StackedUIIconData IconInfo)
{
	local int i;

	LibraryPanel.MC.BeginFunctionOp("UpdateChosenIcon");
	LibraryPanel.MC.QueueBoolean(IconInfo.bInvert);
	for (i = 0; i < IconInfo.Images.Length; i++)
	{
		LibraryPanel.MC.QueueString("img:///" $ IconInfo.Images[i]);
	}

	LibraryPanel.MC.EndOp();
}

//-------------- EVENT HANDLING --------------------------------------------------------
simulated function OnLaunchClicked(UIButton button)
{
	GetMission().SelectSquad();
	CloseScreen();
}

//-------------- GAME DATA HOOKUP --------------------------------------------------------
simulated function String GetOpName()
{
	local GeneratedMissionData MissionData;

	MissionData = XCOMHQ().GetGeneratedMissionData(MissionRef.ObjectID);

	return MissionData.BattleOpName;
}
simulated function XComGameState_MissionSite GetMission()
{
	local XComGameStateHistory History;

	History = `XCOMHISTORY;
	return XComGameState_MissionSiteChosenAssault(History.GetGameStateForObjectID(MissionRef.ObjectID));
}
simulated function XComGameState_AdventChosen GetChosen()
{
	local XComGameState_ResistanceFaction FactionState;
	local XComGameState_AdventChosen ChosenState;

	FactionState = GetMission().GetResistanceFaction();
	if (FactionState != None)
	{
		ChosenState = FactionState.GetRivalChosen();
	}

	return ChosenState;
}

simulated function String GetMissionDescString()
{
	local XGParamTag ParamTag;
	local XComGameState_AdventChosen ChosenState;

	ChosenState = GetChosen();
	
	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = ChosenState.GetChosenName();

	return `XEXPAND.ExpandString(super.GetMissionDescString());
}

//==============================================================================
defaultproperties
{
	Package = "/ package/gfxAlerts/Alerts";
	InputState = eInputState_Consume;
}