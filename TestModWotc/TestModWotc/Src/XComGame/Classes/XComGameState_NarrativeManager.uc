//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_NarrativeManager.uc
//  AUTHOR:  Joe Weinhoffer  --  8/11/2016
//  PURPOSE: This object stores and tracks information related to dynamic narrative moments
//			 and holds the related event triggers
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_NarrativeManager extends XComGameState_BaseObject;

var array<name> Narratives;
var array<name> PlayedThisTurn;
var array<name> PlayedThisMission;
var array<name> PlayedThisGame;

var transient array<XComNarrativeMoment> PendingNarrativeMoments;
var transient array<X2DynamicNarrativeMomentTemplate> PendingNarrativeMomentTemplates;

//---------------------------------------------------------------------------------------
static function SetUpNarrativeManager(XComGameState StartState)
{
	local XComGameState_NarrativeManager NarrativeMgr;
	local X2DynamicNarrativeTemplateManager TemplateMgr;
	local array<X2DynamicNarrativeTemplate> arrAllNarratives;
	local X2DynamicNarrativeTemplate Narrative;
	local X2DynamicNarrativeMomentTemplate MomentTemplate;
	local X2CardManager CardManager;
	local int Index;
		
	// Create the Narrative Manager state object
	NarrativeMgr = XComGameState_NarrativeManager(StartState.CreateNewStateObject(class'XComGameState_NarrativeManager'));

	CardManager = class'X2CardManager'.static.GetCardManager();

	// Save dynamic narrative names and set up narrative decks for the moments
	NarrativeMgr.Narratives.Length = 0;
	TemplateMgr = class'X2DynamicNarrativeTemplateManager'.static.GetDynamicNarrativeTemplateManager();
	arrAllNarratives = TemplateMgr.GetAllTemplatesOfClass(class'X2DynamicNarrativeMomentTemplate');
	foreach arrAllNarratives(Narrative)
	{
		MomentTemplate = X2DynamicNarrativeMomentTemplate(Narrative);
		NarrativeMgr.Narratives.AddItem(MomentTemplate.DataName);
		
		if (MomentTemplate.DynamicMoments.Length > 1)
		{
			if (MomentTemplate.NarrativeDeck != '')
			{
				for (Index = 0; Index < MomentTemplate.DynamicMoments.Length; ++Index)
				{
					CardManager.AddCardToDeck(MomentTemplate.NarrativeDeck, PathName(MomentTemplate.DynamicMoments[Index].NarrativeMoment));
				}
			}
			else
			{
				`RedScreen("@jweinhoffer DynamicNarrativeMomentTemplate " @ MomentTemplate.DataName @ "has multiple narratives but no deck name.");
			}
		}
	}
}

//---------------------------------------------------------------------------------------
function GetNarrativeEventNames(out array<Name> StandardNarrativeEvents, out array<Name> SequencedNarrativeEvents)
{
	local X2DynamicNarrativeMomentTemplate NarrativeTemplate;
	local X2DynamicNarrativeTemplateManager TemplateMgr;
	local Name NarrativeName;

	TemplateMgr = class'X2DynamicNarrativeTemplateManager'.static.GetDynamicNarrativeTemplateManager();

	foreach Narratives(NarrativeName)
	{
		NarrativeTemplate = X2DynamicNarrativeMomentTemplate(TemplateMgr.FindDynamicNarrativeTemplate(NarrativeName));

		if( NarrativeTemplate != none && NarrativeTemplate.EventTrigger != '' )
		{
			if( !NarrativeTemplate.bSequencedNarrative && StandardNarrativeEvents.Find(NarrativeTemplate.EventTrigger) == INDEX_NONE )
			{
				StandardNarrativeEvents.AddItem(NarrativeTemplate.EventTrigger);
			}

			if( NarrativeTemplate.bSequencedNarrative && SequencedNarrativeEvents.Find(NarrativeTemplate.EventTrigger) == INDEX_NONE )
			{
				SequencedNarrativeEvents.AddItem(NarrativeTemplate.EventTrigger);
			}
		}
	}
}

//---------------------------------------------------------------------------------------
function OnBeginTacticalPlay(XComGameState NewGameState)
{
	local X2EventManager EventManager;
	local Object ThisObj;
	local array<Name> StandardNarrativeEvents, SequencedNarrativeEvents;
	local Name NarrativeEvent;
		
	super.OnBeginTacticalPlay(NewGameState);

	EventManager = `XEVENTMGR;
	ThisObj = self;

	GetNarrativeEventNames(StandardNarrativeEvents, SequencedNarrativeEvents);

	foreach StandardNarrativeEvents(NarrativeEvent)
	{
		EventManager.RegisterForEvent(ThisObj, NarrativeEvent, OnNarrativeEventTriggered, ELD_OnStateSubmitted);
	}

	foreach SequencedNarrativeEvents(NarrativeEvent)
	{
		EventManager.RegisterForEvent(ThisObj, NarrativeEvent, OnNarrativeEventTriggered_Immediate, ELD_Immediate);
	}

	EventManager.RegisterForEvent(ThisObj, 'PlayerTurnBegun', OnBeginXCOMTurn, ELD_OnStateSubmitted);
}

//---------------------------------------------------------------------------------------
function OnEndTacticalPlay(XComGameState NewGameState)
{
	local X2EventManager EventManager;
	local Object ThisObj;
	local array<Name> StandardNarrativeEvents, SequencedNarrativeEvents;
	local Name NarrativeEvent;

	super.OnEndTacticalPlay(NewGameState);

	EventManager = `XEVENTMGR;
	ThisObj = self;

	GetNarrativeEventNames(StandardNarrativeEvents, SequencedNarrativeEvents);

	foreach StandardNarrativeEvents(NarrativeEvent)
	{
		EventManager.UnRegisterFromEvent(ThisObj, NarrativeEvent, ELD_OnStateSubmitted);
	}

	foreach SequencedNarrativeEvents(NarrativeEvent)
	{
		EventManager.UnRegisterFromEvent(ThisObj, NarrativeEvent, ELD_Immediate);
	}
	
	EventManager.UnRegisterFromEvent(ThisObj, 'PlayerTurnBegun', ELD_OnStateSubmitted);

	// Reset mission state variables
	PlayedThisTurn.Length = 0;
	PlayedThisMission.Length = 0;
}

//---------------------------------------------------------------------------------------
function EventListenerReturn OnNarrativeEventTriggered(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	TriggerDynamicNarrative(EventData, EventSource, GameState, EventID, false);

	return ELR_NoInterrupt;
}

function EventListenerReturn OnNarrativeEventTriggered_Immediate(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	TriggerDynamicNarrative(EventData, EventSource, GameState, EventID, true);

	return ELR_NoInterrupt;
}

function EventListenerReturn OnBeginXCOMTurn(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Player PlayerState;

	PlayerState = XComGameState_Player(EventSource);
	if (PlayerState != none && PlayerState.TeamFlag == eTeam_XCom)
	{
		PlayedThisTurn.Length = 0; // Reset the played this turn moments
	}

	return ELR_NoInterrupt;
}

//---------------------------------------------------------------------------------------
function TriggerDynamicNarrative(Object EventData, Object EventSource, XComGameState GameState, Name EventID, bool bImmediate)
{
	local XComGameState NewGameState;
	local XComGameState_NarrativeManager NarrativeMgr;
	local X2DynamicNarrativeMomentTemplate Narrative;
	local array<X2DynamicNarrativeMomentTemplate> ValidMoments, PriorityMoments;
	local XComNarrativeMoment MomentToPlay;
	local name NarrativeName, SequenceID;

	if( GameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt )
	{
		return;
	}
		
	ValidMoments = FindValidNarrativeMoments(EventData, EventSource, GameState, EventID, bImmediate);	
	if (ValidMoments.Length > 0)
	{
		PriorityMoments = GetPrioritizedMoments(ValidMoments, bImmediate);

		foreach PriorityMoments(Narrative)
		{	
			if (bImmediate)
			{
				NewGameState = GameState;
			}
			else
			{
				NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger Dynamic Narrative Moment");
				XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = BuildVisualizationForDynamicNarrative_Callback;

				NewGameState.GetContext().SetAssociatedPlayTiming(Narrative.NarrativePlayTiming);
			}
									
			// Save narratives which only play once per game
			NarrativeMgr = XComGameState_NarrativeManager(NewGameState.ModifyStateObject(class'XComGameState_NarrativeManager', ObjectID));
			if( NarrativeMgr.PlayedThisGame.Find(Narrative.DataName) == INDEX_NONE )
			{
				NarrativeMgr.PlayedThisGame.AddItem(Narrative.DataName);

				// Add any exclusive moments so they don't trigger later
				foreach Narrative.OncePerGameExclusiveMoments(NarrativeName)
				{
					if( NarrativeMgr.PlayedThisGame.Find(NarrativeName) == INDEX_NONE )
					{
						NarrativeMgr.PlayedThisGame.AddItem(NarrativeName);
					}
				}
			}
			
			if( NarrativeMgr.PlayedThisMission.Find(Narrative.DataName) == INDEX_NONE ) // Save narratives which only play once per mission
			{
				NarrativeMgr.PlayedThisMission.AddItem(Narrative.DataName);
			}

			if (NarrativeMgr.PlayedThisTurn.Find(Narrative.DataName) == INDEX_NONE) // Save narratives which only play once per turn
			{
				NarrativeMgr.PlayedThisTurn.AddItem(Narrative.DataName);
			}

			// Get the actual narrative moment to play and store it, along with the dynamic narrative template
			MomentToPlay = GetNarrativeMomentToPlay(Narrative, EventData, EventSource, GameState, SequenceID);
			NarrativeMgr.PendingNarrativeMoments.AddItem(MomentToPlay);
			NarrativeMgr.PendingNarrativeMomentTemplates.AddItem(Narrative);
			
			if (!bImmediate)
			{
				`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
			}
		}
	}
}

