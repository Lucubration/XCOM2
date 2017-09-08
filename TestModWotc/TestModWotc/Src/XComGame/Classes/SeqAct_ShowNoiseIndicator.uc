//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_ShowNoiseIndicator.uc
//  AUTHOR:  David Burchanowski  --  7/5/2016
//  PURPOSE: Displays a noise indicator immediately
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class SeqAct_ShowNoiseIndicator extends SequenceAction
	implements(X2KismetSeqOpVisualizer); 

var() StaticMesh IndicatorMesh;
var XComGameState_Unit HeardUnit;
var vector TargetLocation;
var string HeardUnitCallout;

event Activated();
function ModifyKismetGameState(out XComGameState GameState);

function XComGameState_Unit GetClosestXComUnit(vector Location)
{
	local XComGameStateHistory History;
	local XComWorldData WorldData;
	local XComGameState_Unit UnitState;
	local XComGameState_Unit ClosestUnitState;
	local float DistanceSquared;
	local float ClosestDistanceSquared;

	History = `XCOMHISTORY;
	WorldData = `XWORLD;

	foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		if(UnitState.GetTeam() == eTeam_XCom
			&& UnitState.IsAlive()
			&& !UnitState.IsUnconscious())
		{
			DistanceSquared = VSizeSq(WorldData.GetPositionFromTileCoordinates(UnitState.TileLocation) - Location);
			if(DistanceSquared < ClosestDistanceSquared || ClosestUnitState == none)
			{
				ClosestUnitState = UnitState;
				ClosestDistanceSquared = DistanceSquared;
			}
		}
	}

	return ClosestUnitState;
}

function BuildVisualization(XComGameState GameState)
{
	local VisualizationActionMetadata ActionMetadata;
	local X2Action_NoiseIndicator NoiseIndicator;

	if(HeardUnit == none)
	{
		`Redscreen("SeqAct_ShowNoiseIndicator: HeardUnit not specified.");
		return;
	}

	ActionMetadata.StateObject_OldState = GetClosestXComUnit(TargetLocation);
	ActionMetadata.StateObject_NewState = ActionMetadata.StateObject_OldState;

	NoiseIndicator = X2Action_NoiseIndicator(class'X2Action_NoiseIndicator'.static.AddToVisualizationTree(ActionMetadata, GameState.GetContext()));
	NoiseIndicator.SetNoiseIndicatorMesh(IndicatorMesh);
	NoiseIndicator.HeardUnitReference = HeardUnit.GetReference();
	NoiseIndicator.HeardUnitCallout = HeardUnitCallout != "" ? name(HeardUnitCallout) : class'X2Action_NoiseIndicator'.default.HeardUnitCallout;

	if(TargetLocation == vect(0, 0, 0))
	{
		TargetLocation = `XWORLD.GetPositionFromTileCoordinates(HeardUnit.TileLocation);
	}

	NoiseIndicator.TargetLocation = TargetLocation;
}

defaultproperties
{
	ObjName="Show Noise Indicator"
	ObjCategory="UI/Input"
	bCallHandler=false
	bAutoActivateOutputLinks=true

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="Heard Unit", PropertyName=HeardUnit)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Target Location", PropertyName=TargetLocation)
	VariableLinks(2)=(ExpectedType=class'SeqVar_String',LinkDesc="Heard Unit Callout", PropertyName=HeardUnitCallout)
}
