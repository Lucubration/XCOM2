//---------------------------------------------------------------------------------------
//  FILE:    SeqEvent_UnitApproachedUnit.uc
//  AUTHOR:  David Burchanowski  --  10/29/2014
//  PURPOSE: Event for handling when a unit approaches another unit
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
 
class SeqEvent_UnitApproachedUnit extends SeqEvent_UnitApproachedObjectBase
	native;

var private XComGameState_Unit ApproachedUnit;
var() private bool RequiresCivilianTarget; // Only activate from civilian targets.
var() private bool RequiresNonAlienTarget; // Only activates to non-alien targets. (If checked, skips faceless civilians)

protected native function GetCheckObjects(XComGameState_Unit MovedUnit, out array<XComGameState_BaseObject> CheckObjects);
protected event ActivateEvent(XComGameState_BaseObject Object)
{
	ApproachedUnit = XComGameState_Unit(Object);
	if(ApproachedUnit != none)
	{
		CheckActivate(ApproachingUnit.GetVisualizer(), none);
	}
}

defaultproperties
{
	ObjName="Unit Approached Unit"
	TriggerDistanceTiles=3

	VariableLinks(1)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="ApproachedUnit",PropertyName=ApproachedUnit,bWriteable=TRUE)

	SkipVisibilityCheck=false
}

