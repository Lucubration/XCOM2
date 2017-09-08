//---------------------------------------------------------------------------------------
//  FILE:    XComGameStateContext_TickEffect.uc
//  AUTHOR:  Joshua Bouscher -- 6/17/2014
//  PURPOSE: Used by XComGameState_Effect whenever an effect is ticked. Used purely for
//           visualization purposes.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameStateContext_TickEffect extends XComGameStateContext;

var StateObjectReference TickedEffect;
var() array<name> arrTickSuccess;   // Stores result of ApplyEffect for each ApplyOnTick effect

function bool Validate(optional EInterruptionStatus InInterruptionStatus)
{
	return true;
}

function XComGameState ContextBuildGameState()
{
	// this class is not used to build a game state, see XComGameState_Effect for use
	`assert(false);
	return none;
}

protected function ContextBuildVisualization()
{
	local VisualizationActionMetadata ActionMetadata, SourceBuildTrack;	
	local XComGameStateHistory History;
	local X2VisualizerInterface VisualizerInterface;
	local XComGameState_Effect EffectState;
	local XComGameState_BaseObject EffectTarget;
	local X2Effect_Persistent EffectTemplate;
	local X2Effect TickingEffect;
	local int i;

	History = `XCOMHISTORY;
	
	EffectState = XComGameState_Effect(AssociatedState.GetGameStateForObjectID(TickedEffect.ObjectID));
	`assert(EffectState != none);
	EffectTarget = History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID);
	
	if (EffectTarget != none)
	{
		ActionMetadata.VisualizeActor = History.GetVisualizer(EffectTarget.ObjectID);
		VisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
		if (ActionMetadata.VisualizeActor != none)
		{
			History.GetCurrentAndPreviousGameStatesForObjectID(EffectTarget.ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState, eReturnType_Reference, AssociatedState.HistoryIndex);
			if (ActionMetadata.StateObject_NewState == none)
				ActionMetadata.StateObject_NewState = ActionMetadata.StateObject_OldState;
			else if (ActionMetadata.StateObject_OldState == none)
				ActionMetadata.StateObject_OldState = ActionMetadata.StateObject_NewState;

			if (VisualizerInterface != none)
				VisualizerInterface.BuildAbilityEffectsVisualization(AssociatedState, ActionMetadata);

			EffectTemplate = EffectState.GetX2Effect();

			if (!EffectState.bRemoved)
			{
				EffectTemplate.AddX2ActionsForVisualization_Tick(AssociatedState, ActionMetadata, INDEX_NONE, EffectState);
			}

			for (i = 0; i < EffectTemplate.ApplyOnTick.Length; ++i)
			{
				TickingEffect = EffectTemplate.ApplyOnTick[i];
				TickingEffect.AddX2ActionsForVisualization_Tick(AssociatedState, ActionMetadata, i, EffectState);
			}

			if (EffectState.bRemoved)
			{
				EffectTemplate.AddX2ActionsForVisualization_Removed(AssociatedState, ActionMetadata, 'AA_Success', EffectState);

				// When the effect gets removed, the source of the effect may also need to update visuals
				SourceBuildTrack.VisualizeActor = History.GetVisualizer(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID);
				if (SourceBuildTrack.VisualizeActor != none)
				{
					History.GetCurrentAndPreviousGameStatesForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID, SourceBuildTrack.StateObject_OldState, SourceBuildTrack.StateObject_NewState, eReturnType_Reference, AssociatedState.HistoryIndex);
					if (SourceBuildTrack.StateObject_NewState == none)
						SourceBuildTrack.StateObject_NewState = SourceBuildTrack.StateObject_OldState;
					else if (SourceBuildTrack.StateObject_OldState == none)
						SourceBuildTrack.StateObject_OldState = SourceBuildTrack.StateObject_NewState;

					EffectTemplate.AddX2ActionsForVisualization_RemovedSource(AssociatedState, SourceBuildTrack, 'AA_Success', EffectState);					
				}
			}
		}
	}
}

function string SummaryString()
{
	return "XComGameStateContext_TickEffect";
}

static function XComGameStateContext_TickEffect CreateTickContext(XComGameState_Effect EffectState)
{
	local XComGameStateContext_TickEffect container;
	container = XComGameStateContext_TickEffect(CreateXComGameStateContext());
	container.TickedEffect = EffectState.GetReference();
	container.SetVisualizationFence(true, 5);
	return container;
}