/**
 * SceneCaptureCubeMapComponent
 *
 * Allows a scene capture to up to 6 2D texture render targets
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class X2SceneCaptureEnvMapComponent extends SceneCaptureCubeMapComponent
	dependson(KMeshProps)
	hidecategories(SceneCaptureCubeMapComponent,Capture)
	native;

enum EnvMapCaptureState
{
	eEMCS_Off,
	eEMCS_Registered,
	eEMCS_Capture
};
var transient EnvMapCaptureState CaptureState;

struct native VolumeToTileMap
{
	var array<byte> DataMap;
	var vector TileStart;
	var vector TileExtent;
};

var transient VolumeToTileMap VolumeMapping;

var transient bool bEnableLocalEnvMap;
var private const transient native pointer EnvMapInfo{FEnvMapSceneInfo};

var() bool bUserEnabled;

var() TextureCube PreMadeTextureCube;
var() float fDiffuseIntensity;
var() float fSpecularIntensity;

var() bool bParallaxCorrected<DisplayName=ParallaxCorrected>;

/* Cubemap Filtering Data */
var bool bIsFilteringCubeMap;
var int iFilteringCubeMapFace;

enum SpecQuality
{
	eSQ_SuperLow,
	eSQ_Low,
	eSQ_Medium,
	eSQ_High,
	eSQ_Cinematic
};

var() SpecQuality eSpecQuality;

var bool bUseAsWorldAmbient;

/* Variable used to modify the diffuse of a character when outside in dark areas. Material needs to be set to one of
	MLM_SubsurfaceScattering or MLM_ClearCoat, or needs to have the UseForCharacterLightingMod flag checked. 
	This variable has no effect on local capture actors. 
*/
var() float CharacterDiffuseModifier;

/* Variable used to modify the specular of a character when outside in dark areas. Material needs to be set to one of
	MLM_SubsurfaceScattering or MLM_ClearCoat, or needs to have the UseForCharacterLightingMod flag checked. 
	This variable has no effect on local capture actors.
*/
var() float CharacterSpecularModifier;

cpptext 
{
private:
	void RenderMipFace_RenderThread(INT Mip, INT Face);

protected:

	// UActorComponent interface.
	virtual void Attach();
	virtual void Detach( UBOOL bWillReattach );

public:

	void Init();

	virtual FEnvMapSceneInfo* CreateSceneInfo() {return NULL;}

	virtual void UpdateVolumeData() {}

	virtual void UpdateTransform();
	virtual void UpdateComponent(FSceneInterface* InScene,AActor* InOwner,const FMatrix& InLocalToWorld, UBOOL bCollisionUpdate=FALSE);	

	virtual void GetVolumes(TArray<AVolume*>& OutVolumes) {}

	virtual void Tick(FLOAT DeltaTime);

	void RenderCubeMap();
	void BeginFiltering();
	void EndFiltering();

	UINT GetResolution();

	virtual UBOOL IsPositionInVolumes(const FVector&) { return FALSE; }
}

defaultproperties
{
	ViewMode=SceneCapView_Lit
	bForceNoClear=false // FIRAXIS
	bForceNoResolve=false // FIRAXIS
	bIsXComEdgeCapture=false // FIRAXIS
	bDynamicOnly=false // FIRAXIS
	ClearColor=(R=0,G=0,B=0,A=255)
	FrameRate=0
	bEnabled=false
	MaxViewDistanceOverride=0.0
	bSkipRenderingDepthPrepass=false
	m_nRenders=0 // FIRAXIS addition jshopf
	ColorWriteMask=eCaptureWriteMask_RGBA
	m_fConstrainedAspectRatio=-1;
	NearPlane = 20
	FarPlane = 0
	bEnableFog = true
	bEnablePostProcess = true
	bEnableSSReflections = false
	bEnableAmbient = false
	PostProcess = none//PostProcessChain'XComEngineMaterials.AmbientCapture_PostProcessChain'

	CaptureState = eEMCS_Off

	bUseAsWorldAmbient = false
	fDiffuseIntensity = 1.0f
	fSpecularIntensity = 1.0f
	bParallaxCorrected = false
	eSpecQuality = eSQ_Medium

	CharacterDiffuseModifier = 1.0f
	CharacterSpecularModifier = 1.0f

	bIsFilteringCubeMap = false
	iFilteringCubeMapFace = 0;

	bUserEnabled=true
}
