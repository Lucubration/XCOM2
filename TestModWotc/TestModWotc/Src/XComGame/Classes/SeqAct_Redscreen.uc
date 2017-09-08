///---------------------------------------------------------------------------------------
//  FILE:    SeqAct_Redscreen.uc
//  AUTHOR:  James Brawley -- 11/16/2016
//  PURPOSE: Send a redscreen to the system from Kismet
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_Redscreen extends SequenceAction;

var() string ErrorText; // Message to send to redscreen system

event Activated()
{
	`Redscreen("Kismet Error: " $ ErrorText);
}

defaultproperties
{
	ObjName="Redscreen"
	ObjCategory="Debug"
	bCallHandler=false;

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	ErrorText="Unspecified Kismet Error"

	VariableLinks.Empty
}


