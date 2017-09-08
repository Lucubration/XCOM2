//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XComAnimNotify_RunStopAlternative extends AnimNotify
	native(Animation);

cpptext
{
	// AnimNotify interface.
	virtual FString GetEditorComment() { return "Run Stop Alternative"; }
	virtual FColor GetEditorColor() { return FColor(0,128,255); }
}
