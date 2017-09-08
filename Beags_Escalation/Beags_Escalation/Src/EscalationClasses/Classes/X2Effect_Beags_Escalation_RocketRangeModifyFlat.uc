class X2Effect_Beags_Escalation_RocketRangeModifyFlat extends X2Effect_Persistent;

var float RangeModifier;
var array<X2Condition> ApplyRangeModifierConditions;

function float ModifyRocketRange(XComGameState_Unit UnitState, XComGameState_Ability AbilityState, float RocketRange)
{
	local X2Condition Condition;

	foreach ApplyRangeModifierConditions(Condition)
	{
		if (Condition.AbilityMeetsCondition(AbilityState, UnitState) != 'AA_Success')
			return RocketRange;

		if (Condition.MeetsCondition(UnitState) != 'AA_Success')
			return RocketRange;
	}

	return RocketRange + RangeModifier;
}
