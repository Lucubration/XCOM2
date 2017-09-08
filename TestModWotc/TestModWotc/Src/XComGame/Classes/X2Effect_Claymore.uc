//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Claymore.uc
//  AUTHOR:  Joshua Bouscher  --  7/18/2016
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Effect_Claymore extends X2Effect_SpawnDestructible
	native(Core);

DefaultProperties
{
	EffectName = "Claymore"
	DuplicateResponse = eDupe_Allow
	TargetingIcon=Texture2D'UILibrary_XPACK_Common.target_claymore'
	bTargetableBySpawnedTeamOnly = true
}