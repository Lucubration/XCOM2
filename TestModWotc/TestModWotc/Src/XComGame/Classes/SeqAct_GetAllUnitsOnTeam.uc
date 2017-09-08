//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_GetAllUnitsOnTeam.uc
//  AUTHOR:  James Brawley
//  PURPOSE: Outputs all the units on a team to a Game State List.  Built to simplify the unit
//			 indexing all missions need to do, and also to resolve bugs with multi-part missions
//			 incorrectly indexing units that aren't on that leg of the mission.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class SeqAct_GetAllUnitsOnTeam extends SequenceAction;

var protected SeqVar_GameStateList FoundUnits; 

var() bool bExcludeCosmeticUnits;
var() bool bExcludeDeadUnits;
var() bool bExcludeTurrets;

event Activated()
{
	local StateObjectReference GameState;
	local XComGameState_Unit UnitToFilter;
	local bool bUnitsWereFound;

	local XGPlayer RequestedPlayer;
	local array<XComGameState_Unit> Units;

	// Get the correct player
	RequestedPlayer = GetRequestedPlayer();
	RequestedPlayer.GetUnits(Units);

	// Bind the internal list to the SeqVar plugged into the node
	foreach LinkedVariables(class'SeqVar_GameStateList', FoundUnits, "Game State List")
	{
		break;
	}

	// Walk through the units we found and filter valid units onto the SeqVar unit list
	foreach Units(UnitToFilter)
	{
		if(UnitToFilter!= none)
		{
			if(  !(UnitToFilter.GetMyTemplate().bIsCosmetic && bExcludeCosmeticUnits) && 
				 !UnitToFilter.bRemovedFromPlay &&
				 !(UnitToFilter.IsDead() && bExcludeDeadUnits) &&
				 !(UnitToFilter.GetMyTemplate().bIsTurret && bExcludeTurrets))
			{
				`Log("SeqAct_GetAllUnitsOnTeam: Found unit "@ UnitToFilter);
				GameState.ObjectID = UnitToFilter.ObjectID;
				FoundUnits.GameStates.AddItem(GameState);
				bUnitsWereFound=true;
			}
		}
	}

	if(!bUnitsWereFound)
	{
		`Redscreen("SeqAct_GetAllUnitsOnTeam: Could not find any units on the designated team.  Check for proper usage of this node.");		
	}
}

function protected XGPlayer GetRequestedPlayer()
{
	local XComTacticalGRI TacticalGRI;
	local XGBattle_SP Battle;
	local XGPlayer RequestedPlayer;

	TacticalGRI = `TACTICALGRI;
	Battle = (TacticalGRI != none)? XGBattle_SP(TacticalGRI.m_kBattle) : none;
	if(Battle != none)
	{
		if(InputLinks[0].bHasImpulse)
		{
			RequestedPlayer = Battle.GetHumanPlayer();
		}
		else if(InputLinks[1].bHasImpulse)
		{
			RequestedPlayer = Battle.GetAIPlayer();
		}
		else if(InputLinks[2].bHasImpulse)
		{
			RequestedPlayer = Battle.GetCivilianPlayer();
		}
		else if(InputLinks[3].bHasImpulse)
		{
			RequestedPlayer = Battle.GetTheLostPlayer();
		}
		else
		{
			RequestedPlayer = Battle.GetResistancePlayer();
		}
	}

	return RequestedPlayer;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjCategory="Unit"
	ObjName="Get All Units On Team"

	bExcludeCosmeticUnits=true
	bExcludeDeadUnits=true
	bExcludeTurrets=true

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	InputLinks.Empty;
	InputLinks(0)=(LinkDesc="XCom")
	InputLinks(1)=(LinkDesc="Alien")
	InputLinks(2)=(LinkDesc="Civilian")
	InputLinks(3)=(LinkDesc="TheLost")
	InputLinks(4)=(LinkDesc="Resistance")

	VariableLinks.Empty;
	VariableLinks(0)=(ExpectedType=class'SeqVar_GameStateList',LinkDesc="Game State List", bWriteable=true, MinVars=1, MaxVars=1)
}
