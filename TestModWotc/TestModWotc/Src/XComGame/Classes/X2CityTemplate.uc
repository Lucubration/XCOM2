//---------------------------------------------------------------------------------------
//  FILE:    X2CityTemplate.uc
//  AUTHOR:  Mark Nauta
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2CityTemplate extends X2StrategyElementTemplate config(GameBoard);

var config Vector		  Location;
var config name			  Region;
var config bool			  bAdventMadeCity; // Fills out map, generated name, always city center

var localized string      DisplayName;
var localized string      PoiText;

//---------------------------------------------------------------------------------------
function XComGameState_City CreateInstanceFromTemplate(XComGameState NewGameState)
{
	local XComGameState_City CityState;

	CityState = XComGameState_City(NewGameState.CreateNewStateObject(class'XComGameState_City', self));
	return CityState;
}

//---------------------------------------------------------------------------------------
DefaultProperties
{
}