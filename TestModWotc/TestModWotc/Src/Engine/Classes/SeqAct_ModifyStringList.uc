/**
 * 
 */
class SeqAct_ModifyStringList extends SeqAct_SetSequenceVariable;

var() String sInput;

event Activated()
{
	local SeqVar_StringList StringList;

	foreach LinkedVariables(class'SeqVar_StringList',StringList,"String List")
	{
		if(InputLinks[0].bHasImpulse)
		{
			StringList.arrStrings.AddItem(sInput);
		}
		else if(InputLinks[1].bHasImpulse)
		{
			StringList.arrStrings.RemoveItem(sInput);
		}
		else if(InputLinks[2].bHasImpulse)
		{
			StringList.arrStrings.Remove(0, StringList.arrStrings.Length);
		}
	}
}

defaultproperties
{
	ObjName="Modify StringList"
	ObjCategory="Variable Lists"
	ObjColor=(R=255,G=0,B=255,A=255)

	InputLinks(0)=(LinkDesc="Add To List")
	InputLinks(1)=(LinkDesc="Remove From List")
	InputLinks(2)=(LinkDesc="Empty List")

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_String',LinkDesc="StringRef",PropertyName=sInput)
	VariableLinks(1)=(ExpectedType=class'SeqVar_StringList',LinkDesc="String List",bWriteable=true)
}