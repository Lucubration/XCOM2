class ActorFactoryXComInstancedMeshActor extends ActorFactory
	native;

var() StaticMesh SourceStaticMesh;
var bool bCreated;
var native transient const pointer NewActor{AActor};
var native transient const array<pointer> SelectedStaticMeshActors{AStaticMeshActor}; 

cpptext
{
	virtual AActor* CreateActor( const FVector* const Location, const FRotator* const Rotation, const class USeqAct_ActorFactory* const ActorFactoryData );
	virtual void AutoFillFields(USelection* Selection);
	virtual FString GetMenuName();
	virtual UBOOL CanCreateActor(FString& OutErrorMsg, UBOOL bFromAssetOnly = FALSE );
}

defaultproperties
{
	bCreated=false
	MenuName="Add XComInstancedMeshActor"
	NewActorClass=class'XComGame.XComInstancedMeshActor'
}
