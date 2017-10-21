//  XComFOWEffect.uc - Firaxis Games
//
// Author: Jeremy Shopf
// 07/28/2011
// Effect class for exposing FOW settings to the editor

class XComFOWEffect extends PostProcessEffect
	native;

var Vector LevelVolumeDimensions;
var Vector LevelVolumePosition;
var Vector VoxelSizeUVW;
var bool bHiding;
var bool bForcePointSampling;
var bool bForceNoFiltering;
var bool bShowFOW;

var (XComFOW) Color FogColor;
var (XComFOW) Color HaveSeenTintColor;
var (XComFOW) float BorderFadeOutColor;
var (XComFOW) float BorderFadeOutRate;
var (XComFOW) float BorderFadeInRate;

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

	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
}
	

defaultproperties
{
	FogColor=(R=0,G=0,B=0,A=255)
	HaveSeenTintColor=(R=128,G=128,B=128,A=255)
	bHiding=true;
	bForcePointSampling=false;
	bForceNoFiltering=false;
	BorderFadeOutColor=0.2;
	BorderFadeOutRate=0.05;
	BorderFadeInRate=1.0;
	bShowFOW=false;
}