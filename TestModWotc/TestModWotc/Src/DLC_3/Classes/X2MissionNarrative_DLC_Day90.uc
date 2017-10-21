//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    X2MissionNarrative_DLC_Day90.uc
//  AUTHOR:  James Brawley - 2/9/2016
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class X2MissionNarrative_DLC_Day90 extends X2MissionNarrative;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2MissionNarrativeTemplate> Templates;

    Templates.AddItem(AddDefaultLastGiftNarrativeTemplate());
    Templates.AddItem(AddDefaultLastGiftPartBNarrativeTemplate());
    Templates.AddItem(AddDefaultLastGiftPartCNarrativeTemplate());

    return Templates;
}

static function X2MissionNarrativeTemplate AddDefaultLastGiftNarrativeTemplate()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultLastGift');

    Template.MissionType = "LastGift";
    Template.NarrativeMoments[0]="DLC_90_NarrativeMoments.DLC3_T_Lily_Shen_Killed";
    Template.NarrativeMoments[1]="DLC_90_NarrativeMoments.DLC3_T_Spark_Is_Killed";
    Template.NarrativeMoments[2]="DLC_90_NarrativeMoments.DLC3_T_Squad_Heavy_Losses";
    Template.NarrativeMoments[3]="DLC_90_NarrativeMoments.DLC3_T_Reinf_Reminder_ALT";
    Template.NarrativeMoments[4]="DLC_90_NarrativeMoments.DLC3_T_Reinforcement_Reminder";
    Template.NarrativeMoments[5]="DLC_90_NarrativeMoments.DLC3_T_Boots_Ground";
    Template.NarrativeMoments[6]="DLC_90_NarrativeMoments.DLC3_T_Bridge_Extended";
    Template.NarrativeMoments[7]="DLC_90_NarrativeMoments.DLC3_T_Elevator_Activated";
    Template.NarrativeMoments[8]="DLC_90_NarrativeMoments.DLC3_T_Facility_Elevator_Reveal";
    Template.NarrativeMoments[9]="DLC_90_NarrativeMoments.DLC3_T_Feral_Mec_Destroyed";
    Template.NarrativeMoments[10]="DLC_90_NarrativeMoments.DLC3_T_First_Feral_Mec";
    Template.NarrativeMoments[11]="DLC_90_NarrativeMoments.DLC3_T_Unlimited_Reinf";
    Template.NarrativeMoments[12]="DLC_90_NarrativeMoments.DLC3_T_First_Soldier_Escapes_MapOne";
    Template.NarrativeMoments[13]="DLC_90_NarrativeMoments.DLC3_T_Player_Escapes_MapOne";
    Template.NarrativeMoments[14]="DLC_90_NarrativeMoments.DLC3_T_Phase_One";
    Template.NarrativeMoments[15]="DLC_90_NarrativeMoments.DLC3_T_Phase_Two";
    Template.NarrativeMoments[16]="DLC_90_NarrativeMoments.DLC3_T_Phase_Three";
    Template.NarrativeMoments[17]="DLC_90_NarrativeMoments.DLC3_T_Phase_Four";
    Template.NarrativeMoments[18]="DLC_90_NarrativeMoments.DLC3_T_Phase_Five";
    Template.NarrativeMoments[19]="DLC_90_NarrativeMoments.DLC3_T_Phase_Six";
    Template.NarrativeMoments[20]="DLC_90_NarrativeMoments.DLC3_T_Phase_Seven";
    Template.NarrativeMoments[21]="DLC_90_NarrativeMoments.DLC3_T_Phase_Eight";
    Template.NarrativeMoments[22]="DLC_90_NarrativeMoments.DLC3_T_Phase_Nine";
    Template.NarrativeMoments[23]="DLC_90_NarrativeMoments.DLC3_T_Phase_Ten";
    Template.NarrativeMoments[24]="DLC_90_NarrativeMoments.DLC3_T_Phase_Eleven";
    Template.NarrativeMoments[25]="DLC_90_NarrativeMoments.DLC3_T_Phase_Twelve";
    Template.NarrativeMoments[26]="DLC_90_NarrativeMoments.DLC3_T_Phase_Thirteen";
    Template.NarrativeMoments[27]="DLC_90_NarrativeMoments.DLC3_T_Phase_Fourteen";
    Template.NarrativeMoments[28]="DLC_90_NarrativeMoments.DLC3_T_Phase_Fifteen";
    Template.NarrativeMoments[29]="DLC_90_NarrativeMoments.DLC3_T_Phase_Sixteen";
    Template.NarrativeMoments[30]="DLC_90_NarrativeMoments.DLC3_T_Phase_Seventeen";
    Template.NarrativeMoments[31]="DLC_90_NarrativeMoments.DLC3_T_Julian_Speaks";
    Template.NarrativeMoments[32]="DLC_90_NarrativeMoments.DLC3_T_Elevator_Control_LOS";
    Template.NarrativeMoments[33]="DLC_90_NarrativeMoments.DLC3_T_Elevator_Activated_Spawn";
    Template.NarrativeMoments[34]="DLC_90_NarrativeMoments.DLC3_T_Feral_Mec_Destroyed_Factory";
    Template.NarrativeMoments[35]="DLC_90_NarrativeMoments.DLC3_T_Kamikaze_Mec_Sighted";
    Template.NarrativeMoments[36]="DLC_90_NarrativeMoments.DLC3_T_Kamikaze_Mec_Sighted_Unknown";
    Template.NarrativeMoments[37]="DLC_90_NarrativeMoments.DLC3_T_First_Soldier_Escapes_MapOne_Unknown";
    Template.NarrativeMoments[38]="DLC_90_NarrativeMoments.DLC3_T_Lily_Shen_Killed_Unknown";
    Template.NarrativeMoments[39]="DLC_90_NarrativeMoments.DLC3_T_Elevator_Activated_Spawn_Unknown";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultLastGiftPartBNarrativeTemplate()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultLastGiftPartB');

    Template.MissionType = "LastGiftB";
    Template.NarrativeMoments[0]="DLC_90_NarrativeMoments.DLC3_T_Lily_Shen_Killed";
    Template.NarrativeMoments[1]="DLC_90_NarrativeMoments.DLC3_T_Spark_Is_Killed";
    Template.NarrativeMoments[2]="DLC_90_NarrativeMoments.DLC3_T_Squad_Heavy_Losses";
    Template.NarrativeMoments[3]="DLC_90_NarrativeMoments.DLC3_T_Reinf_Reminder_ALT";
    Template.NarrativeMoments[4]="DLC_90_NarrativeMoments.DLC3_T_Reinforcement_Reminder";
    Template.NarrativeMoments[5]="DLC_90_NarrativeMoments.DLC3_T_First_Turrets";
    Template.NarrativeMoments[6]="DLC_90_NarrativeMoments.DLC3_T_Section_Two_Tactical_Intro";
    Template.NarrativeMoments[7]="DLC_90_NarrativeMoments.DLC3_T_Player_LOS_To_Prototype";
    Template.NarrativeMoments[8]="DLC_90_NarrativeMoments.DLC3_T_Section_Two_Turn_Taunts_A";
    Template.NarrativeMoments[9]="DLC_90_NarrativeMoments.DLC3_T_Section_Two_Turn_Taunts_B";
    Template.NarrativeMoments[10]="DLC_90_NarrativeMoments.DLC3_T_Section_Two_Turn_Taunts_C";
    Template.NarrativeMoments[11]="DLC_90_NarrativeMoments.DLC3_T_Section_Two_Turn_Taunts_D";
    Template.NarrativeMoments[12]="DLC_90_NarrativeMoments.DLC3_T_Section_Two_Turn_Taunts_E";
    Template.NarrativeMoments[13]="DLC_90_NarrativeMoments.DLC3_T_Poison_Gas_Ambush";
    Template.NarrativeMoments[14]="DLC_90_NarrativeMoments.DLC3_T_Poison_Gas_Deactivated";
    Template.NarrativeMoments[15]="DLC_90_NarrativeMoments.DLC3_T_Spark_Is_Specialist";
    Template.NarrativeMoments[16]="DLC_90_NarrativeMoments.DLC3_T_Spark_Vs_Gas";
    Template.NarrativeMoments[17]="DLC_90_NarrativeMoments.DLC3_T_Section_Two_Almost_EVACED";
    Template.NarrativeMoments[18]="DLC_90_NarrativeMoments.DLC3_T_More_Taunts_3";
    Template.NarrativeMoments[19]="DLC_90_NarrativeMoments.DLC3_T_More_Taunts_6";
    Template.NarrativeMoments[20]="DLC_90_NarrativeMoments.DLC3_T_More_Taunts_7";
    Template.NarrativeMoments[21]="DLC_90_NarrativeMoments.DLC3_T_More_Taunts_8";
    Template.NarrativeMoments[22]="DLC_90_NarrativeMoments.DLC3_T_More_Taunts_9";
    Template.NarrativeMoments[23]="DLC_90_NarrativeMoments.DLC3_T_More_Taunts_10";
    Template.NarrativeMoments[24]="DLC_90_NarrativeMoments.DLC3_T_Section_Two_Turn_Taunts_B";
    Template.NarrativeMoments[25]="DLC_90_NarrativeMoments.DLC3_T_Section_Two_Turn_Taunts_E";
    Template.NarrativeMoments[26]="DLC_90_NarrativeMoments.DLC3_T_Julian_Encounter_Begins";
    Template.NarrativeMoments[27]="DLC_90_NarrativeMoments.DLC3_T_More_Taunts_10"; // Sort of deprecated, don't want to reindex, but not
    Template.NarrativeMoments[28]="DLC_90_NarrativeMoments.DLC3_T_More_Taunts_11"; // Enough open indices here to reuse
    Template.NarrativeMoments[29]="DLC_90_NarrativeMoments.DLC3_T_More_Taunts_12"; // Same
    Template.NarrativeMoments[30]="DLC_90_NarrativeMoments.DLC3_T_More_Taunts_13"; // Same
    Template.NarrativeMoments[31]="DLC_90_NarrativeMoments.DLC3_T_Escaped_Level_Two";
    Template.NarrativeMoments[32]="DLC_90_NarrativeMoments.DLC3_T_Escaped_Level_Two_ALT1";
    Template.NarrativeMoments[33]="DLC_90_NarrativeMoments.DLC3_T_Escaped_Level_Two_ALT2";
    Template.NarrativeMoments[34]="DLC_90_NarrativeMoments.DLC3_T_Poison_Gas_Deactivated_B";
    Template.NarrativeMoments[35]="DLC_90_NarrativeMoments.DLC3_T_Lots_Of_Turrets";
    Template.NarrativeMoments[36]="DLC_90_NarrativeMoments.DLC3_T_Player_LOS_To_Prototype_B";
    Template.NarrativeMoments[37]="DLC_90_NarrativeMoments.DLC3_T_Player_LOS_To_Prototype_C";
    Template.NarrativeMoments[38]="DLC_90_NarrativeMoments.DLC3_T_Phase_Fifteen";
    Template.NarrativeMoments[39]="DLC_90_NarrativeMoments.DLC3_T_Phase_Seventeen";
    Template.NarrativeMoments[40]="DLC_90_NarrativeMoments.DLC3_T_Phase_Thirteen";
    Template.NarrativeMoments[41]="DLC_90_NarrativeMoments.DLC3_T_Phase_Fourteen";
    Template.NarrativeMoments[42]="DLC_90_NarrativeMoments.DLC3_T_Phase_Sixteen";
    Template.NarrativeMoments[43]="DLC_90_NarrativeMoments.DLC3_T_More_Taunts_1";
    Template.NarrativeMoments[44]="DLC_90_NarrativeMoments.DLC3_T_More_Taunts_5";
    Template.NarrativeMoments[45]="DLC_90_NarrativeMoments.DLC3_T_More_Taunts_11";
    Template.NarrativeMoments[46]="DLC_90_NarrativeMoments.DLC3_T_More_Taunts_12";
    Template.NarrativeMoments[47]="DLC_90_NarrativeMoments.DLC3_T_More_Taunts_13";
    Template.NarrativeMoments[48]="DLC_90_NarrativeMoments.DLC3_T_More_Taunts_13"; // Holding this index for a line that doesn't exist yet 
    Template.NarrativeMoments[49]="DLC_90_NarrativeMoments.DLC3_T_SparkActivation";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultLastGiftPartCNarrativeTemplate()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultLastGiftPartC');

    Template.MissionType = "LastGiftC";
    Template.NarrativeMoments[0]="DLC_90_NarrativeMoments.DLC3_T_Lily_Shen_Killed";
    Template.NarrativeMoments[1]="DLC_90_NarrativeMoments.DLC3_T_Spark_Is_Killed";
    Template.NarrativeMoments[2]="DLC_90_NarrativeMoments.DLC3_T_Squad_Heavy_Losses";
    Template.NarrativeMoments[3]="DLC_90_NarrativeMoments.DLC3_T_Reinf_Reminder_ALT";
    Template.NarrativeMoments[4]="DLC_90_NarrativeMoments.DLC3_T_Reinforcement_Reminder";
    Template.NarrativeMoments[5]="DLC_90_NarrativeMoments.DLC3_T_Section_Three_Tactical_Intro_ALT1";
    Template.NarrativeMoments[6]="DLC_90_NarrativeMoments.DLC3_T_Sectopod_In_Play";
    Template.NarrativeMoments[7]="DLC_90_NarrativeMoments.DLC3_T_Sectopod_Turn_Taunts_A";
    Template.NarrativeMoments[8]="DLC_90_NarrativeMoments.DLC3_T_Sectopod_Turn_Taunts_B";
    Template.NarrativeMoments[9]="DLC_90_NarrativeMoments.DLC3_T_Sectopod_Turn_Taunts_C_2";
    Template.NarrativeMoments[10]="DLC_90_NarrativeMoments.DLC3_T_Sectopod_Turn_Taunts_D";
    Template.NarrativeMoments[11]="DLC_90_NarrativeMoments.DLC3_T_Sectopod_Turn_Taunts_E";
    Template.NarrativeMoments[12]="DLC_90_NarrativeMoments.DLC3_T_Sectopod_Destroyed";
    Template.NarrativeMoments[13]="DLC_90_NarrativeMoments.DLC3_T_Julian_Awakens";
    Template.NarrativeMoments[14]="DLC_90_NarrativeMoments.DLC3_T_Julian_Encounter_Begins";
    Template.NarrativeMoments[15]="DLC_90_NarrativeMoments.DLC3_T_Julian_Mec_Reinforcements";
    Template.NarrativeMoments[16]="DLC_90_NarrativeMoments.DLC3_T_Sectopod_Taunt_ALT_1";
    Template.NarrativeMoments[17]="DLC_90_NarrativeMoments.DLC3_T_Sectopod_Taunt_ALT_2";
    Template.NarrativeMoments[18]="DLC_90_NarrativeMoments.DLC3_T_Sectopod_Taunt_ALT_3";
    Template.NarrativeMoments[19]="DLC_90_NarrativeMoments.DLC3_T_Sectopod_Taunt_ALT_4";
    Template.NarrativeMoments[20]="DLC_90_NarrativeMoments.DLC3_T_Sectopod_Taunt_ALT_5";
    Template.NarrativeMoments[21]="DLC_90_NarrativeMoments.DLC3_T_Sectopod_Taunt_ALT_6";
    Template.NarrativeMoments[22]="DLC_90_NarrativeMoments.DLC3_T_Sectopod_Taunt_ALT_7";
    Template.NarrativeMoments[23]="DLC_90_NarrativeMoments.DLC3_T_Sectopod_Taunt_ALT_8";
    Template.NarrativeMoments[24]="DLC_90_NarrativeMoments.DLC3_T_Sectopod_Taunt_ALT_9";
    Template.NarrativeMoments[25]="DLC_90_NarrativeMoments.DLC3_T_Sectopod_Taunt_ALT_10";
    Template.NarrativeMoments[26]="DLC_90_NarrativeMoments.DLC3_T_Sectopod_Taunt_ALT_11";
    Template.NarrativeMoments[27]="DLC_90_NarrativeMoments.DLC3_T_Sectopod_Reinforcement_Alt";

    return Template;
}