/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * Used to affect post process settings in the game and editor.
 */
class PostProcessSettingsObject extends Object
	native;


/**  LUT Blender for efficient Color Grading (LUT: color look up table, RGB_new = LUT[RGB_old]) blender. */
struct native LUTBlender
{
	// is emptied at end of each frame, each value stored need to be unique, the value 0 is used for neutral
	var array<Texture> LUTTextures;
	// is emptied at end of each frame
	var array<float> LUTWeights;

	structcpptext
	{
		/** constructor, by default not even the Neutral element is defined */
		FLUTBlender();

		UBOOL IsLUTEmpty() const;

		/** new = lerp(old, Rhs, Weight) (main thread only)
		*
		* @param Texture 0 is a valid entry and is used for neutral
		* @param Weight 0..1
		*/
		void LerpTo(UTexture* Texture, float Weight);
		
		//Lerp function used to Lerp between two full FLUTBlenders
		void LerpTo(const FLUTBlender& OtherLUT, float Weight);

		/** resolve to one LUT (render thread only)*/
		const FTextureRHIRef ResolveLUT(class FViewInfo& View, const struct ColorTransformMaterialProperties& ColorTransform);

		/** Is updated every frame if GColorGrading is set to debug mode, empty if not */
		static UBOOL GetDebugInfo(FString& Out);

		void CopyToRenderThread(FLUTBlender& Dest) const;

		/**
		 * Check if the parameters are different, compared to the previous LUT Blender parameters.
		 */
		UBOOL CheckForChanges( const FLUTBlender& PreviousLUTBlender );

		/**
		* Clean the container and adds the neutral LUT. 
		* should be called after the render thread copied the data
		*/
		void Reset();

	private:

		/**
		*
		* @param Texture 0 is used for the neutral LUT
		*/
		void SetLUT(UTexture *Texture);

		/** 
		* add a LUT to the ones that are blended together 
		*
		* @param Texture can be 0 then the call is ignored
		* @param Weight 0..1
		*/
		void PushLUT(UTexture* Texture, float Weight);

		/** @return 0xffffffff if not found */
		UINT FindIndex(UTexture* Tex) const;

		/** @return count */
		UINT GenerateFinalTable(FTexture* OutTextures[], float OutWeights[], UINT MaxCount) const;
	}
};

struct native PostProcessSettings
{
	/** Determines if bEnableBloom variable will be overridden. */
	var	bool			bOverride_EnableBloom;
	
	/** Determines if bEnableDOF variable will be overridden. */
	var	bool			bOverride_EnableDOF;
	
	/** Determines if bEnableMotionBlur variable will be overridden. */
	var	bool			bOverride_EnableMotionBlur;
	
	/** Determines if bEnableSceneEffect variable will be overridden. */
	var	bool			bOverride_EnableSceneEffect;
	
	/** Determines if bAllowAmbientOcclusion variable will be overridden. */
	var	bool			bOverride_AllowAmbientOcclusion;
	
	/** Determines if bOverrideRimShaderColor variable will be overridden. */
	var	bool			bOverride_OverrideRimShaderColor;
	
	/** Determines if Bloom_Scale variable will be overridden. */
	var	bool			bOverride_Bloom_Scale;

	/** Determines if Bloom_Threshold variable will be overridden. */
	var	bool			bOverride_Bloom_Threshold;

	/** Determines if Bloom_Variance variable will be overridden. */
	var bool            bOverride_Bloom_Variance;

	var bool			bOverride_Bloom_TemporalLowEnd;
	var bool			bOverride_Bloom_TemporalHighEnd;

	/** Determines if DirtyLens_Texture variable will be overridden. */
	var bool            bOverride_DirtyLens_Texture;

	/** Determines if DirtyLens_Scale variable will be overridden. */
	var bool            bOverride_DirtyLens_Scale;

	/** Determines if DirtyLens_TileTexture variable will be overridden. */
	var bool            bOverride_DirtyLens_TileTexture;

	/** Determines if Bloom_InterpolationDuration variable will be overridden. */
	var	bool			bOverride_Bloom_InterpolationDuration;
	
	/** Determines if DOF_FalloffExponent variable will be overridden. */
	var	bool			bOverride_DOF_FalloffExponent;
	
	/** Determines if DOF_BlurKernelSize variable will be overridden. */
	var	bool			bOverride_DOF_BlurKernelSize;
	
	/** Determines if DOF_MaxNearBlurAmount variable will be overridden. */
	var	bool			bOverride_DOF_MaxNearBlurAmount;
	
	/** Determines if DOF_MinBlurAmount variable will be overridden. */
	var	bool			bOverride_DOF_MinBlurAmount;

	/** Determines if DOF_MaxFarBlurAmount variable will be overridden. */
	var	bool			bOverride_DOF_MaxFarBlurAmount;
	
	/** Determines if DOF_FocusType variable will be overridden. */
	var	bool			bOverride_DOF_FocusType;
	
