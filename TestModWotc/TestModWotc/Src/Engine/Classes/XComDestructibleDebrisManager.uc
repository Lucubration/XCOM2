class XComDestructibleDebrisManager extends Actor
	native
	inherits(FTickableObject);	

var array<StaticMeshActor> m_DebrisCoverActors;

var int MaxNumberOfSpawnedDebris;


struct native RemainsRequestStruct
{
	var Actor pTemplateActor;
	var Vector NewLocation;
	var Rotator NewRotation;
	var LightingChannelContainer NewLightingChannels;
	var String TemplatePath;

	structcpptext
	{

		FRemainsRequestStruct()
		{
			memset( this, 0, sizeof(*this) );
		}

		FRemainsRequestStruct(EEventParm)
		{
			memset( this, 0, sizeof(*this) );
		}

	}
};

var array<RemainsRequestStruct> RequestRemains;
var array<RemainsRequestStruct> SpawnedDebrisRequests;


cpptext
{

	// FTickableObject interface
	virtual void Tick(FLOAT DeltaTime);
	
	virtual UBOOL IsTickable() const
	{	
		return !HasAnyFlags( RF_Unreachable | RF_AsyncLoading );
	}

	virtual UBOOL IsTickableWhenPaused() const
	{
		return FALSE;
	}

	void AddDestructibleRemains(FVector NewLocation, FRotator NewRotation, AActor* pTemplateActor, FLightingChannelContainer NewLightingChannels);

	UBOOL ReachedMaxDebris();
}

defaultproperties
{
	RemoteRole=ROLE_None

	MaxNumberOfSpawnedDebris=2
}