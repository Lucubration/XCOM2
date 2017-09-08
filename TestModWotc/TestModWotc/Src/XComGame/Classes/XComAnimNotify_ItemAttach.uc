//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XComAnimNotify_ItemAttach extends AnimNotify
	native(Animation);

var() Name FromSocket;
var() Name ToSocket;

enum XComAnimNotify_ItemAttachType
{
	eIAT_None,
	eIAT_Show,
	eIAT_Hide
};

var() XComAnimNotify_ItemAttachType AttachVisibility;

cpptext
{
	// AnimNotify interface.
	virtual void Notify( class UAnimNodeSequence* NodeSeq );
	virtual FString GetEditorComment() { return "Item Attach"; }
	virtual FColor GetEditorColor() { return FColor(0,128,255); }
}

defaultproperties
{
	AttachVisibility=eIAT_None
}