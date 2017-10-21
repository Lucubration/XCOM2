/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Material extends MaterialInterface
	native(Material)
	hidecategories(object);

// Material input structs.

struct MaterialInput
{
	/** Material expression that this input is connected to, or NULL if not connected. */
	var MaterialExpression	Expression;

	/** Index into Expression's outputs array that this input is connected to. */
	var int					OutputIndex;

	/** 
	 * Optional name of the input.  
	 * Note that this is the only member which is not derived from the output currently connected. 
	 */
	var string				InputName;
	var int					Mask,
							MaskR,
							MaskG,
							MaskB,
							MaskA;
	var int					GCC64_Padding; // @todo 64: if the C++ didn't mismirror this structure (with ExpressionInput), we might not need this
};

struct ColorMaterialInput extends MaterialInput
{
	var bool	UseConstant;
	var color	Constant;
};

struct ScalarMaterialInput extends MaterialInput
{
	var bool	UseConstant;
	var float	Constant;
};

struct VectorMaterialInput extends MaterialInput
{
	var bool	UseConstant;
	var vector	Constant;
};

struct Vector2MaterialInput extends MaterialInput
{
	var bool	UseConstant;
	var float	ConstantX,
				ConstantY;
};

// FIRAXIS begin
// Material Editor background mesh information
var			string		BackgroundMesh;
var			vector		BackgroundPosition;
var			rotator		BackgroundRotation;
var			float		BackgroundScale;
var			vector		BackgroundScale3D;
// FIRAXIS end

// Physics.

/** Physical material to use for this graphics material. Used for sounds, effects etc.*/
var(PhysicalMaterial) PhysicalMaterial		PhysMaterial;

/** For backwards compatibility only. */
var class<PhysicalMaterial>	PhysicalMaterial;

/** A 1 bit monochrome texture that represents a mask for what physical material should be used if the collided texel is black or white. */
var(PhysicalMaterial)	Texture2D	PhysMaterialMask;				
/** The UV channel to use for the PhysMaterialMask. */
var(PhysicalMaterial)	INT	PhysMaterialMaskUVChannel;
/** The physical material to use when a black pixel in the PhysMaterialMask texture is hit. */
var(PhysicalMaterial)	PhysicalMaterial BlackPhysicalMaterial;
/** The physical material to use when a white pixel in the PhysMaterialMask texture is hit. */
var(PhysicalMaterial)	PhysicalMaterial WhitePhysicalMaterial;

// Reflection.

//NOTE: If any additional inputs are added/removed WxMaterialEditor::GetVisibleMaterialParameters() must be updated
var ColorMaterialInput		DiffuseColor;
var ScalarMaterialInput		DiffusePower;
var ColorMaterialInput		SpecularColor;
var ScalarMaterialInput		Roughness;
var ScalarMaterialInput     Cavity;
var VectorMaterialInput		Normal;
var ScalarMaterialInput     NormalOpacity;
var VectorMaterialInput     AnisotropicDirection;

// Emission.

var ColorMaterialInput		EmissiveColor;

// Transmission.

var ScalarMaterialInput		Opacity;
var ScalarMaterialInput		OpacityMask;

/** If BlendMode is BLEND_Masked or BLEND_SoftMasked, the surface is not rendered where OpacityMask < OpacityMaskClipValue. */
var() float OpacityMaskClipValue;

/** Can be used to bias shadows away from the surface. */
var(Misc) float ShadowDepthBias;

/** Allows the material to distort background color by offsetting each background pixel by the amount of the distortion input for that pixel. */
var VectorMaterialInput	Distortion;

/** Determines how the material's color is blended with background colors. */
var() EBlendMode BlendMode;

//FIRAXIS CHANGE
/** Determines how inputs are combined to create the material's final color. */
var()   EMaterialLightingModel EditorLightingModel;
var     EMaterialLightingModel LightingModel;

var()   ETransLightingType      TransLightingType;

/** Set this flag if this material is used with a character and that character needs to have lighting modified
	by the world ambient diff and spec.
*/
var(Usage)	bool					UseForCharacterLightingMod;

/** Set this flag to on to use the old Roughness Conversion. */
var(Usage)	bool					UseOldRoughness;
//FIRAXIS END

/** 
 * Use a custom light transfer equation to be factored with light color, attenuation and shadowing. 
 * This is currently only used for Movable, Toggleable and Dominant light contribution.
 * LightVector can be used in this material input and will be set to the tangent space light direction of the current light being rendered.
 */
var ColorMaterialInput		CustomLighting;

/** 
 * Use a custom diffuse factor for attenuation with lights that only support a diffuse term. 
 * This should only be the diffuse color coefficient, and must not depend on LightVector.
 * This is currently used with skylights, SH lights, materials exported to lightmass and directional lightmap contribution.
 */
var ColorMaterialInput		CustomSkylightDiffuse;

/** Lerps between lighting color (diffuse * attenuation * Lambertian) and lighting without the Lambertian term color (diffuse * attenuation * TwoSidedLightingColor). */
var ScalarMaterialInput		TwoSidedLightingMask;

/** Modulates the lighting without the Lambertian term in two sided lighting. */
var ColorMaterialInput		TwoSidedLightingColor;

/** Adds to world position in the vertex shader. */
var VectorMaterialInput		WorldPositionOffset;

/** Offset in tangent space applied to tessellated vertices.  A scalar connected to this input will be treated as the z component (float3(0,0,x)). */
var VectorMaterialInput		WorldDisplacement;

/** Multiplies the tessellation factors applied when a tessellation mode is set. */
var ScalarMaterialInput		TessellationMultiplier;

/** Scalar value indicating the curvature of the model */
var ScalarMaterialInput     SubsurfaceCurvature;

