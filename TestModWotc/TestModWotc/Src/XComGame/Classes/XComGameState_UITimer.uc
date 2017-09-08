//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_UITimer.uc
//  AUTHOR:  Kirk Martinez --  08/19/2015
//  PURPOSE: Game State Object that represents the objective timer
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class XComGameState_UITimer extends XComGameState_BaseObject;

var int TimerValue;
var int UiState;
var bool ShouldShow;
var string  DisplayMsgTitle;
var string  DisplayMsgSubtitle;

var private int TimerSuspensionRefCount;
var int OldUiState; // UI state to restore after the suspension is over.
var bool IsTimer; // Identify timers that should count towards the RemainingTimers stat collection.

static function SuspendTimer(bool bResume, XComGameState NewGameState)
{
	local XComGameState_UITimer UiTimer;

	// On certain missions, where the Timer is repurposed for an alternate usage, this is a noop.
	if (`TACTICALMISSIONMGR.ActiveMission.DisallowUITimerSuspension)
	{
		return;
	}

	UiTimer = XComGameState_UITimer(`XCOMHISTORY.GetSingleGameStateObjectForClass(class 'XComGameState_UITimer', true));
	if (UiTimer == none)
	{
		// no need to resume timers that aren't currently suspended
		if (bResume)
		{
			`redscreen( "Attempting to resume UITimer with no active gamestate" );
			return;
		}

		// Create invisible timer as suspended, in case a timer is enabled while suspended.
		UiTimer = XComGameState_UITimer(NewGameState.CreateNewStateObject(class 'XComGameState_UITimer'));
	}
	else
	{
		// no need to resume timers that aren't currently suspended
		if (bResume && UiTimer.TimerSuspensionRefCount <= 0)
		{
			`redscreen( "Attempting to resume a non-suspended UITimer" );
			return;
		}

		UiTimer = XComGameState_UITimer(NewGameState.ModifyStateObject(class 'XComGameState_UITimer', UiTimer.ObjectID));
	}

	if (bResume)
	{
		if (UITimer.TimerSuspensionRefCount == 1)
		{
			UiTimer.UiState = UiTimer.OldUiState;
		}
		--UiTimer.TimerSuspensionRefCount;
	}
	else if (UITimer.TimerSuspensionRefCount == 0)
	{
		UiTimer.TimerSuspensionRefCount = 1;
		UiTimer.OldUiState = UiTimer.UiState;
		UiTimer.UiState = eUIState_Disabled;
	}
	else
	{
		++UiTimer.TimerSuspensionRefCount;
	}
}

function bool IsSuspended( )
{
	return TimerSuspensionRefCount > 0; 
}

//Defaults: ------------------------------------------------------------------------------
defaultproperties
{
	bTacticalTransient=true
	IsTimer=true;
}