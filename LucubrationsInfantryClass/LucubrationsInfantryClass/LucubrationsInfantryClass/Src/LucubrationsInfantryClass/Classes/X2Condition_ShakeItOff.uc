class X2Condition_ShakeItOff extends X2Condition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(kTarget);
	if (TargetUnit == none)
		return 'AA_NotAUnit';

	if (!TargetUnit.GetMyTemplate().bCanBeRevived)
		return 'AA_UnitIsImmune';

	if (TargetUnit.IsDead())
		return 'AA_UnitIsDead';

	if (TargetUnit.IsMindControlled())
		return 'AA_UnitIsMindControlled';

	if (TargetUnit.IsConfused() || TargetUnit.IsDisoriented() || TargetUnit.IsStunned())
	{
		//`LOG("Lucubration Infantry Class: Shake It Off conditions met.");

		return 'AA_Success';
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

	if (SourceUnit.ObjectID == TargetUnit.ObjectID)
		return 'AA_Success';

	return 'AA_UnitIsHostile';
}