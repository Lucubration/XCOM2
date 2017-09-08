class PA_MoltCondition extends X2Condition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameStateHistory History;
	local XComGameState_Unit	TargetUnit;
	local array<name>			DamageTypeNames;
	local name					DamageTypeName;
	local StateObjectReference	AffectedByEffectRef;
	local XComGameState_Effect	AffectedByEffectState;
	local X2Effect				AffectedByEffect;

	History = `XCOMHISTORY;	

	TargetUnit = XComGameState_Unit(kTarget);
	if (TargetUnit == none)
	{
		//`LOG("Playable Advent: Target " @ TargetUnit.GetFullName() @ " is... not.");

		return 'AA_NotAUnit';
	}

	if (TargetUnit.IsDead())
	{
		//`LOG("Playable Advent: Target " @ TargetUnit.GetFullName() @ " is dead.");

		return 'AA_UnitIsDead';
	}

	if (TargetUnit.IsMindControlled())
	{
		//`LOG("Playable Advent: Target " @ TargetUnit.GetFullName() @ " is mind controlled.");

		return 'AA_UnitIsMindControlled';
	}

	//`LOG("Playable Advent: Checking target " @ TargetUnit.GetFullName() @ " for conditions.");

	// We know the condtions we want to cure. Grab the damage type names from the Viper abilities class
	DamageTypeNames = class'PA_Abilities'.static.GetViperMoltDamageTypeNames();
	// Check all of the effects affecting the target unit
	foreach TargetUnit.AffectedByEffects(AffectedByEffectRef)
	{
		AffectedByEffectState = XComGameState_Effect(History.GetGameStateForObjectID(AffectedByEffectRef.ObjectID));
		// Get the effect template, which has the damage type name(s)
		AffectedByEffect = AffectedByEffectState.GetX2Effect();

		foreach AffectedByEffect.DamageTypes(DamageTypeName)
		{
			//  If we find one from our list of damage types to cure, indicate success
			if (DamageTypeNames.Find(DamageTypeName) != INDEX_NONE)
			{
				//`LOG("Playable Advent: Target " @ TargetUnit.GetFullName() @ " affected by condition " @ X2Effect_Persistent(AffectedByEffect).FriendlyName @ ", which can be molted.");

				return 'AA_Success';
			}
		}
	}

	return 'AA_UnitIsNotImpaired';
}

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
	local XComGameState_Unit SourceUnit, TargetUnit;

	SourceUnit = XComGameState_Unit(kSource);
	TargetUnit = XComGameState_Unit(kTarget);

	if (SourceUnit == none || TargetUnit == none)
		return 'AA_NotAUnit';

	// Only allow this to apply to self
	if (SourceUnit.ObjectID == TargetUnit.ObjectID)
		return 'AA_Success';

	return 'AA_UnitIsHostile';
}
