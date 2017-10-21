//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_HeadquartersProjectHealSpark.uc
//  AUTHOR:  Joe Weinhoffer  --  02/23/2016
//  PURPOSE: This object represents the instance data for an XCom HQ heal Spark project
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_HeadquartersProjectHealSpark extends XComGameState_HeadquartersProjectHealSoldier;

var bool bForcePaused;

//---------------------------------------------------------------------------------------
function int CalculateWorkPerHour(optional XComGameState StartState = none, optional bool bAssumeActive = false)
{
	local XComGameStateHistory History;
	local XComGameState_SparkManager SparkManager;
	local int iTotalWork;

	History = `XCOMHISTORY;
	SparkManager = XComGameState_SparkManager(History.GetSingleGameStateObjectForClass(class'XComGameState_SparkManager'));
	iTotalWork = max(SparkManager.SparkHealingRate, SparkManager.BaseSparkHealRate);

	// Can't make progress when paused
	if (bForcePaused && !bAssumeActive)
	{
		return 0;
	}

	return iTotalWork;
}

//---------------------------------------------------------------------------------------
function OnProjectCompleted()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit Unit;
	local XComGameState_StaffSlot StaffSlotState;
	local StaffUnitInfo UnitInfo;
	local int i;
	
	super.OnProjectCompleted();
	
	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom')); 
	Unit = XComGameState_Unit(History.GetGameStateForObjectID(ProjectFocus.ObjectID));

	// Remove the Spark from the staff slot	
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("SPARK Healing Project Completed");
	StaffSlotState = Unit.GetStaffSlot();
	if (StaffSlotState != none)
	{
		StaffSlotState.EmptySlot(NewGameState);
	}
	`GAMERULES.SubmitGameState(NewGameState);
	
	// Check for any other wounded SPARKs, and staff one automatically if found
	StaffSlotState = XComGameState_StaffSlot(History.GetGameStateForObjectID(StaffSlotState.ObjectID)); // Get the new emptied version of the slot
	for (i = 0; i < XComHQ.Crew.Length; i++)
	{
		Unit = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.Crew[i].ObjectID));
		if (Unit != None)
		{
			UnitInfo.UnitRef = Unit.GetReference();
			UnitInfo.bGhostUnit = false;
			UnitInfo.GhostLocation.ObjectID = 0;

			if (StaffSlotState.ValidUnitForSlot(UnitInfo))
			{
				StaffSlotState.FillSlot(UnitInfo);
				break;
			}
		}
	}
}

//---------------------------------------------------------------------------------------
DefaultProperties
{
}