///---------------------------------------------------------------------------------------
//  FILE:    SeqCond_IsMissionTimerSuspended.uc
//  AUTHOR:  Alex Cheng  --  9/8/2016
//  PURPOSE: Action to determine if the mission timer should be suspended.  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqCond_IsMissionTimerSuspended extends SequenceCondition;

event Activated()
{
	local XComGameState_UITimer UiTimer;
	UiTimer = XComGameState_UITimer(`XCOMHISTORY.GetSingleGameStateObjectForClass(class 'XComGameState_UITimer', true));
	if (UiTimer != none && UiTimer.IsSuspended())
	{
		OutputLinks[0].bHasImpulse = true;
	}
	else
	{
		OutputLinks[1].bHasImpulse = true;
	}
}

defaultproperties
{
	ObjCategory = "Gameplay"
	ObjName = "Is Mission Timer Suspended"

	InputLinks(0) = (LinkDesc = "In")
	OutputLinks(0) = (LinkDesc = "Yes")
	OutputLinks(1) = (LinkDesc = "No")

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
}