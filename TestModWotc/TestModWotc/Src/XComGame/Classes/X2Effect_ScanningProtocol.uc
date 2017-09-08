//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_ScanningProtocol.uc
//  AUTHOR:  Joshua Bouscher
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Effect_ScanningProtocol extends X2Effect_Persistent;

var float LookAtDuration;

var privatewrite name ScanningProtocolTriggeredEventName;

function EffectAddedCallback(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	local X2EventManager EventMan;
	local XComGameState_Unit UnitState;

	EventMan = `XEVENTMGR;
	UnitState = XComGameState_Unit(kNewTargetState);
	if (UnitState != none)
	{
		UnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.UnburrowActionPoint);      //  will be useless for units without unburrow, just add it blindly

		EventMan.TriggerEvent(default.ScanningProtocolTriggeredEventName, kNewTargetState, kNewTargetState, NewGameState);
	}
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
	local X2Action_UpdateScanningProtocolOutline OutlineAction;
	local X2Action_PlaySoundAndFlyOver FlyOver;
	local X2AbilityTemplate AbilityTemplate;

	if (EffectApplyResult == 'AA_Success' && XComGameState_Unit(ActionMetadata.StateObject_NewState) != none)
	{
		OutlineAction = X2Action_UpdateScanningProtocolOutline(class'X2Action_UpdateScanningProtocolOutline'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		OutlineAction.bEnableOutline = true;

		AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(XComGameStateContext_Ability(VisualizeGameState.GetContext()).InputContext.AbilityTemplateName);
		FlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		FlyOver.SetSoundAndFlyOverParameters(none, AbilityTemplate.LocFlyOverText, '', eColor_Good, AbilityTemplate.IconImage, default.LookAtDuration, true);
	}
}

simulated function AddX2ActionsForVisualization_Removed(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	if (XComGameState_Unit(ActionMetadata.StateObject_NewState) != none)
	{
		class'X2Action_UpdateScanningProtocolOutline'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded);
	}
}

simulated function AddX2ActionsForVisualization_Sync( XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata )
{
	local X2Action_UpdateScanningProtocolOutline OutlineAction;

	OutlineAction = X2Action_UpdateScanningProtocolOutline( class'X2Action_UpdateScanningProtocolOutline'.static.AddToVisualizationTree( ActionMetadata, VisualizeGameState.GetContext( ) ) );
	OutlineAction.bEnableOutline = true;
}

DefaultProperties
{
	EffectName="ScanningProtocol"
	DuplicateResponse=eDupe_Ignore
	EffectAddedFn=EffectAddedCallback
	LookAtDuration=1.0f
	ScanningProtocolTriggeredEventName="ScanningProtocolTriggered"
}