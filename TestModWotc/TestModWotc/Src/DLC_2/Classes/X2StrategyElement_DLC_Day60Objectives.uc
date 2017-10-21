//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DLC_Day60Objectives.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_DLC_Day60Objectives extends X2StrategyElement
	dependson(XComGameState_ObjectivesList);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Objectives;

	/////////////// DLC //////////////////
	Objectives.AddItem(CreateDLC_AlienHuntersTemplate());
	Objectives.AddItem(CreateDLC_AlienHuntersOptionalNarrativeTemplate());
	Objectives.AddItem(CreateDLC_AlienHuntersNoNarrativeTemplate());
	Objectives.AddItem(CreateDLC_HunterWeaponsTemplate());
	Objectives.AddItem(CreateDLC_HunterWeaponsReceivedTemplate());
	Objectives.AddItem(CreateDLC_AlienNestMissionCompleteTemplate());
	Objectives.AddItem(CreateDLC_NestCompleteViperKingAliveTemplate());
	Objectives.AddItem(CreateDLC_NestCompleteViperKingDeadTemplate());
	Objectives.AddItem(CreateDLC_ViperKingAbilitiesTemplate());
	Objectives.AddItem(CreateDLC_KillViperKingTemplate());
	Objectives.AddItem(CreateDLC_KillBerserkerQueenTemplate());
	Objectives.AddItem(CreateDLC_KillArchonKingTemplate());
	Objectives.AddItem(CreateDLC_RecoverAlienRulerCorpseTemplate());
	Objectives.AddItem(CreateDLC_AutopsyAlienRulerTemplate());
	
	/////////////// NARRATIVE //////////////////
	Objectives.AddItem(CreateN_FirstAlienRulerEscaping());
	Objectives.AddItem(CreateN_AlienRulerEscaping());
	Objectives.AddItem(CreateN_ViperKingSighted());
	Objectives.AddItem(CreateN_ViperKingReturns());
	Objectives.AddItem(CreateN_BerserkerQueenSighted());
	Objectives.AddItem(CreateN_BerserkerQueenReturns());
	Objectives.AddItem(CreateN_ArchonKingSighted());
	Objectives.AddItem(CreateN_ArchonKingReturns());
	Objectives.AddItem(CreateN_AllAlienRulersKilled());
	Objectives.AddItem(CreateN_FirstAlienRulerCorpseRecoveredTemplate());
	Objectives.AddItem(CreateN_AlienRulerCorpseRecoveredTemplate());
	Objectives.AddItem(CreateN_AlienRulerAutopsyCompleteTemplate());
	Objectives.AddItem(CreateN_AlienNestTemplate());

	return Objectives;
}

// #######################################################################################
// ------------------------ DLC OBJECTIVES -----------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateDLC_AlienHuntersTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'DLC_AlienHunters');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	////////////////////////////////////////////////////////
	// VO which will always play when the DLC is enabled  //
	////////////////////////////////////////////////////////

	// Gameplay
	Template.NextObjectives.AddItem('DLC_ViperKingAbilities');
	Template.NextObjectives.AddItem('DLC_KillBerserkerQueen');
	Template.NextObjectives.AddItem('DLC_KillArchonKing');
	Template.NextObjectives.AddItem('DLC_RecoverAlienRulerCorpse');

	// Narrative
	Template.NextObjectives.AddItem('N_BerserkerQueenSighted');
	Template.NextObjectives.AddItem('N_ArchonKingSighted');
	Template.NextObjectives.AddItem('N_FirstAlienRulerEscaping');
	Template.NextObjectives.AddItem('N_AllAlienRulersKilled');
	Template.NextObjectives.AddItem('N_FirstAlienRulerCorpseRecovered');
	Template.NextObjectives.AddItem('N_AlienRulerAutopsyComplete');

	Template.CompletionEvent = 'PreMissionDone';

	return Template;
}

