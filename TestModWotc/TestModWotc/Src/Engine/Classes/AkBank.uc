class AkBank extends Object
	native;

var()	bool	AutoLoad;			// Auto-load bank when its package is accessed for the first time
var()	bool	GenerateDefinition;	// This bank is part of the 'Generate All Definitions' list

cpptext
{
	virtual void PostLoad();
	virtual void BeginDestroy();

	UBOOL Load();
	UBOOL LoadAsync( void* in_pfnBankCallback, void* in_pCookie );
	void  Unload();
	void  UnloadAsync( void* in_pfnBankCallback, void* in_pCookie );
	
	void GetEventsReferencingBank( TArray<UAkEvent*>& Events );
	void GenerateDefinitionFile();
}

defaultproperties
{
	AutoLoad=true
	GenerateDefinition=true
}
