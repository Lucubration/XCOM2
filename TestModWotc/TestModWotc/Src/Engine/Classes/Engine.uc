//=============================================================================
// Engine: The base class of the global application object classes.
// Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
//=============================================================================
class Engine extends Subsystem
	native(GameEngine)
	abstract
	config(Engine)
	transient;

//Firaxis BEGIN
const MAX_SYNCRAND_SEED_TYPES = 10;
//Firaxis END

enum AlienFXColors
{
	eAlienFX_Cyan,
	eAlienFX_Red,
	eAlienFX_Yellow,
	eAlienFX_Orange,
};

// Fonts.
var private Font	TinyFont;
var globalconfig string TinyFontName;

var private Font	SmallFont;
var globalconfig string SmallFontName;

var private Font	MediumFont;
var globalconfig string MediumFontName;

var private Font	LargeFont;
var globalconfig string LargeFontName;

var private Font	SubtitleFont;
var globalconfig string SubtitleFontName;

var globalconfig vector ImageAdjustments1;
var globalconfig vector ImageAdjustments2;
var globalconfig vector ImageAdjustments3;

/** Any additional fonts that script may use without hard-referencing the font. */
var private array<Font>			AdditionalFonts;
var globalconfig array<string>	AdditionalFontNames;

/** The class to use for the game console. */
var class<Console> ConsoleClass;
var globalconfig string ConsoleClassName;

/** The class to use for the game viewport client. */
var class<GameViewportClient> GameViewportClientClass;
var globalconfig string GameViewportClientClassName;

/** The class to use for managing the global data stores */
var	class<DataStoreClient> DataStoreClientClass;
var	globalconfig string DataStoreClientClassName;

/** The class to use for local players. */
var class<LocalPlayer> LocalPlayerClass;
var config string LocalPlayerClassName;

/** The material used when no material is explicitly applied. */
var Material	DefaultMaterial;
var globalconfig string DefaultMaterialName;

// FIRAXIS Begin -sboeckmann
/** The material used for the border of the moveable area. */
var Material    MovementGridMaterial;
var globalconfig string MovementGridMaterialName;

var Material    MovementGridDotsMaterial;
var globalconfig string MovementGridDotsMaterialName;
// FIRAXIS End

/** The decal material used for fallback case of decals */
var Material	DefaultDecalMaterial;
var globalconfig string DefaultDecalMaterialName;

/** A global default texture. */
var Texture	DefaultTexture;
var globalconfig string DefaultTextureName;

/** A global default cube map texture. */
var TextureCube DefaultCubeMap;
var globalconfig string DefaultCubeMapName;

var TextureCube DefaultPreviewSceneCubeMap;
var globalconfig string DefaultPreviewSceneCubeMapName;

/** The wanted poster heads texture. */
var Texture2DArray HeadsTexture;
var globalconfig string HeadsTextureName;

/** The propaganda texture array */
var Texture2DArray PropagandaTexture;
var globalconfig string PropagandaTextureName;

/** Default propaganda Texture */
var Texture2D DefaultPropagandaTexture;
var globalconfig string DefaultPropagandaTextureName;

/** The material used to render wireframe meshes. */
var Material	WireframeMaterial;
var globalconfig string WireframeMaterialName;

/** A textured material with an instance parameter for the texture. */
var Material EmissiveTexturedMaterial;
var globalconfig string EmissiveTexturedMaterialName;

/** A translucent material used to render things in geometry mode. */
var Material	GeomMaterial;
var globalconfig string GeomMaterialName;

/** The default fog volume material */
var Material	DefaultFogVolumeMaterial;
var globalconfig string DefaultFogVolumeMaterialName;

/** Material used for drawing a tick mark. */
var Material	TickMaterial;
var globalconfig string TickMaterialName;

/** Material used for drawing a cross mark. */
var Material	CrossMaterial;
var globalconfig string CrossMaterialName;

/** Material used for visualizing level membership in lit viewport modes. */
var Material	LevelColorationLitMaterial;
var globalconfig string LevelColorationLitMaterialName;

/** Material used for visualizing level membership in unlit viewport modes. */
var Material	LevelColorationUnlitMaterial;
var globalconfig string LevelColorationUnlitMaterialName;

/** Material used for visualizing lighting only w/ lightmap texel density. */
var Material	LightingTexelDensityMaterial;
var globalconfig string LightingTexelDensityName;

/** Material used for visualizing level membership in lit viewport modes. Uses shading to show axis directions. */
var Material	ShadedLevelColorationLitMaterial;
var globalconfig string ShadedLevelColorationLitMaterialName;

/** Material used for visualizing level membership in unlit viewport modes.  Uses shading to show axis directions. */
var Material	ShadedLevelColorationUnlitMaterial;
var globalconfig string ShadedLevelColorationUnlitMaterialName;

/** Material used to indicate that the associated BSP surface should be removed. */
var Material	RemoveSurfaceMaterial;
var globalconfig string RemoveSurfaceMaterialName;

/** Material that renders vertex colour as emissive. */
var Material	VertexColorMaterial;
var globalconfig string VertexColorMaterialName;

/** Material for visualizing vertex colors on meshes in the scene (color only, no alpha) */
var Material	VertexColorViewModeMaterial_ColorOnly;
var globalconfig string VertexColorViewModeMaterialName_ColorOnly;

/** Material for visualizing vertex colors on meshes in the scene (alpha channel as color) */
var Material	VertexColorViewModeMaterial_AlphaAsColor;
var globalconfig string VertexColorViewModeMaterialName_AlphaAsColor;

/** Material for visualizing vertex colors on meshes in the scene (red only) */
var Material	VertexColorViewModeMaterial_RedOnly;
var globalconfig string VertexColorViewModeMaterialName_RedOnly;

/** Material for visualizing vertex colors on meshes in the scene (green only) */
var Material	VertexColorViewModeMaterial_GreenOnly;
var globalconfig string VertexColorViewModeMaterialName_GreenOnly;

/** Material for visualizing vertex colors on meshes in the scene (blue only) */
var Material	VertexColorViewModeMaterial_BlueOnly;
var globalconfig string VertexColorViewModeMaterialName_BlueOnly;

