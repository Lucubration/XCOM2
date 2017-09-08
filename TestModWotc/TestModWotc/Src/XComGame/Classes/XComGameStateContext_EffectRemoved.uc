//---------------------------------------------------------------------------------------
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameStateContext_EffectRemoved extends XComGameStateContext;

var array<StateObjectReference> RemovedEffects;

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
	local VisualizationActionMetadata SourceMetadata;
	local VisualizationActionMetadata TargetMetadata;
	local XComGameStateHistory History;
	local X2VisualizerInterface VisualizerInterface;
	local XComGameState_Effect EffectState;
	local XComGameState_BaseObject EffectTarget;
	local XComGameState_BaseObject EffectSource;
	local X2Effect_Persistent EffectTemplate;
	local int i;
	
	History = `XCOMHISTORY;
	
	for (i = 0; i < RemovedEffects.Length; ++i)
	{
		EffectState = XComGameState_Effect(History.GetGameStateForObjectID(RemovedEffects[i].ObjectID));
		if (EffectState != none)
		{
			EffectSource = History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID);
			EffectTarget = History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID);

			if (EffectTarget != none)
			{
				TargetMetadata.VisualizeActor = History.GetVisualizer(EffectTarget.ObjectID);
				VisualizerInterface = X2VisualizerInterface(TargetMetadata.VisualizeActor);
				if (TargetMetadata.VisualizeActor != none)
				{
					History.GetCurrentAndPreviousGameStatesForObjectID(EffectTarget.ObjectID, TargetMetadata.StateObject_OldState, TargetMetadata.StateObject_NewState, eReturnType_Reference, AssociatedState.HistoryIndex);
					if (TargetMetadata.StateObject_NewState == none)
						TargetMetadata.StateObject_NewState = TargetMetadata.StateObject_OldState;

					if (VisualizerInterface != none)
						VisualizerInterface.BuildAbilityEffectsVisualization(AssociatedState, TargetMetadata);

					EffectTemplate = EffectState.GetX2Effect();
					EffectTemplate.AddX2ActionsForVisualization_Removed(AssociatedState, TargetMetadata, 'AA_Success', EffectState);
				}
				
				if (EffectTarget.ObjectID == EffectSource.ObjectID)
				{
					SourceMetadata = TargetMetadata;
				}

				SourceMetadata.VisualizeActor = History.GetVisualizer(EffectSource.ObjectID);
				if (SourceMetadata.VisualizeActor != none)
				{
					History.GetCurrentAndPreviousGameStatesForObjectID(EffectSource.ObjectID, SourceMetadata.StateObject_OldState, SourceMetadata.StateObject_NewState, eReturnType_Reference, AssociatedState.HistoryIndex);
					if (SourceMetadata.StateObject_NewState == none)
						SourceMetadata.StateObject_NewState = SourceMetadata.StateObject_OldState;

					EffectTemplate.AddX2ActionsForVisualization_RemovedSource(AssociatedState, SourceMetadata, 'AA_Success', EffectState);
				}
			}
		}
	}
}

function string SummaryString()
{
	local XComGameState_Effect EffectState;
	local XComGameStateHistory History;
	History = `XCOMHISTORY;

	EffectState = XComGameState_Effect(History.GetGameStateForObjectID(RemovedEffects[0].ObjectID));
	return "XComGameStateContext_EffectRemoved (" $ EffectState.SummaryString() $ ") [" $ History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID).SummaryString() $ "]";
}

function AddEffectRemoved(XComGameState_Effect EffectState)
{
	RemovedEffects.AddItem(EffectState.GetReference());
}

static function XComGameStateContext_EffectRemoved CreateEffectRemovedContext(XComGameState_Effect EffectState)
{
	local XComGameStateContext_EffectRemoved container;

	container = XComGameStateContext_EffectRemoved(CreateXComGameStateContext());
	container.RemovedEffects.AddItem(EffectState.GetReference());
	return container;
}

static function XComGameStateContext_EffectRemoved CreateEffectsRemovedContext(array<XComGameState_Effect> EffectStates)
{
	local XComGameStateContext_EffectRemoved container;
	local int i;

	container = XComGameStateContext_EffectRemoved(CreateXComGameStateContext());
	for (i = 0; i < EffectStates.Length; ++i)
	{
		container.RemovedEffects.AddItem(EffectStates[i].GetReference());
	}
	return container;
}

defaultproperties
{
	AssociatedPlayTiming=SPT_AfterSequential
}