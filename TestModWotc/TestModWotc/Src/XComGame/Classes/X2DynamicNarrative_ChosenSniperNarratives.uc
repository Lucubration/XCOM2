//---------------------------------------------------------------------------------------
//  FILE:    X2DynamicNarrative_ChosenSniperNarratives.uc
//  AUTHOR:  Joe Weinhoffer --  8/11/2016
//  PURPOSE: Defines the Chosen Sniper's set of dynamic narrative templates.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DynamicNarrative_ChosenSniperNarratives extends X2DynamicNarrative_DefaultDynamicNarratives;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	/////////////////////// MOMENTS ///////////////////////////////

	// Reveal
	Templates.AddItem(CreateChosenSniperRevealPartATemplate());
	Templates.AddItem(CreateChosenSniperRevealPartBTemplate());
	Templates.AddItem(CreateChosenSniperSharedRevealPartATemplate());
	Templates.AddItem(CreateChosenSniperSharedRevealPartBTemplate());

	// Engaged
	Templates.AddItem(CreateChosenSniperEngagedFirstEncounterTemplate());
	Templates.AddItem(CreateChosenSniperEngagedLastChosenTemplate());
	Templates.AddItem(CreateChosenSniperEngagedTwoChosenRemainTemplate());
	Templates.AddItem(CreateChosenSniperEngagedBlacksiteTemplate());
	Templates.AddItem(CreateChosenSniperEngagedForgeTemplate());
	Templates.AddItem(CreateChosenSniperEngagedPsiGateTemplate());
	Templates.AddItem(CreateChosenSniperEngagedBroadcastTemplate());
	Templates.AddItem(CreateChosenSniperEngagedChosenStrongholdTemplate());
	Templates.AddItem(CreateChosenSniperEngagedAlienFortressTemplate());
	Templates.AddItem(CreateChosenSniperEngagedAlienFortressShowdownTemplate());
	Templates.AddItem(CreateChosenSniperEngagedFirstAvengerAssaultTemplate());
	Templates.AddItem(CreateChosenSniperEngagedAvengerAssaultTemplate());
	Templates.AddItem(CreateChosenSniperEngagedLastTimeKilledTemplate());
	Templates.AddItem(CreateChosenSniperEngagedLastTimeCapturedSoldierTemplate());
	Templates.AddItem(CreateChosenSniperEngagedLastTimeGainedKnowledgeTemplate());
	Templates.AddItem(CreateChosenSniperEngagedLastTimeHeavyXComLossesTemplate());
	Templates.AddItem(CreateChosenSniperEngagedInterimChosenKilledTemplate());
	Templates.AddItem(CreateChosenSniperEngagedInterimChosenDefeatedTemplate());
	Templates.AddItem(CreateChosenSniperEngagedInterimChosenBeatXComTemplate());
	Templates.AddItem(CreateChosenSniperEngagedInterimChosenBeatXComHeavyLossesTemplate());
	Templates.AddItem(CreateChosenSniperEngagedInterimChosenAvengerAssaultTemplate());
	Templates.AddItem(CreateChosenSniperEngagedInterimBlacksiteTemplate());
	Templates.AddItem(CreateChosenSniperEngagedInterimForgeTemplate());
	Templates.AddItem(CreateChosenSniperEngagedInterimPsiGateTemplate());
	Templates.AddItem(CreateChosenSniperEngagedInterimSabotageTemplate());
	Templates.AddItem(CreateChosenSniperEngagedInterimAvatarProjectTemplate());
	Templates.AddItem(CreateChosenSniperEngagedHasCaptiveSoldierTemplate());
	Templates.AddItem(CreateChosenSniperEngagedOtherChosenHaveCaptivesTemplate());
	Templates.AddItem(CreateChosenSniperEngagedXComRescuedSoldiersTemplate());
	Templates.AddItem(CreateChosenSniperEngagedHuntAvengerTemplate());

	// Sniper Abilities
	Templates.AddItem(CreateChosenSniperTrackingShotMarkTemplate());
	Templates.AddItem(CreateChosenSniperTrackingShotTemplate());
	Templates.AddItem(CreateChosenSniperTranqShotTemplate());
	Templates.AddItem(CreateChosenSniperKillzoneTemplate());
	Templates.AddItem(CreateChosenSniperKillzoneShotTemplate());
	Templates.AddItem(CreateChosenSniperConcussionGrenadeTemplate());
	Templates.AddItem(CreateChosenSniperGrappleTemplate());
	Templates.AddItem(CreateChosenSniperRifleShotTemplate());
	Templates.AddItem(CreateChosenSniperOverwatchShotTemplate());
	Templates.AddItem(CreateChosenSniperPistolShotTemplate());
	Templates.AddItem(CreateChosenSniperPistolOverwatchShotTemplate());
	Templates.AddItem(CreateChosenSniperSummonFollowersTemplate());
	
	// Sniper Extracts Knowledge Appproach
	Templates.AddItem(CreateChosenSniperFirstExtractKnowledgeTemplate());
	Templates.AddItem(CreateChosenSniperExtractKnowledgeTemplate());
	Templates.AddItem(CreateChosenSniperExtractKnowledgePsiOperativeTemplate());
	Templates.AddItem(CreateChosenSniperExtractKnowledgeReaperTemplate());
	Templates.AddItem(CreateChosenSniperExtractKnowledgeSkirmisherTemplate());
	Templates.AddItem(CreateChosenSniperExtractKnowledgeTemplarTemplate());
	Templates.AddItem(CreateChosenSniperExtractKnowledgeJaneKellyTemplate());
	Templates.AddItem(CreateChosenSniperExtractKnowledgeHighRankSoldierTemplate());
	
	// Sniper Extracts Knowledge Complete
	Templates.AddItem(CreateChosenSniperExtractKnowledgeEscapeHealthyTemplate());
	Templates.AddItem(CreateChosenSniperExtractKnowledgeEscapeWoundedTemplate());
	Templates.AddItem(CreateChosenSniperExtractKnowledgeEscapeHeavyLossesTemplate());

	// Sniper Captures Soldier Approach
	Templates.AddItem(CreateChosenSniperFirstCaptureTemplate());
	Templates.AddItem(CreateChosenSniperCaptureTemplate());
	Templates.AddItem(CreateChosenSniperCapturePsiOperativeTemplate());
	Templates.AddItem(CreateChosenSniperCaptureReaperTemplate());
	Templates.AddItem(CreateChosenSniperCaptureSkirmisherTemplate());
	Templates.AddItem(CreateChosenSniperCaptureTemplarTemplate());
	Templates.AddItem(CreateChosenSniperCaptureJaneKellyTemplate());
	Templates.AddItem(CreateChosenSniperCaptureHighRankSoldierTemplate());

	// Sniper Captured Complete
	Templates.AddItem(CreateChosenSniperCaptureEscapeHealthyTemplate());
	Templates.AddItem(CreateChosenSniperCaptureEscapeWoundedTemplate());
	Templates.AddItem(CreateChosenSniperCaptureEscapeHeavyLossesTemplate());

	// Sniper Killed
	Templates.AddItem(CreateChosenSniperFirstTimeKilledTemplate());
	Templates.AddItem(CreateChosenSniperKilledTemplate());

	// Turn Start
	Templates.AddItem(CreateChosenSniperXCOMTurnBeginsStalkingTemplate());
	Templates.AddItem(CreateChosenSniperXCOMTurnBeginsTemplate());
	Templates.AddItem(CreateChosenSniperXCOMTurnBeginsAnticipateTemplate());
	Templates.AddItem(CreateChosenSniperAlienTurnBeginsTemplate());
	Templates.AddItem(CreateChosenSniperLostTurnBeginsTemplate());

	// Faction Taunts
	Templates.AddItem(CreateChosenSniperReaperTauntsTemplate());
	Templates.AddItem(CreateChosenSniperSkirmisherTauntsTemplate());
	Templates.AddItem(CreateChosenSniperTemplarTauntsTemplate());

	// XCOM Attacks Non-Chosen
	//Templates.AddItem(CreateChosenSniperXComAttacksMagWeaponsTemplate());
	//Templates.AddItem(CreateChosenSniperXComAttacksBeamWeaponsTemplate());
	Templates.AddItem(CreateChosenSniperXComAttacksChosenWeaponsTemplate());

	// XCOM Attacks Anyone
	Templates.AddItem(CreateChosenSniperSoldierAttacksGrenadesTemplate());
	Templates.AddItem(CreateChosenSniperRangerAttacksSwordTemplate());
	Templates.AddItem(CreateChosenSniperPsiOperativeAttacksTemplate());
	Templates.AddItem(CreateChosenSniperXComRecoversSoldierTemplate());

	// XCOM Kills
	Templates.AddItem(CreateChosenSniperXComKillsAdventPriestTemplate());
	Templates.AddItem(CreateChosenSniperXComKillsEnemyTemplate());
	Templates.AddItem(CreateChosenSniperXComKillsLastVisibleEnemyTemplate());

	// XCOM Attacked
	Templates.AddItem(CreateChosenSniperSoldierKilledByEnemyTemplate());
	Templates.AddItem(CreateChosenSniperSoldierKilledByChosenTemplate());
	Templates.AddItem(CreateChosenSniperSoldierWoundedByEnemyTemplate());
	Templates.AddItem(CreateChosenSniperSoldierWoundedByChosenTemplate());
	Templates.AddItem(CreateChosenSniperSoldierMissedByChosenTemplate());
	Templates.AddItem(CreateChosenSniperCivilianKilledTemplate());

	// Chosen Attacked
	Templates.AddItem(CreateChosenSniperAttackedByAlienHunterWeaponTemplate());
	Templates.AddItem(CreateChosenSniperAttackedByChosenWeaponTemplate());
	Templates.AddItem(CreateChosenSniperAttackedBySparkTemplate());
	Templates.AddItem(CreateChosenSniperAttackedBySquadsightTemplate());
	Templates.AddItem(CreateChosenSniperAttackedFirstMissTemplate());
	Templates.AddItem(CreateChosenSniperAttackedMissTemplate());
	Templates.AddItem(CreateChosenSniperAttackedMissBySkirmisherTemplate());
	Templates.AddItem(CreateChosenSniperAttackedMissByTemplarTemplate());
	Templates.AddItem(CreateChosenSniperAttackedFirstHitTemplate());
	Templates.AddItem(CreateChosenSniperAttackedHitTemplate());
	Templates.AddItem(CreateChosenSniperAttackedHitBySkirmisherTemplate());
	Templates.AddItem(CreateChosenSniperAttackedHitByTemplarTemplate());
	Templates.AddItem(CreateChosenSniperAttackedHitByReaperTemplate());

	/////////////////////// CONDITIONS /////////////////////////////
	Templates.AddItem(CreateIsChosenActiveCondition('NarrativeCondition_IsChosenSniperActive', 'ChosenSniper'));
	Templates.AddItem(CreateIsChosenEngagedCondition('NarrativeCondition_IsChosenSniperEngaged', 'ChosenSniper'));
	Templates.AddItem(CreateIsAlienActiveExcludeCharacterCondition('NarrativeCondition_IsAlienActiveExcludeChosenSniper', 'ChosenSniper'));
	Templates.AddItem(CreateIsEventSourceCharacterCondition('NarrativeCondition_IsEventSourceChosenSniper', 'ChosenSniper'));
	Templates.AddItem(CreateIsEventSourceNotCharacterCondition('NarrativeCondition_IsEventSourceNotChosenSniper', 'ChosenSniper'));
	Templates.AddItem(CreateIsAbilityTargetCharacterCondition('NarrativeCondition_IsAbilityTargetChosenSniper', 'ChosenSniper'));
	Templates.AddItem(CreateIsAbilityTargetNotCharacterCondition('NarrativeCondition_IsAbilityTargetNotChosenSniper', 'ChosenSniper'));
	Templates.AddItem(CreateIsAbilitySourceCharacterCondition('NarrativeCondition_IsAbilitySourceChosenSniper', 'ChosenSniper'));
	Templates.AddItem(CreateIsAbilitySourceNotCharacterCondition('NarrativeCondition_IsAbilitySourceNotChosenSniper', 'ChosenSniper'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityTrackingShotMark', 'TrackingShotMark'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityTrackingShot', 'TrackingShot'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityTranqShot', 'LethalDose'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityHunterKillzone', 'HunterKillzone'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityHunterKillzoneShot', 'KillzoneShot'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityHunterGrapple', 'HunterGrapple'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityHunterRifleShot', 'HunterRifleShot'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityHunterOverwatchShot', 'OverwatchShot'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityPistolShot', 'PistolStandardShot'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityPistolOverwatchShot', 'PistolOverwatchShot'));
	Templates.AddItem(CreateIsAbilityWeaponNameCondition('NarrativeCondition_IsAbilityWeaponConcussionGrenade', 'HunterConcussionGrenade'));
	Templates.AddItem(CreateIsMissionCondition('NarrativeCondition_IsMissionChosenSniperShowdown', 'ChosenShowdown_Hunter'));
	Templates.AddItem(CreateIsNotMissionCondition('NarrativeCondition_IsMissionNotChosenSniperShowdown', 'ChosenShowdown_Hunter'));
	
	return Templates;
}

