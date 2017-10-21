//  XComEdgeEffect.uc - Firaxis Games
//
// Author: Scott Boeckmann
// 02/14/2012
// Effect class for exposing Edge effect to the editor

class XComEdgeEffect extends PostProcessEffect
	native;

var TextureRenderTarget2D   m_kEdgeTexture;
var LinearColor             m_kOutlineColor;
var float                   m_kMaxSceneDepth;
/** Whether we are using the edge effect for targeting */
var bool                    m_bTargeting;
var int                     m_nDownsampleFactor;

var Vector                  m_kLevelVolumePosition;
var Vector                  m_kLevelVolumeDimensions;

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
	m_nDownsampleFactor=1
}