/** Material used to render game stat heatmaps. */
var Material	HeatmapMaterial;
var globalconfig string HeatmapMaterialName;

/** Material used to render bone weights on skel meshes */
var Material BoneWeightMaterial;
var globalconfig string BoneWeightMaterialName;

/** Material used to render tangents on skel meshes */
var Material TangentColorMaterial;
var globalconfig string TangentColorMaterialName;

/** True if we should combine light/shadow maps together if they're very similar to one another */
var globalconfig bool bCombineSimilarMappings;

/** Maximum root mean square deviation of the image difference allowed for mappings to be combined.  Requires bCombineSimilarLightAndShadowMappings to be enabled. */
var globalconfig float MaxRMSDForCombiningMappings;

/** Size of the texture generated by ImageReflectionSceneCapture actors. */
var globalconfig int ImageReflectionTextureSize;

var globalconfig LinearColor LightingOnlyBrightness;

/** The colors used to render light complexity. */
var globalconfig array<color> LightComplexityColors;

/** The colors used to render shader complexity. */
var globalconfig array<LinearColor> ShaderComplexityColors;

/**
* Complexity limits for the various complexity viewmode combinations.
* These limits are used to map instruction counts to ShaderComplexityColors.
*/
var globalconfig float MaxPixelShaderAdditiveComplexityCount;

/** Range for the texture density viewmode. */
var globalconfig float MinTextureDensity;
var globalconfig float IdealTextureDensity;
var globalconfig float MaxTextureDensity;

/** Range for the lightmap density viewmode. */
/** Minimum lightmap density value for coloring. */
var globalconfig float MinLightMapDensity;
/** Ideal lightmap density value for coloring. */
var globalconfig float IdealLightMapDensity;
/** Maximum lightmap density value for coloring. */
var globalconfig float MaxLightMapDensity;
/** If TRUE, then render grayscale density. */
var globalconfig bool bRenderLightMapDensityGrayscale;
/** The scale factor when rendering grayscale density. */
var globalconfig float RenderLightMapDensityGrayscaleScale;
/** The scale factor when rendering color density. */
var globalconfig float RenderLightMapDensityColorScale;
/** The color to render vertex mapped objects in for LightMap Density view mode. */
var globalconfig linearcolor LightMapDensityVertexMappedColor;
/** The color to render selected objects in for LightMap Density view mode. */
var globalconfig linearcolor LightMapDensitySelectedColor;

struct native StatColorMapEntry
{
	var globalconfig float	In;
	var globalconfig color	Out;
};

struct native StatColorMapping
{
	var globalconfig string	StatName;
	var globalconfig array<StatColorMapEntry> ColorMap;
	var globalconfig bool DisableBlend;
};

var globalconfig array<StatColorMapping>	StatColorMappings;

/** A material used to render the sides of the builder brush/volumes/etc. */
var Material	EditorBrushMaterial;
var globalconfig string EditorBrushMaterialName;

/** PhysicalMaterial to use if none is defined for a particular object. */
var	PhysicalMaterial	DefaultPhysMaterial;
var globalconfig string DefaultPhysMaterialName;

/** Optional damage mapping for Apex destructbile actors */
var	ApexDestructibleDamageParameters    ApexDamageParams;
var globalconfig string	                ApexDamageParamsName;


/** The material used when terrain compilation is too complex. */
var Material	TerrainErrorMaterial;
var globalconfig string TerrainErrorMaterialName;
var globalconfig int TerrainMaterialMaxTextureCount;

/** This is the number of frames that are used between terrain tessellation re-calculations */
var globalconfig int TerrainTessellationCheckCount;
/**
 *	The radius from the view origin that terrain tessellation checks should be performed.
 *	If 0.0, every component will be checked for tessellation changes each frame.
 */
var globalconfig float TerrainTessellationCheckDistance;

/** OnlineSubsystem class to use for netplay */
var	class<OnlineSubsystem> OnlineSubsystemClass;
var globalconfig string DefaultOnlineSubsystemName;

/** FIRAXIS: Online Event Manager Setup -ttalley */
var string OnlineEventMgrClassName;
var const transient OnlineEventMgr OnlineEventManager;

/** Default engine post process chain used for the game and main editor view if none is specified in the WorldInfo  */
var private{private} PostProcessChain DefaultPostProcess;
var private{private} config string DefaultPostProcessName;

/** Default engine post process settings. */
var private{private} PostProcessSettingsObject DefaultPostProcessSettingsObj;
var private{private} config string DefaultPostProcessSettingsObjName;

/** post process chain used for skeletal mesh thumbnails */
var PostProcessChain ThumbnailSkeletalMeshPostProcess;
var config string ThumbnailSkeletalMeshPostProcessName;

/** post process chain used for particle system thumbnails */
var PostProcessChain ThumbnailParticleSystemPostProcess;
var config string ThumbnailParticleSystemPostProcessName;

/** post process chain used for material thumbnails */
var PostProcessChain ThumbnailMaterialPostProcess;
var config string ThumbnailMaterialPostProcessName;

/** post process chain used for rendering the UI */
var PostProcessChain DefaultUIScenePostProcess;
var config string DefaultUIScenePostProcessName;

/** Material used for drawing meshes when their collision is missing. */
var Material	DefaultUICaretMaterial;
var globalconfig string DefaultUICaretMaterialName;

/** Material used for visualizing the reflection scene captures on a surface */
var Material	SceneCaptureReflectActorMaterial;
var globalconfig string SceneCaptureReflectActorMaterialName;

/** Material used for visualizing the cube map scene captures on a mesh */
var Material	SceneCaptureCubeActorMaterial;
var globalconfig string SceneCaptureCubeActorMaterialName;

/** Texture used to get random opacity values per-pixel for screen-door fading */
var Texture2D ScreenDoorNoiseTexture;
var globalconfig string ScreenDoorNoiseTextureName;

/** Texture used to get random image grain values for post processing */
var Texture2D ImageGrainNoiseTexture;
var globalconfig string ImageGrainNoiseTextureName;

