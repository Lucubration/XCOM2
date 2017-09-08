class XComGameState_Beags_Escalation_Effect_AwarenessPassive extends XComGameState_BaseObject;

var StateObjectReference UnitRef;

function EventListenerReturn OnTacticalGameEnd(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local X2EventManager EventManager;
	local Object ListenerObj;
    local XComGameState NewGameState;
	
    //`LOG("Beags Escalation: Awareness passive 'TacticalGameEnd' event listener delegate invoked.");
	
	EventManager = `XEVENTMGR;

	// Unregister our callbacks
	ListenerObj = self;
	
	EventManager.UnRegisterFromEvent(ListenerObj, 'ObjectMoved');
	EventManager.UnRegisterFromEvent(ListenerObj, 'AbilityActivated');
	EventManager.UnRegisterFromEvent(ListenerObj, 'TacticalGameEnd');
	
    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Awareness passive states cleanup");
	NewGameState.RemoveStateObject(ObjectID);
	`GAMERULES.SubmitGameState(NewGameState);

	`LOG("Beags Escalation: Awareness passive effect unregistered from events.");
	
	return ELR_NoInterrupt;
}

// This callback is triggered when the unit with the Awareness passive effect moves, and should remove all Awareness active effects applied
// by the unit with Awareness
function EventListenerReturn OnObjectMoved(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local XComGameStateContext_Ability			AbilityContext;
	local XComGameStateHistory					History;
	//local XComGameState_Unit					ActiveEffectTarget;
	local XComGameState_Effect					ActiveEffectState;
	local X2Effect_Beags_Escalation_Awareness	ActiveEffect;
	local XComGameStateContext_EffectRemoved	EffectRemovedState;
	local XComGameState							NewGameState;

	History = `XCOMHISTORY;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	
	// Sanity check. This callback should be filtered for the unit, but the event manager is a black box to me so I check anyways
	if (AbilityContext.InputContext.SourceObject.ObjectID == UnitRef.ObjectID)
	{
		//`LOG("Beags Escalation: Awareness passive effect source moved.");

		// Find all targets of Awareness active effects applied by this effect's source
		foreach History.IterateByClassType(class'XComGameState_Effect', ActiveEffectState)
		{
			ActiveEffect = X2Effect_Beags_Escalation_Awareness(ActiveEffectState.GetX2Effect());
			if (ActiveEffect != none && ActiveEffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == UnitRef.ObjectID)
			{
				// Remove effect from all such targets
				EffectRemovedState = class'XComGameStateContext_EffectRemoved'.static.CreateEffectRemovedContext(ActiveEffectState);
				NewGameState = History.CreateNewGameState(true, EffectRemovedState);
				ActiveEffectState.RemoveEffect(NewGameState, NewGameState);
		
				if (NewGameState.GetNumGameStateObjects() > 0)
				{
					// Effects may have changed action availability - if a unit died, took damage, etc.
					`TACTICALRULES.SubmitGameState(NewGameState);
				}
				else
				{
					History.CleanupPendingGameState(NewGameState);
				}
			
				//ActiveEffectTarget = XComGameState_Unit(History.GetGameStateForObjectID(ActiveEffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

				//`LOG("Beags Escalation: Awareness active effect removed from target " @ ActiveEffectTarget.GetFullName() @ ".");
			}
		}
	}

	return ELR_NoInterrupt;
}

// This callback is triggered whenever any unit actives an ability, and should force all Awareness active effects to re-calculate
// whether or not they should be removed based on visiblity only
function EventListenerReturn OnAbilityActivated(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local XComGameStateHistory					History;
	local XComGameState_Effect					ActiveEffectState;
	local X2Effect_Beags_Escalation_Awareness	ActiveEffect;
	local XComGameStateContext_EffectRemoved	EffectRemovedState;
	local XComGameState							NewGameState;
	local XComGameState_Unit					TargetUnitState, SourceUnitState;

	History = `XCOMHISTORY;

	// Find all targets of Awareness active effects in the mission
	foreach History.IterateByClassType(class'XComGameState_Effect', ActiveEffectState)
	{
		ActiveEffect = X2Effect_Beags_Escalation_Awareness(ActiveEffectState.GetX2Effect());

		if (ActiveEffect != none)
		{
			// Only check the active effects applied by this passive effect's source. This isn't strictly necessary, but it prevents
			// redundant work if multiple units with Awareness are in play
			if (ActiveEffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == UnitRef.ObjectID)
			{
				// Find source and target of the Awareness active effect
				TargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(ActiveEffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
				SourceUnitState = XComGameState_Unit(History.GetGameStateForObjectID(ActiveEffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

				if (TargetUnitState != none && SourceUnitState != none && class'X2TacticalVisibilityHelpers'.static.GetTargetIDVisibleForPlayer(TargetUnitState.ObjectID, SourceUnitState.ControllingPlayer.ObjectID))
				{
					// Target is visible to source player; remove the Awareness effect
					EffectRemovedState = class'XComGameStateContext_EffectRemoved'.static.CreateEffectRemovedContext(ActiveEffectState);
					NewGameState = History.CreateNewGameState(true, EffectRemovedState);
					ActiveEffectState.RemoveEffect(NewGameState, NewGameState);
		
					if (NewGameState.GetNumGameStateObjects() > 0)
					{
						// Effects may have changed action availability - if a unit died, took damage, etc.
						`TACTICALRULES.SubmitGameState(NewGameState);
					}
					else
					{
						History.CleanupPendingGameState(NewGameState);
					}
			
					//`LOG("Beags Escalation: Awareness active effect removed from target " @ TargetUnitState.GetFullName() @ ".");
				}
			}
		}
	}

	return ELR_NoInterrupt;
}
