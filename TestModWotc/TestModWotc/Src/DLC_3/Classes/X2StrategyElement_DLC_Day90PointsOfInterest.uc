//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DLC_Day90PointsOfInterest.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_DLC_Day90PointsOfInterest extends X2StrategyElement
	dependson(X2PointOfInterestTemplate);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreatePOILostTowersTemplate());

	return Templates;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreatePOILostTowersTemplate()
{
	local X2PointOfInterestTemplate Template;

	`CREATE_X2POINTOFINTEREST_TEMPLATE(Template, 'POI_LostTowers');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);
	Template.bNeverExpires = true;
	Template.POIClass = class'XComGameState_PointOfInterestLostTowers';

	return Template;
}