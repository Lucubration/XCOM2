//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_XpackObjectives.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_XpackObjectives extends X2StrategyElement
	dependson(XComGameState_ObjectivesList);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Objectives;

	/////////////// XPACK //////////////////
	Objectives.AddItem(CreateN_XPGameStartTemplate());
	Objectives.AddItem(CreateN_XPAlwaysPlayVOTemplate());
	Objectives.AddItem(CreateN_XPBeginnerVOTemplate());
	Objectives.AddItem(CreateN_XPCinematicsTemplate());
	Objectives.AddItem(CreateN_XPAfterActionCommentTemplate());
	Objectives.AddItem(CreateN_XPResearchCommentsTemplate());
	Objectives.AddItem(CreateN_XPPhotoboothCommentTemplate());
	Objectives.AddItem(CreateN_XPFacilityWalkthroughsTemplate());

	// Chosen gameplay objectives
	Objectives.AddItem(CreateN_XPFirstChosenLocatedTemplate());
	Objectives.AddItem(CreateN_XPChosenLocatedTemplate());
	Objectives.AddItem(CreateN_XPMeetTheChosenAssassinTemplate());
	Objectives.AddItem(CreateN_XPMeetTheChosenHunterTemplate());
	Objectives.AddItem(CreateN_XPMeetTheChosenWarlockTemplate());
	Objectives.AddItem(CreateN_XPAssassinFirstAvengerAssaultTemplate());
	Objectives.AddItem(CreateN_XPAssassinAvengerAssaultTemplate());
	Objectives.AddItem(CreateN_XPHunterFirstAvengerAssaultTemplate());
	Objectives.AddItem(CreateN_XPHunterAvengerAssaultTemplate());
	Objectives.AddItem(CreateN_XPWarlockFirstAvengerAssaultTemplate());
	Objectives.AddItem(CreateN_XPWarlockAvengerAssaultTemplate());
	Objectives.AddItem(CreateN_XPKillChosenAssassinTemplate());
	Objectives.AddItem(CreateN_XPKillChosenHunterTemplate());
	Objectives.AddItem(CreateN_XPKillChosenWarlockTemplate());
	Objectives.AddItem(CreateN_XPChosenAssassinTriggerElderRageTemplate());
	Objectives.AddItem(CreateN_XPChosenHunterTriggerElderRageTemplate());
	Objectives.AddItem(CreateN_XPChosenWarlockTriggerElderRageTemplate());
	Objectives.AddItem(CreateN_XPChosenAssassinElderRageTemplate());
	Objectives.AddItem(CreateN_XPChosenHunterElderRageTemplate());
	Objectives.AddItem(CreateN_XPChosenWarlockElderRageTemplate());
	
	// Faction gameplay objectives
	Objectives.AddItem(CreateN_XPFactionHQLocatedTemplate());
	Objectives.AddItem(CreateN_XPMeetTheReapersTemplate());
	Objectives.AddItem(CreateN_XPMeetTheSkirmishersTemplate());
	Objectives.AddItem(CreateN_XPMeetTheTemplarsTemplate());

	////////////// CENTRAL ////////////////////
	Objectives.AddItem(CreateCEN_ChosenRegionContactedTemplate());
	Objectives.AddItem(CreateCEN_ChosenMissionWarningTemplate());
	Objectives.AddItem(CreateCEN_ChosenThresholdChangesTemplate());
	Objectives.AddItem(CreateCEN_MissionBladesTemplate());
	Objectives.AddItem(CreateCEN_SquadSelectTemplate());
	Objectives.AddItem(CreateCEN_ToDoWarningsTemplate());

	////////////// FACTION LEADERS ////////////////////
	// FL = Faction Leader
	Objectives.AddItem(CreateFL_FactionMetTemplate());
	Objectives.AddItem(CreateFL_FactionInfluenceTemplate());
	Objectives.AddItem(CreateFL_ResistanceOpsTemplate());
	Objectives.AddItem(CreateFL_AfterActionCommentTemplate());
	Objectives.AddItem(CreateFL_WalkupCommentTemplate());
	Objectives.AddItem(CreateFL_ResistanceOrdersTemplate());
	Objectives.AddItem(CreateFL_CovertActionsTemplate());

	////////////// CHOSEN ////////////////////
	// CH = Chosen
	Objectives.AddItem(CreateCH_ChosenMetTemplate());
	Objectives.AddItem(CreateCH_RetributionTemplate());
	Objectives.AddItem(CreateCH_SabotageTemplate());
	Objectives.AddItem(CreateCH_SoldierCapturedTemplate());
	Objectives.AddItem(CreateCH_SoldierRescuedTemplate());
	Objectives.AddItem(CreateCH_DarkEventCompleteTemplate());
	Objectives.AddItem(CreateCH_RetaliationTemplate());
	Objectives.AddItem(CreateCH_ThresholdChangesTemplate());
	Objectives.AddItem(CreateCH_CovertActionsTemplate());

	////////////// LOST AND ABANDONED ////////////////////
	Objectives.AddItem(CreateXP0_M0_LostAndAbandonedTemplate());
	Objectives.AddItem(CreateXP0_M1_TutorialLostAndAbandonedCompleteTemplate());
	Objectives.AddItem(CreateXP0_M1_LostAndAbandonedCompleteTemplate());
	Objectives.AddItem(CreateXP0_M2_FactionMetLATemplate());
	Objectives.AddItem(CreateXP0_M3_AssassinLocatedTemplate());
	Objectives.AddItem(CreateXP0_M4_RescueMoxCompleteTemplate());
	Objectives.AddItem(CreateXP0_M5_ActivateChosenLostAndAbandonedTemplate());
	Objectives.AddItem(CreateXP0_M6_MoxReturnsTemplate());
	Objectives.AddItem(CreateXP0_M7_MeetTheReapersLATemplate());

	////////////// CHOSEN ACTIVATION ////////////////////
	Objectives.AddItem(CreateXP1_M0_ActivateChosenTemplate());
	Objectives.AddItem(CreateXP1_M1_RetaliationCompleteTemplate());
	Objectives.AddItem(CreateXP1_M2_RevealChosenTemplate());

	////////////// COVERT ACTION TUTORIALS /////////////////
	Objectives.AddItem(CreateXP2_M0_FirstCovertActionTutorialTemplate());
	Objectives.AddItem(CreateXP2_M1_SecondCovertActionTutorialTemplate());
	
	////////////// NON-LOST AND ABANDONED /////////////////
	Objectives.AddItem(CreateXP3_M0_NonLostAndAbandonedTemplate());
	Objectives.AddItem(CreateXP3_M1_MeetFirstFactionTemplate());
	Objectives.AddItem(CreateXP3_M2_SpawnFirstPOITemplate());

	return Objectives;
}

// #######################################################################################
// -------------------- NARRATIVE OBJECTIVES ---------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateN_XPGameStartTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPGameStart');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	// Additional narrative objectives that should begin every time the game starts
	Template.NextObjectives.AddItem('N_XPAlwaysPlayVO');
	Template.NextObjectives.AddItem('N_XPCinematics');
	Template.NextObjectives.AddItem('N_XPAfterActionComment');
	Template.NextObjectives.AddItem('N_XPResearchComments');
	Template.NextObjectives.AddItem('N_XPPhotoboothComment');
	Template.NextObjectives.AddItem('N_XPFacilityWalkthroughs');

	Template.NextObjectives.AddItem('N_XPMeetTheReapers');
	Template.NextObjectives.AddItem('N_XPMeetTheSkirmishers');
	Template.NextObjectives.AddItem('N_XPMeetTheTemplars');

	Template.NextObjectives.AddItem('N_XPMeetTheChosenAssassin');
	Template.NextObjectives.AddItem('N_XPMeetTheChosenHunter');
	Template.NextObjectives.AddItem('N_XPMeetTheChosenWarlock');
	Template.NextObjectives.AddItem('N_XPAssassinFirstAvengerAssault');
	Template.NextObjectives.AddItem('N_XPHunterFirstAvengerAssault');
	Template.NextObjectives.AddItem('N_XPWarlockFirstAvengerAssault');
	Template.NextObjectives.AddItem('N_XPKillChosenAssassin');
	Template.NextObjectives.AddItem('N_XPKillChosenHunter');
	Template.NextObjectives.AddItem('N_XPKillChosenWarlock');
	Template.NextObjectives.AddItem('N_XPChosenAssassinTriggerElderRage');
	Template.NextObjectives.AddItem('N_XPChosenHunterTriggerElderRage');
	Template.NextObjectives.AddItem('N_XPChosenWarlockTriggerElderRage');

	Template.NextObjectives.AddItem('CEN_ChosenRegionContacted');
	Template.NextObjectives.AddItem('CEN_ChosenMissionWarning');
	Template.NextObjectives.AddItem('CEN_ChosenThresholdChanges');
	Template.NextObjectives.AddItem('CEN_MissionBlades');
	Template.NextObjectives.AddItem('CEN_SquadSelect');
	Template.NextObjectives.AddItem('CEN_ToDoWarnings');
	
	Template.NextObjectives.AddItem('FL_FactionInfluence');
	Template.NextObjectives.AddItem('FL_ResistanceOps');
	Template.NextObjectives.AddItem('FL_AfterActionComment');
	Template.NextObjectives.AddItem('FL_WalkupComment');
	Template.NextObjectives.AddItem('FL_ResistanceOrders');
	Template.NextObjectives.AddItem('FL_CovertActions');

	Template.NextObjectives.AddItem('CH_ChosenMet');
	Template.NextObjectives.AddItem('CH_Retribution');
	Template.NextObjectives.AddItem('CH_Sabotage');
	Template.NextObjectives.AddItem('CH_SoldierCaptured');
	Template.NextObjectives.AddItem('CH_SoldierRescued');
	Template.NextObjectives.AddItem('CH_DarkEventComplete');
	Template.NextObjectives.AddItem('CH_Retaliation');
	Template.NextObjectives.AddItem('CH_ThresholdChanges');
	Template.NextObjectives.AddItem('CH_CovertActions');

	Template.NextObjectives.AddItem('XP2_M0_FirstCovertActionTutorial');
	
	Template.CompletionEvent = 'PreMissionDone';

	return Template;
}

static function X2DataTemplate CreateN_XPAlwaysPlayVOTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPAlwaysPlayVO');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// VO which will play in every game, even in Lost and Abandoned games or when beginner VO is turned off		 //
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// Chosen Fragments
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_First_Fragment_Action", NAW_OnAssignment, 'FirstChosenFragmentAvailable', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Ring_After_Influence_Gained_Fragment_A", NAW_OnAssignment, 'NewFragmentActionAvailable', '', ELD_OnStateSubmitted, NPC_Multiple, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Ring_After_Influence_Gained_Fragment_B", NAW_OnAssignment, 'NewFragmentActionAvailable', '', ELD_OnStateSubmitted, NPC_Multiple, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Ring_After_Influence_Gained_Fragment_C", NAW_OnAssignment, 'NewFragmentActionAvailable', '', ELD_OnStateSubmitted, NPC_Multiple, '');
		
	// Training Center Nags
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Bond_Level_Up_Reminder_A", NAW_OnAssignment, 'OnLevelUpBondReminder', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'NagBuildRecoveryCenter');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Nag_Build_Recovery_Center_A", NAW_OnAssignment, 'OnLevelUpBondReminder', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'NagBuildRecoveryCenter');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Nag_Build_Recovery_Center_B", NAW_OnAssignment, 'OnLevelUpBondReminder', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'NagBuildRecoveryCenter');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Multiple_Bonds_Build_Recovery_A", NAW_OnAssignment, 'OnLevelUpBondReminder', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'NagBuildRecoveryCenter');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Multiple_Bonds_Build_Recovery_B", NAW_OnAssignment, 'OnLevelUpBondReminder', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'NagBuildRecoveryCenter');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Multiple_Bonds_Build_Recovery_C", NAW_OnAssignment, 'OnLevelUpBondReminder', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'NagBuildRecoveryCenter');
	
	// Covert Actions
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Low_Staff_Covert_Actions_ALT", NAW_OnAssignment, 'LowSoldiersCovertAction', '', ELD_OnStateSubmitted, NPC_Once, '', 'LowStaffCovertAction');
	
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Ambushed_Covert_Action_A", NAW_OnAssignment, 'CovertActionAmbush_Central', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralCovertActionAmbushed');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Ambushed_Covert_Action_B", NAW_OnAssignment, 'CovertActionAmbush_Central', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralCovertActionAmbushed');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Ambushed_Covert_Action_C", NAW_OnAssignment, 'CovertActionAmbush_Central', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralCovertActionAmbushed');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Soldier_Captured_Covert_Action_A", NAW_OnAssignment, 'CovertActionSoldierCaptured_Central', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralCovertActionSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Soldier_Captured_Covert_Action_B", NAW_OnAssignment, 'CovertActionSoldierCaptured_Central', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralCovertActionSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Soldier_Captured_Covert_Action_C", NAW_OnAssignment, 'CovertActionSoldierCaptured_Central', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralCovertActionSoldierCaptured');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Soldier_Wounded_Covert_Action_A", NAW_OnAssignment, 'CovertActionSoldierWounded_Central', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralCovertActionSoldierWounded');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Soldier_Wounded_Covert_Action_B", NAW_OnAssignment, 'CovertActionSoldierWounded_Central', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralCovertActionSoldierWounded');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Soldier_Wounded_Covert_Action_C", NAW_OnAssignment, 'CovertActionSoldierWounded_Central', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralCovertActionSoldierWounded');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Soldier_Wounded_Covert_Action_D", NAW_OnAssignment, 'CovertActionSoldierWounded_Central', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralCovertActionSoldierWounded');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Soldier_Wounded_Covert_Action_E", NAW_OnAssignment, 'CovertActionSoldierWounded_Central', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralCovertActionSoldierWounded');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Fragment_Recover_Covert_Action_A", NAW_OnAssignment, 'ChosenFragmentRecovered', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralChosenFragmentRecovered');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Fragment_Recover_Covert_Action_B", NAW_OnAssignment, 'ChosenFragmentRecovered', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralChosenFragmentRecovered');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Fragment_Recover_Covert_Action_C", NAW_OnAssignment, 'ChosenFragmentRecovered', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralChosenFragmentRecovered');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Fragment_Recover_Covert_Action_D", NAW_OnAssignment, 'ChosenFragmentRecovered', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralChosenFragmentRecovered');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Fragment_Recover_Covert_Action_E", NAW_OnAssignment, 'ChosenFragmentRecovered', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralChosenFragmentRecovered');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Chosen_Fragment_Recovered_A", NAW_OnAssignment, 'ChosenFragmentRecovered', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralChosenFragmentRecovered');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Chosen_Fragment_Recovered_B", NAW_OnAssignment, 'ChosenFragmentRecovered', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralChosenFragmentRecovered');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Chosen_Fragment_Recovered_C", NAW_OnAssignment, 'ChosenFragmentRecovered', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralChosenFragmentRecovered');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Chosen_Fragment_Recovered_D", NAW_OnAssignment, 'ChosenFragmentRecovered', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralChosenFragmentRecovered');

	// Chosen Sabotage
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Chosen_Sabotages_XCOM_A", NAW_OnAssignment, 'PostChosenSabotage', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralPostChosenSabotage');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Chosen_Sabotages_XCOM_B", NAW_OnAssignment, 'PostChosenSabotage', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralPostChosenSabotage');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Chosen_Sabotages_XCOM_C", NAW_OnAssignment, 'PostChosenSabotage', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralPostChosenSabotage');

	// Chosen Retribution
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_After_Chosen_Retaliation_A", NAW_OnAssignment, 'PostChosenRetribution', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralPostChosenRetribution');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_After_Chosen_Retaliation_B", NAW_OnAssignment, 'PostChosenRetribution', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralPostChosenRetribution');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_After_Chosen_Retaliation_C", NAW_OnAssignment, 'PostChosenRetribution', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralPostChosenRetribution');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Chosen_Knowledge_First", NAW_OnAssignment, 'PostChosenRetribution', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralPostChosenRetribution');

	// Soldier Captured Closed	
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Soldier_Captured_A", NAW_OnAssignment, 'SoldierCapturedClosed', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralSoldierCapturedClosed');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Soldier_Captured_B", NAW_OnAssignment, 'SoldierCapturedClosed', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralSoldierCapturedClosed');
	
	// The Lost
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_T_Lost_First_Howl", NAW_OnAssignment, 'OnLostHowl', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_T_Lost_Howl_Warning", NAW_OnAssignment, 'OnLostApproaching', '', ELD_OnStateSubmitted, NPC_Once, 'LostHowlWarnings');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_T_Lost_Approaching", NAW_OnAssignment, 'OnLostApproaching', '', ELD_OnStateSubmitted, NPC_Once, 'LostHowlWarnings');
	
	// Chosen Tactical Summary
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_T_Chosen_Summary_Defeated", NAW_OnAssignment, 'ChosenSummaryDefeated', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_T_Chosen_Summary_Capture", NAW_OnAssignment, 'ChosenSummaryCapture', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_T_Chosen_Summary_Extraction", NAW_OnAssignment, 'ChosenSummaryExtract', '', ELD_OnStateSubmitted, NPC_Once, '');

	// Hunt Chosen Nags
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Hunt_Chosen_Covert_Action_Nag_A", NAW_OnAssignment, 'OnHuntChosenNag1', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Hunt_Chosen_Covert_Action_Nag_B", NAW_OnAssignment, 'OnHuntChosenNag2', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Hunt_Chosen_Covert_Action_Nag_C", NAW_OnAssignment, 'OnHuntChosenNag3', '', ELD_OnStateSubmitted, NPC_Once, '');
	
	// DLC 2 Integration
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Alien_Ruler_Available", NAW_OnAssignment, 'OnRulerGuardingFacilityPopup', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Post_Ruler_Escapes", NAW_OnAssignment, 'AfterAction_RulerEscaped', '', ELD_OnStateSubmitted, NPC_Once, '');
				
	return Template;
}

