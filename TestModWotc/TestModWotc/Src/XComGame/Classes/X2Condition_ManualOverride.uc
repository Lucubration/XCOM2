class X2Condition_ManualOverride extends X2Condition;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit AbilityOwner;
	local StateObjectReference AbilityRef;
	local XComGameState_Ability AbilityState;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;
	AbilityOwner = XComGameState_Unit(History.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	if (AbilityOwner != none)
	{
		foreach AbilityOwner.Abilities(AbilityRef)
		{
			if (AbilityRef.ObjectID == kAbility.ObjectID)
				continue;

			AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));
			if (AbilityState != none && AbilityState.iCooldown > 0)
				return 'AA_Success';
		}
	}

	return 'AA_AbilityUnavailable';
}