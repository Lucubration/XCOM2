class X2Condition_Beags_Escalation_UnitEffectsWithAbilitySource extends X2Condition_UnitEffectsWithAbilitySource;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	return 'AA_Success';
}

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
	local XComGameStateHistory History;
	local XComGameState_Unit TargetUnit, SourceUnit;
	local StateObjectReference EffectRef;
	local XComGameState_Effect EffectState;
	local EffectReason Reason;
	local name EffectName;
	local bool EffectFound;
	
	History = `XCOMHISTORY;

	TargetUnit = XComGameState_Unit(kTarget);
	SourceUnit = XComGameState_Unit(kSource);
	
	foreach ExcludeEffects(Reason)
	{
		foreach TargetUnit.AffectedByEffects(EffectRef)
		{
			EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
			EffectName = EffectState.GetX2Effect().EffectName;
			if (Reason.EffectName == EffectName && EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == SourceUnit.ObjectID && !EffectState.bRemoved)
				return Reason.Reason;
		}
	}

	foreach RequireEffects(Reason)
	{
		EffectFound = false;
		foreach TargetUnit.AffectedByEffects(EffectRef)
		{
			EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
			EffectName = EffectState.GetX2Effect().EffectName;
			if (Reason.EffectName == EffectName && EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == SourceUnit.ObjectID && !EffectState.bRemoved)
			{
				EffectFound = true;
				break;
			}
		}

		if (!EffectFound)
			return Reason.Reason;
	}

	return 'AA_Success';
}

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local XComGameStateHistory History;
	local XComGameState_Unit TargetUnit;
	local StateObjectReference EffectRef;
	local XComGameState_Effect EffectState;
	local EffectReason Reason;
	local name EffectName;
	local bool EffectFound;

	History = `XCOMHISTORY;

	TargetUnit = XComGameState_Unit(kTarget);
	
	foreach ExcludeEffects(Reason)
	{
		foreach TargetUnit.AffectedByEffects(EffectRef)
		{
			EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
			EffectName = EffectState.GetX2Effect().EffectName;
			if (Reason.EffectName == EffectName && EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == kAbility.OwnerStateObject.ObjectID && !EffectState.bRemoved)
				return Reason.Reason;
		}
	}

	foreach RequireEffects(Reason)
	{
		EffectFound = false;
		foreach TargetUnit.AffectedByEffects(EffectRef)
		{
			EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
			EffectName = EffectState.GetX2Effect().EffectName;
			if (Reason.EffectName == EffectName && EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == kAbility.OwnerStateObject.ObjectID && !EffectState.bRemoved)
			{
				EffectFound = true;
				break;
			}
		}

		if (!EffectFound)
			return Reason.Reason;
	}

	return 'AA_Success';

}
