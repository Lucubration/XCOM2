//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    X2Effect_Obsessed.uc    
//  AUTHOR:  David Burchanowski  --  10/3/2016
//  PURPOSE: Panic Effects - Remove control from player and run Panic behavior tree.
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2Effect_Obsessed extends X2Effect_Panicked
	config(GameCore);

var Name ObsessedTargetValueName;

function int GetObsessedTargetID( int SourceUnitID )
{
	local XComGameState_Unit UnitState;
	local XComGameStateHistory History;
	local int ObsessedTargetID;
	local UnitValue ObsessedValue;
	History = `XCOMHISTORY;
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(SourceUnitID));
	ObsessedTargetID = GetPanicSourceID(SourceUnitID, EffectName);
	if (ObsessedTargetID <= 0 || ObsessedTargetID == SourceUnitID)
	{
		// Try to pull from the unit value set by the AI.
		if (UnitState.GetUnitValue(ObsessedTargetValueName, ObsessedValue))
		{
			ObsessedTargetID = ObsessedValue.fValue;
		}
	}
	return ObsessedTargetID;
}

//•	Obsessed
//	o	Obsessed units should always spend their turn attacking a target.  If a unit gets the obsessed mental state, 
//		they should run towards the unit and attack.ON the next turn, if that unit is still alive, the obsessed unit 
//		should continue to move and attack.Obsessed units should never stay in one location.
//	o	If the unit that triggered the obsession is killed(by anyone), then the obsession should be immediately removed.
function bool TickPanicObsessed(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication)
{
	local XComGameState_Unit UnitState;
	local XComGameState_Unit TargetUnit;
	local Name PanicBehaviorTree;
	local int ObsessedTargetID;
	local XComGameStateHistory History;
	local int Point;

	// If our effect is set to expire this turn, don't run the BT.
	if (!FirstApplication && kNewEffectState.iTurnsRemaining == 0 && WatchRule == eGameRule_PlayerTurnBegin)
		return false;

	History = `XCOMHISTORY;
	UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	ObsessedTargetID = GetObsessedTargetID(UnitState.ObjectID);
	TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(ObsessedTargetID));

	if (TargetUnit != None && TargetUnit.IsAbleToAct() && UnitState.GetTeam() == eTeam_XCom)
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
	else
	{
		return true; // End this effect if the target is dead.
	}

	return false;
}

defaultproperties
{
	EffectTickedFn = TickPanicObsessed
	ObsessedTargetValueName = "ObsessedTarget"
}