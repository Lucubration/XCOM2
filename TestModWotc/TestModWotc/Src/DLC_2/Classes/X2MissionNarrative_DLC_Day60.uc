//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    X2MissionNarrative_DLC_Day60.uc
//  AUTHOR:  James Brawley - 1/21/2016
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class X2MissionNarrative_DLC_Day60 extends X2MissionNarrative;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2MissionNarrativeTemplate> Templates;

    Templates.AddItem(AddDefaultAlienNestNarrativeTemplate());

    return Templates;
}

static function X2MissionNarrativeTemplate AddDefaultAlienNestNarrativeTemplate()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultAlienNest');

    Template.MissionType = "AlienNest";
	Template.NarrativeMoments[0]="DLC_60_NarrativeMoments.DLC2_T_Facility_Entry_One";			// Linked
	Template.NarrativeMoments[1]="DLC_60_NarrativeMoments.DLC2_T_Facility_Entry_Two";			// Linked
	Template.NarrativeMoments[2]="DLC_60_NarrativeMoments.DLC2_T_MATINEE_Boots_Ground";			// Linked but modified
	Template.NarrativeMoments[3]="DLC_60_NarrativeMoments.DLC2_T_Neophytes_Spotted";			// Linked
	Template.NarrativeMoments[4]="DLC_60_NarrativeMoments.DLC2_T_Post_Pad";						// UnLinked
	Template.NarrativeMoments[5]="DLC_60_NarrativeMoments.DLC2_T_Pre_Ambush_Research_One";  	// Linked
	Template.NarrativeMoments[6]="DLC_60_NarrativeMoments.DLC2_T_Pre_Ambush_Research_Two";  	// Linked
	Template.NarrativeMoments[7]="DLC_60_NarrativeMoments.DLC2_T_Research_Segue";				// Linked
	Template.NarrativeMoments[8]="DLC_60_NarrativeMoments.DLC2_T_The_Beacon";					// Linked
	Template.NarrativeMoments[9]="DLC_60_NarrativeMoments.DLC2_T_Ambush";						// Linked
	Template.NarrativeMoments[10]="DLC_60_NarrativeMoments.DLC2_T_Ambush_Begins";				// Linked
	Template.NarrativeMoments[11]="DLC_60_NarrativeMoments.DLC2_T_Approach_The_King";			// Linked
	Template.NarrativeMoments[12]="DLC_60_NarrativeMoments.DLC2_T_Beacon_Located";				// Linked
	Template.NarrativeMoments[13]="DLC_60_NarrativeMoments.DLC2_T_MATINEE_King_Reveal";			// Linked
	Template.NarrativeMoments[14]="DLC_60_NarrativeMoments.DLC2_T_Post_Ambush_Research_One";	// Linked
	Template.NarrativeMoments[15]="DLC_60_NarrativeMoments.DLC2_T_Post_Ambush_Research_Two";	// Linked
	Template.NarrativeMoments[16]="DLC_60_NarrativeMoments.DLC2_T_Post_Ambush_Research_Three";	// Linked
	Template.NarrativeMoments[17]="DLC_60_NarrativeMoments.DLC2_T_Post_Ambush_Research_Five";	// Linked
	Template.NarrativeMoments[18]="DLC_60_NarrativeMoments.DLC2_T_Post_Ambush_Research_Four";	// Linked
	Template.NarrativeMoments[19]="DLC_60_NarrativeMoments.DLC2_T_Post_Ambush_Research_Six";	// Linked
	Template.NarrativeMoments[20]="DLC_60_NarrativeMoments.DLC2_T_Pre_Ambush_Research_Three";	// Linked
	Template.NarrativeMoments[21]="DLC_60_NarrativeMoments.DLC2_T_Pre_Ambush_Research_Four";	// Linked
	Template.NarrativeMoments[22]="DLC_60_NarrativeMoments.DLC2_T_Pre_Ambush_Research_Five";	// Linked
	Template.NarrativeMoments[23]="DLC_60_NarrativeMoments.DLC2_T_Pre_Ambush_Research_Six";		// Linked
	Template.NarrativeMoments[24]="DLC_60_NarrativeMoments.DLC2_T_Push_Forward";				// UnLinked
	Template.NarrativeMoments[25]="DLC_60_NarrativeMoments.DLC2_T_Transmission_Cleared";		// Linked
	Template.NarrativeMoments[26]="DLC_60_NarrativeMoments.DLC2_T_Unbroken_Transmission";		// Linked
	Template.NarrativeMoments[27]="DLC_60_NarrativeMoments.DLC2_T_Reinforcements_Wont_Stop";	// Linked
	Template.NarrativeMoments[28]="DLC_60_NarrativeMoments.DLC2_T_Post_King_Research_One";		// Linked
	Template.NarrativeMoments[29]="DLC_60_NarrativeMoments.DLC2_T_Post_King_Research_Two";		// Linked
	Template.NarrativeMoments[30]="DLC_60_NarrativeMoments.DLC2_T_Post_King_Research_Three";	// Linked
	Template.NarrativeMoments[31]="DLC_60_NarrativeMoments.DLC2_T_Post_King_Research_Four";		// Linked
	Template.NarrativeMoments[32]="DLC_60_NarrativeMoments.DLC2_T_Post_King_Research_Five";		// Linked
	Template.NarrativeMoments[33]="DLC_60_NarrativeMoments.DLC2_T_Post_King_Research_Six";		// Linked
	Template.NarrativeMoments[34]="DLC_60_NarrativeMoments.DLC2_T_Post_Matinee";				// Linked
	Template.NarrativeMoments[35]="DLC_60_NarrativeMoments.DLC2_T_Post_Pad_Alt";				// Linked
	Template.NarrativeMoments[36]="DLC_60_NarrativeMoments.DLC2_T_Push_Forward_Alt";			// Linked
	Template.NarrativeMoments[37]="DLC_60_NarrativeMoments.DLC2_T_Mission_Final";				// Unused
	Template.NarrativeMoments[38]="DLC_60_NarrativeMoments.DLC2_T_Mission_Final";				// Unused
	Template.NarrativeMoments[39]="DLC_60_NarrativeMoments.DLC2_T_Mission_Final";
	Template.NarrativeMoments[40]="DLC_60_NarrativeMoments.DLC2_T_Egg_Warning";
	Template.NarrativeMoments[41]="DLC_60_NarrativeMoments.DLC2_T_King_Attempting_Escape";
	Template.NarrativeMoments[42]="DLC_60_NarrativeMoments.DLC2_T_King_Dead_AO_Clear";			// Linked
	Template.NarrativeMoments[43]="DLC_60_NarrativeMoments.DLC2_T_King_Escaped_AO_Clear";		// Linked
	Template.NarrativeMoments[44]="DLC_60_NarrativeMoments.DLC2_T_King_Escaped_Clear_AO";		// Linked
	Template.NarrativeMoments[45]="DLC_60_NarrativeMoments.DLC2_T_King_Has_Escaped";			// Linked
	Template.NarrativeMoments[46]="DLC_60_NarrativeMoments.DLC2_T_MATINEE_Final_Body_Check";
	Template.NarrativeMoments[47]="DLC_60_NarrativeMoments.DLC2_T_King_Dead_Clear_AO";			// Linked

    return Template;
}