	/** Determines if DOF_FocusInnerRadius variable will be overridden. */
	var	bool			bOverride_DOF_FocusInnerRadius;
	
	/** Determines if DOF_FocusDistance variable will be overridden. */
	var	bool			bOverride_DOF_FocusDistance;
	
	/** Determines if DOF_FocusPosition variable will be overridden. */
	var	bool			bOverride_DOF_FocusPosition;
	
	/** Determines if DOF_InterpolationDuration variable will be overridden. */
	var	bool			bOverride_DOF_InterpolationDuration;

	/** Determines if DOF_BokehTexture variable will be overridden. */
	var	bool			bOverride_DOF_BokehTexture;

	/** Determins if the DOF_NearFocusStart variable will be overridden. */
	var bool            bOverride_DOF_NearFocusStart;

	/** Determins if the DOF_NearFocusEnd variable will be overridden. */
	var bool            bOverride_DOF_NearFocusEnd;

	/** Determins if the DOF_FarFocusStart variable will be overridden. */
	var bool            bOverride_DOF_FarFocusStart;

	/** Determins if the DOF_FarFocusEnd variable will be overridden. */
	var bool            bOverride_DOF_FarFocusEnd;
	
	/** Determines if MotionBlur_MaxVelocity variable will be overridden. */
	var	bool			bOverride_MotionBlur_MaxVelocity;
	
	/** Determines if MotionBlur_Amount variable will be overridden. */
	var	bool			bOverride_MotionBlur_Amount;
	
	/** Determines if MotionBlur_FullMotionBlur variable will be overridden. */
	var	bool			bOverride_MotionBlur_FullMotionBlur;
	
	/** Determines if MotionBlur_CameraRotationThreshold variable will be overridden. */
	var	bool			bOverride_MotionBlur_CameraRotationThreshold;
	
	/** Determines if MotionBlur_CameraTranslationThreshold variable will be overridden. */
	var	bool			bOverride_MotionBlur_CameraTranslationThreshold;
	
	/** Determines if MotionBlur_InterpolationDuration variable will be overridden. */
	var	bool			bOverride_MotionBlur_InterpolationDuration;
	
	/** Determines if Scene_Desaturation variable will be overridden. */
	var	bool			bOverride_Scene_Desaturation;
	
	/** Determines if Scene_Colorize variable will be overridden. */
	var	bool			bOverride_Scene_Colorize;

	/** Determines if Scene_TonemapperScale variable will be overridden. */
	var	bool			bOverride_Scene_TonemapperScale;

	/** Determines if Scene_ImageGrainScale variable will be overridden. */
	var	bool			bOverride_Scene_ImageGrainScale;

	/** Determines if Scene_HighLights variable will be overridden. */
	var	bool			bOverride_Scene_HighLights;
	
	/** Determines if Scene_MidTones variable will be overridden. */
	var	bool			bOverride_Scene_MidTones;
	
	/** Determines if Scene_Shadows variable will be overridden. */
	var	bool			bOverride_Scene_Shadows;
	
	/** Determines if Scene_InterpolationDuration variable will be overridden. */
	var	bool			bOverride_Scene_InterpolationDuration;
	
	/** Determines if ColorGrading_LookupTable variable will be overridden. */
	var	bool			bOverride_Scene_ColorGradingLUT;
	
	/** Determines if RimShader_Color variable will be overridden. */
	var	bool			bOverride_RimShader_Color;
	
	/** Determines if RimShader_InterpolationDuration variable will be overridden. */
	var	bool			bOverride_RimShader_InterpolationDuration;

	var bool            bOverride_MagneticChromaticAbberation;
	
	var bool			bOverride_SSAO_InterpolationDuration;
	var bool			bOverride_SSAO_Power;
	var bool			bOverride_SSAO_Scale;
	var bool			bOverride_SSAO_Bias;
	var bool			bOverride_SSAO_MinOcclusion;
	var bool			bOverride_SSAO_OcclusionRadius;
	var bool			bOverride_SSAO_HaloDistanceThreshold;
	var bool			bOverride_SSAO_FadeoutMinDistance;
	var bool			bOverride_SSAO_FadeoutMaxDistance;

	var bool			bOverride_Scene_ExposureAdjustment;
	var bool			bOverride_Scene_CurveOutputAdjustment;

	var bool			bOverride_ShowFog;

	/** Whether to use bloom effect.																*/
	var(Bloom)	bool			bEnableBloom<editcondition=bOverride_EnableBloom>;
	/** Whether to use depth of field effect.														*/
	var(DepthOfField)	bool			bEnableDOF<editcondition=bOverride_EnableDOF>;
	/** Whether to use two layer simple depth of field effect.										*/
	var					bool			bTwoLayerSimpleDepthOfField;
	/** Whether to use motion blur effect.															*/
	var(MotionBlur)	bool			bEnableMotionBlur<editcondition=bOverride_EnableMotionBlur>;
	/** Whether to use the material/ scene effect.													*/
	var(Scene)	bool			bEnableSceneEffect<editcondition=bOverride_EnableSceneEffect>;
	/** Whether to allow ambient occlusion.															*/
	var()	bool			bAllowAmbientOcclusion<editcondition=bOverride_AllowAmbientOcclusion>;
	/** Whether to override the rim shader color.													*/
	var(RimShader)	bool			bOverrideRimShaderColor<editcondition=bOverride_OverrideRimShaderColor>;

