//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_PlayUIDistortion.uc
//  AUTHOR:  James Brawley
//  PURPOSE: Triggers the UI distortion effect used by grenades
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_PlayUIDistortion extends SequenceAction;

// Duration of the distortion
var() float DistortionDuration;

event Activated()
{
	`PRES.StartDistortUI(DistortionDuration);
}

defaultproperties
{
	ObjCategory="UI"
	ObjName="Play UI Distortion"
	bCallHandler = false

	DistortionDuration = 2.5

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_Float',LinkDesc="Duration",PropertyName=DistortionDuration)
}