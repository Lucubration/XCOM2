//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIReplay
//  AUTHOR:  Ryan McFall
//
//  PURPOSE: Provides an interface for operating X-Com 2's replay functionality
//---------------------------------------------------------------------------------------
//  Copyright (c) 2009-2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIReplay extends UIScreen;

var UIPanel		m_kButtonContainer;
var UIIcon	m_kFastForwardButton;
var UIIcon	m_kPlayButton;
var UIIcon	m_kRestartButton;
var UINavigationHelp					m_NavHelp;

var UIIcon	m_kCancelButton;


var UIButton	m_kStepForwardButton;
var UIButton	m_kStopButton;
var UIButton	m_kQuitButton;

var UIBGBox		m_kCurrentFrameInfoBG;
var UIText		m_kCurrentFrameInfoTitle;
var UIText		m_kCurrentFrameInfoText;

var bool m_bPaused;

var int m_iPlayToFrame;
var float m_playbackSpeed;
var string m_playerString;

var bool bShowFrameInfo;

var localized string m_CurrentReplayString;

var localized string m_PauseReplay;
var localized string m_PlayReplay;
var localized string m_RestartReplay;
var localized string m_FastForwardReplay;

//----------------------------------------------------------------------------
// MEMBERS

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	super.InitScreen(InitController, InitMovie, InitName);

	m_kButtonContainer = Spawn(class'UIPanel', self);

	m_kFastForwardButton = Spawn(class'UIIcon', m_kButtonContainer);
	m_kPlayButton = Spawn(class'UIIcon', m_kButtonContainer);
	m_kRestartButton = Spawn(class'UIIcon', m_kButtonContainer);

	m_kCancelButton = Spawn(class'UIIcon', self);

	//Set up buttons
	m_kButtonContainer.InitPanel('centerGroup');
	m_kFastForwardButton.InitIcon('fastForwardButton', "", , , , , OnFastForwardClicked);
	m_kFastForwardButton.EnableMouseAutomaticColorStates(eUIState_Normal);
//	m_kFastForwardButton.SetGamepadIcon(class'UIUtilities_Input'.const.ICON_X_SQUARE);

	m_kPlayButton.InitIcon('playButton', "", , , , , OnPlayClicked);
	m_kPlayButton.EnableMouseAutomaticColorStates(eUIState_Normal);
//	m_kPlayButton.SetGamepadIcon(class'UIUtilities_Input'.const.ICON_Y_TRIANGLE);

	m_kRestartButton.InitIcon('restartButton', "", , , , , OnRestartClicked);
	m_kRestartButton.EnableMouseAutomaticColorStates(eUIState_Normal);
//	m_kRestartButton.SetGamepadIcon(class'UIUtilities_Input'.const.ICON_RB_R1);

	m_kCancelButton.InitIcon('replayBackButton', "", , , , , OnCancelClicked);
	m_kCancelButton.EnableMouseAutomaticColorStates(eUIState_Normal);
