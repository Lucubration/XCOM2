//---------------------------------------------------------------------------------------
//  FILE:    X2DynamicNarrative_ChosenWarlockNarratives.uc
//  AUTHOR:  Joe Weinhoffer --  8/11/2016
//  PURPOSE: Defines the Chosen Warlock's set of dynamic narrative templates.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DynamicNarrative_ChosenWarlockNarratives extends X2DynamicNarrative_DefaultDynamicNarratives;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	/////////////////////// MOMENTS ///////////////////////////////

	// Reveal
	Templates.AddItem(CreateChosenWarlockRevealPartATemplate());
	Templates.AddItem(CreateChosenWarlockRevealPartBTemplate());
	Templates.AddItem(CreateChosenWarlockSharedRevealPartATemplate());
	Templates.AddItem(CreateChosenWarlockSharedRevealPartBTemplate());

	// Engaged
	Templates.AddItem(CreateChosenWarlockEngagedFirstEncounterTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedLastChosenTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedTwoChosenRemainTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedBlacksiteTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedForgeTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedPsiGateTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedBroadcastTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedChosenStrongholdTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedAlienFortressTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedAlienFortressShowdownTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedFirstAvengerAssaultTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedAvengerAssaultTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedLastTimeKilledTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedLastTimeCapturedSoldierTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedLastTimeGainedKnowledgeTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedLastTimeHeavyXComLossesTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedInterimChosenKilledTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedInterimChosenDefeatedTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedInterimChosenBeatXComTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedInterimChosenBeatXComHeavyLossesTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedInterimChosenAvengerAssaultTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedInterimBlacksiteTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedInterimForgeTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedInterimPsiGateTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedInterimSabotageTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedInterimAvatarProjectTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedHasCaptiveSoldierTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedOtherChosenHaveCaptivesTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedXComRescuedSoldiersTemplate());
	Templates.AddItem(CreateChosenWarlockEngagedHuntAvengerTemplate());

	// Warlock Abilities
	Templates.AddItem(CreateChosenWarlockPossessTemplate());
	Templates.AddItem(CreateChosenWarlockCorruptTemplate());
	Templates.AddItem(CreateChosenWarlockCorressTemplate());
	Templates.AddItem(CreateChosenWarlockTeleportTemplate());
	Templates.AddItem(CreateChosenWarlockMindControlTemplate());
	Templates.AddItem(CreateChosenWarlockMindScorchTemplate());
	Templates.AddItem(CreateChosenWarlockRifleShotTemplate());
	Templates.AddItem(CreateChosenWarlockSpectralArmyTemplate());
	Templates.AddItem(CreateChosenWarlockSummonFollowersTemplate());

	// Warlock Extracts Knowledge Appproach
	Templates.AddItem(CreateChosenWarlockFirstExtractKnowledgeTemplate());
	Templates.AddItem(CreateChosenWarlockExtractKnowledgeTemplate());
	Templates.AddItem(CreateChosenWarlockExtractKnowledgePsiOperativeTemplate());
	Templates.AddItem(CreateChosenWarlockExtractKnowledgeReaperTemplate());
	Templates.AddItem(CreateChosenWarlockExtractKnowledgeSkirmisherTemplate());
	Templates.AddItem(CreateChosenWarlockExtractKnowledgeTemplarTemplate());
	Templates.AddItem(CreateChosenWarlockExtractKnowledgeJaneKellyTemplate());
	Templates.AddItem(CreateChosenWarlockExtractKnowledgeHighRankSoldierTemplate());

	// Warlock Extracts Knowledge Complete
	Templates.AddItem(CreateChosenWarlockExtractKnowledgeEscapeHealthyTemplate());
	Templates.AddItem(CreateChosenWarlockExtractKnowledgeEscapeWoundedTemplate());
	Templates.AddItem(CreateChosenWarlockExtractKnowledgeEscapeHeavyLossesTemplate());

	// Warlock Captures Soldier Approach
	Templates.AddItem(CreateChosenWarlockFirstCaptureTemplate());
	Templates.AddItem(CreateChosenWarlockCaptureTemplate());
	Templates.AddItem(CreateChosenWarlockCapturePsiOperativeTemplate());
	Templates.AddItem(CreateChosenWarlockCaptureReaperTemplate());
	Templates.AddItem(CreateChosenWarlockCaptureSkirmisherTemplate());
	Templates.AddItem(CreateChosenWarlockCaptureTemplarTemplate());
	Templates.AddItem(CreateChosenWarlockCaptureJaneKellyTemplate());
	Templates.AddItem(CreateChosenWarlockCaptureHighRankSoldierTemplate());

	// Warlock Captured Complete
	Templates.AddItem(CreateChosenWarlockCaptureEscapeHealthyTemplate());
	Templates.AddItem(CreateChosenWarlockCaptureEscapeWoundedTemplate());
	Templates.AddItem(CreateChosenWarlockCaptureEscapeHeavyLossesTemplate());

	// Warlock Killed
	Templates.AddItem(CreateChosenWarlockFirstTimeKilledTemplate());
	Templates.AddItem(CreateChosenWarlockKilledTemplate());

	// Turn Start
	Templates.AddItem(CreateChosenWarlockXCOMTurnBeginsStalkingTemplate());
	Templates.AddItem(CreateChosenWarlockXCOMTurnBeginsTemplate());
	Templates.AddItem(CreateChosenWarlockXCOMTurnBeginsAnticipateTemplate());
	Templates.AddItem(CreateChosenWarlockAlienTurnBeginsTemplate());
	Templates.AddItem(CreateChosenWarlockLostTurnBeginsTemplate());

	// Faction Taunts
	Templates.AddItem(CreateChosenWarlockReaperTauntsTemplate());
	Templates.AddItem(CreateChosenWarlockSkirmisherTauntsTemplate());
	Templates.AddItem(CreateChosenWarlockTemplarTauntsTemplate());

	// XCOM Attacks Non-Chosen
	//Templates.AddItem(CreateChosenWarlockXComAttacksMagWeaponsTemplate());
	//Templates.AddItem(CreateChosenWarlockXComAttacksBeamWeaponsTemplate());
	Templates.AddItem(CreateChosenWarlockXComAttacksChosenWeaponsTemplate());

	// XCOM Attacks Anyone
	Templates.AddItem(CreateChosenWarlockSoldierAttacksGrenadesTemplate());
	Templates.AddItem(CreateChosenWarlockRangerAttacksSwordTemplate());
	Templates.AddItem(CreateChosenWarlockPsiOperativeAttacksTemplate());
	Templates.AddItem(CreateChosenWarlockXComRecoversSoldierTemplate());

	// XCOM Kills
	Templates.AddItem(CreateChosenWarlockXComKillsAdventPriestTemplate());
	Templates.AddItem(CreateChosenWarlockXComKillsEnemyTemplate());
	Templates.AddItem(CreateChosenWarlockXComKillsLastVisibleEnemyTemplate());

	// XCOM Attacked
	Templates.AddItem(CreateChosenWarlockSoldierKilledByEnemyTemplate());
	Templates.AddItem(CreateChosenWarlockSoldierKilledByChosenTemplate());
	Templates.AddItem(CreateChosenWarlockSoldierWoundedByEnemyTemplate());
	Templates.AddItem(CreateChosenWarlockSoldierWoundedByChosenTemplate());
	Templates.AddItem(CreateChosenWarlockSoldierMissedByChosenTemplate());
	Templates.AddItem(CreateChosenWarlockCivilianKilledTemplate());

	// Chosen Attacked
	Templates.AddItem(CreateChosenWarlockAttackedByAlienHunterWeaponTemplate());
	Templates.AddItem(CreateChosenWarlockAttackedBySparkTemplate());
	Templates.AddItem(CreateChosenWarlockAttackedBySquadsightTemplate());
	Templates.AddItem(CreateChosenWarlockAttackedFirstMissTemplate());
	Templates.AddItem(CreateChosenWarlockAttackedMissTemplate());
	Templates.AddItem(CreateChosenWarlockAttackedMissBySkirmisherTemplate());
	Templates.AddItem(CreateChosenWarlockAttackedMissByTemplarTemplate());
	Templates.AddItem(CreateChosenWarlockAttackedFirstHitTemplate());
	Templates.AddItem(CreateChosenWarlockAttackedHitTemplate());
	Templates.AddItem(CreateChosenWarlockAttackedHitBySkirmisherTemplate());
	Templates.AddItem(CreateChosenWarlockAttackedHitByTemplarTemplate());
	Templates.AddItem(CreateChosenWarlockAttackedHitByReaperTemplate());

	/////////////////////// CONDITIONS /////////////////////////////
	Templates.AddItem(CreateIsChosenActiveCondition('NarrativeCondition_IsChosenWarlockActive', 'ChosenWarlock'));
	Templates.AddItem(CreateIsChosenEngagedCondition('NarrativeCondition_IsChosenWarlockEngaged', 'ChosenWarlock'));
	Templates.AddItem(CreateIsAlienActiveExcludeCharacterCondition('NarrativeCondition_IsAlienActiveExcludeChosenWarlock', 'ChosenWarlock'));
	Templates.AddItem(CreateIsEventSourceCharacterCondition('NarrativeCondition_IsEventSourceChosenWarlock', 'ChosenWarlock'));
	Templates.AddItem(CreateIsEventSourceNotCharacterCondition('NarrativeCondition_IsEventSourceNotChosenWarlock', 'ChosenWarlock'));
	Templates.AddItem(CreateIsAbilityTargetCharacterCondition('NarrativeCondition_IsAbilityTargetChosenWarlock', 'ChosenWarlock'));
	Templates.AddItem(CreateIsAbilityTargetNotCharacterCondition('NarrativeCondition_IsAbilityTargetNotChosenWarlock', 'ChosenWarlock'));
	Templates.AddItem(CreateIsAbilitySourceCharacterCondition('NarrativeCondition_IsAbilitySourceChosenWarlock', 'ChosenWarlock'));
	Templates.AddItem(CreateIsAbilitySourceNotCharacterCondition('NarrativeCondition_IsAbilitySourceNotChosenWarlock', 'ChosenWarlock'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityPossess', 'Possess'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityCorrupt', 'Corrupt'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityTeleport', 'TeleportAlly'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityMindControl', 'PsiMindControl'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityMindScorch', 'MindScorch'));
	Templates.AddItem(CreateIsMissionCondition('NarrativeCondition_IsMissionChosenWarlockShowdown', 'ChosenShowdown_Warlock'));
	Templates.AddItem(CreateIsNotMissionCondition('NarrativeCondition_IsMissionNotChosenWarlockShowdown', 'ChosenShowdown_Warlock'));

	Templates.AddItem(CreateIsAbilityCorressCondition());
	Templates.AddItem(CreateIsAbilitySpectralArmyCondition());

	return Templates;
}

static function X2DataTemplate CreateIsAbilityCorressCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsAbilityCorress');
	Template.IsConditionMetFn = CheckEventDataAbilityName;
	Template.ConditionNames.AddItem('Corress');
	Template.ConditionNames.AddItem('CorressM2');
	Template.ConditionNames.AddItem('CorressM3');
	Template.ConditionNames.AddItem('CorressM4');

	return Template;
}

