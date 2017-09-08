//---------------------------------------------------------------------------------------
//  FILE:    SeqVar_GameStateList.uc
//  AUTHOR:  David Burchanowski  --  6/30/2016
//  PURPOSE: Modifies a list of game state objects in kismet
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class SeqAct_ModifyGameStateList extends SeqAct_SetSequenceVariable
	native;

var protected SeqVar_GameStateList List; 

event Activated()
{
	local StateObjectReference GameState;
	local SeqVar_GameUnit Unit;
	local SeqVar_InteractiveObject InteractiveObject;

	List = none;
	foreach LinkedVariables(class'SeqVar_GameStateList', List, "Game State List")
	{
		break;
	}

	if(List == none)
	{
		`Redscreen("No SeqVar_GameStateList attached to " $ string(name));
		return;
	}

	// if we want to empty, just empty
	if(InputLinks[2].bHasImpulse)
	{
		List.GameStates.Length = 0;
		return;
	}

	foreach LinkedVariables(class'SeqVar_GameUnit', Unit, "Unit")
	{
		GameState.ObjectID = Unit.IntValue;
		DoListOperation(GameState);
	}

	foreach LinkedVariables(class'SeqVar_InteractiveObject', InteractiveObject, "Interactive Object")
	{
		GameState.ObjectID = InteractiveObject.IntValue;
		DoListOperation(GameState);
	}
}

protected function DoListOperation(StateObjectReference GameState)
{
	if(InputLinks[0].bHasImpulse)
	{
		List.GameStates.AddItem(GameState);
	}
	else if(InputLinks[1].bHasImpulse)
	{
		List.GameStates.RemoveItem(GameState);
	}
}

defaultproperties
{
	ObjName="Modify GameStateList"
	ObjCategory="Variable Lists"
	ObjColor=(R=255,G=0,B=255,A=255)

	InputLinks(0)=(LinkDesc="Add To List")
	InputLinks(1)=(LinkDesc="Remove From List")
	InputLinks(2)=(LinkDesc="Empty List")

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="Unit")
	VariableLinks(1)=(ExpectedType=class'SeqVar_InteractiveObject',LinkDesc="Interactive Object")
	VariableLinks(2)=(ExpectedType=class'SeqVar_GameStateList',LinkDesc="Game State List",bWriteable=true,MinVars=1,MaxVars=1)
}