//=============================================================================
// Ambient sound, sits there and emits its sound.
// Copyright 1998-2007 Epic Games, Inc. All Rights Reserved.
//=============================================================================
class AkAmbientSound extends Keypoint native;

/** Should the audio component automatically play on load? */
//var() bool bAutoPlay; Not showing this parameter to user since it is not working properly yet.
var bool bAutoPlay;

/** Audio component to play */
var() AkEvent PlayEvent;

var() bool StopWhenOwnerIsDestroyed;

/** Is the audio component currently playing? */
var transient private bool bIsPlaying;

cpptext
{
public:
	/**
	 * Start and stop the ambience playback
	 */
	virtual void StartPlayback();
	virtual void StopPlayback();

	/** Used by the component to flag the ambient sound as not playing */
	void Playing( UBOOL in_IsPlaying );
	
	virtual void FinishDestroy();

protected:
	/**
	 * Starts audio playback if wanted.
	 */
	virtual void UpdateComponentsInternal(UBOOL bCollisionUpdate = FALSE);
}

defaultproperties
{
	Begin Object NAME=Sprite
		Sprite=Texture2D'AkResources.Wwise'
	End Object

	bAutoPlay=TRUE
	StopWhenOwnerIsDestroyed=TRUE
	bIsPlaying=FALSE
	
	RemoteRole=ROLE_None
}
