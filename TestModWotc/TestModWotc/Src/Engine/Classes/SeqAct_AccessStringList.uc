/**
 * 
 */
class SeqAct_AccessStringList extends SeqAct_SetSequenceVariable;

var String sOutput;
var int iIndex;

event Activated()
{
	local SeqVar_StringList StringList;

	foreach LinkedVariables(class'SeqVar_StringList',StringList,"String List")
	{
		if(InputLinks[0].bHasImpulse)
		{
			if(StringList.arrStrings.Length > 0)
			{
				sOutput = StringList.arrStrings[Rand(StringList.arrStrings.Length)];
			}
		}
		else if(InputLinks[1].bHasImpulse)
		{
			if(StringList.arrStrings.Length > 0)
			{
				sOutput = StringList.arrStrings[0];
			}
		}
		else if(InputLinks[2].bHasImpulse)
		{
			if(StringList.arrStrings.Length > 0)
			{
				sOutput = StringList.arrStrings[StringList.arrStrings.Length-1];
			}
		}
		else if(InputLinks[3].bHasImpulse)
		{
			if(StringList.arrStrings.Length > iIndex)
			{
				sOutput = StringList.arrStrings[iIndex];
			}
		}
	}
}

defaultproperties
{
	ObjName="Access StringList"
	ObjCategory="Variable Lists"
	ObjColor=(R=255,G=0,B=255,A=255)

	InputLinks(0)=(LinkDesc="Random")
	InputLinks(1)=(LinkDesc="First")
	InputLinks(2)=(LinkDesc="Last")
	InputLinks(3)=(LinkDesc="At Index")

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_StringList',LinkDesc="String List",bWriteable=false,MinVars=1,MaxVars=1)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Int',LinkDesc="Index",bWriteable=FALSE,PropertyName=iIndex)
	VariableLinks(2)=(ExpectedType=class'SeqVar_String',LinkDesc="Output String",bWriteable=true,PropertyName=sOutput)
	
}