//---------------------------------------------------------------------------------------
//  FILE:    X2TargetingMethod_DLC_2IcarusJump.uc
//  AUTHOR:  Joshua Bouscher
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2TargetingMethod_DLC_2IcarusJump extends X2TargetingMethod_Teleport;

function name ValidateTargetLocations(const array<Vector> TargetLocations)
{
	local name AbilityAvailability;
	local XComWorldData World;
	local int MaxZ;
	
	AbilityAvailability = super.ValidateTargetLocations(TargetLocations);
	if (AbilityAvailability == 'AA_Success')
	{
		World = `XWORLD;
		`assert(TargetLocations.Length == 1);
		MaxZ = class'XComWorldData'.const.WORLD_FloorHeightsPerLevel * class'XComWorldData'.const.WORLD_TotalLevels * class'XComWorldData'.const.WORLD_FloorHeight;
		if (!World.HasOverheadClearance(TargetLocations[0], MaxZ))
		{
			AbilityAvailability = 'AA_TileIsBlocked';
		}
	}
	return AbilityAvailability;
}