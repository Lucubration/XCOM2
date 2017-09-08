//---------------------------------------------------------------------------------------
//  FILE:    X2DynamicNarrative_ChosenAssassinNarratives.uc
//  AUTHOR:  Joe Weinhoffer --  8/11/2016
//  PURPOSE: Defines the Chosen Assassin's set of dynamic narrative templates.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DynamicNarrative_ChosenAssassinNarratives extends X2DynamicNarrative_DefaultDynamicNarratives;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	/////////////////////// MOMENTS ///////////////////////////////

	// Reveal
	Templates.AddItem(CreateChosenAssassinRevealPartATemplate());
	Templates.AddItem(CreateChosenAssassinRevealPartBTemplate());
	Templates.AddItem(CreateChosenAssassinSharedRevealPartATemplate());
	Templates.AddItem(CreateChosenAssassinSharedRevealPartBTemplate());

	// Engaged
	Templates.AddItem(CreateChosenAssassinEngagedFirstEncounterTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedLastChosenTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedTwoChosenRemainTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedBlacksiteTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedForgeTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedPsiGateTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedBroadcastTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedChosenStrongholdTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedAlienFortressTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedAlienFortressShowdownTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedFirstAvengerAssaultTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedAvengerAssaultTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedLastTimeKilledTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedLastTimeCapturedSoldierTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedLastTimeGainedKnowledgeTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedLastTimeHeavyXComLossesTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedInterimChosenKilledTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedInterimChosenDefeatedTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedInterimChosenBeatXComTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedInterimChosenBeatXComHeavyLossesTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedInterimChosenAvengerAssaultTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedInterimForgeTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedInterimPsiGateTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedInterimSabotageTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedInterimAvatarProjectTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedHasCaptiveSoldierTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedOtherChosenHaveCaptivesTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedXComRescuedSoldiersTemplate());
	Templates.AddItem(CreateChosenAssassinEngagedHuntAvengerTemplate());

	// Assassin Abilities
	Templates.AddItem(CreateChosenAssassinVanishingWindTemplate());
	Templates.AddItem(CreateChosenAssassinPartingSilkTemplate());
	Templates.AddItem(CreateChosenAssassinHarborWaveTemplate());
	Templates.AddItem(CreateChosenAssassinMountainMistTemplate());
	Templates.AddItem(CreateChosenAssassinBendingReedTemplate());
	Templates.AddItem(CreateChosenAssassinBladestormTemplate());
	Templates.AddItem(CreateChosenAssassinRapidFireTemplate());
	Templates.AddItem(CreateChosenAssassinSummonFollowersTemplate());

	// Assassin Extracts Knowledge Approach
	Templates.AddItem(CreateChosenAssassinFirstExtractKnowledgeTemplate());
	Templates.AddItem(CreateChosenAssassinExtractKnowledgeTemplate());
	Templates.AddItem(CreateChosenAssassinExtractKnowledgePsiOperativeTemplate());
	Templates.AddItem(CreateChosenAssassinExtractKnowledgeReaperTemplate());
	Templates.AddItem(CreateChosenAssassinExtractKnowledgeSkirmisherTemplate());
	Templates.AddItem(CreateChosenAssassinExtractKnowledgeTemplarTemplate());
	Templates.AddItem(CreateChosenAssassinExtractKnowledgeJaneKellyTemplate());
	Templates.AddItem(CreateChosenAssassinExtractKnowledgeElenaDragunovaTemplate());
	Templates.AddItem(CreateChosenAssassinExtractKnowledgeHighRankSoldierTemplate());
	
	// Assassin Extracts Knowledge Complete
	Templates.AddItem(CreateChosenAssassinExtractKnowledgeEscapeHealthyTemplate());
	Templates.AddItem(CreateChosenAssassinExtractKnowledgeEscapeWoundedTemplate());
	Templates.AddItem(CreateChosenAssassinExtractKnowledgeEscapeHeavyLossesTemplate());

	// Assassin Captures Soldier Approach
	Templates.AddItem(CreateChosenAssassinFirstCaptureTemplate());
	Templates.AddItem(CreateChosenAssassinCaptureTemplate());
	Templates.AddItem(CreateChosenAssassinCapturePsiOperativeTemplate());
	Templates.AddItem(CreateChosenAssassinCaptureReaperTemplate());
	Templates.AddItem(CreateChosenAssassinCaptureSkirmisherTemplate());
	Templates.AddItem(CreateChosenAssassinCaptureTemplarTemplate());
	Templates.AddItem(CreateChosenAssassinCaptureJaneKellyTemplate());
	Templates.AddItem(CreateChosenAssassinCaptureHighRankSoldierTemplate());

	// Assassin Captured Complete
	Templates.AddItem(CreateChosenAssassinCaptureEscapeHealthyTemplate());
	Templates.AddItem(CreateChosenAssassinCaptureEscapeWoundedTemplate());
	Templates.AddItem(CreateChosenAssassinCaptureEscapeHeavyLossesTemplate());

	// Assassin Killed
	Templates.AddItem(CreateChosenAssassinFirstTimeKilledTemplate());
	Templates.AddItem(CreateChosenAssassinKilledTemplate());

	// Turn Start
	Templates.AddItem(CreateChosenAssassinXCOMTurnBeginsStalkingTemplate());
	Templates.AddItem(CreateChosenAssassinXCOMTurnBeginsTemplate());
	Templates.AddItem(CreateChosenAssassinXCOMTurnBeginsAnticipateTemplate());
	Templates.AddItem(CreateChosenAssassinAlienTurnBeginsTemplate());
	Templates.AddItem(CreateChosenAssassinLostTurnBeginsTemplate());

	// Faction Taunts
	Templates.AddItem(CreateChosenAssassinReaperTauntsTemplate());
	Templates.AddItem(CreateChosenAssassinSkirmisherTauntsTemplate());
	Templates.AddItem(CreateChosenAssassinTemplarTauntsTemplate());
	
	// XCOM Attacks Non-Chosen
	//Templates.AddItem(CreateChosenAssassinXComAttacksMagWeaponsTemplate());
	//Templates.AddItem(CreateChosenAssassinXComAttacksBeamWeaponsTemplate());
	Templates.AddItem(CreateChosenAssassinXComAttacksChosenWeaponsTemplate());

	// XCOM Attacks Anyone
	Templates.AddItem(CreateChosenAssassinSoldierAttacksGrenadesTemplate());
	Templates.AddItem(CreateChosenAssassinRangerAttacksSwordTemplate());
	Templates.AddItem(CreateChosenAssassinPsiOperativeAttacksTemplate());
	Templates.AddItem(CreateChosenAssassinXComRecoversSoldierTemplate());

	// XCOM Kills
	Templates.AddItem(CreateChosenAssassinXComKillsAdventPriestTemplate());
	Templates.AddItem(CreateChosenAssassinXComKillsEnemyTemplate());
	Templates.AddItem(CreateChosenAssassinXComKillsLastVisibleEnemyTemplate());

	// XCOM Attacked
	Templates.AddItem(CreateChosenAssassinSoldierKilledByEnemyTemplate());
	Templates.AddItem(CreateChosenAssassinSoldierKilledByChosenTemplate());
	Templates.AddItem(CreateChosenAssassinSoldierWoundedByEnemyTemplate());
	Templates.AddItem(CreateChosenAssassinSoldierWoundedByChosenTemplate());
	Templates.AddItem(CreateChosenAssassinSoldierMissedByChosenTemplate());
	Templates.AddItem(CreateChosenAssassinCivilianKilledTemplate());
		
	// Chosen Attacked
	Templates.AddItem(CreateChosenAssassinAttackedByAlienHunterWeaponTemplate());
	Templates.AddItem(CreateChosenAssassinAttackedByChosenWeaponTemplate());
	Templates.AddItem(CreateChosenAssassinAttackedBySparkTemplate());
	Templates.AddItem(CreateChosenAssassinAttackedBySquadsightTemplate());
	Templates.AddItem(CreateChosenAssassinAttackedFirstMissTemplate());
	Templates.AddItem(CreateChosenAssassinAttackedMissTemplate());
	Templates.AddItem(CreateChosenAssassinAttackedMissBySkirmisherTemplate());
	Templates.AddItem(CreateChosenAssassinAttackedMissByTemplarTemplate());
	Templates.AddItem(CreateChosenAssassinAttackedFirstHitTemplate());
	Templates.AddItem(CreateChosenAssassinAttackedHitTemplate());
	Templates.AddItem(CreateChosenAssassinAttackedHitBySkirmisherTemplate());
	Templates.AddItem(CreateChosenAssassinAttackedHitByTemplarTemplate());
	Templates.AddItem(CreateChosenAssassinAttackedHitByReaperTemplate());


	/////////////////////// CONDITIONS /////////////////////////////
	Templates.AddItem(CreateIsChosenActiveCondition('NarrativeCondition_IsChosenAssassinActive', 'ChosenAssassin'));
	Templates.AddItem(CreateIsChosenEngagedCondition('NarrativeCondition_IsChosenAssassinEngaged', 'ChosenAssassin'));
	Templates.AddItem(CreateIsAlienActiveExcludeCharacterCondition('NarrativeCondition_IsAlienActiveExcludeChosenAssassin', 'ChosenAssassin'));
	Templates.AddItem(CreateIsEventSourceCharacterCondition('NarrativeCondition_IsEventSourceChosenAssassin', 'ChosenAssassin'));
	Templates.AddItem(CreateIsEventSourceNotCharacterCondition('NarrativeCondition_IsEventSourceNotChosenAssassin', 'ChosenAssassin'));
	Templates.AddItem(CreateIsAbilityTargetCharacterCondition('NarrativeCondition_IsAbilityTargetChosenAssassin', 'ChosenAssassin'));
	Templates.AddItem(CreateIsAbilityTargetNotCharacterCondition('NarrativeCondition_IsAbilityTargetNotChosenAssassin', 'ChosenAssassin'));
	Templates.AddItem(CreateIsAbilitySourceCharacterCondition('NarrativeCondition_IsAbilitySourceChosenAssassin', 'ChosenAssassin'));
	Templates.AddItem(CreateIsAbilitySourceNotCharacterCondition('NarrativeCondition_IsAbilitySourceNotChosenAssassin', 'ChosenAssassin'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityVanishingWind', 'VanishingWind'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityPartingSilk', 'PartingSilk'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityHarborWave', 'HarborWave'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityBendingReed', 'BendingReed'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityBladestorm', 'BladestormAttack'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityRapidFire', 'RapidFire'));
	Templates.AddItem(CreateIsAbilityWeaponNameCondition('NarrativeCondition_IsAbilityWeaponMountainMistGrenade', 'MountainMistGrenade'));
	Templates.AddItem(CreateIsMissionCondition('NarrativeCondition_IsMissionChosenAssassinShowdown', 'ChosenShowdown_Assassin'));
	Templates.AddItem(CreateIsNotMissionCondition('NarrativeCondition_IsMissionNotChosenAssassinShowdown', 'ChosenShowdown_Assassin'));

	return Templates;
}

