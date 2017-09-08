class AnimNotify_FireGrapple extends AnimNotify
	native(Animation);

cpptext
{
	// AnimNotify interface.
	virtual void Notify( class UAnimNodeSequence* NodeSeq );
	virtual FString GetEditorComment() { return TEXT("Fire Grapple"); }
}

defaultproperties
{
	
}
