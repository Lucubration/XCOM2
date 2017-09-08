//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIPersonnel_SquadSelect
//  AUTHOR:  Sam Batista
//  PURPOSE: Provides custom behavior for personnel selection screen when
//           selecting soldiers to take on a mission.
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIPersonnel_SquadSelect extends UIPersonnel;

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	super.InitScreen(InitController, InitMovie, InitName);
}

simulated function UpdateList()
{
	local int i, MinRank, MaxRank;
	local XComGameState_Unit Unit;
	local GeneratedMissionData MissionData;
	local UIPersonnel_ListItem UnitItem;
	local bool bAllowWoundedSoldiers; // true if wounded soldiers are allowed to be deployed on this mission
	local XComGameStateHistory History;
	local XComGameState_MissionSite MissionState;
	local bool bHasRankLimits;
	
	super.UpdateList();
	
	History = `XCOMHISTORY;
	MissionData = HQState.GetGeneratedMissionData(HQState.MissionRef.ObjectID);
	bAllowWoundedSoldiers = MissionData.Mission.AllowDeployWoundedUnits;
	MissionState = XComGameState_MissionSite(History.GetGameStateForObjectID(HQState.MissionRef.ObjectID));
	bHasRankLimits = MissionState.HasRankLimits(MinRank, MaxRank);

	// loop through every soldier to make sure they're not already in the squad
	for(i = 0; i < m_kList.itemCount; ++i)
	{
		UnitItem = UIPersonnel_ListItem(m_kList.GetItem(i));
		Unit = XComGameState_Unit(History.GetGameStateForObjectID(UnitItem.UnitRef.ObjectID));

		if(HQState.IsUnitInSquad(UnitItem.UnitRef) || !Unit.CanGoOnMission(bAllowWoundedSoldiers) ||
			(bHasRankLimits && (Unit.GetRank() < MinRank || Unit.GetRank() > MaxRank)))
		{
			UnitItem.SetDisabled(true);
		}
	}
}

// Override sort function
simulated function SortPersonnel()
{
	SortCurrentData(SortSoldiers);
}

// show available units first
simulated function int SortSoldiers(StateObjectReference A, StateObjectReference B)
{
	if( !HQState.IsUnitInSquad(A) && HQState.IsUnitInSquad(B) )
		return 1;
	else if( HQState.IsUnitInSquad(A) && !HQState.IsUnitInSquad(B) )
		return -1;
	return 0;
}

defaultproperties
{
	m_eListType = eUIPersonnel_Soldiers;
	m_bRemoveWhenUnitSelected = true;
}