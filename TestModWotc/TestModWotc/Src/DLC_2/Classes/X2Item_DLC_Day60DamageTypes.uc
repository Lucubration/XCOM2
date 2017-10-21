//---------------------------------------------------------------------------------------
//  FILE:    X2Item_DLC_Day60DamageTypes.uc
//  AUTHOR:  Joshua Bouscher
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Item_DLC_Day60DamageTypes extends X2Item;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> DamageTypes;

	DamageTypes.AddItem(CreateFrostDamageType());

	return DamageTypes;
}

static function X2DamageTypeTemplate CreateFrostDamageType()
{
	local X2DamageTypeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DamageTypeTemplate', Template, 'Frost');

	Template.bCauseFracture = false;
	Template.MaxFireCount = 0;
	Template.bAllowAnimatedDeath = true;

	return Template;
}