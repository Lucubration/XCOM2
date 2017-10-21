//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_SparkManager.uc
//  AUTHOR:  Joe Weinhoffer -- 02/23/2016
//  PURPOSE: This object is a manager for Spark data in the XCOM 2 strategy game
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class XComGameState_SparkManager extends XComGameState_BaseObject config(GameData);

// Healing Vars
var config int											BaseSparkHealRate; // Not difficulty adjusted, Wound times adjusted instead
var int													SparkHealingRate; // The current healing rate for all Sparks

// DLC Installation Tracking
var bool												bContentCheckCompleted; // Has the popup asking the player whether or not to enable DLC content been shown
var bool												bContentActivated; // Is the DLC content enabled

// SPARK from Lost Towers Mission
var StateObjectReference								LostTowersSparkReference;

// Shen config values
var const config name									LostTowersShenTemplate;

// Localized strings
var localized string									LostTowersShenFirstName;
var localized string									LostTowersShenLastName;

//---------------------------------------------------------------------------------------
static function SetUpManager(XComGameState StartState)
{
	local XComGameState_SparkManager SparkMgr;

	foreach StartState.IterateByClassType(class'XComGameState_SparkManager', SparkMgr)
	{
		break;
	}

	if (SparkMgr == none)
	{
		SparkMgr = XComGameState_SparkManager(StartState.CreateNewStateObject(class'XComGameState_SparkManager'));
	}
	
	SparkMgr.SparkHealingRate = default.BaseSparkHealRate; // Initialize healing rate
	SparkMgr.CreateLostTowersShen(StartState);
}

//---------------------------------------------------------------------------------------
function CreateLostTowersShen(XComGameState NewGameState)
{
	local XComGameState_Unit UnitState;
	local X2CharacterTemplateManager CharMgr;
	local X2CharacterTemplate CharTemplate;

	CharMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	CharTemplate = CharMgr.FindCharacterTemplate(default.LostTowersShenTemplate);
	UnitState = CharTemplate.CreateInstanceFromTemplate(NewGameState);
	
	// Give Shen squaddie gear. She will automatically get upgraded to the best available gear during Squad Select.
	UnitState.ApplySquaddieLoadout(NewGameState);
}

//---------------------------------------------------------------------------------------
function OnEndTacticalPlay(XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_MissionSite MissionState;

	super.OnEndTacticalPlay(NewGameState);
	History = `XCOMHISTORY;

	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	MissionState = XComGameState_MissionSite(History.GetGameStateForObjectID(XComHQ.MissionRef.ObjectID));

	if(MissionState != none && MissionState.Source == 'MissionSource_LostTowers')
	{
		foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
		{
			if(UnitState.GetMyTemplateName() == 'LostTowersSpark')
			{
				LostTowersSparkReference = UnitState.GetReference();
				break;
			}
		}
	}
}