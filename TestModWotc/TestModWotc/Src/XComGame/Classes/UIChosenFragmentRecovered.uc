//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIChosenFragmentRecovered.uc
//  AUTHOR:  Joe Weinhoffer -- 2/8/2017
//  PURPOSE: This file displays information about a recovered Chosen Fragment
//---------------------------------------------------------------------------------------
//  Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIChosenFragmentRecovered extends UIScreen;

var StateObjectReference ChosenRef;
var int FragmentLevel; 

var localized string m_strFragmentReceivedTitle;
var localized string m_strFragmentReceivedNextSteps;
var localized string m_strFinalFragmentReceived;
var localized string m_strFactionInfluenceIncreased;
var localized string m_strFragmentReceivedButton;

//----------------------------------------------------------------------------
// MEMBERS

simulated function OnInit()
{
	super.OnInit();

	`HQPRES.StrategyMap2D.Hide();
	BuildScreen();
}

simulated function BuildScreen()
{
	local XComGameState NewGameState;
	local XComGameState_AdventChosen ChosenState;
	local XComGameState_ResistanceFaction FactionState;
	local XGParamTag ParamTag;
	local name FragmentEvent;
	local string ChosenImage;

	ChosenState = XComGameState_AdventChosen(`XCOMHISTORY.GetGameStateForObjectID(ChosenRef.ObjectID));
	FactionState = ChosenState.GetRivalFaction();
	
	if( FragmentLevel == -1 )
		FragmentLevel = int(ChosenState.GetRivalFaction().GetInfluence());

	if (ChosenState.IsStrongholdMissionAvailable())
	{
		// We don't have a 3rd influence level for Factions, so check the stronghold mission to determine if the final Hunt Chosen Covert Action has been completed
		FragmentLevel = 3;
	}

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = ChosenState.GetChosenName();
	ParamTag.StrValue1 = FactionState.GetFactionTitle();
	ParamTag.StrValue2 = FactionState.GetInfluenceString();

	ChosenImage = ChosenState.GetChosenPortraitImage() $ "_sm";
	
	AS_SetChosenIcon(ChosenState.GetChosenIcon());

	AS_UpdateData(Caps(`XEXPAND.ExpandString(m_strFragmentReceivedTitle)),
		ChosenImage,//need to send the small image with alpha
		/*ChosenState.GetChosenIcon()*/ "",
		string(ChosenState.Level),
		ChosenState.GetChosenClassName(),
		ChosenState.GetChosenName(),
		ChosenState.GetChosenNickname(),
		FragmentLevel,
		FragmentLevel < 3 ? `XEXPAND.ExpandString(m_strFragmentReceivedNextSteps) : `XEXPAND.ExpandString(m_strFinalFragmentReceived),
		FragmentLevel < 3 ? `XEXPAND.ExpandString(m_strFactionInfluenceIncreased) : "",
		m_strFragmentReceivedButton);

	`HQPRES.m_kAvengerHUD.NavHelp.AddContinueButton(OnContinue);

	`XSTRATEGYSOUNDMGR.PlaySoundEvent(ChosenState.GetRivalFaction().GetFanfareEvent());

	if (class'X2StrategyGameRulesetDataStructures'.static.Roll(50))
	{
		FragmentEvent = 'ChosenFragmentRecovered';
	}
	else
	{
		FragmentEvent = FactionState.GetChosenFragmentEvent();
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger Event: Fragment Recovered");
	`XEVENTMGR.TriggerEvent(FragmentEvent, , , NewGameState);
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

simulated function PlayFragmentSound(string arg)
{
	`XSTRATEGYSOUNDMGR.PlayPersistentSoundEvent(arg);
}

function AS_UpdateData(string Title, string ChosenImage, string ChosenIcon, string ChosenLevel, string ChosenType,
	string ChosenName, string ChosenNickname, int numFragments, string Desc1, string Desc2, string ButtonLabel)
{
	MC.BeginFunctionOp("UpdateData");
	MC.QueueString(Title);
	MC.QueueString(ChosenImage);
	MC.QueueString(ChosenIcon);
	MC.QueueString(ChosenLevel);
	MC.QueueString(ChosenType);
	MC.QueueString(ChosenName);
	MC.QueueString(ChosenNickname);
	MC.QueueNumber(numFragments);
	MC.QueueString(Desc1);
	MC.QueueString(Desc2);
	MC.QueueString(ButtonLabel);
	MC.EndOp();
}

function AS_SetChosenIcon(StackedUIIconData IconInfo)
{
	local int i;

	MC.BeginFunctionOp("SetChosenIcon");
	MC.QueueBoolean(IconInfo.bInvert);
	for (i = 0; i < IconInfo.Images.Length; i++)
	{
		MC.QueueString("img:///" $ IconInfo.Images[i]);
	}

	MC.EndOp();
}

//-----------------------------------------------------------------------

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local bool bHandled;

	if (!CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
		return false;

	bHandled = true;

	switch (cmd)
	{
	case class'UIUtilities_Input'.const.FXS_BUTTON_B :
	case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE :
	case class'UIUtilities_Input'.const.FXS_R_MOUSE_DOWN :

	case class'UIUtilities_Input'.const.FXS_BUTTON_A :
	case class'UIUtilities_Input'.const.FXS_KEY_ENTER :
	case class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR :

		OnContinue();
		break;

	default:
		bHandled = false;
		break;
	}

	return bHandled || super.OnUnrealCommand(cmd, arg);
}

simulated public function OnContinue()
{
	local XComGameStateHistory History;
	local XComGameState_AdventChosen ChosenState;
	local XComGameState_MissionSite MissionState;

	History = `XCOMHISTORY;
	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
	CloseScreen();

	ChosenState = XComGameState_AdventChosen(History.GetGameStateForObjectID(ChosenRef.ObjectID));
	
	// If the stronghold mission is available, display its mission popups
	if (ChosenState.IsStrongholdMissionAvailable())
	{
		MissionState = XComGameState_MissionSite(History.GetGameStateForObjectID(ChosenState.StrongholdMission.ObjectID));
		`HQPRES.UIChosenStrongholdMission(MissionState);
	}
	else // Otherwise influence with the Faction increased as part of the Fragment, display that popup sequence next
	{
		`HQPRES.UIFactionPopup(ChosenState.GetRivalFaction(), true);
	}
}
simulated function OnCommand(string cmd, string arg)
{
	switch (cmd)
	{
	case "PlayFragmentSound": PlayFragmentSound(arg);
		break;
	}
}

//==============================================================================

defaultproperties
{
	Package = "/ package/gfxXPACK_FragmentRecovered/XPACK_FragmentRecovered";
	InputState = eInputState_Consume;
	FragmentLevel = -1; 
}