//-----------------------------------------------------------
//Event triggers when the player turn begins but only when loading from a save
//-----------------------------------------------------------
class SeqEvent_OnPlayerLoadedFromSave extends SequenceEvent;

event Activated()
{
}

static function FireEvent( )
{
	local array<SequenceObject> Events;
	local SeqEvent_OnPlayerLoadedFromSave Event;
	local Sequence GameSeq;
	local int Index;

	// Get the gameplay sequence.
	GameSeq = class'WorldInfo'.static.GetWorldInfo().GetGameSequence();
	if (GameSeq == None) return;

	GameSeq.FindSeqObjectsByClass(class'SeqEvent_OnPlayerLoadedFromSave', true, Events);
	for (Index = 0; Index < Events.length; ++Index)
	{
		Event = SeqEvent_OnPlayerLoadedFromSave(Events[Index]);
		`assert(Event != None);

		Event.CheckActivate( class'WorldInfo'.static.GetWorldInfo(), none );
	}
}

defaultproperties
{
	ObjCategory="Save/Load"
	ObjName="On Player Loaded From Save"
	bPlayerOnly=FALSE
	MaxTriggerCount=0

	bConvertedForReplaySystem=true

	OutputLinks(0)=(LinkDesc="Out")
}
