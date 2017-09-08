//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_ShowFlyover.uc
//  AUTHOR:  Russell Aasland  --  2/9/2017
//  PURPOSE: Displays a Flyover.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_ShowFlyover extends SequenceAction
	implements(X2KismetSeqOpVisualizer)
	dependson(UIUtilities_Colors);

var XComGameState_BaseObject TargetObject;
var string Message; // the message to display
var() EWidgetColor MessageColor;
var() string FlyOverIcon;

function ModifyKismetGameState(out XComGameState GameState);

function BuildVisualization(XComGameState GameState)
{
	local X2Action_PlaySoundAndFlyover FlyoverAction;
	local XComGameState_KismetVariable KismetVar;
	local VisualizationActionMetadata ActionMetadata;

	if(Message != "")
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

		FlyoverAction = X2Action_PlaySoundAndFlyover(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(ActionMetadata, GameState.GetContext()));
		FlyoverAction.SetSoundAndFlyOverParameters(none, Message, '', MessageColor, FlyOverIcon);
	}
}

defaultproperties
{
	ObjCategory="Level"
	ObjName="Show Flyover Message"

	MessageColor = eColor_Good
	FlyOverIcon = ""

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
	
	bAutoActivateOutputLinks=true
	OutputLinks(0)=(LinkDesc="Out")

	VariableLinks(0)=(ExpectedType=class'SeqVar_GameStateObject',LinkDesc="State Object",PropertyName=TargetObject)
	VariableLinks(1)=(ExpectedType=class'SeqVar_String',LinkDesc="Message",PropertyName=Message)
}