// #######################################################################################
// --------------------------- REVEAL ----------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenAssassinRevealPartATemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinRevealPartA');
	Template.EventTrigger = 'ScamperBegin';
	Template.NarrativeDeck = 'ChosenAssassinRevealPartA';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'RevealAI';
	Template.SequencedEventTrigger = 'Visualizer_ChosenReveal_LipSyncA';
	Template.MatineeNames.AddItem("CIN_ChosenAssassinM1_Reveal_2");
	Template.MatineeNames.AddItem("CIN_ChosenAssassinM2_Reveal_2");
	Template.MatineeNames.AddItem("CIN_ChosenAssassinM3_Reveal_2");
	Template.MatineeNames.AddItem("CIN_ChosenAssassinM4_Reveal_2");
	Template.bIgnorePriority = true;

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Pod_Reveal_C', , , 'Assassin_Reveal_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Pod_Reveal_G', , , 'Assassin_Reveal_G');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinRevealPartBTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinRevealPartB');
	Template.EventTrigger = 'ScamperBegin';
	Template.NarrativeDeck = 'ChosenAssassinRevealPartB';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'RevealAI';
	Template.SequencedEventTrigger = 'Visualizer_ChosenReveal_LipSyncB';
	Template.MatineeNames.AddItem("CIN_ChosenAssassinM1_Reveal_2");
	Template.MatineeNames.AddItem("CIN_ChosenAssassinM2_Reveal_2");
	Template.MatineeNames.AddItem("CIN_ChosenAssassinM3_Reveal_2");
	Template.MatineeNames.AddItem("CIN_ChosenAssassinM4_Reveal_2");
	Template.bIgnorePriority = true;

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Pod_Reveal_C2', , , 'Assassin_Reveal_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Pod_Reveal_G2', , , 'Assassin_Reveal_G');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinSharedRevealPartATemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinSharedRevealPartA');
	Template.EventTrigger = 'ScamperBegin';
	Template.NarrativeDeck = 'ChosenAssassinSharedRevealPartA';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'RevealAI';
	Template.SequencedEventTrigger = 'Visualizer_ChosenReveal_LipSyncA';
	Template.MatineeNames.AddItem("CIN_ChosenAssassinM1_Reveal_1");
	Template.MatineeNames.AddItem("CIN_ChosenAssassinM2_Reveal_1");
	Template.MatineeNames.AddItem("CIN_ChosenAssassinM3_Reveal_1");
	Template.MatineeNames.AddItem("CIN_ChosenAssassinM4_Reveal_1");
	Template.bIgnorePriority = true;

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Pod_Reveal_I', , , 'Assassin_Reveal_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Pod_Reveal_J', , , 'Assassin_Reveal_J');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinSharedRevealPartBTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinSharedRevealPartB');
	Template.EventTrigger = 'ScamperBegin';
	Template.NarrativeDeck = 'ChosenAssassinSharedRevealPartB';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'RevealAI';
	Template.SequencedEventTrigger = 'Visualizer_ChosenReveal_LipSyncB';
	Template.MatineeNames.AddItem("CIN_ChosenAssassinM1_Reveal_1");
	Template.MatineeNames.AddItem("CIN_ChosenAssassinM2_Reveal_1");
	Template.MatineeNames.AddItem("CIN_ChosenAssassinM3_Reveal_1");
	Template.MatineeNames.AddItem("CIN_ChosenAssassinM4_Reveal_1");
	Template.bIgnorePriority = true;

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Pod_Reveal_I2', , , 'Assassin_Reveal_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Pod_Reveal_J2', , , 'Assassin_Reveal_J');

	return Template;
}