static function X2DataTemplate CreateN_XPBeginnerVOTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPBeginnerVO');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// This objective should hold ALL Beginner VO EXCEPT things that would play in the Lost and Abandoned sequence  //
	// They will play in both L&A and Non-L&A modes        															//
	// BUT THESE WILL NOT PLAY IF BEGINNER VO IS TURNED OFF															//
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// First Time Moments
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_First_Hero_Promotion", NAW_OnAssignment, 'OnHeroPromotionScreen', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_First_End_Month_Chosen", NAW_OnAssignment, 'OnViewChosenEvents', '', ELD_OnStateSubmitted, NPC_Once, '', 'FirstChosenReport');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_First_Chosen_Activity", NAW_OnAssignment, 'OnViewChosenEvents', '', ELD_OnStateSubmitted, NPC_Once, '', 'FirstChosenReport');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_TYG_S_First_Research_Breakthrough", NAW_OnAssignment, 'OnBreakthroughTech', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_TYG_S_First_Research_Inspiration", NAW_OnAssignment, 'OnInspiredTech', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_First_Photobooth", NAW_OnAssignment, 'OnViewPhotobooth', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_First_SITREP_ALT", NAW_OnAssignment, 'OnSITREPIntro', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_First_Resistance_Policies", NAW_OnAssignment, 'OnResistanceOrdersIntroPopup', '', ELD_OnStateSubmitted, NPC_Once, '');
	//Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_First_Resistance_Order", NAW_OnAssignment, 'OnResistanceOrderReceived', '', ELD_OnStateSubmitted, NPC_Once, '', 'FirstResistanceOrder');
	//Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_First_Strategy_Card", NAW_OnAssignment, 'OnResistanceOrderReceived', '', ELD_OnStateSubmitted, NPC_Once, '', 'FirstResistanceOrder');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_First_Com_Int", NAW_OnAssignment, 'OnComIntIntro', '', ELD_OnStateSubmitted, NPC_Once, 'ComIntIntro');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Combat_Intelligence", NAW_OnAssignment, 'OnComIntIntro', '', ELD_OnStateSubmitted, NPC_Once, 'ComIntIntro');
	//Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Chosen_Encounter_Screen", NAW_OnAssignment, 'OnViewChosenInfo', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Chosen_Strengths", NAW_OnAssignment, 'OnViewChosenInfo', '', ELD_OnStateSubmitted, NPC_Once, '');
	
	// Covert Actions
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_First_Covert_Actions", NAW_OnAssignment, 'OnCovertActionsPopup', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Covert_Action_Tutorial", NAW_OnAssignment, 'OnCovertActionIntro', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Covert_Action_Risks", NAW_OnAssignment, 'OnCovertActionRiskIntro', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Covert_Action_In_Progress", NAW_OnAssignment, 'CovertActionInProgress', '', ELD_OnStateSubmitted, NPC_Once, '', 'CovertActionInProgress');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Covert_Action_Already_Underway", NAW_OnAssignment, 'CovertActionInProgress', '', ELD_OnStateSubmitted, NPC_Once, '', 'CovertActionInProgress');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Covert_Action_Veteran_Required", NAW_OnAssignment, 'CovertActionVetRequired', '', ELD_OnStateSubmitted, NPC_Once, '');

	// Facilities Available
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_SHN_S_Ring_Available", NAW_OnAssignment, 'FacilityAvailablePopup', 'ResistanceRing', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_SHN_S_Recovery_Center_Available", NAW_OnAssignment, 'FacilityAvailablePopup', 'RecoveryCenter', ELD_OnStateSubmitted, NPC_Once, '');

	// First Facility Entry
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_First_Time_Recovery_Center", NAW_OnAssignment, 'OnEnteredFacility_RecoveryCenter', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_SPO_S_First_Ring_Covert_Actions", NAW_OnAssignment, 'OnEnteredFacility_ResistanceRing', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Tutorial_Infirmary", NAW_OnAssignment, 'OnEnteredFacility_AdvancedWarfareCenter', '', ELD_OnStateSubmitted, NPC_Once, '');
	
	// Soldier Bonds
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_First_Soldier_Compatibility", NAW_OnAssignment, 'OnSoldierCompatibilityIntro', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_First_Bond_Available", NAW_OnAssignment, 'AfterAction_Bond', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_First_Bond_Level_Up", NAW_OnAssignment, 'AfterAction_LevelUpBond', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_View_First_Bond_Available", NAW_OnAssignment, 'OnBondAvailable', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_First_Level_Two_Bond", NAW_OnAssignment, 'BondLevelUpComplete', '', ELD_OnStateSubmitted, NPC_Once, '');
	//Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_First_Watershed_Moment", NAW_OnAssignment, 'OnWatershedMoment', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_View_First_Bond_Level_Up", NAW_OnAssignment, 'OnLevelUpBondAvailable', '', ELD_OnStateSubmitted, NPC_Once, '');

	// Soldier Will
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_First_Positive_Trait", NAW_OnAssignment, 'OnPositiveTraitAcquired', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_First_Negative_Trait", NAW_OnAssignment, 'OnNegativeTraitAcquired', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_TYG_S_First_Mult_Negative_Traits", NAW_OnAssignment, 'OnMultNegativeTraits', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_First_Low_Will_Return", NAW_OnAssignment, 'OnSoldierTiredPopup', '', ELD_OnStateSubmitted, NPC_Once, '', 'FirstTiredSoldierReturns');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_First_Soldier_Returns_Tired", NAW_OnAssignment, 'OnSoldierTiredPopup', '', ELD_OnStateSubmitted, NPC_Once, '', 'FirstTiredSoldierReturns');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_First_Soldier_Shaken", NAW_OnAssignment, 'OnSoldierShakenPopup', '', ELD_OnStateSubmitted, NPC_Once, '', 'FirstShakenSoldierReturns');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_First_Soldier_Returns_Shaken", NAW_OnAssignment, 'OnSoldierShakenPopup', '', ELD_OnStateSubmitted, NPC_Once, '', 'FirstShakenSoldierReturns');

	// Squad Select
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_First_Tired_Squad_Select", NAW_OnAssignment, 'OnTiredSoldierSquadSelect', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_First_Shaken_Squad_Select", NAW_OnAssignment, 'OnShakenSoldierSquadSelect', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_TYG_S_First_Recovery_Boost", NAW_OnAssignment, 'OnRecoveryBoostSquadSelect', '', ELD_OnStateSubmitted, NPC_Once, '');

	// Lost and Abandoned - Beginner VO is forced on when L&A is enabled
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_T_LNA_Part1_Opening_Base_View", NAW_OnAssignment, 'OnViewLostAndAbandoned', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_T_LNA_Part1_LoadOut", NAW_OnAssignment, 'OnLostAndAbandonedSquadSelect', '', ELD_OnStateSubmitted, NPC_Once, '');

	// Rescue Soldier Available
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Captured_Soldier_Found_A", NAW_OnAssignment, 'OnRescueSoldierPopup', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralRescueSoldierAvailable');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Captured_Soldier_Found_B", NAW_OnAssignment, 'OnRescueSoldierPopup', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralRescueSoldierAvailable');

	// Misc
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_SPO_Faction_Leader_Screen", NAW_OnAssignment, 'OnResistanceOrdersScreen', '', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}

static function X2DataTemplate CreateN_XPCinematicsTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPCinematics');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.XP_LostAndAbandoned", NAW_OnAssignment, 'LostAndAbandonedSpawned', '', ELD_OnStateSubmitted, NPC_Once, '');
	
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.XP_ChosenAssaultAssassin", NAW_OnAssignment, 'ChosenAssault_Assassin', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.XP_ChosenAssaultHunter", NAW_OnAssignment, 'ChosenAssault_Hunter', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.XP_ChosenAssaultWarlock", NAW_OnAssignment, 'ChosenAssault_Warlock', '', ELD_OnStateSubmitted, NPC_Once, '');
	
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.XP_WrapUpReapers", NAW_OnAssignment, 'WrapUp_Reapers', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.XP_WrapUpSkirmishers", NAW_OnAssignment, 'WrapUp_Skirmishers', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.XP_WrapUpTemplars", NAW_OnAssignment, 'WrapUp_Templars', '', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}

