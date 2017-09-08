//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_TransferToNewMission.uc
//  AUTHOR:  David Burchanowski   --  3/11/2016
//  PURPOSE: Displays the hidden movement indicator immediately
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class SeqAct_TransferToNewMission extends SequenceAction
	implements(X2KismetSeqOpVisualizer); 

var() private string MissionType;

event Activated();
function ModifyKismetGameState(out XComGameState GameState);

function BuildVisualization(XComGameState GameState)
{
	local XComGameStateHistory History;
	local VisualizationActionMetadata ActionMetadata;
	local X2Action_TransferToNewMission TransferAction;
	local XComGameState_KismetVariable KismetState;
	local SeqVar_GameStateList List;
	local StateObjectReference StateRef;

	if(MissionType == "")
	{
		`Redscreen("No mission specified in SeqAct_TransferToNewMission!");
		return;
	}

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_KismetVariable', KismetState)
	{
		break;
	}

	ActionMetadata.StateObject_OldState = KismetState;
	ActionMetadata.StateObject_NewState = ActionMetadata.StateObject_OldState;
	TransferAction = X2Action_TransferToNewMission(class'X2Action_TransferToNewMission'.static.AddToVisualizationTree(ActionMetadata, GameState.GetContext()));
	TransferAction.MissionType = MissionType;

	foreach LinkedVariables(class'SeqVar_GameStateList', List, "Capture Soldiers")
	{
		foreach List.GameStates( StateRef )
		{
			TransferAction.ForcedCapturedSoldiers.AddItem( StateRef );
		}
	}

	foreach LinkedVariables(class'SeqVar_GameStateList', List, "Evac Soldiers")
	{
		foreach List.GameStates( StateRef )
		{
			TransferAction.ForcedEvacSoldiers.AddItem( StateRef );
		}
	}
}

/**
* Return the version number for this class.  Child classes should increment this method by calling Super then adding
* a individual class version to the result.  When a class is first created, the number should be 0; each time one of the
* link arrays is modified (VariableLinks, OutputLinks, InputLinks, etc.), the number that is added to the result of
* Super.GetObjClassVersion() should be incremented by 1.
*
* @return	the version number for this specific class.
*/
static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjName="Transfer To New Mission"
	ObjCategory="Level"
	bCallHandler=false
	bAutoActivateOutputLinks=true

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_String',LinkDesc="Mission Type",PropertyName=MissionType)
	VariableLinks(1)=(ExpectedType=class'SeqVar_GameStateList',LinkDesc="Capture Soldiers",MinVars=1,MaxVars=1)
	VariableLinks(2)=(ExpectedType=class'SeqVar_GameStateList',LinkDesc="Evac Soldiers",MinVars=1,MaxVars=1)
}
