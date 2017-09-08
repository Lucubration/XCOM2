//---------------------------------------------------------------------------------------
//  FILE:    X2Condition_Bondmate.uc
//  AUTHOR:  Dan Kaplan
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2Condition_BondmateAggro extends X2Condition_Bondmate
	config(GameData_SoldierSkills)
	native(Core);

// only if the two units are bondmates, and within bond range
native function name MeetsCondition(XComGameState_BaseObject kTarget);
native function name MeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource);

