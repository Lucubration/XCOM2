//---------------------------------------------------------------------------------------
//  FILE:    X2Camera_TheLostReveal.uc
//  AUTHOR:  David Burchanowski  --  11/22/2016
//  PURPOSE: Camera that frames the lost coming out of the fog
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2Camera_TheLostReveal extends X2Camera
	config(Camera)
	native;

var private const config string CameraShake; // camera shake to play for the duration of the reveal
var const config bool EnableLostRevealCam; // Allows ini disabling of the lost reveal cam 
var const config float LostRevealCamViewDistance; // how far away to view the lost (in tiles)

var XComGameState_AIGroup RevealingLostPod; // cached reference to the pod that is revealing

var protected XComUnitPawnNativeBase LostUnitToFollow;
var protected Vector CameraLocation; // fixed location that the camera will be located at
var protected Vector LastTargetFeetLocation; // For smoothing out camera tracking of the target unit's head location

// finds all move ability contexts for the scampering pod
static native function FindScamperContextsForPods(XComGameState_AIGroup RevealedAIGroup, out array<XComGameStateContext_Ability> ScamperContexts) const;

// decides which XCom soldier should view the pod scamper, and which lost unit he is focusing on
static native function bool DetermineViewingUnits(XComGameState_AIGroup RevealedAIGroup, out XComUnitPawnNativeBase XComUnit, out XComUnitPawnNativeBase LostUnit, out Vector LostScamperEndPoint) const;

// determines the fixed location from which the camera will track the ladder climb
private function bool DetermineCameraLocation()
{
	local XComUnitPawnNativeBase ViewingXComPawn;
	local vector ToLost, NormalToLost, LostScamperEndPoint;
	local float ViewDistance;

	if(!DetermineViewingUnits(RevealingLostPod, ViewingXComPawn, LostUnitToFollow, LostScamperEndPoint))
	{
		return false;
	}

	// Get the normal vector pointing from the viewing XCom unit, to the Lost member he is tracking
	ToLost = LostScamperEndPoint - ViewingXComPawn.GetHeadLocation();
	NormalToLost = Normal(ToLost);

	// put the camera 1/2 tile in front of the viewing unit, to simulate looking through their eyes
	//CameraLocation = ViewingXComPawn.GetHeadLocation() + NormalToLost * class'XComWorldData'.const.WORLD_StepSize;
	
	ViewDistance = FMin(class'XComWorldData'.const.WORLD_StepSize * LostRevealCamViewDistance, VSize(ToLost) - class'XComWorldData'.const.WORLD_StepSize);
	CameraLocation = LostScamperEndPoint - NormalToLost * ViewDistance;

	// TODO? add support for detecting camera blocks
	return true;
}

function Activated(TPOV CurrentPOV, X2Camera PreviousActiveCamera, X2Camera_LookAt LastActiveLookAtCamera)
{
	local XComTacticalController LocalController;

	super.Activated(CurrentPOV, PreviousActiveCamera, LastActiveLookAtCamera);

	if(!DetermineCameraLocation())
	{
		RemoveSelfFromCameraStack();
	}

	LocalController = XComTacticalController(`BATTLE.GetALocalPlayerController());
	LocalController.CinematicModeToggled(true, true, true, true, false, false);

	PlayCameraAnim(CameraShake,,, true);

	LastTargetFeetLocation = LostUnitToFollow.GetFeetLocation();
}

function Deactivated()
{
	super.Deactivated();

	// If something else interrupts, just go back to overhead camera
	RemoveSelfFromCameraStack();
}

function UpdateCamera(float DeltaTime)
{
	super.UpdateCamera(DeltaTime);

	LastTargetFeetLocation = VLerp(LastTargetFeetLocation, LostUnitToFollow.GetFeetLocation(), DeltaTime * 4);
}

function TPOV GetCameraLocationAndOrientation()
{
	local vector HeadLocation;
	local TPOV Result;

	Result.Location = CameraLocation;
	Result.FOV = 55;

	// Since the lost heads bounce up and down a lot as they run, rather than look directly at them
	// we'll look at where their head is when they are standing up so that the camera doesn't
	// bob an insane amount
	HeadLocation = LastTargetFeetLocation;
	HeadLocation.Z += LostUnitToFollow.CollisionHeight * 2;
	Result.Rotation = Rotator(HeadLocation - CameraLocation);

	return Result;
}

function AddCameraFocusPoints()
{
	local XComGameStateHistory History;
	local XComWorldData WorldData;
	local StateObjectReference ScamperUnitRef;
	local XComGameState_Unit ScamperUnitState;
	local TFocusPoints FocusPoint;

	History = `XCOMHISTORY;
	WorldData = `XWORLD;

	foreach RevealingLostPod.m_arrMembers(ScamperUnitRef)
	{
		ScamperUnitState = XComGameState_Unit(History.GetGameStateForObjectID(ScamperUnitRef.ObjectID));

		FocusPoint.vFocusPoint = WorldData.GetPositionFromTileCoordinates(ScamperUnitState.TileLocation);
		FocusPoint.vCameraLocation = GetCameraLocationAndOrientation().Location;
		VisFocusPoints.AddItem(FocusPoint);
	}
}

defaultproperties
{
	Priority=eCameraPriority_LookAt
}

