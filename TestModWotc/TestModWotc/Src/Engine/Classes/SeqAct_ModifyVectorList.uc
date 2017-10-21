/**
 * 
 */
class SeqAct_ModifyVectorList extends SeqAct_SetSequenceVariable;

var() vector vInput;

event Activated()
{
	local SeqVar_VectorList VectorList;

	foreach LinkedVariables(class'SeqVar_VectorList',VectorList,"Vector List")
	{
		if(InputLinks[0].bHasImpulse)
		{
			VectorList.arrVectors.AddItem(vInput);
		}
		else if(InputLinks[1].bHasImpulse)
		{
			VectorList.arrVectors.RemoveItem(vInput);
		}
		else if(InputLinks[2].bHasImpulse)
		{
			VectorList.arrVectors.Remove(0, VectorList.arrVectors.Length);
		}
	}
}

defaultproperties
{
	ObjName="Modify VectorList"
	ObjCategory="Variable Lists"
	ObjColor=(R=255,G=0,B=255,A=255)

	InputLinks(0)=(LinkDesc="Add To List")
	InputLinks(1)=(LinkDesc="Remove From List")
	InputLinks(2)=(LinkDesc="Empty List")

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_Vector',LinkDesc="VectorRef",PropertyName=vInput)
	VariableLinks(1)=(ExpectedType=class'SeqVar_VectorList',LinkDesc="Vector List",bWriteable=true)
}