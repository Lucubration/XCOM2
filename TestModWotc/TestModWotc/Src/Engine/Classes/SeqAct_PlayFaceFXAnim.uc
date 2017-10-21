/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_PlayFaceFXAnim extends SequenceAction
	native(Sequence);

/** Reference to FaceFX AnimSet package the animation is in */
var()	FaceFXAnimSet	FaceFXAnimSetRef;

/**
 *	Name of group within the FaceFXAsset to find the animation in. Case sensitive.
 */
var()	string			FaceFXGroupName;

/** 
 *	Name of FaceFX animation within the specified group to play. Case sensitive.
 */
var()	string			FaceFXAnimName;

/** The SoundCue to play with this FaceFX. **/
var() SoundCue SoundCueToPlay;

// WWISEMODIF_START, alessard, nov-28-2008, WwiseAudioIntegration
var() AkEvent AkEventToPlay;
// WWISEMODIF_END

defaultproperties
{
	ObjName="Play FaceFX Anim"
	ObjCategory="Actor"

	InputLinks(0)=(LinkDesc="Play")
}