	//FIRAXIS ADDITION
	var bool bOverrideXComFOWColor;
	var LinearColor XComFOWColor; // This variable should no longer be used. Left in to handle conversion to the newer XComFogOfWarColor
	var Color XComFogOfWarColor;

	var bool bOverrideXComHaveSeenTint;
	var Color HaveSeenTintColor;

	var(XComFOW) bool bOverrideXComFOWBorderSettings;
	var(XComFOW) float XComFOWBorderFadeOutColor;
	var(XComFOW) float XComFOWBorderFadeOutRate;
	var(XComFOW) float XComFOWBorderFadeInRate;

	/** 
	 * Power to apply to the calculated occlusion value. 
	 * Higher powers result in more contrast, but will need other factors like OcclusionScale to be tweaked as well. 
	 */
	var(SSAO) float SSAO_Power <editcondition = bOverride_SSAO_Power | UIMin = 0.1 | UIMax = 20.0>;

	/** Scale to apply to the calculated occlusion value. */
	var(SSAO) float SSAO_Scale <editcondition = bOverride_SSAO_Scale | UIMin = 0.0 | UIMax = 10.0>;

	/** Bias to apply to the calculated occlusion value. */
	var(SSAO) float SSAO_Bias <editcondition = bOverride_SSAO_Bias | UIMin = -1.0 | UIMax = 4.0>;

	/** Minimum occlusion value after all other transforms have been applied. */
	var(SSAO) float SSAO_MinOcclusion <editcondition = bOverride_SSAO_MinOcclusion>;

	/** Distance to check around each pixel for occluders, in world units. */
	var(SSAO) float SSAO_OcclusionRadius <editcondition = bOverride_SSAO_OcclusionRadius | UIMin = 0.0 | UIMax = 256.0>;
	/** 
	 * Distance in front of a pixel that an occluder must be to be considered a different object, in world units.  
	 * This threshold is used to identify halo regions around nearby objects, for example a first person weapon.
	 */
	var(SSAO) float SSAO_HaloDistanceThreshold <editcondition = bOverride_SSAO_HaloDistanceThreshold | UIMin = 0.0 | UIMax = 256.0>;
	/** 
	 * Distance at which to start fading out the occlusion factor, in world units. 
	 * This is useful for hiding distant artifacts on skyboxes.
	 */
	var(SSAO) float SSAO_FadeoutMinDistance <editcondition = bOverride_SSAO_FadeoutMinDistance | UIMin = 0.0 | UIMax = 256.0>;

	/** Distance at which the occlusion factor should be fully faded, in world units. */
	var(SSAO) float SSAO_FadeoutMaxDistance <editcondition = bOverride_SSAO_FadeoutMaxDistance | UIMin = 0.0 | UIMax = 256.0>;

	var(SSAO) float SSAO_InterpolationDuration <editcondition = bOverride_SSAO_InterpolationDuration>;


	/** Number of tiles to include starting from the center. */
	var(TiledAO) int TiledAO_Radius <UIMin=1 | UIMax=5>;

	/** Standard deviation of the bell curve. */
	var(TiledAO) float TiledAO_Sigma <UIMin=0.0>;

	/** How strong the effect is. */
	var(TiledAO) float TiledAO_Intensity <UIMin=0.0>;

	var() vector MagneticChromaticAbberation<editcondition=bOverride_MagneticChromaticAbberation>;
	
	/** Disables material effects.                                                                  */
	var() init array<name>     DisabledMaterialEffects;
	//FIRAXIS END

	/** Scale for the blooming.																		*/
	var(Bloom)	interp float	Bloom_Scale<editcondition=bOverride_Bloom_Scale>;
	/** Bloom threshold																				*/
	var(Bloom)	interp float	Bloom_Threshold<editcondition=bOverride_Bloom_Threshold>;
	/** Bloom Variance                                                                              */
	var(Bloom)  interp float    Bloom_Variance<editcondition=bOverride_Bloom_Variance>;

	/** Time for bloom to fully fade out */
	var(Bloom)	interp float	Bloom_TemporalLowEnd<editcondition = bOverride_Bloom_TemporalLowEnd>;
	
	/** Time for bloom to fully fade in */
	var(Bloom)	interp float	Bloom_TemporalHighEnd<editcondition = bOverride_Bloom_TemporalHighEnd>;

