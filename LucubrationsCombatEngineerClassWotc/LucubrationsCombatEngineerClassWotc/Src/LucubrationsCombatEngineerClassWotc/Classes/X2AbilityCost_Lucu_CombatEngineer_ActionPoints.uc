class X2AbilityCost_Lucu_CombatEngineer_ActionPoints extends X2AbilityCost_ActionPoints;

var array<name> DoNotConsumeAbilities;

simulated function int GetPointCost(XComGameState_Ability AbilityState, XComGameState_Unit AbilityOwner)
{
	local int PointCheck;

    PointCheck = super.GetPointCost(AbilityState, AbilityOwner);

	if (DoNotConsumePoints(AbilityState, AbilityOwner))
	{
		PointCheck = 0;
	}

	return PointCheck;
}

simulated function bool DoNotConsumePoints(XComGameState_Ability AbilityState, XComGameState_Unit AbilityOwner)
{
	local int i;

	for (i = 0; i < DoNotConsumeAbilities.Length; ++i)
	{
		if (AbilityOwner.HasSoldierAbility(DoNotConsumeAbilities[i]))
			return true;
	}

	return false;
}