//	m_kCancelButton.SetGamepadIcon(class'UIUtilities_Input'.const.ICON_B_CIRCLE);

	if(bShowFrameInfo)
	{
		m_kStepForwardButton = Spawn(class'UIButton', self);
		m_kStopButton = Spawn(class'UIButton', self);
		m_kQuitButton = Spawn(class'UIButton', self);

		m_kStepForwardButton.InitButton('stepForwardButton', "Step Forward", OnButtonClicked, eUIButtonStyle_HOTLINK_BUTTON);
		m_kStepForwardButton.SetX(250);
		m_kStepForwardButton.SetY(50);

		m_kStopButton.InitButton('stopButton', "Stop Replay", OnButtonClicked, eUIButtonStyle_HOTLINK_BUTTON);
		m_kStopButton.SetX(50);
		m_kStopButton.SetY(50);

		m_kQuitButton.InitButton('quitButton', "Quit", OnButtonClicked, eUIButtonStyle_HOTLINK_BUTTON);
		m_kQuitButton.SetX(50);
		m_kQuitButton.SetY(100);

		m_kCurrentFrameInfoBG = Spawn(class'UIBGBox', self);
		m_kCurrentFrameInfoTitle = Spawn(class'UIText', self);
		m_kCurrentFrameInfoText = Spawn(class'UIText', self);
		m_kCurrentFrameInfoBG.InitBG('infoBox', 700, 50, 500, 150);
		m_kCurrentFrameInfoTitle.InitText('infoBoxTitle', "<Empty>", true);
		m_kCurrentFrameInfoTitle.SetWidth(480);
		m_kCurrentFrameInfoTitle.SetX(710);
		m_kCurrentFrameInfoTitle.SetY(60);
		m_kCurrentFrameInfoText.InitText('infoBoxText', "<Empty>", true);
		m_kCurrentFrameInfoText.SetWidth(480);
		m_kCurrentFrameInfoText.SetX(710);
		m_kCurrentFrameInfoText.SetY(100);
	}

	if (`REPLAY.bInTutorial)
	{
		Navigator.Clear();
	}
}

simulated function OnInit()
{
	local UITacticalHUD tacHUD;
	super.OnInit();

	tacHUD = UITacticalHUD(movie.Pres.ScreenStack.GetFirstInstanceOf(class'UITacticalHUD'));

	if (tacHUD != none)
		tacHUD.Hide();

	m_playerString = `ONLINEEVENTMGR.m_sReplayUserID;;

	MC.BeginFunctionOp("SetReplayText");
	MC.QueueString(m_CurrentReplayString);
	MC.QueueString(m_playerString);//gamertag
	MC.EndOp();

	MC.BeginFunctionOp("SetButtons");
	MC.QueueString("img:///UILibrary_XPACK_Common.Replay_back");
	MC.QueueString("img:///UILibrary_XPACK_Common.Replay_restart");
	MC.QueueString("img:///UILibrary_XPACK_Common.Replay_play");
	MC.QueueString("img:///UILibrary_XPACK_Common.Replay_fastforward");
	MC.EndOp();

	if (`ISCONTROLLERACTIVE)
	{
		m_kCancelButton.Hide();
		m_kButtonContainer.AnchorBottomCenter();
		m_kButtonContainer.SetY(-100);

		m_NavHelp = Spawn(class'UINavigationHelp', self).InitNavHelp();
		UpdateNavHelp();
	}
}

simulated function ToggleDebugPanels()
{
	bShowFrameInfo = !bShowFrameInfo;

	if (bShowFrameInfo)
	{
		m_kStepForwardButton = Spawn(class'UIButton', self);
		m_kStopButton = Spawn(class'UIButton', self);
		m_kQuitButton = Spawn(class'UIButton', self);

		m_kStepForwardButton.InitButton('stepForwardButton', "Step Forward", OnButtonClicked, eUIButtonStyle_HOTLINK_BUTTON);
		m_kStepForwardButton.SetX(250);
		m_kStepForwardButton.SetY(50);

		m_kStopButton.InitButton('stopButton', "Stop Replay", OnButtonClicked, eUIButtonStyle_HOTLINK_BUTTON);
		m_kStopButton.SetX(50);
		m_kStopButton.SetY(50);

		m_kQuitButton.InitButton('quitButton', "Quit", OnButtonClicked, eUIButtonStyle_HOTLINK_BUTTON);
		m_kQuitButton.SetX(50);
		m_kQuitButton.SetY(100);

		m_kCurrentFrameInfoBG = Spawn(class'UIBGBox', self);
		m_kCurrentFrameInfoTitle = Spawn(class'UIText', self);
		m_kCurrentFrameInfoText = Spawn(class'UIText', self);
		m_kCurrentFrameInfoBG.InitBG('infoBox', 700, 50, 500, 150);
		m_kCurrentFrameInfoTitle.InitText('infoBoxTitle', "<Empty>", true);
		m_kCurrentFrameInfoTitle.SetWidth(480);
		m_kCurrentFrameInfoTitle.SetX(710);
		m_kCurrentFrameInfoTitle.SetY(60);
		m_kCurrentFrameInfoText.InitText('infoBoxText', "<Empty>", true);
		m_kCurrentFrameInfoText.SetWidth(480);
		m_kCurrentFrameInfoText.SetX(710);
		m_kCurrentFrameInfoText.SetY(100);
	}
	else
	{
		m_kStepForwardButton.Remove();
		m_kStopButton.Remove();
		m_kQuitButton.Remove();

		m_kCurrentFrameInfoBG.Remove();
		m_kCurrentFrameInfoTitle.Remove();
		m_kCurrentFrameInfoText.Remove();
	}

}

simulated function UpdateNavHelp()
{
	m_NavHelp.ClearButtonHelp();
	if (!`REPLAY.bInTutorial)
	{
	m_NavHelp.AddBackButton(BackButtonCallback);

	m_NavHelp.AddCenterHelp(m_RestartReplay, class'UIUtilities_Input'.const.ICON_RB_R1);

	if (m_bPaused)
	{
		m_NavHelp.AddCenterHelp(m_PlayReplay, class'UIUtilities_Input'.const.ICON_Y_TRIANGLE);
	}
	else
	{
		m_NavHelp.AddCenterHelp(m_PauseReplay, class'UIUtilities_Input'.const.ICON_Y_TRIANGLE);
	}

	m_NavHelp.AddCenterHelp(m_FastForwardReplay, class'UIUtilities_Input'.const.ICON_X_SQUARE);
}
}

simulated function BackButtonCallback()
{
	CloseScreen();
}

