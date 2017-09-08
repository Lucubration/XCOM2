class XComGameState_Beags_Escalation_Effect_Reaper extends XComGameState_BaseObject;

var StateObjectReference UnitRef;

function EventListenerReturn OnTacticalGameEnd(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local X2EventManager EventManager;
	local Object ListenerObj;
    local XComGameState NewGameState;
	
    //`LOG("Beags Escalation: Reaper 'TacticalGameEnd' event listener delegate invoked.");
	
	EventManager = `XEVENTMGR;

	// Unregister our callbacks
	ListenerObj = self;
	
	//EventManager.UnRegisterFromEvent(ListenerObj, 'UnitDied');
	EventManager.UnRegisterFromEvent(ListenerObj, 'AbilityActivated');
	EventManager.UnRegisterFromEvent(ListenerObj, 'TacticalGameEnd');
	
    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Reaper states cleanup");
	NewGameState.RemoveStateObject(ObjectID);
	`GAMERULES.SubmitGameState(NewGameState);

	`LOG("Beags Escalation: Reaper passive effect unregistered from events.");
	
	return ELR_NoInterrupt;
}

//function EventListenerReturn OnUnitDied(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
function EventListenerReturn OnAbilityActivated(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit PrimaryTargetUnitState, SourceUnitState;
	local XComGameState_Ability AbilityState;
	local XComGameState_Item ItemState;
	local XComGameState_Effect EffectState;
	local X2WeaponTemplate WeaponTemplate;
	local XComGameState NewGameState;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	
	// Check if the source object was the unit ref for this effect
	if (AbilityContext.InputContext.SourceObject.ObjectID == UnitRef.ObjectID)
	{
		//SourceUnitState = XComGameState_Unit(AbilityContext.AssociatedState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
		SourceUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
		if (SourceUnitState != none)
		{
			//PrimaryTargetUnitState = XComGameState_Unit(AbilityContext.AssociatedState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
			PrimaryTargetUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
			if (PrimaryTargetUnitState != none)
			{
				if (PrimaryTargetUnitState.IsDead())
				{
					AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
					if (AbilityState != none)
					{
						ItemState = AbilityState.GetSourceWeapon();
						if (ItemState != none)
						{
							WeaponTemplate = X2WeaponTemplate(ItemState.GetMyTemplate());
							if (WeaponTemplate != none && WeaponTemplate.InventorySlot == eInvSlot_SecondaryWeapon)
							{
								EffectState = XComGameState_Effect(`XCOMHISTORY.GetGameStateForObjectID(OwningObjectId));

								// Restore standard action points for the turn in a change container
								NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
								if (EffectState != none)
									XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = EffectState.ReaperKillVisualizationFn;
								SourceUnitState = XComGameState_Unit(NewGameState.CreateStateObject(SourceUnitState.Class, SourceUnitState.ObjectID));
								NewGameState.AddStateObject(SourceUnitState);

								while (SourceUnitState.NumActionPoints(class'X2CharacterTemplateManager'.default.StandardActionPoint) < class'X2CharacterTemplateManager'.default.StandardActionsPerTurn)
								{
									SourceUnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
								}

								// Submit changed state
								`TACTICALRULES.SubmitGameState(NewGameState);
									
								`LOG("Beags Escalation: Reaper triggered for unit " @ SourceUnitState.GetFullName() @ " ability " @ string(AbilityState.GetMyTemplateName()) @ ".");
							}
							else
							{
								//`LOG("Beags Escalation: Reaper not triggered for unit " @ SourceUnitState.GetFullName() @ " ability " @ string(AbilityState.GetMyTemplateName()) @ " (wrong weapon type).");
							}
						}
						else
						{
							//`LOG("Beags Escalation: Reaper not triggered for unit " @ SourceUnitState.GetFullName() @ " ability " @ string(AbilityState.GetMyTemplateName()) @ " (weapon state not found).");
						}
					}
					else
					{
						//`LOG("Beags Escalation: Reaper not triggered for unit " @ SourceUnitState.GetFullName() @ "ability (ability state not found).");
					}
				}
				else
				{
					//`LOG("Beags Escalation: Reaper not triggered for unit " @ SourceUnitState.GetFullName() @ "ability (primary target unit is not dead).");
				}
			}
			else
			{
				//`LOG("Beags Escalation: Reaper not triggered for unit " @ SourceUnitState.GetFullName() @ "ability (primary target unit state not found).");
			}
		}
		else
		{
			//`LOG("Beags Escalation: Reaper not triggered for ability (source unit state not found).");
		}
	}
	else
	{
		//`LOG("Beags Escalation: Reaper not triggered for ability (wrong source unit).");
	}

	return ELR_NoInterrupt;
}
