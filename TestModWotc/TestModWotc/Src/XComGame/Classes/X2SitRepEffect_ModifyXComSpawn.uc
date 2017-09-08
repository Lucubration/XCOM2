//---------------------------------------------------------------------------------------
//  FILE:    X2SitRepEffect_ModifyXComSpawn.uc
//  AUTHOR:  Russell Aasland  --  3/8/2017
//  PURPOSE: Allows sitreps to modify initial xcom spawning location
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2SitRepEffect_ModifyXComSpawn extends X2SitRepEffectTemplate;

var delegate<ModifyLocationsDelegate> ModifyLocationsFn;

delegate ModifyLocationsDelegate( out int IdealSpawnDistance, out int MinSpawnDistance );

event ModifyLocations( out int IdealSpawnDistance, out int MinSpawnDistance )
{
	if (ModifyLocationsFn != none)
		ModifyLocationsFn( IdealSpawnDistance, MinSpawnDistance );
}

defaultproperties
{
}