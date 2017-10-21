class ActorFactoryXComArchetype extends ActorFactoryArchetype
	native;

cpptext
{
	virtual UBOOL CanCreateActor(FString& OutErrorMsg, UBOOL bFromAssetOnly = FALSE );
	virtual void PostReplaceActor(AActor *OldActor, AActor *NewActor);
}

defaultproperties
{
	MenuName="Add Archetype (w/Cover)"
}