// #######################################################################################
// --------------------------- REVEAL ----------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenSniperRevealPartATemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperRevealPartA');
	Template.EventTrigger = 'ScamperBegin';
	Template.NarrativeDeck = 'ChosenSniperRevealPartA';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'RevealAI';
	Template.SequencedEventTrigger = 'Visualizer_ChosenReveal_LipSyncA';
	Template.MatineeNames.AddItem("CIN_ChosenHunter_Reveal_2");
	Template.bIgnorePriority = true;

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Pod_Reveal_G', , , 'Hunter_Reveal_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Pod_Reveal_I', , , 'Hunter_Reveal_I');
	
	return Template;
}

static function X2DataTemplate CreateChosenSniperRevealPartBTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperRevealPartB');
	Template.EventTrigger = 'ScamperBegin';
	Template.NarrativeDeck = 'ChosenSniperRevealPartB';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'RevealAI';
	Template.SequencedEventTrigger = 'Visualizer_ChosenReveal_LipSyncB';
	Template.MatineeNames.AddItem("CIN_ChosenHunter_Reveal_2");
	Template.bIgnorePriority = true;
	
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Pod_Reveal_G2', , , 'Hunter_Reveal_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Pod_Reveal_I2', , , 'Hunter_Reveal_I');
	
	return Template;
}

