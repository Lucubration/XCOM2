//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_ShowRescueRings.uc
//  AUTHOR:  Russell Aasland  --  1/20/2017
//  PURPOSE: Shows rescue rings around specific set of units
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
 
class SeqAct_ShowRescueRings extends SequenceAction
	implements(X2KismetSeqOpVisualizer);

var() private int RescueRingRadius;
var() private float RescueRingRadiusDelta;

function ModifyKismetGameState(out XComGameState GameState)
{
	local float RescueRingRadiusUnrealUnits, TotalRingRadius;
	local SeqVar_GameStateList List;
	local StateObjectReference UnitRef;
	local XComGameState_Unit UnitState;

	RescueRingRadiusUnrealUnits = RescueRingRadius * class'XComWorldData'.const.WORLD_StepSize;
	TotalRingRadius = RescueRingRadiusUnrealUnits + RescueRingRadiusDelta;

	foreach LinkedVariables(class'SeqVar_GameStateList', List, "Game State List")
	{
		foreach List.GameStates( UnitRef )
		{
			UnitState = XComGameState_Unit( GameState.ModifyStateObject( class'XComGameState_Unit', UnitRef.ObjectID ) );
			UnitState.SetRescueRingRadius( TotalRingRadius );
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
	ObjName="Show Rescue Rings"
	RescueRingRadius=3

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
	bAutoActivateOutputLinks=true

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_GameStateList',LinkDesc="Game State List",MinVars=1,MaxVars=1)
}