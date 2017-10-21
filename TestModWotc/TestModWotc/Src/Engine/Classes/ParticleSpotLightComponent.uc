/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class ParticleSpotLightComponent extends SpotLightComponent
	native(Light)
	hidecategories(Object)
	editinlinenew
	transient;

var transient bool bUseLocalSpace;
var rotator	 EmitterRotation;
var vector	 EmitterTranslation;


cpptext
{
	virtual void SetParentToWorld(const FMatrix& ParentToWorld);

	virtual void Attach();
	virtual void UpdateTransform();
}

defaultproperties
{
	CastShadows=FALSE
	bForceDynamicLight=TRUE
	UseDirectLightMap=FALSE
	bUseLocalSpace=FALSE
	LightingChannels=(Dynamic=TRUE,bInitialized=TRUE)
	bCompositeIntoLightRig=FALSE
}
