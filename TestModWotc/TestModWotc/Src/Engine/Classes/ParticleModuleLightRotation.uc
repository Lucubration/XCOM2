/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class ParticleModuleLightRotation extends ParticleModuleLightPropertyBase
	native(Particle)
	editinlinenew
	hidecategories(Object);

/** 
 *	The location the particle should be emitted.
 *	Relative in local space to the emitter by default.
 *	Relative in world space as a WorldOffset module or when the emitter's UseLocalSpace is off.
 *	Retrieved using the EmitterTime at the spawn of the particle.
 */
var(Light) rawdistributionvector	StartRotation;

cpptext
{
protected:
	/**
	 *	Extended version of spawn, allows for using a random stream for distribution value retrieval
	 *
	 *	@param	Owner				The particle emitter instance that is spawning
	 *	@param	Offset				The offset to the modules payload data
	 *	@param	SpawnTime			The time of the spawn
	 *	@param	InRandomStream		The random stream to use for retrieving random values
	 */
	virtual void SpawnEx(FParticleEmitterInstance* Owner, INT Offset, FLOAT SpawnTime, class FRandomStream* InRandomStream);

public:
	virtual void Spawn(FParticleEmitterInstance* Owner, INT Offset, FLOAT SpawnTime);
}

defaultproperties
{
	bSpawnModule=true

	Begin Object Class=DistributionVectorConstant Name=DistributionStartRotation
	End Object
	StartRotation=(Distribution=DistributionStartRotation)
}

