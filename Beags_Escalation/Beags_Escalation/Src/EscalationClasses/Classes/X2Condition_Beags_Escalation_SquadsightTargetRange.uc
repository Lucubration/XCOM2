class X2Condition_Beags_Escalation_SquadsightTargetRange extends X2Condition;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource) 
{ 
	local XComGameStateHistory History;
	local XComGameState_Unit TargetUnit, SourceUnit;
	local StateObjectReference EffectRef;
	local XComGameState_Effect EffectState;
	local X2Effect_Beags_Escalation_SquadsightRange SquadsightRangeEffect;
	local X2Effect_Squadsight SquadsightEffect;
	local float TileDistance, SquadsightRange;

	SourceUnit = XComGameState_Unit(kSource);
	if (SourceUnit == none)
		return 'AA_Success';

	TargetUnit = XComGameState_Unit(kTarget);
	if (TargetUnit != none)
		TileDistance = SourceUnit.TileDistanceBetween(TargetUnit);
	else
		TileDistanceBetween(XComGameState_Destructible(kTarget), SourceUnit);

	History = `XCOMHISTORY;

	// If the unit doesn't have squadsight, they never have the option to target things out of their sight range, so only check this
	// if it's possible that the unit has partial squadsight	
	if (SourceUnit.HasSquadsight())
	{
		SquadsightRange = 0;
		foreach SourceUnit.AffectedByEffects(EffectRef)
		{
			EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
			SquadsightRangeEffect = X2Effect_Beags_Escalation_SquadsightRange(EffectState.GetX2Effect());
			SquadsightEffect = X2Effect_Squadsight(EffectState.GetX2Effect());
			// Find the max Squadsight Range effect
			if (SquadsightRangeEffect != none && SquadsightRangeEffect.Range > SquadsightRange)
				SquadsightRange = SquadsightRangeEffect.Range;
			// Also look for plain old Squadsight effects. This supercedes anything else
			if (SquadsightRangeEffect == none && SquadsightEffect != none)
			{
				SquadsightRange = -1;
				break;
			}
		}

		// If a squadsight range was defined, make sure the target is in range
		if (SquadsightRange > 0)
		{
			if ((TileDistance * class'XComWorldData'.const.WORLD_StepSize) - (SourceUnit.GetVisibilityRadius() * class'XComWorldData'.const.WORLD_METERS_TO_UNITS_MULTIPLIER) > SquadsightRange)
				return 'AA_NotInRange';
		}
	}

	return 'AA_Success'; 
}

function float TileDistanceBetween(XComGameState_Destructible TargetDestructible, XComGameState_Unit UnitState)
{
	local XComWorldData WorldData;
	local vector UnitLoc, TargetLoc;
	local float Dist;
	local int Tiles;

	if (TargetDestructible == none || TargetDestructible.TileLocation == UnitState.TileLocation)
		return 0;

	WorldData = `XWORLD;
	UnitLoc = WorldData.GetPositionFromTileCoordinates(UnitState.TileLocation);
	TargetLoc = WorldData.GetPositionFromTileCoordinates(TargetDestructible.TileLocation);
	Dist = VSize(UnitLoc - TargetLoc);
	Tiles = Dist / WorldData.WORLD_StepSize;      //@TODO gameplay - surely there is a better check for finding the number of tiles between two points
	return Tiles;
}