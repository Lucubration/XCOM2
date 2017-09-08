class X2Effect_Beags_Escalation_Suppression extends X2Effect_Suppression;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit SourceUnit;
	local XComGameStateContext_Ability AbilityContext;

	SourceUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	SourceUnit.ReserveActionPoints.AddItem(class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.SuppressionActionPointName); // Add one reserve action point to the shooter per affected target
	AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
	SourceUnit.m_SuppressionAbilityContext = AbilityContext;
	NewGameState.AddStateObject(SourceUnit);

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameStateHistory History;
	local XComGameState_Unit SourceUnit;
	local StateObjectReference EffectRef;
	local XComGameState_Effect EffectState;
	local bool SourceStillSuppressing;
	
	History = `XCOMHISTORY;
	
	if (EffectRemovedFn != none)
		EffectRemovedFn(self, ApplyEffectParameters, NewGameState, bCleansed);

	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(RemovedEffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	NewGameState.AddStateObject(SourceUnit);
}

simulated function AddX2ActionsForVisualization_RemovedSource(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	local X2Action_EnterCover Action;
	local XComGameStateHistory History;
	local XComGameState_Unit SourceUnit;
	local StateObjectReference EffectRef;
	local XComGameState_Effect EffectState;
	local bool SourceStillSuppressing;

	History = `XCOMHISTORY;
	
	SourceUnit = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(RemovedEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	if (SourceUnit == none)
		SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(RemovedEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	// The source unit stops Suppressing IIF all of their applied Suppression effects are removed
	SourceStillSuppressing = false;
	foreach SourceUnit.AppliedEffects(EffectRef)
	{
		EffectState = XComGameState_Effect(VisualizeGameState.GetGameStateForObjectID(EffectRef.ObjectID));
		if (EffectState == none)
			EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
		if (EffectState != none && !EffectState.bRemoved && EffectState.GetX2Effect().IsA('X2Effect_Suppression'))
		{
			SourceStillSuppressing = true;
			break;
		}
	}

	if (!SourceStillSuppressing)
	{
		class'X2Action_StopSuppression'.static.AddToVisualizationTrack(BuildTrack, VisualizeGameState.GetContext());
		Action = X2Action_EnterCover(class'X2Action_EnterCover'.static.AddToVisualizationTrack(BuildTrack, VisualizeGameState.GetContext()));

		Action.AbilityContext = SourceUnit.m_SuppressionAbilityContext;
	}
}

simulated function CleansedSuppressionVisualization(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult)
{
	local XComGameStateHistory History;
	local XComGameState_Effect EffectState, SuppressionEffect;
	local X2Action_EnterCover Action;
	local XComGameState_Unit UnitState;
	local bool SourceStillSuppressing;
	
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		if (EffectState.bRemoved && EffectState.GetX2Effect() == self)
		{
			SuppressionEffect = EffectState;
			break;
		}
	}

	if (SuppressionEffect != none)
	{
		// The source unit stops Suppressing IIF all of their applied Suppression effects are removed
		SourceStillSuppressing = false;
		foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', EffectState)
		{
			if (EffectState.GetX2Effect().IsA('X2Effect_Suppression') && !EffectState.bRemoved && EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == SuppressionEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID)
			{
				SourceStillSuppressing = true;
				break;
			}
		}

		if (!SourceStillSuppressing)
		{
			History = `XCOMHISTORY;

			UnitState = XComGameState_Unit(History.GetGameStateForObjectID(SuppressionEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
			BuildTrack.TrackActor = History.GetVisualizer(SuppressionEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID);
			History.GetCurrentAndPreviousGameStatesForObjectID(SuppressionEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID, BuildTrack.StateObject_OldState, BuildTrack.StateObject_NewState, eReturnType_Reference, VisualizeGameState.HistoryIndex);
			if (BuildTrack.StateObject_NewState == none)
				BuildTrack.StateObject_NewState = BuildTrack.StateObject_OldState;

			class'X2Action_StopSuppression'.static.AddToVisualizationTrack(BuildTrack, VisualizeGameState.GetContext());
			Action = X2Action_EnterCover(class'X2Action_EnterCover'.static.AddToVisualizationTrack(BuildTrack, VisualizeGameState.GetContext()));

			Action.AbilityContext = UnitState.m_SuppressionAbilityContext;
		}
	}
}


function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit SourceUnitState;
	local XComGameStateHistory History;
	local Object EffectObj;

	History = `XCOMHISTORY;
	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	SourceUnitState = XComGameState_Unit(History.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	// Register for the required events
	EventMgr.RegisterForEvent(EffectObj, 'ImpairingEffect', EffectGameState.OnSourceBecameImpaired, ELD_OnStateSubmitted, , SourceUnitState);
}