	/** DirtyLens Texture                                                                           */
	var(Bloom)  Texture2D       DirtyLens_Texture<editcondition=bOverride_DirtyLens_Texture>;
	/** DirtyLens Scale                                                                             */
	var(Bloom)  interp float    DirtyLens_Scale<editcondition=bOverride_DirtyLens_Scale>;
	/** DirtyLens TileTexture                                                                       */
	var(Bloom)  bool		    DirtyLens_TileTexture<editcondition=bOverride_DirtyLens_TileTexture>;
	/** Duration over which to interpolate values to.												*/
	var(Bloom)	float		Bloom_InterpolationDuration<editcondition=bOverride_Bloom_InterpolationDuration>;

	/** Exponent to apply to blur amount after it has been normalized to [0,1].						*/
	var(DepthOfField)	interp float	DOF_FalloffExponent<editcondition=bOverride_DOF_FalloffExponent>;
	/** affects the radius of the DepthOfField bohek / how blurry the scene gets					*/
	var(DepthOfField)	interp float	DOF_BlurKernelSize<editcondition=bOverride_DOF_BlurKernelSize>;
	/** [0,1] value for clamping how much blur to apply to items in front of the focus plane.		*/
	var(DepthOfField, BlurAmount)	interp float	DOF_MaxNearBlurAmount<editcondition=bOverride_DOF_MaxNearBlurAmount | DisplayName=MaxNear>;
	/** [0,1] value for clamping how much blur to apply.											*/
	var(DepthOfField, BlurAmount)	interp float	DOF_MinBlurAmount<editcondition=bOverride_DOF_MinBlurAmount | DisplayName=Min>;
	/** [0,1] value for clamping how much blur to apply to items behind the focus plane.			*/
	var(DepthOfField, BlurAmount)	interp float	DOF_MaxFarBlurAmount<editcondition=bOverride_DOF_MaxFarBlurAmount | DisplayName=MaxFar>;
	/** Controls how the focus point is determined.													*/
	var(DepthOfField)	EFocusType		DOF_FocusType<editcondition=bOverride_DOF_FocusType>;
	/** Inner focus radius.																			*/
	var(DepthOfField)	interp float	DOF_FocusInnerRadius<editcondition=bOverride_DOF_FocusInnerRadius>;
	/** Used when FOCUS_Distance is enabled.														*/
	var(DepthOfField)	interp float	DOF_FocusDistance<editcondition=bOverride_DOF_FocusDistance>;
	/** Used when FOCUS_Position is enabled.														*/
	var(DepthOfField)	vector			DOF_FocusPosition<editcondition=bOverride_DOF_FocusPosition>;
	/** Duration over which to interpolate values to.												*/
	var(DepthOfField)	float			DOF_InterpolationDuration<editcondition=bOverride_DOF_InterpolationDuration>;
	/** Name of the Bokeh texture e.g. EngineMaterial.BokehTexture, empty if not used						*/
	var(DepthOfField)	Texture2D		DOF_BokehTexture<editcondition=bOverride_DOF_BokehTexture>;

	/** Used when FOCUS_AbsolutePlanes is enabled. */
	var(DepthOfField) float DOF_NearFocusStart<editcondition=bOverride_DOF_NearFocusStart>;
	/** Used when FOCUS_AbsolutePlanes is enabled. */
	var(DepthOfField) float DOF_NearFocusEnd<editcondition=bOverride_DOF_NearFocusEnd>;
	/** Used when FOCUS_AbsolutePlanes is enabled. */
	var(DepthOfField) float DOF_FarFocusStart<editcondition=bOverride_DOF_FarFocusStart>;
	/** Used when FOCUS_AbsolutePlanes is enabled. */
	var(DepthOfField) float DOF_FarFocusEnd<editcondition=bOverride_DOF_FarFocusEnd>;

	/** Maximum blur velocity amount.  This is a clamp on the amount of blur.						*/
	var(MotionBlur)	interp float	MotionBlur_MaxVelocity<editcondition=bOverride_MotionBlur_MaxVelocity>;
	/** This is a scalar on the blur																*/
	var(MotionBlur)	interp float	MotionBlur_Amount<editcondition=bOverride_MotionBlur_Amount>;
	/** Whether everything (static/dynamic objects) should motion blur or not. If disabled, only moving objects may blur. */
	var(MotionBlur)	bool			MotionBlur_FullMotionBlur<editcondition=bOverride_MotionBlur_FullMotionBlur>;
	/** Threshold for when to turn off motion blur when the camera rotates swiftly during a single frame (in degrees). */
	var(MotionBlur)	interp float	MotionBlur_CameraRotationThreshold<editcondition=bOverride_MotionBlur_CameraRotationThreshold>;
	/** Threshold for when to turn off motion blur when the camera translates swiftly during a single frame (in world units). */
	var(MotionBlur)	interp float	MotionBlur_CameraTranslationThreshold<editcondition=bOverride_MotionBlur_CameraTranslationThreshold>;
	/** Duration over which to interpolate values to.												*/
	var(MotionBlur)	float			MotionBlur_InterpolationDuration<editcondition=bOverride_MotionBlur_InterpolationDuration>;
	
