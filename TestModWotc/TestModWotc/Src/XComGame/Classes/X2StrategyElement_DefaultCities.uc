//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DefaultCities.uc
//  AUTHOR:  Mark Nauta
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_DefaultCities extends X2StrategyElement config(GameBoard);

var config array<name> Cities;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	local X2CityTemplate Template;
	local name CityName;

	foreach default.Cities(CityName)
	{
		`CREATE_X2TEMPLATE(class'X2CityTemplate', Template, CityName);
		Templates.AddItem(Template);
	}

	return Templates;
}
