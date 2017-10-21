/**
 * 
 */
class SeqAct_AccessVectorList extends SeqAct_SetSequenceVariable;

var vector vOutput;
var int iIndex;

event Activated()
{
	local SeqVar_VectorList VectorList;

	foreach LinkedVariables(class'SeqVar_VectorList',VectorList,"Vector List")
	{
		if(InputLinks[0].bHasImpulse)
		{
			if(VectorList.arrVectors.Length > 0)
			{
				vOutput = VectorList.arrVectors[Rand(VectorList.arrVectors.Length)];
			}
		}
		else if(InputLinks[1].bHasImpulse)
		{
			if(VectorList.arrVectors.Length > 0)
			{
				vOutput = VectorList.arrVectors[0];
			}
		}
		else if(InputLinks[2].bHasImpulse)
		{
			if(VectorList.arrVectors.Length > 0)
			{
				vOutput = VectorList.arrVectors[VectorList.arrVectors.Length-1];
			}
		}
		else if(InputLinks[3].bHasImpulse)
		{
			if(VectorList.arrVectors.Length > iIndex)
			{
				vOutput = VectorList.arrVectors[iIndex];
			}
		}
	}
}

defaultproperties
{
	ObjName="Access VectorList"
	ObjCategory="Variable Lists"
	ObjColor=(R=255,G=0,B=255,A=255)

	InputLinks(0)=(LinkDesc="Random")
	InputLinks(1)=(LinkDesc="First")
	InputLinks(2)=(LinkDesc="Last")
	InputLinks(3)=(LinkDesc="At Index")

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_VectorList',LinkDesc="Vector List",bWriteable=false,MinVars=1,MaxVars=1)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Int',LinkDesc="Index",bWriteable=FALSE,PropertyName=iIndex)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Output Vector",bWriteable=true,PropertyName=vOutput)
	
}