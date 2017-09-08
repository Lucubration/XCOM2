//-----------------------------------------------------------
//Makes a unit speak a line of voice over
//-----------------------------------------------------------
class SeqAct_PlayUnitVoiceover extends SequenceAction
	implements(X2KismetSeqOpVisualizer);

var XComGameState_Unit Unit;
var name AudioCue;
var string AudioCueString;

function ModifyKismetGameState(out XComGameState GameState);

function BuildVisualization(XComGameState GameState)
{
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local VisualizationActionMetadata ActionMetadata;

	if(AudioCueString != "")
	{
		AudioCue = name(AudioCueString);
	}

	ActionMetadata.VisualizeActor = Unit.GetVisualizer();
	ActionMetadata.StateObject_OldState = Unit;
	ActionMetadata.StateObject_NewState = Unit;

	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, GameState.GetContext()));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "", AudioCue, eColor_Good);

	
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjCategory="Sound"
	ObjName="Play Unit Voiceover"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks(0)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="Unit",PropertyName=Unit)
	VariableLinks(1)=(ExpectedType=class'SeqVar_String',LinkDesc="AudioCue",PropertyName=AudioCueString)
}
