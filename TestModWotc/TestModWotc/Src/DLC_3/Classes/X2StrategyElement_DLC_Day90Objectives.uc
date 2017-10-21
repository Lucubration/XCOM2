//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DLC_Day90Objectives.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_DLC_Day90Objectives extends X2StrategyElement
	dependson(XComGameState_ObjectivesList);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Objectives;

	/////////////// DLC ////////////////////
	Objectives.AddItem(CreateDLC_ShensLastGiftTemplate());
	Objectives.AddItem(CreateDLC_ShensLastGiftOptionalNarrativeTemplate());
	Objectives.AddItem(CreateDLC_LostTowersMissionCompleteTemplate());

	/////////////// NARRATIVE //////////////////
	Objectives.AddItem(CreateN_LostTowersPOISetupTemplate());
	Objectives.AddItem(CreateN_LostTowersTemplate());
	Objectives.AddItem(CreateN_SparkRecoveredTemplate());
	Objectives.AddItem(CreateN_SparkSquadSelectTemplate());
	Objectives.AddItem(CreateN_WoundedSparksAvailableTemplate());
	Objectives.AddItem(CreateN_SparkVoiceChangedTemplate());

	return Objectives;
}

// #######################################################################################
// -------------------- DLC OBJECTIVES -----------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateDLC_ShensLastGiftTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'DLC_ShensLastGift');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	////////////////////////////////////////////////////////
	// VO which will always play when the DLC is enabled  //
	////////////////////////////////////////////////////////
	
	// Narrative
	Template.NextObjectives.AddItem('N_SparkSquadSelect');
	Template.NextObjectives.AddItem('N_WoundedSparksAvailable');
	
	Template.CompletionEvent = 'PreMissionDone';

	return Template;
}

static function X2DataTemplate CreateDLC_ShensLastGiftOptionalNarrativeTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'DLC_ShensLastGiftOptionalNarrative');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	//////////////////////////////////////////////////////////////////////////////////////
	// VO which will only play when Optional Narrative Content is enabled for this DLC  //
	// This will only ever be activated at the start of a new campaign					//
	//////////////////////////////////////////////////////////////////////////////////////

	// Optional Narrative Content
	Template.NextObjectives.AddItem('DLC_LostTowersMissionComplete');
	Template.NextObjectives.AddItem('N_LostTowersPOISetup');

	Template.CompletionEvent = 'PreMissionDone';

	return Template;
}

static function X2DataTemplate CreateDLC_LostTowersMissionCompleteTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'DLC_LostTowersMissionComplete');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.RevealEvent = '';
	Template.NextObjectives.AddItem('N_SparkRecovered');
	Template.NextObjectives.AddItem('N_SparkVoiceChanged');
	Template.CompletionEvent = 'LostTowersMissionComplete';
	Template.CompleteObjectiveFn = FlagDLCCompleted;

	return Template;
}

function FlagDLCCompleted(XComGameState NewGameState, XComGameState_Objective ObjectiveState)
{
	local XComOnlineProfileSettings m_kProfileSettings;
	local array<NarrativeContentFlag> AllDLCFlags;
	local int DLCFlagIndex;

	m_kProfileSettings = `XPROFILESETTINGS;
	AllDLCFlags = m_kProfileSettings.Data.m_arrNarrativeContentEnabled;
	DLCFlagIndex = AllDLCFlags.Find('DLCName', Name(class'X2DownloadableContentInfo_DLC_Day90'.default.DLCIdentifier));

	if (DLCFlagIndex != INDEX_NONE && AllDLCFlags[DLCFlagIndex].NarrativeContentEnabled)
	{
		// Only turn the flag off if it is true, so should only happen once
		m_kProfileSettings.Data.m_arrNarrativeContentEnabled[DLCFlagIndex].NarrativeContentEnabled = false;
		`ONLINEEVENTMGR.SaveProfileSettings(true);
	}
}

// #######################################################################################
// -------------------- NARRATIVE OBJECTIVES ---------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateN_LostTowersPOISetupTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_LostTowersPOISetup');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	
	Template.NextObjectives.AddItem('N_LostTowers');
	Template.CompletionEvent = 'LostTowersPOISpawned';

	return Template;
}

