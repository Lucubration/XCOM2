/**
 * Copyright 2016 Firaxis Games, Inc. All Rights Reserved.
 */
class ParticleModuleLightSourceLengthMultiplyLife extends ParticleModuleLightPropertyBase
	native(Particle)
	editinlinenew
	hidecategories(Object);

/**
 *	The scale factor for the source length that should be used for a light particle.
 *	The value is retrieved using the RelativeTime of the particle during its update.
 */
var(Light)					rawdistributionfloat	LifeMultiplier;

cpptext
{
	virtual void	Spawn(FParticleEmitterInstance* Owner, INT Offset, FLOAT SpawnTime);
	virtual void	Update(FParticleEmitterInstance* Owner, INT Offset, FLOAT DeltaTime);
}

defaultproperties
{
	bSpawnModule=true
	bUpdateModule=true

	Begin Object Class=DistributionFloatConstant Name=DistributionLightSourceLengthMultiplier
		Constant=1
	End Object
	LifeMultiplier=(Distribution=DistributionLightSourceLengthMultiplier)
}
