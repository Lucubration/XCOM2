//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_ActivateTacticalNarrative.uc
//  AUTHOR:  Russell Aasland
//  PURPOSE: Visualizer version of SeqAct_ActivateNarrative to play arbitrary moments
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class SeqAct_ActivateTacticalNarrative extends SequenceAction
	implements(X2KismetSeqOpVisualizer)
	dependson(XGNarrative);

var() XComNarrativeMoment NarrativeMoment;
var() bool WaitForCompletion;
var() bool StopExistingNarrative;

function ModifyKismetGameState( out XComGameState GameState )
{
}

function BuildVisualization(XComGameState GameState)
{
	local X2Action_PlayNarrative Narrative;
	local VisualizationActionMetadata ActionMetadata;
	local XComGameState_KismetVariable KismetStateObject;

	if (NarrativeMoment == none)
	{
		`Redscreen( "SeqAct_ActivateTacticalNarrative: not configured with narrative moment reference" );
		return;
	}

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_KismetVariable', KismetStateObject)
	{
		break;
	}

	ActionMetadata.StateObject_OldState = KismetStateObject;
	ActionMetadata.StateObject_NewState = KismetStateObject;

	Narrative = X2Action_PlayNarrative( class'X2Action_PlayNarrative'.static.AddToVisualizationTree( ActionMetadata, GameState.GetContext() ) );

	Narrative.Moment = NarrativeMoment;
	Narrative.WaitForCompletion = WaitForCompletion;
	Narrative.StopExistingNarrative = StopExistingNarrative;
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
	return Super.GetObjClassVersion() + 0;
}

defaultproperties
{
	ObjCategory="Sound"
	ObjName="Narrative Moment - Tactical"
	bCallHandler=false

	bConvertedForReplaySystem=true

	VariableLinks.Empty

	WaitForCompletion=true
	StopExistingNarrative=false
}