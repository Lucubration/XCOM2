/**
* Firaxis Games, Inc. All rights reserved.
*/
class SHDebugActor extends Actor
	native
	transient;

var const transient InstancedStaticMeshComponent SphereComponent;
var const transient StaticMesh SphereMesh;
/*
cpptext
{
	// UObject interface
	virtual void Serialize(FArchive& Ar);
	virtual void PostLoad();

	// AActor interface
	virtual void UpdateComponentsInternal(UBOOL bCollisionUpdate = FALSE);
	virtual void ClearComponents();

	// Needed to reference UObjects embedded in TMaps
	virtual void AddReferencedObjects(TArray<UObject*>& ObjectArray);
}*/

defaultproperties
{
	bStatic = false
	bMovable=false

	Begin Object Class=InstancedStaticMeshComponent Name=InstancedMeshComponent0
	CastShadow=false
	BlockNonZeroExtent=false
	BlockZeroExtent=false
	BlockActors=false
	CollideActors=false
	StaticMesh=StaticMesh'ChrisPDev.SHSphere'
	End object
	SphereComponent=InstancedMeshComponent0
	Components.Add(InstancedMeshComponent0)
}