// #######################################################################################
// --------------------------- ENGAGED ---------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenAssassinEngagedFirstEncounterTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedFirstEncounter');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedFirstEncounter';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotLostAndAbandoned');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_First_Time_Ever_Met');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_First_Encounter_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_First_Encounter_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_First_Encounter_C');
	
	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedLastChosenTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedLastChosen');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedLastChosen';
	Template.bOncePerGame = true;
	
	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 5; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceLastChosen');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Last_Chosen_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Last_Chosen_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Last_Chosen_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Last_Chosen_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Last_Chosen_E');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedTwoChosenRemainTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedTwoChosenRemain');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedTwoChosenRemain';
	Template.bOncePerGame = true;
	
	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenSniperEngageTwoChosenRemain');
	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenWarlockEngageTwoChosenRemain');

	Template.Priority = 5; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceLastTwoChosen');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Two_Chosen_Remain_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Two_Chosen_Remain_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Two_Chosen_Remain_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Two_Chosen_Remain_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Two_Chosen_Remain_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Two_Chosen_Remain_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Two_Chosen_Remain_G');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedBlacksiteTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedBlacksite');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedBlacksite';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionBlacksite');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Golden_Path_Pod_Reveal_Blacksite');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Completed_Blacksite');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Completed_Blacksite_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Completed_Blacksite_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Completed_Blacksite_E');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedForgeTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedForge');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedForge';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionForge');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Golden_Path_Pod_Reveal_Forge');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedPsiGateTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedPsiGate');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedPsiGate';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionPsiGate');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Golden_Path_Pod_Reveal_PsiGate');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedBroadcastTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedBroadcast');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedBroadcast';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionBroadcast');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Golden_Path_Pod_Reveal_Tower');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedChosenStrongholdTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedChosenStronghold');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedChosenStronghold';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionChosenAssassinShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Stronghold_Start_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Stronghold_Start_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Stronghold_Start_C');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedAlienFortressTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedAlienFortress');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedAlienFortress';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionAlienFortress');
	
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Final_Mission_Start_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Final_Mission_Start_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Final_Mission_Start_C');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedAlienFortressShowdownTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedAlienFortressShowdown');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedAlienFortressShowdown';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionAlienFortressShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Final_Mission_Start_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Final_Mission_Start_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Final_Mission_Start_C');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedFirstAvengerAssaultTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedFirstAvengerAssault');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedFirstAvengerAssault';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionAvengerAssault');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Avenger_Assault_First_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Avenger_Assault_First_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Avenger_Assault_First_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Avenger_Assault_First_D');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedAvengerAssaultTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedAvengerAssault');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedAvengerAssault';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionAvengerAssault');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Avenger_Assault_Subs_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Avenger_Assault_Subs_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Avenger_Assault_Subs_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Avenger_Assault_Subs_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Avenger_Assault_Subs_E');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedLastTimeKilledTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedLastTimeKilled');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedLastTimeKilled';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 17; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenLastEncounterKilled');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Field_Death_Last_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Field_Death_Last_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Field_Death_Last_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Field_Death_Last_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Field_Death_Last_E');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Was_Defeated_Last_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Was_Defeated_Last_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Was_Defeated_Last_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Was_Defeated_Last_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Was_Defeated_Last_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Was_Defeated_Last_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Was_Defeated_Last_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Was_Defeated_Last_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Was_Defeated_Last_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Was_Defeated_Last_J');
	
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Was_Scarred_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Was_Scarred_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Was_Scarred_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Was_Scarred_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Was_Scarred_E');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_First_Teleport_A');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedLastTimeCapturedSoldierTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedLastTimeCapturedSoldier');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedLastTimeCapturedSoldier';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 19; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenLastEncounterCapturedSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Captured_Soldier_Last_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Captured_Soldier_Last_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Captured_Soldier_Last_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Captured_Soldier_Last_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Captured_Soldier_Last_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Captured_Soldier_Last_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Captured_Soldier_Last_G');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedLastTimeGainedKnowledgeTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedLastTimeGainedKnowledge');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedLastTimeGainedKnowledge';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 19; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenLastEncounterGainedKnowledge');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_General_Favor_Last_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_General_Favor_Last_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_General_Favor_Last_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_General_Favor_Last_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_General_Favor_Last_E');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Extracted_Know_Last_Time_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Extracted_Know_Last_Time_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Extracted_Know_Last_Time_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Extracted_Know_Last_Time_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Extracted_Know_Last_Time_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Extracted_Know_Last_Time_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Extracted_Know_Last_Time_G');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedLastTimeHeavyXComLossesTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedLastTimeHeavyXComLosses');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedLastTimeHeavyXComLosses';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 18; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenLastEncounterHeavyXComLosses');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');
	
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Losses_Last_Time_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Losses_Last_Time_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Losses_Last_Time_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Losses_Last_Time_D');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedInterimChosenKilledTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedInterimChosenKilled');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedInterimChosenKilled';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 16; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceOtherChosenLastEncounterKilled');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Defeated_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Defeated_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Defeated_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Defeated_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Defeated_E');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedInterimChosenDefeatedTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedInterimChosenDefeated');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedInterimChosenDefeated';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 4; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceOtherChosenLastEncounterDefeated');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');
	
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Killed_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Killed_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Killed_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Killed_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Killed_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Killed_F');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedInterimChosenBeatXComTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedInterimChosenBeatXCom');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedInterimChosenBeatXCom';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 16; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceOtherChosenLastEncounterBeatXCom');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Capture_Extract_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Capture_Extract_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Capture_Extract_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Capture_Extract_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Capture_Extract_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Capture_Extract_F');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedInterimChosenBeatXComHeavyLossesTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedInterimChosenBeatXComHeavyLosses');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedInterimChosenBeatXComHeavyLosses';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 15; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceOtherChosenLastEncounterBeatXComHeavyLosses');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Defeat_XCOM_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Defeat_XCOM_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Defeat_XCOM_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Defeat_XCOM_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Defeat_XCOM_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Defeat_XCOM_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Defeat_XCOM_G');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedInterimChosenAvengerAssaultTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedInterimChosenAvengerAssault');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedInterimChosenAvengerAssault';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 6; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_Strategy_IsLastChosenEncounterAvengerAssault');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Avenger_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Avenger_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Avenger_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Avenger_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Avenger_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Avenger_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Interim_Chosen_Avenger_G');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedInterimForgeTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedInterimForge');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedInterimForge';
	Template.bOncePerGame = true;

	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenSniperEngagedInterimForge');
	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenWarlockEngagedInterimForge');

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 11; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_Strategy_IsForgeComplete');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Completed_Forge');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Completed_Forge_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Completed_Forge_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Completed_Forge_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Completed_Forge_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Completed_Forge_F');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedInterimPsiGateTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedInterimPsiGate');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedInterimPsiGate';
	Template.bOncePerGame = true;

	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenSniperEngagedInterimPsiGate');
	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenWarlockEngagedInterimPsiGate');

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 10; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_Strategy_IsPsiGateComplete');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Completed_PsiGate');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Completed_PsiGate_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Completed_PsiGate_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Completed_PsiGate_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Completed_PsiGate_E');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedInterimSabotageTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedInterimSabotage');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedInterimSabotage';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 8; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_Strategy_DidXComRecentlySabotageFacility');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Sabotaged_Facility_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Sabotaged_Facility_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Sabotaged_Facility_C');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedInterimAvatarProjectTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedInterimAvatarProject');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedInterimAvatarProject';
	Template.bOncePerGame = true;

	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenSniperEngagedInterimAvatarProject');
	Template.OncePerGameExclusiveMoments.AddItem('NarrativeMoment_ChosenWarlockEngagedInterimAvatarProject');

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 9; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_Strategy_IsAvatarProjectAlmostComplete');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Avatar_Almost_Complete');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Avatar_Almost_Complete_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Avatar_Almost_Complete_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Avatar_Almost_Complete_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Avatar_Almost_Complete_E');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedHasCaptiveSoldierTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedHasCaptiveSoldier');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedHasCaptiveSoldier';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 14; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenHasCaptiveSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Still_Has_Captive_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Still_Has_Captive_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Still_Has_Captive_C');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedOtherChosenHaveCaptivesTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinCaptureOtherChosenHaveCaptives');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinCaptureOtherChosenHaveCaptives';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 14; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceOtherChosenHaveCaptiveSoldiers');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Other_Chosen_Have_Captives_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Other_Chosen_Have_Captives_B');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedXComRescuedSoldiersTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedXComRescuedSoldiers');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinCaptureXComRescuedSoldiers';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 13; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenXComRescuedSoldiers');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Rescued_Captive_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Rescued_Captive_B');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinEngagedHuntAvengerTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinEngagedHuntAvenger');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEngagedHuntAvenger';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenEngaged';

	Template.Priority = 7; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenKnowledgeHuntingAvenger');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Close_To_Avenger_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Close_To_Avenger_B');

	return Template;
}

