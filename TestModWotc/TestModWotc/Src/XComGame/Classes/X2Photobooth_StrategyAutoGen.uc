//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    X2Photobooth_StrategyAutoGen.uc
//  AUTHOR:  Ken Derda
//  PURPOSE: Generate a photo using photobooth without user input
//---------------------------------------------------------------------------------------
//  Copyright (c) 2009-2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class X2Photobooth_StrategyAutoGen extends X2Photobooth_AutoGenBase
	native(Core)
	config(GameCore);

var StateObjectReference ChosenRef;

struct native UnitToCameraDistance
{
	var name UnitTemplateName;
	var float CameraDistance;
};

var config array<UnitToCameraDistance> arrUnitToCameraDistances;
var config float DefaultCameraDistance;

var array<AutoGenPhotoInfo> arrAutoGenRequests;
var AutoGenPhotoInfo ExecutingAutoGenRequest;


function Init()
{
	super.Init();

	AutoGenSettings.FormationLocation = GetFormationPlacementActor();
	AutoGenSettings.CameraPOV.FOV = class'UIArmory_Photobooth'.default.m_fCameraFOV;
}

function PointInSpace GetFormationPlacementActor()
{
	local PointInSpace PlacementActor;

	foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'PointInSpace', PlacementActor)
	{
		if ('BlueprintLocation' == PlacementActor.Tag)
			return PlacementActor;
	}

	return none;
}

function AddDeadSoldier(StateObjectReference UnitRef, optional delegate<OnAutoGenPhotoFinished> Callback)
{
	AddNewRequest(UnitRef, ePBTLS_DeadSoldier, Callback);
}

function AddPromotedSoldier(StateObjectReference UnitRef, optional delegate<OnAutoGenPhotoFinished> Callback)
{
	AddNewRequest(UnitRef, ePBTLS_PromotedSoldier, Callback);
}

function AddBondedSoldier(StateObjectReference UnitRef, optional delegate<OnAutoGenPhotoFinished> Callback)
{
	AddNewRequest(UnitRef, ePBTLS_BondedSoldier, Callback);
}

function AddCapturedSoldier(StateObjectReference UnitRef, optional delegate<OnAutoGenPhotoFinished> Callback)
{
	AddNewRequest(UnitRef, ePBTLS_CapturedSoldier, Callback);
}

function AddNewRequest(StateObjectReference UnitRef, Photobooth_TextLayoutState TextLayoutState, optional delegate<OnAutoGenPhotoFinished> Callback)
{
	local AutoGenPhotoInfo LocAutoGenInfo;

	LocAutoGenInfo.TextLayoutState = TextLayoutState;
	LocAutoGenInfo.UnitRef = UnitRef;
	if (Callback != none)
	{
		LocAutoGenInfo.FinishedDelegates.AddItem(Callback);
	}

	arrAutoGenRequests.AddItem(LocAutoGenInfo);
}

function CancelRequest(StateObjectReference UnitRef, Photobooth_TextLayoutState TextLayoutState)
{
	local int Index;
	local XComGameState_Unit Unit;
	local SoldierBond BondData;
	local StateObjectReference BondmateRef;

	switch (TextLayoutState)
	{
	case ePBTLS_DeadSoldier:
	case ePBTLS_PromotedSoldier:
	case ePBTLS_CapturedSoldier:
		for (Index = 0; Index < arrAutoGenRequests.Length; ++Index)
		{
			if (UnitRef.ObjectID == arrAutoGenRequests[Index].UnitRef.ObjectID &&
				TextLayoutState == arrAutoGenRequests[Index].TextLayoutState)
			{
				arrAutoGenRequests.Remove(Index, 1);
				break;
			}
		}
		break;
	case ePBTLS_BondedSoldier:
		Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));
		if (Unit.HasSoldierBond(BondmateRef, BondData))
		{
			for (Index = 0; Index < arrAutoGenRequests.Length; ++Index)
			{
				if ((UnitRef.ObjectID == arrAutoGenRequests[Index].UnitRef.ObjectID || BondmateRef.ObjectID == arrAutoGenRequests[Index].UnitRef.ObjectID) &&
					TextLayoutState == arrAutoGenRequests[Index].TextLayoutState)
				{
					arrAutoGenRequests.Remove(Index, 1);
					break;
				}
			}
		}
		break;
	}
}

