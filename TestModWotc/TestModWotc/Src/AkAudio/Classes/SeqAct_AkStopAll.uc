class SeqAct_AkStopAll extends SequenceAction
	native;

cpptext
{
	void Activated();
};

defaultproperties
{
	ObjName="AkStopAll"
	ObjCategory="AkAudio"
	bConvertedForReplaySystem=true

	VariableLinks.Empty

	InputLinks(0)=(LinkDesc="StopAll")
}
