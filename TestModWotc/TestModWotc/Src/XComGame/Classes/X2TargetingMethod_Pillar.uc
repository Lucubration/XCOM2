class X2TargetingMethod_Pillar extends X2TargetingMethod_Teleport;

function name ValidateTargetLocations(const array<Vector> TargetLocations)
{
	local name AbilityAvailability;
	local TTile TeleportTile;
	local XComWorldData World;
	local bool bFoundFloorTile;

	AbilityAvailability = super.ValidateTargetLocations(TargetLocations);
	if (AbilityAvailability == 'AA_Success')
	{
		// There is only one target location and visible by squadsight
		World = `XWORLD;

		`assert(TargetLocations.Length == 1);
		bFoundFloorTile = World.GetFloorTileForPosition(TargetLocations[0], TeleportTile);
		if (bFoundFloorTile && !World.CanUnitsEnterTile(TeleportTile))
		{
			AbilityAvailability = 'AA_TileIsBlocked';
		}
		else if (World.IsRampTile(TeleportTile))
		{
			AbilityAvailability = 'AA_TileIsBlocked';
		}
	}

	return AbilityAvailability;
}