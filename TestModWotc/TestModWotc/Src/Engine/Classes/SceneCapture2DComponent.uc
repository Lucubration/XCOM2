/**
 * SceneCapture2DComponent
 *
 * Allows a scene capture to a 2D texture render target
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SceneCapture2DComponent extends SceneCaptureComponent
	native;

/** render target resource to set as target for capture */
var(Capture) const TextureRenderTarget2D TextureTarget;
/** horizontal field of view */
var(Capture) const float FieldOfView;
/** near plane clip distance */
var(Capture) const float NearPlane;
/** far plane clip distance: <= 0 means no far plane */
var(Capture) const float FarPlane;
// BEGIN FIRAXIS jshopf
/** Width of the image plane. Don't use this if you're using a perspective view */
var(Capture) const float OrthoWidth;
/** Height of the image plane. Don't use this if you're using a perspective view */
var(Capture) const float OrthoHeight;
/** X coordinate of TextureTarget to use */
var(Capture) const int TargetX;
/** Y coordinate of TextureTarget to use */
var(Capture) const int TargetY;
/** Width of TextureTarget to use, 0 for full width */
var(Capture) const int TargetWidth;
/** Height coordinate of TextureTarget to use, 0 for full height */
var(Capture) const int TargetHeight;

var(Capture) const EAspectRatioAxisConstraint AxisConstraint;

var(Capture) bool bIsHeadCapture;
var bool bIsPhotoboothPreview;

// END FIRAXIS
/** set to false to disable automatic updates of the view/proj matrices */
var bool bUpdateMatrices;
// transients
/** view matrix used for rendering */
var const transient matrix ViewMatrix;
/** projection matrix used for rendering */
var const transient matrix ProjMatrix;

var transient int FrameDelay;

cpptext
{
protected:

	// UActorComponent interface

	/**
	* Attach a new 2d capture component
	*/
	virtual void Attach();

	/**
	 * Sets the ParentToWorld transform the component is attached to.
	 * @param ParentToWorld - The ParentToWorld transform the component is attached to.
	 */
	virtual void SetParentToWorld(const FMatrix& ParentToWorld);

public:

	/**
	* Constructor
	*/
	USceneCapture2DComponent() :
		ViewMatrix(FMatrix::Identity),
		ProjMatrix(FMatrix::Identity)
		{}

	/**
	* Update the projection matrix using the fov,near,far,aspect
	*/
	void UpdateProjMatrix();

	// SceneCaptureComponent interface

	/**
	* Create a new probe with info needed to render the scene
	*/
	virtual class FSceneCaptureProbe* CreateSceneCaptureProbe();
}

// FIRAXIS CHANGE jshopf
/** interface for changing TextureTarget, FOV, and clip planes */
native noexport final function SetCaptureParameters( optional TextureRenderTarget2D NewTextureTarget = TextureTarget,
							optional float NewFOV = FieldOfView, optional float NewNearPlane = NearPlane,
							optional float NewFarPlane = FarPlane, optional float NewOrthoWidth = OrthoWidth,
							optional float NewOrthoHeight = OrthoHeight, optional int NewTargetX = 0, optional int NewTargetY = 0,
							optional int NewTargetWidth = 0, optional int NewTargetHeight = 0, optional EAspectRatioAxisConstraint NewAxisConstraint = AspectRatio_MajorAxisFOV,
							optional float NewConstrainedAspectRatio = -1);

delegate OnCaptureFinished(TextureRenderTarget2D RenderTarget);

// Callback for when a requested capture finishes
event CaptureFinished()
{
	OnCaptureFinished(TextureTarget);
}

/** changes the view location and rotation
 * @note: unless bUpdateMatrices is false, this will get overwritten as soon as the component or its owner moves
 */
native final function SetView(vector NewLocation, rotator NewRotation);

defaultproperties
{
	NearPlane=20
	FarPlane=500
	FieldOfView=80
	// FIRAXIS BEGIN jshopf
	OrthoWidth=0
	OrthoHeight=0
	TargetX=0
	TargetY=0
	TargetWidth=0
	TargetHeight=0
	// FIRAXIS END
	bUpdateMatrices=true
	FrameDelay=0
	bIsPhotoboothPreview=false
}
