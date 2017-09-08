//---------------------------------------------------------------------------------------
//  FILE:    X2DynamicNarrative_Central.uc
//  AUTHOR:  Joe Weinhoffer --  12/5/2016
//  PURPOSE: Defines the Central's set of dynamic narrative templates.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DynamicNarrative_Central extends X2DynamicNarrative_DefaultDynamicNarratives;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	/////////////////////// MOMENTS ///////////////////////////////

	// Chosen
	Templates.AddItem(CreateCentralChosenMapBehaviorTemplate());
	Templates.AddItem(CreateCentralChosenAssassinMapBehaviorTemplate());
	
	Templates.AddItem(CreateCentralChosenSniperEngagedTemplate());
	Templates.AddItem(CreateCentralChosenWarlockEngagedTemplate());
	Templates.AddItem(CreateCentralChosenEngagedTemplate());
	
	Templates.AddItem(CreateCentralChosenIncapacitatesSoldierTemplate());
	Templates.AddItem(CreateCentralChosenExtractsKnowledgeTemplate());
	Templates.AddItem(CreateCentralChosenCapturesSoldierTemplate());
	Templates.AddItem(CreateCentralXCOMKillsChosenTemplate());

	Templates.AddItem(CreateCentralWillRemindersTemplate());

	return Templates;
}

// #######################################################################################
// -------------------------- MOMENTS ----------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateCentralChosenMapBehaviorTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_CentralChosenMapBehavior');
	Template.EventTrigger = 'ScamperEnd';
	Template.NarrativeDeck = 'CentralChosenMapBehavior';
	Template.NarrativePlayTiming = SPT_AfterParallel;
	
	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosen');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceNotChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsNotChosenShowdownMission');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Chosen_Starts_Beh_Non_Assn');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Chosen_Starts_Map_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Chosen_Starts_Map_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Chosen_Starts_Map_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Chosen_Starts_Map_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Chosen_Starts_Map_E');

	return Template;
}

static function X2DataTemplate CreateCentralChosenAssassinMapBehaviorTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_CentralChosenAssassinMapBehavior');
	Template.EventTrigger = 'ScamperEnd';
	Template.NarrativeDeck = 'CentralChosenAssassinMapBehavior';
	Template.NarrativePlayTiming = SPT_AfterParallel;
	
	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotLostAndAbandoned');
	Template.Conditions.AddItem('NarrativeCondition_IsNotChosenShowdownMission');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Chosen_Starts_Beh_Assn');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Assassin_Starts_Map_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Assassin_Starts_Map_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Assassin_Starts_Map_C');
	
	return Template;
}

static function X2DataTemplate CreateCentralChosenSniperEngagedTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_CentralChosenSniperEngaged');
	Template.EventTrigger = 'AbilityActivated';
	Template.bOncePerGame = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsNotChosenShowdownMission');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_First_Hunter_Sighting');

	return Template;
}

static function X2DataTemplate CreateCentralChosenWarlockEngagedTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_CentralChosenWarlockEngaged');
	Template.EventTrigger = 'AbilityActivated';
	Template.bOncePerGame = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsNotChosenShowdownMission');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_First_Warlock_Sighting');

	return Template;
}

static function X2DataTemplate CreateCentralChosenEngagedTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_CentralChosenEngaged');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'CentralChosenEngaged';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosen');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotLostAndAbandoned');
	Template.Conditions.AddItem('NarrativeCondition_IsNotChosenShowdownMission');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Chosen_Reveal_Engaged_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Chosen_Reveal_Engaged_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Chosen_Reveal_Engaged_C');
	
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Squad_Engages_Chosen_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Squad_Engages_Chosen_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Squad_Engages_Chosen_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Squad_Engages_Chosen_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Squad_Engages_Chosen_E');

	return Template;
}

static function X2DataTemplate CreateCentralChosenIncapacitatesSoldierTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_CentralChosenIncapacitatesSoldier');
	Template.EventTrigger = 'PlayerTurnBegun';
	Template.NarrativeDeck = 'CentralChosenIncapacitatesSoldier';
	Template.bOncePerMission = true;
	
	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceXComPlayer');
	Template.Conditions.AddItem('NarrativeCondition_IsXComSoldierDazedCondition');
	Template.Conditions.AddItem('NarrativeCondition_IsAnyChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_Strategy_HasPlayerSeenDazedTutorial');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Chosen_Incapacitate_Soldier');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Chosen_Dazes_Soldier_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Chosen_Dazes_Soldier_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Chosen_Dazes_Soldier_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Chosen_Dazes_Soldier_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Chosen_Dazes_Soldier_E');

	return Template;
}

static function X2DataTemplate CreateCentralChosenExtractsKnowledgeTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_CentralChosenExtractsKnowledge');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'CentralChosenExtractsKnowledge';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosen');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledge');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Chosen_Extracts_Knowledge');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Post_Mission_Extracted_Knowledge_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Post_Mission_Extracted_Knowledge_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Post_Mission_Extracted_Knowledge_C');

	return Template;
}

static function X2DataTemplate CreateCentralChosenCapturesSoldierTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_CentralChosenCapturesSoldier');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'CentralChosenCapturesSoldier';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosen');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnap');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Chosen_Captures_Soldier');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Post_Mission_Soldier_Captured_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Post_Mission_Soldier_Captured_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Post_Mission_Soldier_Captured_C');

	return Template;
}

static function X2DataTemplate CreateCentralXCOMKillsChosenTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_CentralXCOMKillsChosen');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'CentralXCOMKillsChosen';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosen');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenDefeatedEscape');
	Template.Conditions.AddItem('NarrativeCondition_IsNotChosenShowdownMission');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_XCOM_Killed_Chosen');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Post_Mission_Chosen_Sorta_Killed_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Post_Mission_Chosen_Sorta_Killed_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Post_Mission_Chosen_Sorta_Killed_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Post_Mission_Chosen_Sorta_Killed_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Post_Mission_Chosen_Sorta_Killed_E');

	return Template;
}

static function X2DataTemplate CreateCentralWillRemindersTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_CentralWillReminders');
	Template.EventTrigger = 'DoPanicAbility';
	Template.NarrativeDeck = 'CentralWillReminders';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions
	
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Will_System_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Will_System_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Will_System_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Will_System_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_Will_System_E');

	return Template;
}