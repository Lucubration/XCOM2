/**
* If they are bShowInGame they are still evaluated and will take up GPU time even if their effects are not seen.
 * So for MaterialEffects that are in your Post Process Chain you will want to manage them by toggling bShowInGame
 * for when you see them if they are not always evident.  (e.g. you press a button to go into "see invis things" mode 
 * which has some expensive and cool looking material.  You want to toggle that on the button press and not have it on
 * all the time)
 */
class PhotoboothEffect extends PostProcessEffect
	native;

var float						X, Y;
var float						SizeX, SizeY;

enum PBEffectType
{
	ePBET_GeneratePoster,
	ePBET_ShowPoster
};

var() PBEffectType				eEffectType;

// Used when showing the Poster
var TextureRenderTarget2D		SoldierRenderTarget;

// Used when generating the Poster
var TextureRenderTarget2D		UIRenderTarget;
var Texture2D					BackgroundTexture;
var MaterialInterface			FirstPassFilterMI;
var MaterialInterface			SecondPassFilterMI;
					
var LinearColor					GradientColor1;
var LinearColor					GradientColor2;
var bool						bOverrideBackgroundTextureColor;

enum PBMajorAxis
{
	ePBMajorAxis_X,
	ePBMajorAxis_Y
};

var() PBMajorAxis				m_eMajorAxis;

cpptext
{
    // UPostProcessEffect interface

	/**
	 * Creates a proxy to represent the render info for a post process effect
	 * @param WorldSettings - The world's post process settings for the view.
	 * @return The proxy object.
	 */
	virtual class FPostProcessSceneProxy* CreateSceneProxy(const FPostProcessSettings* WorldSettings);
}

defaultproperties
{
	X=0
	Y=0
	SizeX=0
	SizeY=0

	eEffectType=ePBET_GeneratePoster

	GradientColor1=(R=0.0,G=0.0,B=0.0,A=0.0)
	GradientColor2=(R=1.0,G=1.0,B=1.0,A=0.0)
	bOverrideBackgroundTextureColor=false
}