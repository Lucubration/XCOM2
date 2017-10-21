class X2Condition_Wrath extends X2Condition;

var TTile TargetTile;

static function bool DefaultMeleeVisibility(const out TTile TileOption, const out TTile SourceTile, const out Object PassedObject)
{
	local XComWorldData WorldData;
	local X2Condition_Wrath WrathCondition;
	local TTile SourceAdjacencyTestTile, TargetAdjacencyTestTile;

	WrathCondition = X2Condition_Wrath(PassedObject);
	WorldData = `XWORLD;

	SourceAdjacencyTestTile.X = WrathCondition.TargetTile.X;
	SourceAdjacencyTestTile.Y = WrathCondition.TargetTile.Y;
	SourceAdjacencyTestTile.Z = TileOption.Z;

	TargetAdjacencyTestTile.X = TileOption.X;
	TargetAdjacencyTestTile.Y = TileOption.Y;
	TargetAdjacencyTestTile.Z = WrathCondition.TargetTile.Z;

	if( WorldData.IsAdjacentTileBlocked(WrathCondition.TargetTile, TargetAdjacencyTestTile)
	   && WorldData.IsAdjacentTileBlocked(TileOption, SourceAdjacencyTestTile) )
	{
		return false;
	}

	// No attacking through floors.
	if( (TileOption.Z >WrathCondition.TargetTile.Z) && WorldData.IsFloorTile(SourceAdjacencyTestTile) )
	{
		return false;
	}

	return true;
}

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
	local XComGameState_Unit TargetUnitState, SourceUnitState;
	local TTile NeighborTile;
	local Vector PreferredDirection;
	local XComWorldData World;

	SourceUnitState = XComGameState_Unit(kSource);
	TargetUnitState = XComGameState_Unit(kTarget);
	`assert(TargetUnitState != none);
	`assert(SourceUnitState != none);
	
	World = `XWORLD;
	TargetTile = TargetUnitState.TileLocation;

	PreferredDirection = Normal(World.GetPositionFromTileCoordinates(SourceUnitState.TileLocation) - World.GetPositionFromTileCoordinates(TargetUnitState.TileLocation));
	
	if ( TargetUnitState.FindAvailableNeighborTileWeighted(PreferredDirection, NeighborTile, DefaultMeleeVisibility, self))
	{
		return 'AA_Success';
	}

	return 'AA_TileIsBlocked';
}