class X2AbilityTrigger_EventListener extends X2AbilityTrigger;

var() AbilityEventListener ListenerData;

simulated function RegisterListener(XComGameState_Ability AbilityState, Object FilterObject)
{
	local Object FilterObj, AbilityObj;
	
	if( ListenerData.OverrideListenerSource != none )
	{
		AbilityObj = ListenerData.OverrideListenerSource;
	}
	else
	{
		AbilityObj = AbilityState;
	}
	
	FilterObj = FilterObject;
	
	`XEVENTMGR.RegisterForEvent(AbilityObj, ListenerData.EventID, ListenerData.EventFn, ListenerData.Deferral, ListenerData.Priority, FilterObj,, AbilityState);
}
simulated function bool FixupRegisterListener(XComGameState_Ability AbilityState, Object FilterObject)
{
	local Object FilterObj, AbilityObj;

	if( ListenerData.OverrideListenerSource != none )
	{
		AbilityObj = ListenerData.OverrideListenerSource;
	}
	else
	{
		AbilityObj = AbilityState;
	}

	FilterObj = FilterObject;

	if (`XEVENTMGR.IsRegistered(AbilityObj, ListenerData.EventID, ListenerData.Deferral, ListenerData.EventFn))
		return false;

	`XEVENTMGR.RegisterForEvent(AbilityObj, ListenerData.EventID, ListenerData.EventFn, ListenerData.Deferral, ListenerData.Priority, FilterObj,, AbilityState);

	return true;
}