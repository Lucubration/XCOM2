//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XComAlienPathNodeFactory extends ActorFactory
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
	MenuName="Add XComAlienPathNode"
	NewActorClass=class'XComGame.XComAlienPathNode'
	bShowInEditorQuickMenu=true
}
