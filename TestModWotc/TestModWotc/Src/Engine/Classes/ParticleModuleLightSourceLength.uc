/**
 * Copyright 2016 Firaxis Games, Inc. All Rights Reserved.
 */
class ParticleModuleLightSourceLength extends ParticleModuleLightPropertyBase
	native(Particle)
	editinlinenew
	hidecategories(Object);

/**
 *	The initial source length for the light particle (requires source radius to be non-zero)
 */
var(Light) rawdistributionfloat	StartLightSourceLength;

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

	Begin Object Class=DistributionFloatConstant Name=DistributionStartLightSourceLength
		Constant=0
	End Object
	StartLightSourceLength=(Distribution=DistributionStartLightSourceLength)
}