static function X2DataTemplate CreateN_LostTowersTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_LostTowers');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	
	Template.RevealEvent = 'OnEnteredFacility_CIC';
	Template.CompletionEvent = 'LostTowersMissionComplete';

	Template.AddNarrativeTrigger("DLC_90_NarrativeMoments.DLC3_S_Shen_Message", NAW_OnReveal, '', '', ELD_OnStateSubmitted, NPC_Once, '', ShenMessageComplete);
	Template.AddNarrativeTrigger("DLC_90_NarrativeMoments.DLC3_S_Investigate_Signal", NAW_OnReveal, 'ShenMessageComplete', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("DLC_90_NarrativeMoments.DLC3_S_Pre_Scan_Geo", NAW_OnReveal, 'LostTowersRumorAppeared', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("DLC_90_NarrativeMoments.DLC3_S_Tower_Rumor_Comp", NAW_OnReveal, 'LostTowersRumorComplete', '', ELD_OnStateSubmitted, NPC_Once, '');	
	Template.AddNarrativeTrigger("DLC_90_NarrativeMoments.DLC3_S_Pre_Mission_Prep", NAW_OnReveal, 'LostTowersMissionSquadSelect', '', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}

function ShenMessageComplete()
{
	local XComGameState NewGameState;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger Shen Message Complete Event");
	`XEVENTMGR.TriggerEvent('ShenMessageComplete', , , NewGameState);
	`GAMERULES.SubmitGameState(NewGameState);
}

static function X2DataTemplate CreateN_SparkRecoveredTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_SparkRecovered');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionEvent = 'PostMissionLoot';

	Template.AddNarrativeTrigger("DLC_90_NarrativeMoments.DLC3_S_Spark_Is_Ours", NAW_OnCompletion, '', '', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}

static function X2DataTemplate CreateN_SparkSquadSelectTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_SparkSquadSelect');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionEvent = 'EnterSquadSelect';
	Template.CompletionRequirements.SpecialRequirementsFn = HasSpark;

	Template.AddNarrativeTrigger("", NAW_OnCompletion, '', '', ELD_OnStateSubmitted, NPC_Once, '', TriggerSparkInfoPopup);

	return Template;
}

static function bool HasSpark()
{
	local XComGameState_HeadquartersXCom XComHQ;
	local array<XComGameState_Unit> Soldiers;
	local XComGameState_Unit Soldier;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	Soldiers = XComHQ.GetSoldiers();

	foreach Soldiers(Soldier)
	{
		if (Soldier.GetSoldierClassTemplateName() == 'Spark')
		{
			return true;
		}
	}

	return false;
}

static function TriggerSparkInfoPopup()
{
	class'X2Helpers_DLC_Day90'.static.ShowSparkSquadSelectInfoPopup();
}

static function X2DataTemplate CreateN_WoundedSparksAvailableTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_WoundedSparksAvailable');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionEvent = 'EnterSquadSelect';
	Template.CompletionRequirements.SpecialRequirementsFn = HasWoundedSpark;

	Template.AddNarrativeTrigger("DLC_90_NarrativeMoments.DLC3_S_Spark_Repairs_Available", NAW_OnCompletion, '', '', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}

static function bool HasWoundedSpark()
{
	local XComGameState_HeadquartersXCom XComHQ;
	local array<XComGameState_Unit> Soldiers;
	local XComGameState_Unit Soldier;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	Soldiers = XComHQ.GetSoldiers();

	foreach Soldiers(Soldier)
	{
		if (Soldier.GetSoldierClassTemplateName() == 'Spark' && Soldier.IsInjured())
		{
			return true;
		}
	}
	
	return false;
}

static function X2DataTemplate CreateN_SparkVoiceChangedTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_SparkVoiceChanged');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.AddNarrativeTrigger("DLC_90_NarrativeMoments.DLC3_S_Spark_Has_Honor", NAW_OnAssignment, 'WarriorSparkVoiceSelected', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("DLC_90_NarrativeMoments.DLC3_S_Julian_Lives_Follow", NAW_OnAssignment, 'JulianSparkVoiceSelected', '', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}