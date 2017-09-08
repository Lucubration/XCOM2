class X2Effect_ForwardOperator extends X2Effect_Persistent;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMan;
	local Object EffectObj;

	EventMan = `XEVENTMGR;
	EffectObj = EffectGameState;
	EventMan.RegisterForEvent(EffectObj, 'ScamperEnd', EffectGameState.ForwardOperatorListener, ELD_OnStateSubmitted);
}

function ModifyTurnStartActionPoints(XComGameState_Unit UnitState, out array<name> ActionPoints, XComGameState_Effect EffectState)
{
	local UnitValue PendingPointsValue;
	local int i, Points;

	if (UnitState.IsAbleToAct())
	{
		UnitState.GetUnitValue('ForwardOperatorPending', PendingPointsValue);
		Points = PendingPointsValue.fValue;
		for (i = 0; i < Points; ++i)
		{
			ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
		}
	}
	UnitState.ClearUnitValue('ForwardOperatorPending');
}