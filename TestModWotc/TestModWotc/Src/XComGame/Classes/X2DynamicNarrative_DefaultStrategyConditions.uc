//---------------------------------------------------------------------------------------
//  FILE:    X2DynamicNarrative_DefaultStrategyConditions.uc
//  AUTHOR:  Joe Weinhoffer --  3/2/2017
//  PURPOSE: Defines the set of narrative condition templates which access the strategy game
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DynamicNarrative_DefaultStrategyConditions extends X2DynamicNarrative;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	// STRATEGY CONDITIONS
	Templates.AddItem(CreateDidXComWinLastMissionCondition());
	Templates.AddItem(CreateDidXComLoseLastMissionCondition());
	Templates.AddItem(CreateDidXComLoseVeteranLastMissionCondition());
	Templates.AddItem(CreateDidXComBeatChosenLastMissionCondition());
	Templates.AddItem(CreateDidChosenBeatXComLastMissionCondition());
	Templates.AddItem(CreateDidXComDefeatChosenLastEncounterCondition());
	Templates.AddItem(CreateWasChosenOnLastMissionCondition('NarrativeCondition_Strategy_WasChosenAssassinOnLastMission', 'Chosen_Assassin'));
	Templates.AddItem(CreateWasChosenOnLastMissionCondition('NarrativeCondition_Strategy_WasChosenHunterOnLastMission', 'Chosen_Hunter'));
	Templates.AddItem(CreateWasChosenOnLastMissionCondition('NarrativeCondition_Strategy_WasChosenWarlockLastMission', 'Chosen_Warlock'));

	Templates.AddItem(CreateIsChosenActiveCondition('NarrativeCondition_Strategy_IsChosenAssassinActive', 'Chosen_Assassin'));
	Templates.AddItem(CreateIsChosenActiveCondition('NarrativeCondition_Strategy_IsChosenHunterActive', 'Chosen_Hunter'));
	Templates.AddItem(CreateIsChosenActiveCondition('NarrativeCondition_Strategy_IsChosenWarlockActive', 'Chosen_Warlock'));
	Templates.AddItem(CreateIsChosenKnowledgeHalfwayCondition('NarrativeCondition_Strategy_IsChosenAssassinKnowledgeHalfway', 'Chosen_Assassin'));
	Templates.AddItem(CreateIsChosenKnowledgeHalfwayCondition('NarrativeCondition_Strategy_IsChosenHunterKnowledgeHalfway', 'Chosen_Hunter'));
	Templates.AddItem(CreateIsChosenKnowledgeHalfwayCondition('NarrativeCondition_Strategy_IsChosenWarlockKnowledgeHalfway', 'Chosen_Warlock'));
	Templates.AddItem(CreateIsChosenKnowledgeCompleteCondition('NarrativeCondition_Strategy_IsChosenAssassinKnowledgeComplete', 'Chosen_Assassin'));
	Templates.AddItem(CreateIsChosenKnowledgeCompleteCondition('NarrativeCondition_Strategy_IsChosenHunterKnowledgeComplete', 'Chosen_Hunter'));
	Templates.AddItem(CreateIsChosenKnowledgeCompleteCondition('NarrativeCondition_Strategy_IsChosenWarlockKnowledgeComplete', 'Chosen_Warlock'));
	Templates.AddItem(CreateDidXComRecoverChosenFragmentCondition('NarrativeCondition_Strategy_DidXComRecoverAssassinFragment', 'Chosen_Assassin'));
	Templates.AddItem(CreateDidXComRecoverChosenFragmentCondition('NarrativeCondition_Strategy_DidXComRecoverHunterFragment', 'Chosen_Hunter'));
	Templates.AddItem(CreateDidXComRecoverChosenFragmentCondition('NarrativeCondition_Strategy_DidXComRecoverWarlockFragment', 'Chosen_Warlock'));
	
	Templates.AddItem(CreateHasPlayerMetFactionCondition('NarrativeCondition_Strategy_HasPlayerMetReapers', 'Faction_Reapers'));
	Templates.AddItem(CreateHasPlayerMetFactionCondition('NarrativeCondition_Strategy_HasPlayerMetSkirmishers', 'Faction_Skirmishers'));
	Templates.AddItem(CreateHasPlayerMetFactionCondition('NarrativeCondition_Strategy_HasPlayerMetTemplars', 'Faction_Templars'));

	Templates.AddItem(CreateIsLastMissionSourceCondition('NarrativeCondition_Strategy_IsLastMissionSabotageFacility', 'MissionSource_AlienNetwork'));
	Templates.AddItem(CreateIsLastMissionSourceCondition('NarrativeCondition_Strategy_IsLastMissionChosenStronghold', 'MissionSource_ChosenStronghold'));
	Templates.AddItem(CreateIsLastMissionFamilyCondition('NarrativeCondition_Strategy_IsLastMissionEliminateFieldCommander', "NeutralizeFieldCommander"));
	Templates.AddItem(CreateIsLastChosenEncounterMissionCondition('NarrativeCondition_Strategy_IsLastChosenEncounterAvengerAssault', 'MissionSource_ChosenAvengerAssault'));

	Templates.AddItem(CreateIsObjectiveCompleteCondition('NarrativeCondition_Strategy_IsBlacksiteComplete', 'T2_M1_InvestigateBlacksite'));
	Templates.AddItem(CreateIsObjectiveCompleteCondition('NarrativeCondition_Strategy_IsForgeComplete', 'T2_M3_CompleteForgeMission'));
	Templates.AddItem(CreateIsObjectiveCompleteCondition('NarrativeCondition_Strategy_IsPsiGateComplete', 'T4_M1_CompleteStargateMission'));
	Templates.AddItem(CreateIsAvatarProjectAlmostCompleteCondition());
	Templates.AddItem(CreateDidXComRecentlySabotageFacilityCondition());

	Templates.AddItem(CreateHasPlayerSeenDazedTutorialCondition());

	return Templates;
}