static function X2DataTemplate CreateDLC_AlienHuntersOptionalNarrativeTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'DLC_AlienHuntersOptionalNarrative');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	//////////////////////////////////////////////////////////////////////////////////////
	// VO which will only play when Optional Narrative Content is enabled for this DLC  //
	// This will only ever be activated at the start of a new campaign					//
	//////////////////////////////////////////////////////////////////////////////////////

	// Optional Narrative Content
	Template.NextObjectives.AddItem('DLC_HunterWeapons');
	Template.NextObjectives.AddItem('DLC_AlienNestMissionComplete');
	Template.NextObjectives.AddItem('DLC_NestCompleteViperKingAlive');
	Template.NextObjectives.AddItem('DLC_NestCompleteViperKingDead');
	Template.NextObjectives.AddItem('N_AlienNest');

	Template.CompletionEvent = 'PreMissionDone';

	return Template;
}

static function X2DataTemplate CreateDLC_AlienHuntersNoNarrativeTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'DLC_AlienHuntersNoNarrative');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// VO which will only play when Optional Narrative Content is disabled for this DLC							//
	// This will only ever be activated at the start of a new campaign											//
	// On Narrative playthroughs, these Objectives are activated when DLC_AlienNestMissionComplete is completed //
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////

	Template.NextObjectives.AddItem('DLC_KillViperKing');
	Template.NextObjectives.AddItem('N_ViperKingSighted');

	Template.CompletionEvent = 'PreMissionDone';

	return Template;
}

static function X2DataTemplate CreateDLC_HunterWeaponsTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'DLC_HunterWeapons');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.NextObjectives.AddItem('DLC_HunterWeaponsReceived');
	Template.CompletionEvent = 'HunterWeaponsRumorComplete';

	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_S_Locator_Beacon_Detected", NAW_OnAssignment, 'HunterWeaponsRumorAppeared', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_S_BigSky_Crash_Site_Located", NAW_OnCompletion, '', '', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}

static function X2DataTemplate CreateDLC_HunterWeaponsReceivedTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'DLC_HunterWeaponsReceived');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionEvent = 'HunterWeaponsViewed';

	Template.AddNarrativeTrigger("", NAW_OnAssignment, 'OnEnteredFacility_Hangar', '', ELD_OnStateSubmitted, NPC_Once, '', ViewHunterWeapons);
	Template.AddNarrativeTrigger("", NAW_OnAssignment, 'EnterSquadSelect', '', ELD_OnStateSubmitted, NPC_Once, '', ViewHunterWeapons);
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_S_Hunter_Weapons_UI_Pop", NAW_OnAssignment, 'HunterWeaponsPopup', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_S_Dont_Lose_Hunter_Weapons", NAW_OnCompletion, '', '', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}

function ViewHunterWeapons()
{
	local XComGameState NewGameState;
	local X2ItemTemplateManager ItemTemplateMgr;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger Event: Hunter Weapons Viewed");
	`XEVENTMGR.TriggerEvent('HunterWeaponsViewed', , , NewGameState);
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	`HQPRES.UIItemReceived(ItemTemplateMgr.FindItemTemplate('Frostbomb'));
	`HQPRES.UIItemReceived(ItemTemplateMgr.FindItemTemplate('AlienHunterAxe_CV'));
	`HQPRES.UIItemReceived(ItemTemplateMgr.FindItemTemplate('AlienHunterPistol_CV'));
	`HQPRES.UIItemReceived(ItemTemplateMgr.FindItemTemplate('HunterRifle_CV_Schematic'));
}

static function X2DataTemplate CreateDLC_AlienNestMissionCompleteTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'DLC_AlienNestMissionComplete');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.RevealEvent = '';
	Template.NextObjectives.AddItem('DLC_KillViperKing');
	Template.NextObjectives.AddItem('N_ViperKingReturns');
	Template.CompletionEvent = 'AlienNestMissionComplete';
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
	DLCFlagIndex = AllDLCFlags.Find('DLCName', Name(class'X2DownloadableContentInfo_DLC_Day60'.default.DLCIdentifier));
	
	if (DLCFlagIndex != INDEX_NONE && AllDLCFlags[DLCFlagIndex].NarrativeContentEnabled)
	{
		// Only turn the flag off if it is true, so should only happen once
		m_kProfileSettings.Data.m_arrNarrativeContentEnabled[DLCFlagIndex].NarrativeContentEnabled = false;
		`ONLINEEVENTMGR.SaveProfileSettings(true);
	}
}

