//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DLC_Day90MissionSiteDescriptions.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_DLC_Day90MissionSiteDescriptions extends X2StrategyElement;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateLostTowerTemplate());

	return Templates;
}

static function X2DataTemplate CreateLostTowerTemplate()
{
	local X2MissionSiteDescriptionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2MissionSiteDescriptionTemplate', Template, 'LostTower');

	Template.GetMissionSiteDescriptionFn = GetLostTowerMissionSiteDescription;

	return Template;
}

static function string GetLostTowerMissionSiteDescription(string BaseString, XComGameState_MissionSite MissionSite)
{
	local string OutputString;

	OutputString = BaseString;

	return OutputString;
}