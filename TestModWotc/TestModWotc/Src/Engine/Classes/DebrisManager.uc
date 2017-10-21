class DebrisManager extends Actor
	native
	dependson(DebrisMeshCollection);

event SpawnDebris(ParticleSystemComponent InComp, DebrisMeshCollection InDebrisCollection, vector InSpawnLocation, float InDebrisStrength, float InSpawnDelay);

defaultproperties
{
}