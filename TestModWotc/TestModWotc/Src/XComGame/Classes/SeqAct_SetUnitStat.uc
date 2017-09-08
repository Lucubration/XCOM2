//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_SetUnitStat.uc
//  AUTHOR:  James Brawley -- 3/2/2017
//  PURPOSE: Directly modify a units stat.  Implemented to support Compound Rescue and modifying
//           the detection radius of enemy units.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_SetUnitStat extends SequenceAction
	implements(X2KismetSeqOpVisualizer);

var XComGameState_Unit Unit;
var() int NewValue;
var() ECharStatType StatToModify;

function Activated();
function BuildVisualization(XComGameState GameState);

function ModifyKismetGameState(out XComGameState GameState)
{
	local SeqVar_GameStateList List;
	local StateObjectReference UnitRef;
	local XComGameState_Unit UnitState;
	local bool bUnitsFound;

	bUnitsFound = false;

	if(Unit != none)
	{
		UnitState = XComGameState_Unit(GameState.ModifyStateObject(class'XComGameState_Unit', Unit.ObjectID));

		UnitState.SetBaseMaxStat(StatToModify, NewValue);
		UnitState.SetCurrentStat(StatToModify, NewValue);

		bUnitsFound = true;
	}

	foreach LinkedVariables(class'SeqVar_GameStateList', List, "Unit List")
	{
		foreach List.GameStates( UnitRef )
		{
			UnitState = XComGameState_Unit( GameState.ModifyStateObject( class'XComGameState_Unit', UnitRef.ObjectID ) );

			UnitState.SetBaseMaxStat(StatToModify, NewValue);
			UnitState.SetCurrentStat(StatToModify, NewValue);

			bUnitsFound = true;
		}
	}

	if(!bUnitsFound)
	{
		`Redscreen("SeqAct_SetUnitStat: Could not find a unit to alter, check for proper usage.");
	}
}

defaultproperties
{
	ObjCategory="Unit"
	ObjName="Set Unit Stat"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	InputLinks(0)=(LinkDesc="In")
	
	bAutoActivateOutputLinks=true

	VariableLinks(0)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="Single Unit",PropertyName=Unit)
	VariableLinks(1)=(ExpectedType=class'SeqVar_GameStateList',LinkDesc="Unit List")
	VariableLinks(2)=(ExpectedType=class'SeqVar_Int',LinkDesc="NewValue",PropertyName=NewValue)
}
