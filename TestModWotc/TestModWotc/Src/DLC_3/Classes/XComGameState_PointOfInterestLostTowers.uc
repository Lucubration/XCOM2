//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_PointOfInterestLostTowers.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_PointOfInterestLostTowers extends XComGameState_PointOfInterest;

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
	return class'UIStrategyMapItem_DLC_Day90';
}

// The static mesh for this entities 3D UI
function StaticMesh GetStaticMesh()
{
	return StaticMesh'Materials_DLC3.3DUI.ShenLastGift';
}

//---------------------------------------------------------------------------------------
simulated public function POIAppearedPopup()
{
	local XComGameState NewGameState;
	local XComGameState_PointOfInterestLostTowers POIState;

	// If we are in the tutorial sequence, it will be revealed in the specific Blacksite objective
	if (class'XComGameState_HeadquartersXCom'.static.GetObjectiveStatus('T0_M10_IntroToBlacksite') != eObjectiveState_InProgress &&
	class'XComGameState_HeadquartersXCom'.static.GetObjectiveStatus('T2_M1_L0_LookAtBlacksite') != eObjectiveState_InProgress)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Toggle Lost Towers POI Appeared Popup");
		POIState = XComGameState_PointOfInterestLostTowers(NewGameState.ModifyStateObject(class'XComGameState_PointOfInterestLostTowers', self.ObjectID));
		POIState.bTriggerAppearedPopup = false;
		POIState.bNeedsAppearedPopup = false;
		`XEVENTMGR.TriggerEvent('LostTowersRumorAppeared', , , NewGameState);
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
		
		class'X2Helpers_DLC_Day90'.static.ShowLostTowersPOIPopup(GetReference());

		`GAME.GetGeoscape().Pause();
	}
}

//---------------------------------------------------------------------------------------
simulated public function POICompletePopup()
{
	local XComGameState NewGameState;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger POI Complete Event");
	`XEVENTMGR.TriggerEvent('LostTowersRumorComplete', , , NewGameState);
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

	super.POICompletePopup();
}

simulated function TriggerPOICompletePopup()
{
	class'X2Helpers_DLC_Day90'.static.ShowLostTowersPOICompletePopup(GetReference());
}

simulated function string GetUIButtonIcon()
{
	return "img:///UILibrary_DLC3Images.MissionIcon_POI_Special2";
}

//#############################################################################################
DefaultProperties
{
}