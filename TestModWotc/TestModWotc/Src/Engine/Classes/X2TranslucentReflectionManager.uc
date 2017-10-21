class X2TranslucentReflectionManager extends Actor
	native;

var transient array<StaticMeshComponent> RegisteredMeshes;

cpptext
{
	virtual void TickSpecial(float DeltaTime);

	virtual void RegisterTranslucentStaticMesh(UStaticMeshComponent* StaticMesh);
	virtual void DeregisterTranslucentStaticMesh(UStaticMeshComponent* StaticMesh);
}