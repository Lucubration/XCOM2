/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class ParticleModuleWindVelocityOverLifetime extends ParticleModuleVelocityBase
	native(Particle)
	editinlinenew
	hidecategories(Object);

// global wind vector converted into local space 
//	wind speed is inherent in the length of the vector...
//	if this is a world space effect, this is a world space vector...
var(Velocity) rawdistributionfloat	AdditiveWindFraction<Tooltip=Adds the full WindVector specified to the ParticleVelocity>;

var(Velocity) bool UseWindSpeed<ToolTip=Set to use WindSpeed vector, unset to use WindStrength vector>;

var(Velocity) rawdistributionfloat	MultiplicativeWindFraction<ToolTip=Scales the prior component's AdditiveWindFraction by this factor>;

var(Velocity) bool PureMultiplicative<Tooltip=Set to use only the MultiplicativeWindFraction, Unset to use the AdditiveWindFraction>;

cpptext
{
	virtual void	Spawn(FParticleEmitterInstance* Owner, INT Offset, FLOAT SpawnTime);
	virtual void	Update(FParticleEmitterInstance* Owner, INT Offset, FLOAT DeltaTime);
}

defaultproperties
{
	bSpawnModule=true
	bUpdateModule=true

	Begin Object Class=DistributionFloatConstant Name=GlobalDistributionWindFraction
		Constant=1.0;
	End Object
	AdditiveWindFraction=(Distribution=GlobalDistributionWindFraction)

	Begin Object Class=DistributionFloatConstant Name=CumulativeDistributionWindFraction
		Constant=1.0;
	End Object
	MultiplicativeWindFraction=(Distribution=CumulativeDistributionWindFraction)

}
