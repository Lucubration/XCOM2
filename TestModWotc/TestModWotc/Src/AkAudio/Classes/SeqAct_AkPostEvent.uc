class SeqAct_AkPostEvent extends SeqAct_Latent
	native;

var transient int Signal;		// signal (event) used for EndOfEvent

cpptext
{
	virtual void FinishDestroy();

	void Activated();
	UBOOL UpdateOp(FLOAT deltaTime);
private:
	void PlayEventOnTargets();
};

/** Event to post on the targeted actor(s) */
var() AkEvent Event;

defaultproperties
{
	ObjName="AkPostEvent"
	ObjCategory="AkAudio"
	bConvertedForReplaySystem=true

	OutputLinks.Empty

	InputLinks(0)=(LinkDesc="Post")

	OutputLinks(0)=(LinkDesc="Finished")
}