// bFlushPendingRequests parameter is not implemented. The XComPhotographer_Strategy system that this replaces implemented it, but nothing that called into that system ever utilized it.
function AddHeadShotRequest(StateObjectReference UnitRef, int SizeX, int SizeY, delegate<OnAutoGenPhotoFinished> Callback, optional X2SoldierPersonalityTemplate Personality, optional bool bFlushPendingRequests = false, optional bool bHighPriority = false)
{
	local int i;
	local AutoGenPhotoInfo LocAutoGenInfo;
	local XComGameState_Unit Unit;
	local UnitToCameraDistance LocUnitToCameraDist;

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));
	if (`XENGINE.m_kPhotoManager.HeadshotExistsAndIsCurrent(AutoGenSettings.CampaignID, UnitRef.ObjectID, Unit))
	{
		if (Callback != none)
		{
			Callback(UnitRef);
		}

		return;
	}

	// Check for existing request
	for (i = 0; i < arrAutoGenRequests.Length; ++i)
	{
		if (arrAutoGenRequests[i].UnitRef.ObjectID == UnitRef.ObjectID && arrAutoGenRequests[i].TextLayoutState == ePBTLS_HeadShot)
		{
			if (Callback != none)
			{
				arrAutoGenRequests[i].FinishedDelegates.AddItem(Callback);
			}

			if (bHighPriority && i != 0)
			{
				LocAutoGenInfo = arrAutoGenRequests[i];
				arrAutoGenRequests.Remove(i, 1);
				arrAutoGenRequests.InsertItem(0, LocAutoGenInfo);
			}

			return;
		}
	}

	// Add new request
	LocAutoGenInfo.TextLayoutState = ePBTLS_HeadShot;
	LocAutoGenInfo.UnitRef = UnitRef;
	LocAutoGenInfo.SizeX = 512;
	LocAutoGenInfo.SizeY = 512;

	LocAutoGenInfo.CameraDistance = DefaultCameraDistance;
	foreach arrUnitToCameraDistances(LocUnitToCameraDist)
	{
		if (LocUnitToCameraDist.UnitTemplateName == Unit.GetMyTemplateName())
		{
			LocAutoGenInfo.CameraDistance = LocUnitToCameraDist.CameraDistance;
			break;
		}
	}

	if (Callback != none)
	{
		LocAutoGenInfo.FinishedDelegates.AddItem(Callback);
	}

	if (Personality == none)
	{
		Personality = Unit.GetPhotoboothPersonalityTemplate();
	}
	LocAutoGenInfo.AnimName = Personality.IdleAnimName;

	if (bHighPriority)
	{
		arrAutoGenRequests.InsertItem(0, LocAutoGenInfo);
	}
	else
	{
		arrAutoGenRequests.AddItem(LocAutoGenInfo);
	}
}

function PhotoboothDefaultSettings SetupDefault(AutoGenPhotoInfo request)
{
	local XComGameState_Unit Unit;
	local SoldierBond BondData;
	local StateObjectReference BondmateRef;
	local PhotoboothDefaultSettings GenSettings;
	local array<X2PropagandaPhotoTemplate> arrFormations;
	local int i, DuoAnimIndex;

	GenSettings.PossibleSoldiers.Length = 0;
	GenSettings.PossibleSoldiers.AddItem(request.UnitRef);
	if (request.TextLayoutState == ePBTLS_BondedSoldier)
	{
		Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(request.UnitRef.ObjectID));

		DuoAnimIndex = `SYNC_RAND(`PHOTOBOOTH.DuoPose1Indices.length);
		GenSettings.SoldierAnimIndex.AddItem(DuoAnimIndex);

		if (Unit.HasSoldierBond(BondmateRef, BondData))
		{
			GenSettings.PossibleSoldiers.AddItem(BondmateRef);
			GenSettings.SoldierAnimIndex.AddItem(DuoAnimIndex);
		}
	}

	GenSettings.TextLayoutState = request.TextLayoutState;

	GenSettings.CameraPresetDisplayName = "Full Frontal";
	GenSettings.BackgroundDisplayName = class'UIPhotoboothBase'.default.m_strEmptyOption;

	`PHOTOBOOTH.GetFormations(arrFormations);
	for (i = 0; i < arrFormations.Length; ++i)
	{
		if (request.TextLayoutState == ePBTLS_BondedSoldier)
		{
			if (arrFormations[i].DataName == 'Duo')
			{
				GenSettings.FormationTemplate = arrFormations[i];
				break;
			}
		}
		else
		{
			if (arrFormations[i].DataName == 'Solo')
			{
				GenSettings.FormationTemplate = arrFormations[i];
				break;
			}
		}
	}

	return GenSettings;
}

function TakePhoto()
{
	local XComGameState_Unit Unit;
	local XComGameState_AdventChosen ChosenState;
	local SoldierBond BondData;
	local StateObjectReference BondmateRef;

	// Set things up for the next photo and queue it up to the photobooth.
	if (arrAutoGenRequests.Length > 0)
	{
		ExecutingAutoGenRequest = arrAutoGenRequests[0];

		AutoGenSettings.PossibleSoldiers.Length = 0;
		AutoGenSettings.PossibleSoldiers.AddItem(ExecutingAutoGenRequest.UnitRef);
		AutoGenSettings.TextLayoutState = ExecutingAutoGenRequest.TextLayoutState;
		AutoGenSettings.HeadShotAnimName = '';
		AutoGenSettings.CameraPOV.FOV = class'UIArmory_Photobooth'.default.m_fCameraFOV;
		AutoGenSettings.BackgroundDisplayName = class'UIPhotoboothBase'.default.m_strEmptyOption;
		SetFormation("Solo");

		switch (ExecutingAutoGenRequest.TextLayoutState)
		{
		case ePBTLS_DeadSoldier:
			AutoGenSettings.CameraPresetDisplayName = "Full Frontal";
			break;
		case ePBTLS_PromotedSoldier:
			AutoGenSettings.CameraPresetDisplayName = "Full Frontal";
			break;
		case ePBTLS_BondedSoldier:
			Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ExecutingAutoGenRequest.UnitRef.ObjectID));

			if (Unit.HasSoldierBond(BondmateRef, BondData))
			{
				AutoGenSettings.PossibleSoldiers.AddItem(BondmateRef);
				AutoGenSettings.CameraPresetDisplayName = "Full Frontal";

				SetFormation("Duo");
			}
			else
			{
				arrAutoGenRequests.Remove(0, 1);
				return;
			}
			break;
		case ePBTLS_CapturedSoldier:
			AutoGenSettings.CameraPresetDisplayName = "Captured";

			Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ExecutingAutoGenRequest.UnitRef.ObjectID));
			ChosenState = XComGameState_AdventChosen(`XCOMHISTORY.GetGameStateForObjectID(Unit.ChosenCaptorRef.ObjectID));
			AutoGenSettings.BackgroundDisplayName = GetChosenBackgroundName(ChosenState);
			break;
		case ePBTLS_HeadShot:
			AutoGenSettings.CameraPresetDisplayName = "Headshot";
			AutoGenSettings.SizeX = ExecutingAutoGenRequest.SizeX;
			AutoGenSettings.SizeY = ExecutingAutoGenRequest.SizeY;
			AutoGenSettings.CameraDistance = ExecutingAutoGenRequest.CameraDistance;
			AutoGenSettings.HeadShotAnimName = ExecutingAutoGenRequest.AnimName;
			AutoGenSettings.CameraPOV.FOV = 80;
			break;
		}

		`PHOTOBOOTH.SetAutoGenSettings(AutoGenSettings, PhotoTaken);
	}
	else
	{
		m_bTakePhotoRequested = false;
		Cleanup();
	}
}

