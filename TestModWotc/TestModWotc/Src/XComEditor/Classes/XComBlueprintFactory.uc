//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XComBlueprintFactory extends ActorFactory
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
	MenuName="Add XComBlueprint"
	NewActorClass=class'Engine.XComBlueprint'
	// temporarily removed from the quick menu until the functionality is actually completed.
	bShowInEditorQuickMenu=true
}