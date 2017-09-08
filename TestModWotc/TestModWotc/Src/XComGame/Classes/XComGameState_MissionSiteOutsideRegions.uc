//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_MissionSiteOutsideRegions.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_MissionSiteOutsideRegions extends XComGameState_MissionSite;

// This mission site requires the Avenger to be present because it exists outside of a region
function bool RequiresAvenger()
{
	return true;
}

function DestinationReached()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Skyranger SkyrangerState;

	History = `XCOMHISTORY;
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	SkyrangerState = XComGameState_Skyranger(History.GetGameStateForObjectID(XComHQ.SkyrangerRef.ObjectID));

	// If an airship just landed here, but the skyranger doesn't have the squad yet, the Avenger must have flown
	// Set XCOM HQ's location then skip straight to Squad Select to avoid infinite loops caused by the normal landing sequence
	if (!SkyrangerState.SquadOnBoard && RequiresSquad())
	{
		if (XComHQ.CurrentLocation.ObjectID != self.ObjectID)
		{
			// Update XComHQ's location to be this mission site
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("On Arrive at Alien Nest Mission Site");
			XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
			XComHQ.CurrentLocation = self.GetReference();
			`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
		}

		SelectSquad();
	}
	else
	{
		super.DestinationReached();
	}
}

protected function bool DisplaySelectionPrompt()
{
	MissionSelected();

	return true;
}