/** Texture used to get random angles per-pixel by the Branching PCF implementation */
var Texture2D RandomAngleTexture;
var globalconfig string RandomAngleTextureName;

/** Texture used to get random normals per-pixel */
var Texture2D RandomNormalTexture;
var globalconfig string RandomNormalTextureName;

/** Texture used to get random rotation per-pixel */
var Texture2D RandomMirrorDiscTexture;
var globalconfig string RandomMirrorDiscTextureName;

/** Texture used as a placeholder for terrain weight-maps to give the material the correct texture format. */
var Texture	WeightMapPlaceholderTexture;
var globalconfig string WeightMapPlaceholderTextureName;

/** Texture used for PreIntegrated BRDF lighting of SSS. */
var Texture PreIntegratedBRDFTexture;
var globalconfig string PreIntegratedBRDFTextureName;

// Firaxis BEGIN
// JMS - Area LUT used for MLAA
/** Texture containing precomputed areas for MLAA postprocess */
var Texture2D MLAAAreaLUTTexture;
var globalconfig string MLAAAreaLUTTextureName;

// RAM - added to support better looking terrain blending
/** Texture use as a default for high frequency filtering on the terrain's default low frequency linear blending */
var Texture	TerrainBlendNoiseDefaultTexture;
var globalconfig string TerrainBlendNoiseDefaultTextureName;
// Firaxis END

/** Texture used to display LightMapDensity */
var Texture2D LightMapDensityTexture;
var globalconfig string LightMapDensityTextureName;

/** Texture used to display LightMapDensity */
var Texture2D LightMapDensityNormal;
var globalconfig string LightMapDensityNormalName;

/** Default Bokeh Texture */
var Texture2D BokehTexture;
var globalconfig string BokehTextureName;

/** White noise sound */
var SoundNodeWave DefaultSound;
var globalconfig string DefaultSoundName;

/** Time in seconds (game time) we should wait between purging object references to objects that are pending kill */
var(Settings) config float TimeBetweenPurgingPendingKillObjects;

/** Skin Diffusion Profile Parameter values. Used to generate preintegrated BRDF texture. */
var globalconfig array<vector4> SkinDiffusionProfileParameters;

// Variables.

/** Abstract interface to platform-specific subsystems */
var const client							Client;

/** Viewports for all players in all game instances (all PIE windows, for example) */
var init array<LocalPlayer>					GamePlayers;

/** the viewport representing the current game instance */
var GameViewportClient				GameViewport;

/** Array of deferred command strings/ execs that get executed at the end of the frame */
var init array<string>	DeferredCommands;

var int TickCycles, GameCycles, ClientCycles;
var int TickCnt; // Increments every tick - FIRAXIS ADDITION
var transient bool bUseSound;

/** Whether to allow background level streaming. */
var(Settings) config bool bUseBackgroundLevelStreaming;

/** Flag for completely disabling subtitles for localized sounds. */
var(Settings) config bool bSubtitlesEnabled;

/** Flag for forcibly disabling subtitles even if you try to turn them back on they will be off */
var(Settings) config bool bSubtitlesForcedOff;

/** Whether to enable framerate smoothing.																		*/
var config	bool			bSmoothFrameRate;
/** Maximum framerate to smooth. Code will try to not go over via waiting.										*/
var config	float			MaxSmoothedFrameRate;
/** Minimum framerate smoothing will kick in.																	*/
var config	float			MinSmoothedFrameRate;

/** 
 * Whether we should check for more than N pawns spawning in a single frame.  
 * Basically, spawning pawns and all of their attachments can be slow.  And on consoles it
 * can be really slow.  If this bool is true we will display a 
 **/
var config bool bCheckForMultiplePawnsSpawnedInAFrame;

/** If bCheckForMultiplePawnsSpawnedInAFrame==TRUE, then we will check to see that no more than this number of pawns are spawned in a frame. **/
var config int NumPawnsAllowedToBeSpawnedInAFrame;

/**
 * Whether or not the simple lightmaps should be generated during lighting rebuilds.
 */
var globalconfig bool bShouldGenerateSimpleLightmaps;

/**
 *	Flag for forcing terrain to be 'static' (MinTessellationLevel = MaxTesselationLevel)
 *	Game time only...
 */
var(Settings) config bool bForceStaticTerrain;

/** Entry point for RemoteControl, the in-game UI for the exec system. */
var native pointer				RemoteControlExec{class FRemoteControlExec};

/** Pointer to a support class to handle mobile material emulation (created on demand) */
var native pointer				MobileMaterialEmulator{class FMobileMaterialEmulator};

// Color preferences.
var(Colors) color
	C_WorldBox,
	C_BrushWire,
	C_AddWire,
	C_SubtractWire,
	C_SemiSolidWire,
	C_NonSolidWire,
	C_WireBackground,
	C_ScaleBoxHi,
	C_VolumeCollision,
	C_BSPCollision,
	C_OrthoBackground,
	C_Volume,
	C_BrushShape,
	C_DefaultGrey;

/** Fudge factor for tweaking the distance based miplevel determination */
var(Settings)	float			StreamingDistanceFactor;

/** Class name of the scout to use for path building */
var const config string ScoutClassName;

/**
 * A transition type.
 */
enum ETransitionType
{
	TT_None,
	TT_Paused,
	TT_Loading,
	TT_Saving,
	TT_Connecting,
	TT_Precaching
};

/** The current transition type. */
var ETransitionType TransitionType;

/** The current transition description text. */
var string TransitionDescription;

/** The gametype for the destination map */
var string TransitionGameType;

