class X2Condition_Beags_Escalation_VisibleToPlayer extends X2Condition;

var bool IsVisible;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
	local XComGameState_Unit Target, Source;

	Target = XComGameState_Unit(kTarget);
	Source = XComGameState_Unit(kSource);

	if (Target != none && Source != none && class'X2TacticalVisibilityHelpers'.static.GetTargetIDVisibleForPlayer(Target.ObjectID, Source.ControllingPlayer.ObjectID))
	{
		if (IsVisible)
			return 'AA_Success';
		else
			return 'AA_UnitCanBeSeen';
	}
	else
	{
		if (IsVisible)
			return 'AA_NotVisible';
		else
			return 'AA_Success';
	}
}