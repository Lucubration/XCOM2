//---------------------------------------------------------------------------------------
//  FILE:    UICustomize_Gear.uc
//  AUTHOR:  Brit Steiner --  8/29/2014
//  PURPOSE: Soldier gear options list. 
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class UICustomize_Props extends UICustomize;

//----------------------------------------------------------------------------
// MEMBERS

var string DEBUG_PrimaryColor; 
var string DEBUG_PrimaryColor_Label; 
var string DEBUG_SecondaryColor; 
var string DEBUG_SecondaryColor_Label; 

var localized string m_strTitle;
var localized string m_strUpperFaceProps;
var localized string m_strLowerFaceProps;
var localized string m_strHelmet;
var localized string m_strArms;
var localized string m_strTorso;
var localized string m_strLegs;
var localized string m_strArmorPattern;
var localized string m_strTattoosLeft;
var localized string m_strTattoosRight;
var localized string m_strTattooColor;
var localized string m_strScars;
var localized string m_strClearButton;
var localized string m_strFacePaint;
var localized string m_strWeaponName;
var localized string m_strWeaponPattern;

//Left arm / right arm selection
var localized string m_strLeftArm;
var localized string m_strRightArm;
var localized string m_strLeftArmDeco;
var localized string m_strRightArmDeco;

// XPack Hero deco selection
var localized string m_strLeftForearm;
var localized string m_strRightForearm;
var localized string m_strThighs;
var localized string m_strShins;
var localized string m_strTorsoDeco;

//----------------------------------------------------------------------------
// FUNCTIONS

simulated function UpdateData()
{
	local int i;
	local EUIState ColorState;	
	local int currentSel;
	currentSel = List.SelectedIndex;
	
	super.UpdateData();

	ColorState = bIsSuperSoldier ? eUIState_Disabled : eUIState_Normal;

	// HELMET
	//-----------------------------------------------------------------------------------------
	GetListItem(i++)
		.UpdateDataValue(CustomizeManager.CheckForAttentionIcon(eUICustomizeCat_Helmet) $ m_strHelmet, CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_Helmet, ColorState, FontSize), CustomizeHelmet)
		.SetDisabled(bIsSuperSoldier, m_strIsSuperSoldier);

	// DISABLE VETERAN OPTIONS
	ColorState = bDisableVeteranOptions ? eUIState_Disabled : eUIState_Normal;


	// FACE PAINT
	//-----------------------------------------------------------------------------------------

	//Check whether any face paint is available...	
	if(CustomizeManager.HasPartsForPartType("Facepaint", `XCOMGAME.SharedBodyPartFilter.FilterAny))
	{
		GetListItem(i++).UpdateDataValue(CustomizeManager.CheckForAttentionIcon(eUICustomizeCat_FacePaint) $ m_strFacePaint,
										 CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_FacePaint, eUIState_Normal, FontSize), CustomizeFacePaint);
	}


	// SCARS (VETERAN ONLY)
	//-----------------------------------------------------------------------------------------
	GetListItem(i++, bDisableVeteranOptions).UpdateDataValue(CustomizeManager.CheckForAttentionIcon(eUICustomizeCat_Scars) $ m_strScars,
		CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_Scars, ColorState, FontSize), CustomizeScars);

	if (currentSel > -1 && currentSel < List.ItemCount)
	{
		List.Navigator.SetSelected(List.GetItem(currentSel));
	}
	else
	{
		List.Navigator.SetSelected(List.GetItem(0));
	}
}


// --------------------------------------------------------------------------
reliable client function WeaponColorSelector()
{
	CustomizeManager.UpdateCamera(eUICustomizeCat_WeaponColor);
	ColorSelector = GetColorSelector(CustomizeManager.GetColorList(eUICustomizeCat_WeaponColor), PreviewWeaponColor, SetWeaponColor,
									int(CustomizeManager.GetCategoryDisplay(eUICustomizeCat_WeaponColor)));
}
function PreviewWeaponColor(int iColorIndex)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_WeaponColor, -1, iColorIndex);
}
function SetWeaponColor(int iColorIndex)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_WeaponColor, -1, iColorIndex);
	UpdateData();
}
// ------------------------------------------------------------------------
simulated function CustomizeHelmet()
{
	CustomizeManager.UpdateCamera();
	Movie.Pres.UICustomize_Trait(m_strHelmet, "", CustomizeManager.GetCategoryList(eUICustomizeCat_Helmet),
		ChangeHelmet, ChangeHelmet, CanCycleTo, CustomizeManager.GetCategoryIndex(eUICustomizeCat_Helmet));
}

simulated function ChangeHelmet(UIList _list, int itemIndex)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_Helmet, 0, itemIndex); 
}

// ------------------------------------------------------------------------

// ------------------------------------------------------------------------
simulated function CustomizeFacePaint()
{
	CustomizeManager.UpdateCamera();
	Movie.Pres.UICustomize_Trait(m_strFacePaint, "", CustomizeManager.GetCategoryList(eUICustomizeCat_FacePaint),
								 ChangeFacePaint, ChangeFacePaint, CanCycleTo, CustomizeManager.GetCategoryIndex(eUICustomizeCat_FacePaint));
}
simulated function ChangeFacePaint(UIList _list, int itemIndex)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_FacePaint, 0, itemIndex);
}
// ------------------------------------------------------------------------
simulated function CustomizeScars()
{
	CustomizeManager.UpdateCamera();
	Movie.Pres.UICustomize_Trait(m_strScars, "", CustomizeManager.GetCategoryList(eUICustomizeCat_Scars),
		ChangeScars, ChangeScars, CanCycleTo, CustomizeManager.GetCategoryIndex(eUICustomizeCat_Scars));
}
simulated function ChangeScars(UIList _list, int itemIndex)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_Scars, 0, itemIndex);
}




// --------------------------------------------------------------------------
simulated function CustomizeUpperFaceProps()
{
	CustomizeManager.UpdateCamera();
	Movie.Pres.UICustomize_Trait(m_strUpperFaceProps, "", CustomizeManager.GetCategoryList(eUICustomizeCat_FaceDecorationUpper),
		ChangeFaceUpperProps, ChangeFaceUpperProps, CanCycleTo, CustomizeManager.GetCategoryIndex(eUICustomizeCat_FaceDecorationUpper));
}
simulated function ChangeFaceUpperProps(UIList _list, int itemIndex)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_FaceDecorationUpper, 0, itemIndex);
}
// --------------------------------------------------------------------------
simulated function CustomizeLowerFaceProps()
{
	CustomizeManager.UpdateCamera();
	Movie.Pres.UICustomize_Trait(m_strLowerFaceProps, "", CustomizeManager.GetCategoryList(eUICustomizeCat_FaceDecorationLower),
		ChangeFaceLowerProps, ChangeFaceLowerProps, CanCycleTo, CustomizeManager.GetCategoryIndex(eUICustomizeCat_FaceDecorationLower));
}
simulated function ChangeFaceLowerProps(UIList _list, int itemIndex)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_FaceDecorationLower, 0, itemIndex);
}
//==============================================================================
