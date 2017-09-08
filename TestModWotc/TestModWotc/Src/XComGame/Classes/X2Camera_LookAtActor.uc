//---------------------------------------------------------------------------------------
//  FILE:    X2Camera_LookAtActor.uc
//  AUTHOR:  David Burchanowski  --  2/10/2014
//  PURPOSE: Camera that looks at a unit.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2Camera_LookAtActor extends X2Camera_LookAt;

var Actor ActorToFollow;
var bool UseTether; // Should this tether to the safe zone, or center on the unit
var bool SnapToFloor; // Should the lookat snap to the bottom of the current floor?
var privatewrite bool HasArrived; // have we arrived at our destination?

function UpdateCamera(float DeltaTime)
{
	local TPOV CameraLocation;

	super.UpdateCamera(DeltaTime);

	if(UseTether)
	{
		// check to see if we've finished our transition to the target.
		// Consider ourselves "arrived" once the target is onscreen. We'll still be moving, but generally
		// anything that was waiting to look at the actor can stop waiting.
		CameraLocation = GetCameraLocationAndOrientation();

		HasArrived = HasArrived || IsPointWithinCameraFrustum(CameraLocation, GetCameraLookat());
	}
	else
	{
		HasArrived = HasArrived || (VSizeSq(GetCameraLookat() - CurrentLookAt) < 4096.0f);
	}
}

protected function InterpolateZoom(float DeltaTime)
{
	// don't zoom until the camera has arrived at the destination
	if( HasArrived )
	{
		super.InterpolateZoom(DeltaTime);
	}
}

/// <summary>
/// Gets the current desired look at location. Override in derived classes
/// </summary>
protected function Vector GetCameraLookat()
{
	local XCom3DCursor Cursor;
	local int CursorFloor;
	local Vector Result;

	Result = ActorToFollow.Location;

	// snap the lookat to the bottom of the current objects's floor. Smooths out small bumps
	// and vertical motions, especially when transitioning between objects on the same floor.
	if(SnapToFloor)
	{
		Cursor = `CURSOR;
		CursorFloor = Cursor.WorldZToFloor(Result);
		Result.Z = Cursor.GetFloorMinZ(CursorFloor);
	}

	if(UseTether)
	{
		Result = GetTetheredLookatPoint(Result, GetCameraLocationAndOrientation());
	}

	return Result;
}

function AddCameraFocusPoints()
{
	local TFocusPoints FocusPoint;
	local BoxSphereBounds UnitBounds;	

	if (XGUnit(ActorToFollow) != none)
	{
		UnitBounds = XGUnit(ActorToFollow).GetPawn().Mesh.Bounds;
	}
	else if(ActorToFollow.CollisionComponent != none)
	{
		UnitBounds = ActorToFollow.CollisionComponent.Bounds;
	}
	else
	{
		UnitBounds.Origin = ActorToFollow.Location;
		UnitBounds.BoxExtent = vect(0, 0, 0);
		UnitBounds.SphereRadius = 0;
	}

	FocusPoint.vFocusPoint = UnitBounds.Origin;

	FocusPoint.vCameraLocation = FocusPoint.vFocusPoint - (Vector(GetCameraLocationAndOrientation().Rotation) * 9999.0f);

	FocusPoint.vFocusPoint.Z += UnitBounds.BoxExtent.Z;
	VisFocusPoints.AddItem(FocusPoint);

	FocusPoint.vFocusPoint.Z -= UnitBounds.BoxExtent.Z * 2.0f;
	VisFocusPoints.AddItem(FocusPoint);
}

defaultproperties
{
	Priority=eCameraPriority_GameActions
	UseTether=false
	SnapToFloor=true
}