static function X2DataTemplate CreateIsAbilitySpectralArmyCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsAbilitySpectralArmy');
	Template.IsConditionMetFn = CheckEventDataAbilityName;
	Template.ConditionNames.AddItem('SpectralArmy');
	Template.ConditionNames.AddItem('SpectralArmyM2');
	Template.ConditionNames.AddItem('SpectralArmyM3');
	Template.ConditionNames.AddItem('SpectralArmyM4');

	return Template;
}

// #######################################################################################
// -------------------------- MOMENTS ----------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenWarlockRevealPartATemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockRevealPartA');
	Template.EventTrigger = 'ScamperBegin';
	Template.NarrativeDeck = 'ChosenWarlockRevealPartA';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'RevealAI';
	Template.SequencedEventTrigger = 'Visualizer_ChosenReveal_LipSyncA';
	Template.MatineeNames.AddItem("CIN_ChosenWarlock_Reveal_2");
	Template.bIgnorePriority = true;

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Pod_Reveal_E', , , 'Warlock_Reveal_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Pod_Reveal_G', , , 'Warlock_Reveal_G');
	
	return Template;
}

static function X2DataTemplate CreateChosenWarlockRevealPartBTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockRevealPartB');
	Template.EventTrigger = 'ScamperBegin';
	Template.NarrativeDeck = 'ChosenWarlockRevealPartB';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'RevealAI';
	Template.SequencedEventTrigger = 'Visualizer_ChosenReveal_LipSyncB';
	Template.MatineeNames.AddItem("CIN_ChosenWarlock_Reveal_2");
	Template.bIgnorePriority = true;

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Pod_Reveal_E2', , , 'Warlock_Reveal_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Pod_Reveal_G2', , , 'Warlock_Reveal_G');
	
	return Template;
}

