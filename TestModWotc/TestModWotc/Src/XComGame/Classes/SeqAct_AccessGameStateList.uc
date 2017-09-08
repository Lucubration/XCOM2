//---------------------------------------------------------------------------------------
//  FILE:    SeqVar_GameStateList.uc
//  AUTHOR:  David Burchanowski  --  6/30/2016
//  PURPOSE: Accesses a list of game state objects in kismet
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class SeqAct_AccessGameStateList extends SeqAct_SetSequenceVariable;

var XComGameState_Unit Unit;
var XComGameState_InteractiveObject InteractiveObject;
var int Index;

event Activated()
{
	local XComGameStateHistory History;
	local SeqVar_GameStateList List;
	local XComGameState_BaseObject BaseObject;
	local int SelectedIndex;

	Unit = none;
	InteractiveObject = none;

	// get the attached list object
	foreach LinkedVariables(class'SeqVar_GameStateList', List, "Game State List")
	{
		// decide which index we want to use
		if(InputLinks[0].bHasImpulse)
		{
			SelectedIndex = Rand(List.GameStates.Length);
		}
		else if(InputLinks[1].bHasImpulse)
		{
			SelectedIndex = 0;
		}
		else if(InputLinks[2].bHasImpulse)
		{
			SelectedIndex = List.GameStates.Length - 1;
		}
		else
		{
			SelectedIndex = Index;
		}

		// grab the object (if any)
		if(SelectedIndex < List.GameStates.Length)
		{
			History = `XCOMHISTORY;
			BaseObject = History.GetGameStateForObjectID(List.GameStates[SelectedIndex].ObjectID);
			Unit = XComGameState_Unit(BaseObject);
			InteractiveObject = XComGameState_InteractiveObject(BaseObject);
		}

		break;
	}

	// activate outputs based on what kind of object we are returning
	OutputLinks[0].bHasImpulse = Unit != none;
	OutputLinks[1].bHasImpulse = InteractiveObject != none;
	OutputLinks[2].bHasImpulse = !OutputLinks[0].bHasImpulse && !OutputLinks[1].bHasImpulse;
}

defaultproperties
{
	ObjName="Access GameStateList"
	ObjCategory="Variable Lists"
	ObjColor=(R=255,G=0,B=255,A=255)

	InputLinks(0)=(LinkDesc="Random")
	InputLinks(1)=(LinkDesc="First")
	InputLinks(2)=(LinkDesc="Last")
	InputLinks(3)=(LinkDesc="At Index")

	OutputLinks(0)=(LinkDesc="Unit")
	OutputLinks(1)=(LinkDesc="InterativeObject")
	OutputLinks(2)=(LinkDesc="None")

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_GameStateList',LinkDesc="Game State List",bWriteable=false,MinVars=1,MaxVars=1)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Int',LinkDesc="Index",bWriteable=FALSE,PropertyName=Index)
	VariableLinks(2)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="Unit",bWriteable=true,PropertyName=Unit)
	VariableLinks(3)=(ExpectedType=class'SeqVar_InteractiveObject',LinkDesc="Interactive Object",bWriteable=true,PropertyName=InteractiveObject)
}