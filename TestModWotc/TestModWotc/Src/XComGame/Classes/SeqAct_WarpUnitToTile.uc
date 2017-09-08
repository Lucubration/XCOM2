//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_WarpsUnitToTile.uc
//  AUTHOR:  David Burchanowski
//  PURPOSE: Warps a unit to a given tile (if possible) via kismet. For LD scripting demo/tutorial save creation.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_WarpUnitToTile extends SequenceAction
	implements(X2KismetSeqOpVisualizer);

var XComGameState_Unit Unit;
var Actor DestinationActor;
var vector DestinationLocation;

function ModifyKismetGameState(out XComGameState GameState)
{
	local XComWorldData WorldData;
	local TTile DestinationTile;

	WorldData = `XWORLD;

	if(Unit == none)
	{
		`RedScreen("SeqAct_WarpUnitToTile: No unit provided");
		return;
	}

	if(DestinationActor != none)
	{
		DestinationLocation = DestinationActor.Location;
	}

	if(!WorldData.GetFloorTileForPosition(DestinationLocation, DestinationTile))
	{
		`RedScreen("SeqAct_MoveUnitToTile: Destination location is invalid" $ string(DestinationLocation));
		return;
	}

	Unit = XComGameState_Unit(GameState.ModifyStateObject(class'XComGameState_Unit', Unit.ObjectID));
	Unit.SetVisibilityLocation(DestinationTile);
}

function BuildVisualization(XComGameState GameState)
{
	local XComGameState_Unit UnitState;
	local VisualizationActionMetadata BuildTrack;
	local X2Action_UpdateFOW FOWAction;

	foreach GameState.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		BuildTrack.StateObject_NewState = UnitState;
		BuildTrack.StateObject_OldState = UnitState;
		class'X2Action_SyncVisualizer'.static.AddToVisualizationTree(BuildTrack, GameState.GetContext());

		FOWAction = X2Action_UpdateFOW( class'X2Action_UpdateFOW'.static.AddToVisualizationTree( BuildTrack, GameState.GetContext()) );
		FOWAction.ForceUpdate = true;

		break;
	}
}

defaultproperties
{
	ObjCategory="Automation"
	ObjName="Warp Unit To Tile"
	bCallHandler = false

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks(0)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="Unit",PropertyName=Unit)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Destination Actor",PropertyName=DestinationActor)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Destination Location",PropertyName=DestinationLocation)
}