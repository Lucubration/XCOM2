//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIShellNarrativeContent.uc
//  AUTHOR:  Mark Nauta --2/4/2016

//  PURPOSE: Controls enabling optional narrative content for the campaign. 
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIShellNarrativeContent extends UIScreen
	dependson(XComOnlineProfileSettingsDataBlob);

var localized string NarrativeContentTitle;
var localized string DLCSubTitle;
var localized string m_strXPACKNarrativeHeader;
var localized string IntegratedDLCOption;
var localized string XPACKNarrativeOption;
var localized string XPACKNarrativeWithTutorialOptionDesc;
var localized string m_strDisableXpackNarrativeTitle;
var localized string m_strDisableXpackNarrativeBody;
var localized string m_strDisableXpackNarrativeYes;
var localized string m_strDisableXpackNarrativeNo;
var localized string IntegratedDLCDesc;
var localized string XPACKNarrativeOptionDesc;
var localized string XPACKNarrativeWithTutorialTooltip;

var UIList           m_List;
//var UIButton         m_CancelButton;
var UILargeButton    m_StartButton;
var UIMechaListItem	 m_XpacknarrativeMechaItem; 
var UIX2PanelHeader	 m_HeaderPanel;

var array<name> EnabledOptionalNarrativeDLC; // DLC Identifiers with enabled optional narrative content
var private array<X2DownloadableContentInfo> DLCInfos; // All DLC infos that have optional narrative content (forms the list of checkboxes)
var private bool bCheckboxUpdate;
var bool m_bShowedXpackNarrtiveNotice;
var bool bEnabledIntegratedDLC; // Is Integrated DLC enabled for the XPack
var bool m_bTutorial;

var UINavigationHelp NavHelp; //bsg-hlee (05.05.17): Moving this here for other nav help functions.

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	super.InitScreen(InitController, InitMovie, InitName);
	
	m_HeaderPanel = Spawn(class'UIX2PanelHeader', self);
	m_HeaderPanel.bAnimateOnInit = false;
	m_HeaderPanel.InitPanelHeader('', NarrativeContentTitle);
	m_HeaderPanel.SetHeaderWidth(740, false);
	m_HeaderPanel.SetPosition(-425, 18);

	m_HeaderPanel.DisableNavigation();

	m_XpacknarrativeMechaItem = Spawn(class'UIMechaListItem', self);
	m_XpacknarrativeMechaItem.bAnimateOnInit = false;
	m_XpacknarrativeMechaItem.width = 270;
	m_XpacknarrativeMechaItem.InitListItem('XPackNarrativeListItemMC');
	m_XpacknarrativeMechaItem.OnMouseEventDelegate = OnXpackNarrativeMouseEvent;

	m_List = Spawn(class'UIList', self);
	m_List.InitList('difficultyListMC');
	m_List.bPermitNavigatorToDefocus = true;
	m_List.Navigator.LoopSelection = false;
	m_List.Navigator.LoopOnReceiveFocus = false;
	m_List.bCascadeSelection = true;
	m_List.bCascadeFocus = true;
	m_List.SetHeight(330);
	m_List.OnItemClicked = OnClicked;
	m_List.OnSetSelectedIndex = OnSetSelectedIndex;

	//m_CancelButton = Spawn(class'UIButton', self);
	//m_CancelButton.bIsNavigable = false;
	//m_CancelButton.InitButton('difficultyCancelButton').Hide();

	NavHelp = Movie.Pres.GetNavHelp();
	UpdateNavHelp(); //bsg-hlee (05.05.17): Added to function call.
	
	m_StartButton = Spawn(class'UILargeButton', self);
	m_StartButton.InitLargeButton('narrativeLaunchButton', GetStartButtonText(), "", ConfirmNarrativeContent);
	if( `ISCONTROLLERACTIVE ) 
		m_StartButton.DisableNavigation();

	Navigator.SetSelected(m_StartButton);
	//m_List.Navigator.SetSelected(m_List.GetItem(m_List.SelectedIndex));
}

simulated function string GetStartButtonText()
{
	local String strLabel;

	strLabel = class'UIUtilities_Text'.default.m_strGenericContinue;

	if( `ISCONTROLLERACTIVE )
	{
		strLabel = class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_X_SQUARE, 26, 26, -10) @ strLabel; //bsg-jneal (2.2.17): fix for InjectImage calls not using platform prefix for button icons
	}

	return strLabel;
}

simulated function OnInit()
{
	super.OnInit();
	SetX(570);
	BuildMenu();	
}

