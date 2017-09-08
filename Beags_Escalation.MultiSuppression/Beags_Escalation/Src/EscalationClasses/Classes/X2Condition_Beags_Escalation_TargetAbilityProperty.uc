class X2Condition_Beags_Escalation_TargetAbilityProperty extends X2Condition;

var array<name> TargetHasSoldierAbilities;

function name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit UnitState;
	local name SoldierAbility;

	UnitState = XComGameState_Unit(kTarget);
	if (UnitState == none)
		return 'AA_NotAUnit';

	foreach TargetHasSoldierAbilities(SoldierAbility)
	{
		if (UnitState.FindAbility(SoldierAbility).ObjectID == 0)
			return 'AA_AbilityUnavailable';
	}

	return 'AA_Success';
}