static function X2DataTemplate CreateChosenWarlockSharedRevealPartATemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockSharedRevealPartA');
	Template.EventTrigger = 'ScamperBegin';
	Template.NarrativeDeck = 'ChosenWarlockSharedRevealPartA';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'RevealAI';
	Template.SequencedEventTrigger = 'Visualizer_ChosenReveal_LipSyncA';
	Template.MatineeNames.AddItem("CIN_ChosenWarlock_Reveal_1");
	Template.bIgnorePriority = true;

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Pod_Reveal_F', , , 'Warlock_Reveal_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Pod_Reveal_J', , , 'Warlock_Reveal_J');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockSharedRevealPartBTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockSharedRevealPartB');
	Template.EventTrigger = 'ScamperBegin';
	Template.NarrativeDeck = 'ChosenWarlockSharedRevealPartB';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'RevealAI';
	Template.SequencedEventTrigger = 'Visualizer_ChosenReveal_LipSyncB';
	Template.MatineeNames.AddItem("CIN_ChosenWarlock_Reveal_1");
	Template.bIgnorePriority = true;

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Pod_Reveal_F2', , , 'Warlock_Reveal_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Pod_Reveal_J2', , , 'Warlock_Reveal_J');

	return Template;
}

// #######################################################################################
// --------------------------- ENGAGED ---------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenWarlockEngagedFirstEncounterTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedFirstEncounter');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedFirstEncounter';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_First_Time_Met_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_First_Encounter_A');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedLastChosenTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedLastChosen');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedLastChosen';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 5; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceLastChosen');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Last_Chosen_Alive_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Last_Chosen_Alive_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Last_Chosen_Alive_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Last_Chosen_Alive_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Last_Chosen_Alive_E');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedTwoChosenRemainTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedTwoChosenRemain');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedTwoChosenRemain';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenAssassinEngageTwoChosenRemain');
	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenSniperEngageTwoChosenRemain');

	Template.Priority = 5; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceLastTwoChosen');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Two_Chosen_Remain_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Two_Chosen_Remain_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Two_Chosen_Remain_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Two_Chosen_Remain_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Two_Chosen_Remain_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Two_Chosen_Remain_F');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedBlacksiteTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedBlacksite');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedBlacksite';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionBlacksite');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Golden_Path_Pod_Reveal_Blacksite');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedForgeTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedForge');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedForge';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionForge');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Golden_Path_Pod_Reveal_Forge');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedPsiGateTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedPsiGate');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedPsiGate';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionPsiGate');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Golden_Path_Pod_Reveal_PsiGate');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedBroadcastTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedBroadcast');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedBroadcast';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionBroadcast');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Golden_Path_Pod_Reveal_Tower');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedChosenStrongholdTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedChosenStronghold');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedChosenStronghold';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Stronghold_Start');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedAlienFortressTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedAlienFortress');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedAlienFortress';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionAlienFortress');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Final_Mission_Start');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedAlienFortressShowdownTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedAlienFortressShowdown');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedAlienFortressShowdown';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionAlienFortress');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Final_Mission_Start');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedFirstAvengerAssaultTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedFirstAvengerAssault');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedFirstAvengerAssault';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionAvengerAssault');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_First_Avenger_Assault_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_First_Avenger_Assault_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_First_Avenger_Assault_C');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedAvengerAssaultTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedAvengerAssault');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedAvengerAssault';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionAvengerAssault');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Subs_Avenger_Assault_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Subs_Avenger_Assault_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Subs_Avenger_Assault_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Subs_Avenger_Assault_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Subs_Avenger_Assault_E');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedLastTimeKilledTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedLastTimeKilled');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedLastTimeKilled';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 17; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenLastEncounterKilled');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Was_Defeated_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Was_Defeated_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Was_Defeated_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Was_Defeated_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Was_Defeated_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Was_Defeated_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Was_Defeated_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Was_Defeated_H');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedLastTimeCapturedSoldierTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedLastTimeCapturedSoldier');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedLastTimeCapturedSoldier';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 19; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenLastEncounterCapturedSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Captured_Last_Time_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Captured_Last_Time_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Captured_Last_Time_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Captured_Last_Time_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Captured_Last_Time_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Captured_Last_Time_F');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedLastTimeGainedKnowledgeTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedLastTimeGainedKnowledge');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedLastTimeGainedKnowledge';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 19; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenLastEncounterGainedKnowledge');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Gained_Know_Last_Time_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Gained_Know_Last_Time_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Gained_Know_Last_Time_C');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Extract_Know_Last_Time_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Extract_Know_Last_Time_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Extract_Know_Last_Time_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Extract_Know_Last_Time_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Extract_Know_Last_Time_E');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedLastTimeHeavyXComLossesTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedLastTimeHeavyXComLosses');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedLastTimeHeavyXComLosses';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 18; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenLastEncounterHeavyXComLosses');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Losses_Last_Time_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Losses_Last_Time_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Losses_Last_Time_C');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedInterimChosenKilledTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedInterimChosenKilled');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedInterimChosenKilled';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 16; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceOtherChosenLastEncounterKilled');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Interim_Chosen_Defeated_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Interim_Chosen_Defeated_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Interim_Chosen_Defeated_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Interim_Chosen_Defeated_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Interim_Chosen_Defeated_E');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedInterimChosenDefeatedTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedInterimChosenDefeated');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedInterimChosenDefeated';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 4; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceOtherChosenLastEncounterDefeated');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Interim_Chosen_Killed_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Interim_Chosen_Killed_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Interim_Chosen_Killed_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Interim_Chosen_Killed_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Interim_Chosen_Killed_E');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedInterimChosenBeatXComTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedInterimChosenBeatXCom');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedInterimChosenBeatXCom';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 16; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceOtherChosenLastEncounterBeatXCom');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Interim_Chosen_Defeat_XCOM_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Interim_Chosen_Defeat_XCOM_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Interim_Chosen_Defeat_XCOM_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Interim_Chosen_Defeat_XCOM_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Interim_Chosen_Defeat_XCOM_E');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Other_Chosen_Extract_Capture_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Other_Chosen_Extract_Capture_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Other_Chosen_Extract_Capture_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Other_Chosen_Extract_Capture_D');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedInterimChosenBeatXComHeavyLossesTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedInterimChosenBeatXComHeavyLosses');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedInterimChosenBeatXComHeavyLosses';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 15; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceOtherChosenLastEncounterBeatXComHeavyLosses');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Other_Chosen_Beat_XCOM_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Other_Chosen_Beat_XCOM_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Other_Chosen_Beat_XCOM_C');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedInterimChosenAvengerAssaultTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedInterimChosenAvengerAssault');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedInterimChosenAvengerAssault';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 6; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_Strategy_IsLastChosenEncounterAvengerAssault');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Interim_Chosen_Avenger_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Interim_Chosen_Avenger_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Interim_Chosen_Avenger_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Interim_Chosen_Avenger_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Interim_Chosen_Avenger_E');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedInterimBlacksiteTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedInterimBlacksite');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedInterimBlacksite';
	Template.bOncePerGame = true;

	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenAssassinEngagedInterimBlacksite');
	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenSniperEngagedInterimBlacksite');

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 12; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_Strategy_IsBlacksiteComplete');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Completed_Blacksite_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Completed_Blacksite_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Completed_Blacksite_C');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedInterimForgeTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedInterimForge');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedInterimForge';
	Template.bOncePerGame = true;

	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenAssassinEngagedInterimForge');
	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenSniperEngagedInterimForge');

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 11; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_Strategy_IsForgeComplete');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Completed_Forge_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Completed_Forge_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Completed_Forge_C');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedInterimPsiGateTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedInterimPsiGate');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedInterimPsiGate';
	Template.bOncePerGame = true;

	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenAssassinEngagedInterimPsiGate');
	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenSniperEngagedInterimPsiGate');

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 10; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_Strategy_IsPsiGateComplete');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Completed_Gate_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Completed_Gate_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Completed_Gate_C');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedInterimSabotageTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedInterimSabotage');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedInterimSabotage';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 8; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_Strategy_DidXComRecentlySabotageFacility');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Sabotaged_Facility_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Sabotaged_Facility_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Sabotaged_Facility_C');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedInterimAvatarProjectTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedInterimAvatarProject');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedInterimAvatarProject';
	Template.bOncePerGame = true;

	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenAssassinEngagedInterimAvatarProject');
	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenSniperEngagedInterimAvatarProject');

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 9; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_Strategy_IsAvatarProjectAlmostComplete');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Avatar_Almost_Complete_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Avatar_Almost_Complete_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Avatar_Almost_Complete_C');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedHasCaptiveSoldierTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedHasCaptiveSoldier');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedHasCaptiveSoldier';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 14; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenHasCaptiveSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Still_Has_Captive_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Still_Has_Captive_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Still_Has_Captive_C');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedOtherChosenHaveCaptivesTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockCaptureOtherChosenHaveCaptives');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockCaptureOtherChosenHaveCaptives';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 14; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceOtherChosenHaveCaptiveSoldiers');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Other_Chosen_Have_Captives_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Other_Chosen_Have_Captives_B');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedXComRescuedSoldiersTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedXComRescuedSoldiers');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockCaptureXComRescuedSoldiers';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 13; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenXComRescuedSoldiers');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Rescued_Captive_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Rescued_Captive_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Rescued_Captive_C');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockEngagedHuntAvengerTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockEngagedHuntAvenger');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEngagedHuntAvenger';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 7; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenKnowledgeHuntingAvenger');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Close_To_Avenger_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Close_To_Avenger_B');

	return Template;
}

