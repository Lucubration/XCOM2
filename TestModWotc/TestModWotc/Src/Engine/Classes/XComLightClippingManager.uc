class XComLightClippingManager extends Actor
	transient
	native(GameEngine);

var native array<byte> Grid;
var native pointer GridData{BYTE};

var native int VoxelX;
var native int VoxelY;
var native int VoxelZ;

var native vector WorldMin;
var native vector TileSize;

var native pointer QuadTreeHead{struct FQuadTreeNode};

var native bool bLightClippingRunAtLeastOnce;
var native bool bCurrentlyBuilding;

var native array<PointLightComponent> AllLights;

struct native LightRebuildTasks
{
	var PointLightComponent Light;
	var TTile MinTiles;
	var TTile MaxTiles;
};

var native array<LightRebuildTasks> LightsNeedingRebuild;

cpptext
{
	struct DeferredTileUpdate
		{
			BYTE    *pGridData;
			BYTE    ClippingId;
		};

	virtual void BeginDestroy();

	virtual UBOOL Tick(FLOAT DeltaTime, enum ELevelTick TickType);

	void Build();
	void Initialize(const struct FXComWorldDataInfo& WorldDataInfo);
	void UpdateTiles(const TArray<struct FTTile>& TileList);
	
	void GatherLights(TArray<class UPointLightComponent*> &OutLights);
	void AssignIDToLight(struct LightDataInfo* pLight);

	void BuildLighting(const TArray<class UPointLightComponent*>& LightsToBuild, const FBox& UpdateBox);
	void BuildLightingDeferred(const TArray<class UPointLightComponent*>& LightsToBuild, const FBox& UpdateBox);

	void BuildLight(class UPointLightComponent* pLight, const FBoxSphereBounds& UpdateBoxSphere);
	void BuildLightDeferred(class UPointLightComponent* pLight, const FTTile& MinTiles, const FTTile& MaxTiles, TArray<DeferredTileUpdate> &TileUpdates);

	void UpdateTextureData();

	FVector CalculateTilePosition(INT X, INT Y, INT Z);
	struct FTTile CalculateTileFromPosition(FVector& Position);

	virtual void AddReferencedObjects(TArray<UObject*>& ObjectArray);
}

native function BuildFromScript();

defaultproperties
{	
	bLightClippingRunAtLeastOnce=false
	bCurrentlyBuilding=false
}