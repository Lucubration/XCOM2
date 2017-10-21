/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqCond_CompareString extends SequenceCondition
	native(Sequence);

cpptext
{
	void Activated()
	{
		// compare the values and set appropriate output impulse
		const UBOOL IsEqual = ValueA == ValueB;

		OutputLinks(0).bHasImpulse = IsEqual;
		OutputLinks(1).bHasImpulse = !IsEqual;
	}
};

var() string ValueA;

var() string ValueB;

defaultproperties
{
	ObjName="Compare String"
	ObjCategory="Comparison"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	InputLinks(0)=(LinkDesc="In")
	OutputLinks(0)=(LinkDesc="A == B")
	OutputLinks(1)=(LinkDesc="A != B")

	VariableLinks(0)=(ExpectedType=class'SeqVar_String',LinkDesc="A",PropertyName=ValueA)
	VariableLinks(1)=(ExpectedType=class'SeqVar_String',LinkDesc="B",PropertyName=ValueB)
}
