class X2Condition_Wrath extends X2Condition;

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

	PreferredDirection = Normal(World.GetPositionFromTileCoordinates(SourceUnitState.TileLocation) - World.GetPositionFromTileCoordinates(TargetUnitState.TileLocation));
	
	if (TargetUnitState.FindAvailableNeighborTileWeighted(PreferredDirection, NeighborTile))
	{
			return 'AA_Success';
	}

	return 'AA_TileIsBlocked';
}