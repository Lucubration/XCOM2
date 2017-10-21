//---------------------------------------------------------------------------------------
//  FILE:    UICustomize_SparkProps.uc
//  AUTHOR:  Joe Weinhoffer --  2/22/2016
//  PURPOSE: Spark gear options list. 
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class UICustomize_SparkProps extends UICustomize;

//----------------------------------------------------------------------------
// MEMBERS

var string DEBUG_PrimaryColor;
var string DEBUG_PrimaryColor_Label;
var string DEBUG_SecondaryColor;
var string DEBUG_SecondaryColor_Label;

var localized string m_strTitle;
var localized string m_strArms;
var localized string m_strTorso;
var localized string m_strLegs;
var localized string m_strArmorPattern;
var localized string m_strWeaponName;
var localized string m_strWeaponColor;
var localized string m_strWeaponPattern;
var localized string m_strClearButton;

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
	local int currentSel;
	currentSel = List.SelectedIndex;
	
	
		
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
simulated function CustomizeArmorPattern()
{
	CustomizeManager.UpdateCamera();
	Movie.Pres.UICustomize_Trait(m_strArmorPattern, "", CustomizeManager.GetCategoryList(eUICustomizeCat_ArmorPatterns),
		ChangeArmorPattern, ChangeArmorPattern, CanCycleTo, CustomizeManager.GetCategoryIndex(eUICustomizeCat_ArmorPatterns));
}
simulated function ChangeArmorPattern(UIList _list, int itemIndex)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_ArmorPatterns, 0, itemIndex);
}
// ------------------------------------------------------------------------
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
// --------------------------------------------------------------------------
simulated function CustomizeArms()
{
	CustomizeManager.UpdateCamera();
	Movie.Pres.UICustomize_Trait(m_strArms, "", CustomizeManager.GetCategoryList(eUICustomizeCat_Arms),
		ChangeArms, ChangeArms, CanCycleTo, CustomizeManager.GetCategoryIndex(eUICustomizeCat_Arms));
}
simulated function ChangeArms(UIList _list, int itemIndex)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_Arms, 0, itemIndex);
}

// --------------------------------------------------------------------------
simulated function CustomizeTorso()
{
	CustomizeManager.UpdateCamera();
	Movie.Pres.UICustomize_Trait(m_strTorso, "", CustomizeManager.GetCategoryList(eUICustomizeCat_Torso),
		ChangeTorso, ChangeTorso, CanCycleTo, CustomizeManager.GetCategoryIndex(eUICustomizeCat_Torso));
}
simulated function ChangeTorso(UIList _list, int itemIndex)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_Torso, 0, itemIndex);
}
// --------------------------------------------------------------------------
simulated function CustomizeLegs()
{
	CustomizeManager.UpdateCamera();
	Movie.Pres.UICustomize_Trait(m_strLegs, "", CustomizeManager.GetCategoryList(eUICustomizeCat_Legs),
		ChangeLegs, ChangeLegs, CanCycleTo, CustomizeManager.GetCategoryIndex(eUICustomizeCat_Legs));
}
simulated function ChangeLegs(UIList _list, int itemIndex)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_Legs, 0, itemIndex);
}
//==============================================================================