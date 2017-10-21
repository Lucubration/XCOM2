/**
 * Firaxis addition - MHU
 */
class ParticleModuleCollisionPrediction extends ParticleModuleCollision
	native(Particle)
	editinlinenew
	hidecategories(Object);

var(Collision) float fCollisionPredictionTimeStep;

cpptext
{

	virtual void	Spawn(FParticleEmitterInstance* Owner, INT Offset, FLOAT SpawnTime);
	virtual void	Update(FParticleEmitterInstance* Owner, INT Offset, FLOAT DeltaTime);
	virtual UINT	RequiredBytes(FParticleEmitterInstance* Owner = NULL);
}

defaultproperties
{
}
