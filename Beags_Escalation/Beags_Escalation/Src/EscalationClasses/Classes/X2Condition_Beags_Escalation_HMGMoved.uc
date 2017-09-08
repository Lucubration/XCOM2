class X2Condition_Beags_Escalation_HMGMoved extends X2Condition;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	// If a unit with an HMG moved but has not been braced, they cannot use attack abilities
	if (UnitState.AffectedByEffectNames.Find(class'X2Ability_Beags_Escalation_GunnerAbilitySet'.default.HMGMovedEffectName) != INDEX_NONE &&
		UnitState.AffectedByEffectNames.Find(class'X2Ability_Beags_Escalation_GunnerAbilitySet'.default.HMGBracedEffectName) == INDEX_NONE)
		return 'AA_AbilityUnavailable';

	return 'AA_Success';
}
