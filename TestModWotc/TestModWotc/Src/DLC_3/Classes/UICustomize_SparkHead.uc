//---------------------------------------------------------------------------------------
//  FILE:    UICustomize_SparkHead.uc
//  AUTHOR:  Joe Cortese--  2/17/2017
//  PURPOSE: Spark gear options list. 
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class UICustomize_SparkHead extends UICustomize;

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
	
	// HEAD
	//-----------------------------------------------------------------------------------------
	ListItem = GetListItem(i++);
	ListItem.UpdateDataValue(class'UICustomize_SparkMenu'.default.m_strHead,
		CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_Face, eUIState_Normal, FontSize), CustomizeHead);
		
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
simulated function CustomizeHead()
{
	CustomizeManager.UpdateCamera();
	Movie.Pres.UICustomize_Trait(class'UICustomize_SparkMenu'.default.m_strHead, "", CustomizeManager.GetCategoryList(eUICustomizeCat_Face),
		ChangeHead, ChangeHead, CanCycleTo, CustomizeManager.GetCategoryIndex(eUICustomizeCat_Face));

	//spark would overlap UI otherwise
	UIMouseGuard_RotatePawn(`SCREENSTACK.GetFirstInstanceOf(class'UIMouseGuard_RotatePawn')).ActorRotation.Yaw = -10142;
	UIMouseGuard_RotatePawn(`SCREENSTACK.GetFirstInstanceOf(class'UIMouseGuard_RotatePawn')).SetCanRotate(false);
}
reliable client function ChangeHead(UIList _list, int itemIndex)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_Face, 0, itemIndex);
}

defaultproperties
{
	CameraTag = "UIBlueprint_CustomizeMenu";
	DisplayTag = "UIBlueprint_CustomizeMenu";
	bUsePersonalityAnim = false;
}