// #######################################################################################
// ----------------------- CONDITIONS ----------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateDidXComWinLastMissionCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_Strategy_DidXComWinLastMission');
	Template.IsConditionMetFn = CheckXComWonLastMission;

	return Template;
}

static function X2DataTemplate CreateDidXComLoseLastMissionCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_Strategy_DidXComLoseLastMission');
	Template.IsConditionMetFn = CheckXComLostLastMission;

	return Template;
}

static function X2DataTemplate CreateDidXComLoseVeteranLastMissionCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_Strategy_DidXComLoseVeteranLastMission');
	Template.IsConditionMetFn = CheckXComLostVeteranLastMission;

	return Template;
}

static function X2DataTemplate CreateDidXComBeatChosenLastMissionCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_Strategy_DidXComBeatChosenLastMission');
	Template.IsConditionMetFn = CheckXComBeatChosenLastMission;

	return Template;
}

static function X2DataTemplate CreateDidChosenBeatXComLastMissionCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_Strategy_DidChosenBeatXComLastMission');
	Template.IsConditionMetFn = CheckChosenBeatXComLastMission;

	return Template;
}

static function X2DataTemplate CreateDidXComDefeatChosenLastEncounterCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_Strategy_DidXComDefeatChosenLastEncounter');
	Template.IsConditionMetFn = CheckXComDefeatChosenLastEncounter;

	return Template;
}

static function X2DataTemplate CreateWasChosenOnLastMissionCondition(name TemplateName, name ChosenName)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckWasChosenOnLastMission;
	Template.ConditionNames.AddItem(ChosenName);

	return Template;
}

static function X2DataTemplate CreateIsChosenActiveCondition(name TemplateName, name ChosenName)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckIsChosenActive;
	Template.ConditionNames.AddItem(ChosenName);

	return Template;
}

static function X2DataTemplate CreateIsChosenKnowledgeHalfwayCondition(name TemplateName, name ChosenName)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckIsChosenKnowledgeHalfway;
	Template.ConditionNames.AddItem(ChosenName);

	return Template;
}

static function X2DataTemplate CreateIsChosenKnowledgeCompleteCondition(name TemplateName, name ChosenName)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckIsChosenKnowledgeComplete;
	Template.ConditionNames.AddItem(ChosenName);

	return Template;
}

static function X2DataTemplate CreateDidXComRecoverChosenFragmentCondition(name TemplateName, name ChosenName)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckDidXComRecoverChosenFragment;
	Template.ConditionNames.AddItem(ChosenName);

	return Template;
}