static function X2DataTemplate CreateDLC_NestCompleteViperKingDeadTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'DLC_NestCompleteViperKingDead');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionEvent = 'NestCompleteViperKingDead';

	return Template;
}

static function X2DataTemplate CreateDLC_NestCompleteViperKingAliveTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'DLC_NestCompleteViperKingAlive');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionEvent = 'NestCompleteViperKingAlive';

	return Template;
}

static function X2DataTemplate CreateDLC_ViperKingAbilitiesTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'DLC_ViperKingAbilities');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionEvent = 'KilledViperKing';
	Template.TacticalCompletion = true;

	Template.ShouldCompleteWithSimCombatFn = DontCompleteWithSimCombat;

	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_T_Viper_King_Freeze_Breath", NAW_OnReveal, 'AbilityActivated', 'Frostbite', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}

static function X2DataTemplate CreateDLC_KillViperKingTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'DLC_KillViperKing');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	
	Template.CompleteObjectiveFn = KillAlienRulerComplete;
	Template.CompletionEvent = 'KilledViperKing';
	Template.TacticalCompletion = true;

	Template.ShouldCompleteWithSimCombatFn = ShouldCompleteKillViperKingWithSimCombat;
	Template.SimCombatItemReward = 'CorpseViperKing';
	
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_T_Viper_King_Dead", NAW_OnCompletion, '', '', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}

static function bool ShouldCompleteKillViperKingWithSimCombat()
{
	return WasEnemyOnMission('ViperKing');
}

static function X2DataTemplate CreateDLC_KillBerserkerQueenTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'DLC_KillBerserkerQueen');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	
	Template.CompleteObjectiveFn = KillAlienRulerComplete;
	Template.CompletionEvent = 'KilledBerserkerQueen';
	Template.TacticalCompletion = true;

	Template.ShouldCompleteWithSimCombatFn = ShouldCompleteKillBerserkerQueenWithSimCombat;
	Template.SimCombatItemReward = 'CorpseBerserkerQueen';

	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_T_Berserker_Queen_Quake", NAW_OnReveal, 'AbilityActivated', 'Quake', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_T_Berserker_Queen_Dead", NAW_OnCompletion, '', '', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}

static function bool ShouldCompleteKillBerserkerQueenWithSimCombat()
{
	return WasEnemyOnMission('BerserkerQueen');
}

static function X2DataTemplate CreateDLC_KillArchonKingTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'DLC_KillArchonKing');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	
	Template.CompleteObjectiveFn = KillAlienRulerComplete;
	Template.CompletionEvent = 'KilledArchonKing';
	Template.TacticalCompletion = true;

	Template.ShouldCompleteWithSimCombatFn = ShouldCompleteKillArchonKingWithSimCombat;
	Template.SimCombatItemReward = 'CorpseArchonKing';

	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_T_Archon_King_Icarus_Drop", NAW_OnReveal, 'AbilityActivated', 'IcarusDropGrab', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_T_Archon_King_Dead", NAW_OnCompletion, '', '', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}

static function bool ShouldCompleteKillArchonKingWithSimCombat()
{
	return WasEnemyOnMission('ArchonKing');
}

private static function bool WasEnemyOnMission(name EnemyName)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_MissionSite MissionState;
	local array<PodSpawnInfo> MissionPods;
	local int idx;

	History = `XCOMHISTORY;
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	MissionState = XComGameState_MissionSite(History.GetGameStateForObjectID(XComHQ.MissionRef.ObjectID));

	// Grab all pods on the mission
	for(idx = 0; idx < MissionState.SelectedMissionData.SelectedEncounters.Length; idx++)
	{
		MissionPods.AddItem(MissionState.SelectedMissionData.SelectedEncounters[idx].EncounterSpawnInfo);
	}

	// Check for Archon King
	for(idx = 0; idx < MissionPods.Length; idx++)
	{
		if(MissionPods[idx].SelectedCharacterTemplateNames.Find(EnemyName) != INDEX_NONE)
		{
			return true;
		}
	}

	return false;
}

function KillAlienRulerComplete(XComGameState NewGameState, XComGameState_Objective ObjectiveState)
{
	local XComGameState_AlienRulerManager RulerMgr;
	
	RulerMgr = XComGameState_AlienRulerManager(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_AlienRulerManager'));
	if (RulerMgr.DefeatedAlienRulers.Length == (RulerMgr.AllAlienRulers.Length - 1))
	{
		// All of the rulers are dead, since the ruler we just killed will not be in the DefeatedAlienRulers array yet
		`XEVENTMGR.TriggerEvent('AllAlienRulersKilled', , , NewGameState);
	}
}

