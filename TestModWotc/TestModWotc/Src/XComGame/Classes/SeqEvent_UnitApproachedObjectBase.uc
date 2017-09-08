//---------------------------------------------------------------------------------------
//  FILE:    SeqEvent_UnitApproachedObjectBase.uc
//  AUTHOR:  David Burchanowski  --  6/29/2016
//  PURPOSE: Base logic for the approach 
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
 
class SeqEvent_UnitApproachedObjectBase extends SeqEvent_X2GameState
	abstract
	native;

var protected XComGameState_Unit ApproachingUnit;
var() const private int TriggerDistanceTiles; // when the unit draws within this many tiles to another object, this event will fire
var() const private bool SkipVisibilityCheck; // Activate regardless of unit-to-object visibility; just check radius (for matching behavior of visible "rescue range")

protected native function GetCheckObjects(XComGameState_Unit MovedUnit, out array<XComGameState_BaseObject> CheckObjects);
protected event ActivateEvent(XComGameState_BaseObject Object);
protected native function EventListenerReturn OnUnitFinishedMove(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData);

function RegisterEvent()
{
	local Object ThisObj;

	ThisObj = self;

	`XEVENTMGR.RegisterForEvent( ThisObj, 'UnitMoveFinished', OnUnitFinishedMove, ELD_OnStateSubmitted );
}

defaultproperties
{
	TriggerDistanceTiles=3

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="ApproachingUnit",PropertyName=ApproachingUnit,bWriteable=TRUE)

	SkipVisibilityCheck=false
}