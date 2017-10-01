class X2AbilityMultiTarget_Lucu_CombatEngineer_SIMON extends X2AbilityMultiTarget_Radius;

simulated function GetMultiTargetsForLocation(const XComGameState_Ability Ability, const vector Location, out AvailableTarget Target)
{
    local array<TilePosPair> CheckTiles;
    local vector TileExtent;
    local TilePosPair CheckTile;
    local array<StateObjectReference> UnitRefs;
    local StateObjectReference UnitRef;

    super.GetTilesToCheckForLocation(Ability, Location, TileExtent, CheckTiles);
    
    FilterTilesForLocation(Ability, Location, CheckTiles);

    foreach CheckTiles(CheckTile)
    {
        UnitRefs = `XWORLD.GetUnitsOnTile(CheckTile.Tile);

        foreach UnitRefs(UnitRef)
        {
            if (Target.AdditionalTargets.Find('ObjectId', UnitRef.ObjectId) == INDEX_NONE)
            {
                Target.AdditionalTargets.AddItem(UnitRef);
            }
        }
    }
}

simulated function GetValidTilesForLocation(const XComGameState_Ability Ability, const vector Location, out array<TTile> ValidTiles)
{
    local array<TilePosPair> CheckTiles;
    local vector TileExtent;
    local TilePosPair CheckTile;

    super.GetTilesToCheckForLocation(Ability, Location, TileExtent, CheckTiles);
    
    FilterTilesForLocation(Ability, Location, CheckTiles);

    foreach CheckTiles(CheckTile)
    {
        ValidTiles.AddItem(CheckTile.Tile);
    }
}

simulated protected function FilterTilesForLocation(const XComGameState_Ability Ability,
													const out vector TargetLocation,
													out array<TilePosPair> CheckTiles)
{
	local XComGameStateHistory History;
    local XComGameState_Unit Owner;
    local XComGameState_Item Ammo;
	local TilePosPair CheckTile;
    local vector ShooterLocation, CWLimitLocation, CCWLimitLocation;
    local float Radius, WeaponAngle, TargetAngle;
    local int Sign1, Sign2;
    local array<TilePosPair> ValidTiles;
    
	History = `XCOMHISTORY;

	Owner = XComGameState_Unit(History.GetGameStateForObjectID(Ability.OwnerStateObject.ObjectID));
    ShooterLocation = `XWORLD.GetPositionFromTileCoordinates(Owner.TileLocation);
    Radius = GetUnitsTargetRadius(Ability);
    Ammo = XComGameState_Item(History.GetGameStateForObjectID(Ability.SourceAmmo.ObjectID));
    WeaponAngle = X2SIMONTemplate_Lucu_CombatEngineer(Ammo.GetMyTemplate()).fAngle;

    TargetAngle = DegreesAroundCircle(ShooterLocation, TargetLocation);
    if (TargetLocation.X < ShooterLocation.X)
        TargetAngle *= -1.0f;
        
    CWLimitLocation = PointOnCircle(Radius, TargetAngle + (WeaponAngle / 2.0f), TargetLocation);
    CCWLimitLocation = PointOnCircle(Radius, TargetAngle - (WeaponAngle / 2.0f), TargetLocation);
    
    foreach CheckTiles(CheckTile)
    {
        Sign1 = SignOfPoint(TargetLocation, CWLimitLocation, CheckTile.WorldPos);
        Sign2 = SignOfPoint(TargetLocation, CCWLimitLocation, CheckTile.WorldPos);
        if (Sign1 <= 0 && Sign2 <= 0)
        {
            ValidTiles.AddItem(CheckTile);
        }
    }

    CheckTiles = ValidTiles;
}

simulated function float DegreesAroundCircle(const out vector ShooterLocation, const out vector TargetLocation)
{
    local float Radius, Radius2;
    
    Radius2 = Square(ShooterLocation.X - TargetLocation.X) + Square(ShooterLocation.Y - TargetLocation.Y);
    Radius = Sqrt(Radius2);

    return ACos((Radius2 + Radius2 - Square(ShooterLocation.X - TargetLocation.X) - Square(ShooterLocation.Y + Radius - TargetLocation.Y)) /
                (2 * Radius2)) * 180.0f / Pi;
}

simulated function vector PointOnCircle(float Radius, float AngleInDegrees, const out vector CenterLocation)
{
    local vector Location;

    Location.Z = CenterLocation.Z;

    Location.X = CenterLocation.X - Radius * Cos(AngleInDegrees * Pi / 180.0f);
    Location.Y = CenterLocation.Y + Radius * Sin(AngleInDegrees * Pi / 180.0f);

    return Location;
}

simulated function int SignOfPoint(const out vector CenterLocation, const out vector RadiusLocation, const out vector CheckLocation)
{
    return Sgn((RadiusLocation.X - CenterLocation.X) *
               (CheckLocation.Y - CenterLocation.Y) -
               (RadiusLocation.Y - CenterLocation.Y) *
               (CheckLocation.X - CenterLocation.X));
}

simulated function float GetUnitsTargetRadius(const XComGameState_Ability Ability)
{
    local XComGameState_Item SourceWeapon;
    local X2WeaponTemplate SourceWeaponTemplate;

    if (bUseWeaponRadius)
    {
        // Using ammo instead of weapon
        SourceWeapon = Ability.GetSourceAmmo();
        if (SourceWeapon != none)
        {
            SourceWeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
            if (SourceWeaponTemplate != none)
            {
                return `TILESTOUNITS(SourceWeaponTemplate.iRadius);
            }
        }
    }

    return GetTargetRadius(Ability);
}
