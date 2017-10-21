//---------------------------------------------------------------------------------------
//  FILE:    UICustomize_SparkWeapon.uc
//  AUTHOR:  Joe Cortese--  2/17/2017
//  PURPOSE: Spark gear options list. 
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class UICustomize_SparkWeapon extends UICustomize;

//----------------------------------------------------------------------------
// MEMBERS
var localized string m_strTitle;

//----------------------------------------------------------------------------
// FUNCTIONS

// Override to use correct menu class
simulated function UpdateCustomizationManager()
{
	if (Movie.Pres.m_kCustomizeManager == none)
	{
		Unit = UICustomize_SparkMenu(Movie.Stack.GetScreen(class'UICustomize_SparkMenu')).Unit;
		UnitRef = UICustomize_SparkMenu(Movie.Stack.GetScreen(class'UICustomize_SparkMenu')).UnitRef;
		Movie.Pres.InitializeCustomizeManager(Unit);
	}
}

simulated function UpdateData()
{
	local int i;
	local UIMechaListItem ListItem;
	local int currentSel;
	currentSel = List.SelectedIndex;

	super.UpdateData();

	// WEAPON PATTERN
	//-----------------------------------------------------------------------------------------
	ListItem = GetListItem(i++);
	ListItem.UpdateDataValue(class'UICustomize_SparkProps'.default.m_strWeaponPattern,
		CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_WeaponPatterns, eUIState_Normal, FontSize), CustomizeWeaponPattern);

	// WEAPON PRIMARY COLOR
	//-----------------------------------------------------------------------------------------
	ListItem = GetListItem(i++);
	ListItem.UpdateDataColorChip(class'UICustomize_SparkMenu'.default.m_strWeaponColor,
		CustomizeManager.GetCurrentDisplayColorHTML(eUICustomizeCat_WeaponColor), WeaponColorSelector);

	if (currentSel > -1 && currentSel < List.ItemCount)
	{
		List.Navigator.SetSelected(List.GetItem(currentSel));
	}
	else
	{
		List.Navigator.SetSelected(List.GetItem(0));
	}
}
// ------------------------------------------------------------------------
simulated function CustomizeWeaponPattern()
{
	CustomizeManager.UpdateCamera();
	Movie.Pres.UICustomize_Trait(class'UICustomize_SparkProps'.default.m_strWeaponPattern, "", CustomizeManager.GetCategoryList(eUICustomizeCat_WeaponPatterns),
		ChangeWeaponPattern, ChangeWeaponPattern, CanCycleTo, CustomizeManager.GetCategoryIndex(eUICustomizeCat_WeaponPatterns));
}
simulated function ChangeWeaponPattern(UIList _list, int itemIndex)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_WeaponPatterns, 0, itemIndex);
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