static function X2DataTemplate CreateChosenSniperSharedRevealPartATemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperSharedRevealPartA');
	Template.EventTrigger = 'ScamperBegin';
	Template.NarrativeDeck = 'ChosenSniperSharedRevealPartA';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'RevealAI';
	Template.SequencedEventTrigger = 'Visualizer_ChosenReveal_LipSyncA';
	Template.MatineeNames.AddItem("CIN_ChosenHunter_Reveal_1");
	Template.bIgnorePriority = true;

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Pod_Reveal_A', , , 'Hunter_Reveal_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Pod_Reveal_E', , , 'Hunter_Reveal_E');

	return Template;
}

static function X2DataTemplate CreateChosenSniperSharedRevealPartBTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperSharedRevealPartB');
	Template.EventTrigger = 'ScamperBegin';
	Template.NarrativeDeck = 'ChosenSniperSharedRevealPartB';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'RevealAI';
	Template.SequencedEventTrigger = 'Visualizer_ChosenReveal_LipSyncB';
	Template.MatineeNames.AddItem("CIN_ChosenHunter_Reveal_1");
	Template.bIgnorePriority = true;

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Pod_Reveal_A2', , , 'Hunter_Reveal_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Pod_Reveal_E2', , , 'Hunter_Reveal_E');

	return Template;
}

// #######################################################################################
// --------------------------- ENGAGED ---------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenSniperEngagedFirstEncounterTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedFirstEncounter');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedFirstEncounter';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_First_Time_Met_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_First_Time_Met_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_First_Time_Met_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_First_Encounter_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_First_Encounter_B');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedLastChosenTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedLastChosen');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedLastChosen';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 5; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceLastChosen');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Last_Chosen_Alive_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Last_Chosen_Alive_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Last_Chosen_Alive_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Last_Chosen_Alive_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Last_Chosen_Alive_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Last_Chosen_Alive_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Last_Chosen_Alive_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Last_Chosen_Alive_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Last_Chosen_Alive_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Last_Chosen_Alive_J');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedTwoChosenRemainTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedTwoChosenRemain');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedTwoChosenRemain';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenAssassinEngageTwoChosenRemain');
	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenWarlockEngageTwoChosenRemain');

	Template.Priority = 5; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceLastTwoChosen');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Two_Chosen_Remain_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Two_Chosen_Remain_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Two_Chosen_Remain_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Two_Chosen_Remain_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Two_Chosen_Remain_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Two_Chosen_Remain_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Two_Chosen_Remain_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Two_Chosen_Remain_H');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedBlacksiteTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedBlacksite');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedBlacksite';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionBlacksite');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Golden_Path_Pod_Reveal_Blacksite');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedForgeTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedForge');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedForge';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionForge');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Golden_Path_Pod_Reveal_Forge');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedPsiGateTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedPsiGate');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedPsiGate';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionPsiGate');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Golden_Path_Pod_Reveal_PsiGate');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedBroadcastTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedBroadcast');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedBroadcast';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionBroadcast');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Golden_Path_Pod_Reveal_Tower');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedChosenStrongholdTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedChosenStronghold');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedChosenStronghold';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionChosenSniperShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Stronghold_Start');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedAlienFortressTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedAlienFortress');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedAlienFortress';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionAlienFortress');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Final_Mission_Start');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedAlienFortressShowdownTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedAlienFortressShowdown');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedAlienFortressShowdown';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionAlienFortress');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Final_Mission_Start');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedFirstAvengerAssaultTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedFirstAvengerAssault');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedFirstAvengerAssault';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionAvengerAssault');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_First_Avenger_Assault_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_First_Avenger_Assault_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_First_Avenger_Assault_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_First_Avenger_Assault_D');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedAvengerAssaultTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedAvengerAssault');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedAvengerAssault';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionAvengerAssault');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Subs_Avenger_Assault_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Subs_Avenger_Assault_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Subs_Avenger_Assault_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Subs_Avenger_Assault_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Subs_Avenger_Assault_E');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedLastTimeKilledTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedLastTimeKilled');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedLastTimeKilled';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 17; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenLastEncounterKilled');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');
	
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Was_Defeated_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Was_Defeated_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Was_Defeated_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Was_Defeated_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Was_Defeated_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Was_Defeated_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Was_Defeated_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Was_Defeated_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Was_Defeated_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Was_Defeated_J');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Was_Defeated_K');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Was_Defeated_L');
	
	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedLastTimeCapturedSoldierTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedLastTimeCapturedSoldier');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedLastTimeCapturedSoldier';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 19; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenLastEncounterCapturedSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Captured_Last_Time_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Captured_Last_Time_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Captured_Last_Time_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Captured_Last_Time_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Captured_Last_Time_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Captured_Last_Time_F');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedLastTimeGainedKnowledgeTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedLastTimeGainedKnowledge');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedLastTimeGainedKnowledge';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 19; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenLastEncounterGainedKnowledge');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Gained_Know_Last_Time_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Gained_Know_Last_Time_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Gained_Know_Last_Time_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Gained_Know_Last_Time_D');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Extract_Know_Last_Time_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Extract_Know_Last_Time_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Extract_Know_Last_Time_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Extract_Know_Last_Time_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Extract_Know_Last_Time_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Extract_Know_Last_Time_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Extract_Know_Last_Time_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Extract_Know_Last_Time_H');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedLastTimeHeavyXComLossesTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedLastTimeHeavyXComLosses');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedLastTimeHeavyXComLosses';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 18; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenLastEncounterHeavyXComLosses');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');
	
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Losses_Last_Time_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Losses_Last_Time_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Losses_Last_Time_C');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedInterimChosenKilledTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedInterimChosenKilled');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedInterimChosenKilled';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 16; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceOtherChosenLastEncounterKilled');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Interim_Chosen_Defeated_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Interim_Chosen_Defeated_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Interim_Chosen_Defeated_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Interim_Chosen_Defeated_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Interim_Chosen_Defeated_E');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedInterimChosenDefeatedTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedInterimChosenDefeated');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedInterimChosenDefeated';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 4; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceOtherChosenLastEncounterDefeated');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Interim_Chosen_Killed_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Interim_Chosen_Killed_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Interim_Chosen_Killed_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Interim_Chosen_Killed_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Interim_Chosen_Killed_E');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedInterimChosenBeatXComTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedInterimChosenBeatXCom');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedInterimChosenBeatXCom';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 16; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceOtherChosenLastEncounterBeatXCom');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Interim_Chosen_Defeat_XCOM_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Interim_Chosen_Defeat_XCOM_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Interim_Chosen_Defeat_XCOM_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Interim_Chosen_Defeat_XCOM_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Interim_Chosen_Defeat_XCOM_E');
	
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Other_Chosen_Extract_Capture_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Other_Chosen_Extract_Capture_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Other_Chosen_Extract_Capture_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Other_Chosen_Extract_Capture_D');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedInterimChosenBeatXComHeavyLossesTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedInterimChosenBeatXComHeavyLosses');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedInterimChosenBeatXComHeavyLosses';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 15; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceOtherChosenLastEncounterBeatXComHeavyLosses');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Other_Chosen_Beat_XCOM_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Other_Chosen_Beat_XCOM_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Other_Chosen_Beat_XCOM_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Other_Chosen_Beat_XCOM_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Other_Chosen_Beat_XCOM_E');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedInterimChosenAvengerAssaultTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedInterimChosenAvengerAssault');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedInterimChosenAvengerAssault';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 6; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_Strategy_IsLastChosenEncounterAvengerAssault');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Interim_Chosen_Avenger_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Interim_Chosen_Avenger_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Interim_Chosen_Avenger_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Interim_Chosen_Avenger_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Interim_Chosen_Avenger_E');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedInterimBlacksiteTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedInterimBlacksite');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedInterimBlacksite';
	Template.bOncePerGame = true;

	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenAssassinEngagedInterimBlacksite');
	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenWarlockEngagedInterimBlacksite');

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 12; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_Strategy_IsBlacksiteComplete');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Completed_Blacksite_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Completed_Blacksite_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Completed_Blacksite_C');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedInterimForgeTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedInterimForge');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedInterimForge';
	Template.bOncePerGame = true;

	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenAssassinEngagedInterimForge');
	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenWarlockEngagedInterimForge');

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 11; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_Strategy_IsForgeComplete');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Completed_Forge_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Completed_Forge_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Completed_Forge_C');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedInterimPsiGateTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedInterimPsiGate');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedInterimPsiGate';
	Template.bOncePerGame = true;

	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenAssassinEngagedInterimPsiGate');
	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenWarlockEngagedInterimPsiGate');

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 10; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_Strategy_IsPsiGateComplete');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Completed_Gate_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Completed_Gate_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Completed_Gate_C');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedInterimSabotageTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedInterimSabotage');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedInterimSabotage';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 8; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_Strategy_DidXComRecentlySabotageFacility');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Sabotaged_Facility_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Sabotaged_Facility_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Sabotaged_Facility_C');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedInterimAvatarProjectTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedInterimAvatarProject');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedInterimAvatarProject';
	Template.bOncePerGame = true;

	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenAssassinEngagedInterimAvatarProject');
	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenWarlockEngagedInterimAvatarProject');

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 9; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_Strategy_IsAvatarProjectAlmostComplete');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Avatar_Almost_Complete_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Avatar_Almost_Complete_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Avatar_Almost_Complete_C');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedHasCaptiveSoldierTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedHasCaptiveSoldier');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedHasCaptiveSoldier';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 14; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenHasCaptiveSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Still_Has_Captive_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Still_Has_Captive_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Still_Has_Captive_C');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedOtherChosenHaveCaptivesTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperCaptureOtherChosenHaveCaptives');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperCaptureOtherChosenHaveCaptives';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 14; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceOtherChosenHaveCaptiveSoldiers');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Other_Chosen_Have_Captives_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Other_Chosen_Have_Captives_B');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedXComRescuedSoldiersTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedXComRescuedSoldiers');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperCaptureXComRescuedSoldiers';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 13; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenXComRescuedSoldiers');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Rescued_Captive_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Rescued_Captive_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Rescued_Captive_C');

	return Template;
}