/** Clear coat Roughness. */
var VectorMaterialInput     ClearCoat;

/** Indicates that the material should be rendered with subsurface scattering. */
var(D3D11) bool EnableSubsurfaceScattering <bShowOnlyWhenTrue=bShowD3D11Properties>;

/** Indicates that the material should be rendered with subsurface scattering. */
var(D3D11) bool EnableClothScatter <bShowOnlyWhenTrue=bShowD3D11Properties>;

/** Indicates that the material should be rendered in the SeparateTranslucency Pass (does not affect bloom, not affected by DOF). */
var(D3D11) bool EnableSeparateTranslucency <bShowOnlyWhenTrue=bShowD3D11Properties>;

/** Indicates that the material should be rendered with antialiasing. Opacity is evaluated multiple times (for each MSAA sample). */
var(D3D11) bool bEnableMaskedAntialiasing <bShowOnlyWhenTrue=bShowD3D11Properties>;

/** Indicates that the material should be rendered without backface culling and the normal should be flipped for backfaces. */
var() bool TwoSided;

//FIRAXIS BEGIN
/** Indicates if this material should render shadows with the default material. */
var() bool UseDefaultShadow;
//FIRAXIS END

/** Add a cubemap reflection. */
var (Translucency) bool AddReflection;

/** Use a specific predefined cubemap (only works if AddReflection is true)*/
var(Translucency)  TextureCube OverrideCubemap;

/** Indicates that the material should be rendered in its own pass. Used for hair renderering */
var(Translucency) bool TwoSidedSeparatePass;

/**
 * Allows the material to disable depth tests, which is only meaningful with translucent blend modes.
 * Disabling depth tests will make rendering significantly slower since no occluded pixels can get zculled.
 */
var(Translucency) bool bDisableDepthTest;

/** 
 * If enabled and this material reads from scene texture, this material will be rendered behind all other translucency, 
 * Instead of the default behavior for materials that read from scene texture, which is for them to render in front of all other translucency in the same DPG.
 * This is useful for placing large spheres around a level that read from scene texture to do chromatic aberration.
 */
var(Translucency) bool bSceneTextureRenderBehindTranslucency;

// FIRAXIS Begin - mgiordano
/**
 * Allows the material to enable depth writing, which is only meaningful with translucent blend modes.
 */
var(Translucency) bool bEnableDepthWrite; //Firaxis Change - JW

/**
 * Used in conjuncion with disabling depth testing. If true, the primitive's occlusion will always be rendered.
 * Forcing occlusion rendering causes the object to be rendered each frame, even when fully occluded.
 */
var(Translucency) bool bForceOcclusion; 
// FIRAXIS End

/** Whether the material should allow fog or be unaffected by fog.  This only has meaning for materials with translucent blend modes. 
 *	NOTE: If the material is translucent and has a UMaterialExpressionSceneTexture node, this variable can't be toggled.
 */
var(Translucency) bool bAllowFog;
var(Translucency) bool bForceFog;

/** Translucent materials that sample from scene color will ignore FOW by default. This flag will override that behavior. 
 *	This only has meaning for materials with translucent blend modes that sample from scene color. 
 */
var(Translucency) bool bForceSceneColorFOW;

/** 
 * Whether the material should receive dynamic dominant light shadows from static objects when the material is being lit by a light environment. 
 * This is useful for character hair.
 */
var(Translucency) bool bTranslucencyReceiveDominantShadowsFromStatic;

/** 
 * Whether the material should inherit the dynamic shadows that dominant lights are casting on opaque and masked materials behind this material.
 * This is useful for ground meshes using a translucent blend mode and depth biased alpha to hide seams.
 */
var(Translucency) bool bTranslucencyInheritDominantShadowsFromOpaque;

/** Whether the material should allow Depth of Field or be unaffected by DoF.  This only has meaning for materials with translucent blend modes. */
var(Translucency) bool bAllowTranslucencyDoF;

var(Translucency) bool bForceNonHalfResTranslucency;

/**
 * Whether the material should use one-layer distortion, which can be cheaper than normal distortion for some primitive types (mainly fluid surfaces).
 * One layer distortion won't handle overlapping one layer distortion primitives correctly.
 * This causes an extra scene color resolve for the first primitive that uses one layer distortion and so should only be used in very specific circumstances.
 */
var(Translucency) bool bUseOneLayerDistortion;

/** If this is set, a depth-only pass for will be rendered for solid (A=255) areas of dynamic lit translucency primitives. This improves hair sorting at the extra render cost. */
var(Translucency) bool bUseLitTranslucencyDepthPass;

// FIRAXIS BEGIN - EP
/** THE "Use Lit Translucency Depth Pass" CHECKBOX MUST ALSO BE SET FOR THIS TO WORK!  If both checkboxes are checked, then this overrides and ignores the clip operation
 *  that applies to pixels with opacity less than 1.  The final result with these two checkboxes is translucent front most faces (and only front most faces)
 *  of a mesh that has the specified opacity.
 */
var(Translucency) bool bUseLitTranslucencyDepthPassNoClipFXS;
// FIRAXIS END

/** If this is set, a depth-only pass for will be rendered for any visible (A>0) areas of dynamic lit translucency primitives. This is necessary for correct fog and DoF of hair */
var(Translucency) bool bUseLitTranslucencyPostRenderDepthPass;

/** Whether to treat the material's opacity channel as a mask rather than fractional translucency in dynamic shadows. */
var(Translucency) bool bCastLitTranslucencyShadowAsMasked;

// FIRAXIS BEGIN
/** Forces the translucency object to render in the normal translucency pass, before the post process. (Grabs FOW from opaque depth) */
var(Translucency) bool bForceRenderBeforeFOW;
/** Prevents the material from being affected by the have seen tint color in the FOW */

