class X2Condition_Beags_Escalation_AbilityProperty extends X2Condition;

var array<name> OwnerHasSoldierAbilities;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit UnitState;
	local name AbilityName;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	if (UnitState == none)
		return 'AA_NotAUnit';

	foreach OwnerHasSoldierAbilities(AbilityName)
	{
		if (UnitState.FindAbility(AbilityName).ObjectID <= 0)
			return 'AA_AbilityUnavailable';
	}

	return 'AA_Success';
}