/** Level of detail range control for meshes */
var config		float					MeshLODRange;
/** Force to CPU skinning only for skeletal mesh rendering */
var	config		bool					bForceCPUSkinning;
/** Whether to use post processing effects or not */
var	config		bool					bUsePostProcessEffects;
/** whether to send Kismet warning messages to the screen (via PlayerController::ClientMessage()) */
var config bool bOnScreenKismetWarnings;
/** whether kismet logging is enabled. */
var config bool bEnableKismetLogging;
/** whether mature language is allowed **/
var config bool bAllowMatureLanguage;
/** camera rotation (deg) beyond which occlusion queries are ignored from previous frame (because they are likely not valid) */
var config float CameraRotationThreshold;
/** camera movement beyond which occlusion queries are ignored from previous frame (because they are likely not valid) */
var config float CameraTranslationThreshold;
/** The amount of time a primitive is considered to be probably visible after it was last actually visible. */
var config float PrimitiveProbablyVisibleTime;
/** The percent of previously unoccluded primitives which are requeried every frame. */
var config float PercentUnoccludedRequeries;
/** Max screen pixel fraction where retesting when unoccluded is worth the GPU time. */
var config float MaxOcclusionPixelsFraction;
/** Maximum sphere radius of a primitive that should be given an occlusion query. */
var config float MaxOcclusionSphereRadius; // FIRAXIS ADDITION

/** Terrain collision viewing - If TRUE, overlay collion level else render it and overlay terrain. */
var config bool bRenderTerrainCollisionAsOverlay;

/** Do not use Ageia PhysX hardware */
var globalconfig bool bDisablePhysXHardwareSupport;

/** Whether to pause the game if focus is lost. */
var config bool bPauseOnLossOfFocus;

/** The most vertices a fluid surface can have.  The number of verts is clamped to avoid running out of memory and exposing driver bugs. */
var config int MaxFluidNumVerts;

/**
 *	Time limit (in milliseconds) for a fluid simulation update, to avoid spiraling into a bad
 *	feedback-loop with slower and slower framerate. This value is doubled in debug builds.
 */
var config float FluidSimulationTimeLimit;

/**
 *	The maximum allowed size to a ParticleEmitterInstance::Resize call.
 *	If larger, the function will return without resizing.
 */
var config int MaxParticleResize;
/**
*	If the resize request is larger than this, spew out a warning to the log
*/
var config int MaxParticleResizeWarn;
/**
 *	If TRUE, then perform particle size checks in non FINAL_RELEASE builds.
 */
var globalconfig bool bCheckParticleRenderSize;
/** The maximum amount of memory any single emitter is allowed to take for its vertices */
var config int MaxParticleVertexMemory;
var transient int MaxParticleSpriteCount;
var transient int MaxParticleSubUVCount;

/** The number of times to attempt the Begin*UP call before assuming the GPU is hosed	*/
var config int BeginUPTryCount;

/** Info about one note dropped in the map during PIE. */
struct native DropNoteInfo
{
	/** Location to create Note actor in edited level. */
	var vector	Location;
	/** Rotation to create Note actor in edited level. */
	var rotator	Rotation;
	/** Text to assign to Note actor in edited level. */
	var string	Comment;
};

/**  */
var transient array<DropNoteInfo>	PendingDroppedNotes;

/** Overridable class for cover mesh rendering in-game, used to get around the editoronly restrictions needed by the base CoverMeshComponent */
var globalconfig string DynamicCoverMeshComponentName;

/**
 * By default, each frame's initial scene color clear is disabled.
 * This flag can be toggled at runtime to enable clearing for development.
 */
var globalconfig const bool			bEnableColorClear;

/** Number of times to tick each client per second */
var globalconfig float				NetClientTicksPerSecond;

/**
 *	The largest step-size allowed for lens flare occlusion results
 *	before using the incremental step method.
 */
var globalconfig float				MaxTrackedOcclusionIncrement;
/**
 *	The incremental step size for the above.
 */
var globalconfig float				TrackedOcclusionStepSize;

/** Keeps track whether actors moved via PostEditMove and therefore constraint syncup should be performed. */
var transient bool bAreConstraintsDirty;

/** TRUE if the engine needs to perform a delayed global component reattach (really just for editor) */
var transient bool bHasPendingGlobalReattach;

/** Default color of selected objects in the level viewport (additive) */
var globalconfig LinearColor DefaultSelectedMaterialColor;

/** Default color of hovered objects in the level viewport (additive) */
var globalconfig LinearColor DefaultHoveredMaterialColor;

/** Color of selected objects in the level viewport (additive) */
var transient LinearColor SelectedMaterialColor;

/** Color of unselected objects in the level viewport (additive) */
var transient LinearColor UnselectedMaterialColor;

/** If TRUE, then disable OnScreenDebug messages. Can be toggled in real-time. */
var globalconfig	bool	bEnableOnScreenDebugMessages;
/** If TRUE, then disable the display of OnScreenDebug messages (used when running) */
var transient		bool	bEnableOnScreenDebugMessagesDisplay;

/** If TRUE, then skip drawing map warnings on screen even in non FINAL_RELEASE builds */
var globalconfig	bool	bSuppressMapWarnings;

/** If DevAbsorbFuncs logging is unsuppressed and _DEBUG is defined in native, functions listed in this array will not throw a warning when they are absorbed for not being simulated on clients.  Useful for functions like Tick, where this behaviour is intentional */
var globalconfig    array<name>     IgnoreSimulatedFuncWarnings;

/** if set, cook game classes into standalone packages (as defined in [Cooker.MPGameContentCookStandalone]) and load the appropriate
 * one at game time depending on the gametype specified on the URL
 * (the game class should then not be referenced in the maps themselves)
 */
var globalconfig bool bCookSeparateSharedMPGameContent;

/** determines whether AI logging should be processed or not */
var globalconfig bool bDisableAILogging;

/** Semaphore to control screen saver inhibitor thread access. */
var private{private} transient int ScreenSaverInhibitorSemaphore;

/** Thread preventing screen saver from kicking. Suspend most of the time. */
var private{private} transient pointer ScreenSaverInhibitor{FRunnableThread};

/** A global translation context handles simple translation scenarios. e.g. <Strings:A.B.C> */
var TranslationContext GlobalTranslationContext;

/** Enables normal map sampling when Lightmass is generating 'simple' light maps.  This increases lighting build time, but may improve quality when normal maps are used to represent curvature over a large surface area.  When this setting is disabled, 'simple' light maps will not take normal maps into account. */
var globalconfig bool bUseNormalMapsForSimpleLightMaps;