// #######################################################################################
// --------------------------- ABILITIES -------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenAssassinVanishingWindTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinVanishingWind');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinVanishingWind';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'AttackBegin';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityVanishingWind');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotLostAndAbandoned');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Vanishing_Wind_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Vanishing_Wind_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Vanishing_Wind_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Vanishing_Wind_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Vanishing_Wind_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Vanishing_Wind_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Vanishing_Wind_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Vanishing_Wind_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Vanishing_Wind_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Vanishing_Wind_J');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinPartingSilkTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinPartingSilk');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinPartingSilk';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'AttackBegin';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityPartingSilk');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Parting_Silk_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Parting_Silk_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Parting_Silk_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Parting_Silk_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Parting_Silk_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Parting_Silk_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Parting_Silk_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Parting_Silk_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Parting_Silk_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Parting_Silk_J');
	
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bladestorm_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bladestorm_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bladestorm_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bladestorm_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bladestorm_J');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinHarborWaveTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinHarborWave');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinHarborWave';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'AttackBegin';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHarborWave');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Harbor_Wave_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Harbor_Wave_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Harbor_Wave_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Harbor_Wave_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Harbor_Wave_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Harbor_Wave_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Harbor_Wave_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Harbor_Wave_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Harbor_Wave_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Harbor_Wave_J');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Harbor_Wave_K');
	
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bladestorm_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bladestorm_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bladestorm_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bladestorm_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bladestorm_I');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinMountainMistTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinMountainMist');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinMountainMist';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'AttackBegin';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions
	
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityThrowGrenade');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityWeaponMountainMistGrenade');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');
	
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Mountain_Mist_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Mountain_Mist_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Mountain_Mist_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Mountain_Mist_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Mountain_Mist_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Mountain_Mist_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Mountain_Mist_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Mountain_Mist_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Mountain_Mist_I');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinBendingReedTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinBendingReed');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinBendingReed';
	
	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityBendingReed');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bending_Reed_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bending_Reed_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bending_Reed_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bending_Reed_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bending_Reed_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bending_Reed_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bending_Reed_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bending_Reed_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bending_Reed_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bending_Reed_J');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinBladestormTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinBladestorm');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinBladestorm';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'AttackBegin';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityBladestorm');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bladestorm_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bladestorm_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bladestorm_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bladestorm_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bladestorm_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bladestorm_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bladestorm_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bladestorm_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bladestorm_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Bladestorm_J');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinRapidFireTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinRapidFire');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinRapidFire';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'AttackBegin';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityRapidFire');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Rapid_Fire_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Rapid_Fire_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Rapid_Fire_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Rapid_Fire_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Rapid_Fire_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Rapid_Fire_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Rapid_Fire_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Rapid_Fire_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Rapid_Fire_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Rapid_Fire_J');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Rapid_Fire_K');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinSummonFollowersTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinSummonFollowers');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinSummonFollowers';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenSummonBegin';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenSummonFollowers');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAbilityRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Calling_Reinforcements_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Calling_Reinforcements_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Calling_Reinforcements_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Calling_Reinforcements_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Calling_Reinforcements_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Calling_Reinforcements_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Calling_Reinforcements_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Calling_Reinforcements_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Calling_Reinforcements_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Calling_Reinforcements_J');

	return Template;
}