function array<X2DynamicNarrativeMomentTemplate> FindValidNarrativeMoments(Object EventData, Object EventSource, XComGameState GameState, Name EventID, bool bImmediate)
{
	local X2DynamicNarrativeTemplateManager TemplateMgr;
	local array<X2DynamicNarrativeMomentTemplate> ValidMoments;
	local X2DynamicNarrativeMomentTemplate Narrative;
	local name NarrativeName;
	
	TemplateMgr = class'X2DynamicNarrativeTemplateManager'.static.GetDynamicNarrativeTemplateManager();
	ValidMoments.Length = 0;

	foreach Narratives(NarrativeName)
	{
		Narrative = X2DynamicNarrativeMomentTemplate(TemplateMgr.FindDynamicNarrativeTemplate(NarrativeName));

		// First check to make sure the narrative moment event trigger matches
		if (Narrative != none && Narrative.EventTrigger == EventID && Narrative.bSequencedNarrative == bImmediate)
		{
			// Then check if the narrative is marked as playing only once per game, and ensure it has not been played
			if (!Narrative.bOncePerGame || PlayedThisGame.Find(Narrative.DataName) == INDEX_NONE)
			{
				// Then check if the narrative is marked as playing only once per mission, and ensure it has not been played
				if (!Narrative.bOncePerMission || PlayedThisMission.Find(Narrative.DataName) == INDEX_NONE)
				{
					// Then check if the narrative is marked as playing only once per turn, and ensure it has not been played
					if (!Narrative.bOncePerTurn || PlayedThisTurn.Find(Narrative.DataName) == INDEX_NONE)
					{
						// Then check all of the moment's conditions to make sure they are satisfied
						if (Narrative.CanTriggerNarrative(EventData, EventSource, GameState))
						{
							ValidMoments.AddItem(Narrative);
						}
					}
				}
			}
		}
	}

	return ValidMoments;
}

