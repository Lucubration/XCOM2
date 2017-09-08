//---------------------------------------------------------------------------------------
//  FILE:    UICustomize_Menu.uc
//  AUTHOR:  Brit Steiner --  8/28/2014
//  PURPOSE:Soldier category options list. 
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class UICustomize_Menu extends UICustomize;

//----------------------------------------------------------------------------
// MEMBERS

var localized string m_strTitle;
var localized string m_strEditInfo;
var localized string m_strEditProps;
var localized string m_strEditHead;
var localized string m_strEditBody;
var localized string m_strEditWeapon;

//var localized string m_strType;

// Character Pool
var localized string m_strCustomizeClass;
var localized string m_strViewClass;
var localized string m_strExportCharacter;

var localized string m_strAllowTypeSoldier;
var localized string m_strAllowTypeVIP;
var localized string m_strAllowTypeDarkVIP;
var localized string m_strAllowed;

var localized string m_strTimeAdded;

var localized string m_strExportSuccessTitle;
var localized string m_strExportSuccessBody;

//----------------------------------------------------------------------------
// FUNCTIONS

simulated function OnListInited(UIPanel Panel)
{
	local int i;
	
	super.OnListInited(Panel);
	
	// Set the bReadOnly to true so that we don't get double click feedback from the list event also setting the checkbox
	for(i = 0;i < List.ItemCount;i++)
	{		
		if (UIMechaListItem(List.GetItem(i)).Checkbox != none)
		{
			GetListItem(i).Checkbox.bReadOnly = true;
		}
	}
}

