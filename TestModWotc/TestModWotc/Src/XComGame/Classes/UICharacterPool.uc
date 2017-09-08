//---------------------------------------------------------------------------------------
//  FILE:    UICharacterPool.uc
//  AUTHOR:  Brit Steiner --  8/27/2014
//  PURPOSE: Main menu in the character pool system. 
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class UICharacterPool extends UIScreen;


enum EUI_CharPool_Options
{
	eUICP_Usage,
};

//----------------------------------------------------------------------------
// MEMBERS

// UI
var UIPanel Container;
var UIBGBox BG;
var UIList List;
var UIX2PanelHeader TitleHeader;
var UIButton CreateButton;
var UIButton ImportButton;
var UIButton ExportButton;
var UIButton DeleteButton;
var UIButton SelectAllButton;
var UIButton DeselectAllButton;
var UINavigationHelp NavHelp;

var bool bFinishedTransition;

var CharacterPoolManager CharacterPoolMgr;

var localized string m_strTitle;
var localized string m_strSubtitle;
var localized string m_strCreateCharacter;
var localized string m_strImportCharacter;
var localized string m_strExportSelection;
var localized string m_strDeleteSelection;
var localized string m_strEditCharacter;
var localized string m_strUpdateUsage;

var localized string m_strDeleteCharacterDialogueTitle;
var localized string m_strDeleteCharacterDialogueBody;

var localized string m_strDeleteManyCharactersDialogueTitle;
var localized string m_strDeleteManyCharactersDialogueBody;


var localized string m_strSelectAll;
var localized string m_strDeselectAll;
var localized string m_strNoCharacters;
var localized string m_strNothingSelected;
var localized string m_strEverythingSelected;

var localized string m_strUsage_Desc;
var localized string m_strUsage_Tooltip;

var localized string m_arrTypes[ECharacterPoolSelectionMode]  <BoundEnum = ECharacterPoolSelectionMode>;
var int m_iCurrentUsage;

var array<XComGameState_Unit> SelectedCharacters;
var UIList OptionsList; 

const NUM_OptionsListITEMS = 1;

