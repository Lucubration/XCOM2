//-----------------------------------------------------------
//  FILE:    SeqAct_GetObjectActorLocation.uc
//  AUTHOR:  James Brawley  --  6/27/2016
//  PURPOSE: Gets the location of an interactive object's InteractiveLevelActor
//			 This is different from the Interactive Object's location which is specific to the tile and may not match
// 
//-----------------------------------------------------------
class SeqAct_GetObjectActorLocation extends SequenceAction;

var Vector Location;
var XComGameState_InteractiveObject InteractiveObject;

event Activated()
{
local XComInteractiveLevelActor VisActor;

	if (InteractiveObject != none)
	{
		// add in any modifier from the actor
		VisActor = XComInteractiveLevelActor(InteractiveObject.GetVisualizer());
		Location = VisActor.Location;
	}
	else
	{
		`Redscreen("SeqAct_GetObjectActorLocation: Called without an Interactive Object input");
	}
}

defaultproperties
{
	ObjCategory="Interactive Object"
	ObjName="Get Interactive Object Level Actor Location"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
	
	bAutoActivateOutputLinks=true
	OutputLinks(0)=(LinkDesc="Out")

	VariableLinks(0)=(ExpectedType=class'SeqVar_InteractiveObject',LinkDesc="Object",PropertyName=InteractiveObject)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Location",PropertyName=Location,bWriteable=TRUE)
}
