//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    X2Effect_Shattered.uc    
//  AUTHOR:  David Burchanowski  --  10/3/2016
//  PURPOSE: Panic Effects - Remove control from player and run Panic behavior tree.
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2Effect_Shattered extends X2Effect_Panicked
	config(GameCore);

var Name ShatteredTargetValueName;

function int GetShatteredTargetID(int SourceUnitID)
{
	local XComGameState_Unit UnitState;
	local XComGameStateHistory History;
	local int ShatteredTargetID;
	local UnitValue ShatteredValue;
	History = `XCOMHISTORY;
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(SourceUnitID));
	ShatteredTargetID = GetPanicSourceID(SourceUnitID, EffectName);
	if (ShatteredTargetID <= 0 || ShatteredTargetID == SourceUnitID)
	{
		// Try to pull from the unit value set by the AI.
		if (UnitState.GetUnitValue(ShatteredTargetValueName, ShatteredValue))
		{
			ShatteredTargetID = ShatteredValue.fValue;
		}
	}
	return ShatteredTargetID;
}
//•	Shattered
//	o	Same [as Obsessed]. Shattered units should continue to run away from their target. They should never spend a turn in one location.
//	o	If the unit that triggered the shatter dies, then the shattered status should be removed.

function bool TickPanicShattered(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication)
{
	local XComGameState_Unit UnitState;
	local Name PanicBehaviorTree;
	local int Point;

	// If our effect is set to expire this turn, don't run the BT.
	if (!FirstApplication && kNewEffectState.iTurnsRemaining == 0 && WatchRule == eGameRule_PlayerTurnBegin)
		return false;

	UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	if (UnitState.GetTeam() == eTeam_XCom)
	{
		PanicBehaviorTree = Name(BehaviorTreeRoot);

		// Must add action points for the behavior tree run to work.
		for (Point = 0; Point < ActionPoints; ++Point)
		{
			if (Point < UnitState.ActionPoints.Length)
			{
				if (UnitState.ActionPoints[Point] != class'X2CharacterTemplateManager'.default.StandardActionPoint)
				{
					UnitState.ActionPoints[Point] = class'X2CharacterTemplateManager'.default.StandardActionPoint;
				}
			}
			else
			{
				UnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
			}
		}

		// Delayed behavior tree kick-off.  Points must be added and game state submitted before the behavior tree can 
		// update, since it requires the ability cache to be refreshed with the new action points.
		UnitState.AutoRunBehaviorTree(PanicBehaviorTree, BTRunCount, `XCOMHISTORY.GetCurrentHistoryIndex() + 1, true);
	}

	return false;
}

defaultproperties
{
	EffectTickedFn = TickPanicShattered
	ShatteredTargetValueName="ShatteredTarget"
}