	/** Desaturation amount.																		*/
	var(Scene)	interp float	Scene_Desaturation<editcondition=bOverride_Scene_Desaturation>;
	/** Colorize (color tint after desaturate)														*/
	var(Scene)	interp vector	Scene_Colorize<editcondition=bOverride_Scene_Colorize>;
	/** HDR tone mapper scale, only used if tone mapper is on, >=0, 0:black, 1(default), >1 brighter */
	var(Scene)	interp float	Scene_TonemapperScale<editcondition=bOverride_Scene_TonemapperScale>;
	/** Image grain scale, only affects the darks, >=0, 0:none, 1(strong) should be less than 1								*/
	var(Scene)	interp float	Scene_ImageGrainScale<editcondition=bOverride_Scene_ImageGrainScale>;
	/** Controlling white point.																	*/
	var(Scene)	interp vector	Scene_HighLights<editcondition=bOverride_Scene_HighLights>;
	/** Controlling gamma curve.																	*/
	var(Scene)	interp vector	Scene_MidTones<editcondition=bOverride_Scene_MidTones>;
	/** Controlling black point.																	*/
	var(Scene)	interp vector	Scene_Shadows<editcondition=bOverride_Scene_Shadows>;
	/** Duration over which to interpolate values to.												*/
	var(Scene)	float			Scene_InterpolationDuration<editcondition=bOverride_Scene_InterpolationDuration>;

	/** Controlling rim shader color.																*/
	var(RimShader)   LinearColor		RimShader_Color<editcondition=bOverride_RimShader_Color>;
	/** Duration over which to interpolate values to.												*/
	var(RimShader)	float			RimShader_InterpolationDuration<editcondition=bOverride_RimShader_InterpolationDuration>;
	/** Name of the LUT texture e.g. MyPackage01.LUTNeutral, empty if not used						*/
	var(Scene)	Texture			ColorGrading_LookupTable<editcondition=bOverride_Scene_ColorGradingLUT>;
	/** Used to blend color grading LUT in a very similar way we blend scalars */
	var	const private transient	LUTBlender ColorGradingLUT;

	var(Scene) interp float Scene_ExposureAdjustment<editcondition=bOverride_Scene_ExposureAdjustment>;
	var(Scene) interp float Scene_CurveOutputAdjustment<editcondition=bOverride_Scene_CurveOutputAdjustment>;

	/* Should Height fog be shown in this view */
	var() bool				bShowFog<editcondition = bOverride_ShowFog>;

