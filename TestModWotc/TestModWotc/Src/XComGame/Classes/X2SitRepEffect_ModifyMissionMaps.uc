//---------------------------------------------------------------------------------------
//  FILE:    X2SitRepEffect_ModifyMissionMaps.uc
//  AUTHOR:  David Burchanowski  --  8/22/2016
//  PURPOSE: Allows placement of squad limitations via sitreps
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2SitRepEffect_ModifyMissionMaps extends X2SitRepEffectTemplate;

var array<MissionMapSwap> ReplacementMissionMaps; // for each swap, will replace one named mission map with another
var array<string> AdditionalMissionMaps; // these maps will be loaded in addition to the main mission scripting maps