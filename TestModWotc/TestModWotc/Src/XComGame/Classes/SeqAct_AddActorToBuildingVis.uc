class SeqAct_AddActorToBuildingVis extends SequenceAction
	implements(X2KismetSeqOpVisualizer);

var() Actor TargetActor;
var X2Action_AddActorToBuildingVis AddAction;

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

	if (AddAction == none)
	{
		AddAction = class'WorldInfo'.static.GetWorldInfo().Spawn(class'X2Action_AddActorToBuildingVis');
	}

	ActionMetadata.VisualizeActor = `BATTLE;

	class'X2Action_AddActorToBuildingVis'.static.AddActionToVisualizationTree(AddAction, ActionMetadata, GameState.GetContext());

	AddAction.FocusActorToAdd = TargetActor;

	
}

defaultproperties
{
	ObjCategory="CutDown"
	ObjName="Add actor to building vis"
	bAutoActivateOutputLinks=true
	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Actor",PropertyName=TargetActor)
}