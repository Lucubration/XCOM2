class ActorFactoryAkAmbientSound extends ActorFactory
	config(Editor)
	collapsecategories
	hidecategories(Object)
	native;

cpptext
{
	virtual AActor* CreateActor(const FVector* const Location, const FRotator* const Rotation, const class USeqAct_ActorFactory* const ActorFactoryData);
	virtual UBOOL CanCreateActor(FString& OutErrorMsg, UBOOL bFromAssetOnly = FALSE);
	virtual void AutoFillFields(class USelection* Selection);
	virtual FString GetMenuName();
}

var()	AKEvent		AmbientEvent;

defaultproperties 
{
	MenuName="Add AkAmbientSound"
	NewActorClass=class'AKAudio.AKAmbientSound'
}
