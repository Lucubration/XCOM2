/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class InterpTrackInstVectorMaterialParam extends InterpTrackInst
	native(Interpolation);

cpptext
{
	virtual void InitTrackInst(UInterpTrack* Track);
	virtual void TermTrackInst(UInterpTrack* Track);
	virtual void SaveActorState(UInterpTrack* Track);
	virtual void RestoreActorState(UInterpTrack* Track);
}

/** list of MICs we are using and optionally also the original value of the parameter we're editing
 * array size should match owner track's Materials array
 */
struct native VectorMaterialParamMICData
{
	/** MICs we're using to set the desired parameter on PrimitiveComponents - size of array should match track's AffectedMaterialRefs */
	var const array<MaterialInstanceConstant> MICs;
	/** saved values for restoring state when exiting Matinee - size of array should match MICs */
	var const array<vector> MICResetVectors;
	/** Whether or not a new MIC was created at runtime (should be yes except for MICs on particle systems) - size of array should match MICs */
	var const array<bool> MICShouldNotReparent; // FIRAXIS ADDITION
};
var array<VectorMaterialParamMICData> MICInfos;

/** track we are an instance of - used in the editor to propagate changes to the track's Materials array immediately */
var InterpTrackVectorMaterialParam InstancedTrack;
