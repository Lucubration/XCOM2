//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_ExecuteBehaviorTree.uc
//  AUTHOR:  Russell Aasland
//  PURPOSE: Activates the given units specified behavior tree. For LD scripting.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_ExecuteBehaviorTree extends SequenceAction;

var XComGameState_Unit Unit;

event Activated()
{
	if (Unit == none)
	{
		`RedScreen("SeqAct_ExecuteBehaviorTree: No unit provided");
		return;
	}

	Unit.AutoRunBehaviorTree( );
}

defaultproperties
{
	ObjCategory="Automation"
	ObjName="Execute Behavior Tree"
	bCallHandler = false

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks(0)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="Unit",PropertyName=Unit)
}