/** Timestamp for when a loading movie was started, based on appSeconds(). Cleared to 0.0 when no movies are playing anymore. */
var const transient double LoadingMovieStartTime;

/** determines if we should start the matinee capture as soon as the game loads */
var transient bool bStartWithMatineeCapture;

/** should we compress the capture */
var transient bool bCompressMatineeCapture;

/** the name of the matine that we want to record */
var transient string MatineeCaptureName;

/** The package name where the matinee belongs to */
var transient string MatineePackageCaptureName;

/** The visible levels that should be loaded when the matinee starts */
var transient string VisibleLevelsForMatineeCapture;

/** the fps of the matine that we want to record */
var transient int MatineeCaptureFPS;

/** The capture type 0 - AVI, 1 - Screen Shots */
var transient int MatineeCaptureType;

// FIRAXIS BEGIN
var transient bool bDontSilenceGameAudioDuringBink;  // We'll reset this to false after every bink, must set each time before playing a bink if you want it to be true
var transient bool bDontSilenceUserAudioDuringBink;  // We'll reset this to false after every bink, must set each time before playing a bink if you want it to be true
var transient bool bCinematicSoundEnabled;

var globalconfig float PercentageToConsiderFullyFocused;
// FIRAXIS END

//Firaxis BEGIN
var string ForceLevel_PIE;  //If the game is running using UE3's 'Play In Editor' functionality this holds the name of the map that is being edited

//RAM - transplanted online subsystem and DLC handling into the base engine so that we can get at it from the editor
/** The singleton online interface for all game code to use */
var const transient OnlineSubsystem OnlineSubsystem;

/** The singleton interface that enumerates available DLC */
var const transient DownloadableContentEnumerator DLCEnumerator;

/** The name of the class to use for the DLC enumeration */
var config string DownloadableContentEnumeratorClassName;

/** The singleton interface that manages the installation and removal of DLC */
var const transient DownloadableContentManager DLCManager;

/** The name of the class to use for the DLC manager */
var config string DownloadableContentManagerClassName;

//Random number generation
//========================
var int m_iSyncRandSeed;
var int m_iSeedOverride;
var int m_iLastInitSeed;
var int m_loadRandSeedRestore;
var bool ReinitSeedOnLoad;
//========================

// moved here from EditorEngine
var transient array<GroupActor> ActiveGroupActors;

// Max Resolution of the EnvMap Cube Captures
var int MaxEnvCubeResolution;

// Cubemap used to hold temporary cubemap filter data
var TextureRenderTargetCube CubeMapFilterDummyCube;

// Support for modders to indivdually replace instantiated class objects with their own. Only works for spawned or new'd objects.
struct native ModClassOverrideEntry
{
	var name BaseGameClass;
	var name ModClass;
};

var config array<ModClassOverrideEntry> ModClassOverrides;

// TRUE if auto testing was specified by command line
var bool bAutoTesting;
var string AutoTestClassName;
var string AutoTestSaveName;

// mapping of registered template manager class names to their manager objects
var native private Map_Mirror TemplateManagerMap {TMap<UClass*, UObject*>};

// map mirrors aren't exposed to the garbage collector, so we need this array to
// keep the manager objects alive
var private array<Object> TemplateManagers;

//Firaxis END

