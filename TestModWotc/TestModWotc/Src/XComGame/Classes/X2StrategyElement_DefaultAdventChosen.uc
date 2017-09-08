//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DefaultAdventChosen.uc
//  AUTHOR:  Mark Nauta  --  11/14/2016
//  PURPOSE: Creating the X2AdventChosenTemplates
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_DefaultAdventChosen extends X2StrategyElement
	config(GameData);

var config array<name> Chosen;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	local X2AdventChosenTemplate Template;
	local name ChosenName;

	foreach default.Chosen(ChosenName)
	{
		`CREATE_X2TEMPLATE(class'X2AdventChosenTemplate', Template, ChosenName);
		Templates.AddItem(Template);
	}

	return Templates;
}