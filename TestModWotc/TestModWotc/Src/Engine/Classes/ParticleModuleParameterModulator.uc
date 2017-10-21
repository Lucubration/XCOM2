//---------------------------------------------------------------------------------------
//  FILE:    ParticleModuleParameterModulator.uc
//  AUTHOR:  Ryan McFall  --  06/11/2010
//  PURPOSE: The base class for particle modules that modify / modulate dynamic parameters
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class ParticleModuleParameterModulator extends ParticleModule
	native(Particle)
	editinlinenew
	hidecategories(Object)
	abstract;

cpptext
{
	// ParticleModuleParameterModulator interface
	virtual void Modulate( FParticleEmitterInstance* Owner, FVector4& outValue, FVector4& outValue1 ){}
}

defaultproperties
{
	bIsParamaterModulator=true
}
