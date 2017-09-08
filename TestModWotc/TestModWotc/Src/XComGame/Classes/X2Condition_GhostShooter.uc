class X2Condition_GhostShooter extends X2Condition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{ 
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(kTarget);
	if (UnitState == none)
		return 'AA_NotAUnit';

	if (UnitState.GhostSourceUnit.ObjectID > 0)
		return 'AA_UnitIsWrongType';
		
	return 'AA_Success'; 
}