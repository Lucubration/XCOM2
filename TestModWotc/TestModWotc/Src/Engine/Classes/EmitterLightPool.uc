/**
 * this class manages a pool of ParticlePointLightComponents
 * It allows for reuse of light componenters without forcing a creation/deletion
 * upon each spawn/death of a particle.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class EmitterLightPool extends Actor
	native(Particle)
	transient
	config(Game);

/** components currently in the pool */
var transient init array<ParticlePointLightComponent> InActivePointLightComponents;
var transient init array<ParticleSpotLightComponent> InActiveSpotLightComponents;

/** components currently active */
var transient init array<ParticlePointLightComponent> ActivePointLightComponents;
var transient init array<ParticleSpotLightComponent> ActiveSpotLightComponents;

/* Returns the given light back to the pool */
protected native final function ReturnToPool(LightComponent pLC);

/** internal - helper for spawning functions
 * gets a component from the appropriate pool array (checks PerEmitterPools)
 * includes creating a new one if necessary as well as taking one from the active list if the max number active has been exceeded
 * @return the ParticleSystemComponent to use
 */
native final function ParticleSpotLightComponent GetPooledSpotLightComponent();
native final function ParticlePointLightComponent GetPooledPointLightComponent();

private native final function ReturnLightComponent(LightComponent pLC);

defaultproperties
{
	TickGroup=TG_DuringAsyncWork
}
