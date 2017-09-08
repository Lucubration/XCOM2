//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_TakeLoot.uc
//  AUTHOR:  Russell Aasland  --  1/20/2017
//  PURPOSE: Gamestate and Visualizer changes to take loot from another gamestate object
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_TakeLoot extends SequenceAction
	implements(X2KismetSeqOpVisualizer);

var XComGameState_Unit Unit;
var XComGameState_BaseObject LootState;

function ModifyKismetGameState(out XComGameState GameState)
{
	local Lootable LootableState;

	if (Unit == none)
	{
		`Redscreen("SeqAct_TakeLoot was not provided with a unit state as the looter");
		return;
	}

	if (LootState == none)
	{
		`Redscreen("SeqAct_TakeLoot was not provided with an object state to loot from");
		return;
	}

	LootableState = Lootable( LootState );

	if (LootableState == none)
	{
		`Redscreen("SeqAct_TakeLoot was provided with an object state of type" @LootState.Class.Name@ "which is not lootable");
		return;
	}

	LootableState = Lootable( GameState.ModifyStateObject( LootState.Class, LootState.ObjectID ) );

	LootableState.MakeAvailableLoot( GameState );
	class'Helpers'.static.AcquireAllLoot(LootableState, Unit.GetReference(), GameState);
}

function BuildVisualization(XComGameState GameState)
{
	local XComGameStateHistory History;
	local VisualizationActionMetadata        ActionMetadata;

	if ((Unit == none) || (LootState == none) || (Lootable( LootState ) == none))
	{
		return;
	}

	History = `XCOMHISTORY;

	ActionMetadata.StateObject_NewState = GameState.GetGameStateForObjectID(Unit.ObjectID);
	ActionMetadata.StateObject_OldState = ActionMetadata.StateObject_NewState.GetPreviousVersion( );
	ActionMetadata.VisualizeActor = History.GetVisualizer(Unit.ObjectID);

	class'X2Action_Loot'.static.AddToVisualizationTreeIfLooted(LootState, GameState.GetContext(), ActionMetadata);	
}

defaultproperties
{
	ObjCategory="Loot"
	ObjName="Unit Loot Object"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks(0)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="Unit",PropertyName=Unit)
	VariableLinks(1)=(ExpectedType=class'SeqVar_GameStateObject',LinkDesc="ObjectToLoot",PropertyName=LootState)
}