enum EHaveSeenFOWStyle
{
	EHVF_Normal<DisplayName=Normal>,
	EHVF_FullVisible<DisplayName = VisbleInHaveSeen>,
	EHVF_Invisible<DisplayName = HiddenInHaveSeen>,
	EHVF_AlwaysVisibleInFOW<DisplayName = VisibleInFOW>
};

var deprecated bool bForceNoHaveSeenFOW;
var(Translucency) EHaveSeenFOWStyle ForceNoHaveSeenFOW<DisplayName=TranslucentFOW>;

/** If true, this material is used with the 3D UI and should be rendered after gamma correction. */
var(Translucency) bool bIs3DUI;
// FIRAXIS END

var(MutuallyExclusiveUsage) const bool bUsedAsLightFunction;
/** Indicates that the material is used on fog volumes.  This usage flag is mutually exclusive with all other mesh type usage flags! */
var(MutuallyExclusiveUsage) const bool bUsedWithFogVolumes;

// BEGIN FIRAXIS
var (Vertex) bool bUnwrappedSpaceFXS;
var (Vertex) bool bFOWTextureFXS;
/** Use the particle position (instead of vertex position) as world position */
var (Vertex) bool bParticleVertexOffsetPositionFXS;
/** Variable indicating if this material is using vertex offset */
var          bool bUsedWithVertexOffset;
var (Vertex) bool bParticleSpriteFaceCamera;
// END FIRAXIS

/** 
 * This is a special usage flag that allows a material to be assignable to any primitive type.
 * This is useful for materials used by code to implement certain viewmodes, for example the default material or lighting only material.
 * The cost is that nearly 20x more shaders will be compiled for the material than the average material, which will greatly increase shader compile time and memory usage.
 * This flag should only be set when absolutely necessary, and is purposefully not exposed to the UI to prevent abuse.
 */
var duplicatetransient const bool bUsedAsSpecialEngineMaterial;
/** 
 * Indicates that the material and its instances can be assigned to skeletal meshes.  
 * This will result in the shaders required to support skeletal meshes being compiled which will increase shader compile time and memory usage.
 */
var(Usage) const bool bUsedWithSkeletalMesh;
var(Usage) const bool bUsedWithTerrain;
var(Usage) const bool bUsedWithFracturedMeshes;
var		   const bool bUsedWithParticleSystem;
var(Usage) const bool bUsedWithParticleSprites;
var(Usage) const bool bUsedWithBeamTrails;
var(Usage) const bool bUsedWithParticleSubUV;
var(Usage) const bool bUsedWithSpeedTree;
var(Usage) const bool bUsedWithStaticLighting;
var(Usage) const bool bUsedWithLensFlare;
var(Usage) const bool bUsedWithMovementGrid; //FIRAXIS Addition
/* If any particle system usage flag is on, this must be true if you plan to use the material on a static mesh or a mesh particle. You do not need to check it if no particle system flags are on. */
var(Usage) const bool bUsedWithStaticMeshes; // FIRAXIS Addition
var(Usage) const bool bUsedWithFoliage; // FIRAXIS Addition
/** 
 * Gamma corrects the output of the base pass using the current render target's gamma value. 
 * This must be set on materials used with UIScenes to get correct results.
 */
var(Usage) const bool bUsedWithGammaCorrection;
/** Enables instancing for mesh particles.  Use the "Vertex Color" node when enabled, not "MeshEmit VertColor." */
var(Usage) const bool bUsedWithInstancedMeshParticles;
var(Usage) const bool bForceNoParticleMeshInstancing;
var(Usage) const bool bUsedWithFluidSurfaces;
/** WARNING: bUsedWithDecals is mutually exclusive with all other mesh type usage flags!  A material with bUsedWithDecals=true will not work on any other mesh type. */
var(MutuallyExclusiveUsage) const bool bUsedWithDecals;
var(Usage) const bool bUsedWithMaterialEffect;
var(Usage) const bool bUsedWithMorphTargets;
var(Usage) const bool bUsedWithRadialBlur;
var(Usage) const bool bUsedWithInstancedMeshes;
var(Usage) const bool bUsedWithDebrisInstancedMeshes;
var(Usage) const bool bUsedWithSplineMeshes;
var(Usage) const bool bUsedWithAPEXMeshes;

/** Enables support for screen door fading for primitives rendering with this material.  This adds an extra texture lookup and a few extra instructions. */
var(Usage) const bool bUsedWithScreenDoorFade; 

/** The type of tessellation to apply to this object.  Note D3D11 required for anything except MTM_NoTessellation. */
var(D3D11) const EMaterialTessellationMode D3D11TessellationMode <bShowOnlyWhenTrue=bShowD3D11Properties>;

/** Prevents cracks in the surface of the mesh when using tessellation. */
var(D3D11) const bool bEnableCrackFreeDisplacement <bShowOnlyWhenTrue=bShowD3D11Properties>;

// FIRAXIS BEGIN
/** This must be enabled on materials used for Doors and Windows, but never enabled on other materials. Don't ever touch this unless you know what you're doing. */
var(Usage) const bool bUsedWithDoorsOrWindows; 
/** This must be enabled on materials used on primitives that use the cutout functionality **/
var(Usage) bool bCutoutMaskFXS;
/** This flag should be used ONLY on unlit materials. At this time it is reserved only for alien shields */
var(Usage) bool bTranslucencyCutdown;
// FIRAXIS END

/** 
 * Replaces analytical phong specular highlights on this material with an image based reflection,
 * Specified by the ImageReflection actors placed in the world.  Only works in D3D11.
 */
var(D3D11) bool bUseImageBasedReflections <bShowOnlyWhenTrue=bShowD3D11Properties>;

