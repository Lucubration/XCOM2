class XComGameState_Effect_PaleHorse extends XComGameState_Effect;

var int CurrentCritBoost;

function EventListenerReturn KillMailListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local X2Effect_PaleHorse Effect;
	local XComGameState NewGameState;
	local XComGameState_Effect_PaleHorse EffectState;
	local XComGameState_Ability AbilityState;
	local XComGameState_Unit UnitState;
	
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
	{
		Effect = X2Effect_PaleHorse(GetX2Effect());
		if (CurrentCritBoost < Effect.MaxCritBoost)
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Soul Harvester Crit Increase on Kill");
			EffectState = XComGameState_Effect_PaleHorse(NewGameState.ModifyStateObject(Class, ObjectID));
			EffectState.CurrentCritBoost += Effect.CritBoostPerKill;
			//	mark unit state and ability state for flyover
			UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ApplyEffectParameters.SourceStateObjectRef.ObjectID));
			AbilityState = XComGameState_Ability(NewGameState.ModifyStateObject(class'XComGameState_Ability', ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
			`XEVENTMGR.TriggerEvent('OnAPaleHorse', AbilityState, UnitState, NewGameState);
			SubmitNewGameState(NewGameState);
		}
	}

	return ELR_NoInterrupt;
}