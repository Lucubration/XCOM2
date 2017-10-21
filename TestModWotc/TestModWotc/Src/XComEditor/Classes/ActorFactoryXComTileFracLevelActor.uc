class ActorFactoryXComTileFracLevelActor extends ActorFactoryXComFracLevelActor
	native;

cpptext
{
	virtual AActor* CreateActor( const FVector* const Location, const FRotator* const Rotation, const class USeqAct_ActorFactory* const ActorFactoryData );
}

defaultproperties
{
	MenuName="Add XComTileFracLevelActor"
	NewActorClass=class'XComGame.XComTileFracLevelActor'
}
