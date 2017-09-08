//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_HeadquartersProjectRemoveTraits.uc
//  AUTHOR:  Joe Weinhoffer  --  06/05/2015
//  PURPOSE: This object represents the instance data for an XCom HQ remove negative traits project
//           Will eventually be a component
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_HeadquartersProjectRemoveTraits extends XComGameState_HeadquartersProject native(Core);

var localized string ProjectCompleteSubTitle;

//---------------------------------------------------------------------------------------
// Call when you start a new project, NewGameState should be none if not coming from tactical
function SetProjectFocus(StateObjectReference FocusRef, optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	local XComGameStateHistory History;
	local XComGameState_GameTime TimeState;
	local XComGameState_Unit UnitState;

	History = `XCOMHISTORY;
	ProjectFocus = FocusRef; // Unit
	AuxilaryReference = AuxRef; // Facility

	UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ProjectFocus.ObjectID));
	UnitState.SetStatus(eStatus_Training);

	ProjectPointsRemaining = CalculatePointsToRemoveTraits();
	InitialProjectPoints = ProjectPointsRemaining;

	UpdateWorkPerHour(NewGameState);
	TimeState = XComGameState_GameTime(History.GetSingleGameStateObjectForClass(class'XComGameState_GameTime'));
	StartDateTime = TimeState.CurrentTime;

	if (`STRATEGYRULES != none)
	{
		if (class'X2StrategyGameRulesetDataStructures'.static.LessThan(TimeState.CurrentTime, `STRATEGYRULES.GameTime))
		{
			StartDateTime = `STRATEGYRULES.GameTime;
		}
	}

	if (MakingProgress())
	{
		SetProjectedCompletionDateTime(StartDateTime);
	}
	else
	{
		// Set completion time to unreachable future
		CompletionDateTime.m_iYear = 9999;
	}
}

//---------------------------------------------------------------------------------------
function int CalculatePointsToRemoveTraits()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit UnitState;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(ProjectFocus.ObjectID));
	return XComHQ.GetRemoveTraitDays() * UnitState.NegativeTraits.Length * 24;
}

//---------------------------------------------------------------------------------------
function int CalculateWorkPerHour(optional XComGameState StartState = none, optional bool bAssumeActive = false)
{
	return 1;
}

//---------------------------------------------------------------------------------------
// Remove the project
function OnProjectCompleted()
{
	local HeadquartersOrderInputContext OrderInput;
	local XComGameState_Unit UnitState;

	OrderInput.OrderType = eHeadquartersOrderType_RemoveTraitsCompleted;
	OrderInput.AcquireObjectReference = self.GetReference();

	class'XComGameStateContext_HeadquartersOrder'.static.IssueHeadquartersOrder(OrderInput);
	
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ProjectFocus.ObjectID));
	`HQPRES.NotifyBanner(ProjectCompleteNotification, class'UIUtilities_Image'.const.EventQueue_Staff, ProjectCompleteSubTitle, UnitState.GetName(eNameType_RankFull), eUIState_Good);

}

//---------------------------------------------------------------------------------------
DefaultProperties
{
}
