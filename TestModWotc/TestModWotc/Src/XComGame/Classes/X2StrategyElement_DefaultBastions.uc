//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DefaultBastions.uc
//  AUTHOR:  Mark Nauta  --  04/26/2016
//  PURPOSE: Creating the X2BastionTemplates 
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_DefaultBastions extends X2StrategyElement
	dependson(X2BastionTemplate)
	config(GameBoard);

var config array<name> Bastions;

//---------------------------------------------------------------------------------------
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	local X2BastionTemplate Template;
	local name BastionName;

	foreach default.Bastions(BastionName)
	{
		`CREATE_X2TEMPLATE(class'X2BastionTemplate', Template, BastionName);
		Templates.AddItem(Template);
	}

	return Templates;
}