//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_DLC_Day60Freeze.uc
//  AUTHOR:  Joshua Bouscher
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Effect_DLC_Day60Freeze extends X2Effect_PersistentStatChange config(GameCore);

var localized string FreezeName, FreezeDesc, RulerFreezeTickFlyover, FreezeEffectAddedString, FreezeEffectPersistsString, FreezeEffectRemovedString, FreezeLostFlyover, LargeUnitFreezeLostFlyover;
var config int DefenseMod;
var config string ConfigStatusIcon;
var config int LARGE_UNIT_FREEZE_DURATION;
var config int NORMAL_UNIT_FREEZE_DURATION;

var bool bAllowReorder;
var bool bApplyRulerModifiers;
var protectedwrite int MinRulerFreezeCount;
var protectedwrite int MaxRulerFreezeCount;

static function X2Effect_DLC_Day60Freeze CreateFreezeEffect(int InMinRulerFreezeCount, int InMaxRulerFreezeCount)
{
	local X2Effect_DLC_Day60Freeze      Effect;

	Effect = new class'X2Effect_DLC_Day60Freeze';
	Effect.BuildPersistentEffect(1, false, false, true, eGameRule_PlayerTurnBegin);
	Effect.bUseSourcePlayerState = true;
	Effect.bRemoveWhenTargetDies = true;
	Effect.SetDisplayInfo(ePerkBuff_Penalty, default.FreezeName, default.FreezeDesc, default.ConfigStatusIcon);

	Effect.AddPersistentStatChange(eStat_Dodge, 0, MODOP_PostMultiplication);       //  no dodge for you
	Effect.AddPersistentStatChange(eStat_Defense, default.DefenseMod);

	Effect.MinRulerFreezeCount = InMinRulerFreezeCount;
	Effect.MaxRulerFreezeCount = InMaxRulerFreezeCount;

	return Effect;
}