simulated function BuildMenu()
{
	local XComOnlineProfileSettings m_kProfileSettings;
	local array<X2DownloadableContentInfo> AllDLCInfos;
	local array<NarrativeContentFlag> AllDLCFlags;
	local NarrativeContentFlag DLCFlag;
	local int idx, DLCIndex;
	local bool bChecked, bProfileModified, bIntegratedDLCCreated;
	local string DLCLabel; 
	
	m_bTutorial = UIShellDifficulty( `SCREENSTACK.GetScreen(class'UIShellDifficulty') ).m_bControlledStart;
	m_List.ClearItems();
	DLCInfos.length = 0;
	DLCLabel = ""; 
	
	m_XpacknarrativeMechaItem.UpdateDataCheckbox(XPACKNarrativeOption, "", `XPROFILESETTINGS.Data.m_bXPackNarrative, OnXpackNarrativeToggled);
	
	if(m_bTutorial)
	{
		m_XpacknarrativeMechaItem.UpdateDataCheckbox(XPACKNarrativeOption, "", true, OnXpackNarrativeToggled);
		m_XpacknarrativeMechaItem.SetDisabled(true, XPACKNarrativeWithTutorialTooltip);
	}
	else
	{
		m_XpacknarrativeMechaItem.SetDisabled(false);
	}


	// Grab DLC infos for quick access to identifier and localized strings
	m_kProfileSettings = `XPROFILESETTINGS;
	AllDLCFlags = m_kProfileSettings.Data.m_arrNarrativeContentEnabled;
	AllDLCInfos = `ONLINEEVENTMGR.GetDLCInfos(false);

	for(idx = 0; idx < AllDLCInfos.Length; idx++)
	{
		if(AllDLCInfos[idx].bHasOptionalNarrativeContent)
		{
			if( !bIntegratedDLCCreated )
				bIntegratedDLCCreated = CreateIntegratedDLCOption();

			bChecked = false; // All DLCs start with narrative content disabled in favor of the integrated content 
			
			DLCIndex = AllDLCFlags.Find('DLCName', name(AllDLCInfos[idx].DLCIdentifier));
			if (DLCIndex != INDEX_NONE)
			{
				bChecked = AllDLCFlags[DLCIndex].NarrativeContentEnabled;
			}
			else
			{
				DLCFlag.DLCName = name(AllDLCInfos[idx].DLCIdentifier);
				DLCFlag.NarrativeContentEnabled = bChecked;
				m_kProfileSettings.Data.m_arrNarrativeContentEnabled.AddItem(DLCFlag);
				
				bProfileModified = true;
			}

			DLCInfos.AddItem(AllDLCInfos[idx]);
			CreateListItem(AllDLCInfos[idx].NarrativeContentLabel, bChecked);
			DLCLabel = DLCSubTitle;

			if(bChecked)
			{
				EnabledOptionalNarrativeDLC.AddItem(Name(AllDLCInfos[idx].DLCIdentifier));
			}
		}
	}
	
	OnSetSelectedIndex(m_List, -1);
	OnIntegratedDLCCheckboxChanged(UIMechaListItem( m_List.GetItem(0)).Checkbox);

	if (bProfileModified)
	{
		`ONLINEEVENTMGR.SaveProfileSettings(true);
	}
	
	AS_SetNarrativeContentMenu( GetStartButtonText(), DLCLabel, m_strXPACKNarrativeHeader );
}

function bool CreateIntegratedDLCOption()
{
	local UIMechaListItem IntegratedDLCItem;

	//Add an initial item for all integrated DLC 
	IntegratedDLCItem = Spawn(class'UIMechaListItem', m_List.ItemContainer);
	IntegratedDLCItem.bAnimateOnInit = false;
	IntegratedDLCItem.InitListItem();
	IntegratedDLCItem.UpdateDataCheckbox(IntegratedDLCOption, "", true, OnIntegratedDLCCheckboxChanged);

	return true; 
}

simulated function CreateListItem(string Label, bool bChecked)
{
	local UIMechaListItem SpawnedItem;

	// @bsteiner - DLCInfos have a few values you'll need
	// DLCIdentifier - store these in EnabledOptionalNarrativeDLC, will want to pass in CreateStrategyGameStart
	// NarrativeContentLabel - Label for the checkbox
	// NarrativeContentSummary - Description to appear when hovering over the option (not tooltip)

	SpawnedItem = Spawn(class'UIMechaListItem', m_List.ItemContainer);
	SpawnedItem.bAnimateOnInit = false;
	SpawnedItem.InitListItem();
	SpawnedItem.UpdateDataCheckbox(Label, "", bChecked, OnCheckboxChanged);
}

simulated function OnXpackNarrativeToggled(UICheckbox CheckboxControl)
{
	local TDialogueBoxData kDialogData;

	if( !m_bShowedXpackNarrtiveNotice && !CheckboxControl.bChecked )
	{
		PlaySound(SoundCue'SoundUI.HUDOnCue');

		kDialogData.eType = eDialog_Normal;
		kDialogData.strTitle = m_strDisableXpackNarrativeTitle;
		kDialogData.strText = m_strDisableXpackNarrativeBody;
		kDialogData.strAccept = m_strDisableXpackNarrativeYes;
		kDialogData.strCancel = m_strDisableXpackNarrativeNo;
		kDialogData.fnCallback = ConfirmXpackToggleCallback;

		Movie.Pres.UIRaiseDialog(kDialogData);
	}
	else
	{
		`XPROFILESETTINGS.Data.m_bXPackNarrative = CheckboxControl.bChecked;
	}
}