cpptext
{
	// Constructors.
	UEngine();
	void StaticConstructor();

	// UObject interface.
	virtual void FinishDestroy();

	// UEngine interface.
	virtual void Init();

	/**
	 * Called at shutdown, just before the exit purge.
	 */
	virtual void PreExit() {}

	virtual UBOOL Exec( const TCHAR* Cmd, FOutputDevice& Out=*GLog );
	virtual void Tick( FLOAT DeltaSeconds ) PURE_VIRTUAL(UEngine::Tick,);
	virtual void SetClientTravel( const TCHAR* NextURL, ETravelType TravelType ) PURE_VIRTUAL(UEngine::SetClientTravel,);
	virtual FLOAT GetMaxTickRate( FLOAT /*DeltaTime*/, UBOOL bAllowFrameRateSmoothing = TRUE );
	virtual void SetProgress( EProgressMessageType MessageType, const FString& Title, const FString& Message );

	/**
	 * Notifies when the game window gains or loses focus
	 * @param HasFocus TRUE if we have focus, FALSE otherwise
	 */
	virtual void OnWindowFocusChanged( UBOOL HasFocus );

#if DO_CHARTING
	/**
	 * Ticks the FPS chart.
	 *
	 * @param DeltaSeconds	Time in seconds passed since last tick.
	 */
	virtual void TickFPSChart( FLOAT DeltaSeconds );

	/**
	* Ticks the Memory chart.
	*
	* @param DeltaSeconds	Time in seconds passed since last tick.
	*/
	virtual void TickMemoryChart( FLOAT DeltaSeconds );

	/**
	 * Resets the FPS chart data.
	 */
	virtual void ResetFPSChart();

	/**
	 * Dumps the FPS chart information to the passed in archive.
	 *
	 * @param	bForceDump	Whether to dump even if FPS chart info is not enabled.
	 */
	virtual void DumpFPSChart( UBOOL bForceDump = FALSE );

	/** Dumps info on DistanceFactor used for rendering SkeletalMeshComponents during the game. */
	virtual void DumpDistanceFactorChart();

	/**
 	 * Resets the Memory chart data.
	 */
	virtual void ResetMemoryChart();

	/**
	 * Dumps the Memory chart information to various places.
	 *
	 * @param	bForceDump	Whether to dump even if no info has been captured yet (will force an update in that case).
	 */
	virtual void DumpMemoryChart( UBOOL bForceDump = FALSE );
	
private:
	/**
	 * Dumps the FPS chart information to HTML.
	 */
	virtual void DumpFPSChartToHTML( FLOAT TotalTime, FLOAT DeltaTime, INT NumFrames, UBOOL bOutputToGlobalLog );

	/**
	 * Dumps the FPS chart information to the log.
	 */
	virtual void DumpFPSChartToLog( FLOAT TotalTime, FLOAT DeltaTime, INT NumFrames );

	/**
	 * Dumps the FPS chart information to the special stats log file.
	 */
	virtual void DumpFPSChartToStatsLog( FLOAT TotalTime, FLOAT DeltaTime, INT NumFrames );

	/**
	 * Dumps the frame times information to the special stats log file.
	 */
	virtual void DumpFrameTimesToStatsLog( FLOAT TotalTime, FLOAT DeltaTime, INT NumFrames );

	/**
	 * Dumps the Memory chart information to HTML.
	 */
	virtual void DumpMemoryChartToHTML( FLOAT TotalTime, FLOAT DeltaTime, INT NumFrames, UBOOL bOutputToGlobalLog );

	/**
	 * Dumps the Memory chart information to the log.
	 */
	virtual void DumpMemoryChartToLog( FLOAT TotalTime, FLOAT DeltaTime, INT NumFrames );

	/**
	 * Dumps the Memory chart information to the special stats log file.
	 */
	virtual void DumpMemoryChartToStatsLog( FLOAT TotalTime, FLOAT DeltaTime, INT NumFrames );

#endif // DO_CHARTING

public:

	/**
	 * Spawns any registered server actors
	 */
	virtual void SpawnServerActors(void)
	{
	}

	/**
	 * Loads all Engine object references from their corresponding config entries.
	 */
	void InitializeObjectReferences();

	/**
	 * Construct a UNetDriver object based on an .ini setting
	 *
	 * @return The created NetDriver object, or NULL if it fails
	 */
	virtual class UNetDriver* ConstructNetDriver()
	{
		return NULL;
	}

	/**
	 * Clean up the GameViewport
	 */
	void CleanupGameViewport();

	/** Get some viewport. Will be GameViewport in game, and one of the editor viewport windows in editor. */
	virtual FViewport* GetAViewport();

	/**
	 * Allows the editor to accept or reject the drawing of wireframe brush shapes based on mode and tool.
	 */
	virtual UBOOL ShouldDrawBrushWireframe( class AActor* InActor ) { return TRUE; }

	/**
	 * Issued by code requesting that decals be reattached.
	 */
	virtual void IssueDecalUpdateRequest() {}

	/**
	 * Returns whether or not the map build in progressed was cancelled by the user.
	 */
	virtual UBOOL GetMapBuildCancelled() const
	{
		return FALSE;
	}

	/**
	 * Sets the flag that states whether or not the map build was cancelled.
	 *
	 * @param InCancelled	New state for the cancelled flag.
	 */
	virtual void SetMapBuildCancelled( UBOOL InCancelled )
	{
		// Intentionally empty.
	}

	/**
	 * Computes a color to use for property coloration for the given object.
	 *
	 * @param	Object		The object for which to compute a property color.
	 * @param	OutColor	[out] The returned color.
	 * @return				TRUE if a color was successfully set on OutColor, FALSE otherwise.
	 */
	virtual UBOOL GetPropertyColorationColor(class UObject* Object, FColor& OutColor);

	/** Uses StatColorMappings to find a color for this stat's value. */
	UBOOL GetStatValueColoration(const FString& StatName, FLOAT Value, FColor& OutColor);

	/**
	 * @return TRUE if selection of translucent objects in perspective viewports is allowed
	 */
	virtual UBOOL AllowSelectTranslucent() const
	{
		// The editor may override this to disallow translucent selection based on user preferences
		return TRUE;
	}

	virtual UBOOL AllowEmitterLightSpawning() const
	{
		return TRUE;
	}

	/**
	 * @return TRUE if only editor-visible levels should be loaded in Play-In-Editor sessions
	 */
	virtual UBOOL OnlyLoadEditorVisibleLevelsInPIE() const
	{
		// The editor may override this to apply the user's preference state
		return TRUE;
	}

	/**
	 * Enables or disables the ScreenSaver (PC only)
	 *
	 * @param bEnable	If TRUE the enable the screen saver, if FALSE disable it.
	 */
	void EnableScreenSaver( UBOOL bEnable );
	
	/**
	 * Get the index of the provided sprite category
	 *
	 * @param	InSpriteCategory	Sprite category to get the index of
	 *
	 * @return	Index of the provided sprite category, if possible; INDEX_NONE otherwise
	 */
	virtual INT GetSpriteCategoryIndex( const FName& InSpriteCategory )
	{
		// The editor may override this to handle sprite categories as necessary
		return INDEX_NONE;
	}

	/**
	 * Starts playing a loading movie from memory.
	 * Keeps track of the total time fullscreen movies are playing to cover loading.
	 *
	 * @param MovieName		Name of the movie to play in its entirety
	 */
	virtual void PlayLoadingMovie( const TCHAR* MovieName );

	 // FIRAXIS begin
	 /** handles an xcom channel message */
	 virtual UBOOL HandleFxsChannelMessage(UNetConnection* Connection, INT MessageType, class FInBunch& Bunch)
	 {
		return FALSE;
	 }

	 // returns the template manager, if any, that matches the specified manager class
	 template<class TemplateManagerClass>
	 TemplateManagerClass* GetTemplateManager() const 
	 { 
		UObject* const* FoundManager = TemplateManagerMap.Find(TemplateManagerClass::StaticClass());
		check(FoundManager && *FoundManager);
	 	return CastChecked<TemplateManagerClass>(*FoundManager);
	 };
	 // FIRAXIS end

	/**
	 * Creates the online subsystem that was specified in UEngine's
	 * OnlineSubsystemClass. This function is virtual so that licensees
	 * can provide their own version without modifying Epic code.
	 */
	virtual void InitOnlineSubsystem(void);

	/** 
	* Creates the specified objects for dealing with DLC.
	*/
	virtual void InitGameSingletonObjects(void) {}

	/**
	 * Returns the online subsystem object. Returns null if GEngine isn't a
	 * game engine
	 */
	static UOnlineSubsystem* GetOnlineSubsystem(void);

	/**
	 * @return the DLC enumerator, or null if GEngine isn't a game engine
	 */
	static UDownloadableContentEnumerator* GetDLCEnumerator(void);

	/**
	 * @return the DLC manager, or null if GEngine isn't a game engine
	 */
	static UDownloadableContentManager* GetDLCManager(void);

	virtual void LoadDynamicContent(const struct FURL& URL,UBOOL bAsync=FALSE) {}

	virtual void ActorDestroyedHandler(AActor* ActorBeingDestroyed) {}

	/**
	 * Used to query for the streamed level that is marked to use for PostProcess;
	 */
	void SetupWorldAmbientCubeFromStreamedLevels();

protected:
	/**
	 * Handles freezing/unfreezing of rendering
	 */
	virtual void ProcessToggleFreezeCommand()
	{
		// Intentionally empty.
	}

	/**
	 * Handles frezing/unfreezing of streaming
	 */
	 virtual void ProcessToggleFreezeStreamingCommand()
	 {
		// Intentionally empty.
	 }

	 /**
	  * Updates all physics constraint actor joint locations.
	  */
	 virtual void UpdateConstraintActors();

	 /**
	 * needs to be a class member due to access to protected UObject::GExclusiveResourceSizeMode
	 */
	 UBOOL ListParticleSystems(const TCHAR *Cmd, FOutputDevice &Ar);

}

