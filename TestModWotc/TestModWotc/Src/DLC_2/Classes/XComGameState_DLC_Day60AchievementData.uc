//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_DLC_Day60AchievementData.uc
//  AUTHOR:  Joe Weinhoffer - 04/13/2016
//  PURPOSE: Game state for tracking achievements whose conditions have to be
//           met in the same game, which needs to be preserved during save / load.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class XComGameState_DLC_Day60AchievementData extends XComGameState_BaseObject;

// Stored for achievement: AT_UseAllRulerArmorAbilities
var array<name> arrActivatedRulerArmorAbilities;