static function X2DataTemplate CreateN_XPAfterActionCommentTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPAfterActionComment');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionEvent = '';
	
	// Soldier Captured
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Walkup_Soldier_Captured", NAW_OnAssignment, 'AfterAction_SoldierCaptured', '', ELD_OnStateSubmitted, NPC_Multiple, 'AfterActionSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_SHN_Walkup_Soldier_Captured", NAW_OnAssignment, 'AfterAction_SoldierCaptured', '', ELD_OnStateSubmitted, NPC_Multiple, 'AfterActionSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_TYG_Walkup_Soldier_Captured", NAW_OnAssignment, 'AfterAction_SoldierCaptured', '', ELD_OnStateSubmitted, NPC_Multiple, 'AfterActionSoldierCaptured');

	// Chosen Won
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Walkup_Chosen_Extracted", NAW_OnAssignment, 'AfterAction_ChosenWon', '', ELD_OnStateSubmitted, NPC_Multiple, 'AfterActionChosenWon');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_SHN_Walkup_Chosen_Extracted", NAW_OnAssignment, 'AfterAction_ChosenWon', '', ELD_OnStateSubmitted, NPC_Multiple, 'AfterActionChosenWon');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_TYG_Walkup_Chosen_Extracted", NAW_OnAssignment, 'AfterAction_ChosenWon', '', ELD_OnStateSubmitted, NPC_Multiple, 'AfterActionChosenWon');
	
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Chosen_Defeats_XCOM_A", NAW_OnAssignment, 'AfterAction_ChosenWon_ToughMission', '', ELD_OnStateSubmitted, NPC_Multiple, 'AfterActionChosenWonToughMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Chosen_Defeats_XCOM_B", NAW_OnAssignment, 'AfterAction_ChosenWon_ToughMission', '', ELD_OnStateSubmitted, NPC_Multiple, 'AfterActionChosenWonToughMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Chosen_Defeats_XCOM_C", NAW_OnAssignment, 'AfterAction_ChosenWon_ToughMission', '', ELD_OnStateSubmitted, NPC_Multiple, 'AfterActionChosenWonToughMission');

	// Chosen Lost
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Walkup_Chosen_Defeated", NAW_OnAssignment, 'AfterAction_ChosenLost', '', ELD_OnStateSubmitted, NPC_Multiple, 'AfterActionChosenLost');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_SHN_Walkup_Chosen_Defeated", NAW_OnAssignment, 'AfterAction_ChosenLost', '', ELD_OnStateSubmitted, NPC_Multiple, 'AfterActionChosenLost');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_TYG_Walkup_Chosen_Defeated", NAW_OnAssignment, 'AfterAction_ChosenLost', '', ELD_OnStateSubmitted, NPC_Multiple, 'AfterActionChosenLost');

	// High Level Hero
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Walkup_High_Level_Faction_Hero", NAW_OnAssignment, 'AfterAction_HighLevelHero', '', ELD_OnStateSubmitted, NPC_Multiple, 'AfterActionHighLevelHero');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_SHN_Walkup_High_Level_Faction_Hero", NAW_OnAssignment, 'AfterAction_HighLevelHero', '', ELD_OnStateSubmitted, NPC_Multiple, 'AfterActionHighLevelHero');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_TYG_Walkup_High_Level_Faction_Hero", NAW_OnAssignment, 'AfterAction_HighLevelHero', '', ELD_OnStateSubmitted, NPC_Multiple, 'AfterActionHighLevelHero');

	// Chosen Killed Stronghold
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Walkup_Chosen_Killed_Stronghold", NAW_OnAssignment, 'AfterAction_ChosenDefeated', '', ELD_OnStateSubmitted, NPC_Multiple, 'AfterActionChosenDefeated');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_SHN_Walkup_Chosen_Killed_Stronghold", NAW_OnAssignment, 'AfterAction_ChosenDefeated', '', ELD_OnStateSubmitted, NPC_Multiple, 'AfterActionChosenDefeated');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_TYG_Walkup_Chosen_Killed_Stronghold", NAW_OnAssignment, 'AfterAction_ChosenDefeated', '', ELD_OnStateSubmitted, NPC_Multiple, 'AfterActionChosenDefeated');

	// Lost Encountered
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Walkup_Lost_Encountered", NAW_OnAssignment, 'AfterAction_LostEncountered', '', ELD_OnStateSubmitted, NPC_Multiple, 'AfterActionLostEncountered');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_SHN_Walkup_Lost_Encountered", NAW_OnAssignment, 'AfterAction_LostEncountered', '', ELD_OnStateSubmitted, NPC_Multiple, 'AfterActionLostEncountered');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_TYG_Walkup_Lost_Encountered", NAW_OnAssignment, 'AfterAction_LostEncountered', '', ELD_OnStateSubmitted, NPC_Multiple, 'AfterActionLostEncountered');

	// Lost and Abandoned
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Walkup_Lost_Abandoned", NAW_OnAssignment, 'AfterAction_LostAndAbandoned', '', ELD_OnStateSubmitted, NPC_Multiple, 'AfterActionLostAndAbandoned');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_SHN_Walkup_Lost_Abandoned", NAW_OnAssignment, 'AfterAction_LostAndAbandoned', '', ELD_OnStateSubmitted, NPC_Multiple, 'AfterActionLostAndAbandoned');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_TYG_Walkup_Lost_Abandoned", NAW_OnAssignment, 'AfterAction_LostAndAbandoned', '', ELD_OnStateSubmitted, NPC_Multiple, 'AfterActionLostAndAbandoned');

	// Avenger Assault
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Post_Avenger_Assault", NAW_OnAssignment, 'AfterAction_AvengerAssault', '', ELD_OnStateSubmitted, NPC_Multiple, '');

	return Template;
}

static function X2DataTemplate CreateN_XPResearchCommentsTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPResearchComments');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_TYG_Breakthrough_Complete_A", NAW_OnAssignment, 'BreakthroughComplete', '', ELD_OnStateSubmitted, NPC_Multiple, 'TyganBreakthroughComplete');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_TYG_Breakthrough_Complete_B", NAW_OnAssignment, 'BreakthroughComplete', '', ELD_OnStateSubmitted, NPC_Multiple, 'TyganBreakthroughComplete');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_TYG_Breakthrough_Complete_C", NAW_OnAssignment, 'BreakthroughComplete', '', ELD_OnStateSubmitted, NPC_Multiple, 'TyganBreakthroughComplete');
	
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_TYG_Inspiration_Complete_A", NAW_OnAssignment, 'InspirationComplete', '', ELD_OnStateSubmitted, NPC_Multiple, 'TyganInspirationComplete');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_TYG_Inspiration_Complete_B", NAW_OnAssignment, 'InspirationComplete', '', ELD_OnStateSubmitted, NPC_Multiple, 'TyganInspirationComplete');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_TYG_Inspiration_Complete_C", NAW_OnAssignment, 'InspirationComplete', '', ELD_OnStateSubmitted, NPC_Multiple, 'TyganInspirationComplete');
	
	return Template;
}

static function X2DataTemplate CreateN_XPPhotoboothCommentTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPPhotoboothComment');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Photobooth_Musing_A", NAW_OnAssignment, 'OnPhotoTaken', '', ELD_OnStateSubmitted, NPC_Multiple, 'PhotoboothComments');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Photobooth_Musing_B", NAW_OnAssignment, 'OnPhotoTaken', '', ELD_OnStateSubmitted, NPC_Multiple, 'PhotoboothComments');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Photobooth_Musing_C", NAW_OnAssignment, 'OnPhotoTaken', '', ELD_OnStateSubmitted, NPC_Multiple, 'PhotoboothComments');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Photobooth_Musing_D", NAW_OnAssignment, 'OnPhotoTaken', '', ELD_OnStateSubmitted, NPC_Multiple, 'PhotoboothComments');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Photobooth_Musing_E", NAW_OnAssignment, 'OnPhotoTaken', '', ELD_OnStateSubmitted, NPC_Multiple, 'PhotoboothComments');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_TYG_Photobooth_Musing_A", NAW_OnAssignment, 'OnPhotoTaken', '', ELD_OnStateSubmitted, NPC_Multiple, 'PhotoboothComments');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_TYG_Photobooth_Musing_B", NAW_OnAssignment, 'OnPhotoTaken', '', ELD_OnStateSubmitted, NPC_Multiple, 'PhotoboothComments');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_TYG_Photobooth_Musing_D", NAW_OnAssignment, 'OnPhotoTaken', '', ELD_OnStateSubmitted, NPC_Multiple, 'PhotoboothComments');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_TYG_Photobooth_Musing_E", NAW_OnAssignment, 'OnPhotoTaken', '', ELD_OnStateSubmitted, NPC_Multiple, 'PhotoboothComments');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_SHN_Photobooth_Musing_A", NAW_OnAssignment, 'OnPhotoTaken', '', ELD_OnStateSubmitted, NPC_Multiple, 'PhotoboothComments');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_SHN_Photobooth_Musing_B", NAW_OnAssignment, 'OnPhotoTaken', '', ELD_OnStateSubmitted, NPC_Multiple, 'PhotoboothComments');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_SHN_Photobooth_Musing_C", NAW_OnAssignment, 'OnPhotoTaken', '', ELD_OnStateSubmitted, NPC_Multiple, 'PhotoboothComments');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_SHN_Photobooth_Musing_D", NAW_OnAssignment, 'OnPhotoTaken', '', ELD_OnStateSubmitted, NPC_Multiple, 'PhotoboothComments');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_SHN_Photobooth_Musing_E", NAW_OnAssignment, 'OnPhotoTaken', '', ELD_OnStateSubmitted, NPC_Multiple, 'PhotoboothComments');

	return Template;
}

static function X2DataTemplate CreateN_XPFacilityWalkthroughsTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPFacilityWalkthroughs');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.Flyin_Ring", NAW_OnAssignment, 'OnEnteredFacility_ResistanceRing', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.Flyin_RecoveryCenter", NAW_OnAssignment, 'OnEnteredFacility_RecoveryCenter', '', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}

// ---------------------------------- CHOSEN GAMEPLAY OBJECTIVES ------------------------------------
static function X2DataTemplate CreateN_XPFirstChosenLocatedTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPFirstChosenLocated');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.NextObjectives.AddItem('N_XPChosenLocated');

	Template.CompletionEvent = 'ChosenEncountered';
	
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Chosen_Encounter_First_Post_Combat_A", NAW_OnAssignment, 'ChosenEncountered', '', ELD_OnStateSubmitted, NPC_Multiple, 'FirstChosenEncounterLines', ContinueChosenReveal);
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Chosen_Encounter_First_Post_Combat_B", NAW_OnAssignment, 'ChosenEncountered', '', ELD_OnStateSubmitted, NPC_Multiple, 'FirstChosenEncounterLines', ContinueChosenReveal);
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Chosen_Encounter_First_Post_Combat_C", NAW_OnAssignment, 'ChosenEncountered', '', ELD_OnStateSubmitted, NPC_Multiple, 'FirstChosenEncounterLines', ContinueChosenReveal);
	
	return Template;
}

static function X2DataTemplate CreateN_XPChosenLocatedTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPChosenLocated');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Chosen_Encounter_Territory_Contact_A", NAW_OnAssignment, 'ChosenEncountered', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenEncounterContactLines', ContinueChosenReveal);
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Chosen_Encounter_Territory_Contact_B", NAW_OnAssignment, 'ChosenEncountered', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenEncounterContactLines', ContinueChosenReveal);
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Chosen_Encounter_Territory_Contact_C", NAW_OnAssignment, 'ChosenEncountered', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenEncounterContactLines', ContinueChosenReveal);

	return Template;
}

function ContinueChosenReveal()
{
	`HQPRES.UIChosenRevealComplete();
}

static function X2DataTemplate CreateN_XPMeetTheChosenAssassinTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPMeetTheChosenAssassin');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionEvent = 'ChosenMet_Assassin';

	return Template;
}

static function X2DataTemplate CreateN_XPMeetTheChosenHunterTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPMeetTheChosenHunter');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionEvent = 'ChosenMet_Hunter';

	return Template;
}

static function X2DataTemplate CreateN_XPMeetTheChosenWarlockTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPMeetTheChosenWarlock');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionEvent = 'ChosenMet_Warlock';

	return Template;
}

static function X2DataTemplate CreateN_XPAssassinFirstAvengerAssaultTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPAssassinFirstAvengerAssault');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.NextObjectives.AddItem('N_XPAssassinAvengerAssault');

	Template.CompletionEvent = 'ChosenAssaultComment_Assassin';
	
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Assault_Avenger_First", NAW_OnAssignment, 'ChosenAssaultComment_Assassin', '', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}

static function X2DataTemplate CreateN_XPAssassinAvengerAssaultTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPAssassinAvengerAssault');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Assault_Avenger_Subs", NAW_OnAssignment, 'ChosenAssaultComment_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, '');

	return Template;
}

static function X2DataTemplate CreateN_XPHunterFirstAvengerAssaultTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPHunterFirstAvengerAssault');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.NextObjectives.AddItem('N_XPHunterAvengerAssault');

	Template.CompletionEvent = 'ChosenAssaultComment_Hunter';

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Assault_Avenger_First", NAW_OnAssignment, 'ChosenAssaultComment_Hunter', '', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}

static function X2DataTemplate CreateN_XPHunterAvengerAssaultTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPHunterAvengerAssault');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Assault_Avenger_Subs", NAW_OnAssignment, 'ChosenAssaultComment_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, '');

	return Template;
}

static function X2DataTemplate CreateN_XPWarlockFirstAvengerAssaultTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPWarlockFirstAvengerAssault');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.NextObjectives.AddItem('N_XPWarlockAvengerAssault');

	Template.CompletionEvent = 'ChosenAssaultComment_Warlock';

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Assault_Avenger_First", NAW_OnAssignment, 'ChosenAssaultComment_Warlock', '', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}

static function X2DataTemplate CreateN_XPWarlockAvengerAssaultTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPWarlockAvengerAssault');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Assault_Avenger_Subs", NAW_OnAssignment, 'ChosenAssaultComment_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, '');

	return Template;
}

static function X2DataTemplate CreateN_XPKillChosenAssassinTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPKillChosenAssassin');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionEvent = 'ChosenAssassinKilled';

	return Template;
}

static function X2DataTemplate CreateN_XPKillChosenHunterTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPKillChosenHunter');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionEvent = 'ChosenHunterKilled';

	return Template;
}

static function X2DataTemplate CreateN_XPKillChosenWarlockTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPKillChosenWarlock');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionEvent = 'ChosenWarlockKilled';

	return Template;
}

static function X2DataTemplate CreateN_XPChosenAssassinTriggerElderRageTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPChosenAssassinTriggerElderRage');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.NextObjectives.AddItem('N_XPChosenAssassinElderRage');
	Template.CompletionEvent = 'ChosenAssassinElderRage';

	return Template;
}

static function X2DataTemplate CreateN_XPChosenHunterTriggerElderRageTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPChosenHunterTriggerElderRage');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.NextObjectives.AddItem('N_XPChosenHunterElderRage');
	Template.CompletionEvent = 'ChosenHunterElderRage';

	return Template;
}

static function X2DataTemplate CreateN_XPChosenWarlockTriggerElderRageTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPChosenWarlockTriggerElderRage');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.NextObjectives.AddItem('N_XPChosenWarlockElderRage');
	Template.CompletionEvent = 'ChosenWarlockElderRage';

	return Template;
}

static function X2DataTemplate CreateN_XPChosenAssassinElderRageTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPChosenAssassinElderRage');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.RevealEvent = 'OnEnteredFacility_CIC';
	Template.CompletionEvent = 'ElderRageComplete';

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.XP_ElderRage_AssassinDied", NAW_OnReveal, '', '', ELD_OnStateSubmitted, NPC_Once, '', ElderRageComplete);

	return Template;
}

static function X2DataTemplate CreateN_XPChosenHunterElderRageTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPChosenHunterElderRage');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.RevealEvent = 'OnEnteredFacility_CIC';
	Template.CompletionEvent = 'ElderRageComplete';

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.XP_ElderRage_HunterDied", NAW_OnReveal, '', '', ELD_OnStateSubmitted, NPC_Once, '', ElderRageComplete);

	return Template;
}

static function X2DataTemplate CreateN_XPChosenWarlockElderRageTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPChosenWarlockElderRage');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.RevealEvent = 'OnEnteredFacility_CIC';
	Template.CompletionEvent = 'ElderRageComplete';

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.XP_ElderRage_WarlockDied", NAW_OnReveal, '', '', ELD_OnStateSubmitted, NPC_Once, '', ElderRageComplete);

	return Template;
}

function ElderRageComplete()
{
	local XComGameState NewGameState;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger Elder Rage Complete Event");
	`XEVENTMGR.TriggerEvent('ElderRageComplete', , , NewGameState);
	`GAMERULES.SubmitGameState(NewGameState);
}

// ---------------------------------- FACTION GAMEPLAY OBJECTIVES ------------------------------------
static function X2DataTemplate CreateN_XPFactionHQLocatedTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPFactionHQLocated');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Contacted_Reaper_HQ", NAW_OnAssignment, 'RevealHQ_Reapers', '', ELD_OnStateSubmitted, NPC_Once, '', ContinueFactionHQReveal);
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Contacted_Skirmisher_HQ", NAW_OnAssignment, 'RevealHQ_Skirmishers', '', ELD_OnStateSubmitted, NPC_Once, '', ContinueFactionHQReveal);
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Contacted_Templar_HQ", NAW_OnAssignment, 'RevealHQ_Templars', '', ELD_OnStateSubmitted, NPC_Once, '', ContinueFactionHQReveal);

	return Template;
}

function ContinueFactionHQReveal()
{
	`HQPRES.FactionRevealPlayClassIntroMovie();
}