// Begin FIRAXIS
native static final function SetSilenceGameAudioDuringBink(bool bSilence);
native static final function bool GetSilenceGameAudioDuringBink();
native static final function float GetEngineGamma();

native static final function SetCinematicSoundEnabled(bool bEnabled);
native static final function bool GetCinematicSoundEnabled();
// End FIRAXIS

/** @return the GIsEditor flag setting */
native static final function bool IsEditor();

/** @return the GIsGame flag is setting */
native static final function bool IsGame();

/**
 * Returns a pointer to the current world.
 */
native static final function WorldInfo GetCurrentWorldInfo();

/**
 * Returns version info from the engine
 */
native static final function string GetBuildDate();

/**
 * Returns the engine's default tiny font
 */
native static final function Font GetTinyFont();

/**
 * Returns the engine's default small font
 */
native static final function Font GetSmallFont();

/**
 * Returns the engine's default medium font
 */
native static final function Font GetMediumFont();

/**
 * Returns the engine's default large font
 */
native static final function Font GetLargeFont();

/**
 * Returns the engine's default subtitle font
 */
native static final function Font GetSubtitleFont();

/**
 * Returns the specified additional font.
 *
 * @param	AdditionalFontIndex		Index into the AddtionalFonts array.
 */
native static final function Font GetAdditionalFont(int AdditionalFontIndex);

/** @return whether we're currently running in splitscreen (more than one local player) */
native static final function bool IsSplitScreen();

/** @return whether we're currently running with stereoscopic 3D enabled */
native static final function bool IsStereoscopic3D();

/** @return the audio device (will be None if sound is disabled) */
native static final function AudioDevice GetAudioDevice();

/** @return Returns the name of the last movie that was played. */
native static final function string GetLastMovieName();


/**
 * Play one of the LoadMap loading movies as configured by ini file
 *
 * @return TRUE if a movie was played
 */
native function bool PlayLoadMapMovie(optional int Idx=INDEX_NONE); // FIRAXIS jboswell

/**
 * Stops the current movie
 *
 * @param bDelayStopUntilGameHasRendered If TRUE, the engine will delay stopping the movie until after the game has rendered at least one frame
 */
native static final function StopMovie(bool bDelayStopUntilGameHasRendered);

/**
 * Removes all overlays from displaying
 */
native static final function RemoveAllOverlays();

/**
 * Adds a text overlay to the movie
 *
 * @param Font Font to use to display (must be in the root set so this will work during loads)
 * @param Text Text to display
 * @param X X location in resolution-independent coordinates (ignored if centered)
 * @param Y Y location in resolution-independent coordinates
 * @param ScaleX Text horizontal scale
 * @param ScaleY Text vertical scale
 * @param bIsCentered TRUE if the text should be centered
 */
native static final function AddOverlay( Font Font, string Text, float X, float Y, float ScaleX, float ScaleY, bool bIsCentered );

/**
 * Adds a wrapped text overlay to the movie
 *
 * @param Font Font to use to display (must be in the root set so this will work during loads)
 * @param Text Text to display
 * @param X X location in resolution-independent coordinates (ignored if centered)
 * @param Y Y location in resolution-independent coordinates
 * @param ScaleX Text horizontal scale
 * @param ScaleY Text vertical scale
 * @param WrapWidth Number of pixels before text should wrap
 */
native static final function AddOverlayWrapped( Font Font, string Text, float X, float Y, float ScaleX, float ScaleY, float WrapWidth );

/**
 * returns GEngine
 */
native static final function Engine GetEngine();

/**
 * Returns the defualt post process chain (loading it if it has not yet been loaded)
 */
native static final function PostProcessChain GetDefaultPostProcessChain();

/**
 * Returns the defualt post process settings object (loading it if it has not yet been loaded)
 */
native static final function PostProcessSettingsObject GetDefaultPostProcessSettingsObject();

/**
 * Returns the post process chain to be used with the world.
 */
native static final function PostProcessChain GetWorldPostProcessChain();

/**
 * Adds a world location as a secondary view location for purposes of texture streaming.
 * Lasts one frame, or a specified number of seconds (for overriding locations only).
 *
 * @param InLoc					Location to add to texture streaming for this frame
 * @param InDirection           Direction of camera view (pass in FVector(0,0,0) to use normal distance based streaming)
 * @param BoostFactor			A factor that affects all streaming distances for this location. 1.0f is default. Higher means higher-resolution textures and vice versa.
 * @param bOverrideLocation		Whether this is an override location, which forces the streaming system to ignore all other locations
 * @param OverrideDuration		How long the streaming system should keep checking this location if bOverrideLocation is TRUE, in seconds. 0 means just for the next Tick.
 */
native final function AddTextureStreamingSlaveLoc(vector InLoc, vector InDirection, float BoostFactor, bool bOverrideLocation, float OverrideDuration);

