class SeqAct_ShowTutorialTarget extends SequenceAction
	implements(X2KismetSeqOpVisualizer);


event Activated()
{
}

function ModifyKismetGameState(out XComGameState GameState)
{
}

function BuildVisualization(XComGameState GameState)
{
	local XComGameStateHistory History;
	local XComGameState_KismetVariable KismetStateObject;
	local VisualizationActionMetadata ActionMetadata;

	if(`TUTORIAL != none)
	{
		History = `XCOMHISTORY;
		foreach History.IterateByClassType(class'XComGameState_KismetVariable', KismetStateObject)
		{
			break;
		}

		ActionMetadata.StateObject_OldState = KismetStateObject;
		ActionMetadata.StateObject_NewState = KismetStateObject;

		class'X2Action_ShowTutorialTarget'.static.AddToVisualizationTree(ActionMetadata, GameState.GetContext());
	
		
	}
}

static event int GetObjClassVersion()
{
	return super.GetObjClassVersion() + 3;
}

defaultproperties
{
	ObjCategory="Tutorial"
	ObjName="Show Tutorial Target"
	bAutoActivateOutputLinks=true
	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
}