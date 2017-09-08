//---------------------------------------------------------------------------------------
//  FILE:    UIFacility_TrainingCenter.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class UIFacility_TrainingCenter extends UIFacility;

var public localized string m_strTrainAbilities;

//----------------------------------------------------------------------------
// MEMBERS

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_FacilityXCom Facility;

	super.InitScreen(InitController, InitMovie, InitName);

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();

	if (!XComHQ.bHasSeenTrainingCenterIntroPopup)
	{
		Facility = XComGameState_FacilityXCom(`XCOMHISTORY.GetGameStateForObjectID(FacilityRef.ObjectID));
		`HQPRES.UITrainingCenterIntro(Facility.GetMyTemplate());
	}
}

simulated function CreateFacilityButtons()
{
	AddFacilityButton(m_strTrainAbilities, OnTrainAbilities);
}

simulated function OnTrainAbilities()
{
	`SOUNDMGR.PlaySoundEvent("Play_MenuOpenSmall");
	`HQPRES.UIPersonnel_TrainingCenter(OnPersonnelRefSelected);
}

function OnPersonnelRefSelected(StateObjectReference _UnitRef)
{
	`HQPRES.ShowPromotionUI(_UnitRef);
}

simulated function OnRemoved()
{
	super.OnRemoved();
}

defaultproperties
{
	bHideOnLoseFocus = false;
}