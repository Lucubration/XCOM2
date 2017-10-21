/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class StaticMeshComponent extends MeshComponent
	native(Mesh)
	noexport
	hidecategories(Object)
	dependson(LightmassPrimitiveSettingsObject)
	editinlinenew;


/** If 0, auto-select LOD level. if >0, force to (ForcedLodModel-1). */
var() int		ForcedLodModel; 
/** Dictate which LOD level casts static shadows. */
var() int       ShadowCastingLODLevel; // FIRAXIS ADDITION
var int			PreviousLODLevel; // Previous LOD level

var() const StaticMesh StaticMesh;
var() const StaticMesh StencilMesh; // Firaxis Addition mgiordano - TODO(JDB): This could be removed, but I'm leaving it for fear of versioning woes...
var() Color WireframeColor;


/** This is a flag used to indicate whether the irrelevant lights array has been reset since the light build. */
var transient bool bIrrelevantLightsCleared; // FIRAXIS ADDITION

var transient bool bSetLocalAmbientCubemap; //Firaxis - indicate whether we have created our own local MIC for applying the local ambient cubemap

// allows the static mesh to ignore the TRACE_ComplexCollision flag when the TRACE_ConditionalComplexCollision is also set
var() bool bAllowIgnoreComplexCollision <Tooltip="Allow static mesh to ignore it's complex collision in certain gameplay circumstances (like grenade arc tracing)">; // FIRAXIS ADDITION

/**
 *	Ignore this instance of this static mesh when calculating streaming information.
 *	This can be useful when doing things like applying character textures to static geometry,
 *	to avoid them using distance-based streaming.
 */
var()	bool	bIgnoreInstanceForTextureStreaming;

/** Deprecated. Replaced by 'bOverrideLightMapRes'. */
var deprecated const bool bOverrideLightMapResolution;

/** Whether to override the lightmap resolution defined in the static mesh. */
var() const bool bOverrideLightMapRes;

/** Deprecated. Replaced by 'OverriddenLightMapRes'. */
var deprecated const int OverriddenLightMapResolution;

/** Light map resolution used if bOverrideLightMapRes is TRUE */
var() const int	 OverriddenLightMapRes;

/** With the default value of 0, the LODMaxRange from the UStaticMesh will be used to control LOD transitions, otherwise this value overrides. */
var() float OverriddenLODMaxRange;

/**
 * Allows adjusting the desired streaming distance of streaming textures that uses UV 0.
 * 1.0 is the default, whereas a higher value makes the textures stream in sooner from far away.
 * A lower value (0.0-1.0) makes the textures stream in later (you have to be closer).
 */
var()	float	StreamingDistanceMultiplier;

var() const bool StaticLightingHiddenByDefault; //FIRAXIS

/** Subdivision step size for static vertex lighting.				*/
var const int	SubDivisionStepSize;
/** Whether to use subdivisions or just the triangle's vertices.	*/
var const bool bUseSubDivisions;
/** if True then decals will always use the fast path and will be treated as static wrt this mesh */
var const transient bool bForceStaticDecals;
/** Whether or not we can highlight selected sections - this should really only be done in the editor */
var transient bool bCanHighlightSelectedSections;

/** Whether or not to use the optional simple lightmap modification texture */
var(MobileSettings) bool bUseSimpleLightmapModifications;

enum ELightmapModificationFunction
{
	/** Lightmap.RGB * Modification.RGB */
	MLMF_Modulate,
	/** Lightmap.RGB * (Modification.RGB * Modification.A) */
	MLMF_ModulateAlpha,
};

/** The texture to use when modifying the simple lightmap texture */
var(MobileSettings) editoronly texture SimpleLightmapModificationTexture <EditCondition=bUseSimpleLightmapModifications>;

/** The function to use when modifying the simple lightmap texture */
var(MobileSettings) ELightmapModificationFunction SimpleLightmapModificationFunction <EditCondition=bUseSimpleLightmapModifications>;

/** Never become dynamic, even if my mesh has bCanBecomeDynamic=true */
var(Physics) bool bNeverBecomeDynamic;

var const array<Guid>	IrrelevantLights;

