// This is the more powerful version of Cool Under Pressure from Long War called Opportunist, which eliminates the reaction fire aim penalty completely
class X2Effect_Beags_Escalation_Opportunist extends X2Effect_Persistent;

function bool AllowReactionFireCrit(XComGameState_Unit UnitState, XComGameState_Unit TargetState) 
{
	// Indicate that reaction fire is allowed to crit
	return true;
}

//Occurs once per turn during the Unit Effects phase
simulated function bool OnEffectTicked(const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication)
{
	local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (TargetUnit != None)
	{
		// Set unit value to indicate we're "in concealment", which will prevent the reaction fire aim reduction from being applied to reaction fire
		TargetUnit.SetUnitFloatValue(class'X2Ability_DefaultAbilitySet'.default.ConcealedOverwatchTurn, 1, eCleanup_BeginTurn);
	}

	return true;
}
