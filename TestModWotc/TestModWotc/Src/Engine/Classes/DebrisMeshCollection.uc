//  File: DebrisMeshCollection.uc
//  Author: Scott Boeckmann
//  Date: 2/4/2014
//
//  Description: Holds a list of debris meshes to be used in the XComParticleModuleEvent_SpawnDebris object

class DebrisMeshCollection extends object
	native;

var() array<StaticMesh> m_DebrisMeshes;