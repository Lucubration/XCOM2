//---------------------------------------------------------------------------------------
//  FILE:    XComReplayManager.uc
//  AUTHOR:  Ryan McFall  --  10/16/2013
//  PURPOSE: This manager is the interface through which users may visualize previously 
//           recorded XComGameState frames. Usages could include debugging, user facing
//           instant replay features, etc.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComReplayMgr extends Actor native(Core);

var() protectedwrite int CurrentHistoryFrame; //Tracks the frame that the replay system is treating as the 'current' frame for purposes of visualization
var() protectedwrite bool bInReplay;          //This flag is true while the replay manager is running
var() protectedwrite bool bInTutorial;        //This flag is true while the replay manager is a TutorialMgr
var() bool bSingleStepMode;                 //In single step mode, the replay manager 'step' methods will increment the history frame only once. This may be done for debugging.

var() protectedwrite int StepForwardStopFrame;    //The frame immediately prior to the last frame in the history: (`XCOMHISTORY.GetNumGameStates() - 1)
var() protectedwrite int StepBackwardStopFrame;   //The start state for this session

var() protectedwrite bool bVisualizationSkip;  // The value thats passed into BuildVisualization

var UIReplay ReplayUI;

simulated function string GetStateDebugString()
{
	local string DebugString;
	DebugString $= `location;
	DebugString $= "    CurrentHistoryFrame:" @ CurrentHistoryFrame;
	DebugString $= "    bInReplay:" @ bInReplay;
	DebugString $= "    bInTutorial:" @ bInTutorial;
	DebugString $= "    bSingleStepMode:" @ bSingleStepMode;
	DebugString $= "    StepForwardStopFrame:" @ StepForwardStopFrame;
	DebugString $= "    StepBackwardStopFrame:" @ StepBackwardStopFrame;
	DebugString $= "    bVisualizationSkip:" @ bVisualizationSkip;
	DebugString $= "\n\n";
	return DebugString;
}

/// <summary>
/// Switches the running tactical game into a replay mode, where the visualization is driven by frames already in the
/// game state history.
/// </summary>
simulated event StartReplay(int SessionStartStateIndex)
{	
	local XComGameStateVisualizationMgr VisualizationMgr;	
	local XComGameStateHistory History;
	local array<X2Action> NewlyStartedActions;

	VisualizationMgr = `XCOMVISUALIZATIONMGR;
	History = `XCOMHISTORY;

	StepForwardStopFrame = (History.GetNumGameStates() - 1);
	StepBackwardStopFrame = SessionStartStateIndex;

	SetInputState();
	bInReplay = true;		
	CurrentHistoryFrame = SessionStartStateIndex;
	History.SetCurrentHistoryIndex(CurrentHistoryFrame);
	VisualizationMgr.BuildVisualizationFrame(CurrentHistoryFrame, NewlyStartedActions, true);	
	VisualizationMgr.CheckStartBuildTree();

	// move the camera to it's initial start location, if this mission has a fixed orientation
	class'X2Action_InitCamera'.static.InitCamera();

	StepReplayForward();
}

simulated function SetInputState()
{
	local XComTacticalController TacticalController;	
	TacticalController = XComTacticalController(class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController());
	TacticalController.SetInputState('InReplayPlayback');
}

/// <summary>
/// Set the visualization back to the last recorded state of the game and return control to the player
/// </summary>
simulated event StopReplay()
{	
	local XComTacticalController TacticalController;
	local XComGameStateHistory History;	

	History = `XCOMHISTORY;	
	TacticalController = XComTacticalController(class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController());	

	if( TacticalController != none )
	{
		//Obliterate any history that takes place after we are taking control
		History.ObliterateGameStatesFromHistory( History.GetNumGameStates() - CurrentHistoryFrame );
		TacticalController.SetInputState('ActiveUnit_Moving');
		bInReplay = false;		
		`TACTICALRULES.EndReplay();	

		`XCOMVISUALIZATIONMGR.SetCurrentHistoryFrame(History.GetNumGameStates() - 1);
		History.SetCurrentHistoryIndex(-1);
		`XCOMVISUALIZATIONMGR.EnableBuildVisualization();
	}
}

/// <summary>
/// Steps the visualization to the next game state
/// </summary>
simulated event StepReplayForward(bool bStepAll = false)
{	
	local XComGameStateVisualizationMgr VisualizationMgr;
	local XComGameState NextGameState, EventChainLastState;	
	local XComGameStateHistory History;	
	local int StartTickIndex;
	local int SkipTicksIndex;
	local bool bHasVisualizationBlock;
	local XComGameStateContext_TacticalGameRule GameRuleContext;
	local X2TacticalGameRuleset GameRuleset;
	local array<X2Action> NewlyStartedActions;
	local XComGameStateContext NextContext;
	local int StartingHistoryFrame, ChainEndHistoryFrame;

	History = `XCOMHISTORY;	
	GameRuleset = `TACTICALRULES;

	if( CurrentHistoryFrame < StepForwardStopFrame )
	{
		VisualizationMgr = `XCOMVISUALIZATIONMGR;
		NextGameState = History.GetGameStateFromHistory(CurrentHistoryFrame+1);
		NextContext = NextGameState.GetContext( );
		StartTickIndex = NextGameState.TickAddedToHistory;

		do
		{	
			GameRuleContext = XComGameStateContext_TacticalGameRule(NextGameState.GetContext());
			if( GameRuleContext != None && GameRuleContext.GameRuleType == eGameRule_PlayerTurnBegin )
			{
				GameRuleset.CachedUnitActionPlayerRef = GameRuleContext.PlayerRef; // Update the 'active player'
			}

			NextGameState = History.GetGameStateFromHistory(CurrentHistoryFrame+1);
			NextContext = NextGameState.GetContext( );

			if(!bStepAll && (StartTickIndex != NextGameState.TickAddedToHistory) && bHasVisualizationBlock)
			{
				break;
			}

			StartingHistoryFrame = CurrentHistoryFrame + 1;
			ChainEndHistoryFrame = StartingHistoryFrame;
			
			if (NextContext.InterruptionStatus != eInterruptionStatus_None)
				ChainEndHistoryFrame = NextContext.GetLastStateInInterruptChain().HistoryIndex;

			EventChainLastState = NextContext.GetLastStateInEventChain(true);
			if ((EventChainLastState != none) && (ChainEndHistoryFrame < EventChainLastState.HistoryIndex))
				ChainEndHistoryFrame = EventChainLastState.HistoryIndex;

			// add all the history entries for the interrupt chain to the history
			// this is the set of states that would be the states visualized by calling 
			// BuildVisualizationFrame for CurrentHistoryFrame.  But that would visualize things
			// not added to the history yet which is unexpected and doesn't work for some state types (like environment damage).
			do {
				++CurrentHistoryFrame;
				History.SetCurrentHistoryIndex(CurrentHistoryFrame);	

				HandleGameState(History, NextGameState);

				// Update the VisiblityMgr with the gamestate
				`XWORLD.SyncReplay(NextGameState);
				`XWORLD.UpdateTileDataCache(NextGameState);
				GameRuleset.VisibilityMgr.OnNewGameState(NextGameState);

				NextGameState = History.GetGameStateFromHistory(CurrentHistoryFrame+1);
			}
			until (CurrentHistoryFrame == ChainEndHistoryFrame);

			// Before handling control over the visualizer, reset all the collision that may have been changed by the state submission
			// We only need to call this once for the entire state chain, not for every state in the chain
			`XWORLD.RestoreFrameDestructionCollision( );

			// now visualize all the states in the state chain.
			while (StartingHistoryFrame <= ChainEndHistoryFrame)
			{
				NewlyStartedActions.Length = 0;
				VisualizationMgr.BuildVisualizationFrame(StartingHistoryFrame, NewlyStartedActions, bVisualizationSkip);
				++StartingHistoryFrame;
			}

			VisualizationMgr.CheckStartBuildTree();

			//'Instant' visualization tracks take 2 ticks to execute and remove
			for( SkipTicksIndex = 0; SkipTicksIndex < 2; ++SkipTicksIndex )
			{
				VisualizationMgr.Tick(0.0f);
			}

			bHasVisualizationBlock = class'XComGameStateVisualizationMgr'.static.VisualizerBusy();
		}
		until( CurrentHistoryFrame == StepForwardStopFrame || bSingleStepMode );
	}
}

simulated function HandleGameState(XComGameStateHistory History, XComGameState GameState)
{

// Leaving this debug code until I'm certain the issue I was debugging.
// 
// 	local XComGameState_Unit UnitState;
// 	local XComGameState_AIUnitData AIUnitData;
// 	local int i;
// 	local int Alert;

// 
// 	for (i = 0; i < GameState.GetNumGameStateObjects(); i++)
// 	{
// 		UnitState = XComGameState_Unit(GameState.GetGameStateForObjectIndex(i));
// 		AIUnitData = XComGameState_AIUnitData(GameState.GetGameStateForObjectIndex(i));
// 
// 		if (UnitState != none && UnitState.ControllingPlayerIsAI())
// 		{
// 			AIUnitData = XComGameState_AIUnitData(`XCOMHISTORY.GetGameStateForObjectID(UnitState.GetAIUnitDataID()));
// 			
// 			Alert = UnitState.GetCurrentStat(eStat_AlertLevel);
// 
// 			if (Alert != 0)
// 			{
// 				Alert = Alert; // Debug me
// 			}
// 		}
// 		else if (AIUnitData != none)
// 		{
// 			i = i; // Debug me
// 		}
// 
// 	}

	local int i;
	local XComGameStateContext ContextItr;
	local XComGameStateContext_Ability TempAbilityContext;
	local XComGameState_ChallengeData ChallengeData;


	ContextItr = GameState.GetContext();
	// Grab context ... if first in chain => loop to process all effects in the chain to guarantee proper visualization of chained contexts. TTP: 23932 -ttalley
	if(ContextItr != none)
	{
		if( ContextItr.EventChainStartIndex != 0 )
		{
			// This GameState is part of a chain, which means there may be a stun to the target
			for( i = ContextItr.EventChainStartIndex; ContextItr != None && !ContextItr.bLastEventInChain; ++i )
			{
				ContextItr = History.GetGameStateFromHistory(i).GetContext();
				TempAbilityContext = XComGameStateContext_Ability(ContextItr);
				if( TempAbilityContext != None )
				{
					TempAbilityContext.FillEffectsForReplay();
				}
			}
		}
	}
	GameState.GetContext().OnSubmittedToReplay(GameState);
	if (XComGameStateContext_TacticalGameRule(GameState.GetContext()) != none && XComGameStateContext_TacticalGameRule(GameState.GetContext()).GameRuleType == eGameRule_TacticalGameEnd)
	{
		ChallengeData = XComGameState_ChallengeData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_ChallengeData', true));
		if (ChallengeData != none)
		{
			// Replayed to the end ... don't exit the replay, but let the ruleset clean-up and exit.
			`TACTICALRULES.GotoState('EndTacticalGame');
		}
	}
}



/// <summary>
/// Steps the visualization to the next game state
/// </summary>
simulated event StepReplayAll()
{
	StepReplayForward(true);
}

/// <summary>
/// Steps the visualization to the next game state
/// </summary>
simulated event JumpReplayToFrame(int Frame)
{
	local XComGameStateVisualizationMgr VisualizationMgr;	
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local array<X2Action> NewlyStartedActions;

	History = `XCOMHISTORY;
	VisualizationMgr = `XCOMVISUALIZATIONMGR;

	CurrentHistoryFrame = Frame;
	History.SetCurrentHistoryIndex(CurrentHistoryFrame);
	VisualizationMgr.OnJumpForwardInHistory();
	VisualizationMgr.SetCurrentHistoryFrame(CurrentHistoryFrame);
	VisualizationMgr.BuildVisualizationFrame(CurrentHistoryFrame, NewlyStartedActions, true);
	VisualizationMgr.CheckStartBuildTree();

	// Make sure all units tiles are set to blocked
	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Unit', UnitState, eReturnType_Reference)
	{
		if (!UnitState.bRemovedFromPlay && UnitState.IsAlive() && UnitState.ControllingPlayer.ObjectID > 0 && !UnitState.GetMyTemplate().bIsCosmetic)
		{
			`XWORLD.SetTileBlockedByUnitFlag(UnitState);
		}
	}

	`XWORLD.ForceUpdateAllFOWViewers( );
}

/// <summary>
/// Steps the visualization to the previous game state
/// </summary>
simulated event StepReplayBackward()
{
	local XComGameStateVisualizationMgr VisualizationMgr;	
	local array<X2Action> NewlyStartedActions;

	if( CurrentHistoryFrame > StepBackwardStopFrame )
	{
		VisualizationMgr = `XCOMVISUALIZATIONMGR;

		do
		{
			--CurrentHistoryFrame;
			`XCOMHISTORY.SetCurrentHistoryIndex(CurrentHistoryFrame);
			NewlyStartedActions.Length = 0;
			VisualizationMgr.BuildVisualizationFrame(CurrentHistoryFrame, NewlyStartedActions);
			VisualizationMgr.CheckStartBuildTree();
		}
		until( class'XComGameStateVisualizationMgr'.static.VisualizerBusy() || CurrentHistoryFrame == StepBackwardStopFrame || bSingleStepMode );
	}
}

simulated function ToggleUI()
{
	if (ReplayUI == none)
	{
		// Cache the UIReplay screen so we can update it as we play through
		foreach AllActors(class'UIReplay', ReplayUI)
		{
			break;
		}
	}
	if (ReplayUI != none)
	{
		ReplayUI.ToggleVisible();
		UpdateUIWithFrame(CurrentHistoryFrame);
	}
}

simulated function UpdateUIWithFrame(int Frame)
{
	if (ReplayUI == none)
	{
		// Cache the UIReplay screen so we can update it as we play through
		foreach AllActors(class'UIReplay', ReplayUI)
		{
			break;
		}
	}
	if (ReplayUI != none)
	{
		ReplayUI.UpdateCurrentFrameInfoBox(Frame);
	}
}

defaultproperties
{
}