static function X2Effect CreateFreezeRemoveEffects()
{
	local X2Effect_RemoveEffectsByDamageType RemoveEffects;

	RemoveEffects = new class'X2Effect_RemoveEffectsByDamageType';
	RemoveEffects.DamageTypesToRemove.AddItem('stun');
	RemoveEffects.DamageTypesToRemove.AddItem('fire');
	RemoveEffects.DamageTypesToRemove.AddItem('poison');
	RemoveEffects.DamageTypesToRemove.AddItem(class'X2Effect_ParthenogenicPoison'.default.ParthenogenicPoisonType);
	RemoveEffects.DamageTypesToRemove.AddItem('acid');

	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.ConfusedName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.PanickedName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.StunnedName);

	return RemoveEffects;
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	local X2EventManager EventMan;

	TargetUnit = XComGameState_Unit(kNewTargetState);

	if (TargetUnit != none)
	{
		//  Freeze overrides stun, so clear out any stunned action points - they cannot be recovered
		TargetUnit.StunnedActionPoints = 0;
		TargetUnit.StunnedThisTurn = 0;
		//  Now knock off all of their AP
		TargetUnit.ActionPoints.Length = 0;
		TargetUnit.ReserveActionPoints.Length = 0;
		//  immobilize
		TargetUnit.SetUnitFloatValue(class'X2Ability_DefaultAbilitySet'.default.ImmobilizedValueName, 1);

		EventMan = `XEVENTMGR;
		TargetUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.UnburrowActionPoint);      //  will be useless for units without unburrow, just add it blindly
		EventMan.TriggerEvent(class'X2Ability_Chryssalid'.default.UnburrowTriggerEventName, kNewTargetState, kNewTargetState, NewGameState);
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

static function bool ShouldFreezeAsLargeUnit(XComGameState_Unit TargetUnit)
{
	return (TargetUnit.GetMyTemplate().UnitSize > 1 || TargetUnit.GetMyTemplateName() == 'AdvPsiWitchM3' || TargetUnit.GetMyTemplate().bIsChosen) && 
		!class'X2Helpers_DLC_Day60'.static.IsUnitAlienRuler(TargetUnit);
}

// This function really means "should I tick now"? So far all of our effects have ticked once per turn,
// so the function name made sense, but since this effect needs to tick after every xcom action
// on alien rulers, we need to specialize this function, but can't rename it or risk breaking mods
simulated function bool FullTurnComplete(XComGameState_Effect kEffect, XComGameState_Player Player)
{
	local XComGameState_Unit TargetUnit;
	local int CachedUnitActionPlayerId;

	// all units tick at the start of their turn
	TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kEffect.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	CachedUnitActionPlayerId = Player.ObjectID;
	return CachedUnitActionPlayerId == TargetUnit.ControllingPlayer.ObjectID;
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_Unit TargetUnit;
	
	// add action points
	TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (TargetUnit == none)
	{
		TargetUnit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	}

	if (TargetUnit != none && !class'X2Helpers_DLC_Day60'.static.IsUnitAlienRuler(TargetUnit))
	{
		TargetUnit.GiveStandardActionPoints();

		// large units get one fewer action point, since they thaw on their turn
		if(TargetUnit.ActionPoints.Length > 0 && ShouldFreezeAsLargeUnit(TargetUnit))
		{
			TargetUnit.ActionPoints.Remove(0, 1);
		}
	}

	//  stop the immobilize
	TargetUnit.ClearUnitValue(class'X2Ability_DefaultAbilitySet'.default.ImmobilizedValueName);

	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);
}

function bool ProvidesDamageImmunity(XComGameState_Effect EffectState, name DamageType)
{
	return DamageType == 'stun';
}

function int GetStartingNumTurns(const out EffectAppliedData ApplyEffectParameters)
{
	local XComGameState_Unit TargetUnit;
	local int RulerFreezeCount;

	TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (TargetUnit == none) // don't apply to non-units
		return 0;

	// Different unit types tick differently:
	// Large units and avatars: Remove effect at the start of their turn.
	// Alien rulers: Tick after every xcom action, or remove all at start of turn
	// All other units: Remove at the start of the turn after next
	if (ShouldFreezeAsLargeUnit(TargetUnit))
	{
		return LARGE_UNIT_FREEZE_DURATION;
	}
	else if(class'X2Helpers_DLC_Day60'.static.IsUnitAlienRuler(TargetUnit))
	{
		// Get per ruler modifier here and subtract it from the turns
		RulerFreezeCount = `SYNC_RAND(MaxRulerFreezeCount - MinRulerFreezeCount) + MinRulerFreezeCount;
		if (bApplyRulerModifiers)
		{
			RulerFreezeCount -= class'X2Helpers_DLC_Day60'.static.GetRulerFreezeModifier(TargetUnit);
		}
		return RulerFreezeCount;
	}
	else
	{
		// "normal" unit
		return NORMAL_UNIT_FREEZE_DURATION;
	}
}

function ModifyTurnStartActionPoints(XComGameState_Unit UnitState, out array<name> ActionPoints, XComGameState_Effect EffectState)
{
	//  no actions allowed while frozen
	ActionPoints.Length = 0;
}

simulated function AddX2ActionsForVisualization_Sync( XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata )
{
	local X2Action_DLC_Day60Freeze FreezeAction;

	super.AddX2ActionsForVisualization_Sync(VisualizeGameState, ActionMetadata);
	if (XComGameState_Unit(ActionMetadata.StateObject_NewState) != none)
	{
		FreezeAction = X2Action_DLC_Day60Freeze(class'X2Action_DLC_Day60Freeze'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		FreezeAction.PlayIdle = true;		
	}
}

// rulers show a different flyover from other units, so this function splits that out
static protected function string GetFlyoverTickText(XComGameState_Unit UnitState)
{
	local XComGameState_Effect EffectState;
	local X2AbilityTag AbilityTag;
	local string ExpandedString; // bsg-dforrest (7.27.17): need to clear out ParseObject

	EffectState = UnitState.GetUnitAffectedByEffectState(default.EffectName);
	if(class'X2Helpers_DLC_Day60'.static.IsUnitAlienRuler(UnitState))
	{
		EffectState = UnitState.GetUnitAffectedByEffectState(default.EffectName);
		AbilityTag = X2AbilityTag(`XEXPANDCONTEXT.FindTag("Ability"));
		AbilityTag.ParseObj = EffectState;
		// bsg-dforrest (7.27.17): need to clear out ParseObject
		ExpandedString = `XEXPAND.ExpandString(default.RulerFreezeTickFlyover);
		AbilityTag.ParseObj = none;
		// bsg-dforrest (7.27.17): end
		return ExpandedString;
	}
	else
	{
		return default.FreezeName;
	}
}

simulated function ModifyTracksVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ModifyTrack, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(ModifyTrack.StateObject_NewState);
	if( UnitState != none && EffectApplyResult == 'AA_Success' )
	{
		//  Make the freeze happen immediately after the wait, rather than waiting until after the apply damage action
		class'X2Action_DLC_Day60Freeze'.static.AddToVisualizationTree(ModifyTrack, VisualizeGameState.GetContext());
		class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ModifyTrack, VisualizeGameState.GetContext(), GetFlyoverTickText(UnitState), '', eColor_Bad, default.StatusIcon);
		class'X2StatusEffects'.static.AddEffectMessageToTrack(ModifyTrack,
															  default.FreezeEffectAddedString,
															  VisualizeGameState.GetContext(),
															  class'UIEventNoticesTactical'.default.FrozenTitle,
															  default.StatusIcon,
															  eUIState_Bad);
		class'X2StatusEffects'.static.UpdateUnitFlag(ModifyTrack, VisualizeGameState.GetContext());
	}
}

