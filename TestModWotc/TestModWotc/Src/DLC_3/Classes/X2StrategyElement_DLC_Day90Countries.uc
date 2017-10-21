//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DLC_Day90Countries.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_DLC_Day90Countries extends X2StrategyElement
	dependson(X2CountryTemplate, XGCharacterGenerator);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Countries;

	Countries.AddItem(CreateSparkTemplate());

	return Countries;
}

static function X2DataTemplate CreateSparkTemplate()
{
	local X2CountryTemplate Template;
	
	`CREATE_X2TEMPLATE(class'X2CountryTemplate', Template, 'Country_Spark');
	Template.bHideInCustomization = true;

	return Template;
}