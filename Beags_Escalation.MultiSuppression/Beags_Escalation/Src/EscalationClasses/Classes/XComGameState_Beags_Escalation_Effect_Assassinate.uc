class XComGameState_Beags_Escalation_Effect_Assassinate extends XComGameState_BaseObject;

var StateObjectReference UnitRef;

function EventListenerReturn OnTacticalGameEnd(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local X2EventManager EventManager;
	local Object ListenerObj;
    local XComGameState NewGameState;
	
    //`LOG("Beags Escalation: Assassinate 'TacticalGameEnd' event listener delegate invoked.");
	
	EventManager = `XEVENTMGR;

	// Unregister our callbacks
	ListenerObj = self;
	
	EventManager.UnRegisterFromEvent(ListenerObj, 'AbilityActivated');
	EventManager.UnRegisterFromEvent(ListenerObj, 'TacticalGameEnd');
	
    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Assassinate states cleanup");
	NewGameState.RemoveStateObject(ObjectID);
	`GAMERULES.SubmitGameState(NewGameState);

	`LOG("Beags Escalation: Assassinate passive effect unregistered from events.");
	
	return ELR_NoInterrupt;
}

function EventListenerReturn OnAbilityActivated(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit PrimaryTargetUnitState, MultiTargetUnitState, SourceUnitState;
	local StateObjectReference MultiTargetUnitRef;
	local bool bRetainConcealment;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	
	bRetainConcealment = true;

	// Sanity check. This callback should be filtered for the unit, but the event manager is a black box to me so I check anyways
	if (AbilityContext.InputContext.SourceObject.ObjectID == UnitRef.ObjectID)
	{
		// Do not process concealment breaks or AI alerts during interrupt processing
		if (AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
		{
			SourceUnitState = XComGameState_Unit(AbilityContext.AssociatedState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
			if (SourceUnitState != none)
			{
				// If the unit isn't concealed, the rest doesn't matter; pass through all events
				if (SourceUnitState.IsConcealed())
				{
					PrimaryTargetUnitState = XComGameState_Unit(AbilityContext.AssociatedState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
					if (PrimaryTargetUnitState != none)
					{
						if (PrimaryTargetUnitState.IsEnemyUnit(SourceUnitState))
						{
							// Assassinate only causes concealment breaks if the target unit did not die
							if (PrimaryTargetUnitState.IsDead())
							{
								// I'm also going to check multi-targets if there are any
								bRetainConcealment = true;
								foreach AbilityContext.InputContext.MultiTargets(MultiTargetUnitRef)
								{
									MultiTargetUnitState = XComGameState_Unit(AbilityContext.AssociatedState.GetGameStateForObjectID(MultiTargetUnitRef.ObjectID));
									if (MultiTargetUnitState != none && !MultiTargetUnitState.IsDead())
									{
										//`LOG("Beags Escalation: Assassinate not triggered for unit " @ SourceUnitState.GetFullName() @ " ability (multi target " @ MultiTargetUnitState.GetFullName() @ " not dead).");
										bRetainConcealment = false;
										break;
									}
								}

								if (bRetainConcealment)
								{
									// If everything went right, the unit may remain concealed. Do not notify the unit state of ability activation
									//`LOG("Beags Escalation: Assassinate triggered for unit " @ SourceUnitState.GetFullName() @ " ability.");
									return ELR_NoInterrupt;
								}
							}
							else
							{
								//`LOG("Beags Escalation: Assassinate not triggered for unit " @ SourceUnitState.GetFullName() @ " ability (primary target " @ PrimaryTargetUnitState.GetFullName() @ " not dead).");
							}
						}
						else
						{
							//`LOG("Beags Escalation: Assassinate not triggered for unit " @ SourceUnitState.GetFullName() @ " ability (primary target " @ PrimaryTargetUnitState.GetFullName() @ " not enemy).");
						}
					}
					else
					{
						//`LOG("Beags Escalation: Assassinate not triggered for unit " @ SourceUnitState.GetFullName() @ " ability (target unit state not found).");
					}
				}
				else
				{
					//`LOG("Beags Escalation: Assassinate not triggered for unit " @ SourceUnitState.GetFullName() @ " ability (source unit not concealed).");
				}
			}
			else
			{
				//`LOG("Beags Escalation: Assassinate not triggered for ability (source unit state not found).");
			}
		}
		else
		{
			//`LOG("Beags Escalation: Assassinate not triggered for ability (wrong interrupt status).");
		}
	}
	else
	{
		//`LOG("Beags Escalation: Assassinate not triggered for ability (wrong source unit).");
	}

	// If some part of the above checks failed, notify the unit state of ability activation
	return SourceUnitState.OnAbilityActivated(EventData, EventSource, GameState, EventID);
}