// #######################################################################################
// --------------------------- EXTRACT ---------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenAssassinFirstExtractKnowledgeTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinFirstExtractKnowledge');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinFirstExtractKnowledge';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';	

	Template.Priority = 4; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledgeMove');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_First_Extraction_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_First_Extraction_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_First_Extraction_C');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinExtractKnowledgeTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinExtractKnowledge');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinExtractKnowledge';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 5; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledgeMove');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Subsequent_Extraction_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Subsequent_Extraction_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Subsequent_Extraction_C');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Generic_Extract_Know_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Generic_Extract_Know_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Generic_Extraction_C');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinExtractKnowledgePsiOperativeTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinExtractKnowledgePsiOperative');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinExtractKnowledgePsiOperative';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledgeMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetPsiOperative');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Extract_Know_Psi_Op_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Extract_Know_Psi_Op_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Extract_Know_Psi_Op_C');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinExtractKnowledgeReaperTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinExtractKnowledgeReaper');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinExtractKnowledgeReaper';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';
	
	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledgeMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetReaperSoldier');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Extract_Know_Reaper_A');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinExtractKnowledgeSkirmisherTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinExtractKnowledgeSkirmisher');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinExtractKnowledgeSkirmisher';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';
	
	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledgeMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetSkirmisherSoldier');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Extract_Know_Skirmisher_A');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinExtractKnowledgeTemplarTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinExtractKnowledgeTemplar');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinExtractKnowledgeTemplar';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';
	
	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledgeMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetTemplarSoldier');
	
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Extract_Know_Templar_A');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinExtractKnowledgeJaneKellyTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinExtractKnowledgeJaneKelly');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinExtractKnowledgeJaneKelly';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';
	
	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledgeMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetJaneKelly');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Extract_Know_Jane_Kelly_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Extract_Know_Jane_Kelly_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Extract_Know_Jane_Kelly_C');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinExtractKnowledgeElenaDragunovaTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinExtractKnowledgeElenaDragunova');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinExtractKnowledgeElenaDragunova';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';
	
	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledgeMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetElenaDragunova');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Extract_Know_Elena_Convo_B');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinExtractKnowledgeHighRankSoldierTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinExtractKnowledgeHighRankSoldier');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinExtractKnowledgeHighRankSoldier';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledgeMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetHighRankSoldier');
	
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Extract_Know_High_Rank_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Extract_Know_High_Rank_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Extract_Know_High_Rank_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Extract_Know_High_Rank_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Extract_Know_High_Rank_E');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinExtractKnowledgeEscapeHealthyTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinExtractKnowledgeEscapeHealthy');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinExtractKnowledgeEscapeHealthy';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenTacticalEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledge');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceUnitHealthy');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Healthy_Escape_Extract_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Healthy_Escape_Extract_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Healthy_Escape_Extract_C');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinExtractKnowledgeEscapeWoundedTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinExtractKnowledgeEscapeWounded');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinExtractKnowledgeWounded';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenTacticalEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledge');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceUnitWounded');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Wounded_Escape_Extract_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Wounded_Escape_Extract_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Wounded_Escape_Extract_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Wounded_Escape_Extract_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Wounded_Escape_Extract_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Wounded_Escape_Extract_F');
	return Template;
}

static function X2DataTemplate CreateChosenAssassinExtractKnowledgeEscapeHeavyLossesTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinExtractKnowledgeEscapeHeavyLosses');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinEscapeKnowledgeEscapeHeavyLosses';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenTacticalEscape';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenExtractKnowledge');
	Template.Conditions.AddItem('NarrativeCondition_IsXComSufferingHeavyLosses');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Loss_Escape_Extract_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Loss_Escape_Extract_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Loss_Escape_Extract_C');

	return Template;
}

// #######################################################################################
// --------------------------- CAPTURE ---------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenAssassinFirstCaptureTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinFirstCapture');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinFirstCapture';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';
	
	Template.Priority = 4; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnapMove');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_First_Soldier_Capture_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_First_Soldier_Capture_B');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinCaptureTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinCapture');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinCapture';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';

	Template.Priority = 5; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnapMove');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Generic_Soldier_Capture_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Generic_Soldier_Capture_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Generic_Soldier_Capture_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Generic_Soldier_Capture_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Generic_Soldier_Capture_E');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Captures_Multiple_Soldiers_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Captures_Multiple_Soldiers_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Captures_Multiple_Soldiers_C');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinCapturePsiOperativeTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinCapturePsiOperative');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinCapturePsiOperative';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';
	
	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnapMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetPsiOperative');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Captures_Psi_Op_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Captures_Psi_Op_B');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinCaptureReaperTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinCaptureReaper');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinCaptureReaper';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';
	
	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnapMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetReaperSoldier');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Captures_Reaper_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Captures_Reaper_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Captures_Reaper_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Captures_Reaper_D');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinCaptureSkirmisherTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinCaptureSkirmisher');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinCaptureSkirmisher';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';
	
	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnapMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetSkirmisherSoldier');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Captures_Skirmisher_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Captures_Skirmisher_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Captures_Skirmisher_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Captures_Skirmisher_D');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinCaptureTemplarTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinCaptureTemplar');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinCaptureTemplar';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';
	
	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnapMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetTemplarSoldier');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Captures_Templar_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Captures_Templar_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Captures_Templar_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Captures_Templar_D');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinCaptureJaneKellyTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinCaptureJaneKelly');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinCaptureJaneKelly';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';
	
	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnapMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetJaneKelly');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Captures_Jane');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinCaptureHighRankSoldierTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinCaptureHighRankSoldier');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinCaptureHighRankSoldier';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenMoveToEscape';
	
	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnapMove');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetHighRankSoldier');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Captures_High_Rank_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Captures_High_Rank_B');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinCaptureEscapeHealthyTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinCaptureEscapeHealthy');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinCaptureEscapeHealthy';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenTacticalEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnap');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceUnitHealthy');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Healthy_Escape_Capture_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Healthy_Escape_Capture_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Healthy_Escape_Capture_C');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinCaptureEscapeWoundedTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinCaptureEscapeWounded');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinCaptureEscapeWounded';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenTacticalEscape';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnap');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceUnitWounded');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Wounded_Escape_Capture_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Wounded_Escape_Capture_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Wounded_Escape_Capture_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Wounded_Escape_Capture_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Wounded_Escape_Capture_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Wounded_Escape_Capture_F');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinCaptureEscapeHeavyLossesTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinCaptureEscapeHeavyLosses');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinCaptureEscapeHeavyLosses';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenTacticalEscape';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenKidnap');
	Template.Conditions.AddItem('NarrativeCondition_IsXComSufferingHeavyLosses');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Loss_Escape_Capture_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Loss_Escape_Capture_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Loss_Escape_Capture_C');

	return Template;
}

