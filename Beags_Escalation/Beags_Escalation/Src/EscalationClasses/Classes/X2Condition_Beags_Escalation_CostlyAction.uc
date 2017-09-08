class X2Condition_Beags_Escalation_CostlyAction extends X2Condition;

var bool	UnitTookCostlyAction;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local UnitValue Value;
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(kTarget);
	if (UnitState == none)
		return 'AA_NotAUnit';

	if ((UnitState.GetUnitValue('MovesThisTurn', Value) && Value.fValue > 0) ||
		(UnitState.GetUnitValue('AttacksThisTurn', Value) && Value.fValue > 0))
	{
		return (UnitTookCostlyAction ? 'AA_Success' : 'AA_ValueCheckFailed');
	}

	return (UnitTookCostlyAction ? 'AA_ValueCheckFailed' : 'AA_Success');
}