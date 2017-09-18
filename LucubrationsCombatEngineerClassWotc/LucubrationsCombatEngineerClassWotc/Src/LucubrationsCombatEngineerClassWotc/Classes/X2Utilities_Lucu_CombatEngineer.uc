class X2Utilities_Lucu_CombatEngineer extends Object;

static function name GatherAbilityTargets(const XComGameState_Ability Ability, out array<AvailableTarget> Targets)
{
	local int i, j;
	local XComGameState_Unit kOwner;
	local name AvailableCode;
	local XComGameStateHistory History;
    local X2AbilityTemplate AbilityTemplate;

	AbilityTemplate = Ability.GetMyTemplate();
	History = `XCOMHISTORY;
	kOwner = XComGameState_Unit(History.GetGameStateForObjectID(Ability.OwnerStateObject.ObjectID));

	if (AbilityTemplate != None)
	{
		AvailableCode = AbilityTemplate.AbilityTargetStyle.GetPrimaryTargetOptions(Ability, Targets);
		if (AvailableCode != 'AA_Success')
			return AvailableCode;
	
		for (i = Targets.Length - 1; i >= 0; --i)
		{
			AvailableCode = AbilityTemplate.CheckTargetConditions(Ability, kOwner, History.GetGameStateForObjectID(Targets[i].PrimaryTarget.ObjectID));
			if (AvailableCode != 'AA_Success')
			{
				Targets.Remove(i, 1);
			}
		}

		if (AbilityTemplate.AbilityMultiTargetStyle != none)
		{
			AbilityTemplate.AbilityMultiTargetStyle.GetMultiTargetOptions(Ability, Targets);
			for (i = Targets.Length - 1; i >= 0; --i)
			{
				for (j = Targets[i].AdditionalTargets.Length - 1; j >= 0; --j)
				{
					AvailableCode = AbilityTemplate.CheckMultiTargetConditions(Ability, kOwner, History.GetGameStateForObjectID(Targets[i].AdditionalTargets[j].ObjectID));
					if (AvailableCode != 'AA_Success' || (Targets[i].AdditionalTargets[j].ObjectID == Targets[i].PrimaryTarget.ObjectID) && !AbilityTemplate.AbilityMultiTargetStyle.bAllowSameTarget)
					{
						Targets[i].AdditionalTargets.Remove(j, 1);
					}
				}

				AvailableCode = AbilityTemplate.AbilityMultiTargetStyle.CheckFilteredMultiTargets(Ability, Targets[i]);
				if (AvailableCode != 'AA_Success')
					Targets.Remove(i, 1);
			}
		}

		//The Multi-target style may have deemed some primary targets invalid in calls to CheckFilteredMultiTargets - so CheckFilteredPrimaryTargets must come afterwards.
		AvailableCode = AbilityTemplate.AbilityTargetStyle.CheckFilteredPrimaryTargets(Ability, Targets);
		if (AvailableCode != 'AA_Success')
			return AvailableCode;
	}
	return 'AA_Success';
}
