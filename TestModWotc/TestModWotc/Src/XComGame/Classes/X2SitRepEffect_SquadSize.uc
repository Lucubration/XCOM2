//---------------------------------------------------------------------------------------
//  FILE:    X2SitRepEffect_SquadSize.uc
//  AUTHOR:  David Burchanowski  --  8/22/2016
//  PURPOSE: Allows placement of squad limitations via sitreps
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2SitRepEffect_SquadSize extends X2SitRepEffectTemplate;

// general sitrep configuration
var() int MinSquadSize; // allows sitreps to force a minimum number of soldiers
var() int MaxSquadSize; // allows sitreps to limit the number of slots that appear in the squad select screen
var() int SquadSizeAdjustment; // allows sitreps to increase or decreate the size of the squad by a relative amount

private function bool CheckSquadSizeRequirements(out string FailReason)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local StateObjectReference SquadRef;
	local int SquadSize;

	if(MinSquadSize > 0)
	{
		History = `XCOMHISTORY;
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));
		if(XComHQ != none)
		{
			SquadSize = 0;
			foreach XComHQ.Squad(SquadRef) // this array can have holes in it pre-mission, so we need to count
			{
				if(SquadRef.ObjectID > 0)
				{
					SquadSize++;
				}
			}

			if(SquadSize < MinSquadSize)
			{
				FailReason = class'X2SitRepTemplateManager'.default.NotEnoughSoldiers;
				return false;
			}
		}
	}

	return true;
}

// Override to allow the effect to modify whether or not the mission can be launched
function bool CanLaunchMission(XComGameState_MissionSite Mission, out string FailReason)
{
	return CheckSquadSizeRequirements(FailReason);
}