//----------------------------------------------------------------------------
// FUNCTIONS

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	local float RunningY;
	local float RunningYBottom;

	super.InitScreen(InitController, InitMovie, InitName);

	// ---------------------------------------------------------

	// Create Container
	Container = Spawn(class'UIPanel', self).InitPanel('').SetPosition(30, 70).SetSize(600, 850);

	// Create BG
	BG = Spawn(class'UIBGBox', Container).InitBG('', 0, 0, Container.width, Container.height);
	BG.SetAlpha( 80 );

	RunningY = 10;
	RunningYBottom = Container.Height - 10;

	// Create Title text
	TitleHeader = Spawn(class'UIX2PanelHeader', Container);
	TitleHeader.InitPanelHeader('', m_strTitle, m_strSubtitle);
	TitleHeader.SetHeaderWidth(Container.width - 20);
	TitleHeader.SetPosition(10, RunningY);
	RunningY += TitleHeader.Height;

	if(Movie.IsMouseActive())
	{
		//Create buttons
		CreateButton = Spawn(class'UIButton', Container);
		CreateButton.ResizeToText = true;
		CreateButton.InitButton('', m_strCreateCharacter, OnButtonCallback, eUIButtonStyle_NONE);
		CreateButton.SetPosition(10, RunningY);
		CreateButton.OnSizeRealized = OnCreateButtonSizeRealized;

		ImportButton = Spawn(class'UIButton', Container);
		ImportButton.InitButton('', m_strImportCharacter, OnButtonCallback, eUIButtonStyle_NONE);
		ImportButton.SetPosition(180, RunningY);

		RunningY += ImportButton.Height + 10;
	}

	//Create bottom buttons
	OptionsList = Spawn(class'UIList', Container);
	OptionsList.InitList('OptionsListMC', 10, RunningYBottom - class'UIMechaListItem'.default.Height, Container.Width - 20, 300, , false);

	RunningYBottom -= class'UIMechaListItem'.default.Height + 10;   

	if (Movie.IsMouseActive())
	{
		ExportButton = Spawn(class'UIButton', Container);
		ExportButton.ResizeToText = true;
		ExportButton.InitButton('', m_strExportSelection, OnButtonCallback, eUIButtonStyle_NONE);
		ExportButton.SetPosition(10, RunningYBottom - ExportButton.Height);
		ExportButton.DisableButton(m_strNothingSelected);
		ExportButton.OnSizeRealized = OnExportButtonSizeRealized;

		DeselectAllButton = Spawn(class'UIButton', Container);
		DeselectAllButton.InitButton('', m_strDeselectAll, OnButtonCallback, eUIButtonStyle_NONE);
		DeselectAllButton.SetPosition(180, RunningYBottom - DeselectAllButton.Height);
		DeselectAllButton.DisableButton(m_strNothingSelected);

		RunningYBottom -= ExportButton.Height + 10;

		DeleteButton = Spawn(class'UIButton', Container);
		DeleteButton.ResizeToText = true;
		DeleteButton.InitButton('', m_strDeleteSelection, OnButtonCallback, eUIButtonStyle_NONE);
		DeleteButton.SetPosition(10, RunningYBottom - DeleteButton.Height);
		DeleteButton.DisableButton(m_strNothingSelected);
		DeleteButton.OnSizeRealized = OnDeleteButtonSizeRealized;

		SelectAllButton = Spawn(class'UIButton', Container);
		SelectAllButton.InitButton('', m_strSelectAll, OnButtonCallback, eUIButtonStyle_NONE);
		SelectAllButton.SetPosition(180, RunningYBottom - SelectAllButton.Height);
		SelectAllButton.DisableButton(m_strNoCharacters);

		RunningYBottom -= DeleteButton.Height + 10;
	}

	List = Spawn(class'UIList', Container);
	List.bAnimateOnInit = false;
	List.InitList('', 10, RunningY, TitleHeader.headerWidth - 20, RunningYBottom - RunningY);
	BG.ProcessMouseEvents(List.OnChildMouseEvent);
	List.bStickyHighlight = true;

	// --------------------------------------------------------

	NavHelp = Spawn(class'UINavigationHelp', self).InitNavHelp();

	// ---------------------------------------------------------

	CharacterPoolMgr = CharacterPoolManager(`XENGINE.GetCharacterPoolManager());

	
	if( `ISCONTROLLERACTIVE )
	{
		m_iCurrentUsage = (`XPROFILESETTINGS.Data.m_eCharPoolUsage);
	}
	else
	{
		// Subtract one b/c NONE first option is skipped when generating the list
		m_iCurrentUsage = (`XPROFILESETTINGS.Data.m_eCharPoolUsage - 1);
	}
	

	// ---------------------------------------------------------
	
	CreateOptionsList();

	// ---------------------------------------------------------
	
	UpdateData();
	
	// ---------------------------------------------------------

	Hide();
	`XCOMGRI.DoRemoteEvent('StartCharacterPool'); // start a fade
	WorldInfo.RemoteEventListeners.AddItem(self);
	SetTimer(2.0, false, nameof(ForceShow));
	
	bAnimateOut = false;
}

simulated function OnInit()
{	
	super.OnInit();

	if( `ISCONTROLLERACTIVE )
	{
		UpdateGamepadFocus();
	}
}

simulated function UpdateGamepadFocus()
{
	if(List.ItemCount > 0)
	{
		List.SetSelectedIndex(0);
		Navigator.SetSelected(List);
	}

	UpdateNavHelp();
}