// #######################################################################################
// --------------------------- ABILITIES -------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenWarlockPossessTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockPossess');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockPossess';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'AttackBegin';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityPossess');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Possess_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Possess_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Possess_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Possess_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Possess_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Possess_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Possess_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Possess_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Possess_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Possess_J');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockCorruptTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockCorrupt');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockCorrupt';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'AttackBegin';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityCorrupt');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Corrupt_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Corrupt_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Corrupt_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Corrupt_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Corrupt_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Corrupt_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Corrupt_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Corrupt_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Corrupt_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Corrupt_J');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockCorressTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockCorress');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockCorress';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'AttackBegin';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityCorress');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Possess_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Possess_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Possess_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Possess_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Possess_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Possess_J');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Corrupt_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Corrupt_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Corrupt_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Corrupt_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Corrupt_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Corrupt_J');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockTeleportTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockTeleport');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockTeleport';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'AttackBegin';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTeleport');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Teleport_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Teleport_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Teleport_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Teleport_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Teleport_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Teleport_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Teleport_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Teleport_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Teleport_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Teleport_J');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockMindControlTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockMindControl');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockMindControl';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'AttackBegin';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityMindControl');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_MindControl_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_MindControl_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_MindControl_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_MindControl_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_MindControl_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_MindControl_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_MindControl_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_MindControl_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_MindControl_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_MindControl_J');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Has_XCOM_Bodyguards_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Has_XCOM_Bodyguards_B');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockMindScorchTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockMindScorch');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockMindScorch';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'AttackBegin';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityMindScorch');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_MindScorch_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_MindScorch_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_MindScorch_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_MindScorch_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_MindScorch_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_MindScorch_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_MindScorch_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_MindScorch_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_MindScorch_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_MindScorch_J');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockRifleShotTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockRifleShot');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockRifleShot';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'AttackBegin';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityStandardShot');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_RifleShot_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_RifleShot_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_RifleShot_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_RifleShot_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_RifleShot_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_RifleShot_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_RifleShot_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_RifleShot_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_RifleShot_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_RifleShot_J');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockSpectralArmyTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockSpectralArmy');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockSpectralArmy';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'AttackBegin';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilitySpectralArmy');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_SpectralArmy_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_SpectralArmy_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_SpectralArmy_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_SpectralArmy_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_SpectralArmy_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_SpectralArmy_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_SpectralArmy_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_SpectralArmy_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_SpectralArmy_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_SpectralArmy_J');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockSummonFollowersTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockSummonFollowers');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockSummonFollowers';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenSummonBegin';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenSummonFollowers');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Calling_Reinforcements_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Calling_Reinforcements_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Calling_Reinforcements_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Calling_Reinforcements_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Calling_Reinforcements_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Calling_Reinforcements_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Calling_Reinforcements_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Calling_Reinforcements_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Calling_Reinforcements_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Calling_Reinforcements_J');

	return Template;
}

