/**
 * SceneCaptureCubeMapComponent
 *
 * Allows a scene capture to up to 6 2D texture render targets
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class X2Ambient_Interior extends X2SceneCaptureEnvMapComponent
	editinlinenew
	collapsecategories
	native;

var() array<Volume> EnvMapVolumes;

cpptext 
{
	virtual void UpdateVolumeData();

	virtual FEnvMapSceneInfo* CreateSceneInfo();

	FBox GetBoundingBox();
	virtual void GetVolumes(TArray<AVolume*>& OutVolumes);
	virtual UBOOL IsPositionInVolumes(const FVector&);
}

defaultproperties
{
	bParallaxCorrected=true
}
