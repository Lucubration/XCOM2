//---------------------------------------------------------------------------------------
//  FILE:    XComGameStateContext_RevealAI.uc
//  AUTHOR:  Ryan McFall  --  3/5/2014
//  PURPOSE: This context handles the AI reflex moves that occur when X-Com is noticed
//           by enemies.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameStateContext_RevealAI extends XComGameStateContext
	native(Core);

enum ERevealAIEvent
{
	eRevealAIEvent_Begin,
	eRevealAIEvent_End
};

var ERevealAIEvent RevealAIEvent;
var array<int> RevealedUnitObjectIDs;
var array<int> SurprisedScamperUnitIDs;
var array<int> ConcealmentBrokenUnits;
var int CausedRevealUnit_ObjectID;
var name SpecialRevealType;

var XComNarrativeMoment FirstSightingMoment;  // When our first sighting is also our pod reveal - Avatar / Codex
var bool bDoSoldierVO;								// If this is true, we should do solider VO because we havn't seen this enemy yet

// If the leader of the revealed group is a type of enemy that has never been encountered before in this campaign, store its
// character template here.
var X2CharacterTemplate FirstEncounterCharacterTemplate;

function bool Validate(optional EInterruptionStatus InInterruptionStatus)
{
	return true;
}

function XComGameState ContextBuildGameState()
{
	local XComGameState NewGameState;
	local XComGameStateContext_RevealAI NewContext;
	local XComGameState_Unit UnitState;
	local XComGameState_AIGroup GroupState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_MissionSite MissionState;
	local XComGameStateHistory History;
	local X2CharacterTemplate CharacterTemplate;
	local int Index, iEvents;
	local int RevealedUnitObjectID;
	local X2EventManager EventManager;

	History = `XCOMHISTORY;

	switch(RevealAIEvent)
	{
	case eRevealAIEvent_Begin:
		NewGameState = History.CreateNewGameState(true, self);
		NewContext = XComGameStateContext_RevealAI(NewGameState.GetContext());
		for( Index = 0; Index < RevealedUnitObjectIDs.Length; ++Index )
		{
			RevealedUnitObjectID = RevealedUnitObjectIDs[Index];

			UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', RevealedUnitObjectID));
			UnitState.ReflexActionState = eReflexActionState_AIScamper;
			UnitState.bTriggerRevealAI = false; //Mark this AI as having already triggered a reveal

			`XACHIEVEMENT_TRACKER.OnRevealAI(NewGameState, RevealedUnitObjectID);

			if(GroupState == none)
			{
				GroupState = UnitState.GetGroupMembership();
			}

			CharacterTemplate = UnitState.GetMyTemplate();
			
			// try to find a unit that the player hasn't seen yet to play the reveal on
			if (NewContext.FirstSightingMoment == none)
			{
				XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));
				if(XComHQ != none && !XComHQ.HasSeenCharacterTemplate(CharacterTemplate))
				{
					//Update the HQ state to record that we saw this enemy type
					XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));					
					XComHQ.AddSeenCharacterTemplate(CharacterTemplate);

					//Store this in the context for easy access in the visualizer action
					if (`CHEATMGR == none || !`CHEATMGR.DisableFirstEncounterVO)
					{
						MissionState = XComGameState_MissionSite(History.GetGameStateForObjectID(XComHQ.MissionRef.ObjectID));
						if (MissionState == none || !MissionState.GetMissionSource().bBlockFirstEncounterVO)
						{
							if (CharacterTemplate.SightedNarrativeMoments.Length > 0)
								NewContext.FirstSightingMoment = CharacterTemplate.SightedNarrativeMoments[0];
						}
						NewContext.FirstEncounterCharacterTemplate = CharacterTemplate;
					}
				}
			}

			// Trigger any sighted events for this unit, this after EverSightedByEnemy is set to true they won't be triggered by sighting the unit
			for (iEvents = 0; iEvents < CharacterTemplate.SightedEvents.Length; iEvents++)
			{
				`XEVENTMGR.TriggerEvent(CharacterTemplate.SightedEvents[iEvents], , , NewGameState);
			}
		}

		//Indicate that this group has processed its scamper
		GroupState = XComGameState_AIGroup(NewGameState.ModifyStateObject(GroupState.Class, GroupState.ObjectID));
		GroupState.MarkGroupSighted(XComGameState_Unit(History.GetGameStateForObjectID(GroupState.RevealInstigatorUnitObjectID)), NewGameState);
		GroupState.bPendingScamper = false;

		EventManager = `XEVENTMGR;
		EventManager.TriggerEvent('ScamperBegin', GroupState, GroupState, NewGameState);

		break;
	case eRevealAIEvent_End:
		NewGameState = History.CreateNewGameState(true, self);
		NewContext = XComGameStateContext_RevealAI(NewGameState.GetContext());
		NewContext.SetVisualizationFence(true);
		
		for( Index = 0; Index < RevealedUnitObjectIDs.Length; ++Index )
		{
			UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', RevealedUnitObjectIDs[Index]));			
			UnitState.ReflexActionState = eReflexActionState_None;

			if (GroupState == none)
			{
				GroupState = UnitState.GetGroupMembership();
			}
		}		
		
		EventManager = `XEVENTMGR;
		EventManager.TriggerEvent('ScamperEnd', GroupState, GroupState, NewGameState);
		
		break;
	}

	return NewGameState;
}

function bool IsChosenRevealed(optional out XComGameState_Unit ChosenUnit)
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local int Index;

	History = `XCOMHISTORY;
	for( Index = 0; Index < RevealedUnitObjectIDs.Length; ++Index )
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(RevealedUnitObjectIDs[Index], eReturnType_Reference, AssociatedState.HistoryIndex));
		if( UnitState.IsChosen() )
		{
			ChosenUnit = UnitState;
			return true;
		}
	}
	return false;
}

