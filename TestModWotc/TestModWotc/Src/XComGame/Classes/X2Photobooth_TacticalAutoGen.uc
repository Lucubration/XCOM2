//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    X2Photobooth_TacticalAutoGen.uc
//  AUTHOR:  Scott Boeckmann
//  PURPOSE: Generate a photo using photobooth without user input
//---------------------------------------------------------------------------------------
//  Copyright (c) 2009-2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class X2Photobooth_TacticalAutoGen extends X2Photobooth_AutoGenBase
	native(Core);

var X2Photobooth_TacticalLocationController m_kTacticalLocation;
var bool m_bStudioLoaded;

var bool bChallengeMode;

var delegate<OnPhotoTaken> m_kOnPhotoTaken;
delegate OnPhotoTaken();

function Init()
{
	super.Init();

	AutoGenSettings.CameraPOV.FOV = class'UITactical_Photobooth'.default.m_fCameraFOV;
	AutoGenSettings.CameraPresetDisplayName = "Full Frontal";
	AutoGenSettings.bChallengeMode = bChallengeMode;

	m_bStudioLoaded = false;

	m_kTacticalLocation = new class'X2Photobooth_TacticalLocationController';
	m_kTacticalLocation.Init(OnStudioLoaded);
}

function OnStudioLoaded()
{
	local int i, j;
	local array<XComGameState_Unit> arrSoldiers;

	BATTLE().GetHumanPlayer().GetOriginalUnits(arrSoldiers, true, true, true);

	j = 0;
	for (i = 0; i < arrSoldiers.Length && j < 6; i++) // Check that we are not adding more than 6 units as no formation holds more than 6.
	{
		if (arrSoldiers[i].UnitIsValidForPhotobooth())
		{
			AutoGenSettings.PossibleSoldiers.AddItem(arrSoldiers[i].GetReference());
			++j;
		}
	}

	AutoGenSettings.FormationLocation = m_kTacticalLocation.GetFormationPlacementActor();
	InitializeFormation();

	m_bStudioLoaded = true;
}

static function XGBattle_SP BATTLE()
{
	return XGBattle_SP(`BATTLE);
}

function Cleanup()
{
	m_kTacticalLocation.Cleanup();
	super.Cleanup();
}

function RequestPhoto(delegate<OnPhotoTaken> inOnPhotoTaken)
{
	super.RequestPhotos();

	m_kOnPhotoTaken = inOnPhotoTaken;

	`LEVEL.m_kBuildingVisManager.m_bForceDisableOfBuildingVis = true;

	TakePhoto();	
}

function PhotoTaken(StateObjectReference UnitRef)
{
	`LEVEL.m_kBuildingVisManager.m_bForceDisableOfBuildingVis = false;

	if (m_kOnPhotoTaken != none)
		m_kOnPhotoTaken();
}

function TakePhoto()
{
	if (m_bTakePhotoRequested == true && m_bStudioLoaded == true)
	{
		`PHOTOBOOTH.SetAutoGenSettings(AutoGenSettings, PhotoTaken);
	}
}

function InitializeFormation()
{
	local array<X2PropagandaPhotoTemplate> arrFormations;
	local array<int> arrFilteredFormationIndices;
	local int i, FormationIndex;

	FormationIndex = INDEX_NONE;
	`PHOTOBOOTH.GetFormations(arrFormations);

	if (AutoGenSettings.PossibleSoldiers.Length == 1)
	{
		for (i = 0; i < arrFormations.Length; ++i)
		{
			if (arrFormations[i].DataName == name("Solo"))
			{
				FormationIndex = i;
				break;
			}
		}
	}
	else if (AutoGenSettings.PossibleSoldiers.Length == 2)
	{
		for (i = 0; i < arrFormations.Length; ++i)
		{
			if (arrFormations[i].DataName == name("Duo"))
			{
				FormationIndex = i;
				break;
			}
		}
	}
	else
	{
		for (i = 0; i < arrFormations.Length; ++i)
		{
			if (arrFormations[i].DataName != name("Solo") && arrFormations[i].DataName != name("Duo"))
			{
				arrFilteredFormationIndices.AddItem(i);
			}
		}

		if (arrFilteredFormationIndices.Length > 0)
		{
			FormationIndex = arrFilteredFormationIndices[`SYNC_RAND(arrFilteredFormationIndices.Length)];
		}
	}

	FormationIndex = FormationIndex != INDEX_NONE ? FormationIndex : `SYNC_RAND(arrFormations.Length);
	AutoGenSettings.FormationTemplate = arrFormations[FormationIndex];
}

defaultproperties
{
	bDestroyPhotoboothPawnsOnCleanup = false
	bChallengeMode = false
}