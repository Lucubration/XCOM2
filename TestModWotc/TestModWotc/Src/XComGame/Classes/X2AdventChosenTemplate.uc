//---------------------------------------------------------------------------------------
//  FILE:    X2AdventChosenTemplate.uc
//  AUTHOR:  Mark Nauta  --  04/29/2016
//  PURPOSE: This object represents immutable data about the ADVENT Chosen
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2AdventChosenTemplate extends X2StrategyElementTemplate
	config(GameData);

// Chosen appearance data
var config array<string> BackgroundImages;
var config array<string> ForegroundImages;
var config string OverworldMeshPath;
var config array<string> ChosenImages;
var config string ChosenPoster;
var config array<string> HuntChosenImages;
var config string FanfareEvent;
var config name AvengerAssaultEvent;
var config name AvengerAssaultCommentEvent;
var config name AmbushCommentEvent;
var config name CancelledActivityEvent;
var config name FavoredGeoscapeEvent;
var config name RevealLocationEvent;
var config name MetEvent;
var config name RegionContactedEvent;
var config name RetributionEvent;
var config name SabotageSuccessEvent;
var config name SabotageFailedEvent;
var config name SoldierCapturedEvent;
var config name SoldierRescuedEvent;
var config name DarkEventCompleteEvent;
var config name RetaliationEvent;
var config name ThresholdTwoEvent;
var config name ThresholdThreeEvent;
var config name ThresholdFourEvent;
var config name LeveledUpEvent;
var config name KilledEvent;
var config name ElderRageEvent;

// Progression data
var config ChosenInformation ChosenProgressionData;

// Non-Random Title of the Chosen
var localized string ChosenTitle;
var localized string ChosenTitleWithArticle;

// For Chosen name generation
var localized array<string> FirstNamePrefixes;
var localized array<string> FirstNameSuffixes;
var localized array<string> LastNames;
var localized array<string> NicknamePrefixes;
var localized array<string> NicknameSuffixes;

// User interface icon options
var config StackedUIIconData ChosenIconData;

//Possible images to use in generating the icons 
var config array<string> ChosenIconInformation_Layer0;
var config array<string> ChosenIconInformation_Layer1;
var config array<string> ChosenIconInformation_Layer2;

//Displayed in the UI resistance report headers. 
var config name ResistanceReportTag;
var config name ResistanceReportMIC;

//---------------------------------------------------------------------------------------
function GenerateName(out string FirstName, out string LastName, out string Nickname)
{
	FirstName = FirstNamePrefixes[`SYNC_RAND(FirstNamePrefixes.Length)] $ "-" $ FirstNameSuffixes[`SYNC_RAND(FirstNameSuffixes.Length)];
	LastName = LastNames[`SYNC_RAND(LastNames.Length)];
	NickName = NicknamePrefixes[`SYNC_RAND(NicknamePrefixes.Length)] $ NicknameSuffixes[`SYNC_RAND(NicknameSuffixes.Length)];
}

function StackedUIIconData GenerateChosenIcon()
{
	local array<string> Newinfo; 

	if( ChosenIconInformation_Layer0.Length > 0 )
	{
		Newinfo.AddItem(ChosenIconInformation_Layer0[`SYNC_RAND(ChosenIconInformation_Layer0.Length)]);
	}
	if( ChosenIconInformation_Layer1.Length > 0 )
	{
		Newinfo.AddItem(ChosenIconInformation_Layer1[`SYNC_RAND(ChosenIconInformation_Layer1.Length)]);
	}
	if( ChosenIconInformation_Layer2.Length > 0 )
	{
		Newinfo.AddItem(ChosenIconInformation_Layer2[`SYNC_RAND(ChosenIconInformation_Layer2.Length)]);
	}
	ChosenIconData.Images = Newinfo;
	ChosenIconData.bInvert = false; //NEVER INVERT

	return ChosenIconData;
}

//---------------------------------------------------------------------------------------
function name GetProgressionTemplate(int ChosenLevel)
{
	if(ChosenProgressionData.CharTemplates.Length == 0)
	{
		return '';
	}

	if(ChosenLevel < 0)
	{
		return ChosenProgressionData.CharTemplates[0];
	}
	else if(ChosenLevel >= ChosenProgressionData.CharTemplates.Length)
	{
		return ChosenProgressionData.CharTemplates[ChosenProgressionData.CharTemplates.Length - 1];
	}
	else
	{
		return ChosenProgressionData.CharTemplates[ChosenLevel];
	}
}

//---------------------------------------------------------------------------------------
function name GetSpawningTag(int ChosenLevel)
{
	if(ChosenProgressionData.SpawningTags.Length == 0)
	{
		return '';
	}

	if(ChosenLevel < 0)
	{
		return ChosenProgressionData.SpawningTags[0];
	}
	else if(ChosenLevel >= ChosenProgressionData.SpawningTags.Length)
	{
		return ChosenProgressionData.SpawningTags[ChosenProgressionData.SpawningTags.Length - 1];
	}
	else
	{
		return ChosenProgressionData.SpawningTags[ChosenLevel];
	}
}

//---------------------------------------------------------------------------------------
function name GetMaxLevelSpawningTag()
{
	if (ChosenProgressionData.SpawningTags.Length == 0)
	{
		return '';
	}

	return ChosenProgressionData.SpawningTags[ChosenProgressionData.SpawningTags.Length - 1];
}

//---------------------------------------------------------------------------------------
function name GetReinforcementGroupName(int ChosenLevel)
{
	local array<name> GroupNames;

	if(ChosenProgressionData.ReinforcementGroups.Length == 0)
	{
		return '';
	}

	if(ChosenLevel < 0)
	{
		GroupNames = ChosenProgressionData.ReinforcementGroups[0].GroupNames;
	}
	else if(ChosenLevel >= ChosenProgressionData.SpawningTags.Length)
	{
		GroupNames = ChosenProgressionData.ReinforcementGroups[ChosenProgressionData.ReinforcementGroups.Length - 1].GroupNames;
	}
	else
	{
		GroupNames = ChosenProgressionData.ReinforcementGroups[ChosenLevel].GroupNames;
	}

	return GroupNames[`SYNC_RAND(GroupNames.Length)];
}

//---------------------------------------------------------------------------------------
function XComGameState_AdventChosen CreateInstanceFromTemplate(XComGameState NewGameState)
{
	local XComGameState_AdventChosen ChosenState;

	ChosenState = XComGameState_AdventChosen(NewGameState.CreateNewStateObject(class'XComGameState_AdventChosen', self));

	return ChosenState;
}

//---------------------------------------------------------------------------------------
DefaultProperties
{
}