//---------------------------------------------------------------------------------------
//  FILE:    X2Camera_FollowCursor.uc
//  AUTHOR:  David Burchanowski  --  2/10/2014
//  PURPOSE: Override of X2Camera_FollowMouseCursor with minor adjustments to make it play well with the controller
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2Camera_FollowCursor extends X2Camera_FollowMouseCursor
	config(Camera);

// Keep track of the location of the cursor on the last frame so we can detect when it moves.
var vector PrevCursorLocation;

function Activated(TPOV CurrentPOV, X2Camera PreviousActiveCamera, X2Camera_LookAt LastActiveLookAtCamera)
{
	super.Activated(CurrentPOV, PreviousActiveCamera, LastActiveLookAtCamera);

	// move the LookAt point to be centered on the cursor
	LookAt = `CURSOR.Location;
}

/// <summary>
/// Get's the current desired look at location
/// </summary>
protected function Vector GetCameraLookat()
{
	local Vector Result;
	local XCom3DCursor Cursor;

	// Just pass through the look at which is recomputed below in UpdateCamera if the cursor location changes. LookAt can accumulate deltas
	// from the scrolling functions ( right stick on the controller ).
	Result = LookAt;
	Cursor = `CURSOR;
	Result.Z = Cursor.GetFloorMinZ(Cursor.m_iLastEffectiveFloorIndex);
	return Result;
}

function UpdateCamera(float DeltaTime)
{
	local XCom3DCursor Cursor;

	super.UpdateCamera(DeltaTime);

	// if the cursor moves, clear out any scrolling deltas to recenter on the puck
	Cursor = `CURSOR;
	if (Cursor.Location != PrevCursorLocation)
	{
		LookAt = Cursor.Location;
	}
	PrevCursorLocation = Cursor.Location;
}

// No mouse edge scrolling allowed in controller mode
function EdgeScrollCamera(Vector2D Offset);

function bool HidePathing()
{
	return false;
}