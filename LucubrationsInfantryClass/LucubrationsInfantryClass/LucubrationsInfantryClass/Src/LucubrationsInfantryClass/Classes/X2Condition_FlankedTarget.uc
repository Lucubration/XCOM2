class X2Condition_FlankedTarget extends X2Condition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{
	return 'AA_Success';
}

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
	local XComGameState_Unit Source, Target;
	local X2GameRulesetVisibilityManager VisibilityMgr;
	local GameRulesCache_VisibilityInfo VisibilityInfoFromSource;

	Source = XComGameState_Unit(kSource);
	Target = XComGameState_Unit(kTarget);
	
	if (Target.CanTakeCover())
	{
		VisibilityMgr = `TACTICALRULES.VisibilityMgr;
		VisibilityMgr.GetVisibilityInfo(Source.ObjectID, Target.ObjectID, VisibilityInfoFromSource);
		if (VisibilityInfoFromSource.TargetCover != CT_None)
		{
			//`LOG("Lucubration Infantry Class: Target " @ Target.GetFullName() @ " not flanked by " @ Source.GetFullName() @ ".");
			return 'AA_InvalidTargetCoverType';
		}
	}

	//`LOG("Lucubration Infantry Class: Target " @ Target.GetFullName() @ " flanked by " @ Source.GetFullName() @ ".");
	return 'AA_Success';
}