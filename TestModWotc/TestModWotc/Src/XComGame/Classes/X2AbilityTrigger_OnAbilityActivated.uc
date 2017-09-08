class X2AbilityTrigger_OnAbilityActivated extends X2AbilityTrigger_EventListener;

var() protected name MatchAbilityActivated;         //  AbilityTemplate name of ability to watch for

simulated function bool OnAbilityActivated(XComGameState_Ability EventAbility, XComGameState GameState, XComGameState_Ability TriggerAbility, Name InEventID)
{
	local GameRulesCache_Unit UnitCache;
	local int i, j;

	if (EventAbility.GetMyTemplateName() == MatchAbilityActivated)
	{
		if (`TACTICALRULES.GetGameRulesCache_Unit(TriggerAbility.OwnerStateObject, UnitCache))
		{
			for (i = 0; i < UnitCache.AvailableActions.Length; ++i)
			{
				if (UnitCache.AvailableActions[i].AbilityObjectRef.ObjectID == TriggerAbility.ObjectID
					&& UnitCache.AvailableActions[i].AvailableTargets.Length > 0)
				{
					for (j = 0; j < UnitCache.AvailableActions[i].AvailableTargets.Length; ++j)
					{
						class'XComGameStateContext_Ability'.static.ActivateAbility(UnitCache.AvailableActions[i], j);
					}
					break;
				}
			}
		}
		return true;
	}
	return false;
}

simulated function SetListenerData(name ActivateAbility)
{
	MatchAbilityActivated = ActivateAbility;
	ListenerData.EventID = 'AbilityActivated';
	ListenerData.EventFn = class'XComGameState_Ability'.static.OnAbilityActivated;
	ListenerData.Deferral = ELD_OnStateSubmitted;
	ListenerData.Filter = eFilter_Unit;
}