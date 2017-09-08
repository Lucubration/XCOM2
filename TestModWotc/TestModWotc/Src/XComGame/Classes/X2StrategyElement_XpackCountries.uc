//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DefaultCountries.uc
//  AUTHOR:  Mark Nauta
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_XpackCountries extends X2StrategyElement_DefaultCountries
	dependson(X2CountryTemplate, XGCharacterGenerator);

var localized array<string> m_arrSkMFirstNames;
var localized array<string> m_arrSkFFirstNames;
var localized array<string> m_arrSkLastNames;

//---------------------------------------------------------------------------------------
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Countries;

	Countries.AddItem(CreateReaperTemplate());
	Countries.AddItem(CreateTemplarTemplate());
	Countries.AddItem(CreateSkirmisherTemplate());

	return Countries;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateReaperTemplate()
{
	local X2CountryTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CountryTemplate', Template, 'Country_Reaper');

	Template.bHideInCustomization = true;

	return Template;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateTemplarTemplate()
{
	local X2CountryTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CountryTemplate', Template, 'Country_Templar');

	Template.bHideInCustomization = true;

	return Template;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateSkirmisherTemplate()
{
	local X2CountryTemplate Template;
	local CountryNames NameStruct;

	`CREATE_X2TEMPLATE(class'X2CountryTemplate', Template, 'Country_Skirmisher');

	NameStruct.MaleNames = default.m_arrSkMFirstNames;
	NameStruct.FemaleNames = default.m_arrSkFFirstNames;
	NameStruct.MaleLastNames = default.m_arrSkLastNames;
	NameStruct.FemaleLastNames = default.m_arrSkLastNames;
	NameStruct.PercentChance = 100;
	Template.Names.AddItem(NameStruct);

	Template.bHideInCustomization = true;

	return Template;
}