static function X2DataTemplate CreateDLC_RecoverAlienRulerCorpseTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'DLC_RecoverAlienRulerCorpse');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.NextObjectives.AddItem('DLC_AutopsyAlienRuler');

	Template.CompletionRequirements.SpecialRequirementsFn = HasAlienRulerCorpse;
	Template.CompletionEvent = 'PostMissionLoot';

	return Template;
}

static function bool HasAlienRulerCorpse()
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	if (XComHQ.HasItemByName('CorpseViperKing') || XComHQ.HasItemByName('CorpseBerserkerQueen') || XComHQ.HasItemByName('CorpseArchonKing'))
	{
		return true;
	}

	return false;
}

static function X2DataTemplate CreateDLC_AutopsyAlienRulerTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'DLC_AutopsyAlienRuler');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionRequirements.SpecialRequirementsFn = HasAutopsiedAlienRuler;
	Template.CompletionEvent = 'ResearchCompleted';

	Template.NagDelayHours = 336;

	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_S_Autopsy_Reminder_Nag", NAW_OnNag, 'OnEnteredFacility_PowerCore', '', ELD_OnStateSubmitted, NPC_Multiple, '');

	return Template;
}

static function bool HasAutopsiedAlienRuler()
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	if (XComHQ.IsTechResearched('AutopsyViperKing') || XComHQ.IsTechResearched('AutopsyBerserkerQueen') || XComHQ.IsTechResearched('AutopsyArchonKing'))
	{
		return true;
	}

	return false;
}

// #######################################################################################
// -------------------- NARRATIVE OBJECTIVES ---------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateN_FirstAlienRulerEscaping()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_FirstAlienRulerEscaping');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.NextObjectives.AddItem('N_AlienRulerEscaping');
	Template.CompletionEvent = 'FirstAlienRulerEscaping';
	Template.TacticalCompletion = true;

	Template.ShouldCompleteWithSimCombatFn = DontCompleteWithSimCombat;

	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_T_King_Attempting_Escape", NAW_OnAssignment, 'AbilityActivated', 'AlienRulerCallForEscape', ELD_OnStateSubmitted, NPC_Once, '', TriggerRulerEscapingEvent);

	return Template;
}

