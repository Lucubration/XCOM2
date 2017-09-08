//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_ShowFlyover.uc
//  AUTHOR:  Russell Aasland  --  2/9/2017
//  PURPOSE: Displays a Flyover.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_ShowDramaticMessage extends SequenceAction
	implements(X2KismetSeqOpVisualizer)
	dependson(UIUtilities_Colors);

var XComGameState_BaseObject TargetObject;
var string Message1; // the message to display
var string Message2; // the message to display
var string Title; // the title to display
var() EUIState MessageColor;
var() string MessageIcon;
var() bool bDontPlaySoundEvent;

function ModifyKismetGameState(out XComGameState GameState);

function BuildVisualization(XComGameState GameState)
{
	local X2Action_PlayMessageBanner MessageAction;
	local XComGameState_KismetVariable KismetVar;
	local VisualizationActionMetadata ActionMetadata;

	if(Message1 != "" || Message2 != "")
	{
		if (TargetObject == none)
		{
			foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_KismetVariable', KismetVar)
			{
				TargetObject = KismetVar;
				break;
			}
		}

		ActionMetadata.StateObject_OldState = TargetObject;
		ActionMetadata.StateObject_NewState = TargetObject;

		MessageAction = X2Action_PlayMessageBanner(class'X2Action_PlayMessageBanner'.static.AddToVisualizationTree(ActionMetadata, GameState.GetContext()));
		MessageAction.AddMessageBanner(Title, MessageIcon, Message1, Message2, MessageColor);
		MessageAction.bDontPlaySoundEvent = bDontPlaySoundEvent;
	}
}

defaultproperties
{
	ObjCategory="Level"
	ObjName="Show Dramatic Message"

	MessageColor = eUIState_Good
	MessageIcon = ""

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
	
	bAutoActivateOutputLinks=true
	OutputLinks(0)=(LinkDesc="Out")

	VariableLinks(0)=(ExpectedType=class'SeqVar_GameStateObject',LinkDesc="State Object",PropertyName=TargetObject)
	VariableLinks(1)=(ExpectedType=class'SeqVar_String',LinkDesc="Title",PropertyName=Title)
	VariableLinks(2)=(ExpectedType=class'SeqVar_String',LinkDesc="Message Line 1",PropertyName=Message1)
	VariableLinks(3)=(ExpectedType=class'SeqVar_String',LinkDesc="Message Line 2",PropertyName=Message2)
}