	structcpptext
	{
		/* default constructor, for script, values are overwritten by serialization after that */
		FPostProcessSettings()
		{}

		/* second constructor, supposed to be used by C++ */
		FPostProcessSettings(INT A)
		{
			bOverride_EnableBloom = TRUE;
			bOverride_EnableDOF = TRUE;
			bOverride_EnableMotionBlur = TRUE;
			bOverride_EnableSceneEffect = TRUE;
			bOverride_AllowAmbientOcclusion = TRUE;
			bOverride_OverrideRimShaderColor = TRUE;

			bOverride_Bloom_Scale = TRUE;
			bOverride_Bloom_Threshold = TRUE;
			bOverride_Bloom_Variance = TRUE;
			bOverride_Bloom_TemporalLowEnd = FALSE;
			bOverride_Bloom_TemporalHighEnd = FALSE;
			bOverride_DirtyLens_Texture = TRUE;
			bOverride_DirtyLens_Scale = TRUE;
			bOverride_DirtyLens_TileTexture = TRUE;
			bOverride_Bloom_InterpolationDuration = TRUE;

			bOverride_DOF_FalloffExponent = TRUE;
			bOverride_DOF_BlurKernelSize = TRUE;
			bOverride_DOF_MaxNearBlurAmount = TRUE;
			bOverride_DOF_MinBlurAmount = FALSE;
			bOverride_DOF_MaxFarBlurAmount = TRUE;
			bOverride_DOF_FocusType = TRUE;
			bOverride_DOF_FocusInnerRadius = TRUE;
			bOverride_DOF_FocusDistance = TRUE;
			bOverride_DOF_FocusPosition = TRUE;
			bOverride_DOF_InterpolationDuration = TRUE;
			bOverride_DOF_BokehTexture = FALSE;			

			bOverride_MotionBlur_MaxVelocity = FALSE;
			bOverride_MotionBlur_Amount = FALSE;
			bOverride_MotionBlur_FullMotionBlur = FALSE;
			bOverride_MotionBlur_CameraRotationThreshold = FALSE;
			bOverride_MotionBlur_CameraTranslationThreshold = FALSE;
			bOverride_MotionBlur_InterpolationDuration = FALSE;
			bOverride_Scene_Desaturation = TRUE;
			bOverride_Scene_Colorize = FALSE;
			bOverride_Scene_TonemapperScale = FALSE;
			bOverride_Scene_ImageGrainScale = FALSE;
			bOverride_Scene_HighLights = TRUE;
			bOverride_Scene_MidTones = TRUE;
			bOverride_Scene_Shadows = TRUE;
			bOverride_Scene_InterpolationDuration = TRUE;
			bOverride_Scene_ColorGradingLUT = FALSE;
			bOverride_RimShader_Color = TRUE;
			bOverride_RimShader_InterpolationDuration = TRUE;

			bOverride_SSAO_Power=FALSE;
			bOverride_SSAO_Scale = FALSE;
			bOverride_SSAO_Bias = FALSE;
			bOverride_SSAO_MinOcclusion = FALSE;
			bOverride_SSAO_OcclusionRadius = FALSE;
			bOverride_SSAO_HaloDistanceThreshold = FALSE;
			bOverride_SSAO_FadeoutMinDistance = FALSE;
			bOverride_SSAO_FadeoutMaxDistance = FALSE;
			bOverride_SSAO_InterpolationDuration = TRUE;

			bOverride_Scene_ExposureAdjustment = FALSE;
			bOverride_Scene_CurveOutputAdjustment = FALSE;

			bOverride_ShowFog = FALSE;

			bEnableBloom=TRUE;
			bEnableDOF=FALSE;
			bTwoLayerSimpleDepthOfField=FALSE;
			bEnableMotionBlur=FALSE; //Firaxis Change-Performance
			bEnableSceneEffect=TRUE;
			bAllowAmbientOcclusion=TRUE;
			bOverrideRimShaderColor=FALSE;

			bOverrideXComFOWColor=FALSE;
			XComFOWColor = FLinearColor(0.0,0.0,0.0,1.0);
			XComFogOfWarColor = FColor(0,0,0,1);

			bOverrideXComHaveSeenTint=FALSE;
			HaveSeenTintColor = FColor(128,128,128,255);

			Bloom_Scale=1;
			Bloom_Threshold=1;
			Bloom_Variance=1;
			Bloom_TemporalLowEnd = 0.02;
			Bloom_TemporalHighEnd = 0.05;
			DirtyLens_Texture=NULL;
			DirtyLens_Scale=1.0f;
			DirtyLens_TileTexture=FALSE;
			Bloom_InterpolationDuration=1;

			DOF_FalloffExponent=4;
			DOF_BlurKernelSize=16;
			DOF_MaxNearBlurAmount=1;
			DOF_MinBlurAmount=0;
			DOF_MaxFarBlurAmount=1;
			DOF_FocusType=FOCUS_Distance;
			DOF_FocusInnerRadius=2000;
			DOF_FocusDistance=0;
			DOF_InterpolationDuration=1;
			DOF_NearFocusStart=0;
			DOF_NearFocusEnd=0;
			DOF_FarFocusStart=0;
			DOF_FarFocusEnd=0;

			MotionBlur_MaxVelocity=1.0f;
			MotionBlur_Amount=0.5f;
			MotionBlur_FullMotionBlur=TRUE;
			MotionBlur_CameraRotationThreshold=90.0f;
			MotionBlur_CameraTranslationThreshold=10000.0f;
			MotionBlur_InterpolationDuration=1;

			Scene_Desaturation=0;
			Scene_Colorize=FVector(1,1,1);
			Scene_TonemapperScale=1.0f;
			Scene_ImageGrainScale=0.0f;
			Scene_HighLights=FVector(1,1,1);
			Scene_MidTones=FVector(1,1,1);
			Scene_Shadows=FVector(0,0,0);
			Scene_InterpolationDuration=1;

			RimShader_Color=FLinearColor(0.470440f,0.585973f,0.827726f,1.0f);
			RimShader_InterpolationDuration=1;

			bOverrideXComFOWBorderSettings=FALSE;
			XComFOWBorderFadeOutColor=0.2f;
			XComFOWBorderFadeOutRate=0.05f;
			XComFOWBorderFadeInRate=1.0f;

			SSAO_Power=2.0f;
			SSAO_Scale=1.0f;
			SSAO_Bias=0.0f;
			SSAO_MinOcclusion=0.1f;
			SSAO_OcclusionRadius=128.0f;
			SSAO_HaloDistanceThreshold=64.0f;
			SSAO_FadeoutMinDistance=1000.0f;
			SSAO_FadeoutMaxDistance=1400.f;
			SSAO_InterpolationDuration = 1.0f;

			TiledAO_Radius=2;
			TiledAO_Sigma=1.0;
			TiledAO_Intensity=0.2;

			Scene_ExposureAdjustment = 0;
			Scene_CurveOutputAdjustment = 0;

			bOverride_MagneticChromaticAbberation=FALSE;
			MagneticChromaticAbberation=FVector(1,1.5,2);

			bShowFog = TRUE;
		}

		/**
		 * Blends the settings on this structure marked as override setting onto the given settings
		 *
		 * @param	ToOverride	The settings that get overridden by the overridable settings on this structure. 
		 * @param	Alpha		The opacity of these settings. If Alpha is 1, ToOverride will equal this setting structure.
		 */
		void OverrideSettingsFor( FPostProcessSettings& ToOverride, FLOAT Alpha=1.f ) const;

		// Similar to OverrideSettignsFor() but merges the two settings, instead of overwriting.
		void MergeSettings(FPostProcessSettings& Other, FLOAT Alpha = 1.0f);

		/**
		 * Enables the override setting for the given post-process setting.
		 *
		 * @param	PropertyName	The post-process property name to enable.
		 */
		void EnableOverrideSetting( const FName& PropertyName );

		/**
		 * Disables the override setting for the given post-process setting.
		 *
		 * @param	PropertyName	The post-process property name to enable.
		 */
		void DisableOverrideSetting( const FName& PropertyName );

		/**
		 * Sets all override values to false, which prevents overriding of this struct.
		 *
		 * @note	Overrides can be enabled again. 
		 */
		void DisableAllOverrides();

		/**
		 * Enables bloom for the post process settings.
		 */
		FORCEINLINE void EnableBloom()
		{
			bOverride_EnableBloom = TRUE;
			bEnableBloom = TRUE;
		}

		/**
		 * Enables DOF for the post process settings.
		 */
		FORCEINLINE void EnableDOF()
		{
			bOverride_EnableDOF = TRUE;
			bEnableDOF = TRUE;
		}

		/**
		 * Enables motion blur for the post process settings.
		 */
		FORCEINLINE void EnableMotionBlur()
		{
			bOverride_EnableMotionBlur = TRUE;
			bEnableMotionBlur = TRUE;
		}

		/**
		 * Enables scene effects for the post process settings.
		 */
		FORCEINLINE void EnableSceneEffect()
		{
			bOverride_EnableSceneEffect = TRUE;
			bEnableSceneEffect = TRUE;
		}

		/**
		 * Enables rim shader color for the post process settings.
		 */
		FORCEINLINE void EnableRimShader()
		{
			bOverride_OverrideRimShaderColor = TRUE;
			bOverrideRimShaderColor = TRUE;
		}

		/**
		 * Disables the override to enable bloom if no overrides are set for bloom settings.
		 */
		void DisableBloomOverrideConditional();

		/**
		 * Disables the override to enable DOF if no overrides are set for DOF settings.
		 */
		void DisableDOFOverrideConditional();

		/**
		 * Disables the override to enable motion blur if no overrides are set for motion blur settings.
		 */
		void DisableMotionBlurOverrideConditional();

		/**
		 * Disables the override to enable scene effect if no overrides are set for scene effect settings.
		 */
		void DisableSceneEffectOverrideConditional();

		/**
		 * Disables the override to enable rim shader if no overrides are set for rim shader settings.
		 */
		void DisableRimShaderOverrideConditional();
	}

