class X2TargetingMethod_Nova extends X2TargetingMethod_TopDown;

function CheckForFriendlyUnit(const out array<Actor> list)
{
	local XComGameStateHistory History;
	local Actor TargetActor;
	local XGUnit TargetUnit;
	local ETeam FiringUnitTeam;
	local XComDestructibleActor TargetDestructible;
	local XComGameState_Destructible DestructibleState;
	local bool bWarnRobotsOnly;
	local XComGameState_Item SourceWeapon;
	local X2GrenadeTemplate GrenadeTemplate;
	local UnitValue NovaValue;

	bFriendlyFireAgainstUnits = false;
	bFriendlyFireAgainstObjects = false;
	bSeriousConsequencesForAction = false;

	if (!AbilityIsOffensive)
		return;

	bWarnRobotsOnly = Ability.GetMyTemplate().bFriendlyFireWarningRobotsOnly;
	SourceWeapon = Ability.GetSourceWeapon();
	if (SourceWeapon != none)
	{
		GrenadeTemplate = X2GrenadeTemplate(SourceWeapon.GetMyTemplate());
		if (GrenadeTemplate != none && GrenadeTemplate.bFriendlyFireWarningRobotsOnly)
		{
			bWarnRobotsOnly = true;
		}
		GrenadeTemplate = X2GrenadeTemplate(SourceWeapon.GetLoadedAmmoTemplate(Ability));
		if (GrenadeTemplate != none && GrenadeTemplate.bFriendlyFireWarningRobotsOnly)
		{
			bWarnRobotsOnly = true;
		}
	}

	History = `XCOMHISTORY;

	FiringUnitTeam = FiringUnit.GetTeam();
	foreach list(TargetActor)
	{
		TargetUnit = XGUnit(TargetActor);

		if (TargetUnit != none && (TargetUnit.GetTeam() == FiringUnitTeam) && TargetUnit.IsAlive())
		{
			if (bWarnRobotsOnly && !TargetUnit.IsRobotic())
				continue;
			
			//	if we haven't used nova yet, we won't damage ourselves, so don't warn about friendly fire for that
			if (TargetUnit == FiringUnit)
			{
				UnitState.GetUnitValue('NovaUsedAmount', NovaValue);
				if (NovaValue.fValue == 0)
					continue;
			}
			// I am friendly!
			bFriendlyFireAgainstUnits = true;
		}

		TargetDestructible = XComDestructibleActor(TargetActor);
		if (TargetDestructible != none && History.GetGameStateComponentForObjectID(TargetDestructible.ObjectID, class'XComGameState_ObjectiveInfo') != none && !bWarnRobotsOnly)
		{
			DestructibleState = XComGameState_Destructible(History.GetGameStateForObjectID(TargetDestructible.ObjectID));
			if (!DestructibleState.IsTargetable(FiringUnitTeam) && DestructibleState.Health > 0) // health < 0 == invincible
			{
				bFriendlyFireAgainstObjects = true;
			}
		}

		//Just to be pedantic, don't give up searching until we know that there's friendly-fire against both units and objects.
		//(In case something wants to specifically handle the "both" case)
		if (bFriendlyFireAgainstObjects && bFriendlyFireAgainstUnits)
			break;
	}
}