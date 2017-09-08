//---------------------------------------------------------------------------------------
//  FILE:    X2SitRepEffect_ModifyDefaultEncounterLists.uc
//  AUTHOR:  David Burchanowski  --  11/17/2016
//  PURPOSE: Allows sitreps to modify the defauly spawn lists
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2SitRepEffect_ModifyDefaultEncounterLists extends X2SitRepEffectTemplate
	native(Core);

// When selecting a spawn list to spawn a pod from, if no per-encounter specific spawn list
// is specified, these lists will be used instead of the mission default spawn list.
// You don't have to override both if you don't want to
var name DefaultLeaderListOverride;
var name DefaultFollowerListOverride;

defaultproperties
{
}