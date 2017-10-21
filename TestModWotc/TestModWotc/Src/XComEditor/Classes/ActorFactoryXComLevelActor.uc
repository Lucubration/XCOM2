class ActorFactoryXComLevelActor extends ActorFactoryStaticMesh
	native;

// store a reference to the old actor, so we can access it if necessary
var native transient const pointer ActorToReplace{AActor};

cpptext
{
	virtual AActor* CreateActor( const FVector* const Location, const FRotator* const Rotation, const class USeqAct_ActorFactory* const ActorFactoryData );
	virtual void AutoFillFields(USelection* Selection);
	virtual FString GetMenuName();
	virtual UBOOL CanCreateActor(FString& OutErrorMsg, UBOOL bFromAssetOnly = FALSE );
	virtual void PreReplaceActor(AActor *OldActor);
	virtual void PostReplaceActor(AActor *OldActor, AActor *NewActor);
}

defaultproperties
{
	MenuName="Add XComLevelActor"
	NewActorClass=class'XComGame.XComLevelActor'
}
