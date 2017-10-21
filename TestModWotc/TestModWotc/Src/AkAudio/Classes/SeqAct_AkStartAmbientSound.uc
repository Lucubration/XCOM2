class SeqAct_AkStartAmbientSound extends SequenceAction
	native;

cpptext
{
	void Activated();
};

defaultproperties
{
	ObjName="AkStartAmbientSound"
	ObjCategory="AkAudio"
	bConvertedForReplaySystem=true

	InputLinks(0)=(LinkDesc="Start All")
	InputLinks(1)=(LinkDesc="Stop All")
	InputLinks(2)=(LinkDesc="Start Target(s)")
	InputLinks(3)=(LinkDesc="Stop Targets(s)")
}
