//---------------------------------------------------------------------------------------
//  FILE:    SeqVar_GameStateList.uc
//  AUTHOR:  David Burchanowski  --  6/30/2016
//  PURPOSE: Returns true if a given set of units are in a game state list
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class SeqAct_IsInGameStateList extends SequenceAction;

// Determines whether or not we check for ALL or ANY objects linked to this action
var() bool bCheckForAllObjects;

event Activated()
{
	local SeqVar_GameStateList List;
	local SeqVar_GameUnit Unit;
	local SeqVar_InteractiveObject InteractiveObject;
	local bool FoundState;
	local bool HasAll;
	local bool HasOne;

 	HasAll = true;
	HasOne = false;
	foreach LinkedVariables(class'SeqVar_GameStateList', List, "Game State List")
	{
		foreach LinkedVariables(class'SeqVar_GameUnit', Unit, "Units")
		{
			FoundState = List.GameStates.Find('ObjectId', Unit.IntValue) != INDEX_NONE;
			HasAll = HasAll && FoundState;
			HasOne = HasOne || FoundState;
		}

		foreach LinkedVariables(class'SeqVar_InteractiveObject', InteractiveObject, "Interactive Objects")
		{
			FoundState = List.GameStates.Find('ObjectId', InteractiveObject.IntValue) != INDEX_NONE;
			HasAll = HasAll && FoundState;
			HasOne = HasOne || FoundState;
		}
	}

	HasOne = HasOne || HasAll; // handles the case where nothing was specified to search for

	OutputLinks[0].bHasImpulse = bCheckForAllObjects ? HasAll : HasOne;
	OutputLinks[1].bHasImpulse = !OutputLinks[0].bHasImpulse;
}

defaultproperties
{
    bCheckForAllObjects=true
	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	ObjName="Is In GameStateList"
	ObjCategory="Variable Lists"
	ObjColor=(R=255,G=0,B=255,A=255)

    // all of the inputs / functionality this Action can do
	InputLinks(0)=(LinkDesc="In")

    // outputs that are set to hot depending
	OutputLinks(0)=(LinkDesc="In List")
	OutputLinks(1)=(LinkDesc="Not in List")

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="Units")
	VariableLinks(1)=(ExpectedType=class'SeqVar_InteractiveObject',LinkDesc="Interactive Objects")
	VariableLinks(2)=(ExpectedType=class'SeqVar_GameStateList',LinkDesc="Game State List",bWriteable=true,MinVars=1,MaxVars=1)
}