static function X2DataTemplate CreateN_XPMeetTheReapersTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPMeetTheReapers');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionEvent = 'MetFaction_Reapers';

	return Template;
}

static function X2DataTemplate CreateN_XPMeetTheSkirmishersTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPMeetTheSkirmishers');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionEvent = 'MetFaction_Skirmishers';

	return Template;
}

static function X2DataTemplate CreateN_XPMeetTheTemplarsTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'N_XPMeetTheTemplars');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionEvent = 'MetFaction_Templars';

	return Template;
}

// #######################################################################################
// ---------------------------------- CENTRAL --------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateCEN_ChosenRegionContactedTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'CEN_ChosenRegionContacted');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Assassin_Sighting_A", NAW_OnAssignment, 'ChosenRegionContacted_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenAssassinRegionContactedLines');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Assassin_Sighting_B", NAW_OnAssignment, 'ChosenRegionContacted_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenAssassinRegionContactedLines');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Assassin_Sighting_C", NAW_OnAssignment, 'ChosenRegionContacted_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenAssassinRegionContactedLines');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Hunter_Sighting_A", NAW_OnAssignment, 'ChosenRegionContacted_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenHunterRegionContactedLines');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Hunter_Sighting_B", NAW_OnAssignment, 'ChosenRegionContacted_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenHunterRegionContactedLines');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Hunter_Sighting_C", NAW_OnAssignment, 'ChosenRegionContacted_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenHunterRegionContactedLines');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Warlock_Sighting_A", NAW_OnAssignment, 'ChosenRegionContacted_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenWarlockRegionContactedLines');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Warlock_Sighting_B", NAW_OnAssignment, 'ChosenRegionContacted_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenWarlockRegionContactedLines');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Warlock_Sighting_C", NAW_OnAssignment, 'ChosenRegionContacted_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenWarlockRegionContactedLines');

	return Template;
}

static function X2DataTemplate CreateCEN_ChosenMissionWarningTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'CEN_ChosenMissionWarning');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
		
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Chosen_Chance_Mission_Appear", NAW_OnAssignment, 'OnChosenMissionBlades', '', ELD_OnStateSubmitted, NPC_Once, '');

	//Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Generic_Chosen_Activity_A", NAW_OnAssignment, 'OnChosenMissionBlades', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenMissionBladeLines');
	//Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Generic_Chosen_Activity_B", NAW_OnAssignment, 'OnChosenMissionBlades', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenMissionBladeLines');
	//Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Generic_Chosen_Activity_C", NAW_OnAssignment, 'OnChosenMissionBlades', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenMissionBladeLines');
	//Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Generic_Chosen_Activity_D", NAW_OnAssignment, 'OnChosenMissionBlades', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenMissionBladeLines');
	//Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Generic_Chosen_Activity_E", NAW_OnAssignment, 'OnChosenMissionBlades', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenMissionBladeLines');

	return Template;
}

static function X2DataTemplate CreateCEN_ChosenThresholdChangesTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'CEN_ChosenThresholdChanges');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_After_Chosen_Half_Knowledge_A", NAW_OnAssignment, 'ChosenKnowledgeHalfway', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenKnowledgeHalfwayLines');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_After_Chosen_Half_Knowledge_B", NAW_OnAssignment, 'ChosenKnowledgeHalfway', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenKnowledgeHalfwayLines');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_After_Chosen_Half_Knowledge_C", NAW_OnAssignment, 'ChosenKnowledgeHalfway', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenKnowledgeHalfwayLines');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_After_Chosen_Full_Knowledge_A", NAW_OnAssignment, 'ChosenKnowledgeComplete', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenKnowledgeCompleteLines');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_After_Chosen_Full_Knowledge_B", NAW_OnAssignment, 'ChosenKnowledgeComplete', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenKnowledgeCompleteLines');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_After_Chosen_Full_Knowledge_C", NAW_OnAssignment, 'ChosenKnowledgeComplete', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenKnowledgeCompleteLines');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Chosen_Leveled_Up_A", NAW_OnAssignment, 'ChosenLeveledUp', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenLeveledUpLines');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Chosen_Leveled_Up_B", NAW_OnAssignment, 'ChosenLeveledUp', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenLeveledUpLines');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Chosen_Leveled_Up_C", NAW_OnAssignment, 'ChosenLeveledUp', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenLeveledUpLines');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Chosen_Level_Up_A", NAW_OnAssignment, 'ChosenLeveledUp', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenLeveledUpLines');

	return Template;
}

static function X2DataTemplate CreateCEN_MissionBladesTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'CEN_MissionBlades');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	//Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Chosen_Guarding_Golden_Path", NAW_OnAssignment, 'OnChosenGoldenPathBlades', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenGoldenPathBladeLines');
	//Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Chosen_Guarding_Golden_Path_B", NAW_OnAssignment, 'OnChosenGoldenPathBlades', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenGoldenPathBladeLines');
	//Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Chosen_Guarding_Golden_Path_C", NAW_OnAssignment, 'OnChosenGoldenPathBlades', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenGoldenPathBladeLines');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Rescue_Soldier_Mission_Blade_A", NAW_OnAssignment, 'OnViewRescueSoldierMission', '', ELD_OnStateSubmitted, NPC_Multiple, 'RescueSoldierMissionBladeLines');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Rescue_Soldier_Mission_Blade_B", NAW_OnAssignment, 'OnViewRescueSoldierMission', '', ELD_OnStateSubmitted, NPC_Multiple, 'RescueSoldierMissionBladeLines');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Rescue_Soldier_Mission_Blade_C", NAW_OnAssignment, 'OnViewRescueSoldierMission', '', ELD_OnStateSubmitted, NPC_Multiple, 'RescueSoldierMissionBladeLines');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Chosen_Avenger_Mission_Blade_A", NAW_OnAssignment, 'OnViewAvengerAssaultMission', '', ELD_OnStateSubmitted, NPC_Multiple, 'AvengerAssaultMissionBladeLines');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Chosen_Avenger_Mission_Blade_B", NAW_OnAssignment, 'OnViewAvengerAssaultMission', '', ELD_OnStateSubmitted, NPC_Multiple, 'AvengerAssaultMissionBladeLines');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Chosen_Avenger_Mission_Blade_C", NAW_OnAssignment, 'OnViewAvengerAssaultMission', '', ELD_OnStateSubmitted, NPC_Multiple, 'AvengerAssaultMissionBladeLines');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Stronghold_Revealed_Mission_Blade_A", NAW_OnAssignment, 'ChosenStrongholdAvailable', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralChosenStrongholdAvailable');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Stronghold_Revealed_Mission_Blade_B", NAW_OnAssignment, 'ChosenStrongholdAvailable', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralChosenStrongholdAvailable');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Stronghold_Revealed_Mission_Blade_C", NAW_OnAssignment, 'ChosenStrongholdAvailable', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralChosenStrongholdAvailable');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Stronghold_Available_A", NAW_OnAssignment, 'OnViewChosenStrongholdMission', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenStrongholdMissionBladeLines');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Stronghold_Available_B", NAW_OnAssignment, 'OnViewChosenStrongholdMission', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenStrongholdMissionBladeLines');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Stronghold_Available_C", NAW_OnAssignment, 'OnViewChosenStrongholdMission', '', ELD_OnStateSubmitted, NPC_Multiple, 'ChosenStrongholdMissionBladeLines');

	return Template;
}

static function X2DataTemplate CreateCEN_SquadSelectTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'CEN_SquadSelect');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Avenger_Assault_Squad_Select", NAW_OnAssignment, 'OnAvengerAssaultSquadSelect', '', ELD_OnStateSubmitted, NPC_Once, '');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Squad_Size_Limited_A", NAW_OnAssignment, 'OnSizeLimitedSquadSelect', '', ELD_OnStateSubmitted, NPC_Multiple, 'SizeLimitedSquadLines');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Squad_Size_Limited_B", NAW_OnAssignment, 'OnSizeLimitedSquadSelect', '', ELD_OnStateSubmitted, NPC_Multiple, 'SizeLimitedSquadLines');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Squad_Size_Limited_C", NAW_OnAssignment, 'OnSizeLimitedSquadSelect', '', ELD_OnStateSubmitted, NPC_Multiple, 'SizeLimitedSquadLines');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Super_Squad_Size_A", NAW_OnAssignment, 'OnSuperSizeSquadSelect', '', ELD_OnStateSubmitted, NPC_Multiple, 'SuperSizeSquadLines');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Super_Squad_Size_B", NAW_OnAssignment, 'OnSuperSizeSquadSelect', '', ELD_OnStateSubmitted, NPC_Multiple, 'SuperSizeSquadLines');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Super_Squad_Size_C", NAW_OnAssignment, 'OnSuperSizeSquadSelect', '', ELD_OnStateSubmitted, NPC_Multiple, 'SuperSizeSquadLines');
	
	return Template;
}

static function X2DataTemplate CreateCEN_ToDoWarningsTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'CEN_ToDoWarnings');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	// No Ring constructed
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Nag_Build_Ring_A", NAW_OnAssignment, 'WarningNoRing', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralBuildRingNags');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Nag_Build_Ring_B", NAW_OnAssignment, 'WarningNoRing', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralBuildRingNags');

	// No Covert Action running
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_CEN_S_Nag_Covert_Action_Available", NAW_OnAssignment, 'WarningNoCovertAction', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralCovertActionNags');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Ring_Not_Used_Nag_A", NAW_OnAssignment, 'WarningNoCovertAction', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralCovertActionNags');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Ring_Not_Used_Nag_B", NAW_OnAssignment, 'WarningNoCovertAction', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralCovertActionNags');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Ring_Not_Used_Nag_C", NAW_OnAssignment, 'WarningNoCovertAction', '', ELD_OnStateSubmitted, NPC_Multiple, 'CentralCovertActionNags');
	
	return Template;
}

// #######################################################################################
// ---------------------------------- FACTION LEADERS ------------------------------------
// #######################################################################################

static function X2DataTemplate CreateFL_FactionMetTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'FL_FactionMet');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	// Met Faction
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Faction_Encountered", NAW_OnAssignment, 'MetFaction_Reapers', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Faction_Encountered", NAW_OnAssignment, 'MetFaction_Skirmishers', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Faction_Encountered", NAW_OnAssignment, 'MetFaction_Templars', '', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}

static function X2DataTemplate CreateFL_FactionInfluenceTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'FL_FactionInfluence');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	
	// Medium Influence
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Influence_Gained_MED_A", NAW_OnAssignment, 'InfluenceIncreased_Med_Reapers', '', ELD_OnStateSubmitted, NPC_Once, '', 'ReaperMedInfluence');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Influence_Gained_MED_B", NAW_OnAssignment, 'InfluenceIncreased_Med_Reapers', '', ELD_OnStateSubmitted, NPC_Once, '', 'ReaperMedInfluence');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Influence_Gained_MED_C", NAW_OnAssignment, 'InfluenceIncreased_Med_Reapers', '', ELD_OnStateSubmitted, NPC_Once, '', 'ReaperMedInfluence');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Influence_Gained_MED_A", NAW_OnAssignment, 'InfluenceIncreased_Med_Skirmishers', '', ELD_OnStateSubmitted, NPC_Once, '', 'SkirmisherMedInfluence');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Influence_Gained_MED_B", NAW_OnAssignment, 'InfluenceIncreased_Med_Skirmishers', '', ELD_OnStateSubmitted, NPC_Once, '', 'SkirmisherMedInfluence');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Influence_Gained_MED_C", NAW_OnAssignment, 'InfluenceIncreased_Med_Skirmishers', '', ELD_OnStateSubmitted, NPC_Once, '', 'SkirmisherMedInfluence');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Influence_Gained_MED_A", NAW_OnAssignment, 'InfluenceIncreased_Med_Templars', '', ELD_OnStateSubmitted, NPC_Once, '', 'TemplarMedInfluence');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Influence_Gained_MED_B", NAW_OnAssignment, 'InfluenceIncreased_Med_Templars', '', ELD_OnStateSubmitted, NPC_Once, '', 'TemplarMedInfluence');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Influence_Gained_MED_C", NAW_OnAssignment, 'InfluenceIncreased_Med_Templars', '', ELD_OnStateSubmitted, NPC_Once, '', 'TemplarMedInfluence');

	// High Influence
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Influence_Gained_HIGH_A", NAW_OnAssignment, 'InfluenceIncreased_High_Reapers', '', ELD_OnStateSubmitted, NPC_Once, '', 'ReaperHighInfluence');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Influence_Gained_HIGH_B", NAW_OnAssignment, 'InfluenceIncreased_High_Reapers', '', ELD_OnStateSubmitted, NPC_Once, '', 'ReaperHighInfluence');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Influence_Gained_HIGH_C", NAW_OnAssignment, 'InfluenceIncreased_High_Reapers', '', ELD_OnStateSubmitted, NPC_Once, '', 'ReaperHighInfluence');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Influence_Gained_HIGH_A", NAW_OnAssignment, 'InfluenceIncreased_High_Skirmishers', '', ELD_OnStateSubmitted, NPC_Once, '', 'SkirmisherHighInfluence');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Influence_Gained_HIGH_B", NAW_OnAssignment, 'InfluenceIncreased_High_Skirmishers', '', ELD_OnStateSubmitted, NPC_Once, '', 'SkirmisherHighInfluence');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Influence_Gained_HIGH_C", NAW_OnAssignment, 'InfluenceIncreased_High_Skirmishers', '', ELD_OnStateSubmitted, NPC_Once, '', 'SkirmisherHighInfluence');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Influence_Gained_HIGH_A", NAW_OnAssignment, 'InfluenceIncreased_High_Templars', '', ELD_OnStateSubmitted, NPC_Once, '', 'TemplarHighInfluence');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Influence_Gained_HIGH_B", NAW_OnAssignment, 'InfluenceIncreased_High_Templars', '', ELD_OnStateSubmitted, NPC_Once, '', 'TemplarHighInfluence');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Influence_Gained_HIGH_C", NAW_OnAssignment, 'InfluenceIncreased_High_Templars', '', ELD_OnStateSubmitted, NPC_Once, '', 'TemplarHighInfluence');

	return Template;
}

