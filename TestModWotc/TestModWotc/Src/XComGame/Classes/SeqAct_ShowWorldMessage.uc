//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_ShowWorldMessage.uc
//  AUTHOR:  David Burchanowski  --  6/16/2016
//  PURPOSE: Displays a message in the corner of the screen
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_ShowWorldMessage extends SequenceAction
	implements(X2KismetSeqOpVisualizer);

var string Message; // the message to display

function ModifyKismetGameState(out XComGameState GameState);

function BuildVisualization(XComGameState GameState)
{
	local X2Action_PlayWorldMessage MessageAction;
	local XComGameState_KismetVariable KismetVar;
	local VisualizationActionMetadata ActionMetadata;

	if(Message != "")
	{
		foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_KismetVariable', KismetVar)
		{
			ActionMetadata.StateObject_OldState = KismetVar;
			ActionMetadata.StateObject_NewState = KismetVar;
			MessageAction = X2Action_PlayWorldMessage(class'X2Action_PlayWorldMessage'.static.AddToVisualizationTree(ActionMetadata, GameState.GetContext()));
			MessageAction.AddWorldMessage(Message);

			
			break;
		}
	}
}

defaultproperties
{
	ObjCategory="Level"
	ObjName="Show World Message"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
	
	bAutoActivateOutputLinks=true
	OutputLinks(0)=(LinkDesc="Out")

	VariableLinks(0)=(ExpectedType=class'SeqVar_String',LinkDesc="Message",PropertyName=Message)
}

