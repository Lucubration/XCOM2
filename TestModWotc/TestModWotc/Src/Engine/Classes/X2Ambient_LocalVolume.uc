/**
 * SceneCaptureCubeMapComponent
 *
 * Allows a scene capture to up to 6 2D texture render targets
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class X2Ambient_LocalVolume extends X2SceneCaptureEnvMapComponent
	editinlinenew
	collapsecategories
	native;

var() Volume EnvMapVolume<ToolTip=Volume to render ambient to. Must be a box.>;
var() vector BlendStartPercentage<Tooltip=Percentage of box from center at which to start fading out the ambient.>;
var() float FalloffPower<ToolTip=Exponent which controls how quickly the influence drops.>;

cpptext 
{
	virtual void UpdateVolumeData();
	virtual FEnvMapSceneInfo* CreateSceneInfo();

	virtual void GetVolumes(TArray<AVolume*>& OutVolumes);
	virtual UBOOL IsPositionInVolumes(const FVector&);
}

defaultproperties
{
	BlendStartPercentage=(X=0.9,Y=0.9,Z=0.9)
	FalloffPower=1
	bParallaxCorrected=true
}
