//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_DLC_Day90AchievementData.uc
//  AUTHOR:  Joe Weinhoffer - 05/09/2016
//  PURPOSE: Game state for tracking achievements whose conditions have to be
//           met in the same game, which needs to be preserved during save / load.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class XComGameState_DLC_Day90AchievementData extends XComGameState_BaseObject;

// Stored for achievement: AT_HitThreeOverdriveShots
struct native OverdriveShots
{
	var int		UnitId;
	var int		NumShots;
};
var array<OverdriveShots> arrOverdriveShotsThisTurn;

// Stored for achievement: AT_BeatMissionHalfHealthSpark
var array<StateObjectReference> arrSparksHalfHealth;