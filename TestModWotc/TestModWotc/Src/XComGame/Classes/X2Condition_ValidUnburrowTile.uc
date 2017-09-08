class X2Condition_ValidUnburrowTile extends X2Condition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit TargetUnitState;
	local name RetCode;
	local XComWorldData World;

	World = `XWORLD;

	TargetUnitState = XComGameState_Unit(kTarget);
	`assert(TargetUnitState != none);

	RetCode = 'AA_TileIsBlocked';
	if( !World.IsTileFullyOccupied(TargetUnitState.TileLocation) && !World.AreOtherUnitsOnTile( TargetUnitState.TileLocation, TargetUnitState ))
	{
		// The tile is not fully occupied by static level data
		// There is no unit blocking this tile
		// AND the unit does not block itself
		RetCode = 'AA_Success';
	}
	
	return RetCode;
}