class InterpTrackInstAkEvent extends InterpTrackInst
	native;

// in order to notify the controller about ak events (for subtitle purposes),
// we need to store them in this intermediate array so that we don't attempt
// to execute two independent script stacks. They will be processed on the following UpdateTrack()
struct native InterpTrackInstAkEvent_Notify
{
	var AkEvent Event; // the event that was fired
	var float Duration; // the duration of the event, once the ak callback is received
	var int PlayingID; // stores a type of AkPlayingID, which unreal doesn't really know about
};

cpptext
{
	virtual void InitTrackInst(UInterpTrack* Track);
	virtual void TermTrackInst(UInterpTrack* Track);
}

// Keeps track of events from the AK callbacks, so that we can process notifies on the next game tick
var private array<InterpTrackInstAkEvent_Notify> PendingEventNotifies;

var	float LastUpdatePosition; 

defaultproperties
{
}
