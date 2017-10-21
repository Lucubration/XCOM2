//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DLC_Day60PointsOfInterest.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_DLC_Day60PointsOfInterest extends X2StrategyElement
	dependson(X2PointOfInterestTemplate);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreatePOIHunterWeaponsTemplate());
	Templates.AddItem(CreatePOIAlienNestTemplate());

	return Templates;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreatePOIHunterWeaponsTemplate()
{
	local X2PointOfInterestTemplate Template;

	`CREATE_X2POINTOFINTEREST_TEMPLATE(Template, 'POI_HunterWeapons');
	Template.bNeverExpires = true;
	Template.POIClass = class'XComGameState_PointOfInterestHunterWeapons';

	return Template;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreatePOIAlienNestTemplate()
{
	local X2PointOfInterestTemplate Template;

	`CREATE_X2POINTOFINTEREST_TEMPLATE(Template, 'POI_AlienNest');
	Template.bNeverExpires = true;
	Template.POIClass = class'XComGameState_PointOfInterestAlienNest';

	return Template;
}