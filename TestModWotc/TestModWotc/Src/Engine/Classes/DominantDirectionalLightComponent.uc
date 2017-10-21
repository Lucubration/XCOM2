/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class DominantDirectionalLightComponent extends DirectionalLightComponent
	native(Light)
	hidecategories(Object)
	dependson(EngineTypes)
	editinlinenew;

var private {private} const DominantShadowInfo DominantLightShadowInfo;
/** Array of depths to the furthest shadow casting geometry in each shadowmap cell, quantized to a WORD and stored relative to LightSpaceImportanceBounds.Min.Z. */
var private {private} const native Array_Mirror DominantLightShadowMap{TArrayNoInit<WORD>};

/** Exposure modifier for input to the tone mapper (filmic only) **/
var() deprecated float ExposureAdjustment;

/** Modifier for output from the tone mapper (filmic only) **/
var() deprecated float CurveOutputAdjustment;

/** Emission modifier based on time of day */
var() float TimeOfDayEmissionScalar;

/** Set emission using the TimeOfDayEmissionScalar on all material instances that have the EmissToDScale scalar parameter */
native static function SetToDEmissionOnAll();

cpptext
{
    virtual void Serialize(FArchive& Ar);
	virtual ELightComponentType GetLightType() const;
    virtual void InvalidateLightingCache();
	/**
	* Called after property has changed via e.g. property window or set command.
	*
	* @param	PropertyThatChanged	UProperty that has been changed, NULL if unknown
	*/
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	virtual void FinishDestroy();
    /** Returns information about the data used to calculate dominant shadow transition distance. */
    void GetInfo(INT& SizeX, INT& SizeY, SIZE_T& ShadowMapBytes) const;
    /** Populates DominantLightShadowMap and DominantLightShadowInfo with the results from a lighting build. */
    void Initialize(const FDominantShadowInfo& InInfo, const TArray<WORD>& InShadowMap);
    /** Returns the distance to the nearest dominant shadow transition, in world space units, starting from the edge of the bounds. */
    FLOAT GetDominantShadowTransitionDistance(const FBoxSphereBounds& Bounds, FLOAT MaxSearchDistance, UBOOL bDebugSearch, TArray<class FDebugShadowRay>& DebugRays, UBOOL& bLightingIsBuilt) const;

	/** Returns true if the dominant light has valid shadow map data */
	UBOOL IsDominantLightShadowMapValid() const
	{
		return DominantLightShadowMap.Num() > 0;
	}

	/** Set emission on all material instances that have the EmissToDScale scalar parameter */
	static void SetToDEmissionStaticFunction(FLOAT Scalar);
}

defaultproperties
{
	bAffectCompositeShadowDirection=true
	bAffectDynamicIndirectLighting=true
	ExposureAdjustment=0.0
	CurveOutputAdjustment=0.0

	TimeOfDayEmissionScalar=1.0
}