function string GetChosenBackgroundName(XComGameState_AdventChosen ChosenState)
{
	local string BackgroundName;
	local array<BackgroundPosterOptions> arrBackgrounds;
	local int i;

	BackgroundName = class'UIPhotoboothBase'.default.m_strEmptyOption;

	if (ChosenState != None)
	{
		`PHOTOBOOTH.GetBackgrounds(arrBackgrounds, ePBT_CHOSEN);

		for (i = 0; i < arrBackgrounds.Length; ++i)
		{
			if (arrBackgrounds[i].BackgroundDisplayName == ChosenState.GetChosenClassName())
			{
				BackgroundName = arrBackgrounds[i].BackgroundDisplayName;
				break;
			}
		}
	}

	return BackgroundName;
}

function RequestPhotos()
{
	//if (`ScreenStack.IsNotInStack(class'UIAfterAction', false))
	//{
		m_bTakePhotoRequested = true;
	//}
}

function PhotoTaken(StateObjectReference UnitRef)
{
	local int Index;
	local bool bFound;
	local delegate<OnAutoGenPhotoFinished> CallDelegate;

	bFound = false;
	for (Index = 0; Index < arrAutoGenRequests.Length; ++Index)
	{
		if (ExecutingAutoGenRequest.UnitRef.ObjectID == arrAutoGenRequests[Index].UnitRef.ObjectID && 
			ExecutingAutoGenRequest.TextLayoutState == arrAutoGenRequests[Index].TextLayoutState)
		{
			bFound = true;
			break;
		}
	}

	if (bFound)
	{
		foreach arrAutoGenRequests[Index].FinishedDelegates(CallDelegate)
		{
			if (CallDelegate != none)
			{
				CallDelegate(UnitRef);
			}
		}

		arrAutoGenRequests.Remove(Index, 1);
	}
}