class X2AbilityMultiTarget_Lucu_CombatEngineer_DetPackRadius extends X2AbilityMultiTarget_Radius;

simulated function float GetTargetRadius(const XComGameState_Ability Ability)
{
    local float Radius;
    Radius = super.GetTargetRadius(Ability);
    
    // Basically add 2 tiles to the radius for the purposes of visualizing the target sphere.
    // This is due to a difference between standard radius ability measurements and destructible
    // death explosion radius. It won't be perfect because the destructible death explosion is a
    // cube instead of a sphere, but... you know...
    Radius += `TILESTOUNITS(2);

    return Radius;
}

simulated function GetMultiTargetsForLocation(const XComGameState_Ability Ability, const vector Location, out AvailableTarget Target)
{
    local array<TilePosPair> Tiles;
    local vector TileExtent;
    local TilePosPair Tile;
    //local array<XComDestructibleActor> DestructibleActors;
	//local XComDestructibleActor DestructibleActor;
    //local XComGameState_Destructible DestructibleState;
    local array<StateObjectReference> UnitRefs;
    local StateObjectReference UnitRef;

    GetTilesToCheckForLocation(Ability, Location, TileExtent, Tiles);

    foreach Tiles(Tile)
    {
        UnitRefs = `XWORLD.GetUnitsOnTile(Tile.Tile);

        foreach UnitRefs(UnitRef)
        {
            Target.AdditionalTargets.AddItem(UnitRef);
        }
    }
}

simulated function GetValidTilesForLocation(const XComGameState_Ability Ability, const vector Location, out array<TTile> ValidTiles)
{
    local vector TileExtent;
    local array<TilePosPair> CheckTiles;
    local TilePosPair CheckTile;

    GetTilesToCheckForLocation(Ability, Location, TileExtent, CheckTiles);

    foreach CheckTiles(CheckTile)
    {
        ValidTiles.AddItem(CheckTile.Tile);
    }
}

simulated protected function GetTilesToCheckForLocation(const XComGameState_Ability Ability, 
														const out vector Location, 
														out vector TileExtent, // maximum extent of the returned tiles from Location
														out array<TilePosPair> CheckTiles)
{
    GetRadialDamageTilesForLocation(Location, GetTileTargetRadius(Ability), TileExtent, CheckTiles);
}

simulated function int GetTileTargetRadius(const XComGameState_Ability Ability)
{
    local XComGameState_Item SourceWeapon;
    local X2WeaponTemplate SourceWeaponTemplate;

    if (bUseWeaponRadius)
    {
        SourceWeapon = Ability.GetSourceWeapon();
        if (SourceWeapon != none)
        {
            SourceWeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
            if (SourceWeaponTemplate != none)
            {
                return SourceWeaponTemplate.iRadius;
            }
        }
    }

    return `UNITSTOTILES(GetTargetRadius(Ability));
}

simulated function GetRadialDamageTilesForLocation(const vector Location,
                                                   const int Radius,
                                                   out vector TileExtent, // maximum extent of the returned tiles from Location
                                                   out array<TilePosPair> CheckTiles)
{
	local TilePosPair CurrentTile;
    local TTIle CenterTile;
	local int X, Y, Z;

    // What am I missing here? This seems too obvious
    TileExtent.X = Radius;
    TileExtent.Y = Radius;
    TileExtent.Z = Radius;

    // Look up the  center tile
    CenterTile = `XWORLD.GetTileCoordinatesFromPosition(Location);

    // Move +/- the tile radius in X,Y,Z coords
	for (X = CenterTile.X - Radius; X <= CenterTile.X + Radius; ++X)
	{
		CurrentTile.Tile.X = X;
		for (Y = CenterTile.Y - Radius; Y <= CenterTile.Y + Radius; ++Y)
		{
			CurrentTile.Tile.Y = Y;
			for (Z = CenterTile.Z - Radius; Z <= CenterTile.Z + Radius; ++Z)
			{
				CurrentTile.Tile.Z = Z;
                CurrentTile.WorldPos = `XWORLD.GetPositionFromTileCoordinates(CurrentTile.Tile);
				CheckTiles.AddItem(CurrentTile);
			}
		}
	}
}

simulated protected function bool ActorBlocksRadialDamage(Actor CheckActor, const out vector Location, int EnvironmentDamage)
{
    return false;
}
