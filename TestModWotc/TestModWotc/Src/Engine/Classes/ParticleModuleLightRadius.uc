/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class ParticleModuleLightRadius extends ParticleModuleLightPropertyBase
	native(Particle)
	editinlinenew
	hidecategories(Object);

/**
 *	The initial light radius for the light particle
 */
var(Light) rawdistributionfloat	StartLightRadius;

cpptext
{
	virtual void Spawn(FParticleEmitterInstance* Owner, INT Offset, FLOAT SpawnTime);
	/**
	 *	Extended version of spawn, allows for using a random stream for distribution value retrieval
	 *
	 *	@param	Owner				The particle emitter instance that is spawning
	 *	@param	Offset				The offset to the modules payload data
	 *	@param	SpawnTime			The time of the spawn
	 *	@param	InRandomStream		The random stream to use for retrieving random values
	 */
	void SpawnEx(FParticleEmitterInstance* Owner, INT Offset, FLOAT SpawnTime, class FRandomStream* InRandomStream);
}

defaultproperties
{
	bSpawnModule=true
	bUpdateModule=false

	Begin Object Class=DistributionFloatConstant Name=DistributionStartLightRadius
		Constant=256
	End Object
	StartLightRadius=(Distribution=DistributionStartLightRadius)
}