static function X2DataTemplate CreateFL_ResistanceOpsTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'FL_ResistanceOps');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_VLK_S_First_Res_Op_Geoscape", NAW_OnAssignment, 'OnResOpPopup_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperResOpPopup');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Res_Op_Help_Needed_A", NAW_OnAssignment, 'OnResOpPopup_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperResOpPopup');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Res_Op_Help_Needed_B", NAW_OnAssignment, 'OnResOpPopup_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperResOpPopup');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Res_Op_Help_Needed_C", NAW_OnAssignment, 'OnResOpPopup_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperResOpPopup');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Res_Op_Help_Needed_D", NAW_OnAssignment, 'OnResOpPopup_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperResOpPopup');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Res_Op_Help_Needed_E", NAW_OnAssignment, 'OnResOpPopup_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperResOpPopup');
	
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Res_Op_Help_Needed_A", NAW_OnAssignment, 'OnResOpPopup_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherResOpPopup');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Res_Op_Help_Needed_B", NAW_OnAssignment, 'OnResOpPopup_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherResOpPopup');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Res_Op_Help_Needed_C", NAW_OnAssignment, 'OnResOpPopup_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherResOpPopup');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Res_Op_Help_Needed_D", NAW_OnAssignment, 'OnResOpPopup_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherResOpPopup');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Res_Op_Help_Needed_E", NAW_OnAssignment, 'OnResOpPopup_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherResOpPopup');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Res_Op_Help_Needed_A", NAW_OnAssignment, 'OnResOpPopup_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarResOpPopup');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Res_Op_Help_Needed_B", NAW_OnAssignment, 'OnResOpPopup_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarResOpPopup');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Res_Op_Help_Needed_C", NAW_OnAssignment, 'OnResOpPopup_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarResOpPopup');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Res_Op_Help_Needed_D", NAW_OnAssignment, 'OnResOpPopup_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarResOpPopup');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Res_Op_Help_Needed_E", NAW_OnAssignment, 'OnResOpPopup_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarResOpPopup');

	return Template;
}

static function X2DataTemplate CreateFL_AfterActionCommentTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'FL_AfterActionComment');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	
	// These comments play after Resistance Ops missions when viewing the Rewards Recap screen
	// Walkup events are handled in FL_WalkupComment

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_VLK_S_Support_Great_Mission_01", NAW_OnAssignment, 'AfterAction_MissionWon_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'ReaperAfterActionGreatMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Res_Op_Success_A", NAW_OnAssignment, 'AfterAction_MissionWon_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'ReaperAfterActionGreatMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Res_Op_Success_B", NAW_OnAssignment, 'AfterAction_MissionWon_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'ReaperAfterActionGreatMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Res_Op_Success_C", NAW_OnAssignment, 'AfterAction_MissionWon_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'ReaperAfterActionGreatMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Res_Op_Success_D", NAW_OnAssignment, 'AfterAction_MissionWon_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'ReaperAfterActionGreatMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Res_Op_Success_E", NAW_OnAssignment, 'AfterAction_MissionWon_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'ReaperAfterActionGreatMission');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_VLK_S_Support_Tough_Mission_01", NAW_OnAssignment, 'AfterAction_MissionLost_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'ReaperAfterActionToughMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Res_Op_Failure_A", NAW_OnAssignment, 'AfterAction_MissionLost_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'ReaperAfterActionToughMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Res_Op_Failure_B", NAW_OnAssignment, 'AfterAction_MissionLost_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'ReaperAfterActionToughMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Res_Op_Failure_C", NAW_OnAssignment, 'AfterAction_MissionLost_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'ReaperAfterActionToughMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Res_Op_Failure_D", NAW_OnAssignment, 'AfterAction_MissionLost_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'ReaperAfterActionToughMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Res_Op_Failure_E", NAW_OnAssignment, 'AfterAction_MissionLost_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'ReaperAfterActionToughMission');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_BET_S_Support_Great_Mission_01", NAW_OnAssignment, 'AfterAction_MissionWon_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'SkirmisherAfterActionGreatMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Res_Op_Success_A", NAW_OnAssignment, 'AfterAction_MissionWon_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'SkirmisherAfterActionGreatMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Res_Op_Success_B", NAW_OnAssignment, 'AfterAction_MissionWon_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'SkirmisherAfterActionGreatMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Res_Op_Success_C", NAW_OnAssignment, 'AfterAction_MissionWon_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'SkirmisherAfterActionGreatMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Res_Op_Success_D", NAW_OnAssignment, 'AfterAction_MissionWon_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'SkirmisherAfterActionGreatMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Res_Op_Success_E", NAW_OnAssignment, 'AfterAction_MissionWon_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'SkirmisherAfterActionGreatMission');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_BET_S_Support_Tough_Mission_01", NAW_OnAssignment, 'AfterAction_MissionLost_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'SkirmisherAfterActionToughMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Res_Op_Failure_A", NAW_OnAssignment, 'AfterAction_MissionLost_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'SkirmisherAfterActionToughMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Res_Op_Failure_B", NAW_OnAssignment, 'AfterAction_MissionLost_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'SkirmisherAfterActionToughMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Res_Op_Failure_C", NAW_OnAssignment, 'AfterAction_MissionLost_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'SkirmisherAfterActionToughMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Res_Op_Failure_D", NAW_OnAssignment, 'AfterAction_MissionLost_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'SkirmisherAfterActionToughMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Res_Op_Failure_E", NAW_OnAssignment, 'AfterAction_MissionLost_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'SkirmisherAfterActionToughMission');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_KAL_S_Support_Great_Mission_01", NAW_OnAssignment, 'AfterAction_MissionWon_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'TemplarAfterActionGreatMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Res_Op_Success_A", NAW_OnAssignment, 'AfterAction_MissionWon_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'TemplarAfterActionGreatMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Res_Op_Success_B", NAW_OnAssignment, 'AfterAction_MissionWon_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'TemplarAfterActionGreatMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Res_Op_Success_C", NAW_OnAssignment, 'AfterAction_MissionWon_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'TemplarAfterActionGreatMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Res_Op_Success_D", NAW_OnAssignment, 'AfterAction_MissionWon_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'TemplarAfterActionGreatMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Res_Op_Success_E", NAW_OnAssignment, 'AfterAction_MissionWon_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'TemplarAfterActionGreatMission');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_KAL_S_Support_Tough_Mission_01", NAW_OnAssignment, 'AfterAction_MissionLost_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'TemplarAfterActionToughMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Res_Op_Failure_A", NAW_OnAssignment, 'AfterAction_MissionLost_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'TemplarAfterActionToughMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Res_Op_Failure_B", NAW_OnAssignment, 'AfterAction_MissionLost_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'TemplarAfterActionToughMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Res_Op_Failure_C", NAW_OnAssignment, 'AfterAction_MissionLost_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'TemplarAfterActionToughMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Res_Op_Failure_D", NAW_OnAssignment, 'AfterAction_MissionLost_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'TemplarAfterActionToughMission');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Res_Op_Failure_E", NAW_OnAssignment, 'AfterAction_MissionLost_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, '', 'TemplarAfterActionToughMission');

	return Template;
}

static function X2DataTemplate CreateFL_WalkupCommentTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'FL_WalkupComment');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	// These comments play after Resistance Ops missions during the soldier After Action walk up
	// Reward recap screen events are handled in FL_AfterActionComment

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Walkup_Chosen_Killed", NAW_OnAssignment, 'AfterAction_ChosenDefeated_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Walkup_Faction_Only", NAW_OnAssignment, 'AfterAction_HeroOnMission_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Walkup_Hero_Killed", NAW_OnAssignment, 'AfterAction_HeroKilled_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Walkup_Chosen_Fought", NAW_OnAssignment, 'AfterAction_ChosenFought_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Walkup_Win", NAW_OnAssignment, 'AfterAction_GreatMission_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Walkup_Lose", NAW_OnAssignment, 'AfterAction_ToughMission_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Walkup_Hero_Captured", NAW_OnAssignment, 'AfterAction_HeroCaptured_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Walkup_Captured_Soldier_Rescue", NAW_OnAssignment, 'AfterAction_SoldierRescued_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, '');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Walkup_Chosen_Killed", NAW_OnAssignment, 'AfterAction_ChosenDefeated_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Walkup_Faction_Only", NAW_OnAssignment, 'AfterAction_HeroOnMission_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Walkup_Hero_Killed", NAW_OnAssignment, 'AfterAction_HeroKilled_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Walkup_Chosen_Fought", NAW_OnAssignment, 'AfterAction_ChosenFought_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Walkup_Win", NAW_OnAssignment, 'AfterAction_GreatMission_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Walkup_Lose", NAW_OnAssignment, 'AfterAction_ToughMission_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Walkup_Hero_Captured", NAW_OnAssignment, 'AfterAction_HeroCaptured_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Walkup_Captured_Soldier_Rescue", NAW_OnAssignment, 'AfterAction_SoldierRescued_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, '');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Walkup_Faction_Only", NAW_OnAssignment, 'AfterAction_ChosenDefeated_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Walkup_Captured_Soldier_Rescue", NAW_OnAssignment, 'AfterAction_SoldierRescued_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, '');

	return Template;
}

static function X2DataTemplate CreateFL_ResistanceOrdersTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'FL_ResistanceOrders');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	// New order received
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Covert_Action_Order_Gain_A", NAW_OnAssignment, 'NewOrderReceived_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperNewOrderReceived');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Covert_Action_Order_Gain_B", NAW_OnAssignment, 'NewOrderReceived_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperNewOrderReceived');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Covert_Action_Order_Gain_C", NAW_OnAssignment, 'NewOrderReceived_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperNewOrderReceived');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Covert_Action_Order_Gain_A", NAW_OnAssignment, 'NewOrderReceived_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherNewOrderReceived');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Covert_Action_Order_Gain_B", NAW_OnAssignment, 'NewOrderReceived_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherNewOrderReceived');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Covert_Action_Order_Gain_C", NAW_OnAssignment, 'NewOrderReceived_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherNewOrderReceived');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Covert_Action_Order_Gain_A", NAW_OnAssignment, 'NewOrderReceived_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarNewOrderReceived');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Covert_Action_Order_Gain_B", NAW_OnAssignment, 'NewOrderReceived_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarNewOrderReceived');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Covert_Action_Order_Gain_C", NAW_OnAssignment, 'NewOrderReceived_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarNewOrderReceived');

	// First slot unlocked
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_First_Order_Screen", NAW_OnAssignment, 'FirstOrderSlot_Reapers', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_First_Order_Screen", NAW_OnAssignment, 'FirstOrderSlot_Skirmishers', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_First_Order_Screen", NAW_OnAssignment, 'FirstOrderSlot_Templars', '', ELD_OnStateSubmitted, NPC_Once, '');

	// Second slot unlocked
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_First_Order_Screen_Slot_Open", NAW_OnAssignment, 'SecondOrderSlot_Reapers', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_First_Order_Screen_Slot_Open", NAW_OnAssignment, 'SecondOrderSlot_Skirmishers', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_First_Order_Screen_Slot_Open", NAW_OnAssignment, 'SecondOrderSlot_Templars', '', ELD_OnStateSubmitted, NPC_Once, '');

	// Confirm new orders
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_VLK_S_Generic_Confirmation_A", NAW_OnAssignment, 'ConfirmPolicies_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperConfirmResOrder');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Res_Order_Confirm_A", NAW_OnAssignment, 'ConfirmPolicies_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperConfirmResOrder');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Res_Order_Confirm_B", NAW_OnAssignment, 'ConfirmPolicies_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperConfirmResOrder');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Res_Order_Confirm_C", NAW_OnAssignment, 'ConfirmPolicies_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperConfirmResOrder');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Res_Order_Confirm_D", NAW_OnAssignment, 'ConfirmPolicies_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperConfirmResOrder');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Res_Order_Confirm_E", NAW_OnAssignment, 'ConfirmPolicies_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperConfirmResOrder');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_BET_S_Generic_Confirmation_A", NAW_OnAssignment, 'ConfirmPolicies_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherConfirmResOrder');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Res_Order_Confirm_A", NAW_OnAssignment, 'ConfirmPolicies_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherConfirmResOrder');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Res_Order_Confirm_B", NAW_OnAssignment, 'ConfirmPolicies_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherConfirmResOrder');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Res_Order_Confirm_C", NAW_OnAssignment, 'ConfirmPolicies_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherConfirmResOrder');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Res_Order_Confirm_D", NAW_OnAssignment, 'ConfirmPolicies_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherConfirmResOrder');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Res_Order_Confirm_E", NAW_OnAssignment, 'ConfirmPolicies_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherConfirmResOrder');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_KAL_S_Generic_Confirmation_A", NAW_OnAssignment, 'ConfirmPolicies_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarConfirmResOrder');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Res_Order_Confirm_A", NAW_OnAssignment, 'ConfirmPolicies_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarConfirmResOrder');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Res_Order_Confirm_B", NAW_OnAssignment, 'ConfirmPolicies_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarConfirmResOrder');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Res_Order_Confirm_C", NAW_OnAssignment, 'ConfirmPolicies_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarConfirmResOrder');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Res_Order_Confirm_D", NAW_OnAssignment, 'ConfirmPolicies_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarConfirmResOrder');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Res_Order_Confirm_E", NAW_OnAssignment, 'ConfirmPolicies_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarConfirmResOrder');

	return Template;
}

