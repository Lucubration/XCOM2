//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DefaultCovertActionNarratives.uc
//  AUTHOR:  Joe Weinhoffer--  07/27/2016
//  PURPOSE: Creating the X2CovertActionNarrative Templates
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_DefaultCovertActionNarratives extends X2StrategyElement
	config(GameBoard);

var config array<name> CovertActionNarratives;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	local X2CovertActionNarrativeTemplate Template;
	local name NarrativeName;

	foreach default.CovertActionNarratives(NarrativeName)
	{
		`CREATE_X2TEMPLATE(class'X2CovertActionNarrativeTemplate', Template, NarrativeName);
		Templates.AddItem(Template);
	}

	return Templates;
}