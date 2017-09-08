class X2Effect_Lucu_Infantry_ShakeItOff extends X2Effect_PersistentStatChange;
	
function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'Lucu_Infantry_ShakeItOffTriggered', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
}

// Occurs once per turn after the Unit Effects phase (this is where we show effect removal, etc)
simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const int TickIndex, XComGameState_Effect EffectState)
{
	local XComGameStateHistory History;
	local XComGameState_Unit OldUnit, NewUnit;
	local StateObjectReference OldEffectStateRef;
	local XComGameState_Effect OldEffectState;
	local X2Effect_Persistent Effect;
	
	History = `XCOMHISTORY;

	OldUnit = XComGameState_Unit(ActionMetadata.StateObject_OldState);
	NewUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	if (OldUnit != none)
	{
		//`LOG("Lucubration Infantry Class: Shake it Off tick visualization started on unit " @ OldUnit.GetFullName() @ ".");

		//  We are assuming that any removed or reduced effects were cleansed by this RemoveEffects. If this turns out to not be a good assumption, something will have to change.
		foreach OldUnit.AffectedByEffects(OldEffectStateRef)
		{
			OldEffectState = XComGameState_Effect(History.GetGameStateForObjectID(OldEffectStateRef.ObjectID));

			if (OldEffectState.bRemoved/* || OldEffect != none && OldEffect.bRemoved*/ &&
				OldEffectState.GetX2Effect().EffectName == class'X2AbilityTemplateManager'.default.DisorientedName ||
				OldEffectState.GetX2Effect().EffectName == class'X2AbilityTemplateManager'.default.ConfusedName ||
				OldEffectState.GetX2Effect().EffectName == class'X2AbilityTemplateManager'.default.PanickedName ||
				OldEffectState.GetX2Effect().EffectName == class'X2AbilityTemplateManager'.default.StunnedName ||
				OldEffectState.GetX2Effect().EffectName == class'X2Effect_MindControl'.default.EffectName)
			{
				if (OldEffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID == NewUnit.ObjectID)
				{
					Effect = OldEffectState.GetX2Effect();
					if (Effect.CleansedVisualizationFn != none)
					{
						Effect.CleansedVisualizationFn(VisualizeGameState, ActionMetadata, 'AA_Success');
					}
					else
					{
						Effect.AddX2ActionsForVisualization_Removed(VisualizeGameState, ActionMetadata, 'AA_Success', OldEffectState);
					}

					//`LOG("Lucubration Infantry Class: Shake it Off tick visualization built for effect " @ OldEffectState.GetX2Effect().EffectName @ " ended on unit " @ OldUnit.GetFullName() @ ".");
				}
				else if (OldEffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == NewUnit.ObjectID)
				{
					Effect = OldEffectState.GetX2Effect();
					Effect.AddX2ActionsForVisualization_RemovedSource(VisualizeGameState, ActionMetadata, 'AA_Success', OldEffectState);
				}
			}
		}

		//`LOG("Lucubration Infantry Class: Shake it Off tick visualization ended on unit " @ OldUnit.GetFullName() @ ".");
	}
	else
	{
		//`LOG("Lucubration Infantry Class: Shake it Off tick visualization skipped (no primary target).");
	}
}

//Occurs once per turn during the Unit Effects phase
simulated function bool OnEffectTicked(const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication, XComGameState_Player Player)
{
	local XComGameStateHistory History;
	local XComGameState_Unit OldTargetUnitState, NewTargetUnitState;
	local StateObjectReference EffectRef;
	local XComGameState_Effect Effect;
	local bool EffectRemoved;
	local X2EventManager EventMgr;
	local XComGameState_Ability AbilityState;
	
	History = `XCOMHISTORY;

	OldTargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	// Only allow this to tick at the end of the other player's turn
	if (OldTargetUnitState != none && `TACTICALRULES.GetCachedUnitActionPlayerRef().ObjectID != OldTargetUnitState.ControllingPlayer.ObjectID)
	{
		//`LOG("Lucubration Infantry Class: Shake it Off tick started on unit " @ OldTargetUnitState.GetFullName() @ ".");

		EffectRemoved = false;

		// Check the old target state for condition effects
		foreach OldTargetUnitState.AffectedByEffects(EffectRef)
		{
			Effect = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));

			if (Effect.GetX2Effect().EffectName == class'X2AbilityTemplateManager'.default.DisorientedName ||
				Effect.GetX2Effect().EffectName == class'X2AbilityTemplateManager'.default.ConfusedName ||
				Effect.GetX2Effect().EffectName == class'X2AbilityTemplateManager'.default.PanickedName ||
				Effect.GetX2Effect().EffectName == class'X2AbilityTemplateManager'.default.StunnedName ||
				Effect.GetX2Effect().EffectName == class'X2Effect_MindControl'.default.EffectName)
			{
				if (!Effect.GetX2Effect().bInfiniteDuration)
				{
					// Finite effects get ticked down and/or cleansed
					if (Effect.iTurnsRemaining > 1)
					{
						Effect.iTurnsRemaining--;
						
						//`LOG("Lucubration Infantry Class: Shake it Off reduced " @ string(Effect.GetX2Effect().EffectName) @ " duration from " @ string(Effect.iTurnsRemaining + 1) @ " to " @ string(Effect.iTurnsRemaining) @ ".");
					}
					else
					{
						Effect.RemoveEffect(NewGameState, NewGameState, true);

						//`LOG("Lucubration Infantry Class: Shake it Off cleansed " @ string(Effect.GetX2Effect().EffectName) @ " (end of duration).");
					}

					EffectRemoved = true;
				}
				else
				{
					// Infinite effects get cleansed
					Effect.RemoveEffect(NewGameState, NewGameState, true);

					//`LOG("Lucubration Infantry Class: Shake it Off cleansed " @ string(Effect.GetX2Effect().EffectName) @ " (infinite duration).");

					EffectRemoved = true;
				}

				if (NewTargetUnitState == none)
				{
					NewTargetUnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', OldTargetUnitState.ObjectID));
					NewGameState.AddStateObject(NewTargetUnitState);
				}
			}
		}

		// If any condition removal occurred, pop up the flyover text
		if (EffectRemoved)
		{
			AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(kNewEffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
			if (AbilityState != none)
			{
				EventMgr = `XEVENTMGR;
				EventMgr.TriggerEvent('Lucu_Infantry_ShakeItOffTriggered', AbilityState, NewTargetUnitState, NewGameState);
			}
		}

		//`LOG("Lucubration Infantry Class: Shake it Off tick ended on unit " @ OldTargetUnitState.GetFullName() @ ".");
	}
	else
	{
		//`LOG("Lucubration Infantry Class: Shake it Off tick skipped (no primary target).");
	}

	return true;
}