function bool IsChosenInFOW(optional out XComGameState_Unit ChosenUnit)
{ 
	if( IsChosenRevealed(ChosenUnit) )
	{
		// Check if we need to clear the FoW.
		if( class'X2TacticalVisibilityHelpers'.static.GetNumEnemyViewersOfTarget(ChosenUnit.ObjectID, INDEX_NONE) == 0 )
		{
			return true;
		}
	}
	return false;
}

protected function ContextBuildVisualization()
{	
	local VisualizationActionMetadata EmptyTrack;
	local VisualizationActionMetadata ActionMetadata;
	local XComGameState_BattleData BattleState;
	local XComGameState_Unit UnitState;
	local XComGameStateHistory History;
	local X2Action_UpdateUI UpdateUIAction;
	local XComGameState_AIGroup GroupState;
	local X2Action_RevealAIBegin RevealBeginAction;
	local X2Action_RevealArea RevealAreaAction;
	local bool bAlwaysShowFullReveal;

	History = `XCOMHISTORY;
	BattleState = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));

	switch(RevealAIEvent)
	{
	case eRevealAIEvent_Begin:
		if( IsChosenInFOW( UnitState ) )
		{
			ActionMetadata.StateObject_OldState = BattleState;
			ActionMetadata.StateObject_NewState = BattleState;
			ActionMetadata.VisualizeActor = none;

			RevealAreaAction = X2Action_RevealArea(class'X2Action_RevealArea'.static.AddToVisualizationTree(ActionMetadata, self));
			RevealAreaAction.TargetLocation = XGUnit(UnitState.GetVisualizer()).GetPawn().GetFeetLocation();
			RevealAreaAction.TargetLocation.Z += class'XComWorldData'.const.WORLD_FloorHeight;
			RevealAreaAction.AssociatedObjectID = UnitState.ObjectID;
			RevealAreaAction.bDestroyViewer = false;			
		}

		ActionMetadata = EmptyTrack;
		ActionMetadata.StateObject_OldState = BattleState;
		ActionMetadata.StateObject_NewState = BattleState;
		ActionMetadata.VisualizeActor = none;

		UpdateUIAction = X2Action_UpdateUI(class'X2Action_UpdateUI'.static.AddToVisualizationTree(ActionMetadata, self));
		UpdateUIAction.UpdateType = EUIUT_GroupInitiative;

		bAlwaysShowFullReveal = false;
		foreach AssociatedState.IterateByClassType(class'XComGameState_Unit', UnitState)
		{
			if( GroupState == None )
			{
				GroupState = UnitState.GetGroupMembership();
			}

			bAlwaysShowFullReveal = bAlwaysShowFullReveal || UnitState.GetMyTemplate().bRevealMatineeAlwaysValid;
		}

		RevealBeginAction = X2Action_RevealAIBegin(class'X2Action_RevealAIBegin'.static.AddToVisualizationTree(ActionMetadata, self));
		RevealBeginAction.bOnlyFrameAI = (!bAlwaysShowFullReveal && (GroupState != None && GroupState.DelayedScamperCause == eAC_MapwideAlert_Hostile)) ||
			(SpecialRevealType == 'ChosenSpecialNoReveal' || SpecialRevealType == 'ChosenSpecialTopDownReveal' || SpecialRevealType == 'TheLostSwarm');

		class'XComGameState_NarrativeManager'.static.BuildVisualizationForDynamicNarrative(AssociatedState, true, 'RevealAI', RevealBeginAction);

		//Add an empty track for each unit that is scampering so that the visualization blocks are sequenced
		foreach AssociatedState.IterateByClassType(class'XComGameState_Unit', UnitState)
		{
			ActionMetadata = EmptyTrack;
			History.GetCurrentAndPreviousGameStatesForObjectID(UnitState.ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState, eReturnType_Reference, AssociatedState.HistoryIndex);
			ActionMetadata.VisualizeActor = History.GetVisualizer(UnitState.ObjectID);
			
			class'X2Action_ShowSpawnedUnit'.static.AddToVisualizationTree(ActionMetadata, self, false, RevealBeginAction);
		}

		if( CausedRevealUnit_ObjectID > 0 )
		{
			//Add an empty track for the unit that caused the reveal
			ActionMetadata = EmptyTrack;
			History.GetCurrentAndPreviousGameStatesForObjectID(CausedRevealUnit_ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState, eReturnType_Reference, AssociatedState.HistoryIndex);
			// Prevent crash on scampering from dropping in units.
			if( ActionMetadata.StateObject_OldState == None )
				ActionMetadata.StateObject_OldState = ActionMetadata.StateObject_NewState;
			`Assert(ActionMetadata.StateObject_OldState != None);
			ActionMetadata.VisualizeActor = History.GetVisualizer(CausedRevealUnit_ObjectID);

			
		}

		break;
	case eRevealAIEvent_End:
		if( IsChosenRevealed(UnitState) )
		{
			ActionMetadata.StateObject_OldState = BattleState;
			ActionMetadata.StateObject_NewState = BattleState;
			ActionMetadata.VisualizeActor = none;

			RevealAreaAction = X2Action_RevealArea(class'X2Action_RevealArea'.static.AddToVisualizationTree(ActionMetadata, self));
			RevealAreaAction.AssociatedObjectID = UnitState.ObjectID;
			RevealAreaAction.bDestroyViewer = true;

			// Update Chosen UI and play fanfare audio (via UI code on first time). In case chosen scampers into engaged state
			UpdateUIAction = X2Action_UpdateUI(class'X2Action_UpdateUI'.static.AddToVisualizationTree(ActionMetadata, self, false, ActionMetadata.LastActionAdded));
			UpdateUIAction.SpecificID = UnitState.ObjectID;
			UpdateUIAction.UpdateType = EUIUT_ChosenHUD;
		}
		ActionMetadata = EmptyTrack;
		ActionMetadata.StateObject_OldState = BattleState;
		ActionMetadata.StateObject_NewState = BattleState;
		ActionMetadata.VisualizeActor = none;
		class'X2Action_RevealAIEnd'.static.AddToVisualizationTree(ActionMetadata, self);
		
		//Add an empty track for each unit that is scampering so that the visualization blocks are sequenced
		foreach AssociatedState.IterateByClassType(class'XComGameState_Unit', UnitState)
		{
			ActionMetadata = EmptyTrack;
			History.GetCurrentAndPreviousGameStatesForObjectID(UnitState.ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState, eReturnType_Reference, AssociatedState.HistoryIndex);
			ActionMetadata.VisualizeActor = History.GetVisualizer(UnitState.ObjectID);
			
		}

		if(CausedRevealUnit_ObjectID > 0)
		{
			//Add an empty track for the unit that caused the reveal
			ActionMetadata = EmptyTrack;
			History.GetCurrentAndPreviousGameStatesForObjectID(CausedRevealUnit_ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState, eReturnType_Reference, AssociatedState.HistoryIndex);
			// Prevent crash on scampering from dropping in units.
			if(ActionMetadata.StateObject_OldState == None)
				ActionMetadata.StateObject_OldState = ActionMetadata.StateObject_NewState;
			`Assert(ActionMetadata.StateObject_OldState != None);
			ActionMetadata.VisualizeActor = History.GetVisualizer(CausedRevealUnit_ObjectID);
			
		}

		break;
	}
}

function MergeIntoVisualizationTree(X2Action BuildTree, out X2Action VisualizationTree)
{
	local XComGameStateVisualizationMgr VisualizationMgr;		
	local int Index;
	local array<X2Action> LeafNodes;
	local array<X2Action> UseParentNodes;
		
	//We want all prior visualization to complete before proceeding with the AI reveal
	VisualizationMgr = `XCOMVISUALIZATIONMGR;

	VisualizationMgr.GetAllLeafNodes(VisualizationTree, LeafNodes);
	for (Index = 0; Index < LeafNodes.Length; ++Index)
	{
		if (X2Action_MarkerTreeInsertEnd(LeafNodes[Index]) != none)
		{
			UseParentNodes.AddItem(LeafNodes[Index]);
		}
	}

	VisualizationMgr.ConnectAction(BuildTree, VisualizationTree, false, none, UseParentNodes);
}

static function XComGameStateContext_ChangeContainer CreateEmptyChangeContainer()
{
	return XComGameStateContext_ChangeContainer(CreateXComGameStateContext());
}

// Debug-only function used in X2DebugHistory screen.
function bool HasAssociatedObjectID(int ID)
{
	if( RevealedUnitObjectIDs.Find(ID) != INDEX_NONE
	   || SurprisedScamperUnitIDs.Find(ID) != INDEX_NONE
	   || ConcealmentBrokenUnits.Find(ID) != INDEX_NONE
	   || CausedRevealUnit_ObjectID == ID)
	   return true;

	return false;
}


function string SummaryString()
{
	return "XComGameStateContext_RevealAI (" $ RevealedUnitObjectIDs.Length $ ") [" $ `XCOMHISTORY.GetGameStateForObjectID(RevealedUnitObjectIDs[0]).SummaryString() $ "]";
}
