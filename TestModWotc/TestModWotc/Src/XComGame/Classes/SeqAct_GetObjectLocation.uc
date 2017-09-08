//-----------------------------------------------------------
//  FILE:    SeqAct_GetObjectLocation.uc
//  AUTHOR:  James Brawley  --  6/27/2016
//  PURPOSE: Gets the location of an interactive object as a vector
// 
//-----------------------------------------------------------
class SeqAct_GetObjectLocation extends SequenceAction;

var Vector Location;
var XComGameState_InteractiveObject InteractiveObject;

event Activated()
{
	local TTile Tile;

	if (InteractiveObject != none)
	{
		`log("Get location of IO");
		Tile =  InteractiveObject.TileLocation;
		Location = class'XComWorldData'.static.GetWorldData().GetPositionFromTileCoordinates(Tile);
	}
	else
	{
		`log("No IO passed to node");
	}
}

defaultproperties
{
	ObjCategory="Interactive Object"
	ObjName="Get Object Location"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
	
	bAutoActivateOutputLinks=true
	OutputLinks(0)=(LinkDesc="Out")

	VariableLinks(0)=(ExpectedType=class'SeqVar_InteractiveObject',LinkDesc="Object",PropertyName=InteractiveObject)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Location",PropertyName=Location,bWriteable=TRUE)
}
