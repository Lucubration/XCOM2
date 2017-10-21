class InterpTrackSourceColor extends InterpTrackLinearColorBase
	native(Interpolation);

/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

cpptext
{
	// InterpTrack interface
	virtual INT AddKeyframe(FLOAT Time, UInterpTrackInst* TrInst, EInterpCurveMode InitInterpMode);
	virtual void PreviewUpdateTrack(FLOAT NewPosition, UInterpTrackInst* TrInst);
	virtual void UpdateTrack(FLOAT NewPosition, UInterpTrackInst* TrInst, UBOOL bJump);
	
	//virtual class UMaterial* GetTrackIcon() const;
}

defaultproperties
{
	TrackInstClass=class'Engine.InterpTrackInstSourceColor'
	TrackTitle="Source Color"
}