	/**
	 * Used when a volume is placed in editor but also when the local player is deserialized
	 * (e.g. after seamless map cycle - this caused TTP 162775)
	 */
	structdefaultproperties
	{
		bOverride_EnableBloom=TRUE
		bOverride_EnableDOF=TRUE
		bOverride_EnableMotionBlur=TRUE
		bOverride_EnableSceneEffect=TRUE
		bOverride_AllowAmbientOcclusion=TRUE
		bOverride_OverrideRimShaderColor=TRUE
		bOverride_Bloom_Scale=TRUE
		bOverride_Bloom_Threshold=TRUE
		bOverride_Bloom_Variance=TRUE
		bOverride_DirtyLens_Texture=TRUE;
		bOverride_DirtyLens_Scale=TRUE;
		bOverride_DirtyLens_TileTexture=TRUE;
		bOverride_Bloom_InterpolationDuration=TRUE
		bOverride_DOF_FalloffExponent=TRUE
		bOverride_DOF_BlurKernelSize=TRUE
		bOverride_DOF_MaxNearBlurAmount=TRUE
		bOverride_DOF_MinBlurAmount=FALSE
		bOverride_DOF_MaxFarBlurAmount=TRUE
		bOverride_DOF_FocusType=TRUE
		bOverride_DOF_FocusInnerRadius=TRUE
		bOverride_DOF_FocusDistance=TRUE
		bOverride_DOF_FocusPosition=TRUE
		bOverride_DOF_InterpolationDuration=TRUE
		bOverride_DOF_BokehTexture=FALSE
		bOverride_MotionBlur_MaxVelocity=FALSE
		bOverride_MotionBlur_Amount=FALSE
		bOverride_MotionBlur_FullMotionBlur=FALSE
		bOverride_MotionBlur_CameraRotationThreshold=FALSE
		bOverride_MotionBlur_CameraTranslationThreshold=FALSE
		bOverride_MotionBlur_InterpolationDuration=FALSE
		bOverride_Scene_Desaturation=TRUE
		bOverride_Scene_Colorize=FALSE
		bOverride_Scene_TonemapperScale=FALSE
		bOverride_Scene_ImageGrainScale=FALSE
		bOverride_Scene_HighLights=TRUE
		bOverride_Scene_MidTones=TRUE
		bOverride_Scene_Shadows=TRUE
		bOverride_Scene_InterpolationDuration=TRUE
		bOverride_Scene_ColorGradingLUT=FALSE
		bOverride_RimShader_Color=TRUE
		bOverride_RimShader_InterpolationDuration=TRUE
		bOverride_SSAO_Power = FALSE
		bOverride_SSAO_Scale = FALSE
		bOverride_SSAO_Bias = FALSE
		bOverride_SSAO_MinOcclusion = FALSE
		bOverride_SSAO_OcclusionRadius = FALSE
		bOverride_SSAO_HaloDistanceThreshold = FALSE
		bOverride_SSAO_FadeoutMinDistance = FALSE
		bOverride_SSAO_FadeoutMaxDistance = FALSE
		bOverride_SSAO_InterpolationDuration=TRUE
		bOverride_ShowFog=FALSE
		SSAO_Power=3.0 //Firaxis Change CP
		SSAO_Scale=1.0
		SSAO_Bias=0.25 //Firaxis Change CP
		SSAO_MinOcclusion=0.1
		SSAO_OcclusionRadius=140.0
		SSAO_HaloDistanceThreshold=64.0
		SSAO_FadeoutMinDistance=4000.0
		SSAO_FadeoutMaxDistance=4500.0
		SSAO_InterpolationDuration=1.0

		TiledAO_Radius=2
		TiledAO_Sigma=1.5 // CP
		TiledAO_Intensity=1.0 // CP

		bEnableBloom=TRUE
		bEnableDOF=FALSE
		bTwoLayerSimpleDepthOfField=FALSE
		bEnableMotionBlur=FALSE //Firaxis change
		bEnableSceneEffect=TRUE
		bAllowAmbientOcclusion=TRUE
		bOverrideRimShaderColor=FALSE

		bOverrideXComFOWColor=FALSE // FIRAXIS 
		XComFOWColor=(R=0.0,G=0.0,B=0.0,A=1.0) // FIRAXIS 
		XComFogOfWarColor=(R=0,G=0,B=0,A=1)

		bOverrideXComHaveSeenTint=FALSE
		HaveSeenTintColor = (R=125,G=128,B=128,A=255);

		Bloom_Scale=1
		Bloom_Threshold=1
		Bloom_Variance=1
		Bloom_TemporalLowEnd=0.02
		Bloom_TemporalHighEnd=0.05
		DirtyLens_Texture=none
		DirtyLens_Scale=1.0
		DirtyLens_TileTexture=false
		Bloom_InterpolationDuration=1

		DOF_FalloffExponent=4
		DOF_BlurKernelSize=16
		DOF_MaxNearBlurAmount=1
		DOF_MinBlurAmount=0
		DOF_MaxFarBlurAmount=1
		DOF_FocusType=FOCUS_Distance
		DOF_FocusInnerRadius=2000
		DOF_FocusDistance=0
		DOF_InterpolationDuration=1
		DOF_NearFocusStart=0
		DOF_NearFocusEnd=0
		DOF_FarFocusStart=0
		DOF_FarFocusEnd=0

		MotionBlur_MaxVelocity=1.0
		MotionBlur_Amount=0.5
		MotionBlur_FullMotionBlur=TRUE
		MotionBlur_CameraRotationThreshold=45.0
		MotionBlur_CameraTranslationThreshold=10000.0
		MotionBlur_InterpolationDuration=1

		Scene_Desaturation=0
		Scene_Colorize=(X=1,Y=1,Z=1)
		Scene_TonemapperScale=1.0f
		Scene_ImageGrainScale=0.0f
		Scene_HighLights=(X=1,Y=1,Z=1)
		Scene_MidTones=(X=1,Y=1,Z=1)
		Scene_Shadows=(X=0,Y=0,Z=0)
		Scene_InterpolationDuration=1
		Scene_ExposureAdjustment=0
		Scene_CurveOutputAdjustment=0

		RimShader_Color=(R=0.470440f,G=0.585973f,B=0.827726f,A=1.0f)
		RimShader_InterpolationDuration=1

		bOverrideXComFOWBorderSettings=FALSE
		XComFOWBorderFadeOutColor=0.2
		XComFOWBorderFadeOutRate=0.05
		XComFOWBorderFadeInRate=1.0		

		bOverride_MagneticChromaticAbberation=FALSE
		MagneticChromaticAbberation=(X=1,Y=1.5,Z=2)

		bShowFog = TRUE
	}

};

/**
 * Post process settings to use for this volume.
 */
var()							PostProcessSettings		Settings;

cpptext
{
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
}

defaultproperties
{
}
