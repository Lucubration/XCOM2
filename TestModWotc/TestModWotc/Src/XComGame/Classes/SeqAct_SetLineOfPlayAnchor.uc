///---------------------------------------------------------------------------------------
//  FILE:    SeqAct_SetLineOfPlayAnchor.uc
//  AUTHOR:  David Burchanowski  --  9/16/2014
//  PURPOSE: Allows kismet to explicitly attach the end point of the line of play
//           to an arbitrary game state
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_SetLineOfPlayAnchor extends SequenceAction
	implements(X2KismetSeqOpVisualizer);

var protected XComGameState_BaseObject AnchorState;

event Activated();

function BuildVisualization(XComGameState GameState);

function ModifyKismetGameState(out XComGameState NewGameState)
{
	local XComGameState_LineOfPlayAnchor LineOfPlayAnchor;

	if(AnchorState == none)
	{
		return;
	}

	if(InputLinks[0].bHasImpulse)
	{
		if(AnchorState.FindComponentObject(class'XComGameState_LineOfPlayAnchor') == none)
		{
			LineOfPlayAnchor = XComGameState_LineOfPlayAnchor(NewGameState.CreateNewStateObject(class'XComGameState_LineOfPlayAnchor'));

			AnchorState = NewGameState.ModifyStateObject(AnchorState.Class, AnchorState.ObjectId);
			AnchorState.AddComponentObject(LineOfPlayAnchor);
		}
	}
	else
	{
		`assert(InputLinks[1].bHasImpulse);
		LineOfPlayAnchor = XComGameState_LineOfPlayAnchor(AnchorState.FindComponentObject(class'XComGameState_LineOfPlayAnchor'));
		if(LineOfPlayAnchor != none)
		{
			NewGameState.RemoveStateObject(LineOfPlayAnchor.ObjectID);

			AnchorState = NewGameState.ModifyStateObject(AnchorState.Class, AnchorState.ObjectId);
			AnchorState.RemoveComponentObject(LineOfPlayAnchor);
		}
	}
}

defaultproperties
{
	ObjName="Set Line of Play Anchor"
	ObjCategory="Level"
	bCallHandler=false;

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	InputLinks(0)=(LinkDesc="Add")
	InputLinks(1)=(LinkDesc="Remove")

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_GameStateObject',LinkDesc="Anchor State",PropertyName=AnchorState)
}


