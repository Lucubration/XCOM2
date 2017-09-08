//---------------------------------------------------------------------------------------
//  FILE:    X2SitRepEffect_RankLimit.uc
//  AUTHOR:  David Burchanowski  --  8/22/2016
//  PURPOSE: Allows limiting soldiers of particular rank ranges to missions
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2SitRepEffect_RankLimit extends X2SitRepEffectTemplate;

// general sitrep configuration
var() int MinSoldierRank; // allows sitreps to force a minimum number of soldiers
var() int MaxSoldierRank; // allows sitreps to limit the number of slots that appear in the squad select screen

private function bool CheckRankRequirements(out string FailReason)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local StateObjectReference SquadRef;
	local XComGameState_Unit UnitState;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));
	if(XComHQ != none)
	{
		foreach XComHQ.Squad(SquadRef) // this array can have holes in it pre-mission, so we need to count
		{
			if(SquadRef.ObjectID > 0)
			{
				UnitState = XComGameState_Unit(History.GetGameStateForObjectID(SquadRef.ObjectID));
				if((MinSoldierRank >=0 && UnitState.GetSoldierRank() < MinSoldierRank)
					|| (MaxSoldierRank >= 0 && UnitState.GetSoldierRank() > MaxSoldierRank))
				{
					FailReason = Description;
					return false;
				}
			}
		}
	}

	return true;
}

// Override to allow the effect to modify whether or not the mission can be launched
function bool CanLaunchMission(XComGameState_MissionSite Mission, out string FailReason)
{
	return CheckRankRequirements(FailReason);
}

defaultproperties
{

}