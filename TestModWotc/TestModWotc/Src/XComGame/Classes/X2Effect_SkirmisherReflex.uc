class X2Effect_SkirmisherReflex extends X2Effect_Persistent;

var privatewrite name ReflexUnitValue, TotalEarnedValue;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', EffectGameState.SkirmisherReflexListener, ELD_OnStateSubmitted);
}

function ModifyTurnStartActionPoints(XComGameState_Unit UnitState, out array<name> ActionPoints, XComGameState_Effect EffectState)
{
	local UnitValue ReflexValue;

	if (UnitState.GetUnitValue(default.ReflexUnitValue, ReflexValue))
	{
		if (ReflexValue.fValue > 0)
		{
			if (UnitState.IsAbleToAct())
				ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);

			UnitState.ClearUnitValue(default.ReflexUnitValue);
		}
	}
}

DefaultProperties
{
	TotalEarnedValue = "TotalReflexTaken"
	ReflexUnitValue = "SkirmisherReflex"
	EffectName = "SkirmisherReflex"
	DuplicateResponse = eDupe_Ignore
}