// #######################################################################################
// --------------------------- EXTRACT ---------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenWarlockFirstExtractKnowledgeTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockFirstExtractKnowledge');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockFirstExtractKnowledge';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 4; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledgeMove');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_First_Extraction_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_First_Extraction_B');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockExtractKnowledgeTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockExtractKnowledge');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockExtractKnowledge';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 5; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledgeMove');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Generic_Extract_Know_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Generic_Extract_Know_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Generic_Extract_Know_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Generic_Extract_Know_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Generic_Extract_Know_E');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockExtractKnowledgePsiOperativeTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockExtractKnowledgePsiOperative');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockExtractKnowledgePsiOperative';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledgeMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetPsiOperative');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Extract_Know_Psi_Op_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Extract_Know_Psi_Op_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Extract_Know_Psi_Op_C');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockExtractKnowledgeReaperTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockExtractKnowledgeReaper');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockExtractKnowledgeReaper';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledgeMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetReaperSoldier');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Extract_Know_Reaper_A');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockExtractKnowledgeSkirmisherTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockExtractKnowledgeSkirmisher');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockExtractKnowledgeSkirmisher';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledgeMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetSkirmisherSoldier');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Extract_Know_Skirmisher_A');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockExtractKnowledgeTemplarTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockExtractKnowledgeTemplar');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockExtractKnowledgeTemplar';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledgeMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetTemplarSoldier');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Extract_Know_Templar_A');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockExtractKnowledgeJaneKellyTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockExtractKnowledgeJaneKelly');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockExtractKnowledgeJaneKelly';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledgeMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetJaneKelly');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Extract_Know_Jane_Kelly_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Extract_Know_Jane_Kelly_B');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockExtractKnowledgeHighRankSoldierTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockExtractKnowledgeHighRankSoldier');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockExtractKnowledgeHighRankSoldier';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledgeMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetHighRankSoldier');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Extract_Know_High_Rank_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Extract_Know_High_Rank_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Extract_Know_High_Rank_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Extract_Know_High_Rank_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Extract_Know_High_Rank_E');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockExtractKnowledgeEscapeHealthyTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockExtractKnowledgeEscapeHealthy');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockExtractKnowledgeEscapeHealthy';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenTacticalEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledge');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceUnitHealthy');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Healthy_Escape_Extract_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Healthy_Escape_Extract_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Healthy_Escape_Extract_C');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockExtractKnowledgeEscapeWoundedTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockExtractKnowledgeEscapeWounded');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockExtractKnowledgeEscapeWounded';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenTacticalEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledge');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceUnitWounded');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Wounded_Escape_Extract_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Wounded_Escape_Extract_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Wounded_Escape_Extract_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Wounded_Escape_Extract_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Wounded_Escape_Extract_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Wounded_Escape_Extract_F');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockExtractKnowledgeEscapeHeavyLossesTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockExtractKnowledgeEscapeHeavyLosses');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockEscapeKnowledgeEscapeHeavyLosses';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenTacticalEscape';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledge');
	Template.Conditions.AddItem('NarrativeCondition_IsXComSufferingHeavyLosses');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Loss_Escape_Extract_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Loss_Escape_Extract_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Loss_Escape_Extract_C');

	return Template;
}

// #######################################################################################
// --------------------------- CAPTURE ---------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenWarlockFirstCaptureTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockFirstCapture');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockFirstCapture';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 4; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnapMove');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_First_Soldier_Capture_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_First_Soldier_Capture_B');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockCaptureTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockCapture');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockCapture';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 5; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnapMove');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Generic_Soldier_Capture_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Generic_Soldier_Capture_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Generic_Soldier_Capture_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Generic_Soldier_Capture_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Generic_Soldier_Capture_E');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Captures_Multiple_Soldiers_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Captures_Multiple_Soldiers_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Captures_Multiple_Soldiers_C');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockCapturePsiOperativeTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockCapturePsiOperative');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockCapturePsiOperative';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnapMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetPsiOperative');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Captures_Psi_Op_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Captures_Psi_Op_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Captures_Psi_Op_C');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockCaptureReaperTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockCaptureReaper');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockCaptureReaper';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnapMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetReaperSoldier');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Captures_Reaper_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Captures_Reaper_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Captures_Reaper_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Captures_Reaper_D');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockCaptureSkirmisherTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockCaptureSkirmisher');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockCaptureSkirmisher';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnapMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetSkirmisherSoldier');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Captures_Skirmisher_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Captures_Skirmisher_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Captures_Skirmisher_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Captures_Skirmisher_D');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockCaptureTemplarTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockCaptureTemplar');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockCaptureTemplar';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnapMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetTemplarSoldier');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Captures_Templar_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Captures_Templar_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Captures_Templar_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Captures_Templar_D');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockCaptureJaneKellyTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockCaptureJaneKelly');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockCaptureJaneKelly';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnapMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetJaneKelly');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Captures_Jane');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockCaptureHighRankSoldierTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockCaptureHighRankSoldier');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockCaptureHighRankSoldier';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnapMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetHighRankSoldier');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Captures_High_Rank_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Captures_High_Rank_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Captures_High_Rank_C');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockCaptureEscapeHealthyTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockCaptureEscapeHealthy');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockCaptureEscapeHealthy';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenTacticalEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnap');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceUnitHealthy');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Healthy_Escape_Capture_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Healthy_Escape_Capture_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Healthy_Escape_Capture_C');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockCaptureEscapeWoundedTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockCaptureEscapeWounded');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockCaptureEscapeWounded';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenTacticalEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnap');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceUnitWounded');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Wounded_Escape_Capture_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Wounded_Escape_Capture_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Wounded_Escape_Capture_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Wounded_Escape_Capture_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Wounded_Escape_Capture_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Wounded_Escape_Capture_F');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockCaptureEscapeHeavyLossesTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockCaptureEscapeHeavyLosses');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockCaptureEscapeHeavyLosses';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnap');
	Template.Conditions.AddItem('NarrativeCondition_IsXComSufferingHeavyLosses');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Loss_Escape_Capture_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Loss_Escape_Capture_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Loss_Escape_Capture_C');

	return Template;
}

