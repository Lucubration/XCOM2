//---------------------------------------------------------------------------------------
//  FILE:    X2SitRepEffect_ModifyPodLocations.uc
//  AUTHOR:  Russell Aasland  --  1/20/2017
//  PURPOSE: Allows sitreps to modify pod spawn location
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2SitRepEffect_ModifyPodLocations extends X2SitRepEffectTemplate
	native(Core);

var delegate<ModifyLocationsDelegate> ModifyLocationsFn;

delegate ModifyLocationsDelegate( out float ZoneOffsetFromLOP, out float ZoneOffsetAlongLOP );

event ModifyLocations( out float ZoneOffsetFromLOP, out float ZoneOffsetAlongLOP )
{
	if (ModifyLocationsFn != none)
		ModifyLocationsFn( ZoneOffsetFromLOP, ZoneOffsetAlongLOP );
}

defaultproperties
{
}