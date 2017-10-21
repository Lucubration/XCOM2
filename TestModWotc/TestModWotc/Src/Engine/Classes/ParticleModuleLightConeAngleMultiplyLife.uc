/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class ParticleModuleLightConeAngleMultiplyLife extends ParticleModuleLightPropertyBase
	native(Particle)
	editinlinenew
	hidecategories(Object);

/**
 *	The scale factor for the size that should be used for a particle.
 *	The value is retrieved using the RelativeTime of the particle during its update.
 */
var(Light)					rawdistributionfloat	InnerLifeMultiplier;
var(Light)					rawdistributionfloat	OuterLifeMultiplier;

cpptext
{
	virtual void	Spawn(FParticleEmitterInstance* Owner, INT Offset, FLOAT SpawnTime);
	virtual void	Update(FParticleEmitterInstance* Owner, INT Offset, FLOAT DeltaTime);
}

defaultproperties
{
	bSpawnModule=true
	bUpdateModule=true

	Begin Object Class=DistributionFloatConstant Name=DistributionInnerLightAngleMultiplier
		Constant=1
	End Object
	InnerLifeMultiplier=(Distribution=DistributionInnerLightAngleMultiplier)

	Begin Object Class=DistributionFloatConstant Name=DistributionOuterLightAngleMultiplier
		Constant=1
	End Object
	OuterLifeMultiplier=(Distribution=DistributionOuterLightAngleMultiplier)
}