static function X2DataTemplate CreateChosenSniperEngagedHuntAvengerTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperEngagedHuntAvenger');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEngagedHuntAvenger';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 7; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenKnowledgeHuntingAvenger');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Close_To_Avenger_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Close_To_Avenger_B');

	return Template;
}

// #######################################################################################
// --------------------------- ABILITIES -------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenSniperTrackingShotMarkTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperTrackingShotMark');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperTrackingShotMark';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'AttackBegin';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTrackingShotMark');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Farsight_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Farsight_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Farsight_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Farsight_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Farsight_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Farsight_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Farsight_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Farsight_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Farsight_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Farsight_J');

	return Template;
}

static function X2DataTemplate CreateChosenSniperTrackingShotTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperTrackingShot');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperTrackingShot';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'AttackBegin';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTrackingShot');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Tracking_Shot_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Tracking_Shot_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Tracking_Shot_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Tracking_Shot_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Tracking_Shot_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Tracking_Shot_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Tracking_Shot_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Tracking_Shot_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Tracking_Shot_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Tracking_Shot_J');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Tracking_Shot_K');

	return Template;
}

static function X2DataTemplate CreateChosenSniperTranqShotTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperTranqShot');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperTranqShot';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'AttackBegin';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTranqShot');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Tranq_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Tranq_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Tranq_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Tranq_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Tranq_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Tranq_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Tranq_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Tranq_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Tranq_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Tranq_J');

	return Template;
}

static function X2DataTemplate CreateChosenSniperKillzoneTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperKillzone');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperKillzone';
	
	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHunterKillzone');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Killzone_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Killzone_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Killzone_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Killzone_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Killzone_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Killzone_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Killzone_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Killzone_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Killzone_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Killzone_J');

	return Template;
}

static function X2DataTemplate CreateChosenSniperKillzoneShotTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperKillzoneShot');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperRifleShot';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'AttackBegin';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHunterKillzoneShot');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	// No NMs because using the same deck as normal Rifle shot

	return Template;
}

static function X2DataTemplate CreateChosenSniperConcussionGrenadeTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperConcussionGrenade');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperConcussionGrenade';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'AttackBegin';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityThrowGrenade');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityWeaponConcussionGrenade');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Concussion_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Concussion_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Concussion_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Concussion_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Concussion_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Concussion_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Concussion_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Concussion_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Concussion_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Concussion_J');

	return Template;
}

static function X2DataTemplate CreateChosenSniperGrappleTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperGrapple');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperGrapple';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHunterGrapple');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Grapple_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Grapple_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Grapple_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Grapple_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Grapple_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Grapple_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Grapple_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Grapple_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Grapple_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Grapple_J');

	return Template;
}

static function X2DataTemplate CreateChosenSniperRifleShotTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperRifleShot');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperRifleShot';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'AttackBegin';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHunterRifleShot');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_RifleShot_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_RifleShot_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_RifleShot_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_RifleShot_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_RifleShot_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_RifleShot_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_RifleShot_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_RifleShot_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_RifleShot_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_RifleShot_J');

	return Template;
}