simulated function UpdateData()
{
	local int i;
	local int currentSel;
	local bool bBasicSoldierClass;
	currentSel = List.SelectedIndex;

	super.UpdateData();

	// Hide all existing options since the number of options can change if player switches genders
	HideListItems();

	CustomizeManager.UpdateBodyPartFilterForNewUnit(CustomizeManager.Unit);

	// INFO
	//-----------------------------------------------------------------------------------------
	GetListItem(i++).UpdateDataDescription(CustomizeManager.CheckForAttentionIcon(eUICustomizeCat_FirstName)$ m_strEditInfo, OnCustomizeInfo);

	// HEAD
	//-----------------------------------------------------------------------------------------
	GetListItem(i++).UpdateDataDescription(CustomizeManager.CheckForAttentionIcon(eUICustomizeCat_NickName)$ m_strEditHead, OnCustomizeHead);

	// BODY
	//-----------------------------------------------------------------------------------------
	GetListItem(i++).UpdateDataDescription(CustomizeManager.CheckForAttentionIcon(eUICustomizeCat_NickName)$ m_strEditBody, OnCustomizeBody);

	// WEAPON
	//-----------------------------------------------------------------------------------------
	GetListItem(i++).UpdateDataDescription(CustomizeManager.CheckForAttentionIcon(eUICustomizeCat_NickName)$ m_strEditWeapon, OnCustomizeWeapon);

	//  CHARACTER POOL OPTIONS
	//-----------------------------------------------------------------------------------------
	//If in the armory, allow exporting character to the pool
	if (bInArmory) 
	{
		GetListItem(i++).UpdateDataDescription(m_strExportCharacter, OnExportSoldier);
	}
	else //Otherwise, allow customizing their potential appearances
	{
		if(!bInMP)
		{
			if (Unit.IsSoldier())
			{
				GetListItem(i++).UpdateDataValue(m_strCustomizeClass,
					CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_Class, eUIState_Normal, FontSize), CustomizeClass, true);

				bBasicSoldierClass = (Unit.GetSoldierClassTemplate().RequiredCharacterClass == '');
				GetListItem(i++, !bBasicSoldierClass, m_strNoClassVariants).UpdateDataValue(m_strViewClass,
					CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_ViewClass, bBasicSoldierClass ? eUIState_Normal : eUIState_Disabled, FontSize), CustomizeViewClass, true);
			}
			
			GetListItem(i++).UpdateDataCheckbox(m_strAllowTypeSoldier, m_strAllowed, CustomizeManager.UpdatedUnitState.bAllowedTypeSoldier, OnCheckbox_Type_Soldier);
			GetListItem(i++).UpdateDataCheckbox(m_strAllowTypeVIP, m_strAllowed, CustomizeManager.UpdatedUnitState.bAllowedTypeVIP, OnCheckbox_Type_VIP);
			GetListItem(i++).UpdateDataCheckbox(m_strAllowTypeDarkVIP, m_strAllowed, CustomizeManager.UpdatedUnitState.bAllowedTypeDarkVIP, OnCheckbox_Type_DarkVIP);

			GetListItem(i).UpdateDataDescription(m_strTimeAdded @ CustomizeManager.UpdatedUnitState.PoolTimestamp, None);
			GetListItem(i++).SetDisabled(true);
		}
	}
	
	List.OnItemClicked = OnListOptionClicked;

	Navigator.SetSelected(List);
	
	if (currentSel > -1 && currentSel < List.ItemCount)
	{
		//Don't use GetItem(..), because it overwrites enable.disable option indiscriminately. 
		List.Navigator.SetSelected(List.GetItem(currentSel));
	}
	else
	{
		//Don't use GetItem(..), because it overwrites enable.disable option indiscriminately. 
		List.Navigator.SelectFirstAvailable();
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

simulated function OnListOptionClicked(UIList ContainerList, int ItemIndex)
{
	local UICheckbox CheckedBox;
	CheckedBox = UIMechaListItem(List.GetItem(ItemIndex)).Checkbox;
	CheckedBox.SetChecked(!CheckedBox.bChecked);
	
	Movie.Pres.PlayUISound(eSUISound_MenuSelect);
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
simulated function OnCustomizeHead()
{
	CustomizeManager.UpdateCamera(eUICustomizeCat_Face);
	Movie.Pres.UICustomize_Head(Unit);
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

reliable client function CustomizeViewClass()
{
	CustomizeManager.UpdateCamera();
	Movie.Pres.UICustomize_Trait(m_strViewClass, "", CustomizeManager.GetCategoryList(eUICustomizeCat_ViewClass),
		none, ViewClass, CanCycleTo, CustomizeManager.GetCategoryIndex(eUICustomizeCat_ViewClass));
}

reliable client function ViewClass(UIList _list, int itemIndex)
{
	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_ViewClass, 0, itemIndex);
}

reliable client function CustomizeClass()
{
	CustomizeManager.UpdateCamera();
	Movie.Pres.UICustomize_Trait(m_strCustomizeClass, "", CustomizeManager.GetCategoryList(eUICustomizeCat_Class), 
		none, ChangeClass, CanCycleTo, CustomizeManager.GetCategoryIndex(eUICustomizeCat_Class));
}

reliable client function ChangeClass(UIList _list, int itemIndex)
{
	CustomizeManager.OnCategoryValueChange( eUICustomizeCat_Class, 0, itemIndex); 
}

simulated static function bool CanCycleToAttitude(XComGameState_Unit NewUnit)
{
	return CanCycleTo(NewUnit) && NewUnit.IsVeteran();
}

// ------------------------------------------------------------------------

simulated function Remove()
{
	if(CustomizeManager.ActorPawn != none)
	{
		// Restore the character's default idle animation
		XComHumanPawn(CustomizeManager.ActorPawn).CustomizationIdleAnim = '';
		XComHumanPawn(CustomizeManager.ActorPawn).PlayHQIdleAnim();
	}

	Movie.Pres.DeactivateCustomizationManager(true);
	super.Remove();
}

//bsg-hlee (05.24.17): Taken from UICharacterPool.uc to make check boxes work.
simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local bool bHandled;

	if( !bIsFocused || !bIsVisible)
		return false;

	if( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	bHandled = false;

	switch( cmd )
	{
		case class'UIUtilities_Input'.const.FXS_BUTTON_A:
			if(List.ItemCount > 0)
			{
				if(UIMechaListItem(List.GetSelectedItem()).Checkbox != None)
				{
					SimulateMouseClickOnCheckbox();
					bHandled = true;
				}
			}
	}

	return bHandled || super.OnUnrealCommand(cmd, arg);
}

simulated function SimulateMouseClickOnCheckbox()
{
	local UIMechaListItem ListItem;

	ListItem = UIMechaListItem(List.GetSelectedItem());
	if(ListItem != None)
	{
		if(ListItem.CheckBox != None)
		{
			ListItem.Checkbox.SetChecked(!ListItem.Checkbox.bChecked);
			Movie.Pres.PlayUISound(eSUISound_MenuSelect);
		}
	}
}
//bsg-hlee (05.24.17): End

//==============================================================================

defaultproperties
{
	CameraTag = "UIBlueprint_CustomizeMenu";
	DisplayTag = "UIBlueprint_CustomizeMenu";
}