/** Values larger than 1 dampen the normal used for image reflections, values smaller than 1 exaggerate the normal used for image reflections. */
var(D3D11) float ImageReflectionNormalDampening  <bShowOnlyWhenTrue=bShowD3D11Properties>;

var(Misc) bool Wireframe;

/** When enabled, the camera vector will be computed in the pixel shader instead of the vertex shader which may improve the quality of the reflection.  Enabling this setting also allows VertexColor expressions to be used alongside Transform expressions. */
var(Misc) bool bPerPixelCameraVector;

/** Controls whether lightmap specular will be rendered or not.  Can be disabled to reduce instruction count. */
var(Misc) bool bAllowLightmapSpecular;

/** Indicates that the material will be used as a fallback on sm2 platforms */
var deprecated bool bIsFallbackMaterial;

// indexed by EMaterialShaderPlatform
// Only the first entry is ever used now that SM2 is no longer supported, 
// But the member is kept as an array to make adding future material platforms easier.  
// The second entry is to work around the script compile error from having an array with one element.
var const native duplicatetransient pointer MaterialResources[2]{FMaterialResource};

// second is used when selected
var const native duplicatetransient pointer DefaultMaterialInstances[3]{class FDefaultMaterialInstance};

var int		EditorX,
			EditorY,
			EditorPitch,
			EditorYaw;

/** Array of material expressions, excluding Comments.  Used by the material editor. */
var array<MaterialExpression>			Expressions;

/** Array of comments associated with this material; viewed in the material editor. */
var editoronly array<MaterialExpressionComment>	EditorComments;

/** Stores information about a function that this material references, used to know when the material needs to be recompiled. */
struct native MaterialFunctionInfo
{
	/** Id that the function had when this material was last compiled. */
	var guid StateId;
	
	/** The function which this material has a dependency on. */
	var MaterialFunction Function;
};

/** Array of all functions this material depends on. */
var array<MaterialFunctionInfo> MaterialFunctionInfos;

var native map{FName, TArray<UMaterialExpression*>} EditorParameters;

/** TRUE if Material uses distortion */
var private bool						bUsesDistortion;

/** TRUE if Material is masked and uses custom opacity */
var private bool						bIsMasked;

/** TRUE if Material is the preview material used in the material editor. */
var transient duplicatetransient private bool bIsPreviewMaterial;

/** Legacy texture references, now handled by FMaterial. */
var deprecated private const array<texture> ReferencedTextures;

var private const editoronly array<guid> ReferencedTextureGuids;

var(OutputMask) const bool bMaskedOutput;
var(OutputMask) const bool bOutputDiffuse;
var(OutputMask) const bool bOutputEmissive;
var(OutputMask) const bool bOutputSpecular;
var(OutputMask) const bool bOutputRoughness;
var(OutputMask) const bool bOutputNormals;