static function FreezeVisualizationTicked(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
	if (UnitState != none)
	{
		class'X2StatusEffects'.static.AddEffectCameraPanToAffectedUnitToTrack(ActionMetadata, VisualizeGameState.GetContext());
		class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), GetFlyoverTickText(UnitState), '', eColor_Bad, default.StatusIcon);
		class'X2StatusEffects'.static.AddEffectMessageToTrack(ActionMetadata,
															  default.FreezeEffectPersistsString,
															  VisualizeGameState.GetContext(),
															  class'UIEventNoticesTactical'.default.FrozenTitle,
															  default.StatusIcon,
															  eUIState_Warning);
		class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
	}
}

simulated function AddX2ActionsForVisualization_Removed(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	local XComGameState_Unit UnitState;
	local string FlyoverText;
	local XComGameStateVisualizationMgr VisMgr;
	local X2Action_SKULLJACK FromSkullJack;

	VisMgr = `XCOMVISUALIZATIONMGR;

	super.AddX2ActionsForVisualization_Removed(VisualizeGameState, ActionMetadata, EffectApplyResult, RemovedEffect);

	UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
	if (UnitState != none)
	{
		FromSkullJack = X2Action_SKULLJACK(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_SkullJack'));
		if( FromSkullJack != None )
		{
			class'X2Action_DLC_Day60FreezeEnd'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), true, , FromSkullJack.ParentActions);
		}
		else
		{
			class'X2Action_DLC_Day60FreezeEnd'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded);
		}
		
		if (UnitState.IsAlive())
		{
			FlyoverText = ShouldFreezeAsLargeUnit(UnitState) ? default.LargeUnitFreezeLostFlyover : default.FreezeLostFlyover;
			class'X2StatusEffects'.static.AddEffectCameraPanToAffectedUnitToTrack(ActionMetadata, VisualizeGameState.GetContext());
			class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), FlyoverText, '', eColor_Good, default.StatusIcon);
			class'X2StatusEffects'.static.AddEffectMessageToTrack(ActionMetadata,
																  default.FreezeEffectRemovedString,
																  VisualizeGameState.GetContext(),
																  class'UIEventNoticesTactical'.default.FrozenTitle,
																  default.StatusIcon,
																  eUIState_Good);
			class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
		}
	}
}

DefaultProperties
{
	bIsImpairing = true
	bAllowReorder = true
	EffectName = "Freeze"
	DuplicateResponse = eDupe_Refresh
	DamageTypes(0) = "Frost"
	ModifyTracksFn = ModifyTracksVisualization
	EffectTickedVisualizationFn = FreezeVisualizationTicked
	bCanTickEveryAction=true

	Begin Object Class=X2Condition_UnitEffects Name=UnitEffectsCondition
		ExcludeEffects(0)=(EffectName="Unconscious", Reason="AA_UnitIsUnconscious")
	End Object

	TargetConditions.Add(UnitEffectsCondition)
}