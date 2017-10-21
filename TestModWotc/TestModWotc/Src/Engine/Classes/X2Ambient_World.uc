/**
 * SceneCaptureCubeMapComponent
 *
 * Allows a scene capture to up to 6 2D texture render targets
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class X2Ambient_World extends X2SceneCaptureEnvMapComponent
	editinlinenew
	native;

var float fDiffuseScalar;

cpptext 
{
	virtual void Serialize(FArchive& Ar);

	// This shouldn't create a sceneinfo, as it should use the world ambient rendering pipeline
	virtual FEnvMapSceneInfo* CreateSceneInfo() {return NULL;}
	virtual UBOOL IsPositionInVolumes(const FVector&);
}

defaultproperties
{
	bUseAsWorldAmbient=true
	bParallaxCorrected=false
	eSpecQuality=eSQ_High

	fDiffuseScalar = 1.0f
}
