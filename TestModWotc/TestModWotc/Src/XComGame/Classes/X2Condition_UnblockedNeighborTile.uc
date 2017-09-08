class X2Condition_UnblockedNeighborTile extends X2Condition;

var bool RequireVisible;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit TargetUnitState;
	local name RetCode;
	local TTile NeighborTile;

	RetCode = 'AA_TileIsBlocked';

	TargetUnitState = XComGameState_Unit(kTarget);
	`assert(TargetUnitState != none);

	if( RequireVisible )
	{
		if( class'X2Effect_GetOverHere'.static.HasBindableNeighborTile(TargetUnitState) )
		{
			RetCode = 'AA_Success';
		}
	}
	else
	{
	if (TargetUnitState.FindAvailableNeighborTile(NeighborTile))
	{
		RetCode = 'AA_Success';
	}
	}
	
	return RetCode;
}