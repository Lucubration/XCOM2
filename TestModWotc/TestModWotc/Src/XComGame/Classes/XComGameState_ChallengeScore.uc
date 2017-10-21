//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_ChallengeScore.uc
//  AUTHOR:  Timothy Talley  --  05/16/2017
//  PURPOSE: Intended to possibly have multiple objects in a context object
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_ChallengeScore extends XComGameState_BaseObject
	dependson(X2ChallengeModeDataStructures)
	native(Challenge)
	config(GameData);

var ChallengeModePointType ScoringType;
var int AddedPoints;

static native function int AddTacticalGameEnd(int CumulativePoints);
static native function int AddKillMail(XComGameState_Unit SourceUnit, XComGameState_Unit KilledUnit, XComGameState GameState);
static native function int AddMissionObjectiveComplete();
static native function int AddCivilianRescued(XComGameState_Unit SourceUnit, XComGameState_Unit RescuedUnit);
static native function int AddIndividualMissionObjectiveComplete(SeqAct_DisplayMissionObjective SA_DisplayMissionObj);

static native function int GetIndividualMissionObjectiveCompletedValue(SeqAct_DisplayMissionObjective SA_DisplayMissionObj);

native function bool Validate(XComGameState HistoryGameState, INT GameStateIndex) const;
native protected function SubmitGameState(XComGameState NewGameState);
