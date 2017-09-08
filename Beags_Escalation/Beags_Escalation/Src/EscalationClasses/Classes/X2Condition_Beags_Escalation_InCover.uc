class X2Condition_Beags_Escalation_InCover extends X2Condition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit Target;

	Target = XComGameState_Unit(kTarget);
	
	if (Target != none && Target.CanTakeCover() && Target.GetCoverTypeFromLocation() != CT_None)
		return 'AA_Success';

	return 'AA_UnitIsNotInCover';
}