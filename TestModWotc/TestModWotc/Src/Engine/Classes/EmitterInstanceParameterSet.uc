//---------------------------------------------------------------------------------------
//  FILE:    EmitterInstanceParameterSet.uc
//  AUTHOR:  Ryan McFall  --  09/28/2010
//  PURPOSE: Defines a set of instance parameters to use with a particle emitter
//
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class EmitterInstanceParameterSet extends Object
	native(Particle);

/**
 *	Array holding name instance parameters for this ParticleSystemComponent.
 *	Parameters can be used in Cascade using DistributionFloat/VectorParticleParameters.
 */
var() editinline array<ParticleSysParam>		InstanceParameters;

DefaultProperties
{	
}
