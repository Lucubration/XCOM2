//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    SceneCaptureRadialComponent.uc
//  AUTHOR:  Jeremy Shopf -- 05/21/09
//  PURPOSE: Allows a scene depth capture to a 2D texture render target
//---------------------------------------------------------------------------------------
//  Copyright (c) 2009 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class SceneCaptureRadialComponent extends SceneCapture2DComponent
	native;

cpptext
{

public:

	/**
	* Create a new probe with info needed to render the scene
	*/
	virtual class FSceneCaptureProbe* CreateSceneCaptureProbe();
}
