/**
 *
 */
class AnimNotify_AkEvent extends AnimNotify
	native(Anim);

var()	AkEvent		AkEvent;
var()	bool		bFollowActor;
var()	Name		BoneName;

cpptext
{
	// AnimNotify interface.
	virtual void Notify( class UAnimNodeSequence* NodeSeq );
	virtual FString GetEditorComment();
	virtual FColor GetEditorColor() { return FColor(0,255,0); }
}

defaultproperties
{
	bFollowActor=true
}
