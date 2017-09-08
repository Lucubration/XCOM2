//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_GetGroupForUnit.uc
//  AUTHOR:  Dan Kaplan  --  7/26/2016
//  PURPOSE: Get the AIGroup associated with a particular unit
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class SeqAct_GetGroupForUnit extends SequenceAction;

var XComGameState_AIGroup Group;
var XComGameState_Unit Unit;

event Activated()
{
	Group = Unit.GetGroupMembership();
}

defaultproperties
{
	ObjCategory="Unit"
	ObjName="Get Group for Unit"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks(0)=(ExpectedType=class'SeqVar_GameGroup',LinkDesc="Group",PropertyName=Group, bWriteable=true)
	VariableLinks(1)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="Unit",PropertyName=Unit)
}
