class AkComponent extends ActorComponent
	native
	collapsecategories
	hidecategories(Object)
	hidecategories(ActorComponent)
	editinlinenew;

var()	Name		BoneName;
var     AkEvent     AutoPlayEvent;

/** Stop sound when owner is destroyed */
var		bool		bStopWhenOwnerDestroyed;

cpptext
{
	// Object interface.
	virtual void Serialize(FArchive& Ar);
	virtual void Attach();
	virtual void Detach( UBOOL bWillReattach = FALSE );
	virtual void FinishDestroy();
	virtual void ShutdownAfterError();
	
	// Methods
	void UnregisterGameObject();
	void Stop();

	void Attenuate(float AttenuationScalingFactor);
}

defaultproperties
{
}
