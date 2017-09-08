//---------------------------------------------------------------------------------------
//  FILE:    XComGameStateContext_ApplyWorldEffects.uc
//  AUTHOR:  Ryan McFall  --  8/25/2014
//  PURPOSE: This context is created in response to events where world effects should 
//           be applied to an object, such as when a unit moves into a cloud of poison.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameStateContext_ApplyWorldEffects extends XComGameStateContext
	native(Core);

var XComGameState_BaseObject ApplyEffectTarget;

// These are filled in by UXComWorldData::ApplyWorldEffectsToObject
var EffectResults TargetEffectResults;

function bool Validate(optional EInterruptionStatus InInterruptionStatus)
{
	return true;
}

function XComGameState ContextBuildGameState()
{
	local XComGameState NewGameState;	
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	NewGameState = History.CreateNewGameState(true, self);

	if( !`XWORLD.ApplyWorldEffectsToObject(ApplyEffectTarget, NewGameState) )
	{
		History.CleanupPendingGameState(NewGameState);
		NewGameState = none;
	}
	
	return NewGameState;
}

function OnSubmittedToReplay(XComGameState SubmittedGameState)
{
	local X2EffectTemplateRef TemplateRef;
	local int i;

	for (i = 0; i < TargetEffectResults.Effects.length; i++)
	{
		TemplateRef = TargetEffectResults.TemplateRefs[i];
		TargetEffectResults.Effects[i] = class'X2Effect'.static.GetX2Effect(TemplateRef);
	}
}

protected function ContextBuildVisualization()
{	
	local VisualizationActionMetadata ActionMetadata;	
	local XComGameStateHistory History;
	local int i;
	
	History = `XCOMHISTORY;

	History.GetCurrentAndPreviousGameStatesForObjectID(ApplyEffectTarget.ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState, , AssociatedState.HistoryIndex);
	ActionMetadata.VisualizeActor = History.GetVisualizer(ApplyEffectTarget.ObjectID);

	for (i = 0; i < TargetEffectResults.Effects.length; i++)
	{
		TargetEffectResults.Effects[i].AddX2ActionsForVisualization(AssociatedState, ActionMetadata, TargetEffectResults.ApplyResults[i]);
	}

	
}

function string SummaryString()
{
	return "XComGameStateContext_ApplyWorldEffects";
}