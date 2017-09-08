//---------------------------------------------------------------------------------------
//  FILE:    X2BastionTemplate.uc
//  AUTHOR:  Mark Nauta  --  04/26/2016
//  PURPOSE: This object represents the immutable data for a Bastion on the world map 
//           in the XCOM 2 strategy game
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2BastionTemplate extends X2StrategyElementTemplate config(GameBoard);


var config string		PlotType; // Plot type if a mission is spawned here
var config string		MeshPath; // 3D Icon on world map

// Loc vars
var localized string	DisplayName;
var localized string	TooltipText;

//---------------------------------------------------------------------------------------
function XComGameState_Bastion CreateInstanceFromTemplate(XComGameState NewGameState)
{
	local XComGameState_Bastion BastionState;

	BastionState = XComGameState_Bastion(NewGameState.CreateNewStateObject(class'XComGameState_Bastion', self));

	return BastionState;
}

//---------------------------------------------------------------------------------------
DefaultProperties
{
}