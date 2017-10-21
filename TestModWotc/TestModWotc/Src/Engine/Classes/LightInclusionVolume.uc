//---------------------------------------------------------------------------------------
//  FILE:    LightInclusionVolume.uc
//  AUTHOR:  Ken Derda  --  5/28/2014
//  PURPOSE: Specialized volume used to bound a light's influence.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class LightInclusionVolume extends Volume
	dependson(Scene,VolumeGeoComponent)
	native
	placeable;

defaultproperties
{
	// replace default brush component with VolumeGeoComponent
	Begin Object Class=VolumeGeoComponent Name=VolumeGeoComponent0
		CollideActors=false
		bAcceptsLights=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		BlockRigidBody=false
		AlwaysLoadOnClient=True
		AlwaysLoadOnServer=True
		CanBlockCamera=false // FIRAXIS jboswell
		bDisableAllRigidBody=true
	End Object
	Components.Remove(BrushComponent0)
	BrushComponent=VolumeGeoComponent0
	CollisionComponent=VolumeGeoComponent0
	Components.Add(VolumeGeoComponent0)

	Layer=Lighting
}