static function X2DataTemplate CreateFL_CovertActionsTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'FL_CovertActions');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	// New Covert Actions Available
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_New_Covert_Actions_Available_A", NAW_OnAssignment, 'NewCovertActionsAvailable_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperNewActionsAvailable');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_New_Covert_Actions_Available_B", NAW_OnAssignment, 'NewCovertActionsAvailable_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperNewActionsAvailable');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_New_Covert_Actions_Available_C", NAW_OnAssignment, 'NewCovertActionsAvailable_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperNewActionsAvailable');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_New_Covert_Actions_Available_A", NAW_OnAssignment, 'NewCovertActionsAvailable_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherNewActionsAvailable');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_New_Covert_Actions_Available_B", NAW_OnAssignment, 'NewCovertActionsAvailable_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherNewActionsAvailable');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_New_Covert_Actions_Available_C", NAW_OnAssignment, 'NewCovertActionsAvailable_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherNewActionsAvailable');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_New_Covert_Actions_Available_A", NAW_OnAssignment, 'NewCovertActionsAvailable_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarNewActionsAvailable');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_New_Covert_Actions_Available_B", NAW_OnAssignment, 'NewCovertActionsAvailable_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarNewActionsAvailable');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_New_Covert_Actions_Available_C", NAW_OnAssignment, 'NewCovertActionsAvailable_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarNewActionsAvailable');

	// Confirm Covert Action
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Confirm_Covert_Action_A", NAW_OnAssignment, 'ConfirmCovertAction_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperConfirmCovertAction');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Confirm_Covert_Action_B", NAW_OnAssignment, 'ConfirmCovertAction_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperConfirmCovertAction');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Confirm_Covert_Action_C", NAW_OnAssignment, 'ConfirmCovertAction_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperConfirmCovertAction');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Confirm_Covert_Action_A", NAW_OnAssignment, 'ConfirmCovertAction_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherConfirmCovertAction');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Confirm_Covert_Action_B", NAW_OnAssignment, 'ConfirmCovertAction_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherConfirmCovertAction');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Confirm_Covert_Action_C", NAW_OnAssignment, 'ConfirmCovertAction_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherConfirmCovertAction');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Confirm_Covert_Action_A", NAW_OnAssignment, 'ConfirmCovertAction_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarConfirmCovertAction');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Confirm_Covert_Action_B", NAW_OnAssignment, 'ConfirmCovertAction_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarConfirmCovertAction');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Confirm_Covert_Action_C", NAW_OnAssignment, 'ConfirmCovertAction_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarConfirmCovertAction');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Covert_Action_Ambushed_A", NAW_OnAssignment, 'CovertActionAmbush_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperCovertActionAmbushed');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Covert_Action_Ambushed_B", NAW_OnAssignment, 'CovertActionAmbush_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperCovertActionAmbushed');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Covert_Action_Ambushed_C", NAW_OnAssignment, 'CovertActionAmbush_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperCovertActionAmbushed');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Covert_Action_Ambushed_A", NAW_OnAssignment, 'CovertActionAmbush_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherCovertActionAmbushed');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Covert_Action_Ambushed_B", NAW_OnAssignment, 'CovertActionAmbush_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherCovertActionAmbushed');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Covert_Action_Ambushed_C", NAW_OnAssignment, 'CovertActionAmbush_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherCovertActionAmbushed');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Covert_Action_Ambushed_A", NAW_OnAssignment, 'CovertActionAmbush_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarCovertActionAmbushed');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Covert_Action_Ambushed_B", NAW_OnAssignment, 'CovertActionAmbush_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarCovertActionAmbushed');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Covert_Action_Ambushed_C", NAW_OnAssignment, 'CovertActionAmbush_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarCovertActionAmbushed');

	// Covert Action Completed
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Covert_Action_Complete_A", NAW_OnAssignment, 'CovertActionCompleted_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperCovertActionComplete');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Covert_Action_Complete_B", NAW_OnAssignment, 'CovertActionCompleted_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperCovertActionComplete');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Covert_Action_Complete_C", NAW_OnAssignment, 'CovertActionCompleted_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperCovertActionComplete');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Covert_Action_Complete_A", NAW_OnAssignment, 'CovertActionCompleted_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherCovertActionComplete');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Covert_Action_Complete_B", NAW_OnAssignment, 'CovertActionCompleted_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherCovertActionComplete');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Covert_Action_Complete_C", NAW_OnAssignment, 'CovertActionCompleted_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherCovertActionComplete');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Covert_Action_Complete_A", NAW_OnAssignment, 'CovertActionCompleted_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarCovertActionComplete');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Covert_Action_Complete_B", NAW_OnAssignment, 'CovertActionCompleted_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarCovertActionComplete');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Covert_Action_Complete_C", NAW_OnAssignment, 'CovertActionCompleted_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarCovertActionComplete');

	// New Faction Soldier Reward
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Covert_Action_Hero_Grant_A", NAW_OnAssignment, 'NewFactionSoldier_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperNewFactionSoldier');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Covert_Action_Hero_Grant_B", NAW_OnAssignment, 'NewFactionSoldier_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperNewFactionSoldier');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Covert_Action_Hero_Grant_C", NAW_OnAssignment, 'NewFactionSoldier_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperNewFactionSoldier');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Covert_Action_Hero_Grant_A", NAW_OnAssignment, 'NewFactionSoldier_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherNewFactionSoldier');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Covert_Action_Hero_Grant_B", NAW_OnAssignment, 'NewFactionSoldier_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherNewFactionSoldier');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Covert_Action_Hero_Grant_C", NAW_OnAssignment, 'NewFactionSoldier_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherNewFactionSoldier');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Covert_Action_Hero_Grant_A", NAW_OnAssignment, 'NewFactionSoldier_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarNewFactionSoldier');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Covert_Action_Hero_Grant_B", NAW_OnAssignment, 'NewFactionSoldier_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarNewFactionSoldier');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Covert_Action_Hero_Grant_C", NAW_OnAssignment, 'NewFactionSoldier_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarNewFactionSoldier');

	// Chosen Fragment Recovered
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Covert_Action_Fragment_Gain_A", NAW_OnAssignment, 'ChosenFragmentRecovered_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperChosenFragmentRecovered');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Covert_Action_Fragment_Gain_B", NAW_OnAssignment, 'ChosenFragmentRecovered_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperChosenFragmentRecovered');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Covert_Action_Fragment_Gain_C", NAW_OnAssignment, 'ChosenFragmentRecovered_Reapers', '', ELD_OnStateSubmitted, NPC_Multiple, 'ReaperChosenFragmentRecovered');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Covert_Action_Fragment_Gain_A", NAW_OnAssignment, 'ChosenFragmentRecovered_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherChosenFragmentRecovered');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Covert_Action_Fragment_Gain_B", NAW_OnAssignment, 'ChosenFragmentRecovered_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherChosenFragmentRecovered');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Covert_Action_Fragment_Gain_C", NAW_OnAssignment, 'ChosenFragmentRecovered_Skirmishers', '', ELD_OnStateSubmitted, NPC_Multiple, 'SkirmisherChosenFragmentRecovered');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Covert_Action_Fragment_Gain_A", NAW_OnAssignment, 'ChosenFragmentRecovered_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarChosenFragmentRecovered');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Covert_Action_Fragment_Gain_B", NAW_OnAssignment, 'ChosenFragmentRecovered_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarChosenFragmentRecovered');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Covert_Action_Fragment_Gain_C", NAW_OnAssignment, 'ChosenFragmentRecovered_Templars', '', ELD_OnStateSubmitted, NPC_Multiple, 'TemplarChosenFragmentRecovered');
	
	return Template;
}

// #######################################################################################
// ----------------------------------- CHOSEN --------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateCH_ChosenMetTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'CH_ChosenMet');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Enter_Chosen_Territory", NAW_OnAssignment, 'ChosenMet_Assassin', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Enter_Chosen_Territory", NAW_OnAssignment, 'ChosenMet_Hunter', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Enter_Chosen_Territory", NAW_OnAssignment, 'ChosenMet_Warlock', '', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}

static function X2DataTemplate CreateCH_RetributionTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'CH_Retribution');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Retaliation_Complete_A", NAW_OnAssignment, 'Retribution_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinRetribution');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Retaliation_Complete_B", NAW_OnAssignment, 'Retribution_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinRetribution');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Retaliation_Complete_C", NAW_OnAssignment, 'Retribution_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinRetribution');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Retaliation_Complete_D", NAW_OnAssignment, 'Retribution_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinRetribution');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Retaliation_Complete_E", NAW_OnAssignment, 'Retribution_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinRetribution');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Assaulting_Bastion_First", NAW_OnAssignment, 'Retribution_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinRetribution');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Assaulting_Bastion_Subs_A", NAW_OnAssignment, 'Retribution_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinRetribution');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Assaulting_Bastion_Subs_B", NAW_OnAssignment, 'Retribution_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinRetribution');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Retaliation_Complete_A", NAW_OnAssignment, 'Retribution_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterRetribution');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Retaliation_Complete_B", NAW_OnAssignment, 'Retribution_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterRetribution');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Retaliation_Complete_C", NAW_OnAssignment, 'Retribution_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterRetribution');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Retaliation_Complete_D", NAW_OnAssignment, 'Retribution_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterRetribution');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Retaliation_Complete_E", NAW_OnAssignment, 'Retribution_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterRetribution');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Assaulting_Bastion_First", NAW_OnAssignment, 'Retribution_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterRetribution');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Assaulting_Bastion_Subs_A", NAW_OnAssignment, 'Retribution_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterRetribution');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Assaulting_Bastion_Subs_B", NAW_OnAssignment, 'Retribution_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterRetribution');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Retaliation_Complete_A", NAW_OnAssignment, 'Retribution_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockRetribution');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Retaliation_Complete_B", NAW_OnAssignment, 'Retribution_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockRetribution');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Retaliation_Complete_C", NAW_OnAssignment, 'Retribution_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockRetribution');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Retaliation_Complete_D", NAW_OnAssignment, 'Retribution_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockRetribution');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Retaliation_Complete_E", NAW_OnAssignment, 'Retribution_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockRetribution');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Assaulting_Bastion_First", NAW_OnAssignment, 'Retribution_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockRetribution');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Assaulting_Bastion_Subs_A", NAW_OnAssignment, 'Retribution_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockRetribution');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Assaulting_Bastion_Subs_B", NAW_OnAssignment, 'Retribution_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockRetribution');

	return Template;
}

static function X2DataTemplate CreateCH_SabotageTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'CH_Sabotage');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Sabotage_Success_A", NAW_OnAssignment, 'SabotageSuccess_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinSabotageSuccess');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Sabotage_Success_B", NAW_OnAssignment, 'SabotageSuccess_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinSabotageSuccess');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Sabotage_Success_C", NAW_OnAssignment, 'SabotageSuccess_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinSabotageSuccess');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Sabotage_Success_D", NAW_OnAssignment, 'SabotageSuccess_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinSabotageSuccess');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Sabotage_Success_E", NAW_OnAssignment, 'SabotageSuccess_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinSabotageSuccess');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Sabotage_Success_A", NAW_OnAssignment, 'SabotageSuccess_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterSabotageSuccess');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Sabotage_Success_B", NAW_OnAssignment, 'SabotageSuccess_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterSabotageSuccess');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Sabotage_Success_C", NAW_OnAssignment, 'SabotageSuccess_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterSabotageSuccess');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Sabotage_Success_D", NAW_OnAssignment, 'SabotageSuccess_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterSabotageSuccess');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Sabotage_Success_E", NAW_OnAssignment, 'SabotageSuccess_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterSabotageSuccess');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Sabotage_Success_A", NAW_OnAssignment, 'SabotageSuccess_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockSabotageSuccess');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Sabotage_Success_B", NAW_OnAssignment, 'SabotageSuccess_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockSabotageSuccess');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Sabotage_Success_C", NAW_OnAssignment, 'SabotageSuccess_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockSabotageSuccess');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Sabotage_Success_D", NAW_OnAssignment, 'SabotageSuccess_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockSabotageSuccess');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Sabotage_Success_E", NAW_OnAssignment, 'SabotageSuccess_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockSabotageSuccess');


	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Sabotage_Failed_A", NAW_OnAssignment, 'SabotageFailed_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinSabotageFailed');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Sabotage_Failed_B", NAW_OnAssignment, 'SabotageFailed_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinSabotageFailed');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Sabotage_Failed_C", NAW_OnAssignment, 'SabotageFailed_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinSabotageFailed');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Sabotage_Failed_D", NAW_OnAssignment, 'SabotageFailed_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinSabotageFailed');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Sabotage_Failed_E", NAW_OnAssignment, 'SabotageFailed_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinSabotageFailed');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Sabotage_Failed_A", NAW_OnAssignment, 'SabotageFailed_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterSabotageFailed');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Sabotage_Failed_B", NAW_OnAssignment, 'SabotageFailed_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterSabotageFailed');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Sabotage_Failed_C", NAW_OnAssignment, 'SabotageFailed_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterSabotageFailed');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Sabotage_Failed_D", NAW_OnAssignment, 'SabotageFailed_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterSabotageFailed');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Sabotage_Failed_E", NAW_OnAssignment, 'SabotageFailed_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterSabotageFailed');
	
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Sabotage_Failed_A", NAW_OnAssignment, 'SabotageFailed_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockSabotageFailed');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Sabotage_Failed_B", NAW_OnAssignment, 'SabotageFailed_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockSabotageFailed');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Sabotage_Failed_C", NAW_OnAssignment, 'SabotageFailed_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockSabotageFailed');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Sabotage_Failed_D", NAW_OnAssignment, 'SabotageFailed_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockSabotageFailed');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Sabotage_Failed_E", NAW_OnAssignment, 'SabotageFailed_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockSabotageFailed');

	return Template;
}

