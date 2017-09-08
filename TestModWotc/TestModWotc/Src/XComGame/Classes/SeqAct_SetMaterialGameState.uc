/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_SetMaterialGameState extends SequenceAction
	implements(X2KismetSeqOpVisualizer);

/** Material to apply to target when action is activated. */
var() private MaterialInterface	NewMaterial;

/** Index in the Materials array to replace with NewMaterial when this action is activated. */
var() private int MaterialIndex;

/** Index in the Materials array to replace with NewMaterial when this action is activated. */
var private XComGamestate_InteractiveObject InteractiveObject;

event Activated()
{
	local X2TacticalGameRuleset Rules;
	local XComGameState NewGameState;
	local XComGameState_InteractiveObject ObjectState;
	local XComGameState_MaterialSwaps MaterialState;

	Rules = `TACTICALRULES;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("SeqAct_SetMaterialGameState: (" @ InteractiveObject.ObjectID @ ")");

	MaterialState = XComGameState_MaterialSwaps(InteractiveObject.FindComponentObject(class'XComGameState_MaterialSwaps', true));
	if(MaterialState == none)
	{
		// create a new material state and attach it to the interactive actor
		MaterialState = XComGameState_MaterialSwaps(NewGameState.CreateNewStateObject(class'XComGameState_MaterialSwaps'));

		// add it as a component on the interactive object
		ObjectState = XComGameState_InteractiveObject(NewGameState.ModifyStateObject(class'XComGameState_InteractiveObject', InteractiveObject.ObjectID));
		ObjectState.AddComponentObject(MaterialState);
	}
	else
	{
		// create a newer version of the existing material state
		MaterialState = XComGameState_MaterialSwaps(NewGameState.ModifyStateObject(class'XComGameState_MaterialSwaps', MaterialState.ObjectID));
	}

	MaterialState.SetMaterialSwap(NewMaterial, MaterialIndex);

	Rules.SubmitGameState(NewGameState);
}

function ModifyKismetGameState(out XComGameState GameState);

function BuildVisualization(XComGameState GameState)
{
	local XComGameStateHistory History;
	local VisualizationActionMetadata ActionMetadata;
	local XComGameState ChangeState;
	local XComGameState_MaterialSwaps SwapState;
	local XComGameState_InteractiveObject SwapObject;

	History = `XCOMHISTORY;

	// get state of the object we modified. This is the game state immediately after ours
	ChangeState = History.GetGameStateFromHistory(GameState.HistoryIndex - 1);

	foreach ChangeState.IterateByClassType(class'XComGameState_MaterialSwaps', SwapState)
	{
		SwapObject = XComGameState_InteractiveObject(SwapState.FindComponentObject(class'XComGameState_InteractiveObject', true));

		if(SwapObject != none)
		{
			ActionMetadata.StateObject_OldState = SwapObject;
			ActionMetadata.StateObject_NewState = SwapObject;
			ActionMetadata.VisualizeActor = History.GetVisualizer(SwapObject.ObjectID);
			class'X2Action_SyncVisualizer'.static.AddToVisualizationTree(ActionMetadata, GameState.GetContext());	

			
		}
	}
}


defaultproperties
{
	ObjName="Set Material GameState"
	ObjCategory="Level"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks(0)=(ExpectedType=class'SeqVar_InteractiveObject',LinkDesc="InteractiveObject",PropertyName=InteractiveObject)
}