/**
 * Serializes an object to a file (object pointers to non-always loaded objects are not supported)
 *
 * @param Obj The object to serialize
 * @param Pathname The path to the file to save
 * @param bIsSaveGame If TRUE, FILEWRITE_SaveGame will be used to create the file writer
 * @param Version A version number to save with the archive, so that we can safely fail when loading old versioned files
 *
 * @return TRUE if successful
 */
native static final function bool BasicSaveObject(Object Obj, string Pathname, bool bIsSaveGame, int Version);

/**
 * Loads an object from a file (saved with the BasicSaveObject function). It should already be
 * allocated just like the original object was allocated
 *
 * @param Obj The object to serialize
 * @param Pathname The path to the file to read and create the object from
 * @param bIsSaveGame If TRUE, FILEREAD_SaveGame will be used to create the file reader
 * @param Version A version number to match with the version saved in the archive, so that we can safely fail when loading old versioned files
 *
 * @return TRUE if successful
 */
native static final function bool BasicLoadObject(Object Obj, string Pathname, bool bIsSaveGame, int Version);

// FIRAXIS begin -tsmith
/**
 * Retrieve a environment variable from the system
 *
 * @param VariableName The name of the variable (ie "Path")
 */
native static final function string GetEnvironmentVariable(string VariableName);

/**
 * Return a string identifying the user thats logged in and the computer the game is running on.
 * NOTE: Only valid on PC platform.
 * 
 * @return String in the form of username@computername
 */
native static final function string GetUserNameComputerName();
// FIRAXIS end -tsmith

// FIRAXIS BEGIN sramsay
native static final function float GetAverageFPS();
native static final function float GetAverageMS();
// FIRAXIS END

// FIRAXIS BEGIN jboswell
// Both editor and normal engines need a content manager, but this is the only
// base class they have in common
native function Object GetContentManager();
native function CleanupDynamicContent();
// FIRAXIS END

/** Returns the global online subsytem pointer. This will be null for PIE */
native static final noexport function OnlineSubsystem GetOnlineSubsystem(); 

/** Returns the DLC enumerator object pointer. This will be null for PIE */
native static final noexport function DownloadableContentEnumerator GetDLCEnumerator();

/** Returns the DLC manager object pointer. This will be null for PIE */
native static final noexport function DownloadableContentManager GetDLCManager();

//Firaxis BEGIN
//RAM - support for profile settings in both editor engine and game engine
native function Object GetProfileSettings();

function CreateProfileSettings()
{	
}

//=======================================================================================
//X-Com 2 Refactoring
//
function CreateGameStateHistory();
native function Object GetGameStateHistory();
native function Object GetValidationGameStateHistory();
native function OnGameStateHistoryResetComplete();

native function Object GetGameStateNetworkManager();

native function Object GetEventManager();
native function Object GetSpawnManager();
native function Object GetCardManager();
native function Object GetBehaviorTreeManager();
native function Object GetAIJobManager();
native function Object GetAutoPlayManager();

native function Object GetCharacterPoolManager();

native function WriteSaveFile(string FilePath, string Description);

//Managers for dynamic map creation
native function Object GetParcelManager();
native function Object GetTacticalMissionManager();
native function Object GetEnvLightingManager();
native function Object GetMapManager();

// Reporting
native function ReportLevelLoadTime(FLOAT LoadTime);

static native final function class FindClassType(string FindClassName);

//Firaxis BEGIN
//RAM - return CDO given a class name
static native final function object FindClassDefaultObject(string ClassName);
//Firaxis END

// Our own Synchronous Rand functions
native static final function SetRandomSeeds(int iSeed);
native static final function int GetSyncSeed();
native static final function int SyncRand( int Max, string strFnName );
native static final function float SyncFRand( string strFnName );
native static final function vector SyncVRand( string strFnName );
native static final function int GetARandomSeed();
native static final function int GetLastInitSeed();

//This is added for us to hookup restoring value on load complete and map finished loading Chang You Wong 2015-7-24
native function ReinitializeValueOnLoadComplete();
native function SetLoadRandomSeedValue(int value);

// MP Game check
native function bool IsMultiPlayerGame();
native function bool IsSinglePlayerGame();

//=======================================================================================

native static final function bool IsRetailGame();
native static final function bool IsConsoleAllowed();
native static final function bool IsSteamBigPicture();

//Triggers the load of streaming maps that support the 'base' maps in X-Com. 
//Routes to XComMapManager, which decides which parcels, rooms, cinematic maps, etc. need to be loaded
native function SeamlessTravelDetermineAdditionalMaps();

//In situations where additional content loading is asynchronous, the async process can use this polling function to find out if 
//loading is done
native function bool SeamlessTravelSignalStageComplete(); 

//Returns a mod class if a mod has selected to override a base game class
native function Class GetModReplacementClass(Class OriginalClass);

// returns the automatically created singleton X2DataTemplateManager of the specified class
static native function Object GetTemplateManager(class TemplateManagerClass);

// returns the Ambient Color from the dynamic cube map (non-directional)
native function color GetNonDirectionalAmbientCubeLighting();
//Firaxis END

static native function SetCharacterLightRigsEnabled(bool bEnabled);


defaultproperties
{
	C_WorldBox=(R=0,G=0,B=40,A=255)
	C_BrushWire=(R=192,G=0,B=0,A=255)
	C_AddWire=(R=127,G=127,B=255,A=255)
	C_SubtractWire=(R=255,G=192,B=63,A=255)
	C_SemiSolidWire=(R=127,G=255,B=0,A=255)
	C_NonSolidWire=(R=63,G=192,B=32,A=255)
	C_WireBackground=(R=0,G=0,B=0,A=255)
	C_ScaleBoxHi=(R=223,G=149,B=157,A=255)
	C_VolumeCollision=(R=149,G=223,B=157,A=255)
	C_BSPCollision=(R=149,G=157,B=223,A=255)
	C_OrthoBackground=(R=163,G=163,B=163,A=255)
	C_Volume=(R=255,G=196,B=255,A=255)
	C_BrushShape=(R=128,G=255,B=128,A=255)
	C_DefaultGrey =(R=50,G=50,B=50,A=255)
	bUseSound=true

	MaxEnvCubeResolution=512
}
