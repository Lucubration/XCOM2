//---------------------------------------------------------------------------------------
//  FILE:    X2AbilityPointTemplate.uc
//  AUTHOR:  Russell Aasland
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2AbilityPointTemplate extends X2EventListenerTemplate
	config(GameCore)
	native(Core);

var localized string ActionFriendlyName; // short name of the action, e.g. "Height Advantage Shot"

var const config int NumPointsAwarded;
var const config bool TacticalEvent;
var const config int Chance;

defaultproperties
{
	RegisterInTactical=true
}