//---------------------------------------------------------------------------------------
//  FILE:    UIMission_RescueSoldier.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class UIMission_RescueSoldier extends UIMission;

var public localized string m_strRescueMission;
var public localized string m_strImageGreeble;

//----------------------------------------------------------------------------
// MEMBERS

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	local XComGameState NewGameState;

	super.InitScreen(InitController, InitMovie, InitName);

	FindMission('MissionSource_RescueSoldier');

	if (CanTakeMission())
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger Central Rescue Soldier Mission Dialogue");
		`XEVENTMGR.TriggerEvent('OnViewRescueSoldierMission', , , NewGameState);
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}

	BuildScreen();
}

simulated function Name GetLibraryID()
{
	return 'XPACK_Alert_MissionBlades';
}

simulated function BuildScreen()
{
	local XComGameState_ResistanceFaction FactionState;

	// Add Interception warning and Shadow Chamber info 
	super.BuildScreen();

	FactionState = GetMission().GetResistanceFaction();
	PlaySFX((FactionState != None) ? FactionState.GetFanfareEvent() : "GeoscapeFanfares_AlienFacility");

	XComHQPresentationLayer(Movie.Pres).CAMSaveCurrentLocation();

	if (bInstantInterp)
	{
		XComHQPresentationLayer(Movie.Pres).CAMLookAtEarth(GetMission().Get2DLocation(), CAMERA_ZOOM, 0);
	}
	else
	{
		XComHQPresentationLayer(Movie.Pres).CAMLookAtEarth(GetMission().Get2DLocation(), CAMERA_ZOOM);
	}
}

simulated function BuildMissionPanel()
{
	local XComGameState_ResistanceFaction FactionState;

	FactionState = GetMission().GetResistanceFaction();

	LibraryPanel.MC.BeginFunctionOp("UpdateMissionInfoBlade");
	LibraryPanel.MC.QueueString(m_strImageGreeble);
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString(FactionState.GetFactionTitle());
	LibraryPanel.MC.QueueString(FactionState.GetFactionName());
	LibraryPanel.MC.QueueString(GetMissionImage());
	LibraryPanel.MC.QueueString(GetOpName());
	LibraryPanel.MC.QueueString(m_strMissionObjective);
	LibraryPanel.MC.QueueString(GetObjectiveString());
	LibraryPanel.MC.QueueString(m_strReward);
	LibraryPanel.MC.EndOp();
	
	LibraryPanel.MC.BeginFunctionOp("UpdateMissionReward");
	LibraryPanel.MC.QueueNumber(0);
	LibraryPanel.MC.QueueString(GetRewardString());
	LibraryPanel.MC.QueueString(""); // Rank Icon
	LibraryPanel.MC.QueueString(""); // Class Icon
	LibraryPanel.MC.EndOp();

	SetFactionIcon(FactionState.GetFactionIcon());
	
	Button1.OnClickedDelegate = OnLaunchClicked;
	Button2.OnClickedDelegate = OnCancelClicked;
	Button3.Hide();
	ConfirmButton.Hide();
}

simulated function BuildOptionsPanel()
{
	LibraryPanel.MC.BeginFunctionOp("UpdateMissionButtonBlade");
	LibraryPanel.MC.QueueString(m_strRescueMission);
	LibraryPanel.MC.QueueString(m_strLaunchMission);
	LibraryPanel.MC.QueueString(m_strIgnore);
	LibraryPanel.MC.EndOp();
}

//bsg-crobinson (5.12.17): Dont refresh navigation for this screen
simulated function RefreshNavigation()
{
	super.RefreshNavigation();

	if(`ISCONTROLLERACTIVE)
	{
		Button1.SetStyle(eUIButtonStyle_HOTLINK_WHEN_SANS_MOUSE);
		Button1.SetGamepadIcon("");
		Button1.SetPosition(-90,0);
		Button1.SetText(class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Input'.static.GetAdvanceButtonIcon(),20,20,-10) @ m_strLaunchMission);

		Button2.SetStyle(eUIButtonStyle_HOTLINK_WHEN_SANS_MOUSE);
		Button2.SetGamepadIcon("");
		Button2.SetPosition(-55,25);
		Button2.SetText(class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Input'.static.GetBackButtonIcon(),20,20,-10) @ m_strIgnore);

		Navigator.Clear();
	}
}
//bsg-crobinson (5.12.17): end

function SetFactionIcon(StackedUIIconData factionIcon)
{
	local int i;
	LibraryPanel.MC.BeginFunctionOp("SetFactionIcon");

	LibraryPanel.MC.QueueBoolean(factionIcon.bInvert);
	for (i = 0; i < factionIcon.Images.Length; i++)
	{
		LibraryPanel.MC.QueueString("img:///" $ factionIcon.Images[i]);
	}
	LibraryPanel.MC.EndOp();
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
	Package = "/ package/gfxXPACK_Alerts/XPACK_Alerts";
}