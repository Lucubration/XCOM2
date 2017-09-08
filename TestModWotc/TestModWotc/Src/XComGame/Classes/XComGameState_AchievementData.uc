//---------------------------------------------------------------------------------------
//  FILE:    X2AchievementData.uc
//  AUTHOR:  Aaron Smith -- 8/14/2015
//  PURPOSE: Game state for tracking achievements whose conditions have to be
//           met in the same game, which needs to be preserved during save / load.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class XComGameState_AchievementData extends XComGameState_BaseObject 
	native(Core);
	
// Stored for achievement: AT_TripleKill	
struct native UnitKills
{	var int		UnitId;
	var int		NumKills;
};
var array<UnitKills> arrKillsPerUnitThisTurn;

// Stored for achievement: AT_Ambush
var array<int> arrUnitsKilledThisTurn;
var array<int> arrRevealedUnitsThisTurn;	

// Stored for achievement: AT_RecoverCodexBrain
var bool bKilledACyberusThisMission;

// Stored for achievement: AT_CompleteMissionTiredSoldiers
var bool bAllTiredSoldierSquad;

// Stored for achievement: AT_TemplarFocusCycle
struct native FocusCycle
{
	var int UnitID;
	var bool bReachedMaxFocus; // Step 1: Reach maximum Focus
	var bool bSpentAllFocus; // Step 2: Spend all of it
};
var array<FocusCycle> arrTemplarFocusCyclesThisMission;

// Stored for achievement: AT_ReaperShadowKills
var array<UnitKills> arrReaperShadowKillsThisMission;

// Stored for achievement: AT_LostHeadshots;
var int iLostKillsThisTurn;
