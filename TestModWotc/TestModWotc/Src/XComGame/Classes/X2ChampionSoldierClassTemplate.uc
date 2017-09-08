//---------------------------------------------------------------------------------------
//  FILE:    X2ChampionSoldierClassTemplate.uc
//  AUTHOR:  Mark Nauta  --  04/25/2016
//  PURPOSE: This object represents immutable data about the Champion soldier classes
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2ChampionSoldierClassTemplate extends X2SoldierClassTemplate
	config(ClassData);

// Faction appearance data
var config Color FactionColor;
var config array<string> BackgroundImages;
var config array<string> ForegroundImages;

// Strings for naming Resistance Factions composed of these units

// Group names can appear at beginning or end
var localized array<string> GroupNames_Male;
var localized array<string> GroupNames_Female;
var localized array<string> GroupNames_Neutral;

// Descriptors are defined as appearing as prefix or suffix
var localized array<string> Descriptors_Prefix;
var localized array<string> Descriptors_Suffix;

//---------------------------------------------------------------------------------------
function string GenerateFactionName(optional bool bForceMale = false, optional bool bForceFemale = false)
{
	local string GroupName;

	// Pick the group name
	if(bForceMale)
	{
		GroupName = default.GroupNames_Male[`SYNC_RAND(default.GroupNames_Male.Length)];
	}
	else if(bForceFemale)
	{
		GroupName = default.GroupNames_Female[`SYNC_RAND(default.GroupNames_Female.Length)];
	}
	else
	{
		GroupName = default.GroupNames_Neutral[`SYNC_RAND(default.GroupNames_Neutral.Length)];
	}

	// Pick the descriptor
	if(class'X2StrategyGameRulesetDataStructures'.static.Roll(50))
	{
		return (default.Descriptors_Prefix[`SYNC_RAND(default.Descriptors_Prefix.Length)] @ GroupName);
	}
	else
	{
		return (GroupName @ default.Descriptors_Suffix[`SYNC_RAND(default.Descriptors_Suffix.Length)]);
	}
}

//---------------------------------------------------------------------------------------
DefaultProperties
{
}