static function X2DataTemplate CreateCH_SoldierCapturedTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'CH_SoldierCaptured');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Soldier_Captured_A", NAW_OnAssignment, 'SoldierCaptured_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Soldier_Captured_B", NAW_OnAssignment, 'SoldierCaptured_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Soldier_Captured_C", NAW_OnAssignment, 'SoldierCaptured_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Soldier_Captured_D", NAW_OnAssignment, 'SoldierCaptured_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Soldier_Captured_E", NAW_OnAssignment, 'SoldierCaptured_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Soldier_Captured_Post_Covert_A", NAW_OnAssignment, 'SoldierCaptured_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Soldier_Captured_Post_Covert_B", NAW_OnAssignment, 'SoldierCaptured_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Photo_Booth_Taunt_Thres_Change_A", NAW_OnAssignment, 'SoldierCaptured_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Photo_Booth_Taunt_Thres_Change_B", NAW_OnAssignment, 'SoldierCaptured_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Photo_Booth_Taunt_Thres_Change_C", NAW_OnAssignment, 'SoldierCaptured_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinSoldierCaptured');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Soldier_Captured_A", NAW_OnAssignment, 'SoldierCaptured_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Soldier_Captured_B", NAW_OnAssignment, 'SoldierCaptured_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Soldier_Captured_C", NAW_OnAssignment, 'SoldierCaptured_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Soldier_Captured_D", NAW_OnAssignment, 'SoldierCaptured_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Soldier_Captured_E", NAW_OnAssignment, 'SoldierCaptured_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Soldier_Captured_Post_Covert_A", NAW_OnAssignment, 'SoldierCaptured_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Soldier_Captured_Post_Covert_B", NAW_OnAssignment, 'SoldierCaptured_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Photo_Booth_Taunt_Thres_Change_A", NAW_OnAssignment, 'SoldierCaptured_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Photo_Booth_Taunt_Thres_Change_B", NAW_OnAssignment, 'SoldierCaptured_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Photo_Booth_Taunt_Thres_Change_C", NAW_OnAssignment, 'SoldierCaptured_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterSoldierCaptured');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Soldier_Captured_A", NAW_OnAssignment, 'SoldierCaptured_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Soldier_Captured_B", NAW_OnAssignment, 'SoldierCaptured_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Soldier_Captured_C", NAW_OnAssignment, 'SoldierCaptured_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Soldier_Captured_D", NAW_OnAssignment, 'SoldierCaptured_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Soldier_Captured_E", NAW_OnAssignment, 'SoldierCaptured_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Soldier_Captured_Post_Covert_A", NAW_OnAssignment, 'SoldierCaptured_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Soldier_Captured_Post_Covert_B", NAW_OnAssignment, 'SoldierCaptured_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockSoldierCaptured');	
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Photo_Booth_Taunt_Thres_Change_A", NAW_OnAssignment, 'SoldierCaptured_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Photo_Booth_Taunt_Thres_Change_B", NAW_OnAssignment, 'SoldierCaptured_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockSoldierCaptured');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Photo_Booth_Taunt_Thres_Change_C", NAW_OnAssignment, 'SoldierCaptured_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockSoldierCaptured');

	return Template;
}

static function X2DataTemplate CreateCH_SoldierRescuedTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'CH_SoldierRescued');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Soldier_Rescued_A", NAW_OnAssignment, 'SoldierRescued_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinSoldierRescued');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Soldier_Rescued_B", NAW_OnAssignment, 'SoldierRescued_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinSoldierRescued');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Soldier_Rescued_C", NAW_OnAssignment, 'SoldierRescued_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinSoldierRescued');
	
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Soldier_Rescued_A", NAW_OnAssignment, 'SoldierRescued_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterSoldierRescued');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Soldier_Rescued_B", NAW_OnAssignment, 'SoldierRescued_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterSoldierRescued');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Soldier_Rescued_C", NAW_OnAssignment, 'SoldierRescued_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterSoldierRescued');
	
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Soldier_Rescued_A", NAW_OnAssignment, 'SoldierRescued_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockSoldierRescued');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Soldier_Rescued_B", NAW_OnAssignment, 'SoldierRescued_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockSoldierRescued');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Soldier_Rescued_C", NAW_OnAssignment, 'SoldierRescued_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockSoldierRescued');
	
	return Template;
}

static function X2DataTemplate CreateCH_DarkEventCompleteTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'CH_DarkEventComplete');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Dark_Event_Complete_A", NAW_OnAssignment, 'DarkEventComplete_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinDarkEventComplete');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Dark_Event_Complete_B", NAW_OnAssignment, 'DarkEventComplete_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinDarkEventComplete');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Dark_Event_Complete_C", NAW_OnAssignment, 'DarkEventComplete_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinDarkEventComplete');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Dark_Event_Complete_D", NAW_OnAssignment, 'DarkEventComplete_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinDarkEventComplete');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Dark_Event_Complete_E", NAW_OnAssignment, 'DarkEventComplete_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinDarkEventComplete');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Dark_Event_Complete_A", NAW_OnAssignment, 'DarkEventComplete_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterDarkEventComplete');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Dark_Event_Complete_B", NAW_OnAssignment, 'DarkEventComplete_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterDarkEventComplete');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Dark_Event_Complete_C", NAW_OnAssignment, 'DarkEventComplete_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterDarkEventComplete');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Dark_Event_Complete_D", NAW_OnAssignment, 'DarkEventComplete_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterDarkEventComplete');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Dark_Event_Complete_E", NAW_OnAssignment, 'DarkEventComplete_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterDarkEventComplete');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Dark_Event_Complete_A", NAW_OnAssignment, 'DarkEventComplete_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockDarkEventComplete');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Dark_Event_Complete_B", NAW_OnAssignment, 'DarkEventComplete_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockDarkEventComplete');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Dark_Event_Complete_C", NAW_OnAssignment, 'DarkEventComplete_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockDarkEventComplete');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Dark_Event_Complete_D", NAW_OnAssignment, 'DarkEventComplete_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockDarkEventComplete');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Dark_Event_Complete_E", NAW_OnAssignment, 'DarkEventComplete_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockDarkEventComplete');

	return Template;
}

static function X2DataTemplate CreateCH_RetaliationTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'CH_Retaliation');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Retaliation_Blade_A", NAW_OnAssignment, 'Retaliation_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinRetaliation');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Retaliation_Blade_B", NAW_OnAssignment, 'Retaliation_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinRetaliation');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Retaliation_Blade_C", NAW_OnAssignment, 'Retaliation_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinRetaliation');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Retaliation_Blade_D", NAW_OnAssignment, 'Retaliation_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinRetaliation');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Retaliation_Blade_E", NAW_OnAssignment, 'Retaliation_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinRetaliation');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Retaliation_Blade_A", NAW_OnAssignment, 'Retaliation_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterRetaliation');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Retaliation_Blade_B", NAW_OnAssignment, 'Retaliation_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterRetaliation');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Retaliation_Blade_C", NAW_OnAssignment, 'Retaliation_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterRetaliation');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Retaliation_Blade_D", NAW_OnAssignment, 'Retaliation_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterRetaliation');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Retaliation_Blade_E", NAW_OnAssignment, 'Retaliation_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterRetaliation');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Retaliation_Blade_A", NAW_OnAssignment, 'Retaliation_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockRetaliation');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Retaliation_Blade_B", NAW_OnAssignment, 'Retaliation_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockRetaliation');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Retaliation_Blade_C", NAW_OnAssignment, 'Retaliation_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockRetaliation');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Retaliation_Blade_D", NAW_OnAssignment, 'Retaliation_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockRetaliation');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Retaliation_Blade_E", NAW_OnAssignment, 'Retaliation_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockRetaliation');

	return Template;
}

static function X2DataTemplate CreateCH_ThresholdChangesTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'CH_ThresholdChanges');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Threshold_Taunts_Level_Two_A", NAW_OnAssignment, 'ThresholdTwo_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinThresholdTwo');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Threshold_Taunts_Level_Two_B", NAW_OnAssignment, 'ThresholdTwo_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinThresholdTwo');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Threshold_Taunts_Level_Two_C", NAW_OnAssignment, 'ThresholdTwo_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinThresholdTwo');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Threshold_Taunts_Level_Three_A", NAW_OnAssignment, 'ThresholdThree_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinThresholdThree');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Threshold_Taunts_Level_Three_B", NAW_OnAssignment, 'ThresholdThree_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinThresholdThree');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Threshold_Taunts_Level_Three_C", NAW_OnAssignment, 'ThresholdThree_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinThresholdThree');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Threshold_Taunts_Level_Four_A", NAW_OnAssignment, 'ThresholdFour_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinThresholdFour');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Threshold_Taunts_Level_Four_B", NAW_OnAssignment, 'ThresholdFour_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinThresholdFour');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Threshold_Taunts_Level_Four_C", NAW_OnAssignment, 'ThresholdFour_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, 'AssassinThresholdFour');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Threshold_Taunts_Level_Two_A", NAW_OnAssignment, 'ThresholdTwo_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterThresholdTwo');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Threshold_Taunts_Level_Two_B", NAW_OnAssignment, 'ThresholdTwo_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterThresholdTwo');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Threshold_Taunts_Level_Two_C", NAW_OnAssignment, 'ThresholdTwo_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterThresholdTwo');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Threshold_Taunts_Level_Three_A", NAW_OnAssignment, 'ThresholdThree_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterThresholdThree');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Threshold_Taunts_Level_Three_B", NAW_OnAssignment, 'ThresholdThree_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterThresholdThree');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Threshold_Taunts_Level_Three_C", NAW_OnAssignment, 'ThresholdThree_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterThresholdThree');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Threshold_Taunts_Level_Four_A", NAW_OnAssignment, 'ThresholdFour_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterThresholdFour');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Threshold_Taunts_Level_Four_B", NAW_OnAssignment, 'ThresholdFour_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterThresholdFour');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Threshold_Taunts_Level_Four_C", NAW_OnAssignment, 'ThresholdFour_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, 'HunterThresholdFour');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Threshold_Taunts_Level_Two_A", NAW_OnAssignment, 'ThresholdTwo_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockThresholdTwo');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Threshold_Taunts_Level_Two_B", NAW_OnAssignment, 'ThresholdTwo_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockThresholdTwo');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Threshold_Taunts_Level_Two_C", NAW_OnAssignment, 'ThresholdTwo_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockThresholdTwo');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Threshold_Taunts_Level_Three_A", NAW_OnAssignment, 'ThresholdThree_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockThresholdThree');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Threshold_Taunts_Level_Three_B", NAW_OnAssignment, 'ThresholdThree_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockThresholdThree');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Threshold_Taunts_Level_Three_C", NAW_OnAssignment, 'ThresholdThree_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockThresholdThree');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Threshold_Taunts_Level_Four_A", NAW_OnAssignment, 'ThresholdFour_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockThresholdFour');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Threshold_Taunts_Level_Four_B", NAW_OnAssignment, 'ThresholdFour_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockThresholdFour');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Threshold_Taunts_Level_Four_C", NAW_OnAssignment, 'ThresholdFour_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, 'WarlockThresholdFour');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Chosen_Leveled_Up", NAW_OnAssignment, 'LeveledUp_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Chosen_Leveled_Up", NAW_OnAssignment, 'LeveledUp_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Chosen_Leveled_Up", NAW_OnAssignment, 'LeveledUp_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, '');

	return Template;
}

static function X2DataTemplate CreateCH_CovertActionsTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'CH_CovertActions');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_XCOM_Covert_Action_Ambushed", NAW_OnAssignment, 'AmbushComment_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_XCOM_Covert_Action_Ambushed", NAW_OnAssignment, 'AmbushComment_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_XCOM_Covert_Action_Ambushed", NAW_OnAssignment, 'AmbushComment_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, '');

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_ASSN_S_Covert_Action_Cancelled_Plans", NAW_OnAssignment, 'CancelledActivity_Assassin', '', ELD_OnStateSubmitted, NPC_Multiple, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_HNTR_S_Covert_Action_Cancelled_Plans", NAW_OnAssignment, 'CancelledActivity_Hunter', '', ELD_OnStateSubmitted, NPC_Multiple, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_WRLK_S_Covert_Action_Cancelled_Plans", NAW_OnAssignment, 'CancelledActivity_Warlock', '', ELD_OnStateSubmitted, NPC_Multiple, '');

	return Template;
}

// #######################################################################################
// -------------------- LOST AND ABANDONED OBJECTIVES ------------------------------------
// #######################################################################################

static function X2DataTemplate CreateXP0_M0_LostAndAbandonedTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'XP0_M0_LostAndAbandoned');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// VO and Objectives which will only activate when Narrative Content is enabled for this XPack  //
	// This will only ever be activated at the start of a new campaign								//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	Template.CompletionEvent = 'PreMissionDone';
	
	Template.NextObjectives.AddItem('XP0_M7_MeetTheReapersLA');
	Template.NextObjectives.AddItem('XP0_M3_AssassinLocated');
	Template.NextObjectives.AddItem('XP0_M5_ActivateChosenLostAndAbandoned');
	Template.NextObjectives.AddItem('N_XPFactionHQLocated');

	Template.AddNarrativeTrigger("", NAW_OnAssignment, 'PreMissionDone', '', ELD_OnStateSubmitted, NPC_Once, '', LostAndAbandonedSetup);

	return Template;
}