/** Cached vertex information at the time the mesh was painted. */
struct PaintedVertex
{
	var vector Position;
	var packednormal Normal;
	var color Color;
};

struct StaticMeshComponentLODInfo
{
	var private const array<ShadowMap2D> ShadowMaps;
	var private const array<Object> ShadowVertexBuffers;
	var native private const pointer LightMap{FLightMap};

	/** Vertex colors to use for this mesh LOD */
	var private native const pointer OverrideVertexColors{FColorVertexBuffer_Mirror};
	var private native const pointer OverrideVertexUVs{FUVVertexBuffer_Mirror};
	var private native const pointer OverrideVertexTangetX{ FTangentXVertexBuffer_Mirror };
	
	/** Vertex data cached at the time this LOD was painted, if any */
	var private const array<PaintedVertex> PaintedVertices;
};

/** Static mesh LOD data.  Contains static lighting data along with instanced mesh vertex colors. */
var native serializetext private const array<StaticMeshComponentLODInfo> LODData;

// FIRAXIS BEGIN
enum ESwapMeshState
{
	SWAPMESH_None,
	SWAPMESH_Damaged,
	SWAPMESH_Destroyed,
	SWAPMESH_Num_States
};

/** Points to the static meshes that may be used for mesh swapping */
var const native pointer SwapStaticMeshes[2]{UStaticMesh};

/** Static swap mesh data.  Contains static lighting data along with instanced mesh vertex colors. */
var native StaticMeshComponentLODInfo SwapMeshData[2]; 
// FIRAXIS END

/** Incremented any time the position of vertices from the source mesh change, used to determine if an update from the source static mesh is required */
var private const int VertexPositionVersionNumber;

/** The Lightmass settings for this object. */
var(Lightmass) LightmassPrimitiveSettings	LightmassSettings <ScriptOrder=true>;

/** Finds the swap mesh state that uses NewMesh and swaps LOD Info between the SMC and the stored swap mesh data */
simulated native function bool SwapStaticMeshLODInfos( StaticMesh NewMesh, optional bool bReuseOriginalLightmap = false ); // FIRAXIS ADDITION

/** Change the StaticMesh used by this instance. */
simulated native function bool SetStaticMesh( StaticMesh NewMesh, optional bool bForce );

/** Disables physics collision between a specific pair of primitive components. */
simulated native function DisableRBCollisionWithSMC( PrimitiveComponent OtherSMC, bool bDisabled );

/**
 * Changes the value of bForceStaticDecals.
 * @param bInForceStaticDecals - The value to assign to bForceStaticDecals.
 */
native final function SetForceStaticDecals(bool bInForceStaticDecals);

/**
 * Returns an FString of the path of the Static Mesh.
 */
native function string GetStaticMeshPath();

/**
 * @RETURNS true if this mesh can become dynamic
 */
native function bool CanBecomeDynamic();

/*
 * Sets up the local ambient map if the object needs it
 */
native function bool SetupLocalAmbientMap();

defaultproperties
{
	// Various physics related items need to be ticked pre physics update
	TickGroup=TG_PreAsyncWork

	ShadowCastingLODLevel=0 // FIRAXIS ADDITION
	bIrrelevantLightsCleared=FALSE;
	CollideActors=True
	BlockActors=True
	BlockZeroExtent=True
	BlockNonZeroExtent=True
	BlockRigidBody=True
	WireframeColor=(R=0,G=255,B=255,A=255)
	bAcceptsStaticDecals=TRUE
	bAcceptsDecals=TRUE
	bOverrideLightMapResolution=FALSE // FIRAXIS jboswell
	OverriddenLightMapResolution=0
	bOverrideLightMapRes=FALSE
	OverriddenLightMapRes=64	
	bUsePrecomputedShadows=FALSE
	SubDivisionStepSize=32
	bUseSubDivisions=TRUE
	bForceStaticDecals=FALSE
	bCanHighlightSelectedSections=false;
	StreamingDistanceMultiplier=1.0
	CanBlockCamera=true // FIRAXIS jboswell
	StaticLightingHiddenByDefault=false; // FIRAXIS
	bCastStaticShadow=TRUE
}
