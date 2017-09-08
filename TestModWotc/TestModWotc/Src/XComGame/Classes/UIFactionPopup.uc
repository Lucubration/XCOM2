//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIFactionPopup.uc
//  AUTHOR:  Joe Weinhoffer -- 2/8/2017
//  PURPOSE: This file displays information about a Resistance Faction
//---------------------------------------------------------------------------------------
//  Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIFactionPopup extends UIScreen;

var StateObjectReference FactionRef;
var bool bInfluenceIncreased;

var localized string m_strFactionMetTitle;
var localized string m_strFactionInfluenceGainedTitle;
var localized string m_strFactionOrderSlotUnlocked;
var localized string m_strFactionOrderUnlocked;
var localized string m_strFactionCovertActionUnlocked;
var localized string m_strFactionMoreCovertActionUnlocked;

//----------------------------------------------------------------------------
// MEMBERS

simulated function OnInit()
{
	super.OnInit();

	if (`HQPRES.StrategyMap2D != none)
		`HQPRES.StrategyMap2D.Hide();

	BuildScreen();
}

simulated function BuildScreen()
{
	local XComGameState_ResistanceFaction FactionState;
	local string NewFactionOrders, NewCovertActions, LeaderQuote;
	local int RowIdx;

	FactionState = XComGameState_ResistanceFaction(`XCOMHISTORY.GetGameStateForObjectID(FactionRef.ObjectID));	
	NewFactionOrders = FactionState.GetNewStrategyCardsListString();
	NewCovertActions = FactionState.GetNowAvailableCovertActionListString();

	AS_SetHeaderData(bInfluenceIncreased ? m_strFactionInfluenceGainedTitle : m_strFactionMetTitle, Caps( FactionState.GetFactionTitle()), FactionState.GetFactionName(), /*FactionState.GetFactionIcon()*/"");
	RowIdx = 0;

	if (bInfluenceIncreased)
	{
		AS_SetUnlockRow(RowIdx, Caps(m_strFactionOrderSlotUnlocked), "");
		RowIdx++;
	}

	if (NewFactionOrders != "")
	{
		AS_SetUnlockRow(RowIdx, Caps(m_strFactionOrderUnlocked), NewFactionOrders);
		RowIdx++;
	}

	if (NewCovertActions != "")
	{
		AS_SetUnlockRow(RowIdx, Caps(bInfluenceIncreased ? m_strFactionMoreCovertActionUnlocked : m_strFactionCovertActionUnlocked), NewCovertActions);
		RowIdx++;
	}
	
	if (bInfluenceIncreased)
	{
		if (FactionState.GetInfluence() == eFactionInfluence_Respected)
			LeaderQuote = FactionState.GetInfluenceMediumQuote();
		else if (FactionState.GetInfluence() == eFactionInfluence_Influential)
			LeaderQuote = FactionState.GetInfluenceHighQuote();
	}
	else
	{
		LeaderQuote = FactionState.GetLeaderQuote();
	}

	AS_SetFactionIcon(FactionState.GetFactionIcon());

	AS_SetQuoteText(LeaderQuote);

	`HQPRES.m_kAvengerHUD.NavHelp.AddContinueButton(OnContinue);
	MC.FunctionVoid("AnimateIn");

	`XSTRATEGYSOUNDMGR.PlaySoundEvent(FactionState.GetFanfareEvent());

	TriggerFactionPopupEvents(FactionState);
}

function TriggerFactionPopupEvents(XComGameState_ResistanceFaction FactionState)
{
	local XComGameState NewGameState;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger Events: Faction Popup");
	if (!bInfluenceIncreased)
	{
		`XEVENTMGR.TriggerEvent(FactionState.GetMetEvent(), , , NewGameState);
	}
	else
	{
		if (FactionState.GetInfluence() == eFactionInfluence_Respected)
		{
			`XEVENTMGR.TriggerEvent(FactionState.GetInfluenceIncreasedMedEvent(), , , NewGameState);
		}
		else if (FactionState.GetInfluence() == eFactionInfluence_Influential)
		{
			`XEVENTMGR.TriggerEvent(FactionState.GetInfluenceIncreasedHighEvent(), , , NewGameState);
		}
	}
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

function AS_SetHeaderData(string Title, string FactionLabel, string FactionValue, string FactionLogo)
{
	MC.BeginFunctionOp("SetHeaderData");
	MC.QueueString(Title);
	MC.QueueString(FactionLabel);
	MC.QueueString(FactionValue);
	MC.QueueString(FactionLogo);
	MC.EndOp();
}

function AS_SetUnlockRow(int Index, string Title, string Value)
{
	MC.BeginFunctionOp("SetUnlockRow");
	MC.QueueNumber(Index);
	MC.QueueString(Title);
	MC.QueueString(Value);
	MC.EndOp();
}

function AS_SetQuoteText(string QuoteText)
{
	MC.BeginFunctionOp("SetQuoteText");
	MC.QueueString(QuoteText);
	MC.EndOp();
}

simulated function AS_SetFactionIcon(StackedUIIconData IconInfo)
{
	local int i;

	MC.BeginFunctionOp("SetFactionIcon");
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
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_ResistanceFaction FactionState;
	
	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	
	FactionState = XComGameState_ResistanceFaction(History.GetGameStateForObjectID(FactionRef.ObjectID));
	if (FactionState != None && FactionState.NewPlayableCards.Length > 0)
	{
		// If the Faction was met from a Covert Action, we need to display the rest of the rewards, so trigger those popups now
		// They get added to the stack first, so the Resistance Orders will be added on top of them
		`HQPRES.UIActionCompleteRewards();

		if (XComHQ.bHasSeenResistanceOrdersIntroPopup)
		{
			FactionState.DisplayNewStrategyCardPopups();
		}		
	}

	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
	CloseScreen();
}

//==============================================================================

defaultproperties
{
	Package = "/ package/gfxXPACK_FactionPopup/XPACK_FactionPopup";
	InputState = eInputState_Consume;
}