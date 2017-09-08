//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DefaultResistanceFactions.uc
//  AUTHOR:  Mark Nauta  --  04/29/2016
//  PURPOSE: Creating the X2ResistanceFactionTemplates
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_DefaultResistanceFactions extends X2StrategyElement
	config(GameBoard);

var config array<name> Factions;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	local X2ResistanceFactionTemplate Template;
	local name FactionName;

	foreach default.Factions(FactionName)
	{
		`CREATE_X2TEMPLATE(class'X2ResistanceFactionTemplate', Template, FactionName);
		Templates.AddItem(Template);
	}

	return Templates;
}