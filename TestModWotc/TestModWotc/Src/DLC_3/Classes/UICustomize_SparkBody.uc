//---------------------------------------------------------------------------------------
//  FILE:    UICustomize_SparkBody.uc
//  AUTHOR:  Joe Cortese--  2/17/2017
//  PURPOSE: Spark gear options list. 
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class UICustomize_SparkBody extends UICustomize;

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
	local bool bHasOptions;
	local EUIState ColorState;
	local UIMechaListItem ListItem;
	local int currentSel;
	currentSel = List.SelectedIndex;

	super.UpdateData();

	// ARMS
	//-----------------------------------------------------------------------------------------
	if (CustomizeManager.HasPartsForPartType("Arms", `XCOMGAME.SharedBodyPartFilter.FilterByTorsoAndArmorMatch))
	{
		ListItem = GetListItem(i++);
		ListItem.UpdateDataValue(class'UICustomize_SparkProps'.default.m_strArms,
			CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_Arms, , FontSize), CustomizeArms);
	}

	// LEGS
	//-----------------------------------------------------------------------------------------
	if (CustomizeManager.HasPartsForPartType("Legs", `XCOMGAME.SharedBodyPartFilter.FilterByTorsoAndArmorMatch))
	{
		ListItem = GetListItem(i++);
		ListItem.UpdateDataValue(class'UICustomize_SparkProps'.default.m_strLegs,
			CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_Legs, , FontSize), CustomizeLegs);
	}

	// TORSO
	//-----------------------------------------------------------------------------------------
	bHasOptions = CustomizeManager.HasMultipleCustomizationOptions(eUICustomizeCat_Torso);
	ColorState = bHasOptions ? eUIState_Normal : eUIState_Disabled;

	ListItem = GetListItem(i++, !bHasOptions, m_strNoVariations);
	ListItem.UpdateDataValue(class'UICustomize_SparkProps'.default.m_strTorso,
		CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_Torso, ColorState, FontSize), CustomizeTorso);
	
	// ARMOR PRIMARY COLOR
	//-----------------------------------------------------------------------------------------
	ListItem = GetListItem(i++);
	ListItem.UpdateDataColorChip(class'UICustomize_SparkMenu'.default.m_strMainColor,
		CustomizeManager.GetCurrentDisplayColorHTML(eUICustomizeCat_PrimaryArmorColor), PrimaryArmorColorSelector);

	// ARMOR SECONDARY COLOR
	//-----------------------------------------------------------------------------------------
	ListItem = GetListItem(i++);
	ListItem.UpdateDataColorChip(class'UICustomize_SparkMenu'.default.m_strSecondaryColor,
		CustomizeManager.GetCurrentDisplayColorHTML(eUICustomizeCat_SecondaryArmorColor), SecondaryArmorColorSelector);

	// ARMOR PATTERN (VETERAN ONLY)
	//-----------------------------------------------------------------------------------------
	ListItem = GetListItem(i++);
	ListItem.UpdateDataValue(class'UICustomize_SparkProps'.default.m_strArmorPattern,
		CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_ArmorPatterns, eUIState_Normal, FontSize), CustomizeArmorPattern);

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
simulated function CustomizeArmorPattern()
{
	CustomizeManager.UpdateCamera();
	Movie.Pres.UICustomize_Trait(class'UICustomize_SparkProps'.default.m_strArmorPattern, "", CustomizeManager.GetCategoryList(eUICustomizeCat_ArmorPatterns),
		ChangeArmorPattern, ChangeArmorPattern, CanCycleTo, CustomizeManager.GetCategoryIndex(eUICustomizeCat_ArmorPatterns));
}
simulated function ChangeArmorPattern(UIList _list, int itemIndex)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_ArmorPatterns, 0, itemIndex);
}
// --------------------------------------------------------------------------
simulated function CustomizeArms()
{
	CustomizeManager.UpdateCamera();
	Movie.Pres.UICustomize_Trait(class'UICustomize_SparkProps'.default.m_strArms, "", CustomizeManager.GetCategoryList(eUICustomizeCat_Arms),
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
	Movie.Pres.UICustomize_Trait(class'UICustomize_SparkProps'.default.m_strTorso, "", CustomizeManager.GetCategoryList(eUICustomizeCat_Torso),
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
	Movie.Pres.UICustomize_Trait(class'UICustomize_SparkProps'.default.m_strLegs, "", CustomizeManager.GetCategoryList(eUICustomizeCat_Legs),
		ChangeLegs, ChangeLegs, CanCycleTo, CustomizeManager.GetCategoryIndex(eUICustomizeCat_Legs));
}
simulated function ChangeLegs(UIList _list, int itemIndex)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_Legs, 0, itemIndex);
}
// --------------------------------------------------------------------------
reliable client function PrimaryArmorColorSelector()
{
	CustomizeManager.UpdateCamera(eUICustomizeCat_PrimaryArmorColor);
	ColorSelector = GetColorSelector(CustomizeManager.GetColorList(eUICustomizeCat_PrimaryArmorColor),
		PreviewPrimaryArmorColor, SetPrimaryArmorColor, int(CustomizeManager.GetCategoryDisplay(eUICustomizeCat_PrimaryArmorColor)));
}
function PreviewPrimaryArmorColor(int iColorIndex)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_PrimaryArmorColor, -1, iColorIndex);
}
function SetPrimaryArmorColor(int iColorIndex)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_PrimaryArmorColor, -1, iColorIndex);
	UpdateData();
}
// --------------------------------------------------------------------------
reliable client function SecondaryArmorColorSelector()
{
	CustomizeManager.UpdateCamera(eUICustomizeCat_SecondaryArmorColor);
	ColorSelector = GetColorSelector(CustomizeManager.GetColorList(eUICustomizeCat_SecondaryArmorColor),
		PreviewSecondaryArmorColor, SetSecondaryArmorColor, int(CustomizeManager.GetCategoryDisplay(eUICustomizeCat_SecondaryArmorColor)));
}
function PreviewSecondaryArmorColor(int iColorIndex)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_SecondaryArmorColor, -1, iColorIndex);
}
function SetSecondaryArmorColor(int iColorIndex)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_SecondaryArmorColor, -1, iColorIndex);
	UpdateData();
}
//==============================================================================