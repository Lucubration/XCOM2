class SeqAct_RemoveActorFromBuildingVis extends SequenceAction
	implements(X2KismetSeqOpVisualizer);

var() Actor TargetActor;
var X2Action_RemoveActorFromBuildingVis RemoveAction;

function ModifyKismetGameState(out XComGameState GameState)
{
}

function BuildVisualization(XComGameState GameState)
{
	local VisualizationActionMetadata ActionMetadata;
	local XComGameStateHistory History;
	local XComGameState_KismetVariable KismetStateObject;

	History = `XComHistory;
		foreach History.IterateByClassType(class'XComGameState_KismetVariable', KismetStateObject)
	{
		break;
	}

	ActionMetadata.StateObject_OldState = KismetStateObject;
	ActionMetadata.StateObject_NewState = KismetStateObject;

	if (RemoveAction == none)
	{
		RemoveAction = class'WorldInfo'.static.GetWorldInfo().Spawn(class'X2Action_RemoveActorFromBuildingVis');
	}

	ActionMetadata.VisualizeActor = `BATTLE;

	class'X2Action_RemoveActorFromBuildingVis'.static.AddActionToVisualizationTree(RemoveAction, ActionMetadata, GameState.GetContext());

	RemoveAction.FocusActorToRemove = TargetActor;

	
}

defaultproperties
{
	ObjCategory="CutDown"
	ObjName="Remove actor from building vis"
	bAutoActivateOutputLinks=true
	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Actor",PropertyName=TargetActor)
}