//---------------------------------------------------------------------------------------
//  FILE:    UICustomize_Weapon.uc
//  PURPOSE: Soldier gear options list. 
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class UICustomize_Weapon extends UICustomize;

var localized string m_strTitle;
var localized string m_strWeaponName;
var localized string m_strWeaponColor;
var localized string m_strWeaponPattern;

//----------------------------------------------------------------------------
// FUNCTIONS

simulated function UpdateData()
{
	local int i;
	local int currentSel;
	currentSel = List.SelectedIndex;
	
	super.UpdateData();

	// WEAPON PRIMARY COLOR
	//-----------------------------------------------------------------------------------------
	GetListItem(i++).UpdateDataColorChip(CustomizeManager.CheckForAttentionIcon(eUICustomizeCat_WeaponColor)$ m_strWeaponColor,
		CustomizeManager.GetCurrentDisplayColorHTML(eUICustomizeCat_WeaponColor), WeaponColorSelector);

	// WEAPON PATTERN
	//-----------------------------------------------------------------------------------------
	GetListItem(i++).UpdateDataValue(CustomizeManager.CheckForAttentionIcon(eUICustomizeCat_WeaponPatterns) $ m_strWeaponPattern,
		CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_WeaponPatterns, eUIState_Normal, FontSize), CustomizeWeaponPattern);

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
// --------------------------------------------------------------------------
simulated function CustomizeWeaponPattern()
{
	CustomizeManager.UpdateCamera();
	Movie.Pres.UICustomize_Trait(m_strWeaponPattern, "", CustomizeManager.GetCategoryList(eUICustomizeCat_WeaponPatterns),
		ChangeWeaponPattern, ChangeWeaponPattern, CanCycleTo, CustomizeManager.GetCategoryIndex(eUICustomizeCat_WeaponPatterns));
}
simulated function ChangeWeaponPattern(UIList _list, int itemIndex)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_WeaponPatterns, 0, itemIndex);
}