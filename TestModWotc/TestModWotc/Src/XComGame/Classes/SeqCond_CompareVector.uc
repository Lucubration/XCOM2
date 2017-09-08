//-----------------------------------------------------------
//  FILE:    SeqCond_CompareVector.uc
//  AUTHOR:  James Brawley  --  6/27/2016
//  PURPOSE: Compares the value of two kismet vectors
// 
//-----------------------------------------------------------
class SeqCond_CompareVector extends SequenceCondition;

var Vector A;
var Vector B;

event Activated()
{
	OutputLinks[0].bHasImpulse = false;
	OutputLinks[1].bHasImpulse = false;

	if(A == B)
	{
		OutputLinks[0].bHasImpulse = true;
	}
	else
	{
		OutputLinks[1].bHasImpulse = true;
	}
}

defaultproperties
{
	ObjName="Compare Vectors"
	ObjCategory="Comparison"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	InputLinks(0)=(LinkDesc="In")
	OutputLinks(0)=(LinkDesc="A == B")
	OutputLinks(1)=(LinkDesc="A != B")

	VariableLinks(0)=(ExpectedType=class'SeqVar_Vector',LinkDesc="A",PropertyName=A)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Vector',LinkDesc="B",PropertyName=B)
}