simulated function UpdateNavHelp()
{
	NavHelp.ClearButtonHelp();

	NavHelp.AddBackButton(OnCancel);
	
	if( `ISCONTROLLERACTIVE == false ) return; 

	//Toggle selection is constant
	if(List.ItemCount > 0)
		NavHelp.AddLeftHelp(class'UIUtilities_Text'.default.m_strGenericToggle, class'UIUtilities_Input'.static.GetAdvanceButtonIcon());

	//TWO MODES:
	if(SelectedCharacters.Length == 0) //NOTHING IS SELECTED
	{		
		NavHelp.AddLeftHelp(m_strCreateCharacter, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_Y_TRIANGLE);
		if(List.ItemCount > 0)
			NavHelp.AddLeftHelp(m_strEditCharacter, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_X_SQUARE);			
	}
	else //ONE OR MORE ITEMS ARE SELECTED
	{		
		NavHelp.AddLeftHelp(m_strDeleteSelection, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_Y_TRIANGLE);
		NavHelp.AddLeftHelp(m_strDeselectAll, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_X_SQUARE);				
	}	

	NavHelp.AddLeftHelp(m_strImportCharacter, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $class'UIUtilities_Input'.const.ICON_LSCLICK_L3);
	NavHelp.AddLeftHelp(m_strUpdateUsage, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $class'UIUtilities_Input'.const.ICON_RB_R1);

	//bsg-jneal (1.20.19): no exporting for consoles
	if( !`ISCONSOLE )
		NavHelp.AddLeftHelp(m_strExportSelection, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $class'UIUtilities_Input'.const.ICON_RT_R2);
	//bsg-jneal (1.20.19): end
}

simulated function SaveCharacterPool()
{
	CharacterPoolMgr.SaveCharacterPool();
	Movie.Stack.PopFirstInstanceOfClass(class'UIProgressDialogue', false);
}


function CreateOptionsList()
{
	local int i;
	local UIMechaListItem ListItem; 
	
	// list needs to be created backwards for depth sorting
	for( i = NUM_OptionsListITEMS - 1; i >= 0; i-- )
	{
		ListItem = Spawn(class'UIMechaListItem', OptionsList.itemContainer);
		ListItem.bAnimateOnInit = false;
		ListItem.InitListItem();
		ListItem.SetY(i * class'UIMechaListItem'.default.Height);
	}

	// ------------------------------------------------------------------------
	// Random vs. Pool usage dropdown: 
	ListItem = UIMechaListItem(OptionsList.GetItem(eUICP_Usage));
	
	//bsg-jneal (2.1.17): use a spinner instead of a dropdown for character pool usage with controller so it looks less like a PC button
	if(`ISCONTROLLERACTIVE)
	{
		ListItem.UpdateDataSpinner(m_strUsage_Desc, m_arrTypes[m_iCurrentUsage], UpdateCharacterPoolSpinner);
		UpdateCharacterPoolSpinner(ListItem.Spinner, 0);
		ListItem.DisableNavigation();
	}
	else
	{
		ListItem.UpdateDataDropdown(m_strUsage_Desc, GetCharacterPoolDropdownLabels(), m_iCurrentUsage, UpdateCharacterPoolUsage);
		ListItem.Dropdown.SetSelected(m_iCurrentUsage);
	}
	//bsg-jneal (2.1.17): end

	ListItem.BG.SetTooltipText(m_strUsage_Tooltip, , , 10, , , , 0.0f);

	if (!Movie.IsMouseActive())
	{
		ListItem.SetDisabled(true);
	}
	// ------------------------------------------------------------------------

}

simulated function OnCreateButtonSizeRealized()
{
	ImportButton.SetX(CreateButton.X + CreateButton.Width + 10);
}

simulated function OnDeleteButtonSizeRealized()
{
	SelectAllButton.SetX(DeleteButton.X + DeleteButton.Width + 10);
}

simulated function OnExportButtonSizeRealized()
{
	DeselectAllButton.SetX(ExportButton.X + ExportButton.Width + 10);
}

simulated function ForceShow()
{
	class'UIUtilities'.static.DisplayUI3D(class'UICustomize'.default.DisplayTag, name(class'UICustomize'.default.CameraTag), 0);
	AnimateIn();
	Show();

	//bsg-jneal (2.1.17): disable spinner arrows for controller, call in ForceShow since it is a delayed call with a timer 
	// allowing Flash enough time to fully init so it can process new function calls without being lost to the abyss
	if(`ISCONTROLLERACTIVE)
	{
		DisableUsageSpinnerArrows();
		UpdateNavHelp();  // bsg-jneal (4.4.17): force a navhelp update to correctly fix wide icon sizing issues when first entering the character pool
	}
	//bsg-jneal (2.1.17): end
}

