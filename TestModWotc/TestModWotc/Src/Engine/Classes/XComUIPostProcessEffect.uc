//  XComUIPostProcessEffect.uc - Firaxis Games
//
// Author: Ken Derda
// 05/04/2015
// Effect class for exposing UI distortion effect to the editor

class XComUIPostProcessEffect extends MaterialEffect
	native;

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
	SceneDPG = SDPG_UIPostProcess
	bShowInEditor = TRUE
	bShowInGame = TRUE
	bAffectsLightingOnly = FALSE
}