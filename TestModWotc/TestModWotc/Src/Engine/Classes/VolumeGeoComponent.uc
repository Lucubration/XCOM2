//---------------------------------------------------------------------------------------
//  FILE:    VolumeGeoComponent.uc
//  AUTHOR:  Ken Derda  --  5/28/2014
//  PURPOSE: Extend brush component to include a volume inclusion scene info pointer for
//           use in rendering thread.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class VolumeGeoComponent extends BrushComponent
	native;

var private native transient const pointer VolumeGeoSceneInfo{struct FVolumeGeoSceneInfo};

cpptext
{
	virtual void Attach();

	virtual void Detach( UBOOL bWillReattach = FALSE );
}