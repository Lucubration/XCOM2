class InterpTrackVectorAim extends InterpTrackVectorBase
	native(Interpolation)
	dependson(AnimNodeAimOffset);

/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

cpptext
{
	// UObject interface
	virtual void PreEditChange(UProperty* PropertyAboutToChange);
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);

	// InterpTrack interface
	virtual INT AddKeyframe(FLOAT Time, UInterpTrackInst* TrInst, EInterpCurveMode InitInterpMode);
	virtual void PreviewUpdateTrack(FLOAT NewPosition, UInterpTrackInst* TrInst);
	virtual void UpdateTrack(FLOAT NewPosition, UInterpTrackInst* TrInst, UBOOL bJump);
	
	class UAnimNodeAimOffset* GetAimOffsetNode(AActor* Actor);
	class UInterpTrackInstVectorAim* GetTrackInst();
}

/** Matching a node in the anim tree of type AnimNodeAimOffset */
var()	name		NodeName;

defaultproperties
{
	TrackInstClass=class'Engine.InterpTrackInstVectorAim'
	TrackTitle="Vector Aim"
}
