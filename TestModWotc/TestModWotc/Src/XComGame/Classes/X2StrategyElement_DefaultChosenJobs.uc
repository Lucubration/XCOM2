//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DefaultChosenJobs.uc
//  AUTHOR:  Mark Nauta  --  04/27/2016
//  PURPOSE: Creating the X2AdventChosenJobTemplates and defining delegate functions.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_DefaultChosenJobs extends X2StrategyElement;

//---------------------------------------------------------------------------------------
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateButcherTemplate());
	Templates.AddItem(CreateSpiderTemplate());
	Templates.AddItem(CreateAbductorTemplate());
	Templates.AddItem(CreateResearcherTemplate());

	return Templates;
}

//---------------------------------------------------------------------------------------
static function X2AdventChosenJobTemplate CreateButcherTemplate()
{
	local X2AdventChosenJobTemplate Template;

	`CREATE_X2TEMPLATE(class'X2AdventChosenJobTemplate', Template, 'ChosenJob_Butcher');

	return Template;
}

//---------------------------------------------------------------------------------------
static function X2AdventChosenJobTemplate CreateSpiderTemplate()
{
	local X2AdventChosenJobTemplate Template;

	`CREATE_X2TEMPLATE(class'X2AdventChosenJobTemplate', Template, 'ChosenJob_Spider');

	return Template;
}

//---------------------------------------------------------------------------------------
static function X2AdventChosenJobTemplate CreateAbductorTemplate()
{
	local X2AdventChosenJobTemplate Template;

	`CREATE_X2TEMPLATE(class'X2AdventChosenJobTemplate', Template, 'ChosenJob_Abductor');

	return Template;
}

//---------------------------------------------------------------------------------------
static function X2AdventChosenJobTemplate CreateResearcherTemplate()
{
	local X2AdventChosenJobTemplate Template;

	`CREATE_X2TEMPLATE(class'X2AdventChosenJobTemplate', Template, 'ChosenJob_Researcher');

	return Template;
}