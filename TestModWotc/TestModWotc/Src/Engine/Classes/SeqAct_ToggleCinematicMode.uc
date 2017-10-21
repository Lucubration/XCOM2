/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ToggleCinematicMode extends SequenceAction;

var() bool bDisableMovement;
var() bool bDisableTurning;
var() bool bHidePlayer;
/** Don't allow input */
var() bool bDisableInput;
/** Whether to hide the HUD during cinematics or not */
var() bool bHideHUD;

/** Destroy dead GearPawns */
var() bool bDeadBodies;
/** Destroy dropped weapons and pickups */
var() bool bDroppedPickups;

// FIRAXIS addition -tsmith
/** TRUE is the default Unreal way of doing things: the server is in control of toggling clients cinemation mode. if clients execute this action its a noop. FALSE allows clients executing this action to toggle cinematics, should only be used in code that is called only on the client. */
var() bool bDisabledOnClient;

// FIRAXIS addition -ejordan
/** Disables user music so as to not play over the cinematic audio */
var() bool bOverrideUserMusic;

/** Delete objects we don't want to keep around during cinematics */
event Activated()
{
	local Actor A;
	foreach GetWorldInfo().DynamicActors( class'Actor', A )
	{
		if( ( bDeadBodies		&& A.IsA('GamePawn') && A.bTearOff ) || 
			( bDroppedPickups	&& A.IsA('DroppedPickup') ) )
		{
			A.Destroy();
		}
	}
}


defaultproperties
{
	ObjName="Toggle Cinematic Mode"
	ObjCategory="Toggle"

	InputLinks(0)=(LinkDesc="Enable")
	InputLinks(1)=(LinkDesc="Disable")
	InputLinks(2)=(LinkDesc="Toggle")

	bDisableMovement=TRUE
	bDisableTurning=TRUE
	bHidePlayer=TRUE
	bDisableInput=TRUE
	bHideHUD=TRUE
	bDeadBodies=TRUE
	bDroppedPickups=TRUE
	// FIRAXIS addition -tsmith
	bDisabledOnClient=TRUE
	// FIRAXIS addition -ejordan
	bOverrideUserMusic=FALSE
}
