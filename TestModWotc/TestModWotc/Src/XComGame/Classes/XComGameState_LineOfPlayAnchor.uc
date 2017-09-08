//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_LineOfPlayAnchor.uc
//  AUTHOR:  David Burchanowski  --  11/8/2016
//  PURPOSE: Allows the end point of the "line of play" in the game to be overridden. This is
//           normally the centerpoint of all objectives in the map, but attaching an instance of
//           this class to an object (or objects) will make it the endpoint of the line of play instead.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class XComGameState_LineOfPlayAnchor extends XComGameState_BaseObject
	native(Core);

defaultproperties
{
	bTacticalTransient=true
}