//---------------------------------------------------------------------------------------
//  FILE:    UICustomize_SparkMenu.uc
//  AUTHOR:  Joe Weinhoffer --  2/19/2016
//  PURPOSE:Spark category options list for DLC. 
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class UICustomize_SparkMenu extends UICustomize;

//----------------------------------------------------------------------------
// MEMBERS

var localized string m_strTitle;
var localized string m_strEditInfo;
var localized string m_strEditProps;
var localized string m_strHead;
var localized string m_strHair;
var localized string m_strMainColor;
var localized string m_strSecondaryColor;
var localized string m_strWeaponColor;

var localized string m_strVoice;
var localized string m_strPreviewVoice;

// Character Pool
var localized string m_strExportCharacter;

var localized string m_strAllowTypeSoldier;
var localized string m_strAllowed;

var localized string m_strTimeAdded;

var localized string m_strExportSuccessTitle;
var localized string m_strExportSuccessBody;

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

	// Hide all existing options since the number of options can change if player switches genders
	HideListItems();

	CustomizeManager.UpdateBodyPartFilterForNewUnit(CustomizeManager.Unit);
	
	// INFO
	//-----------------------------------------------------------------------------------------
	ListItem = GetListItem(i++);
	ListItem.UpdateDataDescription(m_strEditInfo, OnCustomizeInfo);

	// HEAD
	//-----------------------------------------------------------------------------------------
	ListItem = GetListItem(i++);
	ListItem.UpdateDataValue(m_strHead,	CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_Face, eUIState_Normal, FontSize), CustomizeHead);
	
	// BODY
	//-----------------------------------------------------------------------------------------
	ListItem = GetListItem(i++);
	ListItem.UpdateDataDescription(class'UICustomize_Menu'.default.m_strEditBody, OnCustomizeBody);

	// WEAPON
	//-----------------------------------------------------------------------------------------
	ListItem = GetListItem(i++);
	ListItem.UpdateDataDescription(class'UICustomize_Menu'.default.m_strEditWeapon, OnCustomizeWeapon);

		
	//  CHARACTER POOL OPTIONS
	//-----------------------------------------------------------------------------------------
	//If in the armory, allow exporting character to the pool
	if (bInArmory)
	{
		ListItem = GetListItem(i++);
		ListItem.UpdateDataDescription(m_strExportCharacter, OnExportSoldier);
	}
	else //Otherwise, allow customizing their potential appearances
	{
		if (!bInMP)
		{
			if (Unit.IsSoldier())
				GetListItem(i++).UpdateDataValue(class'UICustomize_Menu'.default.m_strCustomizeClass,
					CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_Class, eUIState_Normal, FontSize), CustomizeClass, true);

			ListItem = GetListItem(i++);
			ListItem.UpdateDataCheckbox(m_strAllowTypeSoldier, m_strAllowed, CustomizeManager.UpdatedUnitState.bAllowedTypeSoldier, OnCheckbox_Type_Soldier);
			
			ListItem = GetListItem(i);
			ListItem.UpdateDataDescription(m_strTimeAdded @ CustomizeManager.UpdatedUnitState.PoolTimestamp, None);

			ListItem = GetListItem(i++);
			ListItem.SetDisabled(true);
		}
	}

	if (currentSel > -1 && currentSel < List.ItemCount)
	{
		List.Navigator.SetSelected(List.GetItem(currentSel));
	}
	else
	{
		List.Navigator.SetSelected(List.GetItem(0));
	}
	//-----------------------------------------------------------------------------------------
}

