//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XComTileEffectsFactory extends ActorFactory
	config(Editor)
	collapsecategories
	hidecategories(Object)
	native;

cpptext
{	
	virtual UBOOL CanCreateActor(FString& OutErrorMsg, UBOOL bFromAssetOnly = FALSE );	
}

DefaultProperties
{
	MenuName="Add XComTileEffectActor"
	NewActorClass=class'XComGame.XComTileEffectActor'
	bShowInEditorQuickMenu=true
}