static function X2DataTemplate CreateChosenSniperOverwatchShotTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperOverwatchShot');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperRifleShot';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'AttackBegin';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHunterOverwatchShot');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	// No NMs because using the same deck as normal Rifle shot

	return Template;
}

static function X2DataTemplate CreateChosenSniperPistolShotTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperPistolShot');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperPistolShot';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'AttackBegin';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityPistolShot');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_PistolShot_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_PistolShot_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_PistolShot_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_PistolShot_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_PistolShot_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_PistolShot_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_PistolShot_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_PistolShot_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_PistolShot_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_PistolShot_J');
	
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Quickdraw_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Quickdraw_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Quickdraw_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Quickdraw_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Quickdraw_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Quickdraw_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Quickdraw_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Quickdraw_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Quickdraw_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Quickdraw_J');

	return Template;
}

static function X2DataTemplate CreateChosenSniperPistolOverwatchShotTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperPistolOverwatchShot');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperPistolShot';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'AttackBegin';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityPistolOverwatchShot');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	// No NMs because using the same deck as normal Pistol shot

	return Template;
}

static function X2DataTemplate CreateChosenSniperSummonFollowersTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperSummonFollowers');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperSummonFollowers';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenSummonBegin';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenSummonFollowers');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Calling_Reinforcements_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Calling_Reinforcements_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Calling_Reinforcements_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Calling_Reinforcements_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Calling_Reinforcements_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Calling_Reinforcements_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Calling_Reinforcements_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Calling_Reinforcements_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Calling_Reinforcements_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Calling_Reinforcements_J');

	return Template;
}

// #######################################################################################
// --------------------------- EXTRACT ---------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenSniperFirstExtractKnowledgeTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperFirstExtractKnowledge');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperFirstExtractKnowledge';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 4; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledgeMove');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Extract_Know_First_Time_Ever_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Extract_Know_First_Time_Ever_B');
	
	return Template;
}

static function X2DataTemplate CreateChosenSniperExtractKnowledgeTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperExtractKnowledge');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperExtractKnowledge';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 5; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledgeMove');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Generic_Extract_Know_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Generic_Extract_Know_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Generic_Extract_Know_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Generic_Extract_Know_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Generic_Extract_Know_E');

	return Template;
}

static function X2DataTemplate CreateChosenSniperExtractKnowledgePsiOperativeTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperExtractKnowledgePsiOperative');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperExtractKnowledgePsiOperative';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledgeMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetPsiOperative');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Extract_Know_Psi_Op_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Extract_Know_Psi_Op_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Extract_Know_Psi_Op_C');

	return Template;
}

static function X2DataTemplate CreateChosenSniperExtractKnowledgeReaperTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperExtractKnowledgeReaper');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperExtractKnowledgeReaper';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledgeMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetReaperSoldier');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Extract_Know_Reaper_A');

	return Template;
}

static function X2DataTemplate CreateChosenSniperExtractKnowledgeSkirmisherTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperExtractKnowledgeSkirmisher');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperExtractKnowledgeSkirmisher';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledgeMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetSkirmisherSoldier');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Extract_Know_Skirmisher_A');

	return Template;
}

static function X2DataTemplate CreateChosenSniperExtractKnowledgeTemplarTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperExtractKnowledgeTemplar');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperExtractKnowledgeTemplar';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledgeMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetTemplarSoldier');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Extract_Know_Templar_A');

	return Template;
}

static function X2DataTemplate CreateChosenSniperExtractKnowledgeJaneKellyTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperExtractKnowledgeJaneKelly');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperExtractKnowledgeJaneKelly';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledgeMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetJaneKelly');
	
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Extract_Know_Jane_Kelly_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Extract_Know_Jane_Kelly_B');

	return Template;
}

static function X2DataTemplate CreateChosenSniperExtractKnowledgeHighRankSoldierTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperExtractKnowledgeHighRankSoldier');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperExtractKnowledgeHighRankSoldier';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledgeMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetHighRankSoldier');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Extract_Know_High_Rank_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Extract_Know_High_Rank_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Extract_Know_High_Rank_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Extract_Know_High_Rank_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Extract_Know_High_Rank_E');

	return Template;
}

static function X2DataTemplate CreateChosenSniperExtractKnowledgeEscapeHealthyTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperExtractKnowledgeEscapeHealthy');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperExtractKnowledgeEscapeHealthy';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenTacticalEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledge');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceUnitHealthy');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Healthy_Escape_Extract_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Healthy_Escape_Extract_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Healthy_Escape_Extract_C');

	return Template;
}

static function X2DataTemplate CreateChosenSniperExtractKnowledgeEscapeWoundedTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperExtractKnowledgeEscapeWounded');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperExtractKnowledgeEscapeWounded';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenTacticalEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledge');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceUnitWounded');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Wounded_Escape_Extract_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Wounded_Escape_Extract_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Wounded_Escape_Extract_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Wounded_Escape_Extract_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Wounded_Escape_Extract_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Wounded_Escape_Extract_F');

	return Template;
}

static function X2DataTemplate CreateChosenSniperExtractKnowledgeEscapeHeavyLossesTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperExtractKnowledgeEscapeHeavyLosses');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperEscapeKnowledgeEscapeHeavyLosses';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenTacticalEscape';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledge');
	Template.Conditions.AddItem('NarrativeCondition_IsXComSufferingHeavyLosses');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Loss_Escape_Extract_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Loss_Escape_Extract_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Loss_Escape_Extract_C');

	return Template;
}

// #######################################################################################
// --------------------------- CAPTURE ---------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenSniperFirstCaptureTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperFirstCapture');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperFirstCapture';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 4; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnapMove');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_First_Soldier_Capture_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_First_Soldier_Capture_B');

	return Template;
}

static function X2DataTemplate CreateChosenSniperCaptureTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperCapture');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperCapture';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 5; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnapMove');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Generic_Soldier_Capture_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Generic_Soldier_Capture_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Generic_Soldier_Capture_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Generic_Soldier_Capture_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Generic_Soldier_Capture_E');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Captures_Multiple_Soldiers_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Captures_Multiple_Soldiers_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Captures_Multiple_Soldiers_C');

	return Template;
}

static function X2DataTemplate CreateChosenSniperCapturePsiOperativeTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperCapturePsiOperative');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperCapturePsiOperative';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnapMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetPsiOperative');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Captures_Psi_Op_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Captures_Psi_Op_B');

	return Template;
}

static function X2DataTemplate CreateChosenSniperCaptureReaperTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperCaptureReaper');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperCaptureReaper';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnapMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetReaperSoldier');
	
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Captures_Reaper_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Captures_Reaper_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Captures_Reaper_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Captures_Reaper_D');

	return Template;
}

static function X2DataTemplate CreateChosenSniperCaptureSkirmisherTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperCaptureSkirmisher');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperCaptureSkirmisher';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnapMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetSkirmisherSoldier');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Captures_Skirmisher_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Captures_Skirmisher_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Captures_Skirmisher_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Captures_Skirmisher_D');

	return Template;
}

