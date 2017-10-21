//---------------------------------------------------------------------------------------
//  FILE:    UICustomize_SparkInfo.uc
//  AUTHOR:  Joe Weinhoffer --  2/22/2016
//  PURPOSE: Edit the Spark's name and bio
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class UICustomize_SparkInfo extends UICustomize_Info;

//----------------------------------------------------------------------------
// FUNCTIONS

simulated function CreateDataListItems()
{
	local UIMechaListItem ListItem;
	local int i;

	// FIRST NAME
	//-----------------------------------------------------------------------------------------
	ListItem = GetListItem(i++);
	ListItem.UpdateDataDescription(m_strFirstNameLabel, OpenFirstNameInputBox);

	// LAST NAME
	//-----------------------------------------------------------------------------------------
	ListItem = GetListItem(i++);
	ListItem.UpdateDataDescription(m_strLastNameLabel, OpenLastNameInputBox);

	// NICKNAME
	//-----------------------------------------------------------------------------------------
	ListItem = GetListItem(i++);
	ListItem.UpdateDataDescription(m_strNicknameLabel, OpenNickNameInputBox);
	ListItem.SetDisabled(!Unit.IsVeteran() && !InShell(), m_strNeedsVeteranStatus); // Don't disable in the shell. 

	// BIO
	//-----------------------------------------------------------------------------------------
	ListItem = GetListItem(i++);
	ListItem.UpdateDataDescription(m_strEditBiography, OpenBiographyInputBox);

	// VOICE
	//-----------------------------------------------------------------------------------------
	ListItem = GetListItem(i++);
	ListItem.UpdateDataValue(class'UICustomize_SparkMenu'.default.m_strVoice,
		CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_Voice, eUIState_Normal, FontSize), CustomizeVoice);
}