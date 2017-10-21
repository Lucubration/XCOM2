//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DLC_Day60MissionSiteDescriptions.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_DLC_Day60MissionSiteDescriptions extends X2StrategyElement;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateDerelictFacilityTemplate());

	return Templates;
}

static function X2DataTemplate CreateDerelictFacilityTemplate()
{
	local X2MissionSiteDescriptionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2MissionSiteDescriptionTemplate', Template, 'DerelictFacility');

	Template.GetMissionSiteDescriptionFn = GetDerelictFacilityMissionSiteDescription;

	return Template;
}

static function string GetDerelictFacilityMissionSiteDescription(string BaseString, XComGameState_MissionSite MissionSite)
{
	local string OutputString;

	OutputString = BaseString;

	return OutputString;
}