// #######################################################################################
// --------------------------- ASSASSIN KILLED -------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenAssassinFirstTimeKilledTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinFirstTimeKilled');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinFirstTimeKilled';
	Template.bOncePerGame = true;

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenTacticalEscape';
	
	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenDefeatedEscape');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Flees_First_Defeat_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Flees_First_Defeat_B');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinKilledTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinKilled');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinKilled';

	Template.bSequencedNarrative = true;
	Template.SequencedEventTag = 'ChosenTacticalEscape';
	
	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityChosenDefeatedEscape');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Flees_Multiple_Defeats_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Flees_Multiple_Defeats_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Flees_Multiple_Defeats_C');

	return Template;
}

// #######################################################################################
// --------------------------- TURN START ------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenAssassinXCOMTurnBeginsStalkingTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinXCOMTurnBeginsStalking');
	Template.EventTrigger = 'PlayerTurnBegun';
	Template.NarrativeDeck = 'ChosenAssassinXCOMTurnBeginsStalking';

	Template.Priority = 4; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceXComPlayer');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');
	Template.Conditions.AddItem('NarrativeCondition_IsTurnStartRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Stalking_XCOM_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Stalking_XCOM_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Stalking_XCOM_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Stalking_XCOM_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Stalking_XCOM_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Stalking_XCOM_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Stalking_XCOM_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Stalking_XCOM_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Stalking_XCOM_I');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_First_Teleport_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_First_Teleport_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_First_Teleport_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_First_Teleport_E');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinXCOMTurnBeginsTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinXCOMTurnBegins');
	Template.EventTrigger = 'PlayerTurnBegun';
	Template.NarrativeDeck = 'ChosenAssassinXCOMTurnBegins';

	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceXComPlayer');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');
	Template.Conditions.AddItem('NarrativeCondition_IsTurnStartRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Taunts_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Taunts_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Taunts_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Taunts_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Taunts_E');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Turn_Begins_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Turn_Begins_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Turn_Begins_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Turn_Begins_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Turn_Begins_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Turn_Begins_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Turn_Begins_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Turn_Begins_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Turn_Begins_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Turn_Begins_J');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Turn_Begins_K');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinXCOMTurnBeginsAnticipateTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinXCOMTurnBeginsAnticipate');
	Template.EventTrigger = 'PlayerTurnBegun';
	Template.NarrativeDeck = 'ChosenAssassinXCOMTurnBeginsAnticipate';

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceXComPlayer');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsXComSoldierDazedCondition');
	Template.Conditions.AddItem('NarrativeCondition_IsMissionNotChosenAssassinShowdown');
	Template.Conditions.AddItem('NarrativeCondition_IsTurnStartRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Disabled_Anticipate_Extract_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Disabled_Anticipate_Extract_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Disabled_Anticipate_Extract_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Disabled_Anticipate_Extract_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Disabled_Anticipate_Extract_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Disabled_Anticipate_Extract_F');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Disabled_Anticipate_Capture_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Disabled_Anticipate_Capture_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Disabled_Anticipate_Capture_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Disabled_Anticipate_Capture_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Disabled_Anticipate_Capture_E');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinAlienTurnBeginsTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinAlienTurnBegins');
	Template.EventTrigger = 'PlayerTurnBegun';
	Template.NarrativeDeck = 'ChosenAssassinAlienTurnBegins';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceAlienPlayer');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsAlienActiveExcludeChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsTurnStartRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_AI_Turn_Begins_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_AI_Turn_Begins_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_AI_Turn_Begins_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_AI_Turn_Begins_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_AI_Turn_Begins_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_AI_Turn_Begins_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_AI_Turn_Begins_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_AI_Turn_Begins_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_AI_Turn_Begins_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_AI_Turn_Begins_J');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinLostTurnBeginsTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinLostTurnBegins');
	Template.EventTrigger = 'PlayerTurnBegun';
	Template.NarrativeDeck = 'ChosenAssassinLostTurnBegins';

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceLostPlayer');
	Template.Conditions.AddItem('NarrativeCondition_AreLostActive');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsTurnStartRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Lost_Turn_Begins_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Lost_Turn_Begins_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Lost_Turn_Begins_C');

	return Template;
}

// #######################################################################################
// ------------------------------- FACTION TAUNTS ----------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenAssassinReaperTauntsTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinReaperTaunts');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinReaperTaunts';
	Template.bOncePerMission = true;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceReaperSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceUnitNotConcealed');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityStandardMove');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Reaper_Taunts_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Reaper_Taunts_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Reaper_Taunts_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Reaper_Taunts_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Reaper_Taunts_E');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Reaper_Taunt_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Reaper_Taunt_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Reaper_Taunt_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Reaper_Taunt_F');
	
	return Template;
}

static function X2DataTemplate CreateChosenAssassinSkirmisherTauntsTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinSkirmisherTaunts');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinSkirmisherTaunts';
	Template.bOncePerMission = true;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSkirmisherSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceUnitNotConcealed');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityStandardMove');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Skirmisher_Taunts_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Skirmisher_Taunts_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Skirmisher_Taunts_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Skirmisher_Taunts_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Skirmisher_Taunts_E');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinTemplarTauntsTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinTemplarTaunts');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinTemplarTaunts';
	Template.bOncePerMission = true;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceTemplarSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceUnitNotConcealed');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityStandardMove');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Templar_Taunts_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Templar_Taunts_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Templar_Taunts_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Templar_Taunts_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Templar_Taunts_E');

	return Template;
}

// #######################################################################################
// --------------------------- XCOM ATTACKS ----------------------------------------------
// #######################################################################################

