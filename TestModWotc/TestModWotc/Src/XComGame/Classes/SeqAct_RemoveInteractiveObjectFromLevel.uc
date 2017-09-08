/**
 * Removes an interactive object from the level
 */
class SeqAct_RemoveInteractiveObjectFromLevel extends SequenceAction;

var XComGameState_InteractiveObject ObjectState;

event Activated()
{
	local XComGameState NewGameState;

	if(ObjectState != none)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("SeqAct_RemoveInteractiveObjectFromLevel: " @ ObjectState.GetVisualizer() @ " (" @ ObjectState.ObjectID @ ")");
		ObjectState.RemoveFromPlay(NewGameState);
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
}

defaultproperties
{
	ObjName="Remove Interactive Object From Level"
	ObjCategory="Level"
	bCallHandler=false
	bAutoActivateOutputLinks=true;

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks(0)=(ExpectedType=class'SeqVar_InteractiveObject',LinkDesc="Interactive Object",PropertyName=ObjectState,bWriteable=TRUE)
}