function array<X2DynamicNarrativeMomentTemplate> GetPrioritizedMoments(array<X2DynamicNarrativeMomentTemplate> ValidMoments, bool bImmediate)
{
	local array<X2DynamicNarrativeMomentTemplate> PriorityMoments;
	local X2DynamicNarrativeMomentTemplate Moment;
	local array<name> SequenceTags;
	local bool bHighestPriorityPlayingAfterVisualization, bOppositeVisualizationMomentAdded;
	local int Priority;
	
	PriorityMoments.Length = 0;
	
	// Sort the moments by their priority, and then save the highest one
	ValidMoments.Sort(SortMomentsByPriority);
	Priority = ValidMoments[0].Priority;
	bHighestPriorityPlayingAfterVisualization = ValidMoments[0].PlayAfterVisualization();
	
	foreach ValidMoments(Moment)
	{
		if (Moment.bIgnorePriority) // If a moment ignores priority, always add it to play
		{
			PriorityMoments.AddItem(Moment);
		}
		else if (bImmediate && SequenceTags.Find(Moment.SequencedEventTag) == INDEX_NONE)
		{
			// If a moment has a different sequence tag and hasn't been added to the priority list yet,
			// it is the highest priority moment with that tag since we sorted, so add it to the list
			SequenceTags.AddItem(Moment.SequencedEventTag);
			PriorityMoments.AddItem(Moment);
		}
		else if (!bImmediate && Moment.PlayAfterVisualization() != bHighestPriorityPlayingAfterVisualization && !bOppositeVisualizationMomentAdded)
		{
			// If a non-immediate moment is flagged to play at a different time (pre or post visualization)
			// than the highest priority moment, add it since it it also viable and highest priority for its group
			PriorityMoments.AddItem(Moment);
			bOppositeVisualizationMomentAdded = true;
		}
		else if (Moment.Priority == Priority && PriorityMoments.Length == 0)
		{
			// Otherwise add the moment with the highest priority if one hasn't been selected yet
			PriorityMoments.AddItem(Moment);
		}
	}

	return PriorityMoments;
}

