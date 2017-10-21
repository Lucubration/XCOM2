/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class InstancedStaticMeshComponent extends StaticMeshComponent
	native(Mesh);

// NOTE: This object must have a total size that is a multiple of 16. Serialization errors occur otherwise.
struct immutablewhencooked native InstancedStaticMeshInstanceData
{
	var matrix Transform;
	var vector2d LightmapUVBias;
	var vector2d ConcealmentOpacity;
	var vector4 InstanceParameters; // Currently only the X variable is used. Passed into the shader instance instead of the HitID if bUseDebrisCulling is enabled.

	structcpptext
	{
		// Serialization
		friend FArchive& operator<<(FArchive& Ar, FInstancedStaticMeshInstanceData& InstanceData)
		{
			// @warning BulkSerialize: FInstancedStaticMeshInstanceData is serialized as memory dump
			// See TArray::BulkSerialize for detailed description of implied limitations.
			Ar << InstanceData.Transform << InstanceData.LightmapUVBias << InstanceData.ConcealmentOpacity;
			
			if( Ar.LicenseeVer() >= FXS_VER_INSTANCED_MESH_CHANGE )
				Ar << InstanceData.InstanceParameters;

			return Ar;
		}
	}
};

struct native InstancedStaticMeshMappingInfo
{
	var native pointer Mapping{class FInstancedStaticMeshStaticLightingTextureMapping};
	var native pointer Lightmap{class FInstancedLightMap2D};
	var texture2d LightmapTexture;
	var shadowmap2d ShadowmapTexture;	
};

/** Deprecated array of instances, script serialized */
var deprecated array<InstancedStaticMeshInstanceData> PerInstanceData;

/** Array of instances, bulk serialized */
var native array<InstancedStaticMeshInstanceData> PerInstanceSMData;

/** Number of pending lightmaps still to be calculated (Apply()'d) */
var transient int NumPendingLightmaps;

/**
 * A key for deciding which components are compatible when joining components together after a lighting build. 
 * Will default to the staticmesh pointer when SetStaticMesh is called, so this must be set after calling
 * SetStaticMesh on the component
 */
var int ComponentJoinKey;

/** The mappings for all the instances of this component */
var transient array<InstancedStaticMeshMappingInfo> CachedMappings;

/** Value used to seed the random number stream that generates random numbers for each of this mesh's instances.
	The random number is stored in a buffer accessible to materials through the PerInstanceRandom expression.  If
	this is set to zero (default), it will be populated automatically by the editor */
var() int InstancingRandomSeed;

/** Distance from camera at which each instance begins to fade out */
var(Culling) int InstanceStartCullDistance;

/** Distance from camera at which each instance completely fades out */
var(Culling) int InstanceEndCullDistance;

var bool       bUseDebrisCulling;

/** One bit per instance to show selection in the editor */
var editoronly native const BitArray_Mirror SelectedInstances{TBitArray<>};

cpptext
{
	virtual FPrimitiveSceneProxy* CreateSceneProxy();
	virtual void UpdateBounds();
	virtual void GetStaticLightingInfo(FStaticLightingPrimitiveInfo& OutPrimitiveInfo,const TArray<ULightComponent*>& InRelevantLights,const FLightingBuildOptions& Options);

	void UpdateInstances();
	void ApplyAllMappings();
	
	static TSet<AActor*> ActorsWithInstancedComponents;
	static void UpdateVisibleInstancesForActor(AActor* InActor); // FIRAXIS

	virtual void GetLightAndShadowMapMemoryUsage( INT& LightMapMemoryUsage, INT& ShadowMapMemoryUsage ) const;

	/**
	 * Serialize function.
	 *
	 * @param	Ar	Archive to serialize with
	 */
	virtual void Serialize(FArchive& Ar);

	/**
	 * Returns whether or not this component is instanced.
	 *
	 * @return	TRUE if this component represents multiple instances of a primitive.
	 */
	virtual UBOOL IsInstanced() const
	{
		return TRUE;
	}

	/**
	 * For instanced components, returns the number of instances.
	 *
	 * @return	Number of instances
	 */
	virtual INT GetInstanceCount() const
	{
		return PerInstanceSMData.Num();
	}

	/**
	 * Returns whether this primitive should render selection.
	 */
	virtual UBOOL ShouldRenderSelected() const
	{
		return UPrimitiveComponent::ShouldRenderSelected()
#if WITH_EDITORONLY_DATA
		// Also render selected if we have an array of selected instances
		|| SelectedInstances.Num() > 0
#endif
		;
	}

	/**
	 * For instanced components, returns the Local -> World transform for the specific instance number.
	 * If the function is called on non-instanced components, the component's LocalToWorld will be returned.
	 * You should override this method in derived classes that support instancing.
	 *
	 * @param	InInstanceIndex	The index of the instance to return the Local -> World transform for
	 *
	 * @return	Number of instances
	 */
	virtual const FMatrix GetInstanceLocalToWorld( INT InInstanceIndex ) const
	{
		return PerInstanceSMData( InInstanceIndex ).Transform * LocalToWorld;
	}

	virtual void InitComponentRBPhys(UBOOL bFixed);

	// FIRAXIS BEGIN
	//  JMS - interface to types that have extended per-instance data
	virtual void ClearInstanceBitfields() { return; }

	virtual TArray<INT> GetInstanceBitfields() { return TArray<INT>(); }

	virtual void AddInstanceBitfield( int nBitfield ) { return; }

	virtual void UpdateVisibleInstances() { return; }

	// Return the number of visible instances. 
	virtual INT GetVisibleInstanceCount() const { return PerInstanceSMData.Num(); }
	// FIRAXIS END


#if STATS
	/**
	 * Called after all objects referenced by this object have been serialized. Order of PostLoad routed to 
	 * multiple objects loaded in one set is not deterministic though ConditionalPostLoad can be forced to
	 * ensure an object has been "PostLoad"ed.
	 */
	virtual void PostLoad();

	/**
	 * Informs object of pending destruction via GC.
	 */
	void BeginDestroy();

	/**
	 * Attaches the component to a ParentToWorld transform, owner and scene.
	 * Requires IsValidComponent() == true.
	 */
	virtual void Attach();

	/**
	 * Detaches the component from the scene it is in.
	 * Requires bAttached == true
	 *
	 * @param bWillReattach TRUE is passed if Attach will be called immediately afterwards.  This can be used to
	 *                      preserve state between reattachments.
	 */
	virtual void Detach( UBOOL bWillReattach = FALSE );

#endif
}