function LostAndAbandonedSetup()
{
	local XComGameStateHistory History;
	local XComGameState_MissionCalendar CalendarState;
	local XComGameState NewGameState;
	local MissionCalendarDate CalendarDate, NewCalendarDate;
	local int idx;

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Setup XPack Narrative Lost and Abandoned");
	
	CalendarState = XComGameState_MissionCalendar(History.GetSingleGameStateObjectForClass(class'XComGameState_MissionCalendar'));
	CalendarState = XComGameState_MissionCalendar(NewGameState.ModifyStateObject(class'XComGameState_MissionCalendar', CalendarState.ObjectID));
	
	foreach CalendarState.CurrentMissionMonth(CalendarDate, idx)
	{
		if (CalendarDate.MissionSource == 'MissionSource_ResistanceOp')
		{
			// Replace the regular Res Ops mission with the Lost and Abandoned mission
			NewCalendarDate.Missions = CalendarDate.Missions;
			NewCalendarDate.SpawnDate = CalendarDate.SpawnDate;
			NewCalendarDate.MissionSource = 'MissionSource_LostAndAbandoned';

			CalendarState.CurrentMissionMonth[idx] = NewCalendarDate;
			break;
		}
	}
	
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

static function X2DataTemplate CreateXP0_M5_ActivateChosenLostAndAbandonedTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'XP0_M5_ActivateChosenLostAndAbandoned');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionEvent = 'GuerillaOpComplete';
	Template.CompleteObjectiveFn = ActivateChosen;

	return Template;
}

static function X2DataTemplate CreateXP0_M1_TutorialLostAndAbandonedCompleteTemplate()
{
	local X2ObjectiveTemplate Template;

	// This is a special version of the L&A Complete objective which only gets activated when the base game tutorial is enabled

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'XP0_M1_TutorialLostAndAbandonedComplete');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.NextObjectives.AddItem('XP1_M2_RevealChosen');
	Template.NextObjectives.AddItem('XP0_M4_RescueMoxComplete');

	Template.RevealEvent = '';
	Template.CompletionEvent = 'LostAndAbandonedComplete';
	Template.CompleteObjectiveFn = FlagXPackNarrativeCompleted;
	
	return Template;
}

static function X2DataTemplate CreateXP0_M1_LostAndAbandonedCompleteTemplate()
{
	local X2ObjectiveTemplate Template;

	// Triggered only for non-tutorial games

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'XP0_M1_LostAndAbandonedComplete');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.NextObjectives.AddItem('XP1_M2_RevealChosen');
	Template.NextObjectives.AddItem('XP0_M4_RescueMoxComplete');

	Template.RevealEvent = '';
	Template.CompletionEvent = 'LostAndAbandonedComplete';
	Template.CompleteObjectiveFn = FlagXPackNarrativeCompleted;

	// Central's line about how a Faction will contact us soon
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_LNA_Scanning_Intro", NAW_OnAssignment, 'OnGeoscapeEntry', '', ELD_OnStateSubmitted, NPC_Once, '', SpawnFirstPOI);

	return Template;
}

function SpawnFirstPOI()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersResistance ResistanceHQ;

	History = `XCOMHISTORY;
	ResistanceHQ = XComGameState_HeadquartersResistance(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));

	if (!ResistanceHQ.bFirstPOISpawned)
	{
		ResistanceHQ.AttemptSpawnRandomPOI();
	}
}

function FlagXPackNarrativeCompleted(XComGameState NewGameState, XComGameState_Objective ObjectiveState)
{	
	if (`XPROFILESETTINGS.Data.m_bPlayerHasUncheckedBoxXPackNarrativeSetting == false)
	{
		`XPROFILESETTINGS.Data.m_bPlayerHasUncheckedBoxXPackNarrativeSetting = true; //Only allow this to be activate for this profile, never toggled back. 
		`ONLINEEVENTMGR.SaveProfileSettings(true);
	}
}

static function X2DataTemplate CreateXP0_M7_MeetTheReapersLATemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'XP0_M7_MeetTheReapersLA');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.NextObjectives.AddItem('XP0_M2_FactionMetLA');

	Template.CompletionEvent = 'MetFaction_Reapers';

	// This is an alternate version of FL_FactionMet which plays specific lines for the Lost and Abandoned narrative
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_VLK_Faction_Leader_Intro", NAW_OnAssignment, 'MetFaction_Reapers', '', ELD_OnStateSubmitted, NPC_Once, '', CompleteReaperLostAndAbandonedIntro);

	return Template;
}

function CompleteReaperLostAndAbandonedIntro()
{
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	
	// Turn off flight mode after Volk's dialogue finishes so the Assassin reveal can begin
	`HQPRES.StrategyMap2D.SetUIState(eSMS_Default);
	
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("L&A: Turn off Ring Warning");
	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	XComHQ.bPlayedWarningNoRing = true;
	`GAMERULES.SubmitGameState(NewGameState);
}

static function X2DataTemplate CreateXP0_M2_FactionMetLATemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'XP0_M2_FactionMetLA');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	// This is an alternate version of FL_FactionMet which plays specific lines for the Lost and Abandoned narrative
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_BET_Faction_Leader_Intro", NAW_OnAssignment, 'MetFaction_Skirmishers', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_KAL_Faction_Leader_Intro", NAW_OnAssignment, 'MetFaction_Templars', '', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}

static function X2DataTemplate CreateXP0_M3_AssassinLocatedTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'XP0_M3_AssassinLocated');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.NextObjectives.AddItem('N_XPChosenLocated');

	Template.CompletionEvent = 'ChosenLocated_Assassin';
	
	//Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_How_Chosen_Work", NAW_OnAssignment, 'ChosenLocated_Assassin', '', ELD_OnStateSubmitted, NPC_Once, '', ContinueChosenReveal);
	Template.AddNarrativeTrigger("", NAW_OnAssignment, 'ChosenLocated_Assassin', '', ELD_OnStateSubmitted, NPC_Once, '', ContinueChosenReveal);

	return Template;
}

static function X2DataTemplate CreateXP0_M4_RescueMoxCompleteTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'XP0_M4_RescueMoxComplete');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.NextObjectives.AddItem('XP0_M6_MoxReturns');

	Template.RevealEvent = '';
	Template.CompletionEvent = 'RescueSoldierComplete';
	Template.AssignObjectiveFn = CreateRescueMoxCovertAction;
	
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Mox_Captured", NAW_OnAssignment, 'ViewCovertActionMoxCaptured', '', ELD_OnStateSubmitted, NPC_Once, '');	
	Template.AddNarrativeTrigger("", NAW_OnAssignment, 'RescueSoldierComplete', '', ELD_OnStateSubmitted, NPC_Once, '', MeetTheSkirmishers);

	return Template;
}

static function CreateRescueMoxCovertAction(XComGameState NewGameState, XComGameState_Objective ObjectiveState)
{
	local XComGameStateHistory History;
	local X2StrategyElementTemplateManager StratMgr;
	local X2CovertActionTemplate ActionTemplate;
	local XComGameState_ResistanceFaction FactionState;
	local StateObjectReference ActionRef;

	History = `XCOMHISTORY;
	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	foreach History.IterateByClassType(class'XComGameState_ResistanceFaction', FactionState)
	{
		// Create a special Rescue Soldier covert action for the Reapers, in order to rescue Mox
		if (FactionState.GetMyTemplateName() == 'Faction_Reapers')
		{
			ActionTemplate = X2CovertActionTemplate(StratMgr.FindStrategyElementTemplate('CovertAction_RescueSoldier'));
			
			FactionState = XComGameState_ResistanceFaction(NewGameState.ModifyStateObject(class'XComGameState_ResistanceFaction', FactionState.ObjectID));		
			ActionRef = FactionState.CreateCovertAction(NewGameState, ActionTemplate);
			FactionState.GoldenPathActions.AddItem(ActionRef); // Add it to the Golden Path list so it doesn't get deleted on refresh
			break;
		}
	}
}

function MeetTheSkirmishers()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_ResistanceFaction FactionState;
	
	History = `XCOMHISTORY;
	foreach History.IterateByClassType(class'XComGameState_ResistanceFaction', FactionState)
	{
		if (!FactionState.bMetXCom && FactionState.GetMyTemplateName() == 'Faction_Skirmishers')
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Lost and Abandoned: Meet the Skirmishers");
			FactionState = XComGameState_ResistanceFaction(NewGameState.ModifyStateObject(class'XComGameState_ResistanceFaction', FactionState.ObjectID));
			FactionState.MeetXCom(NewGameState); // Don't give a Faction soldier since we were just rewarded Mox after the mission
			`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
		}
	}
}

static function X2DataTemplate CreateXP0_M6_MoxReturnsTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'XP0_M6_MoxReturns');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	
	Template.CompletionEvent = 'MoxRescuedComplete';
	
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_CEN_Mox_Rescued", NAW_OnAssignment, 'MoxRescuedAfterAction', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_Mox_Returns_To_XCOM", NAW_OnAssignment, 'MoxRescuedVIPRecovered', '', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}

// #######################################################################################
// -------------------------------- CHOSEN OBJECTIVES ------------------------------------
// #######################################################################################

static function X2DataTemplate CreateXP1_M0_ActivateChosenTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'XP1_M0_ActivateChosen');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.NextObjectives.AddItem('XP1_M1_RetaliationComplete');

	Template.CompletionEvent = 'ResistanceOpComplete';
	Template.CompleteObjectiveFn = ActivateChosen;

	return Template;
}

static function ActivateChosen(XComGameState NewGameState, XComGameState_Objective ObjectiveState)
{
	local XComGameState_HeadquartersAlien AlienHQ;

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	AlienHQ = XComGameState_HeadquartersAlien(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersAlien', AlienHQ.ObjectID));
	AlienHQ.OnChosenActivation(NewGameState);
}

static function X2DataTemplate CreateXP1_M1_RetaliationCompleteTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'XP1_M1_RetaliationComplete');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.NextObjectives.AddItem('XP1_M2_RevealChosen');
	Template.CompletionEvent = 'RetaliationComplete';

	return Template;
}

static function X2DataTemplate CreateXP1_M2_RevealChosenTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'XP1_M2_RevealChosen');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionEvent = 'RevealChosenComplete';
	Template.CompleteObjectiveFn = EnsureMeetFirstChosen;
	
	// If the Res Ops is completed
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.XP_ChosenActivated", NAW_OnAssignment, 'OnEnteredFacility_CIC', '', ELD_OnStateSubmitted, NPC_Once, '', RevealChosenComplete);

	// If the Res Ops is skipped
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.XP_ChosenActivated", NAW_OnAssignment, 'MissionExpired', '', ELD_OnStateSubmitted, NPC_Once, '', RevealChosenComplete);

	return Template;
}

function RevealChosenComplete()
{
	local XComGameState NewGameState;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger Reveal Chosen Complete Event");
	`XEVENTMGR.TriggerEvent('RevealChosenComplete', , , NewGameState);
	`GAMERULES.SubmitGameState(NewGameState);
}

static function EnsureMeetFirstChosen(XComGameState NewGameState, XComGameState_Objective ObjectiveState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_AdventChosen ChosenState;

	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	
	ChosenState = XComGameState_AdventChosen(History.GetGameStateForObjectID(AlienHQ.AdventChosen[0].ObjectID));
	if (!ChosenState.bMetXCom)
	{
		ChosenState = XComGameState_AdventChosen(NewGameState.ModifyStateObject(class'XComGameState_AdventChosen', ChosenState.ObjectID));
		ChosenState.bMetXCom = true;
		ChosenState.bForcedMet = true;
	}
}

// #######################################################################################
// ----------------------------------- COVERT ACTIONS ------------------------------------
// #######################################################################################

static function X2DataTemplate CreateXP2_M0_FirstCovertActionTutorialTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'XP2_M0_FirstCovertActionTutorial');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.NextObjectives.AddItem('XP2_M1_SecondCovertActionTutorial');

	Template.CompletionEvent = 'CovertActionCompleted';
	
	return Template;
}

static function X2DataTemplate CreateXP2_M1_SecondCovertActionTutorialTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'XP2_M1_SecondCovertActionTutorial');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	
	Template.CompletionEvent = 'CovertActionCompleted';

	return Template;
}

// #######################################################################################
// -------------------------------- NON-LOST AND ABANDOEND -------------------------------
// #######################################################################################

static function X2DataTemplate CreateXP3_M0_NonLostAndAbandonedTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'XP3_M0_NonLostAndAbandoned');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	/////////////////////////////////////////////////////////////////////////////
	// These objectives only get started when Lost and Abandoned is turned off //
	/////////////////////////////////////////////////////////////////////////////
	
	Template.NextObjectives.AddItem('N_XPFirstChosenLocated');
	Template.NextObjectives.AddItem('FL_FactionMet');
	Template.NextObjectives.AddItem('XP1_M0_ActivateChosen');
	Template.NextObjectives.AddItem('XP3_M1_MeetFirstFaction');
	Template.NextObjectives.AddItem('XP3_M2_SpawnFirstPOI');

	Template.CompletionEvent = 'PreMissionDone';

	return Template;
}

static function X2DataTemplate CreateXP3_M1_MeetFirstFactionTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'XP3_M1_MeetFirstFaction');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.NextObjectives.AddItem('N_XPFactionHQLocated');

	Template.CompletionEvent = 'FactionHQLocated';

	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_REAP_HQ_Intro", NAW_OnAssignment, 'RevealHQ_Reapers', '', ELD_OnStateSubmitted, NPC_Once, '', ContinueFactionHQReveal);
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_SKRM_HQ_Intro", NAW_OnAssignment, 'RevealHQ_Skirmishers', '', ELD_OnStateSubmitted, NPC_Once, '', ContinueFactionHQReveal);
	Template.AddNarrativeTrigger("XPACK_NarrativeMoments.X2_XP_S_TMPL_HQ_Intro", NAW_OnAssignment, 'RevealHQ_Templars', '', ELD_OnStateSubmitted, NPC_Once, '', ContinueFactionHQReveal);

	return Template;
}

static function X2DataTemplate CreateXP3_M2_SpawnFirstPOITemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'XP3_M2_SpawnFirstPOI');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionEvent = 'SpawnFirstPOI';

	Template.AddNarrativeTrigger("", NAW_OnAssignment, 'SpawnFirstPOI', '', ELD_OnStateSubmitted, NPC_Once, '', SpawnFirstPOI);

	return Template;
}