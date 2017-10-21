class SeqAct_AkClearBanks extends SequenceAction
	native;

cpptext
{
	void Activated();
};

defaultproperties
{
	ObjName="AkClearBanks"
	ObjCategory="AkAudio"
	bConvertedForReplaySystem=true

	VariableLinks.Empty

	InputLinks(0)=(LinkDesc="ClearBanks")
}