// #######################################################################################
// ----------------------------- WARLOCK KILLED ------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenWarlockFirstTimeKilledTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockFirstTimeKilled');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockFirstTimeKilled';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenTacticalEscape';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenDefeatedEscape');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Flees_First_Defeat_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Flees_First_Defeat_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Flees_First_Defeat_C');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockKilledTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockKilled');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockKilled';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenTacticalEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenDefeatedEscape');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Flees_Multiple_Defeats_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Flees_Multiple_Defeats_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Flees_Multiple_Defeats_C');

	return Template;
}

// #######################################################################################
// --------------------------- TURN START ------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenWarlockXCOMTurnBeginsStalkingTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockXCOMTurnBeginsStalking');
	Template.EventTrigger = 'PlayerTurnBegun';
	Template.NarrativeDeck = 'ChosenWarlockXCOMTurnBeginsStalking';

	Template.Priority = 4; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceXComPlayer');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');
	Template.Conditions.AddItem('NarrativeCondition_IsTurnStartRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Stalking_XCOM_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Stalking_XCOM_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Stalking_XCOM_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Stalking_XCOM_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Stalking_XCOM_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Stalking_XCOM_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Stalking_XCOM_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Stalking_XCOM_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Stalking_XCOM_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Stalking_XCOM_J');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockXCOMTurnBeginsTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockXCOMTurnBegins');
	Template.EventTrigger = 'PlayerTurnBegun';
	Template.NarrativeDeck = 'ChosenWarlockXCOMTurnBegins';

	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceXComPlayer');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');
	Template.Conditions.AddItem('NarrativeCondition_IsTurnStartRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Taunts_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Taunts_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Taunts_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Taunts_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Taunts_E');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Turn_Begins_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Turn_Begins_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Turn_Begins_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Turn_Begins_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Turn_Begins_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Turn_Begins_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Turn_Begins_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Turn_Begins_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Turn_Begins_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Turn_Begins_J');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockXCOMTurnBeginsAnticipateTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockXCOMTurnBeginsAnticipate');
	Template.EventTrigger = 'PlayerTurnBegun';
	Template.NarrativeDeck = 'ChosenWarlockXCOMTurnBeginsAnticipate';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceXComPlayer');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsXComSoldierDazedCondition');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenWarlockShowdown');
	Template.Conditions.AddItem('NarrativeCondition_IsTurnStartRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Disabled_Anticipate_Extract_Capture_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Disabled_Anticipate_Extract_Capture_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Disabled_Anticipate_Extract_Capture_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Disabled_Anticipate_Extract_Capture_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Disabled_Anticipate_Extract_Capture_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Disabled_Anticipate_Extract_Capture_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Disabled_Anticipate_Extract_Capture_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Disabled_Anticipate_Extract_Capture_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Disabled_Anticipate_Extract_Capture_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Disabled_Anticipate_Extract_Capture_J');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockAlienTurnBeginsTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockAlienTurnBegins');
	Template.EventTrigger = 'PlayerTurnBegun';
	Template.NarrativeDeck = 'ChosenWarlockAlienTurnBegins';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceAlienPlayer');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsAlienActiveExcludeChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsTurnStartRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_AI_Turn_Begins_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_AI_Turn_Begins_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_AI_Turn_Begins_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_AI_Turn_Begins_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_AI_Turn_Begins_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_AI_Turn_Begins_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_AI_Turn_Begins_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_AI_Turn_Begins_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_AI_Turn_Begins_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_AI_Turn_Begins_J');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockLostTurnBeginsTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockLostTurnBegins');
	Template.EventTrigger = 'PlayerTurnBegun';
	Template.NarrativeDeck = 'ChosenWarlockLostTurnBegins';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceLostPlayer');
	Template.Conditions.AddItem('NarrativeCondition_AreLostActive');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsTurnStartRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Lost_Turn_Begins_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Lost_Turn_Begins_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Lost_Turn_Begins_C');

	return Template;
}

// #######################################################################################
// ------------------------------- FACTION TAUNTS ----------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenWarlockReaperTauntsTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockReaperTaunts');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockReaperTaunts';
	Template.bOncePerMission = true;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceReaperSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceUnitNotConcealed');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityStandardMove');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Reaper_Taunts_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Reaper_Taunts_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Reaper_Taunts_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Reaper_Taunts_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Reaper_Taunts_E');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockSkirmisherTauntsTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockSkirmisherTaunts');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockSkirmisherTaunts';
	Template.bOncePerMission = true;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSkirmisherSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceUnitNotConcealed');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityStandardMove');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Skirmisher_Taunts_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Skirmisher_Taunts_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Skirmisher_Taunts_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Skirmisher_Taunts_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Skirmisher_Taunts_E');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockTemplarTauntsTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockTemplarTaunts');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockTemplarTaunts';
	Template.bOncePerMission = true;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceTemplarSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceUnitNotConcealed');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityStandardMove');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Templar_Taunts_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Templar_Taunts_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Templar_Taunts_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Templar_Taunts_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Templar_Taunts_E');

	return Template;
}

