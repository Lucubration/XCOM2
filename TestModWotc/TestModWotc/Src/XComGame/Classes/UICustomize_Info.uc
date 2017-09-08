//---------------------------------------------------------------------------------------
//  FILE:    UICustomize_Info.uc
//  AUTHOR:  Brit Steiner --  8/28/2014
//  PURPOSE: Edit the soldier's name and nationality. 
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class UICustomize_Info extends UICustomize;

const MAX_CHARACTERS_BIO = 3000;

//----------------------------------------------------------------------------
// MEMBERS

var localized string m_strTitle;
var localized string m_strFirstNameLabel;
var localized string m_strLastNameLabel;
var localized string m_strNicknameLabel;
var localized string m_strEditBiography;
var localized string m_strBiographyLabel;
var localized string m_strNationality;
var localized string m_strGender;

var localized string m_strVoice;
var localized string m_strPreviewVoice;
var localized string m_strAttitude;

//----------------------------------------------------------------------------
// FUNCTIONS

simulated function UpdateData()
{
	local CharacterPoolManager cpm;
	local int currentSel;
	
	currentSel = List.SelectedIndex;

	super.UpdateData();

	// Do we have any separated data to request? 
	if (!bInArmory)
	{
		cpm = CharacterPoolManager(`XENGINE.GetCharacterPoolManager());
		cpm.OnCharacterModified(Unit);
	}
	
	CreateDataListItems();

	AS_SetCharacterBio(m_strBiographyLabel, class'UIUtilities_Text'.static.GetSizedText(Unit.GetBackground(), FontSize));

	if (currentSel > -1 && currentSel < List.ItemCount)
	{
		List.Navigator.SetSelected(List.GetItem(currentSel));
	}
	else
	{
		List.Navigator.SetSelected(List.GetItem(0));
	}
}

simulated function CreateDataListItems()
{
	local EUIState ColorState;
	local int i;

	ColorState = bIsSuperSoldier ? eUIState_Disabled : eUIState_Normal;

	// FIRST NAME
	//-----------------------------------------------------------------------------------------
	GetListItem(i++)
		.UpdateDataDescription(m_strFirstNameLabel, OpenFirstNameInputBox)
		.SetDisabled(bIsSuperSoldier, m_strIsSuperSoldier);

	// LAST NAME
	//-----------------------------------------------------------------------------------------
	GetListItem(i++)
		.UpdateDataDescription(m_strLastNameLabel, OpenLastNameInputBox)
		.SetDisabled(bIsSuperSoldier, m_strIsSuperSoldier);

	// NICKNAME
	//-----------------------------------------------------------------------------------------
	ColorState = (bIsSuperSoldier || (!Unit.IsVeteran() && !InShell())) ? eUIState_Disabled : eUIState_Normal;
	GetListItem(i++)
		.UpdateDataDescription(m_strNickNameLabel, OpenNickNameInputBox)
		.SetDisabled(bIsSuperSoldier || (!Unit.IsVeteran() && !InShell()), bIsSuperSoldier ? m_strIsSuperSoldier : m_strNeedsVeteranStatus); // Don't disable in the shell. 

	ColorState = bIsSuperSoldier ? eUIState_Disabled : eUIState_Normal;

	// BIO
	//-----------------------------------------------------------------------------------------
	GetListItem(i++)
		.UpdateDataDescription(m_strEditBiography, OpenBiographyInputBox)
		.SetDisabled(bIsSuperSoldier, m_strIsSuperSoldier);

	// NATIONALITY
	//-----------------------------------------------------------------------------------------
	GetListItem(i++)
		.UpdateDataValue(CustomizeManager.CheckForAttentionIcon(eUICustomizeCat_Country)$ m_strNationality, CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_Country, ColorState, FontSize), CustomizeCountry)
		.SetDisabled(bIsSuperSoldier || bIsXPACSoldier, bIsSuperSoldier?m_strIsSuperSoldier: m_strNoNationality);

	// GENDER
	//-----------------------------------------------------------------------------------------
	GetListItem(i++)
		.UpdateDataValue(CustomizeManager.CheckForAttentionIcon(eUICustomizeCat_Gender)$ m_strGender, CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_Gender, ColorState, FontSize), CustomizeGender)
		.SetDisabled(bIsSuperSoldier, m_strIsSuperSoldier);

	// VOICE
	//-----------------------------------------------------------------------------------------
	GetListItem(i++).UpdateDataValue(CustomizeManager.CheckForAttentionIcon(eUICustomizeCat_Voice)$ m_strVoice, CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_Voice, eUIState_Normal, FontSize), CustomizeVoice);

	// DISABLE VETERAN OPTIONS
	ColorState = bDisableVeteranOptions ? eUIState_Disabled : eUIState_Normal;

	// ATTITUDE (VETERAN)
	//-----------------------------------------------------------------------------------------
	GetListItem(i++, bDisableVeteranOptions).UpdateDataValue(CustomizeManager.CheckForAttentionIcon(eUICustomizeCat_Personality)$ m_strAttitude,
		CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_Personality, ColorState, FontSize), CustomizePersonality);
}

// -----------------------------------------------------------------------

simulated function OpenFirstNameInputBox() { CustomizeManager.EditText( eUICustomizeCat_FirstName ); }
simulated function OpenLastNameInputBox()  { CustomizeManager.EditText( eUICustomizeCat_LastName ); }
simulated function OpenNickNameInputBox()  { CustomizeManager.EditText( eUICustomizeCat_NickName ); }

simulated function OpenBiographyInputBox() 
{
	local TInputDialogData kData;

//	if(!`GAMECORE.WorldInfo.IsConsoleBuild() || `ISCONTROLLERACTIVE )
//	{
		kData.strTitle = m_strEditBiography;
		kData.iMaxChars = MAX_CHARACTERS_BIO;
		kData.strInputBoxText = Unit.GetBackground();
		kData.fnCallback = OnBackgroundInputBoxClosed;
		kData.DialogType = eDialogType_MultiLine;

		Movie.Pres.UIInputDialog(kData);
/*	}
	else
	{
		Movie.Pres.UIKeyboard( m_strEditBiography, 
			Unit.GetBackground(), 
			VirtualKeyboard_OnBackgroundInputBoxAccepted, 
			VirtualKeyboard_OnBackgroundInputBoxCancelled,
			false, 
			MAX_CHARACTERS_BIO
		);
	}*/
}

function OnBackgroundInputBoxClosed(string text)
{
	CustomizeManager.UpdatedUnitState.SetBackground(text);
	AS_SetCharacterBio(m_strBiographyLabel, text);
}
function VirtualKeyboard_OnBackgroundInputBoxAccepted(string text, bool bWasSuccessful)
{
	OnBackgroundInputBoxClosed(bWasSuccessful ? text : "");
}

function VirtualKeyboard_OnBackgroundInputBoxCancelled()
{
	OnBackgroundInputBoxClosed("");
}

// --------------------------------------------------------------------------

simulated function CustomizeGender()
{
	CustomizeManager.UpdateCamera();
	Movie.Pres.UICustomize_Trait(m_strGender, "", CustomizeManager.GetCategoryList(eUICustomizeCat_Gender),
		ChangeGender, ChangeGender, CanCycleTo, CustomizeManager.GetCategoryIndex(eUICustomizeCat_Gender));
}
simulated function ChangeGender(UIList _list, int itemIndex)
{
	CustomizeManager.OnCategoryValueChange( eUICustomizeCat_Gender, 0, itemIndex );
	UIMouseGuard_RotatePawn(`SCREENSTACK.GetFirstInstanceOf(class'UIMouseGuard_RotatePawn')).SetActorPawn(CustomizeManager.ActorPawn);
}

// --------------------------------------------------------------------------

reliable client function CustomizeCountry()
{
	Movie.Pres.UICustomize_Trait( 
	class'UICustomize_Props'.default.m_strArmorPattern, "", CustomizeManager.GetCategoryList(eUICustomizeCat_Country),
		ChangeCountry, ChangeCountry, CanCycleTo, CustomizeManager.GetCategoryIndex(eUICustomizeCat_Country)); 
}

reliable client function ChangeCountry(UIList _list, int itemIndex)
{
	CustomizeManager.OnCategoryValueChange( eUICustomizeCat_Country, 0, itemIndex ); 
	UICustomize(Movie.Pres.ScreenStack.GetCurrentScreen()).Header.PopulateData(CustomizeManager.UpdatedUnitState);
}

//==============================================================================

simulated function AS_SetCharacterBio(string title, string bio)
{
	MC.BeginFunctionOp("setCharacterBio");
	MC.QueueString(title);
	MC.QueueString(bio);
	MC.EndOp();
}

// --------------------------------------------------------------------------
simulated function CustomizeVoice()
{
	CustomizeManager.UpdateCamera();
	if (Movie.IsMouseActive())
	{
		Movie.Pres.UICustomize_Trait(m_strVoice, "", CustomizeManager.GetCategoryList(eUICustomizeCat_Voice),
			none, ChangeVoice, CanCycleTo, CustomizeManager.GetCategoryIndex(eUICustomizeCat_Voice), m_strPreviewVoice, ChangeVoice);
	}
	else //IF MOUSELESS, calls custom class with voice-specific controls
	{
		//Below: copied/modified code from Movie.Pres.UICustomize_Trait() - wanted to keep Mouseless changes as minimal as possible, rather than create a new function in a different class - JTA
		Movie.Pres.ScreenStack.Push(Spawn(class'UICustomize_Voice', Movie.Pres), Movie.Pres.Get3DMovie());
		UICustomize_Trait(Movie.Pres.ScreenStack.GetCurrentScreen()).UpdateTrait(m_strVoice, "", CustomizeManager.GetCategoryList(eUICustomizeCat_Voice),
			none, ChangeVoice, CanCycleTo, CustomizeManager.GetCategoryIndex(eUICustomizeCat_Voice), m_strPreviewVoice, ChangeVoice);
	}
}
reliable client function ChangeVoice(UIList _list, int itemIndex)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_Voice, 0, itemIndex);
}

// --------------------------------------------------------------------------
reliable client function CustomizePersonality()
{
	CustomizeManager.UpdateCamera();
	Movie.Pres.UICustomize_Trait(m_strAttitude, "", CustomizeManager.GetCategoryList(eUICustomizeCat_Personality),
		ChangePersonality, ChangePersonality, CanCycleTo, CustomizeManager.GetCategoryIndex(eUICustomizeCat_Personality));
}

function ChangePersonality(UIList _list, int itemIndex)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_Personality, 1, itemIndex);
}