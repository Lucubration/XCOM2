//  MLAAEffect.uc - Firaxis Games
//
// Author: Jeremy Shopf
// 
// Effect class for exposing MLAA settings to the editor

class MLAAEffect extends PostProcessEffect
	native;

var (MLAA) float LuminanceThreshold;

enum EMLAAMode
{
	EMLAAMode_Normal,
	EMLAAMode_ForceOff,
	EMLAAMode_DistanceX,
	EMLAAMode_DistanceY,
	EMLAAMode_BlendingWeights,
};

var EMLAAMode CurrentMode;

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
	LuminanceThreshold=0.05;
	CurrentMode=EMLAAMode_Normal;
}