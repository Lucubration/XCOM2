/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AnimNotify_Sound extends AnimNotify
	native(Anim);

var()	SoundCue	SoundCue;
var()	bool		bFollowActor;
var()	Name		BoneName;
var()	bool		bIgnoreIfActorHidden;
// FIRAXIS addtion: -tsmith
var()   bool        bIgnoreIfActorInFOW;


/** This is the percent to play this Sound.  Defaults to 100% (aka 1.0f) **/
var()   float       PercentToPlay;
var()   float		VolumeMultiplier;
var()	float		PitchMultiplier;

cpptext
{
	// AnimNotify interface.
	virtual void Notify( class UAnimNodeSequence* NodeSeq );

	virtual FString GetEditorComment()// { return TEXT("Snd"); }
	{
		// Firaxis change
		FString sName = "";
		if (SoundCue)
		{
			SoundCue->GetName(sName);
		}

		return sName;
	}
	virtual FColor GetEditorColor() { return FColor(0,255,0); }
}

defaultproperties
{
	PercentToPlay=1.0f
	VolumeMultiplier=1.f
	PitchMultiplier=1.f
	bFollowActor=TRUE

	bIgnoreIfActorHidden=true  // FIRAXIS CHANGE
}