cpptext
{
	// Constructor.
	UMaterial();

	/** @return TRUE if the material uses distortion */
	UBOOL HasDistortion() const;
	/** @return TRUE if the material uses the scene color texture */
	UBOOL UsesSceneColor() const;

	UBOOL UsesXComDitherMask() const;

	// FIRAXIS Begin - mgiordano
	// Return TRUE if the material uses the occlusion percentage material expression
	UBOOL UsesOcclusionPercentage() const;
	// FIRAXIS End

	/**
	 * Allocates a material resource off the heap to be stored in MaterialResource.
	 */
	virtual FMaterialResource* AllocateResource(UBOOL bInOverrideParentTwoSided = FALSE);

	/** Returns the textures used to render this material for the given platform. */
	virtual void GetUsedTextures(TArray<UTexture*> &OutTextures, EMaterialShaderPlatform Platform = MSP_BASE, UBOOL bAllPlatforms = FALSE);

	/**
	* Checks whether the specified texture is needed to render the material instance.
	* @param Texture	The texture to check.
	* @return UBOOL - TRUE if the material uses the specified texture.
	*/
	virtual UBOOL UsesTexture(const UTexture* Texture);

	/**
	 * Overrides a specific texture (transient)
	 *
	 * @param InTextureToOverride The texture to override
	 * @param OverrideTexture The new texture to use
	 */
	virtual void OverrideTexture( UTexture* InTextureToOverride, UTexture* OverrideTexture );

private:

	/** Sets the value associated with the given usage flag. */
	void SetUsageByFlag(EMaterialUsage Usage, UBOOL NewValue);

	//virtual void OverridePrecisionForTextureInputs(UMaterialExpression* pMainExpression);

public:

	/** Gets the name of the given usage flag. */
	FString GetUsageName(EMaterialUsage Usage) const;

	/** Gets the value associated with the given usage flag. */
	virtual UBOOL GetUsageByFlag(EMaterialUsage Usage);

	/**
	 * Checks if the material can be used with the given usage flag.
	 * If the flag isn't set in the editor, it will be set and the material will be recompiled with it.
	 * @param Usage - The usage flag to check
	 * @return UBOOL - TRUE if the material can be used for rendering with the given type.
	 */
	virtual UBOOL CheckMaterialUsage(EMaterialUsage Usage);

	/**
	 * Sets the given usage flag.
	 * @param bNeedsRecompile - TRUE if the material was recompiled for the usage change
	 * @param Usage - The usage flag to set
	 * @return UBOOL - TRUE if the material can be used for rendering with the given type.
	 */
	UBOOL SetMaterialUsage(UBOOL &bNeedsRecompile, EMaterialUsage Usage);

	/**
	 * @param	OutParameterNames		Storage array for the parameter names we are returning.
	 * @param	OutParameterIds			Storage array for the parameter id's we are returning.
	 *
	 * @return	Returns a array of parameter names used in this material for the specified expression type.
	 */
	template<typename ExpressionType>
	void GetAllParameterNames(TArray<FName> &OutParameterNames, TArray<FGuid> &OutParameterIds);
	
	void GetAllVectorParameterNames(TArray<FName> &OutParameterNames, TArray<FGuid> &OutParameterIds);
	void GetAllScalarParameterNames(TArray<FName> &OutParameterNames, TArray<FGuid> &OutParameterIds);
	void GetAllTextureParameterNames(TArray<FName> &OutParameterNames, TArray<FGuid> &OutParameterIds);
	void GetAllFontParameterNames(TArray<FName> &OutParameterNames, TArray<FGuid> &OutParameterIds);
	void GetAllStaticSwitchParameterNames(TArray<FName> &OutParameterNames, TArray<FGuid> &OutParameterIds);
	void GetAllStaticComponentMaskParameterNames(TArray<FName> &OutParameterNames, TArray<FGuid> &OutParameterIds);
	void GetAllNormalParameterNames(TArray<FName> &OutParameterNames, TArray<FGuid> &OutParameterIds);
	void GetAllTerrainLayerWeightParameterNames(TArray<FName> &OutParameterNames, TArray<FGuid> &OutParameterIds);

	//FIRAXIS ADDITION
	virtual void GetAllBooleanParameterNames(TArray<FName> &OutParameterNames, TArray<FGuid> &OutParameterIds);
	//FIRAXIS END
	/**
	 * Attempts to find a expression by its GUID.
	 *
	 * @param InGUID GUID to search for.
	 *
	 * @return Returns a expression object pointer if one is found, otherwise NULL if nothing is found.
	 */
	template<typename ExpressionType>
	ExpressionType* FindExpressionByGUID(const FGuid &InGUID)
	{
		ExpressionType* Result = NULL;

		for(INT ExpressionIndex = 0;ExpressionIndex < Expressions.Num();ExpressionIndex++)
		{
			ExpressionType* ExpressionPtr =
				Cast<ExpressionType>(Expressions(ExpressionIndex));

			if(ExpressionPtr && ExpressionPtr->ExpressionGUID.IsValid() && ExpressionPtr->ExpressionGUID==InGUID)
			{
				Result = ExpressionPtr;
				break;
			}
		}

		return Result;
	}

	// UMaterialInterface interface.

	/**
	 * Get the material which this is an instance of.
	 * Warning - This is platform dependent!  Do not call GetMaterial(GCurrentMaterialPlatform) and save that reference,
	 * as it will be different depending on the current platform.  Instead call GetMaterial(MSP_BASE) to get the base material and save that.
	 * When getting the material for rendering/checking usage, GetMaterial(GCurrentMaterialPlatform) is fine.
	 *
	 * @param Platform - The platform to get material for.
	 */
	virtual UMaterial* GetMaterial(EMaterialShaderPlatform Platform = GCurrentMaterialPlatform);
    virtual UBOOL GetParameterDesc(FName ParameterName, FString& OutDesc);
    virtual UBOOL GetVectorParameterValue(FName ParameterName,FLinearColor& OutValue);
    virtual UBOOL GetScalarParameterValue(FName ParameterName,FLOAT& OutValue);
	virtual UBOOL GetBooleanParameterValue(FName ParameterName,UBOOL& OutValue); //FIRAXIS ADDITION
    virtual UBOOL GetTextureParameterValue(FName ParameterName,class UTexture*& OutValue);
	virtual UBOOL GetFontParameterValue(FName ParameterName,class UFont*& OutFontValue,INT& OutFontPage);
	/**
	* Retrieves name of group from Material Expression to be used for grouping in Material Instance Editor 
	*
	* @param ParameterName	    Name of parameter to retrieve
	* @param OutDesc		    Group name to be filled
	* @return				    True if successful	 
	*/
	virtual UBOOL GetGroupName(FName ParameterName, FName& OutDesc);
	/**
	 * Gets the value of the given static switch parameter
	 *
	 * @param	ParameterName	The name of the static switch parameter
	 * @param	OutValue		Will contain the value of the parameter if successful
	 * @return					True if successful
	 */
	virtual UBOOL GetStaticSwitchParameterValue(FName ParameterName,UBOOL &OutValue,FGuid &OutExpressionGuid);

	/**
	* Sets the default of the given static switch parameter.
	* NOTE:  Does not add the parameter if it does not exist
	*
	* @param	ParameterName	The name of the static switch parameter
	* @param	InValue			The value to set
	* @return					True if successful
	*/
	virtual UBOOL SetStaticSwitchParameterValue(FName ParameterName, UBOOL &InValue);

	/**
	 * Gets the value of the given static component mask parameter
	 *
	 * @param	ParameterName	The name of the parameter
	 * @param	R, G, B, A		Will contain the values of the parameter if successful
	 * @return					True if successful
	 */
	virtual UBOOL GetStaticComponentMaskParameterValue(FName ParameterName, UBOOL &R, UBOOL &G, UBOOL &B, UBOOL &A, FGuid &OutExpressionGuid);

	/**
	* Gets the compression format of the given normal parameter
	*
	* @param	ParameterName	The name of the parameter
	* @param	CompressionSettings	Will contain the values of the parameter if successful
	* @return					True if successful
	*/
	virtual UBOOL GetNormalParameterValue(FName ParameterName, BYTE& OutCompressionSettings, FGuid &OutExpressionGuid);

	/**
	* Gets the weightmap index of the given terrain layer weight parameter
	*
	* @param	ParameterName	The name of the parameter
	* @param	OutWeightmapIndex	Will contain the values of the parameter if successful
	* @return					True if successful
	*/
	virtual UBOOL GetTerrainLayerWeightParameterValue(FName ParameterName, INT& OutWeightmapIndex, FGuid &OutExpressionGuid);

	virtual FMaterialRenderProxy* GetRenderProxy(UBOOL Selected, UBOOL bHovered=FALSE) const;
	virtual UPhysicalMaterial* GetPhysicalMaterial() const;

	/**
	 * Compiles a FMaterialResource on the given platform with the given static parameters
	 *
	 * @param StaticParameters - The set of static parameters to compile for
	 * @param StaticPermutation - The resource to compile
	 * @param Platform - The platform to compile for
	 * @param MaterialPlatform - The material platform to compile for
	 * @param bFlushExistingShaderMaps - Indicates that existing shader maps should be discarded
	 * @return TRUE if compilation was successful or not necessary
	 */
	UBOOL CompileStaticPermutation(
		FStaticParameterSet* StaticParameters,
		FMaterialResource* StaticPermutation,
		EShaderPlatform Platform,
		EMaterialShaderPlatform MaterialPlatform,
		UBOOL bFlushExistingShaderMaps,
		UBOOL bDebugDump,
		UBOOL bForceUniformExpressionRegen);

	/**
	 * Compiles material resources for the current platform if the shader map for that resource didn't already exist.
	 *
	 * @param ShaderPlatform - platform to compile for
	 * @param bFlushExistingShaderMaps - forces a compile, removes existing shader maps from shader cache.
	 * @param bForceAllPlatforms - compile for all platforms, not just the current.
	 */
	void CacheResourceShaders(EShaderPlatform Platform, UBOOL bFlushExistingShaderMaps=FALSE, UBOOL bForceAllPlatforms=FALSE);

private:
	/**
	 * Flushes existing resource shader maps and resets the material resource's Ids.
	 */
	virtual void FlushResourceShaderMaps();

	/** 
	 * Rebuilds the MaterialFunctionInfos array with the current state of the material's function dependencies,
	 * And updates any function call nodes in this material so their inputs and outputs stay valid.
	 */
	void RebuildMaterialFunctionInfo();

public:
	/**
	 * Gets the material resource based on the input platform
	 * @return - the appropriate FMaterialResource if one exists, otherwise NULL
	 */
	virtual FMaterialResource* GetMaterialResource(EMaterialShaderPlatform Platform = GCurrentMaterialPlatform);

	/** === USurface interface === */
	/**
	 * Method for retrieving the width of this surface.
	 *
	 * This implementation returns the maximum width of all textures applied to this material - not exactly accurate, but best approximation.
	 *
	 * @return	the width of this surface, in pixels.
	 */
	virtual FLOAT GetSurfaceWidth() const;
	/**
	 * Method for retrieving the height of this surface.
	 *
	 * This implementation returns the maximum height of all textures applied to this material - not exactly accurate, but best approximation.
	 *
	 * @return	the height of this surface, in pixels.
	 */
	virtual FLOAT GetSurfaceHeight() const;

	// UObject interface.
	/**
	 * Called before serialization on save to propagate referenced textures. This is not done
	 * during content cooking as the material expressions used to retrieve this information will
	 * already have been dissociated via RemoveExpressions
	 */
	void PreSave();

	virtual void AddReferencedObjects(TArray<UObject*>& ObjectArray);
	virtual void Serialize(FArchive& Ar);
	virtual void PostDuplicate();
	virtual void PostLoad();
	virtual void PreEditChange(UProperty* PropertyAboutToChange);
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	virtual void BeginDestroy();
	virtual UBOOL IsReadyForFinishDestroy();
	virtual void FinishDestroy();

	/**
	 * @return		Sum of the size of textures referenced by this material.
	 */
	virtual INT GetResourceSize();

	/**
	 * Null any material expression references for this material
	 *
	 * @param bRemoveAllExpressions If TRUE, the function will remove every expression and uniform expression from the material and its material resources
	 */
	void RemoveExpressions(UBOOL bRemoveAllExpressions=FALSE);

	UBOOL IsFallbackMaterial() 
	{ 
		return bIsFallbackMaterial_DEPRECATED; 
	}

	/**
	 * Goes through every material, flushes the specified types and re-initializes the material's shader maps.
	 */
	static void UpdateMaterialShaders(TArray<FShaderType*>& ShaderTypesToFlush, TArray<const FVertexFactoryType*>& VFTypesToFlush);

	/**
	 * Adds an expression node that represents a parameter to the list of material parameters.
	 *
	 * @param	Expression	Pointer to the node that is going to be inserted if it's a parameter type.
	 */
	virtual UBOOL AddExpressionParameter(UMaterialExpression* Expression);

	/**
	 * Removes an expression node that represents a parameter from the list of material parameters.
	 *
	 * @param	Expression	Pointer to the node that is going to be removed if it's a parameter type.
	 */
	virtual UBOOL RemoveExpressionParameter(UMaterialExpression* Expression);

	/**
	 * A parameter with duplicates has to update its peers so that they all have the same value. If this step isn't performed then
	 * the expression nodes will not accurately display the final compiled material.
	 *
	 * @param	Parameter	Pointer to the expression node whose state needs to be propagated.
	 */
	virtual void PropagateExpressionParameterChanges(UMaterialExpression* Parameter);

	/**
	 * This function removes the expression from the editor parameters list (if it exists) and then re-adds it.
	 *
	 * @param	Expression	The expression node that represents a parameter that needs updating.
	 */
	virtual void UpdateExpressionParameterName(UMaterialExpression* Expression);

	/**
	 * Iterates through all of the expression nodes in the material and finds any parameters to put in EditorParameters.
	 */
	virtual void BuildEditorParameterList();

	/**
	 * Returns TRUE if the provided expression parameter has duplicates.
	 *
	 * @param	Expression	The expression parameter to check for duplicates.
	 */
	virtual UBOOL HasDuplicateParameters(UMaterialExpression* Expression);

	/**
	 * Returns TRUE if the provided expression dynamic parameter has duplicates.
	 *
	 * @param	Expression	The expression dynamic parameter to check for duplicates.
	 */
	virtual UBOOL HasDuplicateDynamicParameters(UMaterialExpression* Expression);

	/**
	 * Iterates through all of the expression nodes and fixes up changed names on
	 * matching dynamic parameters when a name change occurs.
	 *
	 * @param	Expression	The expression dynamic parameter.
	 */
	virtual void UpdateExpressionDynamicParameterNames(UMaterialExpression* Expression);

	/**
	 * Gets the name of a parameter.
	 *
	 * @param	Expression	The expression to retrieve the name from.
	 * @param	OutName		The variable that will hold the parameter name.
	 * @return	TRUE if the expression is a parameter with a name.
	 */
	static UBOOL GetExpressionParameterName(UMaterialExpression* Expression, FName& OutName);

	/**
	 * Copies the values of an expression parameter to another expression parameter of the same class.
	 *
	 * @param	Source			The source parameter.
	 * @param	Destination		The destination parameter that will receive Source's values.
	 */
	static UBOOL CopyExpressionParameters(UMaterialExpression* Source, UMaterialExpression* Destination);

	/**
	 * Returns TRUE if the provided expression node is a parameter.
	 *
	 * @param	Expression	The expression node to inspect.
	 */
	static UBOOL IsParameter(UMaterialExpression* Expression);

	/**
	 * Returns TRUE if the provided expression node is a dynamic parameter.
	 *
	 * @param	Expression	The expression node to inspect.
	 */
	static UBOOL IsDynamicParameter(UMaterialExpression* Expression);

	/**
	 * Returns the number of parameter groups. NOTE: The number returned can be innaccurate if you have parameters of different types with the same name.
	 */
	inline INT GetNumEditorParameters() const
	{
		return EditorParameters.Num();
	}

	/**
	 * Empties the editor parameters for the material.
	 */
	inline void EmptyEditorParameters()
	{
		EditorParameters.Empty();
	}

	/**
	 * Returns the lookup texture to be used in the physical material mask.  Tries to get the parents lookup texture if not overridden here. 
	 */
	virtual UTexture2D* GetPhysicalMaterialMaskTexture() const { return PhysMaterialMask; }

	/**
	 * Returns the black physical material to be used in the physical material mask.  Tries to get the parents black phys mat if not overridden here
	 */
	virtual UPhysicalMaterial* GetBlackPhysicalMaterial() const { return BlackPhysicalMaterial; }

	/**
	 * Returns the white physical material to be used in the physical material mask.  Tries to get the parents white phys mat if not overridden here. 
	 */
	virtual UPhysicalMaterial* GetWhitePhysicalMaterial() const { return WhitePhysicalMaterial; }

	/** 
	 * Returns the UV channel that should be used to look up physical material mask information 
	 */
	virtual INT GetPhysMaterialMaskUVChannel() const { return PhysMaterialMaskUVChannel; }

	virtual UBOOL IsMaskedOutput() const { return bMaskedOutput; }
	virtual UBOOL ShouldOutputDiffuse() const { return !bMaskedOutput || bOutputDiffuse; }
	virtual UBOOL ShouldOutputEmissive() const { return !bMaskedOutput || bOutputEmissive; }
	virtual UBOOL ShouldOutputSpecular() const { return !bMaskedOutput || bOutputSpecular; }
	virtual UBOOL ShouldOutputRoughness() const { return !bMaskedOutput || bOutputRoughness; }
	virtual UBOOL ShouldOutputNormals() const { return !bMaskedOutput || bOutputNormals; }

protected:
	/**
	 * Sets overrides in the material's static parameters
	 *
	 * @param	Permutation		The set of static parameters to override and their values
	 */
	void SetStaticParameterOverrides(const FStaticParameterSet* Permutation);

	/**
	 * Clears static parameter overrides so that static parameter expression defaults will be used
	 *	for subsequent compiles.
	 */
	void ClearStaticParameterOverrides();

	//FIRAXIS ADDITION
	void UpdateLightingModel();
	//FIRAXIS END

public:
	/** Helper functions for text output of properties... */
	static const TCHAR* GetMaterialLightingModelString(EMaterialLightingModel InMaterialLightingModel);
	static EMaterialLightingModel GetMaterialLightingModelFromString(const TCHAR* InMaterialLightingModelStr);
	static const TCHAR* GetBlendModeString(EBlendMode InBlendMode);
	static EBlendMode GetBlendModeFromString(const TCHAR* InBlendModeStr);

	/**
	 *	Check if the textures have changed since the last time the material was
	 *	serialized for Lightmass... Update the lists while in here.
	 *	NOTE: This will mark the package dirty if they have changed.
	 *
	 *	@return	UBOOL	TRUE if the textures have changed.
	 *					FALSE if they have not.
	 */
	virtual UBOOL UpdateLightmassTextureTracking();

	/**
	*	Get the expression input for the given property
	*
	*	@param	InProperty				The material property chain to inspect, such as MP_DiffuseColor.
	*
	*	@return	FExpressionInput*		A pointer to the expression input of the property specified, 
	*									or NULL if an invalid property was requested.
	*/
	FExpressionInput* GetExpressionInputForProperty(EMaterialProperty InProperty);

	/**
	 *	Get all referenced expressions (returns the chains for all properties).
	 *
	 *	@param	OutExpressions			The array to fill in all of the expressions.
	 *	@param	InStaticParameterSet	Optional static parameter set - if supplied only walk the StaticSwitch branches according to it.
	 *
	 *	@return	UBOOL					TRUE if successful, FALSE if not.
	 */
	virtual UBOOL GetAllReferencedExpressions(TArray<UMaterialExpression*>& OutExpressions, class FStaticParameterSet* InStaticParameterSet);

	/**
	 *	Get the expression chain for the given property (ie fill in the given array with all expressions in the chain).
	 *
	 *	@param	InProperty				The material property chain to inspect, such as MP_DiffuseColor.
	 *	@param	OutExpressions			The array to fill in all of the expressions.
	 *	@param	InStaticParameterSet	Optional static parameter set - if supplied only walk the StaticSwitch branches according to it.
	 *
	 *	@return	UBOOL					TRUE if successful, FALSE if not.
	 */
	virtual UBOOL GetExpressionsInPropertyChain(EMaterialProperty InProperty, 
		TArray<UMaterialExpression*>& OutExpressions, class FStaticParameterSet* InStaticParameterSet);

	/**
	 *	Get all of the textures in the expression chain for the given property (ie fill in the given array with all textures in the chain).
	 *
	 *	@param	InProperty				The material property chain to inspect, such as MP_DiffuseColor.
	 *	@param	OutTextures				The array to fill in all of the textures.
	 *	@param	InStaticParameterSet	Optional static parameter set - if supplied only walk the StaticSwitch branches according to it.
	 *	@param	OutTextureParamNames	Optional array to fill in with texture parameter names.
	 *
	 *	@return	UBOOL			TRUE if successful, FALSE if not.
	 */
	virtual UBOOL GetTexturesInPropertyChain(EMaterialProperty InProperty, TArray<UTexture*>& OutTextures, 
		TArray<FName>* OutTextureParamNames, class FStaticParameterSet* InStaticParameterSet);

protected:
	/**
	 *	Recursively retrieve the expressions contained in the chain of the given expression.
	 *
	 *	@param	InExpression			The expression to start at.
	 *	@param	InOutProcessedInputs	An array of processed expression inputs. (To avoid circular loops causing infinite recursion)
	 *	@param	OutExpressions			The array to fill in all of the expressions.
	 *	@param	InStaticParameterSet	Optional static parameter set - if supplied only walk the StaticSwitch branches according to it.
	 *
	 *	@return	UBOOL					TRUE if successful, FALSE if not.
	 */
	virtual UBOOL RecursiveGetExpressionChain(UMaterialExpression* InExpression, TArray<FExpressionInput*>& InOutProcessedInputs, 
		TArray<UMaterialExpression*>& OutExpressions, class FStaticParameterSet* InStaticParameterSet);

	/**
	*	Recursively update the bRealtimePreview for each expression based on whether it is connected to something that is time-varying.
	*	This is determined based on the result of UMaterialExpression::NeedsRealtimePreview();
	*
	*	@param	InExpression				The expression to start at.
	*	@param	InOutExpressionsToProcess	Array of expressions we still need to process.
	*
	*/
	void RecursiveUpdateRealtimePreview(UMaterialExpression* InExpression, TArray<UMaterialExpression*>& InOutExpressionsToProcess);


	friend class FLightmassMaterialProxy;
};

