//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XComAnimNotify_RunStopStandard extends AnimNotify
	native(Animation);

cpptext
{
	// AnimNotify interface.
	virtual FString GetEditorComment() { return "Run Stop Standard"; }
	virtual FColor GetEditorColor() { return FColor(0,128,255); }
}
