//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    X2Effect_Panicked.uc    
//  AUTHOR:  Alex Cheng  --  2/12/2015
//  PURPOSE: Panic Effects - Remove control from player and run Panic behavior tree.
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Effect_Panicked extends X2Effect_PersistentStatChange
	config(GameCore);

var const config int ActionPoints;
var const config int BTRunCount;
var const config string BehaviorTreeRoot;

var localized string EffectFriendlyName;
var localized string EffectLostFriendlyName;
var localized string EffectFriendlyDesc;
var localized string EffectFailedFriendlyName;
var localized string EffectAcquiredString;
var localized string EffectTickedString;
var localized string EffectLostString;

simulated function BuildPersistentEffect(int _iNumTurns, optional bool _bInfiniteDuration=false, optional bool _bRemoveWhenSourceDies=true, optional bool _bIgnorePlayerCheckOnTick=false, optional GameRuleStateChange _WatchRule=eGameRule_TacticalGameStart )
{
	super.BuildPersistentEffect(_iNumTurns, _bInfiniteDuration, _bRemoveWhenSourceDies, _bIgnorePlayerCheckOnTick, _WatchRule);

	SetDisplayInfo(ePerkBuff_Penalty, EffectFriendlyName, EffectFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_panic");
}

function ModifyTurnStartActionPoints(XComGameState_Unit UnitState, out array<name> InActionPoints, XComGameState_Effect EffectState)
{
	// If our effect is set to expire this turn, don't modify the action points
	if (EffectState.iTurnsRemaining == 1 && WatchRule == eGameRule_PlayerTurnBegin)
		return;

	// Disable player control while panic is in effect.
	InActionPoints.Length = 0;
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit UnitState;
	local Name PanicBehaviorTree;
	local bool bCivilian;
	local int Point;
	local eTeam UnitTeam;
	
	UnitState = XComGameState_Unit(kNewTargetState);
	if (m_aStatChanges.Length > 0)
	{
		NewEffectState.StatChanges = m_aStatChanges;

		//  Civilian panic does not modify stats and does not need to call the parent functions (which will result in a RedScreen for having no stats!)
		super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
	}

	UnitTeam = UnitState.GetTeam();

	// Add two standard action points for panicking actions.	
	bCivilian = UnitTeam == eTeam_Neutral;
	if( !bCivilian )
	{
		for( Point = 0; Point < ActionPoints; ++Point )
		{
			if( Point < UnitState.ActionPoints.Length )
			{
				if( UnitState.ActionPoints[Point] != class'X2CharacterTemplateManager'.default.StandardActionPoint )
				{
					UnitState.ActionPoints[Point] = class'X2CharacterTemplateManager'.default.StandardActionPoint;
				}
			}
			else
			{
				UnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
			}
		}
	}
	else
	{
		// Force civilians into red alert.
		if( UnitState.GetCurrentStat(eStat_AlertLevel) != `ALERT_LEVEL_RED )
		{
			UnitState.SetCurrentStat(eStat_AlertLevel, `ALERT_LEVEL_RED);
		}
	}
	UnitState.bPanicked = true;

	`XEVENTMGR.TriggerEvent('UnitPanicked', UnitState, UnitState, NewGameState);

	if( !bCivilian )
	{
		if (UnitTeam == eTeam_XCom)
		{
			PanicBehaviorTree = Name(BehaviorTreeRoot);
		}
		else
		{
			// Kick off panic behavior tree.
			PanicBehaviorTree = Name(UnitState.GetMyTemplate().strPanicBT);
		}

		// Delayed behavior tree kick-off.  Points must be added and game state submitted before the behavior tree can 
		// update, since it requires the ability cache to be refreshed with the new action points.
		UnitState.AutoRunBehaviorTree(PanicBehaviorTree, BTRunCount, `XCOMHISTORY.GetCurrentHistoryIndex() + 1, true);
	}
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_Unit UnitState;
	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

	UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	// This cleared flag is set through the AIBehavior after the behavior tree runs in OnEffectAdded.
	UnitState.bPanicked = false;
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, name EffectApplyResult)
{
	local XComGameState_Unit UnitState;

	super.AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, EffectApplyResult);

	if( EffectApplyResult != 'AA_Success' )
	{
		return;
	}

	// pan to the panicking unit (but only if it isn't a civilian)
	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);
	if (UnitState == none)
		return;

	if(!UnitState.IsCivilian())
	{
		class'X2StatusEffects'.static.AddEffectCameraPanToAffectedUnitToTrack(BuildTrack, VisualizeGameState.GetContext());
		class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(BuildTrack, VisualizeGameState.GetContext(), EffectFriendlyName, 'PanicScream', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_Panicked);
		class'X2StatusEffects'.static.AddEffectMessageToTrack(BuildTrack,
															  default.EffectAcquiredString,
															  VisualizeGameState.GetContext(),
															  class'UIEventNoticesTactical'.default.PanickedTitle,
															  "img:///UILibrary_PerkIcons.UIPerk_panic",
															  eUIState_Bad,
															  true); // no audio event for panic, since the will test audio would overlap
	}

	class'X2StatusEffects'.static.UpdateUnitFlag(BuildTrack, VisualizeGameState.GetContext());
}

simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, const int TickIndex, XComGameState_Effect EffectState)
{
	local XComGameState_Unit UnitState;

	super.AddX2ActionsForVisualization_Tick(VisualizeGameState, BuildTrack, TickIndex, EffectState);

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);
	if (UnitState == none)
		return;

	// dead units should not be reported, nor civilians
	if( !UnitState.IsAlive() )
	{
		return;
	}

	if( !UnitState.IsCivilian() )
	{
		class'X2StatusEffects'.static.AddEffectCameraPanToAffectedUnitToTrack(BuildTrack, VisualizeGameState.GetContext());
		class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(BuildTrack, VisualizeGameState.GetContext(), EffectFriendlyName, 'PanickedBreathing', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_Panicked);
		class'X2StatusEffects'.static.AddEffectMessageToTrack(BuildTrack,
															  EffectTickedString,
															  VisualizeGameState.GetContext(),
															  class'UIEventNoticesTactical'.default.PanickedTitle,
															  "img:///UILibrary_PerkIcons.UIPerk_panic",
															  eUIState_Warning);
	}

	class'X2StatusEffects'.static.UpdateUnitFlag(BuildTrack, VisualizeGameState.GetContext());
}

simulated function AddX2ActionsForVisualization_Removed(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	local XComGameState_Unit UnitState;

	super.AddX2ActionsForVisualization_Removed(VisualizeGameState, BuildTrack, EffectApplyResult, RemovedEffect);

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);
	if (UnitState == none)
		return;

	// dead units should not be reported. Also, rescued civilians should not display the fly-over.
	if( !UnitState.IsAlive() || UnitState.bRemovedFromPlay )
	{
		return;
	}

	class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(BuildTrack, VisualizeGameState.GetContext(), EffectLostFriendlyName, '', eColor_Good, class'UIUtilities_Image'.const.UnitStatus_Panicked, 2.0f);
	class'X2StatusEffects'.static.AddEffectMessageToTrack(BuildTrack,
														  EffectLostString,
														  VisualizeGameState.GetContext(),
														  class'UIEventNoticesTactical'.default.PanickedTitle,
														  "img:///UILibrary_PerkIcons.UIPerk_panic",
														  eUIState_Good);
	class'X2StatusEffects'.static.UpdateUnitFlag(BuildTrack, VisualizeGameState.GetContext());
}

static function int GetPanicSourceID(int UnitObjectID, Name PanicEffectName)
{
	local XComGameStateHistory History;
	local XComGameStateContext_WillRoll WillContext;
	local XComGameStateContext_Ability AbilitySourceContext;
	local XComGameState ChainStartState;
	// Find last WillRoll context for this unit that resulted in a panic condition.
	History = `XCOMHISTORY;
	foreach History.IterateContextsByClassType(class'XComGameStateContext_WillRoll', WillContext)
	{
		if (WillContext.SourceUnit.ObjectID == UnitObjectID && WillContext.PanicAbilityName == PanicEffectName)
		{
			if (WillContext.TargetUnitID == UnitObjectID)
			{
				// We need to go deeper.  Look at the first context in the event chain.  Find the instigator of that ability.
				ChainStartState = WillContext.GetFirstStateInEventChain();
				AbilitySourceContext = XComGameStateContext_Ability(ChainStartState.GetContext());
				if (AbilitySourceContext != None && AbilitySourceContext.InputContext.SourceObject.ObjectID != UnitObjectID)
				{
					return AbilitySourceContext.InputContext.SourceObject.ObjectID;
				}
			}
			return WillContext.TargetUnitID;
		}
	}
	return INDEX_NONE;
}


DefaultProperties
{
	DuplicateResponse=eDupe_Ignore
	bRemoveWhenTargetDies=true
	bIsImpairingMomentarily=true
	DamageTypes.Add("Mental");
	DamageTypes.Add("Panic");
}