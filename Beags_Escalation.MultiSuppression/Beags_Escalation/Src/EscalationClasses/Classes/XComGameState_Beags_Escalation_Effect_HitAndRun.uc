class XComGameState_Beags_Escalation_Effect_HitAndRun extends XComGameState_BaseObject;

var name HitAndRunUsedName;
var StateObjectReference UnitRef;

function EventListenerReturn OnTacticalGameEnd(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local X2EventManager EventManager;
	local Object ListenerObj;
    local XComGameState NewGameState;
	
    //`LOG("Beags Escalation: Hit and Run 'TacticalGameEnd' event listener delegate invoked.");
	
	EventManager = `XEVENTMGR;

	// Unregister our callbacks
	ListenerObj = self;
	
	EventManager.UnRegisterFromEvent(ListenerObj, 'AbilityActivated');
	EventManager.UnRegisterFromEvent(ListenerObj, 'TacticalGameEnd');
	
    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Hit and Run states cleanup");
	NewGameState.RemoveStateObject(ObjectID);
	`GAMERULES.SubmitGameState(NewGameState);

	`LOG("Beags Escalation: Hit and Run passive effect unregistered from events.");
	
	return ELR_NoInterrupt;
}

function EventListenerReturn OnAbilityActivated(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit PrimaryTargetUnitState, SourceUnitState, OldSourceUnitState;
	local UnitValue UnitValue;
	local GameRulesCache_VisibilityInfo VisibilityInfoFromSource;
	local XComGameState_Ability AbilityState;
	local XComGameState_Item ItemState;
	local X2WeaponTemplate WeaponTemplate;
	local XComGameState NewGameState;
	local bool TargetIsFlankedOrUncovered;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	
	// Check if the source object was the unit ref for this effect, and make sure the target was not
	if (AbilityContext.InputContext.SourceObject.ObjectID == UnitRef.ObjectID &&
		AbilityContext.InputContext.SourceObject.ObjectID != AbilityContext.InputContext.PrimaryTarget.ObjectID)
	{
		//SourceUnitState = XComGameState_Unit(AbilityContext.AssociatedState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
		SourceUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
		// Check if Hit and Run has already been used this turn
		if (SourceUnitState != none && !SourceUnitState.GetUnitValue(default.HitAndRunUsedName, UnitValue))
		{
			if (`TACTICALRULES.GetCachedUnitActionPlayerRef().ObjectID == SourceUnitState.ControllingPlayer.ObjectID)
			{
				//PrimaryTargetUnitState = XComGameState_Unit(AbilityContext.AssociatedState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
				PrimaryTargetUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
				if (PrimaryTargetUnitState != none)
				{
					// Check if the target is flanked or uncovered
					TargetIsFlankedOrUncovered = true;
					if (PrimaryTargetUnitState.CanTakeCover())
					{
						`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(SourceUnitState.ObjectID, PrimaryTargetUnitState.ObjectID, VisibilityInfoFromSource);
						if (VisibilityInfoFromSource.TargetCover != CT_None)
							TargetIsFlankedOrUncovered = false;
					}

					if (TargetIsFlankedOrUncovered)
					{
						AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
						if (AbilityState != none && AbilityState.GetMyTemplate().Hostility == eHostility_Offensive)
						{
							ItemState = AbilityState.GetSourceWeapon();
							if (ItemState != none)
							{
								WeaponTemplate = X2WeaponTemplate(ItemState.GetMyTemplate());
								if (WeaponTemplate != none && WeaponTemplate.InventorySlot == eInvSlot_PrimaryWeapon || WeaponTemplate.InventorySlot == eInvSlot_SecondaryWeapon)
								{
									OldSourceUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID,, AbilityContext.AssociatedState.HistoryIndex - 1));

									if (OldSourceUnitState != none && OldSourceUnitState.ActionPoints.Length > SourceUnitState.ActionPoints.Length)
									{
										NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
										XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = HitAndRunVisualizationFn;
										SourceUnitState = XComGameState_Unit(NewGameState.CreateStateObject(SourceUnitState.Class, SourceUnitState.ObjectID));
										NewGameState.AddStateObject(SourceUnitState);

										// Restore standard action points for the turn in a change container
										SourceUnitState.ActionPoints = OldSourceUnitState.ActionPoints;

										// Set the unit value to prevent Hit and Run from triggering more than once per turn
										SourceUnitState.SetUnitFloatValue(default.HitAndRunUsedName, 1, eCleanup_BeginTurn);

										// Submit changed state
										`TACTICALRULES.SubmitGameState(NewGameState);

										// Show flyover text
										`XEVENTMGR.TriggerEvent('Beags_Escalation_HitAndRunTriggered', AbilityState, SourceUnitState, NewGameState);
									
										`LOG("Beags Escalation: Hit and Run triggered for unit " @ SourceUnitState.GetFullName() @ " ability " @ string(AbilityState.GetMyTemplateName()) @ ".");
									}
									else
									{
										//`LOG("Beags Escalation: Hit and Run not triggered for unit " @ SourceUnitState.GetFullName() @ " ability " @ string(AbilityState.GetMyTemplateName()) @ " (old source unit state not found).");
									}
								}
								else
								{
									//`LOG("Beags Escalation: Hit and Run not triggered for unit " @ SourceUnitState.GetFullName() @ " ability " @ string(AbilityState.GetMyTemplateName()) @ " (wrong weapon type).");
								}
							}
							else
							{
								//`LOG("Beags Escalation: Hit and Run not triggered for unit " @ SourceUnitState.GetFullName() @ " ability " @ string(AbilityState.GetMyTemplateName()) @ " (weapon state not found).");
							}
						}
						else
						{
							//`LOG("Beags Escalation: Hit and Run not triggered for unit " @ SourceUnitState.GetFullName() @ " ability " @ string(AbilityState.GetMyTemplateName()) @ " (not offensive ability).");
						}
					}
					else
					{
						//`LOG("Beags Escalation: Hit and Run not triggered for unit " @ SourceUnitState.GetFullName() @ "ability (primary target unit is not flanked).");
					}
				}
				else
				{
					//`LOG("Beags Escalation: Hit and Run not triggered for unit " @ SourceUnitState.GetFullName() @ "ability (primary target unit state not found).");
				}
			}
			else
			{
				//`LOG("Beags Escalation: Hit and Run action points not refunded for unit " @ SourceUnitState.GetFullName() @ " ability (not unit controller's turn).");
			}
		}
		else
		{
			//`LOG("Beags Escalation: Hit and Run action points not refunded for unit " @ SourceUnitState.GetFullName() @ " ability (Hit and Run already activated this turn).");
		}
	}
	else
	{
		//`LOG("Beags Escalation: Hit and Run not triggered for ability (wrong source or target unit).");
	}

	return ELR_NoInterrupt;
}

function HitAndRunVisualizationFn(XComGameState VisualizeGameState, out array<VisualizationTrack> OutVisualizationTracks)
{
	local XComGameState_Unit UnitState;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local VisualizationTrack BuildTrack;
	local XComGameStateHistory History;
	local X2AbilityTemplate AbilityTemplate;

	History = `XCOMHISTORY;
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		History.GetCurrentAndPreviousGameStatesForObjectID(UnitState.ObjectID, BuildTrack.StateObject_OldState, BuildTrack.StateObject_NewState, , VisualizeGameState.HistoryIndex);
		BuildTrack.StateObject_NewState = UnitState;
		BuildTrack.TrackActor = UnitState.GetVisualizer();

		AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate('Beags_Escalation_HitAndRun');

		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTrack(BuildTrack, VisualizeGameState.GetContext()));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocFlyOverText, '', eColor_Good, AbilityTemplate.IconImage);

		OutVisualizationTracks.AddItem(BuildTrack);

		break;
	}
}

DefaultProperties
{
	HitAndRunUsedName="Beags_Escalation_HitAndRunUsed"
}
