//---------------------------------------------------------------------------------------
//  FILE:    SeqEvent_UnitApproachedObject.uc
//  AUTHOR:  David Burchanowski  --  6/29/2016
//  PURPOSE: Event for handling when a unit approaches an interactive object
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
 
class SeqEvent_UnitApproachedObject extends SeqEvent_UnitApproachedObjectBase
	native;

var private XComGameState_InteractiveObject ApproachedObject;
var() const private bool FireForNonDoorInteractiveObjects;
var() const private bool FireForDoors; // "doors" includes windows

protected native function GetCheckObjects(XComGameState_Unit MovedUnit, out array<XComGameState_BaseObject> CheckObjects);
protected event ActivateEvent(XComGameState_BaseObject Object)
{
	ApproachedObject = XComGameState_InteractiveObject(Object);
	if(ApproachedObject != none)
	{
		CheckActivate(ApproachingUnit.GetVisualizer(), none);
	}
}

defaultproperties
{
	ObjName="Unit Approached Object"
	TriggerDistanceTiles=3
	FireForNonDoorInteractiveObjects=true
	FireForDoors=false

	VariableLinks(1)=(ExpectedType=class'SeqVar_InteractiveObject',LinkDesc="ApproachedObject",PropertyName=ApproachedObject,bWriteable=TRUE)

	SkipVisibilityCheck=false
}