//---------------------------------------------------------------------------------------
//  FILE:    X2ResistanceFactionTemplate.uc
//  AUTHOR:  Mark Nauta  --  04/29/2016
//  PURPOSE: This object represents immutable data about the Resistance Factions
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2ResistanceFactionTemplate extends X2StrategyElementTemplate
	config(GameBoard);

// Unit Type
var config name ChampionSoldierClass;
var config name ChampionCharacterClass;

// Faction appearance data
var config Color FactionColor;
var config array<string> BackgroundImages;
var config array<string> ForegroundImages;
var config string LeaderImage;
var config string OverworldMeshPath;

// Event Triggers
var config name FactionLeaderCinEvent;
var config name RevealEvent;
var config string FanfareEvent;
var config name MetEvent;
var config name RevealHQEvent;
var config name InfluenceIncreasedMedEvent;
var config name InfluenceIncreasedHighEvent;
var config name NewCovertActionAvailableEvent;
var config name ConfirmCovertActionEvent;
var config name CovertActionAmbushEvent;
var config name CovertActionCompletedEvent;
var config name ChosenFragmentEvent;
var config name ResistanceOpSpawnedEvent;
var config name PositiveFeedbackEvent;
var config name NegativeFeedbackEvent;
var config name HeroOnMissionEvent;
var config name ChosenFoughtEvent;
var config name ChosenDefeatedEvent;
var config name GreatMissionEvent;
var config name ToughMissionEvent;
var config name HeroKilledEvent;
var config name HeroCapturedEvent;
var config name SoldierRescuedEvent;
var config name NewFactionSoldierEvent;
var config name NewResistanceOrderEvent;
var config name FirstOrderSlotEvent;
var config name SecondOrderSlotEvent;
var config name ConfirmPoliciesEvent;

// Resistance Ring Upgrade
var config name RingPlaqueUpgradeName;

// Scan Site Data
var config name ResistanceMode; // Formerly on ResHQ, Scanning mode

// Faction Gear to be added to the XComHQ Inventory when a soldier is recruited
var config array<name> FactionEquipment;

// Non-Random Title of the faction
var localized string FactionTitle;
var localized string LeaderQuote;
var localized string InfluenceMediumQuote;
var localized string InfluenceHighQuote;

// Non-Random HQ display name for the faction
var localized string FactionHQDisplayName;

// Group names can appear at beginning or end
var localized array<string> GroupNames;

// Descriptors are defined as appearing as prefix or suffix
var localized array<string> Descriptors_Prefix;
var localized array<string> Descriptors_Suffix;

// User interface icon options
var config StackedUIIconData FactionIconData;
//Possible images to use in generating the icons 
var config array<string> FactionIconInformation_Layer0;
var config array<string> FactionIconInformation_Layer1;
var config array<string> FactionIconInformation_Layer2;

//---------------------------------------------------------------------------------------
function string GenerateFactionName()
{
	local XGParamTag LocTag;

	// Pick the group name
	LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	LocTag.StrValue0 = GroupNames[`SYNC_RAND(GroupNames.Length)];
	LocTag.StrValue1 = Descriptors_Prefix[`SYNC_RAND(Descriptors_Prefix.Length)];
	LocTag.StrValue2 = Descriptors_Suffix[`SYNC_RAND(Descriptors_Suffix.Length)];

	// Pick the descriptor - 50/50 roll on "Prefix GroupName" vs "GroupName Postfix"
	if(class'X2StrategyGameRulesetDataStructures'.static.Roll(50))
	{
		return `XEXPAND.ExpandString(class'XLocalizedData'.default.FactionGroupNameWithPrefixFormat);
	}
	else
	{
		return `XEXPAND.ExpandString(class'XLocalizedData'.default.FactionGroupNameWithSuffixFormat);
	}
}

//---------------------------------------------------------------------------------------

function StackedUIIconData GenerateFactionIcon()
{
	local array<string> Newinfo;

	if( FactionIconInformation_Layer0.Length > 0 )
	{
		Newinfo.AddItem(FactionIconInformation_Layer0[`SYNC_RAND(FactionIconInformation_Layer0.Length)]);
	}
	if( FactionIconInformation_Layer1.Length > 0 )
	{
		Newinfo.AddItem(FactionIconInformation_Layer1[`SYNC_RAND(FactionIconInformation_Layer1.Length)]);
	}
	if( FactionIconInformation_Layer2.Length > 0 )
	{
		Newinfo.AddItem(FactionIconInformation_Layer2[`SYNC_RAND(FactionIconInformation_Layer2.Length)]);
	}
	FactionIconData.Images = Newinfo;
	if( FactionIconInformation_Layer2.Length > 0 )
	{
		FactionIconData.bInvert = (`SYNC_RAND(2) == 0);
	}
	else
	{
		FactionIconData.bInvert = false;
	}

	return FactionIconData;
}

//---------------------------------------------------------------------------------------
function XComGameState_ResistanceFaction CreateInstanceFromTemplate(XComGameState NewGameState)
{
	local XComGameState_ResistanceFaction FactionState;

	FactionState = XComGameState_ResistanceFaction(NewGameState.CreateNewStateObject(class'XComGameState_ResistanceFaction', self));

	return FactionState;
}

//---------------------------------------------------------------------------------------
DefaultProperties
{
}