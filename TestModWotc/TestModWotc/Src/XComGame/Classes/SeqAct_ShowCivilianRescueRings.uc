//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_ShowCivilianRescueRings.uc
//  AUTHOR:  David Burchanowski  --  10/30/2014
//  PURPOSE: Shows rescue rings around all of the civilian units
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
 
class SeqAct_ShowCivilianRescueRings extends SequenceAction
	implements(X2KismetSeqOpVisualizer);

var() private int RescueRingRadius;
var() private float RescueRingRadiusDelta;
var() bool bIncludeResistanceUnits;

function ModifyKismetGameState(out XComGameState GameState)
{
	local XComGameStateHistory History;
	local float RescueRingRadiusUnrealUnits, RadiusTotal;
	local XComGameState_Unit Unit, NewUnit;

	History = `XCOMHISTORY;

	RescueRingRadiusUnrealUnits = RescueRingRadius * class'XComWorldData'.const.WORLD_StepSize;
	RadiusTotal = RescueRingRadiusUnrealUnits + RescueRingRadiusDelta;

	foreach History.IterateByClassType(class'XComGameState_Unit', Unit)
	{
		if((Unit.GetTeam() == eTeam_Neutral || (Unit.GetTeam() == eTeam_Resistance && bIncludeResistanceUnits)) && !Unit.IsDead())
		{
			NewUnit = XComGameState_Unit( GameState.ModifyStateObject( class'XComGameState_Unit', Unit.ObjectID ) );
			NewUnit.SetRescueRingRadius( RadiusTotal );
		}
	}
}

function BuildVisualization(XComGameState GameState)
{
	local VisualizationActionMetadata ActionMetadata, EmptyData;
	local XComGameState_Unit UnitState;

	foreach GameState.IterateByClassType( class'XComGameState_Unit', UnitState )
	{
		ActionMetadata = EmptyData;

		ActionMetadata.StateObject_NewState = UnitState;
		ActionMetadata.StateObject_OldState = UnitState.GetPreviousVersion( );

		class'X2Action_SyncVisualizer'.static.AddToVisualizationTree( ActionMetadata, GameState.GetContext() );
	}
}

defaultproperties
{
	ObjName="Show Civilian Rescue Rings"
	RescueRingRadius=3
	bIncludeResistanceUnits = false

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks.Empty
}