static function TriggerRulerEscapingEvent()
{
	local XComGameState NewGameState;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger First Ruler Escaping Event");
	`XEVENTMGR.TriggerEvent('FirstAlienRulerEscaping', , , NewGameState);
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

static function X2DataTemplate CreateN_AlienRulerEscaping()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_AlienRulerEscaping');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionEvent = 'AllAlienRulersKilled';
	Template.TacticalCompletion = true;

	Template.ShouldCompleteWithSimCombatFn = DontCompleteWithSimCombat;
	
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_T_Ruler_Attempting_Escape_A", NAW_OnAssignment, 'AbilityActivated', 'AlienRulerCallForEscape', ELD_OnStateSubmitted, NPC_Multiple, 'AlienRulerEscapeLines');
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_T_Ruler_Attempting_Escape_B", NAW_OnAssignment, 'AbilityActivated', 'AlienRulerCallForEscape', ELD_OnStateSubmitted, NPC_Multiple, 'AlienRulerEscapeLines');
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_T_Ruler_Attempting_Escape_C", NAW_OnAssignment, 'AbilityActivated', 'AlienRulerCallForEscape', ELD_OnStateSubmitted, NPC_Multiple, 'AlienRulerEscapeLines');
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_T_Ruler_Attempting_Escape_D", NAW_OnAssignment, 'AbilityActivated', 'AlienRulerCallForEscape', ELD_OnStateSubmitted, NPC_Multiple, 'AlienRulerEscapeLines');
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_T_Ruler_Attempting_Escape_E", NAW_OnAssignment, 'AbilityActivated', 'AlienRulerCallForEscape', ELD_OnStateSubmitted, NPC_Multiple, 'AlienRulerEscapeLines');

	return Template;
}

static function X2DataTemplate CreateN_ViperKingSighted()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_ViperKingSighted');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.NextObjectives.AddItem('N_ViperKingReturns');
	Template.CompletionEvent = 'ViperKingSighted';
	Template.TacticalCompletion = true;

	Template.ShouldCompleteWithSimCombatFn = DontCompleteWithSimCombat;
	
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_T_Post_Matinee", NAW_OnCompletion, '', '', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}

static function X2DataTemplate CreateN_ViperKingReturns()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_ViperKingReturns');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionRequirements.RequiredItems.AddItem('CorpseViperKing');
	Template.CompletionEvent = 'PostMissionLoot';

	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_T_Ruler_Returns_A", NAW_OnAssignment, 'ViperKingSighted', '', ELD_OnStateSubmitted, NPC_Multiple, 'ViperKingReturnsLines');
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_T_Ruler_Returns_B", NAW_OnAssignment, 'ViperKingSighted', '', ELD_OnStateSubmitted, NPC_Multiple, 'ViperKingReturnsLines');
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_T_Ruler_Returns_C", NAW_OnAssignment, 'ViperKingSighted', '', ELD_OnStateSubmitted, NPC_Multiple, 'ViperKingReturnsLines');

	return Template;
}

static function X2DataTemplate CreateN_BerserkerQueenSighted()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_BerserkerQueenSighted');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.NextObjectives.AddItem('N_BerserkerQueenReturns');
	Template.CompletionEvent = 'BerserkerQueenSighted';
	Template.TacticalCompletion = true;

	Template.ShouldCompleteWithSimCombatFn = DontCompleteWithSimCombat;
	
	return Template;
}

static function X2DataTemplate CreateN_BerserkerQueenReturns()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_BerserkerQueenReturns');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionRequirements.RequiredItems.AddItem('CorpseBerserkerQueen');
	Template.CompletionEvent = 'PostMissionLoot';
	
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_T_Ruler_Returns_A", NAW_OnAssignment, 'BerserkerQueenSighted', '', ELD_OnStateSubmitted, NPC_Multiple, 'BerserkerQueenReturnsLines');
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_T_Ruler_Returns_B", NAW_OnAssignment, 'BerserkerQueenSighted', '', ELD_OnStateSubmitted, NPC_Multiple, 'BerserkerQueenReturnsLines');
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_T_Ruler_Returns_C", NAW_OnAssignment, 'BerserkerQueenSighted', '', ELD_OnStateSubmitted, NPC_Multiple, 'BerserkerQueenReturnsLines');
	
	return Template;
}

static function X2DataTemplate CreateN_ArchonKingSighted()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_ArchonKingSighted');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.NextObjectives.AddItem('N_ArchonKingReturns');
	Template.CompletionEvent = 'ArchonKingSighted';
	Template.TacticalCompletion = true;

	Template.ShouldCompleteWithSimCombatFn = DontCompleteWithSimCombat;

	return Template;
}

static function X2DataTemplate CreateN_ArchonKingReturns()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_ArchonKingReturns');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionRequirements.RequiredItems.AddItem('CorpseArchonKing');
	Template.CompletionEvent = 'PostMissionLoot';

	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_T_Ruler_Returns_A", NAW_OnAssignment, 'ArchonKingSighted', '', ELD_OnStateSubmitted, NPC_Multiple, 'ArchonKingReturnsLines');
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_T_Ruler_Returns_B", NAW_OnAssignment, 'ArchonKingSighted', '', ELD_OnStateSubmitted, NPC_Multiple, 'ArchonKingReturnsLines');
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_T_Ruler_Returns_C", NAW_OnAssignment, 'ArchonKingSighted', '', ELD_OnStateSubmitted, NPC_Multiple, 'ArchonKingReturnsLines');

	return Template;
}

static function X2DataTemplate CreateN_AllAlienRulersKilled()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_AllAlienRulersKilled');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionEvent = 'AllAlienRulersKilled';
	Template.TacticalCompletion = true;

	Template.ShouldCompleteWithSimCombatFn = DontCompleteWithSimCombat;
	
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_T_Rulers_Move_Always", NAW_OnReveal, 'AbilityActivated', class'X2Ability_DLC_Day60AlienRulers'.default.AlienRulerActionSystemAbilityName, ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_S_All_Rulers_Dead", NAW_OnCompletion, '', '', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}

static function X2DataTemplate CreateN_FirstAlienRulerCorpseRecoveredTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_FirstAlienRulerCorpseRecovered');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.NextObjectives.AddItem('N_AlienRulerCorpseRecovered');
	Template.CompletionEvent = 'AlienRulerCorpseRecovered';

	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_S_Ruler_Autopsy_Available", NAW_OnCompletion, '', '', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}

static function X2DataTemplate CreateN_AlienRulerCorpseRecoveredTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_AlienRulerCorpseRecovered');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_S_Ruler_Autopsy_Available_B", NAW_OnAssignment, 'AlienRulerCorpseRecovered', '', ELD_OnStateSubmitted, NPC_Multiple, 'AlienRulerCorpseRecoveredLines');
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_S_Ruler_Autopsy_Available_C", NAW_OnAssignment, 'AlienRulerCorpseRecovered', '', ELD_OnStateSubmitted, NPC_Multiple, 'AlienRulerCorpseRecoveredLines');
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_S_Ruler_Autopsy_Available_D", NAW_OnAssignment, 'AlienRulerCorpseRecovered', '', ELD_OnStateSubmitted, NPC_Multiple, 'AlienRulerCorpseRecoveredLines');

	return Template;
}

static function X2DataTemplate CreateN_AlienRulerAutopsyCompleteTemplate()
{
	local X2ObjectiveTemplate Template;
	
	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_AlienRulerAutopsyComplete');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_S_Viper_King_Autopsy_Blurb", NAW_OnAssignment, 'OnResearchReport', 'AutopsyViperKing', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_S_Berserker_Queen_Autopsy_Blurb", NAW_OnAssignment, 'OnResearchReport', 'AutopsyBerserkerQueen', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_S_Archon_King_Autopsy_Blurb", NAW_OnAssignment, 'OnResearchReport', 'AutopsyArchonKing', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}

static function X2DataTemplate CreateN_AlienNestTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_AlienNest');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	
	Template.CompletionEvent = 'AlienNestMissionComplete';

	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_S_Nest_Site_Located", NAW_OnAssignment, 'NestRumorAppeared', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_S_Site_Readings", NAW_OnAssignment, 'NestRumorComplete', '', ELD_OnStateSubmitted, NPC_Once, '', TriggerCentralCallToArmsEvent);
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_S_Call_To_Arms", NAW_OnAssignment, 'CentralCallToArms', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_S_Pre_Mission_Prep", NAW_OnAssignment, 'NestMissionSquadSelect', '', ELD_OnStateSubmitted, NPC_Once, '', TriggerCentralDoneMissionPrepEvent);
	Template.AddNarrativeTrigger("DLC_60_NarrativeMoments.DLC2_S_Equip_Hunter_Weapons", NAW_OnAssignment, 'CentralDoneNestMissionPrep', '', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}

static function TriggerCentralCallToArmsEvent()
{
	local XComGameState NewGameState;

	if(`XCOMHISTORY.GetStartState() == none)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger Central Call to Arms Event");
		`XEVENTMGR.TriggerEvent('CentralCallToArms', , , NewGameState);
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
}

static function TriggerCentralDoneMissionPrepEvent()
{
	local XComGameState NewGameState;

	if(`XCOMHISTORY.GetStartState() == none)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger Central Done Pre-Nest Mission Prep Event");
		`XEVENTMGR.TriggerEvent('CentralDoneNestMissionPrep', , , NewGameState);
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
}

static function bool DontCompleteWithSimCombat()
{
	return false;
}