//bsg-jneal (2.1.17): disable spinner arrows for controller
function DisableUsageSpinnerArrows()
{
	local UIMechaListItem ListItem;

	ListItem = UIMechaListItem(OptionsList.GetItem(eUICP_Usage));
	ListItem.Spinner.mc.FunctionBool("canSpin", false);
}
//bsg-jneal (2.1.17): end

event OnRemoteEvent(name RemoteEventName)
{
	super.OnRemoteEvent(RemoteEventName);

	// Only show screen if we're at the top of the state stack
	if(RemoteEventName == 'FinishedTransitionToCharacterPool' && 
		(`SCREENSTACK.GetCurrentScreen() == self || `SCREENSTACK.IsCurrentClass(class'UIRedScreen') || `SCREENSTACK.HasInstanceOf(class'UIProgressDialogue'))) //bsg-jneal (5.10.17): allow remote events to call through even with dialogues up
	{
		bFinishedTransition = true;
		ClearTimer(nameof(ForceShow));
		ForceShow();
	}
	else if(!`ISCONSOLE && RemoteEventName == 'FinishedTransitionToShell' && bFinishedTransition)
	{
		ClearTimer(nameof(CloseScreen));
		CloseScreen();
	}
}

simulated function UpdateData()
{
	UpdateDisplay();
}

simulated function UpdateDisplay()
{
	local UIMechaListItem SpawnedItem;
	local int i, NumCharacters; 
	local array<string> CharacterNames; 

	CharacterNames = GetCharacterNames();
	NumCharacters = CharacterNames.length; 

	if(List.itemCount > NumCharacters)
		List.ClearItems();

	while (List.itemCount < NumCharacters)
	{
		SpawnedItem = Spawn(class'UIMechaListItem', List.ItemContainer);
		SpawnedItem.bAnimateOnInit = false;
		SpawnedItem.InitListItem();
		SpawnedItem.SetWidgetType(EUILineItemType_Checkbox);
	}
	
	for( i = 0; i < NumCharacters; i++ )
	{
		UIMechaListItem(List.GetItem(i)).UpdateDataCheckbox(CharacterNames[i], 
			"",
			SelectedCharacters.Find(GetSoldierInSlot(i)) != INDEX_NONE, 
			SelectSoldier, 
			EditSoldier);
	}

	UpdateNavHelp();
	if( !`ISCONTROLLERACTIVE )
		UpdateEnabledButtons();
}

simulated function OnReceiveFocus()
{
	CharacterPoolMgr.SaveCharacterPool();
	super.OnReceiveFocus();
	UpdateData();
	ForceShow();

	if(`ISCONTROLLERACTIVE) //bsg-crobinson (5.4.17): Only update gamepad focus with controller active
		UpdateGamepadFocus();
}

simulated function OnLoseFocus()
{
	super.OnLoseFocus();
}

//------------------------------------------------------

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	//bsg-jneal (1.20.19): do not use input if not focused
	if( !bIsFocused || !bIsVisible)
		return false;
	//bsg-jneal (1.20.19): end

	if( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	switch( cmd )
	{
		case class'UIUtilities_Input'.const.FXS_BUTTON_B:
		case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE:
		case class'UIUtilities_Input'.const.FXS_R_MOUSE_DOWN:
			OnCancel();
			break; 
		case class'UIUtilities_Input'.const.FXS_BUTTON_A:
			if(List.ItemCount > 0)
				SimulateMouseClickOnCheckbox();
			return true;
		case class'UIUtilities_Input'.const.FXS_BUTTON_X:
			if(SelectedCharacters.Length == 0 && List.ItemCount > 0) //edit
				EditSoldier();
			else if(SelectedCharacters.Length > 0) //unselect all
			{
				SelectedCharacters.Length = 0;
				UpdateDisplay();
			}
			return true;
		case class'UIUtilities_Input'.const.FXS_BUTTON_Y:
			if(SelectedCharacters.Length == 0) //create new
				OnButtonCallbackCreateNew();
			else //delete
				DeleteSoldiersDialogue();
			return true;
		case class'UIUtilities_Input'.const.FXS_BUTTON_L3:
			PC.Pres.UICharacterPool_ImportPools();
			SelectedCharacters.Length = 0;
			return true;
		case class'UIUtilities_Input'.const.FXS_BUTTON_RBUMPER:
			IncrementCharacterPoolUsage();
			return true;
		case class'UIUtilities_Input'.const.FXS_BUTTON_RTRIGGER:
			//bsg-jneal (1.20.19): no exporting for consoles
			if(!`ISCONSOLE)
			{
				if (SelectedCharacters.Length > 0)
				{
					PC.Pres.UICharacterPool_ExportPools(SelectedCharacters);
					SelectedCharacters.Length = 0;
				}
			}
			//bsg-jneal (1.20.19): end
			return true;
	}

	return super.OnUnrealCommand(cmd, arg);
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

//------------------------------------------------------

simulated function OnButtonCallback(UIButton kButton)
{
	local int i;
	
	if(bAnimateOut) return;

	if (kButton == CreateButton)
	{
		OnButtonCallbackCreateNew();
	}
	else if (kButton == ImportButton)
	{
		PC.Pres.UICharacterPool_ImportPools();
		SelectedCharacters.Length = 0;
	}
	else if (kButton == ExportButton)
	{
		if (SelectedCharacters.Length > 0)
		{
			PC.Pres.UICharacterPool_ExportPools(SelectedCharacters);
			SelectedCharacters.Length = 0;
		}
	}
	else if (kButton == DeleteButton)
	{
		if (SelectedCharacters.Length > 0)
			DeleteSoldiersDialogue();
	}
	else if (kButton == SelectAllButton)
	{
		SelectedCharacters.Length = 0;
		for (i = 0; i < List.ItemCount; i++)
		{
			SelectedCharacters.AddItem(GetSoldierInSlot(i));
		}
		UpdateDisplay();
	}
	else if (kButton == DeselectAllButton)
	{
		SelectedCharacters.Length = 0;
		UpdateDisplay();
	}
	
	Movie.Pres.PlayUISound(eSUISound_MenuSelect);
}

simulated function OnButtonCallbackCreateNew()
{
	local XComGameState_Unit	NewSoldierState;

	NewSoldierState = CharacterPoolMgr.CreateSoldier('Soldier');
	NewSoldierState.PoolTimestamp = class'X2StrategyGameRulesetDataStructures'.static.GetSystemDateTimeString();
	CharacterPoolMgr.CharacterPool.AddItem(NewSoldierState);
	PC.Pres.UICustomize_Menu( NewSoldierState, none ); // If sending in 'none', needs to create this character.
	//<workshop> CHARACTER_POOL RJM 2016/02/05
	//WAS:
	//CharacterPoolMgr.SaveCharacterPool();	
	SaveCharacterPool();
	//</workshop>
	SelectedCharacters.Length = 0;
}

simulated function OnCancel()
{
	if (!IsTimerActive(nameof(CloseScreen)) && bIsVisible)
	{
		XComShellPresentationLayer(Movie.Pres).GetCamera().GotoState('CinematicView');
		SetTimer(3.0, false, nameof(CloseScreen));
		`XCOMGRI.DoRemoteEvent('ReturnToShell');
		bAnimateOut = true;
		AnimateOut();		
	}
}

// ---------------------------------------------------------

simulated function array<string> GetCharacterNames()
{
	local array<string> CharacterNames; 
	local int i; 
	
	local XComGameState_Unit Soldier;
	local string soldierName;

	for( i = 0; i < CharacterPoolMgr.CharacterPool.Length; i++ )
	{
		Soldier = CharacterPoolMgr.CharacterPool[i];
		if( Soldier.GetNickName() != "" )
			soldierName = Soldier.GetFirstName() @ Soldier.GetNickName() @ Soldier.GetLastName();
		else
			soldierName = Soldier.GetFirstName() @ Soldier.GetLastName();

		CharacterNames.AddItem(soldierName);
	}
	return CharacterNames; 
}

simulated function EditSoldier()
{
	local int itemIndex;
	local XComGameState_Unit SlotSoldier;

	itemIndex = List.GetItemIndex(List.GetSelectedItem());

	SlotSoldier = GetSoldierInSlot(itemIndex);
	if (SlotSoldier == none)
		return;

	PC.Pres.UICustomize_Menu(SlotSoldier, none);
	CharacterPoolMgr.SaveCharacterPool();
}

simulated function SelectSoldier(UICheckbox CheckBox)
{
	local UIPanel SelectedPanel;
	local XComGameState_Unit SelectedUnit;
	local int itemIndex;

	SelectedPanel = List.GetSelectedItem();
	itemIndex = List.GetItemIndex(SelectedPanel);
	SelectedUnit = GetSoldierInSlot(itemIndex);

	if (CheckBox.bChecked)
		SelectedCharacters.AddItem(SelectedUnit);
	else
		SelectedCharacters.RemoveItem(SelectedUnit);
	

	if( `ISCONTROLLERACTIVE )
		UpdateNavHelp();
	else
		UpdateEnabledButtons();

}

simulated function UpdateEnabledButtons()
{
	local bool AnyCharacters;
	local bool AllSelected;
	local bool NoneSelected;

	AnyCharacters = (List.ItemCount > 0);
	AllSelected = (SelectedCharacters.Length == List.ItemCount);
	NoneSelected = (SelectedCharacters.Length == 0);

	if (NoneSelected)
	{
		DeleteButton.DisableButton(m_strNothingSelected);
		ExportButton.DisableButton(m_strNothingSelected);
	}
	else
	{
		DeleteButton.EnableButton();
		ExportButton.EnableButton();
	}

	//Need to do this to refresh tooltips
	SelectAllButton.EnableButton();
	DeselectAllButton.EnableButton();

	if (!AnyCharacters)
	{
		SelectAllButton.DisableButton(m_strNoCharacters);
		DeselectAllButton.DisableButton(m_strNoCharacters);
	}
	else
	{
		if (NoneSelected)
			DeselectAllButton.DisableButton(m_strNothingSelected);

		if (AllSelected)
			SelectAllButton.DisableButton(m_strEverythingSelected);
	}

	//CreateOptionsList();
}

function XComGameState_Unit GetSoldierInSlot( int iSlot )
{
	return CharacterPoolMgr.CharacterPool[iSlot];
}

function DeleteSoldiersDialogue()
{
	local XGParamTag LocTag;
	local int i;
	local TDialogueBoxData kDialogData;

	if (SelectedCharacters.Length <= 0)
		return;

	kDialogData.eType = eDialog_Normal;

	LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	LocTag.IntValue0 = SelectedCharacters.Length;

	if (SelectedCharacters.Length > 25)
	{
		kDialogData.strTitle = m_strDeleteManyCharactersDialogueTitle;
		kDialogData.strText = `XEXPAND.ExpandString(m_strDeleteManyCharactersDialogueBody);
	}
	else
	{
		kDialogData.strTitle = m_strDeleteCharacterDialogueTitle;
		kDialogData.strText = `XEXPAND.ExpandString(m_strDeleteCharacterDialogueBody);

		for (i = 0; i < SelectedCharacters.Length; i++)
		{
			kDialogData.strText = kDialogData.strText $ "\n" $ SelectedCharacters[i].GetFullName();
		}
	}

	kDialogData.strAccept = class'UIUtilities_Text'.default.m_strGenericAccept;
	kDialogData.strCancel = class'UIUtilities_Text'.default.m_strGenericCancel;
	kDialogData.fnCallback = DeleteSoldiersDialogueCallback;

	Movie.Pres.UIRaiseDialog(kDialogData);
}

simulated public function DeleteSoldiersDialogueCallback(Name eAction)
{
	local int i;
	//Unless they hit accept, don't do anything
	if (eAction != 'eUIAction_Accept')
		return;

	//Remove all selected characters from the pool
	for (i = 0; i < SelectedCharacters.Length; i++)
	{
		CharacterPoolMgr.RemoveUnit(SelectedCharacters[i]);
	}

	SelectedCharacters.Length = 0;
	CharacterPoolMgr.SaveCharacterPool();
	UpdateDisplay();
	
	if( `ISCONTROLLERACTIVE == false )
		UpdateGamepadFocus();
}

public function array<string> GetCharacterPoolDropdownLabels()
{
	local array<string> arrCharacterPoolTypesForDropdown;
	local int i;

	for( i = 1; i < eCPSM_MAX; ++i )
	{
		arrCharacterPoolTypesForDropdown.AddItem(m_arrTypes[i]);
	}

	return arrCharacterPoolTypesForDropdown;
}

//bsg-jneal (2.1.17): use a spinner instead of a dropdown for character pool usage with controller so it looks less like a PC button
public function UpdateCharacterPoolSpinner(UIListItemSpinner SpinnerControl, int direction)
{
	SpinnerControl.SetValue(m_arrTypes[m_iCurrentUsage]);

	`XPROFILESETTINGS.Data.m_eCharPoolUsage = ECharacterPoolSelectionMode(m_iCurrentUsage);
	`ONLINEEVENTMGR.SaveProfileSettings();

	Movie.Pres.PlayUISound(eSUISound_MenuSelect);
}
//bsg-jneal (2.1.17): end

public function UpdateCharacterPoolUsage(UIDropdown DropdownControl)
{
	m_iCurrentUsage = DropdownControl.SelectedItem;

	// Need to add one b/c we skip the NONE first option in the enum list
	`XPROFILESETTINGS.Data.m_eCharPoolUsage = ECharacterPoolSelectionMode(m_iCurrentUsage + 1);
	`ONLINEEVENTMGR.SaveProfileSettings();

	Movie.Pres.PlayUISound(eSUISound_MenuSelect);
}

public function IncrementCharacterPoolUsage()
{
	local UIMechaListItem ListItem; 
	
	ListItem = UIMechaListItem(OptionsList.GetItem(eUICP_Usage));
	//bsg-jneal (2.1.17): use a spinner instead of a dropdown for character pool usage with controller so it looks less like a PC button
	if(`ISCONTROLLERACTIVE)
	{
		m_iCurrentUsage++;
		if(m_iCurrentUsage >= eCPSM_MAX)
			m_iCurrentUsage = 0;

		UpdateCharacterPoolSpinner(ListItem.Spinner, 0);
	}
	else
	{
		if(m_iCurrentUsage +1 == ListItem.Dropdown.Items.Length)
		{
			ListItem.Dropdown.SetSelected(0);
		}
		else
		{
			ListItem.Dropdown.SetSelected(m_iCurrentUsage +1);
		}

		UpdateCharacterPoolUsage(ListItem.Dropdown);
	}
	//bsg-jneal (2.1.17): end
}


//==============================================================================

defaultproperties
{
	InputState = eInputState_Evaluate;
	bIsNavigable	= true;
	bHideOnLoseFocus = true;
	bFinishedTransition = false;
}
