//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_PointOfInterestHunterWeapons.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_PointOfInterestHunterWeapons extends XComGameState_PointOfInterest;

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
	return StaticMesh'Materials_DLC2.3DUI.Skyranger_X1_POI';
}

//---------------------------------------------------------------------------------------
simulated public function POIAppearedPopup()
{
	local XComGameState NewGameState;
	local XComGameState_PointOfInterestHunterWeapons POIState;

	// If we are in the tutorial sequence, it will be revealed in the specific Blacksite objective
	if (class'XComGameState_HeadquartersXCom'.static.GetObjectiveStatus('T0_M10_IntroToBlacksite') != eObjectiveState_InProgress &&
	class'XComGameState_HeadquartersXCom'.static.GetObjectiveStatus('T2_M1_L0_LookAtBlacksite') != eObjectiveState_InProgress)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Toggle Hunter Weapon POI Appeared Popup");
		POIState = XComGameState_PointOfInterestHunterWeapons(NewGameState.ModifyStateObject(class'XComGameState_PointOfInterestHunterWeapons', self.ObjectID));
		POIState.bTriggerAppearedPopup = false;
		POIState.bNeedsAppearedPopup = false;
		`XEVENTMGR.TriggerEvent('HunterWeaponsRumorAppeared', , , NewGameState);
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

		class'X2Helpers_DLC_Day60'.static.ShowHunterWeaponsPOIPopup(GetReference());

		`GAME.GetGeoscape().Pause();
	}
}

//---------------------------------------------------------------------------------------
simulated public function POICompletePopup()
{
	local XComGameState NewGameState;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger POI Complete Event");
	`XEVENTMGR.TriggerEvent('HunterWeaponsRumorComplete', , , NewGameState);
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	
	// Update the base so the Hunter's Lodge will display the new weapons
	`GAME.GetGeoscape().m_kBase.UpdateFacilityProps();

	super.POICompletePopup();
}

simulated function TriggerPOICompletePopup()
{
	class'X2Helpers_DLC_Day60'.static.ShowHunterWeaponsPOICompletePopup(GetReference());
	class'X2Helpers_DLC_Day60'.static.ShowHunterWeaponsAvailablePopup();
}

simulated function string GetUIButtonIcon()
{
	return "img:///UILibrary_DLC2Images.MissionIcon_POI_Special2";
}

//#############################################################################################
DefaultProperties
{
}