class SeqAct_AkLoadBank extends SeqAct_Latent
	native;

var() bool Async;					// Asynchronous loading
var() AkBank Bank;					// Bank to be loaded / unloaded
var transient int Signal;			// signal (event) used during async load

var transient bool bWaitingCallback;// true if the ojbect must cancel a cookie on destroy.

cpptext
{
	void Activated();
	UBOOL UpdateOp(FLOAT deltaTime);

	virtual void BeginDestroy();
};

defaultproperties
{
	ObjName="AkLoadBank"
	ObjCategory="AkAudio"
	bConvertedForReplaySystem=true

	VariableLinks.Empty
	OutputLinks.Empty
	
	Async = TRUE
	bWaitingCallback = FALSE

	InputLinks(0)=(LinkDesc="Load")
	InputLinks(1)=(LinkDesc="Unload")
	
	OutputLinks(0)=(LinkDesc="Finished")
}
