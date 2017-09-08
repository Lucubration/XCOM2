//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_TargetDefinition.uc
//  AUTHOR:  Joshua Bouscher
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Effect_TargetDefinition extends X2Effect_Persistent;

var privatewrite name TargetDefinitionTriggeredEventName;

function EffectAddedCallback(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	local X2EventManager EventMan;
	local XComGameState_Unit UnitState;

	EventMan = `XEVENTMGR;
	UnitState = XComGameState_Unit(kNewTargetState);
	if (UnitState != none)
	{
		UnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.UnburrowActionPoint);      //  will be useless for units without unburrow, just add it blindly

		EventMan.TriggerEvent(default.TargetDefinitionTriggeredEventName, kNewTargetState, kNewTargetState, NewGameState);
	}
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
	local X2Action_TargetDefinition OutlineAction;

	if (EffectApplyResult == 'AA_Success' && XComGameState_Unit(ActionMetadata.StateObject_NewState) != none)
	{
		OutlineAction = X2Action_TargetDefinition(class'X2Action_TargetDefinition'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		OutlineAction.bEnableOutline = true;
	}
}

//	in theory this effect never gets removed, but just in case
simulated function AddX2ActionsForVisualization_Removed(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	if (XComGameState_Unit(ActionMetadata.StateObject_NewState) != none)
	{
		class'X2Action_TargetDefinition'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded);
	}
}

simulated function AddX2ActionsForVisualization_Sync(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata)
{
	local X2Action_TargetDefinition OutlineAction;

	OutlineAction = X2Action_TargetDefinition(class'X2Action_TargetDefinition'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
	OutlineAction.bEnableOutline = true;
}

DefaultProperties
{
	EffectName = "TargetDefinition"
	DuplicateResponse = eDupe_Ignore
	EffectAddedFn = EffectAddedCallback
	TargetDefinitionTriggeredEventName = "TargetDefinitionTriggered"
}