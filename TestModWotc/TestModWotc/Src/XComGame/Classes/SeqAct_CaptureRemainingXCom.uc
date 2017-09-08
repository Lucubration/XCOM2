//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_CaptureRemainingXCom.uc
//  AUTHOR:  David Burchanowski
//  PURPOSE: Causes all XCom units that are not dead and still on the board to be captured by the aliens
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_CaptureRemainingXCom extends SequenceAction
	implements(X2KismetSeqOpVisualizer);

function BuildVisualization(XComGameState GameState);

function ModifyKismetGameState(out XComGameState GameState)
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		if(UnitState.GetTeam() == eTeam_XCom
			&& !UnitState.IsDead()
			&& !UnitState.IsBleedingOut()
			&& !UnitState.bRemovedFromPlay)
		{
			UnitState = XComGameState_Unit(GameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));
			UnitState.bCaptured = true;
		}
	}
}

defaultproperties
{
	ObjName="Capture Remaining XCom"
	ObjCategory="Gameplay"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
	bAutoActivateOutputLinks=true

	VariableLinks.Empty
}