simulated function OnExportSoldier()
{
	local TDialogueBoxData kDialogData;

	//Add to pool and save
	local CharacterPoolManager cpm;
	cpm = CharacterPoolManager(`XENGINE.GetCharacterPoolManager());
	CustomizeManager.Unit.PoolTimestamp = class'X2StrategyGameRulesetDataStructures'.static.GetSystemDateTimeString();
	cpm.CharacterPool.AddItem(CustomizeManager.Unit);
	cpm.SaveCharacterPool();

	//Inform the user
	kDialogData.eType = eDialog_Normal;
	kDialogData.strTitle = m_strExportSuccessTitle;
	kDialogData.strText = m_strExportSuccessBody;
	kDialogData.strAccept = class'UIUtilities_Text'.default.m_strGenericAccept;
	Movie.Pres.UIRaiseDialog(kDialogData);
}

// --------------------------------------------------------------------------
simulated function CustomizeHead()
{
	CustomizeManager.UpdateCamera(eUICustomizeCat_Torso);
	Movie.Pres.UICustomize_Trait(class'UICustomize_SparkMenu'.default.m_strHead, "", CustomizeManager.GetCategoryList(eUICustomizeCat_Face),
		ChangeHead, ChangeHead, CanCycleTo, CustomizeManager.GetCategoryIndex(eUICustomizeCat_Face));

	//spark would overlap UI otherwise
	UIMouseGuard_RotatePawn(`SCREENSTACK.GetFirstInstanceOf(class'UIMouseGuard_RotatePawn')).ActorRotation.Yaw = -10142;
	UIMouseGuard_RotatePawn(`SCREENSTACK.GetFirstInstanceOf(class'UIMouseGuard_RotatePawn')).SetCanRotate(false);
	UICustomize_Trait(Movie.Pres.ScreenStack.GetCurrentScreen()).CameraTag = "UIBlueprint_CustomizeMenu";
	UICustomize_Trait(Movie.Pres.ScreenStack.GetCurrentScreen()).DisplayTag = 'UIBlueprint_CustomizeMenu';
}
reliable client function ChangeHead(UIList _list, int itemIndex)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_Face, 0, itemIndex);
}

// --------------------------------------------------------------------------
simulated function OnCustomizeInfo()
{
	CustomizeManager.UpdateCamera();
	Movie.Pres.UICustomize_Info(Unit);
}
// --------------------------------------------------------------------------
simulated function OnCustomizeProps()
{
	CustomizeManager.UpdateCamera();
	Movie.Pres.UICustomize_Props(Unit);
}
// --------------------------------------------------------------------------
simulated function OnCustomizeBody()
{
	CustomizeManager.UpdateCamera();
	Movie.Pres.UICustomize_Body(Unit);
}
// --------------------------------------------------------------------------
simulated function OnCustomizeWeapon()
{
	CustomizeManager.UpdateCamera();
	Movie.Pres.UICustomize_Weapon(Unit);
}

// ------------------------------------------------------------------------

reliable client function OnCheckbox_Type_Soldier(UICheckbox Checkbox)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_AllowTypeSoldier, 0, Checkbox.bChecked ? 1 : 0);
}

reliable client function OnCheckbox_Type_VIP(UICheckbox Checkbox)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_AllowTypeVIP, 0, Checkbox.bChecked ? 1 : 0);
}

reliable client function OnCheckbox_Type_DarkVIP(UICheckbox Checkbox)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_AllowTypeDarkVIP, 0, Checkbox.bChecked ? 1 : 0);
}

reliable client function CustomizeClass()
{
	CustomizeManager.UpdateCamera();
	Movie.Pres.UICustomize_Trait(class'UICustomize_Menu'.default.m_strCustomizeClass, "", CustomizeManager.GetCategoryList(eUICustomizeCat_Class),
		none, ChangeClass, CanCycleTo, CustomizeManager.GetCategoryIndex(eUICustomizeCat_Class));
}

reliable client function ChangeClass(UIList _list, int itemIndex)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_Class, 0, itemIndex);
}

// ------------------------------------------------------------------------

simulated function Remove()
{
	if (CustomizeManager.ActorPawn != none)
	{
		// Restore the character's default idle animation
		XComHumanPawn(CustomizeManager.ActorPawn).CustomizationIdleAnim = '';
		XComHumanPawn(CustomizeManager.ActorPawn).PlayHQIdleAnim();
	}

	Movie.Pres.DeactivateCustomizationManager(true);
	super.Remove();
}

//==============================================================================