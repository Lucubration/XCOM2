//---------------------------------------------------------------------------------------
//  FILE:    UIMission_ChosenStronghold.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class UIMission_ChosenStronghold extends UIMission;

var localized String m_strTitle;
var localized String m_strLockedHelp;
var localized String m_strFlavorTextAssassin;
var localized String m_strFlavorTextHunter;
var localized String m_strFlavorTextWarlock;

//----------------------------------------------------------------------------
// MEMBERS

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	local XComGameState NewGameState;

	super.InitScreen(InitController, InitMovie, InitName);

	FindMission('MissionSource_ChosenStronghold');

	if (!CanTakeMission())
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger Central Chosen Stronghold Mission Dialogue");
		`XEVENTMGR.TriggerEvent('ChosenStrongholdAvailable', , , NewGameState);
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}

	BuildScreen();
}

simulated function Name GetLibraryID()
{
	return 'Alert_ChosenBlades';
}

// Override, because we use a DefaultPanel in teh structure. 
simulated function BindLibraryItem()
{
	local Name AlertLibID;

	AlertLibID = GetLibraryID();
	if (AlertLibID != '')
	{
		LibraryPanel = Spawn(class'UIPanel', self);
		LibraryPanel.bAnimateOnInit = false;
		LibraryPanel.InitPanel('', AlertLibID);
		LibraryPanel.SetSelectedNavigation();
		
		ConfirmButton = Spawn(class'UIButton', LibraryPanel);
		ConfirmButton.SetResizeToText(false);
		ConfirmButton.InitButton('ConfirmButton', "", OnLaunchClicked);

		ButtonGroup = Spawn(class'UIPanel', LibraryPanel);
		ButtonGroup.InitPanel('ButtonGroup', '');
		ButtonGroup.SetSelectedNavigation();

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

simulated function BuildScreen()
{
	local XComGameState_AdventChosen ChosenState;

	ChosenState = GetChosen();
	if (ChosenState != none)
	{
		PlaySFX(ChosenState.GetMyTemplate().FanfareEvent);
	}

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
	local XComGameState_AdventChosen ChosenState;

	ChosenState = GetChosen();

	BuildChosenIcon(ChosenState.GetChosenIcon());

	// Send over to flash ---------------------------------------------------

	LibraryPanel.MC.BeginFunctionOp("UpdateChosenInfoBlade");
	LibraryPanel.MC.QueueString(GetMissionTitle()); // Title
	LibraryPanel.MC.QueueString(ChosenState.GetChosenClassName()); // Chosen Type
	LibraryPanel.MC.QueueString(ChosenState.GetChosenName()); // Chosen Name
	LibraryPanel.MC.QueueString(ChosenState.GetChosenNickname()); // Chosen Nickname
	LibraryPanel.MC.QueueString(GetMissionImage()); // Image
	LibraryPanel.MC.QueueString(GetOpName()); // Mission Value
	LibraryPanel.MC.QueueString(m_strMissionObjective); // Objective Label
	LibraryPanel.MC.QueueString(GetObjectiveString()); // Objective Value
	LibraryPanel.MC.QueueString(GetMissionDescString()); // Objective Details
	LibraryPanel.MC.EndOp();
}

simulated function BuildOptionsPanel()
{
	// ---------------------

	LibraryPanel.MC.BeginFunctionOp("UpdateChosenButtonBlade");
	LibraryPanel.MC.QueueString(m_strConfirmLabel);
	LibraryPanel.MC.QueueString(m_strLaunchMission);
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.default.m_strGenericCancel);

	if (!CanTakeMission())
	{
		LibraryPanel.MC.QueueString(m_strLocked);
		LibraryPanel.MC.QueueString(m_strLockedHelp);
		LibraryPanel.MC.QueueString(m_strOK); //OnCancelClicked
	}
	LibraryPanel.MC.EndOp();

	// ---------------------
	Button1.OnClickedDelegate = OnLaunchClicked;
	Button2.OnClickedDelegate = OnCancelClicked;

	Button1.SetBad(true);
	Button2.SetBad(true);

	if (!CanTakeMission())
	{
		// Hook up to the flash assets for locked info.
		LockedPanel = Spawn(class'UIPanel', LibraryPanel);
		LockedPanel.InitPanel('lockedMC', '');

		// bsg-jrebar (5/9/17): Back button on locked screen only
		LockedButton = Spawn(class'UIButton', LockedPanel);
		LockedButton.SetResizeToText(false);
		LockedButton.InitButton('ConfirmButton', "");
		LockedButton.SetResizeToText(true);
		LockedButton.SetStyle(eUIButtonStyle_HOTLINK_BUTTON);
		LockedButton.SetGamepadIcon(class 'UIUtilities_Input'.static.GetBackButtonIcon());
		LockedButton.OnSizeRealized = OnButtonSizeRealized;
		LockedButton.SetText(m_strBack);
		LockedButton.OnClickedDelegate = OnCancelClicked;
		LockedButton.Show();
		LockedButton.DisableNavigation();
		// bsg-jrebar (5/9/17): end

		Button1.SetDisabled(true);
		Button2.SetDisabled(true);
	}
	else
	{
		Button1.OnClickedDelegate = OnLaunchClicked;
		Button2.OnClickedDelegate = OnCancelClicked;
	}

	Button3.Hide();
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

// bsg-jrebar (5/9/17): Back button on locked screen only
simulated function bool OnUnrealCommand(int cmd, int arg)
{
	if (!CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
	{
		return false;
	}

	switch (cmd) 
	{
	case class 'UIUtilities_Input'.const.FXS_BUTTON_A:
	case class 'UIUtilities_Input'.const.FXS_KEY_ENTER:
		//bsg-hlee (05.11.17): Make the A button press fire the button that is focused.
		if (CanTakeMission() && Button1 != none && Button1.bIsVisible && Button1.bIsFocused)
		{
			Button1.Click();
		}
		else if(Button2 != none && Button2.bIsVisible && Button2.bIsFocused)
		{
			Button2.Click();
		}
		//bsg-hlee (05.11.17): End
		return true;
	case class'UIUtilities_Input'.const.FXS_BUTTON_B:
		//bsg-hlee (05.11.17): Only let the B button close the screen when the mission is locked and the button is visible.
		if(CanBackOut() && LockedButton != none && LockedButton.bIsVisible)
		{
			CloseScreen();
		}
		return true;
	}
	return super.OnUnrealCommand(cmd, arg);
}
// bsg-jrebar (5/9/17): end

//-------------- EVENT HANDLING --------------------------------------------------------

//-------------- GAME DATA HOOKUP --------------------------------------------------------
simulated function bool CanTakeMission()
{
	return !GetMission().bNotAtThreshold;;
}
simulated function EUIState GetLabelColor()
{
	return eUIState_Bad;
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

simulated function String GetMissionTitle()
{
	local XGParamTag ParamTag;
	local XComGameState_AdventChosen ChosenState;

	ChosenState = GetChosen();

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = ChosenState.GetChosenClassName();
	
	return `XEXPAND.ExpandString(m_strTitle);
}

simulated function String GetMissionDescString()
{
	local XGParamTag ParamTag;
	local XComGameState_AdventChosen ChosenState;

	ChosenState = GetChosen();

	switch (ChosenState.GetMyTemplateName())
	{
	case 'Chosen_Assassin':
		m_strFlavorText = m_strFlavorTextAssassin;
		break;
	case 'Chosen_Hunter':
		m_strFlavorText = m_strFlavorTextHunter;
		break;
	case 'Chosen_Warlock':
		m_strFlavorText = m_strFlavorTextWarlock;
		break;
	default:
		break;
	}

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = ChosenState.GetChosenName();

	return `XEXPAND.ExpandString(super.GetMissionDescString());
}

//==============================================================================

defaultproperties
{
	InputState = eInputState_Consume;
	Package = "/ package/gfxAlerts/Alerts";
}