simulated function OnFastForwardClicked()
{
	Movie.Pres.PlayUISound(eSUISound_MenuSelect);

	m_playbackSpeed = 2.0f;
	WorldInfo.Game.SetGameSpeedMultiplier(m_playbackSpeed);
}

simulated function OnPlayClicked()
{
	Movie.Pres.PlayUISound(eSUISound_MenuSelect);
	if (m_bPaused)
	{
		MC.BeginFunctionOp("SetButtons");
		MC.QueueString("img:///UILibrary_XPACK_Common.Replay_back");
		MC.QueueString("img:///UILibrary_XPACK_Common.Replay_restart");
		MC.QueueString("img:///UILibrary_XPACK_Common.Replay_pause");
		MC.QueueString("img:///UILibrary_XPACK_Common.Replay_fastforward");
		MC.EndOp();

		m_playbackSpeed = 1;
		WorldInfo.Game.SetGameSpeedMultiplier(m_playbackSpeed); // Back to normal speed.

		m_bPaused = false;
		ReplayToFrame(XComTacticalGRI(class'WorldInfo'.static.GetWorldInfo().GRI).ReplayMgr.StepForwardStopFrame);
	}
	else
	{
		MC.BeginFunctionOp("SetButtons");
		MC.QueueString("img:///UILibrary_XPACK_Common.Replay_back");
		MC.QueueString("img:///UILibrary_XPACK_Common.Replay_restart");
		MC.QueueString("img:///UILibrary_XPACK_Common.Replay_play");
		MC.QueueString("img:///UILibrary_XPACK_Common.Replay_fastforward");
		MC.EndOp();
		m_bPaused = true;
	}

	if (`ISCONTROLLERACTIVE)
	{
		UpdateNavHelp();
	}
}

simulated function OnRestartClicked()
{
	Movie.Pres.PlayUISound(eSUISound_MenuSelect);
	`ONLINEEVENTMGR.bInitiateReplayAfterLoad = true;

	ConsoleCommand(`ONLINEEVENTMGR.m_sLastReplayMapCommand);
}

simulated function OnCancelClicked()
{
	//pause
	MC.BeginFunctionOp("SetButtons");
	MC.QueueString("img:///UILibrary_XPACK_Common.Replay_back");
	MC.QueueString("img:///UILibrary_XPACK_Common.Replay_restart");
	MC.QueueString("img:///UILibrary_XPACK_Common.Replay_play");
	MC.QueueString("img:///UILibrary_XPACK_Common.Replay_fastforward");
	MC.EndOp();
	m_bPaused = true;

	Movie.Pres.PlayUISound(eSUISound_MenuSelect);
	ExitGameDialogue();
}

function ExitGameDialogue()
{
	local TDialogueBoxData      kDialogData;

	kDialogData.strTitle = class'UIPauseMenu'.default.m_kExitGameDialogue_title;
	kDialogData.strAccept = class'UIPauseMenu'.default.m_sAccept;
	kDialogData.strCancel = class'UIPauseMenu'.default.m_sCancel;
	kDialogData.fnCallback = ExitGameDialogueCallback;

	Movie.Pres.UIRaiseDialog(kDialogData);
}

simulated function OnRemoved()
{
	`CHEATMGR.bHidePathingPawn = false;
	WorldInfo.Game.SetGameSpeedMultiplier(1);
}

simulated function Disconnect()
{
	`XCOMHISTORY.ResetHistory();
	ConsoleCommand("disconnect");
}

simulated public function ExitGameDialogueCallback(Name eAction)
{
	if (eAction == 'eUIAction_Accept')
	{
		Movie.Pres.PlayUISound(eSUISound_MenuSelect);

		Disconnect();
	}
	else if (eAction == 'eUIAction_Cancel')
	{
		Movie.Pres.PlayUISound(eSUISound_MenuClose);
	}
}

simulated function OnButtonClicked(UIButton button)
{
	if (button == m_kStepForwardButton)
	{
		Movie.Pres.PlayUISound(eSUISound_MenuSelect);
		UpdateCurrentFrameInfoBox();
		if (XComTacticalGRI(class'WorldInfo'.static.GetWorldInfo().GRI).ReplayMgr.bInTutorial)
		{
			XComTacticalGRI(class'WorldInfo'.static.GetWorldInfo().GRI).ReplayMgr.StepReplayForward();
			XComTacticalGRI(class'WorldInfo'.static.GetWorldInfo().GRI).ReplayMgr.GotoState('PlayUntilPlayerInputRequired');
		}
		else
		{
			XComTacticalGRI(class'WorldInfo'.static.GetWorldInfo().GRI).ReplayMgr.StepReplayForward();
		}
	}
	else if (button == m_kStopButton)
	{
		ToggleVisible();
		Movie.Pres.PlayUISound(eSUISound_MenuSelect);
		XComTacticalGRI(class'WorldInfo'.static.GetWorldInfo().GRI).ReplayMgr.StopReplay();
		CloseScreen();
	}
	else if (button == m_kQuitButton)
	{
		Movie.Pres.PlayUISound(eSUISound_MenuSelect);
		Disconnect();
	}
}

function ReplayToFrame(int iFrame)
{
	local XComReplayMgr kReplayMgr;

	kReplayMgr = XComTacticalGRI(class'WorldInfo'.static.GetWorldInfo().GRI).ReplayMgr;
	if (kReplayMgr != None)
	{
		m_iPlayToFrame = Max(iFrame, kReplayMgr.CurrentHistoryFrame);
		m_iPlayToFrame = Min(iFrame, kReplayMgr.StepForwardStopFrame);
		`XCOMVISUALIZATIONMGR.EnableBuildVisualization(true);
		DelayedReplayToFrame();
	}
}

function OnCompleteReplayToFrame()
{
	m_playbackSpeed = 1;
	m_iPlayToFrame = -1;

	WorldInfo.Game.SetGameSpeedMultiplier(m_playbackSpeed); // Back to normal speed.

	`PRES.UIChallengeModeSummaryScreen();
}

function DelayedReplayToFrame()
{
	local XComReplayMgr kReplayMgr;
	if (!class'XComGameStateVisualizationMgr'.static.VisualizerBusy() && !m_bPaused)
	{
		kReplayMgr = XComTacticalGRI(class'WorldInfo'.static.GetWorldInfo().GRI).ReplayMgr;
		if (kReplayMgr != None)
		{
			kReplayMgr.StepReplayForward();
			UpdateCurrentFrameInfoBox();

			if (kReplayMgr.CurrentHistoryFrame < m_iPlayToFrame)
			{
				SetTimer(0.1f, false, nameof(DelayedReplayToFrame));
			}
			else
			{
				OnCompleteReplayToFrame();
			}
		}
	}
	else
	{
		SetTimer(0.1f, false, nameof(DelayedReplayToFrame));
	}
}

simulated function UpdateCurrentFrameInfoBox(optional int Frame = -1)
{
	local string NewText;
	local int HistoryFrameIndex;

	if (m_kCurrentFrameInfoTitle != none)
	{
		if (Frame == -1)
		{
			HistoryFrameIndex = XComTacticalGRI(class'WorldInfo'.static.GetWorldInfo().GRI).ReplayMgr.CurrentHistoryFrame + 1;
		}
		else
		{
			HistoryFrameIndex = Frame;
		}

		NewText = "History Frame" @ HistoryFrameIndex @"/" @`XCOMHISTORY.GetNumGameStates();
			m_kCurrentFrameInfoTitle.SetText(NewText);

		NewText = `XCOMHISTORY.GetGameStateFromHistory(HistoryFrameIndex, eReturnType_Reference).GetContext().SummaryString();
		m_kCurrentFrameInfoText.SetText(NewText);
	}
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local bool bHandled;

	if ( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	bHandled = true;

	switch( cmd )
	{
		case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE:
			Movie.Pres.UIPauseMenu(, true);

		case class'UIUtilities_Input'.const.FXS_BUTTON_B:
		case class'UIUtilities_Input'.const.FXS_BUTTON_A:
		case class'UIUtilities_Input'.const.FXS_KEY_ENTER:
		case class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR:
			// Consume this if you are watching a regular replay, else let it through for the tutorial. 
			if( `REPLAY.bInTutorial )
				bHandled = false;
			break;

		case class'UIUtilities_Input'.const.FXS_BUTTON_Y :
			if (!`REPLAY.bInTutorial)
				OnPlayClicked();
			else
				bHandled = false;
			break;
		case class'UIUtilities_Input'.const.FXS_BUTTON_X :
			if (!`REPLAY.bInTutorial)
				OnFastForwardClicked();
			else
				bHandled = false;
			break;
		case class'UIUtilities_Input'.const.FXS_BUTTON_RBUMPER :
			if (!`REPLAY.bInTutorial)
				OnRestartClicked();
			else
				bHandled = false;
			break;

		default:
			bHandled = false;
			break;
	}

	if (bHandled)
		return true;

	return super.OnUnrealCommand(cmd, arg);
}

simulated function Show()
{
	if (!`REPLAY.bInTutorial)
	{
		super.Show();
	}
}

defaultproperties
{
	Package = "/ package/gfxXPACK_ReplayHUD/XPACK_ReplayHUD";
	MCName          = "theScreen";

	InputState    = eInputState_Evaluate;

	bShowFrameInfo = false;

	bHideOnLoseFocus = true;
	m_bPaused = true;
	m_playbackSpeed = 1;
}