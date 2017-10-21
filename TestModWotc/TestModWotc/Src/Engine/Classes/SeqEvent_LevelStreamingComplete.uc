/**
 * FIRAXIS GAMES - Marc Giordano
 *
 * This event will be fired the first time that all streaming levels
 * have been loaded into the world. It is primarily used for notifying
 * the game core that the initial level generation is complete.
 *
 **/
class SeqEvent_LevelStreamingComplete extends SequenceEvent
	native(Sequence);

DefaultProperties
{
    ObjName="Level Streaming Complete";
	ObjCategory="Level";
	bPlayerOnly=FALSE;
	MaxTriggerCount=1;
}