// #######################################################################################
// --------------------------- XCOM ATTACKS ----------------------------------------------
// #######################################################################################

//static function X2DataTemplate CreateChosenWarlockXComAttacksMagWeaponsTemplate()
//{
//	local X2DynamicNarrativeMomentTemplate Template;
//
//	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockXComAttacksMagWeapons');
//	Template.EventTrigger = 'AbilityActivated';
//	Template.NarrativeDeck = 'ChosenWarlockXComAttacksMagWeapons';
//	Template.bOncePerMission = true;
//
//	Template.bSequencedNarrative = true;
//	Template.SequencedEventTag = 'AttackResult';
//
//	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions
//
//	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
//	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
//	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
//	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetNotChosenWarlock');
//	Template.Conditions.AddItem('NarrativeCondition_IsAbilityWeaponMagnetic');
//
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Mag_Weapons_A');
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Mag_Weapons_B');
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Mag_Weapons_C');
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Mag_Weapons_D');
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Mag_Weapons_E');
//
//	return Template;
//}
//
//static function X2DataTemplate CreateChosenWarlockXComAttacksBeamWeaponsTemplate()
//{
//	local X2DynamicNarrativeMomentTemplate Template;
//
//	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockXComAttacksBeamWeapons');
//	Template.EventTrigger = 'AbilityActivated';
//	Template.NarrativeDeck = 'ChosenWarlockXComAttacksBeamWeapons';
//	Template.bOncePerMission = true;
//
//	Template.bSequencedNarrative = true;
//	Template.SequencedEventTag = 'AttackResult';
//
//	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions
//
//	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
//	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
//	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
//	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetNotChosenWarlock');
//	Template.Conditions.AddItem('NarrativeCondition_IsAbilityWeaponBeam');
//
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Beam_Weapons_A');
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Beam_Weapons_B');
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Beam_Weapons_C');
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Beam_Weapons_D');
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Beam_Weapons_E');
//
//	return Template;
//}

static function X2DataTemplate CreateChosenWarlockXComAttacksChosenWeaponsTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockXComAttacksChosenWeapons');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockXComAttacksChosenWeapons';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityWeaponChosen');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Uses_Chosen_Weapon_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Uses_Chosen_Weapon_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Uses_Chosen_Weapon_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Uses_Chosen_Weapon_D');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockSoldierAttacksGrenadesTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockSoldierAttacksGrenades');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockSoldierAttacksGrenades';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityStandardGrenade');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Attacks_With_Grenades_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Attacks_With_Grenades_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Attacks_With_Grenades_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Attacks_With_Grenades_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Attacks_With_Grenades_E');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockRangerAttacksSwordTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockRangerAttacksSword');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockRangerAttacksSword';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceRanger');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetNotChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilitySwordSlice');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Ranger_Sword_Attack_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Ranger_Sword_Attack_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Ranger_Sword_Attack_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Ranger_Sword_Attack_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Ranger_Sword_Attack_E');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockPsiOperativeAttacksTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockPsiOperativeAttacks');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockPsiOperativeAttacks';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourcePsiOperative');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityNotSolaceCleanse');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetNotChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');
	
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Psi_Operative_Attack_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Psi_Operative_Attack_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Psi_Operative_Attack_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Psi_Operative_Attack_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Psi_Operative_Attack_E');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockXComRecoversSoldierTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockXComRecoversSoldier');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockXComRecoversSoldier';
	Template.bOncePerMission = true;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityRevive');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Attempts_Rescue_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Attempts_Rescue_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Attempts_Rescue_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Attempts_Rescue_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Attempts_Rescue_E');

	return Template;
}

// #######################################################################################
// --------------------------- XCOM KILLS ------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenWarlockXComKillsAdventPriestTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockXComKillsAdventPriest');
	Template.EventTrigger = 'UnitDied';
	Template.NarrativeDeck = 'ChosenWarlockXComKillsAdventPriest';
	Template.bOncePerTurn = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceAdventPriest');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Kills_Priest_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Kills_Priest_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Kills_Priest_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Kills_Priest_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Kills_Priest_E');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockXComKillsEnemyTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockXComKillsEnemy');
	Template.EventTrigger = 'UnitDied';
	Template.NarrativeDeck = 'ChosenWarlockXComKillsEnemy';
	Template.bOncePerTurn = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceAlienTeam');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceNotChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Kills_Hostiles_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Kills_Hostiles_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Kills_Hostiles_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Kills_Hostiles_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Kills_Hostiles_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Kills_Hostiles_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Kills_Hostiles_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Kills_Hostiles_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Kills_Hostiles_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Kills_Hostiles_J');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockXComKillsLastVisibleEnemyTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockXComKillsLastVisibleEnemy');
	Template.EventTrigger = 'UnitDied';
	Template.NarrativeDeck = 'ChosenWarlockXComKillsLastVisibleEnemy';
	Template.bOncePerTurn = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceNotChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetLastVisibleEnemy');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Last_Visible_Hostile_Killed_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Last_Visible_Hostile_Killed_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Last_Visible_Hostile_Killed_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Last_Visible_Hostile_Killed_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Last_Visible_Hostile_Killed_E');

	return Template;
}