function int SortMomentsByPriority(X2DynamicNarrativeMomentTemplate MomentA, X2DynamicNarrativeMomentTemplate MomentB)
{
	if (MomentA.Priority < MomentB.Priority)
	{
		return 1;
	}
	else if (MomentA.Priority > MomentB.Priority)
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

function XComNarrativeMoment GetNarrativeMomentToPlay(X2DynamicNarrativeMomentTemplate Narrative, Object EventData, Object EventSource, XComGameState GameState, out name SequenceID)
{
	local X2CardManager CardManager;
	local DynamicNarrativeMoment DynamicMoment;
	local XComNarrativeMoment MomentToPlay;
	local string SelectedNarrativeMomentPath;

	// If there is only one possible narrative moment to play, select it
	if (Narrative.DynamicMoments.Length == 1)
	{
		return Narrative.DynamicMoments[0].NarrativeMoment;
	}
	
	// If a specific ID was passed in, search for a moment in the deck which matches that ID
	if (SequenceID != '')
	{
		foreach Narrative.DynamicMoments(DynamicMoment)
		{
			if (DynamicMoment.SequenceID == SequenceID)
			{
				return DynamicMoment.NarrativeMoment;
			}
		}
	}
	
	// Otherwise, a narrative deck should exist for this moment, so pull a card from it	
	CardManager = class'X2CardManager'.static.GetCardManager();
	CardManager.SelectNextCardFromDeck(Narrative.NarrativeDeck, SelectedNarrativeMomentPath);

	foreach Narrative.DynamicMoments(DynamicMoment)
	{
		if (PathName(DynamicMoment.NarrativeMoment) == SelectedNarrativeMomentPath)
		{
			// Find the best moment to play from the group the moment we pulled from the deck belongs to
			MomentToPlay =  GetBestMomentFromNarrativeGroup(DynamicMoment, Narrative, EventData, EventSource, GameState);

			// Save the SequenceID of the selected Moment, so any additional events will trigger moments from the same sequence
			SequenceID = DynamicMoment.SequenceID;
			
			return MomentToPlay;
		}
	}

	// If no moment was found in the X2DynamicNarrativeMomentTemplate, return the one pulled from the deck
	return XComNarrativeMoment(DynamicLoadObject(SelectedNarrativeMomentPath, class'XComNarrativeMoment'));
}

function XComNarrativeMoment GetBestMomentFromNarrativeGroup(DynamicNarrativeMoment DynamicMoment, X2DynamicNarrativeMomentTemplate Narrative, Object EventData, Object EventSource, XComGameState GameState)
{
	local X2DynamicNarrativeTemplateManager TemplateMgr;
	local X2CardManager CardManager;
	local X2DynamicNarrativeConditionTemplate ConditionTemplate;
	local XComNarrativeMoment MomentToPlay;
	local bool bConditionNotMet;
	local int Index;

	TemplateMgr = class'X2DynamicNarrativeTemplateManager'.static.GetDynamicNarrativeTemplateManager();
	MomentToPlay = DynamicMoment.NarrativeMoment; // By default, use the narrative associated with the original moment

	// If the selected moment has a condition attached to it, check if it is satisfied
	if (DynamicMoment.MomentCondition != '')
	{
		// If the condition isn't met, shouldn't play this moment
		ConditionTemplate = X2DynamicNarrativeConditionTemplate(TemplateMgr.FindDynamicNarrativeTemplate(DynamicMoment.MomentCondition));
		if (ConditionTemplate == none || !ConditionTemplate.IsConditionMet(EventData, EventSource, GameState))
		{			
			bConditionNotMet = true; // Set flag to find a replacement DynamicMoment which satisfies its condition
		}
	}

	if (DynamicMoment.ExclusionGroup != '')
	{
		CardManager = class'X2CardManager'.static.GetCardManager();

		// If a group is specified for this moment, find all other moments which share the group
		for (Index = 0; Index < Narrative.DynamicMoments.Length; ++Index)
		{
			if (Narrative.DynamicMoments[Index].NarrativeMoment != DynamicMoment.NarrativeMoment && Narrative.DynamicMoments[Index].ExclusionGroup == DynamicMoment.ExclusionGroup)
			{
				// Mark the all moments in the group as used, so we don't hear repeated lines back-to-back
				CardManager.MarkCardUsed(Narrative.NarrativeDeck, PathName(Narrative.DynamicMoments[Index].NarrativeMoment));

				// If a moment from the group which meets the condition has not been found, check this one
				if (bConditionNotMet)
				{
					ConditionTemplate = X2DynamicNarrativeConditionTemplate(TemplateMgr.FindDynamicNarrativeTemplate(Narrative.DynamicMoments[Index].MomentCondition));
					if (ConditionTemplate != none && ConditionTemplate.IsConditionMet(EventData, EventSource, GameState))
					{
						// A moment which satisfies the condition is found, so set it as the moment to play
						bConditionNotMet = false;
						MomentToPlay = Narrative.DynamicMoments[Index].NarrativeMoment;
					}
				}
			}
		}
	}

	return MomentToPlay;
}

static function BuildVisualizationForDynamicNarrative_Callback(XComGameState VisualizeGameState)
{
	BuildVisualizationForDynamicNarrative(VisualizeGameState);
}

static function BuildVisualizationForDynamicNarrative(XComGameState VisualizeGameState, optional bool bWaitForCompletion, optional Name SpecificTemplateName, optional X2Action ParentAction)
{
	local VisualizationActionMetadata ActionMetadata, AnimActionMetadata;
	local X2Action_PlayNarrative NarrativeAction;
	local X2Action_PlayAnimationOnMatineePawn PlayAnimAction;
	local XComGameState_NarrativeManager NarrativeManager;
	local int i, BlendType;
	local X2DynamicNarrativeMomentTemplate NarrativeTemplate;
	local XComNarrativeMoment NarrativeMoment;
	local XComGameState_Unit UnitState;
	local XComGameStateContext VisualizeGameStateContext;

	VisualizeGameStateContext = VisualizeGameState.GetContext();

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_NarrativeManager', NarrativeManager)
	{
		for (i = 0; i < NarrativeManager.PendingNarrativeMoments.Length; i++)
		{
			NarrativeMoment = NarrativeManager.PendingNarrativeMoments[i];
			NarrativeTemplate = NarrativeManager.PendingNarrativeMomentTemplates[i];
			if( SpecificTemplateName == '' || NarrativeTemplate.SequencedEventTag == SpecificTemplateName )
			{
				NarrativeAction = X2Action_PlayNarrative(class'X2Action_PlayNarrative'.static.CreateVisualizationAction(VisualizeGameStateContext));
				NarrativeAction.Moment = NarrativeMoment;
				NarrativeAction.WaitForCompletion = bWaitForCompletion;

				if (NarrativeTemplate.SequencedEventTrigger != '')
				{
					NarrativeAction.ClearInputEvents();
					NarrativeAction.AddInputEvent(NarrativeTemplate.SequencedEventTrigger);
					NarrativeAction.RequiredMatineeNames = NarrativeTemplate.MatineeNames;
				}

				class'X2Action'.static.AddActionToVisualizationTree(NarrativeAction, ActionMetadata, VisualizeGameStateContext, false, ParentAction);

				ActionMetadata.StateObject_OldState = NarrativeManager;
				ActionMetadata.StateObject_NewState = NarrativeManager;

				if( NarrativeMoment.SpeakerAnimationName != '' && NarrativeMoment.SpeakerTemplateGroupName != '' )
				{
					// find the speaker to play the anim on
					foreach VisualizeGameState.IterateByClassType(class'XComGameState_Unit', UnitState)
					{
						if( UnitState.GetMyTemplateGroupName() == NarrativeMoment.SpeakerTemplateGroupName )
						{
							AnimActionMetadata.StateObject_OldState = UnitState;
							AnimActionMetadata.StateObject_NewState = UnitState;
							AnimActionMetadata.VisualizeActor = UnitState.GetVisualizer();

							PlayAnimAction = X2Action_PlayAnimationOnMatineePawn(class'X2Action_PlayAnimationOnMatineePawn'.static.CreateVisualizationAction(VisualizeGameStateContext));
							PlayAnimAction.Params.AnimName = NarrativeMoment.SpeakerAnimationName;
							BlendType = NarrativeMoment.SpeakerAnimationBlendType;
							PlayAnimAction.BlendType = BlendMaskIndex(BlendType);

							if (NarrativeTemplate.SequencedEventTrigger != '')
							{
								PlayAnimAction.ClearInputEvents();								
								PlayAnimAction.AddInputEvent(NarrativeTemplate.SequencedEventTrigger);
								PlayAnimAction.RequiredMatineeNames = NarrativeTemplate.MatineeNames;
							}

							class'X2Action'.static.AddActionToVisualizationTree(PlayAnimAction, AnimActionMetadata, VisualizeGameStateContext, false, ParentAction);
						}
					}
				}
			}
		}
	}
}
