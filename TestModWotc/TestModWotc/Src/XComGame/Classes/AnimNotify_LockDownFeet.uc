//---------------------------------------------------------------------------------------
//
//---------------------------------------------------------------------------------------
class AnimNotify_LockDownFeet extends AnimNotify
	native(Animation);

var() private bool Locked;

cpptext
{
	// AnimNotify interface.
	virtual void Notify( class UAnimNodeSequence* NodeSeq );
	virtual FString GetEditorComment();
	virtual FColor GetEditorColor(){ return FColor(0,128,255); }
}

defaultproperties
{
	Locked = true;
}