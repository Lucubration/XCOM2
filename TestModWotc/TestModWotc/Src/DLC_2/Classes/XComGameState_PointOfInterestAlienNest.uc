//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_PointOfInterestAlienNest.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_PointOfInterestAlienNest extends XComGameState_PointOfInterest;

//#############################################################################################
//----------------   SPAWNING   ======---------------------------------------------------------
//#############################################################################################

function GiveRewards(XComGameState NewGameState)
{
	local XComGameState_Reward RewardState;
	local XComGameState_MissionSite MissionSite;
	local XComGameState_HeadquartersXCom XComHQ;
	local int idx;

	for (idx = 0; idx < RewardRefs.Length; idx++)
	{
		RewardState = XComGameState_Reward(`XCOMHISTORY.GetGameStateForObjectID(RewardRefs[idx].ObjectID));
		RewardState.GiveReward(NewGameState, ResistanceRegion);

		// This mission was just created in GiveReward, so look for it in the NewGameState
		MissionSite = XComGameState_MissionSite(NewGameState.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
		if (MissionSite != none) // Set any mission reward to appear at the same location as this POI
		{
			MissionSite.Region.ObjectID = 0; // This mission is not in a region
			MissionSite.Location = Location;

			foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
			{
				break;
			}
			
			if (XComHQ == none)
			{
				XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
				XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
			}

			// Set XComHQ's location as this mission. No need to reset region or continent since they will be the same as the POI.
			XComHQ.CurrentLocation.ObjectID = MissionSite.ObjectID;
			XComHQ.TargetEntity.ObjectID = MissionSite.ObjectID;
		}
	}
}

//#############################################################################################
//----------------   Geoscape Entity Implementation   -----------------------------------------
//#############################################################################################

function class<UIStrategyMapItem> GetUIClass()
{
	return class'UIStrategyMapItem_DLC_Day60';
}

// The static mesh for this entities 3D UI
function StaticMesh GetStaticMesh()
{
	return StaticMesh'Materials_DLC2.3DUI.ViperKingDen';
}

//---------------------------------------------------------------------------------------
simulated public function POIAppearedPopup()
{
	local XComGameState NewGameState;
	local XComGameState_PointOfInterestAlienNest POIState;

	// If we are in the tutorial sequence, it will be revealed in the specific Blacksite objective
	if (class'XComGameState_HeadquartersXCom'.static.GetObjectiveStatus('T0_M10_IntroToBlacksite') != eObjectiveState_InProgress &&
	class'XComGameState_HeadquartersXCom'.static.GetObjectiveStatus('T2_M1_L0_LookAtBlacksite') != eObjectiveState_InProgress)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Toggle Nest POI Appeared Popup");
		POIState = XComGameState_PointOfInterestAlienNest(NewGameState.ModifyStateObject(class'XComGameState_PointOfInterestAlienNest', self.ObjectID));
		POIState.bTriggerAppearedPopup = false;
		POIState.bNeedsAppearedPopup = false;
		`XEVENTMGR.TriggerEvent('NestRumorAppeared', , , NewGameState);
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
		
		class'X2Helpers_DLC_Day60'.static.ShowNestPOIPopup(GetReference());

		`GAME.GetGeoscape().Pause();
	}
}

//---------------------------------------------------------------------------------------
simulated public function POICompletePopup()
{
	local XComGameState NewGameState;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger POI Complete Event");
	`XEVENTMGR.TriggerEvent('NestRumorComplete', , , NewGameState);
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

	super.POICompletePopup();
}

simulated function TriggerPOICompletePopup()
{
	class'X2Helpers_DLC_Day60'.static.ShowNestPOICompletePopup(GetReference());
}

simulated function string GetUIButtonIcon()
{
	return "img:///UILibrary_DLC2Images.MissionIcon_POI_Special";
}

//#############################################################################################
DefaultProperties
{
}