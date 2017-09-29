class X2AbilityMultiTarget_Lucu_CombatEngineer_DeployableCover extends X2AbilityMultiTarget_Radius;

simulated function GetValidTilesForLocation(const XComGameState_Ability Ability, const vector Location, out array<TTile> ValidTiles)
{
	local TTile Tile;
	local XComWorldData World;
	local bool bFoundFloorTile;

	World = `XWORLD;
    
	bFoundFloorTile = World.GetFloorTileForPosition(Location, Tile);
	if (bFoundFloorTile && World.CanUnitsEnterTile(Tile) && !World.IsRampTile(Tile))
	{
		ValidTiles.AddItem(Tile);
	}
}

simulated function bool CalculateValidLocationsForLocation(const XComGameState_Ability Ability, const vector Location, AvailableTarget AvailableTargets, out array<vector> ValidLocations)
{
	local TTile Tile;
	local XComWorldData World;
	local bool bFoundFloorTile;

	World = `XWORLD;

	bFoundFloorTile = World.GetFloorTileForPosition(Location, Tile);
	if (bFoundFloorTile && World.CanUnitsEnterTile(Tile) && !World.IsRampTile(Tile))
	{
		ValidLocations.AddItem(World.GetPositionFromTileCoordinates(Tile));
        return true;
	}

    return false;
}