static function X2DataTemplate CreateChosenSniperCaptureTemplarTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperCaptureTemplar');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperCaptureTemplar';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnapMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetTemplarSoldier');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Captures_Templar_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Captures_Templar_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Captures_Templar_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Captures_Templar_D');

	return Template;
}

static function X2DataTemplate CreateChosenSniperCaptureJaneKellyTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperCaptureJaneKelly');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperCaptureJaneKelly';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnapMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetJaneKelly');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Captures_Jane');

	return Template;
}

static function X2DataTemplate CreateChosenSniperCaptureHighRankSoldierTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperCaptureHighRankSoldier');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperCaptureHighRankSoldier';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnapMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetHighRankSoldier');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Captures_High_Rank_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Captures_High_Rank_B');

	return Template;
}

static function X2DataTemplate CreateChosenSniperCaptureEscapeHealthyTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperCaptureEscapeHealthy');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperCaptureEscapeHealthy';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenTacticalEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnap');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceUnitHealthy');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Healthy_Escape_Capture_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Healthy_Escape_Capture_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Healthy_Escape_Capture_C');

	return Template;
}

static function X2DataTemplate CreateChosenSniperCaptureEscapeWoundedTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperCaptureEscapeWounded');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperCaptureEscapeWounded';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenTacticalEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnap');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceUnitWounded');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Wounded_Escape_Capture_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Wounded_Escape_Capture_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Wounded_Escape_Capture_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Wounded_Escape_Capture_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Wounded_Escape_Capture_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Wounded_Escape_Capture_F');

	return Template;
}

static function X2DataTemplate CreateChosenSniperCaptureEscapeHeavyLossesTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperCaptureEscapeHeavyLosses');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperCaptureEscapeHeavyLosses';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnap');
	Template.Conditions.AddItem('NarrativeCondition_IsXComSufferingHeavyLosses');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Loss_Escape_Capture_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Loss_Escape_Capture_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Loss_Escape_Capture_C');

	return Template;
}

// #######################################################################################
// ----------------------------- SNIPER KILLED -------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenSniperFirstTimeKilledTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperFirstTimeKilled');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperFirstTimeKilled';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenTacticalEscape';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenDefeatedEscape');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Flees_First_Defeat_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Flees_First_Defeat_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Flees_First_Defeat_C');

	return Template;
}

static function X2DataTemplate CreateChosenSniperKilledTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperKilled');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperKilled';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenTacticalEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenDefeatedEscape');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Flees_Multiple_Defeats_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Flees_Multiple_Defeats_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Flees_Multiple_Defeats_C');

	return Template;
}

// #######################################################################################
// --------------------------- TURN START ------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenSniperXCOMTurnBeginsStalkingTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperXCOMTurnBeginsStalking');
	Template.EventTrigger = 'PlayerTurnBegun';
	Template.NarrativeDeck = 'ChosenSniperXCOMTurnBeginsStalking';

	Template.Priority = 4; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceXComPlayer');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');
	Template.Conditions.AddItem('NarrativeCondition_IsTurnStartRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Stalking_XCOM_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Stalking_XCOM_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Stalking_XCOM_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Stalking_XCOM_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Stalking_XCOM_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Stalking_XCOM_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Stalking_XCOM_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Stalking_XCOM_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Stalking_XCOM_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Stalking_XCOM_J');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Stalking_XCOM_K');

	return Template;
}

static function X2DataTemplate CreateChosenSniperXCOMTurnBeginsTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperXCOMTurnBegins');
	Template.EventTrigger = 'PlayerTurnBegun';
	Template.NarrativeDeck = 'ChosenSniperXCOMTurnBegins';

	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceXComPlayer');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');
	Template.Conditions.AddItem('NarrativeCondition_IsTurnStartRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Taunts_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Taunts_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Taunts_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Taunts_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Taunts_E');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Turn_Begins_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Turn_Begins_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Turn_Begins_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Turn_Begins_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Turn_Begins_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Turn_Begins_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Turn_Begins_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Turn_Begins_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Turn_Begins_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Turn_Begins_J');

	return Template;
}

static function X2DataTemplate CreateChosenSniperXCOMTurnBeginsAnticipateTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperXCOMTurnBeginsAnticipate');
	Template.EventTrigger = 'PlayerTurnBegun';
	Template.NarrativeDeck = 'ChosenSniperXCOMTurnBeginsAnticipate';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceXComPlayer');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsXComSoldierDazedCondition');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenSniperShowdown');
	Template.Conditions.AddItem('NarrativeCondition_IsTurnStartRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Disabled_Anticipate_Extract_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Disabled_Anticipate_Extract_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Disabled_Anticipate_Extract_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Disabled_Anticipate_Extract_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Disabled_Anticipate_Extract_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Disabled_Anticipate_Extract_F');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Disabled_Anticipate_Capture_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Disabled_Anticipate_Capture_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Disabled_Anticipate_Capture_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Disabled_Anticipate_Capture_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Disabled_Anticipate_Capture_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Disabled_Anticipate_Capture_F');

	return Template;
}

static function X2DataTemplate CreateChosenSniperAlienTurnBeginsTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperAlienTurnBegins');
	Template.EventTrigger = 'PlayerTurnBegun';
	Template.NarrativeDeck = 'ChosenSniperAlienTurnBegins';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceAlienPlayer');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsAlienActiveExcludeChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsTurnStartRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_AI_Turn_Begins_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_AI_Turn_Begins_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_AI_Turn_Begins_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_AI_Turn_Begins_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_AI_Turn_Begins_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_AI_Turn_Begins_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_AI_Turn_Begins_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_AI_Turn_Begins_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_AI_Turn_Begins_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_AI_Turn_Begins_J');

	return Template;
}

static function X2DataTemplate CreateChosenSniperLostTurnBeginsTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperLostTurnBegins');
	Template.EventTrigger = 'PlayerTurnBegun';
	Template.NarrativeDeck = 'ChosenSniperLostTurnBegins';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceLostPlayer');
	Template.Conditions.AddItem('NarrativeCondition_AreLostActive');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsTurnStartRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Lost_Turn_Begins_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Lost_Turn_Begins_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Lost_Turn_Begins_C');

	return Template;
}

// #######################################################################################
// ------------------------------- FACTION TAUNTS ----------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenSniperReaperTauntsTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperReaperTaunts');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperReaperTaunts';
	Template.bOncePerMission = true;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceReaperSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceUnitNotConcealed');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityStandardMove');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Reaper_Taunts_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Reaper_Taunts_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Reaper_Taunts_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Reaper_Taunts_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Reaper_Taunts_E');

	return Template;
}

static function X2DataTemplate CreateChosenSniperSkirmisherTauntsTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperSkirmisherTaunts');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperSkirmisherTaunts';
	Template.bOncePerMission = true;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSkirmisherSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceUnitNotConcealed');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityStandardMove');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');
	
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Skirmisher_Taunts_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Skirmisher_Taunts_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Skirmisher_Taunts_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Skirmisher_Taunts_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Skirmisher_Taunts_E');

	return Template;
}

