//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_GetAllUnitsInEncounter.uc
//  AUTHOR:  James Brawley
//  PURPOSE: Outputs all the units in a designated encounter to a Game State List
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class SeqAct_GetAllUnitsInEncounter extends SequenceAction;

var String EncounterIDString;
var string PrePlacedEncounterTag;
var protected SeqVar_GameStateList FoundUnits; 

event Activated()
{
	local XComGameStateHistory History;
	local XComGameState_AIGroup GroupState;
	local name PrePlacedEncounterTagName;
	local int i;
	local StateObjectReference GameState;
	local XComGameState_Unit Unit;
	local bool bFoundEncounter;
	local Name EncounterID;

	History = `XCOMHISTORY;

	// Bind the internal list to the SeqVar plugged into the node
	foreach LinkedVariables(class'SeqVar_GameStateList', FoundUnits, "Game State List")
	{
		break;
	}

	// Check for a specified EncounterID
	if(EncounterIDString != "")
	{
		EncounterID = name(EncounterIDString);
	}

	// Check for a Preplaced Encounter Tag
	PrePlacedEncounterTagName = name(PrePlacedEncounterTag);

	// Search for an encounter group with a matching identity
	foreach History.IterateByClassType(class'XComGameState_AIGroup', GroupState)
	{

		// Find the designated encounter group
		if ((EncounterID != '' && GroupState.EncounterID == EncounterID)
			|| (PrePlacedEncounterTagName != '' && GroupState.PrePlacedEncounterTag == PrePlacedEncounterTagName))
		{
			bFoundEncounter = true;

			// Index the units in the group into the Found Units list
			for (i = 0; i < GroupState.m_arrMembers.Length; ++i)
			{
				Unit = XComGameState_Unit(History.GetGameStateForObjectID(GroupState.m_arrMembers[i].ObjectID));
				if (Unit != none)
				{
					`Log("SeqAct_GetAllUnitsInEncounter: Found unit "@ Unit);
					GameState.ObjectID = Unit.ObjectID;
					FoundUnits.GameStates.AddItem(GameState);
				}
				else
				{
					`Redscreen("SeqAct_GetAllUnitsInEncounter: Could not find unit state for object ID " $ GroupState.m_arrMembers[i].ObjectID);
				}
			}
		}

	}

	if(!bFoundEncounter)
	{
		`Redscreen("SeqAct_GetAllUnitsInEncounter: Could not find specified AI encounter. Provide save to JBrawley.\nEncounterIDString: " $ EncounterIDString $ 
						"\nPrePlacedEncounterTag: " $ PrePlacedEncounterTag);		
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 0;
}

defaultproperties
{
	ObjCategory="Unit"
	ObjName="Get All Units In Encounter"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks(0)=(ExpectedType=class'SeqVar_String',LinkDesc="EncounterID",PropertyName=EncounterIDString)
	VariableLinks(1)=(ExpectedType=class'SeqVar_String',LinkDesc="PreplacedEncounterTag",PropertyName=PrePlacedEncounterTag)
	VariableLinks(2)=(ExpectedType=class'SeqVar_GameStateList',LinkDesc="Game State List", bWriteable=true, MinVars=1, MaxVars=1)
}
