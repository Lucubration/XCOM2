/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * Depth of Field post process effect
 *
 */
class DOFAndBloomEffect extends DOFEffect
	native;

/** A scale applied to blooming colors. */
var(Bloom) float BloomScale;

/** Any component of a pixel's color must be larger than this to contribute bloom. */
var(Bloom) float BloomThreshold;

/** Variance controlling blend between different mip levels of bloom blur. Higher number pushes the bloom out, lower number pulls it in. */
var(Bloom) float BloomVariance;

/** Time for bloom to fully fade out */
var(Bloom) float BloomTemporalLowEnd;

/** Time for bloom to fully fade in */
var(Bloom) float BloomTemporalHighEnd;

/** Texture to be used by for the Dirty Lens effect. */
var(Bloom) Texture2D DirtyLensTexture;

/** If true the texture used for the dirty lens will be tiled. */
var(Bloom) bool DirtyLensTileTexture;

/** Amount to scale the bloom value by before multiplying by the dirty lens texture. */
var(Bloom) float DirtyLensScale;

var deprecated bool bEnableReferenceDOF;

var deprecated bool bEnableDepthOfFieldHQ;

/**
 * Allows to specify the depth of field type. Choose depending on performance and quality needs.
 * "SimpleDOF" blurs the out of focus content and recombines that with the unblurred scene (fast, almost constant speed).
 * "ReferenceDOF" makes use of dynamic branching in the pixel shader and features circular Bokeh shape effects (slow for big Kernel Size).
 * "BokehDOF" allows to specify a Bokeh texture and a bigger radius (requires D3D11, slow when using a lot of out of focus content)
 */
var(DepthOfField) enum EDOFType
{
	DOFType_SimpleDOF<DisplayName=SimpleDOF>, 
	DOFType_ReferenceDOF<DisplayName=ReferenceDOF>, 
	DOFType_BokehDOF<DisplayName=BokehDOF>, 
} DepthOfFieldType;

/**
 * Allows to specify the quality of the chose Depth of Field Type.
 * This meaning depends heavily on the current implementation and that might change.
 * If performance is important the lowest acceptable quality should be used.
 */
var(DepthOfField) enum EDOFQuality
{
	DOFQuality_Low<DisplayName=Low>, 
	DOFQuality_Medium<DisplayName=Medium>, 
	DOFQuality_High<DisplayName=High>, 
} DepthOfFieldQuality;

/** only used if BokehDOF is enabled */
var(DepthOfField) Texture2D BokehTexture;

/** This is simply used to tell the effect to only use the World Settings for the Disabled Effects list and not for the actual DOF and Bloom settings. */
var() bool CheckWorldSettingsForDisabledEffectsOnly;

cpptext
{
	// UPostProcessEffect interface

	/**
	 * Creates a proxy to represent the render info for a post process effect
	 * @param WorldSettings - The world's post process settings for the view.
	 * @return The proxy object.
	 */
	virtual class FPostProcessSceneProxy* CreateSceneProxy(const FPostProcessSettings* WorldSettings);

	/**
	 * @param View - current view
	 * @return TRUE if the effect should be rendered
	 */
	virtual UBOOL IsShown(const FSceneView* View) const;
	
	// UObject interface

	/**
	* Called after this instance has been serialized.  UberPostProcessEffect should only
	* ever exists in the SDPG_PostProcess scene
	*/
	virtual void PostLoad();

	/**
	* Force the bUseWorldSettingsFlag on when the CheckWorldSettingsForDisabledEffectsOnly flag is on.
	*/
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);

	/**
	* This allows to print a warning when the effect is used.
	*/
	virtual void OnPostProcessWarning(FString& OutWarning) const
	{
		// FIRAXIS CHANGE -sboeckmann -Removed the warning since we are actually using it. We should look into switch the Strategy layer Blur over to Uberpostprocess (after the demo).
		//OutWarning = TEXT("Warning: DOFAndBloom should no longer be used, use Uberpostprocess instead.");
	}
}

defaultproperties
{
	BloomThreshold=1.0
	BloomVariance=1.0
	DirtyLensTileTexture=false
	DirtyLensScale=1.0

	BloomScale=1.0
	BlurKernelSize=16.0
	bEnableReferenceDOF=false
	CheckWorldSettingsForDisabledEffectsOnly=false

	BloomTemporalLowEnd=0.02
	BloomTemporalHighEnd=0.05
}
