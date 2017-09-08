class X2AbilityMultiTarget_Beags_Escalation_Cone extends X2AbilityMultiTarget_Cone;

function float GetConeLength(const XComGameState_Ability Ability)
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local StateObjectReference EffectRef;
	local XComGameState_Effect EffectState;
	local X2Effect_Beags_Escalation_SquadsightRange SquadsightRangeEffect;
	local float AbilityConeLength, SquadsightRange;
	
	History = `XCOMHISTORY;

	AbilityConeLength = super.GetConeLength(Ability);

	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(Ability.OwnerStateObject.ObjectID));
	
	SquadsightRange = 0;
	foreach UnitState.AffectedByEffects(EffectRef)
	{
		EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
		SquadsightRangeEffect = X2Effect_Beags_Escalation_SquadsightRange(EffectState.GetX2Effect());
		// Find the max Squadsight Range effect
		if (SquadsightRangeEffect != none && SquadsightRangeEffect.Range > SquadsightRange)
			SquadsightRange = SquadsightRangeEffect.Range;
	}

	// If a squadsight range was defined, add it to the returned cone length
	if (SquadsightRange > 0)
		AbilityConeLength += SquadsightRange;

	return AbilityConeLength;
}