//static function X2DataTemplate CreateChosenAssassinXComAttacksMagWeaponsTemplate()
//{
//	local X2DynamicNarrativeMomentTemplate Template;
//
//	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinXComAttacksMagWeapons');
//	Template.EventTrigger = 'AbilityActivated';
//	Template.NarrativeDeck = 'ChosenAssassinXComAttacksMagWeapons';
//	Template.bOncePerMission = true;
//
//	Template.bSequencedNarrative = true;
//	Template.SequencedEventTag = 'AttackResult';
//
//	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions
//
//	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
//	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
//	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
//	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetNotChosenAssassin');
//	Template.Conditions.AddItem('NarrativeCondition_IsAbilityWeaponMagnetic');
//
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Mag_Weapons_A');
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Mag_Weapons_B');
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Mag_Weapons_C');
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Mag_Weapons_D');
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Mag_Weapons_E');
//
//	return Template;
//}
//
//static function X2DataTemplate CreateChosenAssassinXComAttacksBeamWeaponsTemplate()
//{
//	local X2DynamicNarrativeMomentTemplate Template;
//
//	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinXComAttacksBeamWeapons');
//	Template.EventTrigger = 'AbilityActivated';
//	Template.NarrativeDeck = 'ChosenAssassinXComAttacksBeamWeapons';
//	Template.bOncePerMission = true;
//
//	Template.bSequencedNarrative = true;
//	Template.SequencedEventTag = 'AttackResult';
//
//	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions
//
//	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
//	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
//	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
//	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetNotChosenAssassin');
//	Template.Conditions.AddItem('NarrativeCondition_IsAbilityWeaponBeam');
//
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Beam_Weapons_A');
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Beam_Weapons_B');
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Beam_Weapons_C');
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Beam_Weapons_D');
//	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Beam_Weapons_E');
//
//	return Template;
//}

static function X2DataTemplate CreateChosenAssassinXComAttacksChosenWeaponsTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinXComAttacksChosenWeapons');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinXComAttacksChosenWeapons';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetNotChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityWeaponChosen');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Uses_Chosen_Weapon_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Uses_Chosen_Weapon_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Uses_Chosen_Weapon_C');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinSoldierAttacksGrenadesTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinSoldierAttacksGrenades');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinSoldierAttacksGrenades';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinEngaged');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityStandardGrenade');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Attacks_With_Grenades_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Attacks_With_Grenades_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Attacks_With_Grenades_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Attacks_With_Grenades_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Attacks_With_Grenades_E');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinRangerAttacksSwordTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinRangerAttacksSword');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinRangerAttacksSword';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceRanger');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetNotChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilitySwordSlice');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Ranger_Sword_Attack_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Ranger_Sword_Attack_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Ranger_Sword_Attack_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Ranger_Sword_Attack_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Ranger_Sword_Attack_E');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinPsiOperativeAttacksTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinPsiOperativeAttacks');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinPsiOperativeAttacks';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourcePsiOperative');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityNotSolaceCleanse');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetNotChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Psi_Operative_Attack_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Psi_Operative_Attack_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Psi_Operative_Attack_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Psi_Operative_Attack_D');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinXComRecoversSoldierTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinXComRecoversSoldier');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinXComRecoversSoldier';
	Template.bOncePerMission = true;

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityRevive');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Attempts_Rescue_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Attempts_Rescue_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Attempts_Rescue_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Attempts_Rescue_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Attempts_Rescue_E');

	return Template;
}

// #######################################################################################
// --------------------------- XCOM KILLS ------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenAssassinXComKillsAdventPriestTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinXComKillsAdventPriest');
	Template.EventTrigger = 'UnitDied';
	Template.NarrativeDeck = 'ChosenAssassinXComKillsAdventPriest';
	Template.bOncePerTurn = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceAdventPriest');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Kills_Priest_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Kills_Priest_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Kills_Priest_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Kills_Priest_D');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinXComKillsEnemyTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinXComKillsEnemy');
	Template.EventTrigger = 'UnitDied';
	Template.NarrativeDeck = 'ChosenAssassinXComKillsEnemy';
	Template.bOncePerTurn = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceAlienTeam');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceNotChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Kills_Hostiles_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Kills_Hostiles_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Kills_Hostiles_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Kills_Hostiles_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Kills_Hostiles_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Kills_Hostiles_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Kills_Hostiles_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Kills_Hostiles_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Kills_Hostiles_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Kills_Hostiles_J');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinXComKillsLastVisibleEnemyTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinXComKillsLastVisibleEnemy');
	Template.EventTrigger = 'UnitDied';
	Template.NarrativeDeck = 'ChosenAssassinXComKillsLastVisibleEnemy';
	Template.bOncePerTurn = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceNotChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetLastVisibleEnemy');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttacksRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Last_Visible_Hostile_Killed_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Last_Visible_Hostile_Killed_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Last_Visible_Hostile_Killed_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Last_Visible_Hostile_Killed_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Last_Visible_Hostile_Killed_E');

	return Template;
}

// #######################################################################################
// --------------------------- XCOM ATTACKED ---------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenAssassinSoldierKilledByEnemyTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinSoldierKilledByEnemy');
	Template.EventTrigger = 'KillMail';
	Template.NarrativeDeck = 'ChosenAssassinSoldierKilledByEnemy';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventDataSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceNotChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Killed_By_Hostiles_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Killed_By_Hostiles_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Killed_By_Hostiles_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Killed_By_Hostiles_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Killed_By_Hostiles_E');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinSoldierKilledByChosenTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinSoldierKilledByChosen');
	Template.EventTrigger = 'KillMail';
	Template.NarrativeDeck = 'ChosenAssassinSoldierKilledByChosen';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventDataSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Killed_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Killed_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Killed_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Killed_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Killed_E');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinSoldierWoundedByEnemyTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinSoldierWoundedByEnemy');
	Template.EventTrigger = 'UnitTakeEffectDamage';
	Template.NarrativeDeck = 'ChosenAssassinSoldierWoundedByEnemy';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventDataSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsEventDataUnitAlive'); // Don't play the wounded narrative if the soldier was killed from the attack
	Template.Conditions.AddItem('NarrativeCondition_IsAbilitySourceEnemyTeam');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilitySourceNotChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Wounded_By_Hostiles_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Wounded_By_Hostiles_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Wounded_By_Hostiles_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Wounded_By_Hostiles_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Wounded_By_Hostiles_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Wounded_By_Hostiles_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Wounded_By_Hostiles_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Wounded_By_Hostiles_H');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinSoldierWoundedByChosenTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinSoldierWoundedByChosen');
	Template.EventTrigger = 'UnitTakeEffectDamage';
	Template.NarrativeDeck = 'ChosenAssassinSoldierWoundedByChosen';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventDataSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsEventDataUnitAlive'); // Don't play the wounded narrative if the soldier was killed from the attack
	Template.Conditions.AddItem('NarrativeCondition_IsAbilitySourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Wounded_Not_Killed_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Wounded_Not_Killed_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Wounded_Not_Killed_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Wounded_Not_Killed_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Wounded_Not_Killed_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Wounded_Not_Killed_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Wounded_Not_Killed_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Wounded_Not_Killed_H');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinSoldierMissedByChosenTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinSoldierMissedByChosen');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinSoldierMissedByChosen';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityMiss');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Missed_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Missed_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Missed_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Missed_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Missed_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Missed_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Missed_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Soldier_Missed_H');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinCivilianKilledTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinCivilianKilled');
	Template.EventTrigger = 'KillMail';
	Template.NarrativeDeck = 'ChosenAssassinCivilianKilled';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventDataCivilian');
	Template.Conditions.AddItem('NarrativeCondition_IsXComAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Retaliation_Taunt_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Retaliation_Taunt_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Retaliation_Taunt_C');

	return Template;
}

