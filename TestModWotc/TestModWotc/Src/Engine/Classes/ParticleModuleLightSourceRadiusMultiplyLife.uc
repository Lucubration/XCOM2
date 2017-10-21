/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class ParticleModuleLightSourceRadiusMultiplyLife extends ParticleModuleLightPropertyBase
	native(Particle)
	editinlinenew
	hidecategories(Object);

/**
 *	The scale factor for the size that should be used for a particle.
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

	Begin Object Class=DistributionFloatConstant Name=DistributionLightRadiusMultiplier
		Constant=1
	End Object
	LifeMultiplier=(Distribution=DistributionLightRadiusMultiplier)
}
