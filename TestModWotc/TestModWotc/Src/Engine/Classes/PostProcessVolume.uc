/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * Used to affect post process settings in the game and editor.
 */
class PostProcessVolume extends Volume
	native
	placeable
	dependson(DOFEffect,PostProcessSettingsObject)
	hidecategories(Advanced,Collision,Volume);

/**
 * Priority of this volume. In the case of overlapping volumes the one with the highest priority
 * is chosen. The order is undefined if two or more overlapping volumes have the same priority.
 */
var()							float					Priority;

/**
 * Setting this will forcably override the post processing chain set in World Settings when the 
 * player enters this volume.  Use this when not using "bUseWorldSettings" in an UberPostProcess
 * Effect
 */
var()                           bool                    bOverrideWorldPostProcessChain;

/**
 * Post process settings to use for this volume.
 */
var()							PostProcessSettings		Settings;

/** Next volume in linked listed, sorted by priority in descending order.							*/
var const noimport transient	PostProcessVolume		NextLowerPriorityVolume;


/** Whether this volume is enabled or not.															*/
var()							bool					bEnabled;

replication
{
	if (bNetDirty)
		bEnabled;
}

/**
 * Kismet support for toggling bDisabled.
 */
simulated function OnToggle(SeqAct_Toggle action)
{
	if (action.InputLinks[0].bHasImpulse)
	{
		// "Turn On" -- mapped to enabling of volume.
		bEnabled = TRUE;
	}
	else if (action.InputLinks[1].bHasImpulse)
	{
		// "Turn Off" -- mapped to disabling of volume.
		bEnabled = FALSE;
	}
	else if (action.InputLinks[2].bHasImpulse)
	{
		// "Toggle"
		bEnabled = !bEnabled;
	}
	ForceNetRelevant();
	SetForcedInitialReplicatedProperty(Property'Engine.PostProcessVolume.bEnabled', (bEnabled == default.bEnabled));
}

cpptext
{
	/**
	 * Routes ClearComponents call to Super and removes volume from linked list in world info.
	 */
	virtual void ClearComponents();
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	virtual void PostLoad();
protected:
	/**
	 * Routes UpdateComponents call to Super and adds volume to linked list in world info.
	 */
	virtual void UpdateComponentsInternal(UBOOL bCollisionUpdate = FALSE);
public:
}

defaultproperties
{
	Begin Object Name=BrushComponent0
		CollideActors=False
		BlockActors=False
		BlockZeroExtent=False
		BlockNonZeroExtent=False
		BlockRigidBody=False
	End Object

	bCollideActors=False
	bBlockActors=False
	bProjTarget=False
	bStatic=false
	bTickIsDisabled=true

	SupportedEvents.Empty
	SupportedEvents(0)=class'SeqEvent_Touch'

	bEnabled=True
}