// #######################################################################################
// --------------------------- CHOSEN ATTACKED -------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenAssassinAttackedByAlienHunterWeaponTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinAttackedByAlienHunterWeapon');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinAttackedByAlienHunterWeapon';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityWeaponAlienHunter');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Attacks_With_Hunter_Weap_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Attacks_With_Hunter_Weap_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Attacks_With_Hunter_Weap_C');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinAttackedByChosenWeaponTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinAttackedByChosenWeapon');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinAttackedByChosenWeapon';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityWeaponChosen');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Attacks_With_Chosen_Weap_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Attacks_With_Chosen_Weap_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Attacks_With_Chosen_Weap_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Attacks_With_Chosen_Weap_D');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinAttackedBySparkTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinAttackedBySpark');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinAttackedBySpark';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 1; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSparkSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Spark_Attacks_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Spark_Attacks_B');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinAttackedBySquadsightTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinAttackedBySquadsight');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinAttackedBySquadsight';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 3; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetFromSquadsight');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Attacks_With_Squadsight_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Attacks_With_Squadsight_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Attacks_With_Squadsight_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Attacks_With_Squadsight_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Attacks_With_Squadsight_E');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinAttackedFirstMissTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinAttackedFirstMiss');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinAttackedFirstMiss';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 4; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityMiss');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Misses_Chosen_First_Time_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Misses_Chosen_First_Time_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Misses_Chosen_First_Time_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Misses_Chosen_First_Time_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Misses_Chosen_First_Time_E');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinAttackedMissTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinAttackedMiss');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinAttackedMiss';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 5; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityMiss');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Subsequent_Misses_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Subsequent_Misses_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Subsequent_Misses_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Subsequent_Misses_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Subsequent_Misses_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Subsequent_Misses_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Subsequent_Misses_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Subsequent_Misses_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Subsequent_Misses_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Subsequent_Misses_J');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinAttackedMissBySkirmisherTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinAttackedMissBySkirmisher');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinAttackedMissBySkirmisher';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSkirmisherSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityMiss');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Faction_Miss_Skirmisher_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Faction_Miss_Skirmisher_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Faction_Miss_Skirmisher_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Faction_Miss_Skirmisher_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Faction_Miss_Skirmisher_E');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinAttackedMissByTemplarTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinAttackedMissByTemplar');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinAttackedMissByTemplar';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceTemplarSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityMiss');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Faction_Miss_Templar_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Faction_Miss_Templar_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Faction_Miss_Templar_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Faction_Miss_Templar_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Faction_Miss_Templar_E');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinAttackedFirstHitTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinAttackedFirstHit');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinAttackedFirstHit';
	Template.bOncePerMission = true;
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 4; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHit');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Hits_Chosen_First_Time_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Hits_Chosen_First_Time_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Hits_Chosen_First_Time_C');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinAttackedHitTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinAttackedHit');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinAttackedHit';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 5; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHit');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Subsequent_Hits_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Subsequent_Hits_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Subsequent_Hits_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Subsequent_Hits_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Subsequent_Hits_E');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Subsequent_Hits_F');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Subsequent_Hits_G');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Subsequent_Hits_H');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Subsequent_Hits_I');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_XCOM_Subsequent_Hits_J');
	
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Wounded_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Wounded_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Chosen_Wounded_C');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinAttackedHitBySkirmisherTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinAttackedHitBySkirmisher');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinAttackedHitBySkirmisher';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceSkirmisherSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHit');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Faction_Hit_Skirmisher_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Faction_Hit_Skirmisher_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Faction_Hit_Skirmisher_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Faction_Hit_Skirmisher_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Faction_Hit_Skirmisher_E');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinAttackedHitByTemplarTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinAttackedHitByTemplar');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinAttackedHitByTemplar';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceTemplarSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHit');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Faction_Hit_Templar_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Faction_Hit_Templar_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Faction_Hit_Templar_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Faction_Hit_Templar_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Faction_Hit_Templar_E');

	return Template;
}

static function X2DataTemplate CreateChosenAssassinAttackedHitByReaperTemplate()
{
	local X2DynamicNarrativeMomentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeMomentTemplate', Template, 'NarrativeMoment_ChosenAssassinAttackedHitByReaper');
	Template.EventTrigger = 'AbilityActivated';
	Template.NarrativeDeck = 'ChosenAssassinAttackedHitByReaper';
	Template.NarrativePlayTiming = SPT_AfterParallel;

	Template.Priority = 2; // Priority among other narratives with the same event trigger and successful conditions

	Template.Conditions.AddItem('NarrativeCondition_IsXComPlayerTurn');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAssassinActive');
	Template.Conditions.AddItem('NarrativeCondition_IsEventSourceReaperSoldier');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHit');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetChosenAssassin');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityTargetAlive');
	Template.Conditions.AddItem('NarrativeCondition_IsAbilityHostile');
	Template.Conditions.AddItem('NarrativeCondition_IsChosenAttackedRollMet');

	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Faction_Hit_Reaper_A');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Faction_Hit_Reaper_B');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Faction_Hit_Reaper_C');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Faction_Hit_Reaper_D');
	Template.AddDynamicMoment(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_ASSN_T_Faction_Hit_Reaper_E');

	return Template;
}