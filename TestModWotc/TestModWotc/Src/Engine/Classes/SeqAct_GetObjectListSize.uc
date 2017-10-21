/**
 * 
 */
class SeqAct_GetObjectListSize extends SeqAct_SetSequenceVariable;

var int iListSize;

event Activated()
{
	local SeqVar_ObjectList List;

	foreach LinkedVariables(class'SeqVar_ObjectList',List,"Object List")
	{
		break;
	}

	iListSize = List.ObjList.Length;
}

defaultproperties
{
	ObjName="Get ObjectList Size"
	ObjCategory="Variable Lists"
	ObjColor=(R=255,G=0,B=255,A=255)

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_ObjectList',LinkDesc="Object List",bWriteable=false, MinVars=1, MaxVars=1)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Int',LinkDesc="Size", bWriteable=true, PropertyName=iListSize)
}