//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    ParticleModuleMeshByParameter.uc
//  AUTHOR:  Jeremy Shopf -- 03/27/14
//  PURPOSE: Set the mesh on the mesh emitter using the mesh instance parameter
//---------------------------------------------------------------------------------------
//  Copyright (c) 2014 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 
class ParticleModuleMeshByParameter extends ParticleModuleMeshBase
	native(Particle)
	editinlinenew
	hidecategories(Object);

var(Mesh) name MeshParameter;

cpptext
{
	/**
	 *	Called on a particle that is being updated by its emitter.
	 *
	 *	@param	Owner		The FParticleEmitterInstance that 'owns' the particle.
	 *	@param	Offset		The modules offset into the data payload of the particle.
	 *	@param	DeltaTime	The time since the last update.
	 */
	virtual void Update(FParticleEmitterInstance* Owner, INT Offset, FLOAT DeltaTime);

	/**
	 *	Retrieve the ParticleSysParams associated with this module.
	 *
	 *	@param	ParticleSysParamList	The list of FParticleSysParams to add to
	 */
	virtual void GetParticleSysParamsUtilized(TArray<FString>& ParticleSysParamList);
}

defaultproperties
{
	bSpawnModule=false
	bUpdateModule=true
}
