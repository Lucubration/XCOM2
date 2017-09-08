//-----------------------------------------------------------
//  FILE:    SeqAct_GetVectorListSize.uc
//  AUTHOR:  James Brawley  --  6/27/2016
//  PURPOSE: Gets the length of a vector list and returns it to kismet as an int
// 
//-----------------------------------------------------------
class SeqAct_GetVectorListSize extends SeqAct_SetSequenceVariable;

var int iListSize;

event Activated()
{
	local SeqVar_VectorList List;

	foreach LinkedVariables(class'SeqVar_VectorList',List,"Vector List")
	{
		break;
	}

	iListSize = List.arrVectors.Length;
}

defaultproperties
{
	ObjName="Get VectorList Size"
	ObjCategory="Variable Lists"
	ObjColor=(R=255,G=0,B=255,A=255)

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_VectorList',LinkDesc="Vector List",bWriteable=false, MinVars=1, MaxVars=1)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Int',LinkDesc="Size", bWriteable=true, PropertyName=iListSize)
}