static function X2DataTemplate CreateHasPlayerMetFactionCondition(name TemplateName, name FactionName)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckHasPlayerMetFaction;
	Template.ConditionNames.AddItem(FactionName);

	return Template;
}

static function X2DataTemplate CreateIsLastMissionSourceCondition(name TemplateName, name MissionSource)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckLastMissionSource;
	Template.ConditionNames.AddItem(MissionSource);

	return Template;
}

static function X2DataTemplate CreateIsLastMissionFamilyCondition(name TemplateName, string MissionFamily)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckLastMissionFamily;
	Template.ConditionStrings.AddItem(MissionFamily);

	return Template;
}

static function X2DataTemplate CreateIsLastChosenEncounterMissionCondition(name TemplateName, name MissionSource)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckLastChosenEncounterMissionSource;
	Template.ConditionNames.AddItem(MissionSource);

	return Template;
}

static function X2DataTemplate CreateIsObjectiveCompleteCondition(name TemplateName, name ObjectiveName)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckObjectiveComplete;
	Template.ConditionNames.AddItem(ObjectiveName);

	return Template;
}

static function X2DataTemplate CreateIsAvatarProjectAlmostCompleteCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_Strategy_IsAvatarProjectAlmostComplete');
	Template.IsConditionMetFn = CheckAvatarProjectAlmostComplete;

	return Template;
}

static function X2DataTemplate CreateDidXComRecentlySabotageFacilityCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_Strategy_DidXComRecentlySabotageFacility');
	Template.IsConditionMetFn = CheckXComRecentlySabotagedFacility;

	return Template;
}

static function X2DataTemplate CreateHasPlayerSeenDazedTutorialCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_Strategy_HasPlayerSeenDazedTutorial');
	Template.IsConditionMetFn = CheckPlayerSeenDazedTutorial;

	return Template;
}

// #######################################################################################
// ----------------------- CONDITION FUNCTIONS -------------------------------------------
// #######################################################################################

static function bool CheckXComWonLastMission(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));
	if (XComHQ != none && XComHQ.LastMission.bXComWon)
	{
		return true;
	}

	return false;
}

static function bool CheckXComLostLastMission(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));
	if (XComHQ != none && !XComHQ.LastMission.bXComWon)
	{
		return true;
	}

	return false;
}

static function bool CheckXComLostVeteranLastMission(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));
	if (XComHQ != none && XComHQ.LastMission.bLostVeteran)
	{
		return true;
	}

	return false;
}

static function bool CheckXComBeatChosenLastMission(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersAlien AlienHQ;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));

	if (XComHQ != none && XComHQ.LastMission.bChosenEncountered)
	{
		if (AlienHQ != none && AlienHQ.LastChosenEncounter.bKilled)
		{
			return true;
		}
	}

	return false;
}

static function bool CheckChosenBeatXComLastMission(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersAlien AlienHQ;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));

	if (XComHQ != none && XComHQ.LastMission.bChosenEncountered)
	{
		if (AlienHQ != none && (AlienHQ.LastChosenEncounter.bCapturedSoldier || AlienHQ.LastChosenEncounter.bGainedKnowledge))
		{
			return true;
		}
	}

	return false;
}

static function bool CheckXComDefeatChosenLastEncounter(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_HeadquartersAlien AlienHQ;

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien', true));
	if (AlienHQ != none && AlienHQ.LastChosenEncounter.bDefeated)
	{
		return true;
	}

	return false;
}

static function bool CheckWasChosenOnLastMission(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_AdventChosen ChosenState;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	
	if (XComHQ != none && XComHQ.LastMission.bChosenEncountered)
	{
		if (AlienHQ != none && AlienHQ.LastAttackingChosen.ObjectID != 0)
		{
			ChosenState = XComGameState_AdventChosen(History.GetGameStateForObjectID(AlienHQ.LastAttackingChosen.ObjectID));
			if (Template.ConditionNames.Find(ChosenState.GetMyTemplateName()) != INDEX_NONE)
			{
				return true;
			}
		}
	}

	return false;
}

static function bool CheckIsChosenActive(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_AdventChosen ChosenState;
	local array<XComGameState_AdventChosen> AllChosen;

	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	AllChosen = AlienHQ.GetAllChosen(none, true); // Only return Chosen who have not been defeated

	foreach AllChosen(ChosenState)
	{
		// Ensure the Chosen is alive, has met XCOM, and has fought them in combat at least once
		if (Template.ConditionNames.Find(ChosenState.GetMyTemplateName()) != INDEX_NONE && ChosenState.bMetXCom && ChosenState.NumEncounters > 0)
		{
			return true;
		}
	}

	return false;
}

