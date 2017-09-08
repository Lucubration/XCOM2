//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    X2Photobooth_AutoGenBase.uc
//  AUTHOR:  Ken Derda
//  PURPOSE: Generate a photo using photobooth without user input
//---------------------------------------------------------------------------------------
//  Copyright (c) 2009-2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class X2Photobooth_AutoGenBase extends Actor
	native(Core);

var bool m_bTakePhotoRequested;

var PhotoboothAutoGenSettings AutoGenSettings;

struct native AutoGenPhotoInfo
{
	var Photobooth_TextLayoutState					TextLayoutState;
	var StateObjectReference						UnitRef;
	var array <delegate<OnAutoGenPhotoFinished> >	FinishedDelegates;

	// HeadShot specific members
	var int											SizeX;
	var int											SizeY;
	var float										CameraDistance;
	var name										AnimName;
};

var bool bDestroyPhotoboothPawnsOnCleanup;

delegate OnAutoGenPhotoFinished(StateObjectReference UnitRef);
cpptext
{
	virtual void TickSpecial(float DeltaTime);
}

function Init()
{
	local XComGameState_CampaignSettings SettingsState;

	`PHOTOBOOTH.HidePreview();

	SettingsState = XComGameState_CampaignSettings(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));
	AutoGenSettings.CampaignID = SettingsState.GameIndex;
	AutoGenSettings.bChallengeMode = false;

	AutoGenSettings.BackgroundDisplayName = class'UIPhotoboothBase'.default.m_strEmptyOption;
	AutoGenSettings.TextLayoutState = ePBTLS_Auto;

	m_bTakePhotoRequested = false;
}

function Cleanup()
{
	if (`PHOTOBOOTH.m_backgroundPoster != none)
	{
		`PRESBASE.GetPhotoboothMovie().RemoveScreen(`PHOTOBOOTH.m_backgroundPoster);
	}

	`PHOTOBOOTH.EndPhotobooth(bDestroyPhotoboothPawnsOnCleanup);
}

event Destroyed()
{
	// TODO: Delay destruction until any queued photos are done being taken.
	//		 Currently this will just intuerrupt the AutoGen and any queued photos will not be taken.
	Cleanup();
	super.Destroyed();
}

function RequestPhotos()
{
	m_bTakePhotoRequested = true;
}

function TakePhoto();

event RequestNextPhoto()
{
	if (`PHOTOBOOTH.CanTakeAutoPhoto(false))
	{
		TakePhoto();
	}
}

function PhotoTaken(StateObjectReference UnitRef);

function SetFormation(String InDisplayName)
{
	local array<X2PropagandaPhotoTemplate> arrFormations;
	local int i;

	`PHOTOBOOTH.GetFormations(arrFormations);
	for (i = 0; i < arrFormations.Length; ++i)
	{
		if (arrFormations[i].DataName == name(InDisplayName))
		{
			AutoGenSettings.FormationTemplate = arrFormations[i];
			`PHOTOBOOTH.ChangeFormation(AutoGenSettings.FormationTemplate);
			break;
		}
	}
}

function PhotoboothAutoGenSettings SetupAutoGen(AutoGenPhotoInfo request)
{
	return AutoGenSettings;
}

defaultproperties
{
	m_bTakePhotoRequested = false
	bDestroyPhotoboothPawnsOnCleanup = true
}