static function X2DataTemplate CreateChosenSniperTemplarTauntsTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperTemplarTaunts');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperTemplarTaunts';
	Template.bOncePerMission = true;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceTemplarSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceUnitNotConcealed');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityStandardMove');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Templar_Taunts_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Templar_Taunts_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Templar_Taunts_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Templar_Taunts_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Templar_Taunts_E');

	return Template;
}

// #######################################################################################
// --------------------------- XCOM ATTACKS ----------------------------------------------
// #######################################################################################

//static function X2DataTemplate CreateChosenSniperXComAttacksMagWeaponsTemplate()
//{
//	local X2DynamicNarrativeMomentTemplate Template;
//
//	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperXComAttacksMagWeapons');
//	Template.EventTrigger = 'AbilityActivated';
//	Template.NarrativeDeck = 'ChosenSniperXComAttacksMagWeapons';
//	Template.bOncePerMission = true;
//
//	Template.bSequencedNarrative = true;
//	Template.SequencedEventTag = 'AttackResult';
//
//	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions
//
//	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
//	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
//	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
//	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetNotChosenSniper');
//	Template.Conditions.AddItem('NarrativeCondition_IsAbilityWeaponMagnetic');
//
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Mag_Weapons_A');
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Mag_Weapons_B');
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Mag_Weapons_C');
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Mag_Weapons_D');
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Mag_Weapons_E');
//
//	return Template;
//}
//
//static function X2DataTemplate CreateChosenSniperXComAttacksBeamWeaponsTemplate()
//{
//	local X2DynamicNarrativeMomentTemplate Template;
//
//	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperXComAttacksBeamWeapons');
//	Template.EventTrigger = 'AbilityActivated';
//	Template.NarrativeDeck = 'ChosenSniperXComAttacksBeamWeapons';
//	Template.bOncePerMission = true;
//
//	Template.bSequencedNarrative = true;
//	Template.SequencedEventTag = 'AttackResult';
//
//	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions
//
//	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
//	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
//	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
//	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetNotChosenSniper');
//	Template.Conditions.AddItem('NarrativeCondition_IsAbilityWeaponBeam');
//
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Beam_Weapons_A');
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Beam_Weapons_B');
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Beam_Weapons_C');
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Beam_Weapons_D');
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Beam_Weapons_E');
//
//	return Template;
//}

static function X2DataTemplate CreateChosenSniperXComAttacksChosenWeaponsTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperXComAttacksChosenWeapons');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperXComAttacksChosenWeapons';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetNotChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityWeaponChosen');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Uses_Chosen_Weapon_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Uses_Chosen_Weapon_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Uses_Chosen_Weapon_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Uses_Chosen_Weapon_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Uses_Chosen_Weapon_E');

	return Template;
}

static function X2DataTemplate CreateChosenSniperSoldierAttacksGrenadesTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperSoldierAttacksGrenades');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperSoldierAttacksGrenades';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityStandardGrenade');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Attacks_With_Grenades_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Attacks_With_Grenades_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Attacks_With_Grenades_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Attacks_With_Grenades_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Attacks_With_Grenades_E');

	return Template;
}

static function X2DataTemplate CreateChosenSniperRangerAttacksSwordTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperRangerAttacksSword');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperRangerAttacksSword';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceRanger');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetNotChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilitySwordSlice');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Ranger_Sword_Attack_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Ranger_Sword_Attack_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Ranger_Sword_Attack_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Ranger_Sword_Attack_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Ranger_Sword_Attack_E');

	return Template;
}

static function X2DataTemplate CreateChosenSniperPsiOperativeAttacksTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperPsiOperativeAttacks');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperPsiOperativeAttacks';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourcePsiOperative');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityNotSolaceCleanse');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetNotChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Psi_Operative_Attack_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Psi_Operative_Attack_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Psi_Operative_Attack_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Psi_Operative_Attack_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Psi_Operative_Attack_E');

	return Template;
}

static function X2DataTemplate CreateChosenSniperXComRecoversSoldierTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperXComRecoversSoldier');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperXComRecoversSoldier';
	Template.bOncePerMission = true;

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityRevive');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Attempts_Rescue_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Attempts_Rescue_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Attempts_Rescue_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Attempts_Rescue_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Attempts_Rescue_E');

	return Template;
}

// #######################################################################################
// --------------------------- XCOM KILLS ------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenSniperXComKillsAdventPriestTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperXComKillsAdventPriest');
	Template.EventTrigger = 'UnitDied';
	Template.NarrativeDeck = 'ChosenSniperXComKillsAdventPriest';
	Template.bOncePerTurn = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceAdventPriest');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Kills_Priest_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Kills_Priest_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Kills_Priest_C');

	return Template;
}

static function X2DataTemplate CreateChosenSniperXComKillsEnemyTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperXComKillsEnemy');
	Template.EventTrigger = 'UnitDied';
	Template.NarrativeDeck = 'ChosenSniperXComKillsEnemy';
	Template.bOncePerTurn = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceAlienTeam');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceNotChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Kills_Hostiles_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Kills_Hostiles_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Kills_Hostiles_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Kills_Hostiles_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Kills_Hostiles_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Kills_Hostiles_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Kills_Hostiles_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Kills_Hostiles_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Kills_Hostiles_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Kills_Hostiles_J');

	return Template;
}

static function X2DataTemplate CreateChosenSniperXComKillsLastVisibleEnemyTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperXComKillsLastVisibleEnemy');
	Template.EventTrigger = 'UnitDied';
	Template.NarrativeDeck = 'ChosenSniperXComKillsLastVisibleEnemy';
	Template.bOncePerTurn = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceNotChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetLastVisibleEnemy');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Last_Visible_Hostile_Killed_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Last_Visible_Hostile_Killed_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Last_Visible_Hostile_Killed_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Last_Visible_Hostile_Killed_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Last_Visible_Hostile_Killed_E');

	return Template;
}

// #######################################################################################
// --------------------------- XCOM ATTACKED ---------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenSniperSoldierKilledByEnemyTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperSoldierKilledByEnemy');
	Template.EventTrigger = 'KillMail';
	Template.NarrativeDeck = 'ChosenSniperSoldierKilledByEnemy';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventDataSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Killed_By_Hostiles_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Killed_By_Hostiles_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Killed_By_Hostiles_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Killed_By_Hostiles_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Killed_By_Hostiles_E');

	return Template;
}

static function X2DataTemplate CreateChosenSniperSoldierKilledByChosenTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperSoldierKilledByChosen');
	Template.EventTrigger = 'KillMail';
	Template.NarrativeDeck = 'ChosenSniperSoldierKilledByChosen';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventDataSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Killed_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Killed_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Killed_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Killed_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Killed_E');

	return Template;
}

