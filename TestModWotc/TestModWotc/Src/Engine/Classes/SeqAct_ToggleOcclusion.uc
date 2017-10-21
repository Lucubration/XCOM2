/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ToggleOcclusion extends SequenceAction
	native(Sequence);

cpptext
{
	virtual void Activated();
};


defaultproperties
{
	ObjName="Toggle Occlusion"
	ObjCategory="Toggle"

	InputLinks(0)=(LinkDesc="Turn On")
	InputLinks(1)=(LinkDesc="Turn Off")
	InputLinks(2)=(LinkDesc="Toggle")
}
