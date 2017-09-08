//---------------------------------------------------------------------------------------
//  FILE:    XComGameStateContext_ChallengeScore.uc
//  AUTHOR:  Russell Aasland
//  PURPOSE: Context for changes to the challenge score
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class XComGameStateContext_ChallengeScore extends XComGameStateContext
	native(Challenge);

native function bool Validate(optional EInterruptionStatus InInterruptionStatus);
native function XComGameState ContextBuildGameState();
final native static function XComGameState CreateChangeState();

final static event XComGameStateContext CreateXComGameStateContextNative()
{
	return super.CreateXComGameStateContext();
}

protected event ContextBuildVisualization()
{
	local VisualizationActionMetadata ActionMetadata;
	local X2Action_ChallengeScoreUpdate Action;
	local XComGameStateHistory History;
	local XComGameState_ChallengeScore ChallengeScore;

	// Not Challenge Mode
	if (`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_ChallengeData', true) == none)
	{
		return;
	}

	// we only want to act as a fence in instance where we create actions
	SetVisualizationFence( true, 20.0f );

	History = `XCOMHISTORY;

	foreach AssociatedState.IterateByClassType(class'XComGameState_ChallengeScore', ChallengeScore)
	{
		ActionMetadata.StateObject_OldState = ChallengeScore;
		ActionMetadata.StateObject_NewState = ActionMetadata.StateObject_OldState;
		ActionMetadata.VisualizeActor = History.GetVisualizer(`TACTICALRULES.GetLocalClientPlayerObjectID());

		Action = X2Action_ChallengeScoreUpdate(class'X2Action_ChallengeScoreUpdate'.static.AddToVisualizationTree(ActionMetadata, self));
		Action.AddedPoints = ChallengeScore.AddedPoints;
		Action.ScoringType = ChallengeScore.ScoringType;
	}
}

event string SummaryString( )
{
	return "Challenge Score Change";
}
defaultproperties
{
	AssociatedPlayTiming=SPT_AfterSequential
}