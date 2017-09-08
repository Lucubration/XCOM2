// A directional bomb uses a cone target, but it's very wide so it can't be flattened at the end like the default cone
class X2AbilityMultiTarget_Beags_Escalation_Cone extends X2AbilityMultiTarget_SoldierBonusRadius;

var float ConeAngle;
var bool bUseWeaponAngle;

simulated function float GetTargetRadius(const XComGameState_Ability Ability)
{
	return super.GetTargetRadius(Ability);
}

function float GetConeAngle(const XComGameState_Ability Ability)
{
	local XComGameState_Item Weapon;
	local X2BombTemplate_Beags_Escalation WeaponTemplate;

	if (bUseWeaponAngle)
	{
		Weapon = Ability.GetSourceWeapon();
		`assert(Weapon != none);
		WeaponTemplate = X2BombTemplate_Beags_Escalation(Weapon.GetMyTemplate());
		`assert(WeaponTemplate != none);
		
		return WeaponTemplate.fAngle;
	}
	
	return ConeAngle;
}

simulated function GetValidTilesForLocation(const XComGameState_Ability Ability, const vector Location, out array<TTile> ValidTiles)
{
	local XComWorldData WorldData;
	local XComGameStateHistory History;
	local XComGameState_Unit SourceUnit;
	local array<TTile> ValidTilesInRadius;
	local TTile ValidTile;
	local float Angle, Radius;
	local vector Center, LimitCCW, LimitCW;
	
	WorldData = `XWORLD;
	History = `XCOMHISTORY;

	// Return tiles within the radius and arc of this cone. I'm not 100% on how they figure it in the native code, but I expect
	// that the *center* of the tile has to fall within the geometic area

	// Begin by finding valid tiles within the whole circle
	super.GetValidTilesForLocation(Ability, Location, ValidTilesInRadius);

	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(Ability.OwnerStateObject.ObjectID));
	`assert(SourceUnit != none);

	// Find the two sector end vectors
	Center = WorldData.GetPositionFromTileCoordinates(SourceUnit.TileLocation);
	Angle = GetConeAngle(Ability);
	Radius = GetTargetRadius(Ability);
	LimitCCW = RotatePointAroundCircle(Center, Location, Angle / 2, Radius);
	LimitCW = RotatePointAroundCircle(Center, Location, -1 * Angle / 2, Radius);

	// Filter tiles in radius based on whether they are within the circle sector of the cone
	ValidTiles.Length = 0;
	foreach ValidTilesInRadius(ValidTile)
	{
		if (AreClockwise(LimitCCW, WorldData.GetPositionFromTileCoordinates(ValidTile)) && !AreClockwise(LimitCW, WorldData.GetPositionFromTileCoordinates(ValidTile)))
			ValidTiles.AddItem(ValidTile);
	}
}

simulated function vector RotatePointAroundCircle(vector Center, vector Location, float Angle, float Radius)
{
	local vector Ret;

	// Convert angle from degrees into radians
	Angle = PI * Angle / 180.0f;

	// Rotate the point around the circle
	Ret.x = cos(Angle) * (Location.x - Center.x) - sin(Angle) * (Location.y - Center.y) + Center.x;
	Ret.y = sin(Angle) * (Location.x - Center.x) + cos(Angle) * (Location.y - Center.y) + Center.y;

	return Ret;
}

simulated function bool AreClockwise(vector v1, vector v2)
{
	return -1 * v1.x * v2.y + v1.y * v2.x > 0;
}