class X2AbilityTarget_Beags_Escalation_Rocket extends X2AbilityTarget_Cursor;

simulated function float GetCursorRangeMeters(XComGameState_Ability AbilityState)
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local XComGameState_Item SourceWeapon;
	local X2RocketLauncherTemplate_Beags_Escalation RocketLauncherTemplate;
	local int RangeInTiles;
	local float RangeInMeters;
	local float RangeMult;
	
	History = `XCOMHISTORY;

	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

	if (bRestrictToWeaponRange)
	{
		SourceWeapon = AbilityState.GetSourceWeapon();
		if (SourceWeapon != none)
		{
			RangeInTiles = SourceWeapon.GetItemRange(AbilityState);

			RocketLauncherTemplate = X2RocketLauncherTemplate_Beags_Escalation(SourceWeapon.GetMyTemplate());
			// Update the targeting range based on the unit's rocket range modifiers
			if (RocketLauncherTemplate != none)
				RangeInTiles = RocketLauncherTemplate.ModifyRocketRange(UnitState, AbilityState, RangeInTiles);

			if (RangeInTiles == 0)
			{
				// This is melee range
				RangeInMeters = class'XComWorldData'.const.WORLD_Melee_Range_Meters;
			}
			else
			{
				RangeInMeters = `UNITSTOMETERS(`TILESTOUNITS(RangeInTiles));

				if (RocketLauncherTemplate != none)
				{
					// Apply targeting range reduction to the semi-final rocket launcher range
					RangeMult = 1.0;
					if (UnitState.AffectedByEffectNames.Find(class'X2Effect_Suppression'.default.EffectName) != INDEX_NONE)
						RangeMult = RocketLauncherTemplate.SuppressionRangePenalty;

					RangeInMeters *= RangeMult;
				}
			}
		}
	}
	else
	{
		RangeInMeters = FixedAbilityRange;
	}
	
	return RangeInMeters;
}
