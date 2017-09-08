//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    X2DynamicNarrativeMomentTemplate.uc
//  AUTHOR:  Joe Weinhoffer  --  8/11/2016
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 
class X2DynamicNarrativeMomentTemplate extends X2DynamicNarrativeTemplate
	dependson(X2StrategyGameRulesetDataStructures);

var name										EventTrigger;
var name										NarrativeDeck;
var array<name>									Conditions;
var bool										bOncePerGame;
var array<name>									OncePerGameExclusiveMoments; // Only used for moments marked Once Per Game. If one is triggered, all in the list are marked as played.
var bool										bOncePerMission;
var bool										bOncePerTurn;
//var bool										bPlayAfterVisualization; // Will begin playing after the main visualization block finishes
var int											Priority;
var bool										bIgnorePriority; // If true, this moment will play along with any other moments which have the same priority when triggered
var array<DynamicNarrativeMoment>				DynamicMoments;
var bool										bSequencedNarrative;  // if true, this narrative moment will play during the visualization sequence for the gamestate the event triggers during the execution of X2Action_PlayNarrative
var name										SequencedEventTag;  // if this is a sequenced narrative, this tag can be used to specify where in the sequencing of the visualization this NM should be played
var name										SequencedEventTrigger;  // if this is a sequenced narrative, this event trigger will be used as the input event for the narrative action(s)
var array<string>								MatineeNames; // if this line should only play as part of a specific matinee sequence
var localized string							ChosenEndOfMissionQuote; // if specified, this NM can be displayed at the end of a mission in which it was played


var SequencePlayTiming NarrativePlayTiming;

//---------------------------------------------------------------------------------------
// All conditions to play this narrative are met
function bool CanTriggerNarrative(Object EventData, Object EventSource, XComGameState GameState)
{
	local X2DynamicNarrativeTemplateManager NarrativeMgr;
	local X2DynamicNarrativeConditionTemplate ConditionTemplate;
	local int idx;

	NarrativeMgr = GetMyTemplateManager();

	for (idx = 0; idx < Conditions.Length; idx++)
	{
		ConditionTemplate = X2DynamicNarrativeConditionTemplate(NarrativeMgr.FindDynamicNarrativeTemplate(Conditions[idx]));

		// if one condition isn't met, can't perform the action
		if (ConditionTemplate == none || !ConditionTemplate.IsConditionMet(EventData, EventSource, GameState))
		{
			return false;
		}
	}

	// all conditions are met
	return true;
}

function AddDynamicMoment(XComNarrativeMoment NewNarrativeMoment, optional Name ConditionName, optional Name ExclusionGroup, optional Name SequenceID)
{
	local DynamicNarrativeMoment Moment;
	
	Moment.NarrativeMoment = NewNarrativeMoment;
	Moment.MomentCondition = ConditionName;
	Moment.ExclusionGroup = ExclusionGroup;
	Moment.SequenceID = SequenceID;

	DynamicMoments.AddItem(Moment);
}

function bool PlayAfterVisualization()
{
	return NarrativePlayTiming == SPT_AfterParallel || NarrativePlayTiming == SPT_AfterSequential;
}

//---------------------------------------------------------------------------------------
DefaultProperties
{
	NarrativePlayTiming = SPT_AfterParallel
}