simulated public function ConfirmXpackToggleCallback(Name eAction)
{
	PlaySound(SoundCue'SoundUI.HUDOffCue');

	if( eAction == 'eUIAction_Accept' )
	{
		m_XpacknarrativeMechaItem.Checkbox.SetChecked(true, false); 
	}
	else
	{

		m_XpacknarrativeMechaItem.Checkbox.SetChecked(false, false);
	}
	m_XpacknarrativeMechaItem.Checkbox.OnLoseFocus();

	`XPROFILESETTINGS.Data.m_bXPackNarrative = m_XpacknarrativeMechaItem.Checkbox.bChecked;

	m_bShowedXpackNarrtiveNotice = true; 
}

simulated function OnIntegratedDLCCheckboxChanged(UICheckbox CheckboxControl)
{
	local int i; 
	local UIMechaListItem Item; 

	if( CheckboxControl.bChecked )
	{
		bEnabledIntegratedDLC = true;

		//If the IntegratedDLC option is checked, then all other DLCs are disabled + unchecked. 
		for( i = 1; i < m_List.ItemCount; i++ )
		{
			Item = UIMechaListItem( m_List.GetItem(i));
			Item.SetDisabled(true);
			Item.Checkbox.SetChecked(false, false);
			OnCheckboxChanged(Item.Checkbox);
			OnClicked(m_List, i);
		}
	}
	else
	{
		bEnabledIntegratedDLC = false;

		//If the IntegratedDLC option is *not* checked, then the other DLC are enabled. 
		for( i = 1; i < m_List.ItemCount; i++ )
		{
			Item = UIMechaListItem(m_List.GetItem(i));
			Item.SetDisabled(false);
			OnCheckboxChanged(Item.Checkbox);
			OnClicked(m_List, i);
		}
	}
}

simulated function OnCheckboxChanged(UICheckbox CheckboxControl)
{
	local int index;
	bCheckboxUpdate = true;

	for (index = 0; index < m_List.ItemCount; index++)
	{
		if (UIMechaListItem(m_List.GetItem(index)).Checkbox == CheckboxControl)
			break;
	}

	if (index != m_List.ItemCount)
		OnClicked(m_List, index);
}

simulated function OnClicked(UIList ContainerList, int ItemIndex)
{
	local XComOnlineProfileSettings m_kProfileSettings;
	local array<NarrativeContentFlag> AllDLCFlags;
	local UICheckbox checkedBox;
	local int DLCFlagIndex;
	local UIMechaListItem IntegratedDLCItem, CurrentItem;
	

	IntegratedDLCItem = UIMechaListItem(m_List.GetItem(0)); 
	CurrentItem = UIMechaListItem(m_List.GetItem(ItemIndex));
	checkedBox = CurrentItem.Checkbox;

	if( CurrentItem != IntegratedDLCItem )
	{
		//If the IntegratedDLC option at zero is ticked, then you can't turn any of these other options on.
		if( IntegratedDLCItem.Checkbox.bChecked )
			checkedBox.SetChecked(false);

		if( bCheckboxUpdate )
		{
			m_kProfileSettings = `XPROFILESETTINGS;
			AllDLCFlags = m_kProfileSettings.Data.m_arrNarrativeContentEnabled;
			DLCFlagIndex = AllDLCFlags.Find('DLCName', Name(DLCInfos[ItemIndex - 1].DLCIdentifier)); // minus one because of the Integrated option at zero 

			if( DLCFlagIndex != INDEX_NONE)
			{
				// Only turn the flag off if it is true, so should only happen once
				m_kProfileSettings.Data.m_arrNarrativeContentEnabled[DLCFlagIndex].NarrativeContentEnabled = checkedBox.bChecked;
				`ONLINEEVENTMGR.SaveProfileSettings(true);
			}

			if( checkedBox.bChecked )
				EnabledOptionalNarrativeDLC.AddItem(Name(DLCInfos[ItemIndex - 1].DLCIdentifier));
			else
				EnabledOptionalNarrativeDLC.RemoveItem(Name(DLCInfos[ItemIndex - 1].DLCIdentifier));

			bCheckboxUpdate = false;
		}
	}
}

simulated function OnSetSelectedIndex(UIList ContainerList, int ItemIndex)
{
	if( ItemIndex == -1 )
	{
		SetNarrativeDesc();
	}
	else if(ItemIndex == 0)
	{
		AS_SetDifficultyDesc(IntegratedDLCDesc);
	}
	else
	{
		AS_SetDifficultyDesc(DLCInfos[ItemIndex - 1].NarrativeContentSummary);
	}
}

simulated function AS_SetNarrativeContentMenu(string launchLabel, string DLCLabel, string ChosenLabel)
{
	mc.BeginFunctionOp("UpdateNarrativeContentMenu");
	mc.QueueString(launchLabel);
	mc.QueueString(DLCLabel);
	mc.QueueString(ChosenLabel);
	mc.EndOp();
}
simulated function AS_SetTitle(string title)
{
	mc.FunctionString("SetTitle", title);
}
simulated function AS_SetDifficultyDesc(string desc)
{
	mc.FunctionString("SetDifficultyDesc", desc);
}

simulated public function OnButtonCancel()
{
	if(bIsInited)
	{
		Movie.Pres.PlayUISound(eSUISound_MenuClose);
		Movie.Stack.Pop(self);
		
		if(!m_bTutorial)
		{
			Movie.Pres.UIIronMan();
		}
	}
}

simulated public function ConfirmNarrativeContent(UIButton ButtonControl)
{
	local UIShellDifficulty difficultyMenu;
	difficultyMenu = UIShellDifficulty(Movie.Stack.GetFirstInstanceOf(class'UIShellDifficulty'));
	Movie.Stack.PopUntilClass(class'UIShellDifficulty');
	difficultyMenu.EnabledOptionalNarrativeDLC = EnabledOptionalNarrativeDLC;
	difficultyMenu.m_bIntegratedDLC = bEnabledIntegratedDLC;
	difficultyMenu.OnDifficultyConfirm(ButtonControl);
}


simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local bool bHandled;
	local UIPanel CurrentSelection;

	if(!CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
		return true;

	switch(cmd)
	{
	case class'UIUtilities_Input'.const.FXS_KEY_ENTER:

		CurrentSelection = Navigator.GetSelected();
		if(CurrentSelection != None)
		{
			bHandled = CurrentSelection.OnUnrealCommand(cmd, arg);
		}
		break;

	case class'UIUtilities_Input'.const.FXS_BUTTON_X :
	case class'UIUtilities_Input'.const.FXS_BUTTON_START :
		ConfirmNarrativeContent(none);
		break;
	case class'UIUtilities_Input'.const.FXS_BUTTON_B:
	case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE:
	case class'UIUtilities_Input'.const.FXS_R_MOUSE_DOWN:
		OnButtonCancel();
		break;

	default:
		bHandled = false;
	}


	return bHandled || super.OnUnrealCommand(cmd, arg);
}

simulated function OnXpackNarrativeMouseEvent(UIPanel Panel, int Cmd)
{
	if( Panel != m_XpacknarrativeMechaItem ) return; 

	switch( cmd )
	{
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_IN :
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_OVER :
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OVER :
		SetNarrativeDesc();
		break;
	}
}

simulated function SetNarrativeDesc()
{
	if(m_bTutorial)
	{
		AS_SetDifficultyDesc(XPACKNarrativeOptionDesc $ "\n\n" $ XPACKNarrativeWithTutorialOptionDesc);
	}
	else
	{
		AS_SetDifficultyDesc(XPACKNarrativeOptionDesc);
	}
}

//bsg-hlee (05.05.17): Adding in nav help functions for focus.
simulated function UpdateNavHelp()
{
	NavHelp.ClearButtonHelp();
	NavHelp.bIsVerticalHelp = true;
	NavHelp.AddBackButton(OnButtonCancel);
	NavHelp.AddSelectNavHelp();
}

simulated function OnLoseFocus()
{
	super.OnLoseFocus();
	NavHelp.ClearButtonHelp();
}

simulated function OnReceiveFocus()
{
	super.OnReceiveFocus();
	UpdateNavHelp();
}
//bsg-hlee (05.05.17): End

//==============================================================================
//		CLEANUP:
//==============================================================================

event Destroyed()
{
	super.Destroyed();
}

DefaultProperties
{
	Package = "/ package/gfxDifficultyMenu/DifficultyMenu";
	LibID = "DifficultyMenu_NarrativeContent"

		InputState = eInputState_Consume;
	bConsumeMouseEvents = true;
	bHideOnLoseFocus = true;
	m_bShowedXpackNarrtiveNotice = false; 

}