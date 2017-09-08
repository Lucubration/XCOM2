//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_ExpandLocalizedString.uc
//  AUTHOR:  Russell Aasland  --  2/9/2017
//  PURPOSE: Expands a localized string to include specified values at string tags
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_ExpandLocalizedString extends SequenceAction;

var string OutputString;

var() string Message;

var() string StringTag0;
var() string StringTag1;
var() string StringTag2;

var() int IntTag0;
var() int IntTag1;
var() int IntTag2;

event Activated()
{
	local XGParamTag Tag;

	if (Message != "")
	{
		Tag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));

		Tag.StrValue0 = StringTag0;
		Tag.StrValue1 = StringTag1;
		Tag.StrValue2 = StringTag2;

		Tag.IntValue0 = IntTag0;
		Tag.IntValue1 = IntTag1;
		Tag.IntValue2 = IntTag2;

		OutputString = `XEXPAND.ExpandString( Message );
	}
}

defaultproperties
{
	ObjCategory="UI/Input"
	ObjName="Expand Localized String"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	bAutoActivateOutputLinks=true
	OutputLinks(0)=(LinkDesc="Out")

	VariableLinks(0)=(ExpectedType=class'SeqVar_String',LinkDesc="Message",PropertyName=Message)

	VariableLinks(1)=(ExpectedType=class'SeqVar_String',LinkDesc="String Tag 0",PropertyName=StringTag0)
	VariableLinks(2)=(ExpectedType=class'SeqVar_String',LinkDesc="String Tag 1",PropertyName=StringTag1)
	VariableLinks(3)=(ExpectedType=class'SeqVar_String',LinkDesc="String Tag 2",PropertyName=StringTag2)

	VariableLinks(4)=(ExpectedType=class'SeqVar_Int',LinkDesc="Integer Tag 0",PropertyName=IntTag0)
	VariableLinks(5)=(ExpectedType=class'SeqVar_Int',LinkDesc="Integer Tag 1",PropertyName=IntTag1)
	VariableLinks(6)=(ExpectedType=class'SeqVar_Int',LinkDesc="Integer Tag 2",PropertyName=IntTag2)

	VariableLinks(7)=(ExpectedType=class'SeqVar_String',LinkDesc="Output String",PropertyName=OutputString,bWriteable=true)

	StringTag0="Uninitialized"
	StringTag1="Uninitialized"
	StringTag2="Uninitialized"

	IntTag0=-1
	IntTag1=-1
	IntTag2=-1
}