// #######################################################################################
// --------------------------- XCOM ATTACKED ---------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenWarlockSoldierKilledByEnemyTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockSoldierKilledByEnemy');
	Template.EventTrigger = 'KillMail';
	Template.NarrativeDeck = 'ChosenWarlockSoldierKilledByEnemy';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventDataSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Killed_By_Hostiles_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Killed_By_Hostiles_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Killed_By_Hostiles_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Killed_By_Hostiles_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Killed_By_Hostiles_E');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockSoldierKilledByChosenTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockSoldierKilledByChosen');
	Template.EventTrigger = 'KillMail';
	Template.NarrativeDeck = 'ChosenWarlockSoldierKilledByChosen';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventDataSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Killed_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Killed_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Killed_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Killed_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Killed_E');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockSoldierWoundedByEnemyTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockSoldierWoundedByEnemy');
	Template.EventTrigger = 'UnitTakeEffectDamage';
	Template.NarrativeDeck = 'ChosenWarlockSoldierWoundedByEnemy';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventDataSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsEventDataUnitAlive'); // Don't play the wounded narrative if the soldier was killed from the attack
	Template.Conditions.AddItem('NarrativeCondition_IsAbilitySourceEnemyTeam');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilitySourceNotChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Wounded_By_Hostiles_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Wounded_By_Hostiles_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Wounded_By_Hostiles_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Wounded_By_Hostiles_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Wounded_By_Hostiles_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Wounded_By_Hostiles_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Wounded_By_Hostiles_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Wounded_By_Hostiles_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Wounded_By_Hostiles_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Wounded_By_Hostiles_J');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockSoldierWoundedByChosenTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockSoldierWoundedByChosen');
	Template.EventTrigger = 'UnitTakeEffectDamage';
	Template.NarrativeDeck = 'ChosenWarlockSoldierWoundedByChosen';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventDataSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsEventDataUnitAlive'); // Don't play the wounded narrative if the soldier was killed from the attack
	Template.Conditions.AddItem('NarrativeCondition_IsAbilitySourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Wounded_Not_Killed_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Wounded_Not_Killed_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Wounded_Not_Killed_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Wounded_Not_Killed_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Wounded_Not_Killed_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Wounded_Not_Killed_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Wounded_Not_Killed_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Wounded_Not_Killed_H');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockSoldierMissedByChosenTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockSoldierMissedByChosen');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockSoldierMissedByChosen';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityMiss');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Missed_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Missed_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Missed_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Missed_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Missed_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Missed_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Missed_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Soldier_Missed_H');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockCivilianKilledTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockCivilianKilled');
	Template.EventTrigger = 'KillMail';
	Template.NarrativeDeck = 'ChosenWarlockCivilianKilled';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventDataCivilian');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Retaliation_Taunt_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Retaliation_Taunt_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Retaliation_Taunt_C');

	return Template;
}

// #######################################################################################
// --------------------------- CHOSEN ATTACKED -------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenWarlockAttackedByAlienHunterWeaponTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockAttackedByAlienHunterWeapon');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockAttackedByAlienHunterWeapon';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityWeaponAlienHunter');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Attacks_With_Hunter_Weap_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Attacks_With_Hunter_Weap_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Attacks_With_Hunter_Weap_C');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockAttackedBySparkTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockAttackedBySpark');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockAttackedBySpark';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSparkSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Spark_Attacks_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Spark_Attacks_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Spark_Attacks_C');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockAttackedBySquadsightTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockAttackedBySquadsight');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockAttackedBySquadsight';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetFromSquadsight');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Attacks_With_Squadsight_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Attacks_With_Squadsight_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Attacks_With_Squadsight_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Attacks_With_Squadsight_D');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockAttackedFirstMissTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockAttackedFirstMiss');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockAttackedFirstMiss';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 4; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityMiss');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Misses_Chosen_First_Time_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Misses_Chosen_First_Time_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Misses_Chosen_First_Time_C');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockAttackedMissTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockAttackedMiss');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockAttackedMiss';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 5; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityMiss');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Subsequent_Misses_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Subsequent_Misses_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Subsequent_Misses_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Subsequent_Misses_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Subsequent_Misses_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Subsequent_Misses_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Subsequent_Misses_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Subsequent_Misses_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Subsequent_Misses_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Subsequent_Misses_J');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockAttackedMissBySkirmisherTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockAttackedMissBySkirmisher');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockAttackedMissBySkirmisher';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSkirmisherSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityMiss');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Faction_Miss_Skirmisher_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Faction_Miss_Skirmisher_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Faction_Miss_Skirmisher_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Faction_Miss_Skirmisher_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Faction_Miss_Skirmisher_E');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockAttackedMissByTemplarTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockAttackedMissByTemplar');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockAttackedMissByTemplar';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceTemplarSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityMiss');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Faction_Miss_Templar_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Faction_Miss_Templar_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Faction_Miss_Templar_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Faction_Miss_Templar_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Faction_Miss_Templar_E');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockAttackedFirstHitTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockAttackedFirstHit');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockAttackedFirstHit';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 4; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHit');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Hits_Chosen_First_Time_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Hits_Chosen_First_Time_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Hits_Chosen_First_Time_C');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockAttackedHitTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockAttackedHit');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockAttackedHit';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 5; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHit');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Subsequent_Hits_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Subsequent_Hits_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Subsequent_Hits_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Subsequent_Hits_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Subsequent_Hits_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Subsequent_Hits_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Subsequent_Hits_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Subsequent_Hits_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Subsequent_Hits_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_XCOM_Subsequent_Hits_J');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Wounded_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Wounded_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Chosen_Wounded_C');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockAttackedHitBySkirmisherTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockAttackedHitBySkirmisher');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockAttackedHitBySkirmisher';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSkirmisherSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHit');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Faction_Hit_Skirmisher_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Faction_Hit_Skirmisher_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Faction_Hit_Skirmisher_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Faction_Hit_Skirmisher_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Faction_Hit_Skirmisher_E');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockAttackedHitByTemplarTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockAttackedHitByTemplar');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockAttackedHitByTemplar';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceTemplarSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHit');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Faction_Hit_Templar_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Faction_Hit_Templar_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Faction_Hit_Templar_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Faction_Hit_Templar_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Faction_Hit_Templar_E');

	return Template;
}

static function X2DataTemplate CreateChosenWarlockAttackedHitByReaperTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenWarlockAttackedHitByReaper');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenWarlockAttackedHitByReaper';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenWarlockActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceReaperSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHit');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenWarlock');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Faction_Hit_Reaper_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Faction_Hit_Reaper_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Faction_Hit_Reaper_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Faction_Hit_Reaper_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_WRLK_T_Faction_Hit_Reaper_E');

	return Template;
}