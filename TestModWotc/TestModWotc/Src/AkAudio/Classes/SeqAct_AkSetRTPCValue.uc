class SeqAct_AkSetRTPCValue extends SeqAct_Latent
	native;

cpptext
{
	void Activated();
	UBOOL UpdateOp(FLOAT deltaTime);
private:
	void SetRTPCValue();
};

/** Name of game parameter */
var() string Param;

/** Value of game parameter, default value used if no variable linked */
var() float Value;

/** True when sending RTPC signal */
var transient bool Running;

defaultproperties
{
	ObjName="AkSetRTPCValue"
	ObjCategory="AkAudio"
	bConvertedForReplaySystem=true
	
	OutputLinks.Empty

	InputLinks(0)=(LinkDesc="Start")
	InputLinks(1)=(LinkDesc="Stop")
	VariableLinks(1)=(ExpectedType=class'SeqVar_Float',LinkDesc="Value",PropertyName=Value)

	OutputLinks(0)=(LinkDesc="Finished")
}
