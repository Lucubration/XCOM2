//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Effect_RunBehaviorTree extends X2Effect_Persistent;

var int NumActions;
var name BehaviorTreeName;
var bool bInitFromPlayer; // True to reset more behavior tree vars on each run as if it is the start of the player turn. BTVars & ErrorChecking.
var int SetActionPointCount;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit UnitState;
	local int Point;

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

	UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ApplyEffectParameters.TargetStateObjectRef.ObjectID));	

	//If this is a War of the Chosen enemy, give some action points to run the behavior tree. Everyone else must use the ones they have already - fixes issues with
	//regular enemies sometimes gaining extra moves.
	if (UnitState.GetTeam() == eTeam_TheLost || UnitState.IsChosen())
	{
	for (Point = 0; Point < SetActionPointCount; ++Point)
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
	}

	// Kick off the behavior tree.
	// Delayed behavior tree kick-off.  Points must be added and game state submitted before the behavior tree can 
	// update, since it requires the ability cache to be refreshed with the new action points.
	UnitState.AutoRunBehaviorTree(BehaviorTreeName, NumActions, `XCOMHISTORY.GetCurrentHistoryIndex() + 1, false, bInitFromPlayer, true);

	// Mark the last event chain history index when the behavior tree was kicked off, 
	// to prevent multiple BTs from kicking off from a single event chain.
	UnitState.SetUnitFloatValue('LastChainIndexBTStart', `XCOMHISTORY.GetEventChainStartIndex(), eCleanup_BeginTurn);
}

defaultproperties
{
	NumActions=1
	bInitFromPlayer = false
	SetActionPointCount=1
}