defaultproperties
{
	BlendMode=BLEND_Opaque
	DiffuseColor=(Constant=(R=0,G=0,B=0)) //FIRAXIS CHANGE
	DiffusePower=(Constant=1.0)
	SpecularColor=(Constant=(R=0,G=0,B=0)) //FIRAXIS CHANGE
	Roughness=(Constant=0.3)
	Cavity=(Constant=0.1)
	Distortion=(Constant=(X=0,Y=0,Z=0))
	Opacity=(Constant=1)
	OpacityMask=(Constant=1)
	bUseLitTranslucencyDepthPassNoClipFXS=FALSE //FIRAXIS CHANGE
	OpacityMaskClipValue=0.3333
	ShadowDepthBias=0
	TwoSidedLightingColor=(Constant=(R=255,G=255,B=255))
	bAllowFog=TRUE
	bForceFog=FALSE
	bForceSceneColorFOW = FALSE //FIRAXIS addition
	UseDefaultShadow=true; //Firaxis addition
	bUsedWithStaticLighting=FALSE
	bAllowLightmapSpecular=TRUE
	PhysMaterialMaskUVChannel=-1
	D3D11TessellationMode=MTM_NoTessellation
	bEnableCrackFreeDisplacement=FALSE
	ImageReflectionNormalDampening=5
	bUsedWithVertexOffset=FALSE     // FIRAXIS addition jshopf
	// FIRAXIS begin
	BackgroundMesh="EditorMeshes.AnimTreeEd_PreviewFloor"
	BackgroundPosition=(X=0.000000,Y=0.000000,Z=0.000000)
	BackgroundRotation=(Pitch=0,Yaw=0,Roll=0)
	BackgroundScale=1.000000
	BackgroundScale3D=(X=1.000000,Y=1.000000,Z=1.000000)
	bUsedWithMovementGrid=FALSE
	bUsedWithStaticMeshes=FALSE
	bForceRenderBeforeFOW=FALSE
	bForceNoHaveSeenFOW=FALSE
	ForceNoHaveSeenFOW=EHVF_Normal
	bUsedWithFoliage=FALSE
	bIs3DUI=FALSE
	// FIRAXIS end

	bMaskedOutput=FALSE
	bOutputDiffuse=FALSE
	bOutputEmissive=FALSE
	bOutputSpecular=FALSE
	bOutputRoughness=FALSE
	bOutputNormals=FALSE

	UseForCharacterLightingMod=FALSE
	UseOldRoughness=FALSE
}