static function bool CheckIsChosenKnowledgeHalfway(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	return CheckChosenKnowledgeLevel(Template, eChosenKnowledge_Sentinel);
}

static function bool CheckIsChosenKnowledgeComplete(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	return CheckChosenKnowledgeLevel(Template, eChosenKnowledge_Raider);
}

static function bool CheckChosenKnowledgeLevel(X2DynamicNarrativeConditionTemplate Template, EChosenKnowledge KnowledgeLevel)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_AdventChosen ChosenState;
	local array<XComGameState_AdventChosen> AllChosen;

	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	AllChosen = AlienHQ.GetAllChosen();

	foreach AllChosen(ChosenState)
	{
		// Ensure the Chosens knowledge level matches the input
		if (Template.ConditionNames.Find(ChosenState.GetMyTemplateName()) != INDEX_NONE && ChosenState.GetKnowledgeLevel() == KnowledgeLevel)
		{
			return true;
		}
	}

	return false;
}

static function bool CheckDidXComRecoverChosenFragment(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_AdventChosen ChosenState;
	local XComGameState_ResistanceFaction FactionState;
	local array<XComGameState_AdventChosen> AllChosen;

	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	AllChosen = AlienHQ.GetAllChosen();

	foreach AllChosen(ChosenState)
	{		
		if (Template.ConditionNames.Find(ChosenState.GetMyTemplateName()) != INDEX_NONE)
		{
			FactionState = ChosenState.GetRivalFaction();
			if (FactionState.GetInfluence() > eFactionInfluence_Minimal)
			{
				return true;
			}
		}
	}

	return false;
}

static function bool CheckHasPlayerMetFaction(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameStateHistory History;
	local XComGameState_ResistanceFaction FactionState;

	History = `XCOMHISTORY;
	foreach History.IterateByClassType(class'XComGameState_ResistanceFaction', FactionState)
	{
		if (Template.ConditionNames.Find(FactionState.GetMyTemplateName()) != INDEX_NONE && FactionState.bMetXCom)
		{
			return true;
		}
	}

	return false;
}

static function bool CheckLastMissionSource(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));
	if (XComHQ != none)
	{
		if (Template.ConditionNames.Find(XComHQ.LastMission.MissionSource) != INDEX_NONE)
		{
			return true;
		}
	}

	return false;
}

static function bool CheckLastMissionFamily(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));
	if (XComHQ != none)
	{
		if (Template.ConditionStrings.Find(XComHQ.LastMission.MissionFamily) != INDEX_NONE)
		{
			return true;
		}
	}

	return false;
}

static function bool CheckLastChosenEncounterMissionSource(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_HeadquartersAlien AlienHQ;

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien', true));
	if (AlienHQ != none)
	{
		if (Template.ConditionNames.Find(AlienHQ.LastChosenEncounter.MissionSource) != INDEX_NONE)
		{
			return true;
		}
	}

	return false;
}

static function bool CheckObjectiveComplete(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local name ObjectiveName;

	if (Template.ConditionNames.Length == 0)
	{
		return false;
	}

	foreach Template.ConditionNames(ObjectiveName)
	{
		if (!class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted(ObjectiveName))
		{
			return false;
		}
	}

	return true;
}

static function bool CheckAvatarProjectAlmostComplete(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local float bDoomPercent;

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien', true));
	if (AlienHQ != none)
	{
		bDoomPercent = (1.0 * AlienHQ.GetCurrentDoom()) / AlienHQ.GetMaxDoom();
		if (bDoomPercent >= 0.75)
		{
			return true;
		}
	}

	return false;
}

static function bool CheckXComRecentlySabotagedFacility(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_HeadquartersAlien AlienHQ;

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien', true));
	if (AlienHQ != none && AlienHQ.bRecentlySabotagedFacility)
	{
		return true;
	}

	return false;
}

static function bool CheckPlayerSeenDazedTutorial(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));
	if (XComHQ != none)
	{
		return XComHQ.bHasSeenTacticalTutorialDazed;
	}

	return false;
}