//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DefaultChosenPersonalities.uc
//  AUTHOR:  Mark Nauta  --  04/27/2016
//  PURPOSE: Creating the X2AdventChosenPersonalityTemplates 
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_DefaultChosenPersonalities extends X2StrategyElement
	dependson(X2AdventChosenPersonalityTemplate)
	config(GameData);

var config array<name> Personalities;

//---------------------------------------------------------------------------------------
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	local X2AdventChosenPersonalityTemplate Template;
	local name PersonalityName;

	foreach default.Personalities(PersonalityName)
	{
		`CREATE_X2TEMPLATE(class'X2AdventChosenPersonalityTemplate', Template, PersonalityName);
		Templates.AddItem(Template);
	}

	return Templates;
}