static function X2DataTemplate CreateChosenSniperSoldierWoundedByEnemyTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperSoldierWoundedByEnemy');
	Template.EventTrigger = 'UnitTakeEffectDamage';
	Template.NarrativeDeck = 'ChosenSniperSoldierWoundedByEnemy';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventDataSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsEventDataUnitAlive'); // Don't play the wounded narrative if the soldier was killed from the attack
	Template.Conditions.AddItem('NarrativeCondition_IsAbilitySourceEnemyTeam');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilitySourceNotChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Wounded_By_Hostiles_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Wounded_By_Hostiles_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Wounded_By_Hostiles_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Wounded_By_Hostiles_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Wounded_By_Hostiles_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Wounded_By_Hostiles_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Wounded_By_Hostiles_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Wounded_By_Hostiles_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Wounded_By_Hostiles_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Wounded_By_Hostiles_J');

	return Template;
}

static function X2DataTemplate CreateChosenSniperSoldierWoundedByChosenTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperSoldierWoundedByChosen');
	Template.EventTrigger = 'UnitTakeEffectDamage';
	Template.NarrativeDeck = 'ChosenSniperSoldierWoundedByChosen';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventDataSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsEventDataUnitAlive'); // Don't play the wounded narrative if the soldier was killed from the attack
	Template.Conditions.AddItem('NarrativeCondition_IsAbilitySourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Wounded_Not_Killed_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Wounded_Not_Killed_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Wounded_Not_Killed_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Wounded_Not_Killed_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Wounded_Not_Killed_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Wounded_Not_Killed_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Wounded_Not_Killed_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Wounded_Not_Killed_H');

	return Template;
}

static function X2DataTemplate CreateChosenSniperSoldierMissedByChosenTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperSoldierMissedByChosen');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperSoldierMissedByChosen';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityMiss');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Missed_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Missed_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Missed_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Missed_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Missed_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Missed_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Missed_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Soldier_Missed_H');

	return Template;
}

static function X2DataTemplate CreateChosenSniperCivilianKilledTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperCivilianKilled');
	Template.EventTrigger = 'KillMail';
	Template.NarrativeDeck = 'ChosenSniperCivilianKilled';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventDataCivilian');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Retaliation_Taunt_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Retaliation_Taunt_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Retaliation_Taunt_C');

	return Template;
}

// #######################################################################################
// --------------------------- CHOSEN ATTACKED -------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenSniperAttackedByAlienHunterWeaponTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperAttackedByAlienHunterWeapon');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperAttackedByAlienHunterWeapon';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityWeaponAlienHunter');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Attacks_With_Hunter_Weap_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Attacks_With_Hunter_Weap_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Attacks_With_Hunter_Weap_C');

	return Template;
}

static function X2DataTemplate CreateChosenSniperAttackedByChosenWeaponTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperAttackedByChosenWeapon');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperAttackedByChosenWeapon';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityWeaponChosen');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Attacks_With_Chosen_Weap_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Attacks_With_Chosen_Weap_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Attacks_With_Chosen_Weap_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Attacks_With_Chosen_Weap_D');

	return Template;
}

static function X2DataTemplate CreateChosenSniperAttackedBySparkTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperAttackedBySpark');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperAttackedBySpark';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSparkSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Spark_Attacks_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Spark_Attacks_B');

	return Template;
}

static function X2DataTemplate CreateChosenSniperAttackedBySquadsightTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperAttackedBySquadsight');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperAttackedBySquadsight';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetFromSquadsight');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Attacks_With_Squadsight_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Attacks_With_Squadsight_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Attacks_With_Squadsight_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Attacks_With_Squadsight_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Attacks_With_Squadsight_E');

	return Template;
}

static function X2DataTemplate CreateChosenSniperAttackedFirstMissTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperAttackedFirstMiss');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperAttackedFirstMiss';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 4; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityMiss');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Misses_Chosen_First_Time_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Misses_Chosen_First_Time_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Misses_Chosen_First_Time_C');

	return Template;
}

static function X2DataTemplate CreateChosenSniperAttackedMissTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperAttackedMiss');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperAttackedMiss';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 5; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityMiss');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Subsequent_Misses_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Subsequent_Misses_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Subsequent_Misses_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Subsequent_Misses_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Subsequent_Misses_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Subsequent_Misses_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Subsequent_Misses_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Subsequent_Misses_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Subsequent_Misses_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Subsequent_Misses_J');

	return Template;
}

static function X2DataTemplate CreateChosenSniperAttackedMissBySkirmisherTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperAttackedMissBySkirmisher');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperAttackedMissBySkirmisher';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSkirmisherSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityMiss');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Faction_Miss_Skirmisher_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Faction_Miss_Skirmisher_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Faction_Miss_Skirmisher_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Faction_Miss_Skirmisher_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Faction_Miss_Skirmisher_E');

	return Template;
}

static function X2DataTemplate CreateChosenSniperAttackedMissByTemplarTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperAttackedMissByTemplar');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperAttackedMissByTemplar';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceTemplarSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityMiss');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Faction_Miss_Templar_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Faction_Miss_Templar_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Faction_Miss_Templar_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Faction_Miss_Templar_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Faction_Miss_Templar_E');

	return Template;
}

static function X2DataTemplate CreateChosenSniperAttackedFirstHitTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperAttackedFirstHit');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperAttackedFirstHit';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 4; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHit');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Hits_Chosen_First_Time_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Hits_Chosen_First_Time_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Hits_Chosen_First_Time_C');

	return Template;
}

static function X2DataTemplate CreateChosenSniperAttackedHitTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperAttackedHit');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperAttackedHit';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 5; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHit');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Subsequent_Hits_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Subsequent_Hits_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Subsequent_Hits_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Subsequent_Hits_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Subsequent_Hits_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Subsequent_Hits_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Subsequent_Hits_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Subsequent_Hits_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Subsequent_Hits_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_XCOM_Subsequent_Hits_J');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Wounded_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Wounded_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Chosen_Wounded_C');

	return Template;
}

static function X2DataTemplate CreateChosenSniperAttackedHitBySkirmisherTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperAttackedHitBySkirmisher');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperAttackedHitBySkirmisher';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSkirmisherSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHit');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Faction_Hit_Skirmisher_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Faction_Hit_Skirmisher_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Faction_Hit_Skirmisher_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Faction_Hit_Skirmisher_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Faction_Hit_Skirmisher_E');

	return Template;
}

static function X2DataTemplate CreateChosenSniperAttackedHitByTemplarTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperAttackedHitByTemplar');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperAttackedHitByTemplar';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceTemplarSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHit');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Faction_Hit_Templar_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Faction_Hit_Templar_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Faction_Hit_Templar_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Faction_Hit_Templar_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Faction_Hit_Templar_E');

	return Template;
}

static function X2DataTemplate CreateChosenSniperAttackedHitByReaperTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenSniperAttackedHitByReaper');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenSniperAttackedHitByReaper';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenSniperActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceReaperSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHit');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenSniper');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Faction_Hit_Reaper_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Faction_Hit_Reaper_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Faction_Hit_Reaper_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Faction_Hit_Reaper_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_HNTR_T_Faction_Hit_Reaper_E');

	return Template;
}