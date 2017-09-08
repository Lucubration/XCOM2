//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_SetGroupForUnit.uc
//  AUTHOR:  Dan Kaplan  --  7/26/2016
//  PURPOSE: Set a particular unit to be assigned to a particular AIGroup
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class SeqAct_SetGroupForUnit extends SequenceAction;

var XComGameState_AIGroup Group;
var XComGameState_Unit Unit;

event Activated()
{
	local XComGameState NewGameState;
	local XComGameState_AIGroup PreviousGroupState;

	if( Unit != none )
	{
		PreviousGroupState = Unit.GetGroupMembership();

		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Assign Unit to Group");

		if( PreviousGroupState != none )
			PreviousGroupState.RemoveUnitFromGroup(Unit.ObjectID, NewGameState);

		Group.AddUnitToGroup(Unit.ObjectID, NewGameState);

		`GAMERULES.SubmitGameState(NewGameState);
	}
	else
	{
		`redscreen("WARNING! Tried to Set Group for Unit without specifying a valid unit.");
	}
}

defaultproperties
{
	ObjCategory="Unit"
	ObjName="Set Group for Unit"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks(0)=(ExpectedType=class'SeqVar_GameGroup',LinkDesc="Group",PropertyName=Group)
	VariableLinks(1)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="Unit",PropertyName=Unit)
}
