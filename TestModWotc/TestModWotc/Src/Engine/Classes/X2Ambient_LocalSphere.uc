/**
 * SceneCaptureCubeMapComponent
 *
 * Allows a scene capture to up to 6 2D texture render targets
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class X2Ambient_LocalSphere extends X2SceneCaptureEnvMapComponent
	editinlinenew
	collapsecategories
	native;

var() float SphereOuterRadius<UIMin=8.0 | UIMax=1024.0 | ToolTip=Outer Radius at which this probe will no longer affect the environment.>;
var() float SphereInnerRadius<UIMin=8.0 | UIMax=1024.0 | ToolTip=Inner Radius at which this probe will start to lose intensity.>;
var() float FalloffPower<ToolTip=Exponent which controls how quickly the influence drops.>;

cpptext 
{
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	virtual FEnvMapSceneInfo* CreateSceneInfo();
	virtual UBOOL IsPositionInVolumes(const FVector&);
}

defaultproperties
{
	SphereOuterRadius=256
	SphereInnerRadius=128
	FalloffPower=1
	bParallaxCorrected=false
	eSpecQuality=eSQ_Low
}
