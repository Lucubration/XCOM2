//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2StatusEffects_XPack extends Object config(GameCore);

var localized string DazedFriendlyName;
var localized string DazedFriendlyDesc;
var localized string DazedEffectAcquiredString;
var localized string DazedEffectTickedString;
var localized string DazedEffectLostString;
var localized string DazedPerActionFriendlyName;

var config int DAZED_HIERARCHY_VALUE;
var config string DazedParticle_Name;
var config name DazedSocket_Name;
var config name DazedSocketsArray_Name;

static function X2Effect_Dazed CreateDazedStatusEffect(int StunLevel, int Chance)
{
	local X2Effect_Dazed DazedEffect;
	local X2Condition_UnitProperty UnitPropCondition;

	DazedEffect = new class'X2Effect_Dazed';
	DazedEffect.BuildPersistentEffect(1, true, true, false, eGameRule_UnitGroupTurnBegin);
	DazedEffect.ApplyChance = Chance;
	DazedEffect.StunLevel = StunLevel;
	DazedEffect.bIsImpairing = true;
	DazedEffect.EffectHierarchyValue = default.DAZED_HIERARCHY_VALUE;
	DazedEffect.EffectName = class'X2AbilityTemplateManager'.default.DazedName;
	DazedEffect.VisualizationFn = DazedVisualization;
	DazedEffect.EffectTickedVisualizationFn = DazedVisualizationTicked;
	DazedEffect.EffectRemovedVisualizationFn = DazedVisualizationRemoved;
	DazedEffect.bRemoveWhenTargetDies = true;
	DazedEffect.bCanTickEveryAction = true;
	DazedEffect.DamageTypes.AddItem('Mental');

	if (default.DazedParticle_Name != "")
	{
		DazedEffect.VFXTemplateName = default.DazedParticle_Name;
		DazedEffect.VFXSocket = default.DazedSocket_Name;
		DazedEffect.VFXSocketsArrayName = default.DazedSocketsArray_Name;
	}

	UnitPropCondition = new class'X2Condition_UnitProperty';
	UnitPropCondition.ExcludeFriendlyToSource = true;
	UnitPropCondition.FailOnNonUnits = true;
	UnitPropCondition.ExcludeRobotic = true;
	DazedEffect.TargetConditions.AddItem(UnitPropCondition);

	return DazedEffect;
}

private static function string GetDazedFlyoverText(XComGameState_Unit TargetState, bool FirstApplication)
{
	local XComGameState_Effect EffectState;
	local X2AbilityTag AbilityTag;
	local string ExpandedString; // bsg-dforrest (7.27.17): need to clear out ParseObject

	EffectState = TargetState.GetUnitAffectedByEffectState(class'X2AbilityTemplateManager'.default.DazedName);
	if (FirstApplication || (EffectState != none && EffectState.GetX2Effect().IsTickEveryAction(TargetState)))
	{
		AbilityTag = X2AbilityTag(`XEXPANDCONTEXT.FindTag("Ability"));
		AbilityTag.ParseObj = TargetState;
		// bsg-dforrest (7.27.17): need to clear out ParseObject
		ExpandedString = `XEXPAND.ExpandString(default.DazedPerActionFriendlyName);
		AbilityTag.ParseObj = none;
		return ExpandedString;
		// bsg-dforrest (7.27.17): end
	}
	else
	{
		return default.DazedFriendlyName;
	}
}

static function DazedVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameState_Unit TargetState;

	if (EffectApplyResult != 'AA_Success')
	{
		return;
	}

	TargetState = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(ActionMetadata.StateObject_NewState.ObjectID));
	if (TargetState == none)
		return;

	class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), GetDazedFlyoverText(TargetState, true), '', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_Stunned);
	class'X2StatusEffects'.static.AddEffectMessageToTrack(ActionMetadata,
														  default.DazedEffectAcquiredString,
														  VisualizeGameState.GetContext(),
														  class'UIEventNoticesTactical'.default.DazedTitle,
														  class'UIUtilities_Image'.const.UnitStatus_Stunned,
														  eUIState_Bad);
	class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

static function DazedVisualizationTicked(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(ActionMetadata.StateObject_NewState.ObjectID));
	if (UnitState == none)
		return;

	// dead units should not be reported
	if (!UnitState.IsAlive())
	{
		return;
	}

	class'X2StatusEffects'.static.AddEffectCameraPanToAffectedUnitToTrack(ActionMetadata, VisualizeGameState.GetContext());
	class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), GetDazedFlyoverText(UnitState, false), '', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_Stunned);
	class'X2StatusEffects'.static.AddEffectMessageToTrack(ActionMetadata,
														  default.DazedEffectTickedString,
														  VisualizeGameState.GetContext(),
														  class'UIEventNoticesTactical'.default.DazedTitle,
														  class'UIUtilities_Image'.const.UnitStatus_Stunned,
														  eUIState_Warning);
	class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

static function DazedVisualizationRemoved(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
	if (UnitState == none)
		return;

	// dead units should not be reported
	if (!UnitState.IsAlive())
	{
		return;
	}

	class'X2StatusEffects'.static.AddEffectMessageToTrack(ActionMetadata,
														  default.DazedEffectLostString,
														  VisualizeGameState.GetContext(),
														  class'UIEventNoticesTactical'.default.DazedTitle,
														  class'UIUtilities_Image'.const.UnitStatus_Stunned,
														  eUIState_Good);
	class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}