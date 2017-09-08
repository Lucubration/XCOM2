//---------------------------------------------------------------------------------------
//  FILE:    UIManageEquipmentMenu
//  AUTHOR:  Jake Akemann
//  PURPOSE: Free onscreen clutter by moving the shortcuts to "make items available" to a separate list
//	(MODELED AFTER THE PAUSE MENU)
//---------------------------------------------------------------------------------------

class UIManageEquipmentMenu extends UIScreen;

var UIList	List;
var UINavigationHelp NavHelp;

//the labels (can callback functions) can be set before the menu is initialized, if that happens they are stored in this array and created after the menu is initialized
var protected array< string >	LabelList;
var protected array< delegate<OnClickCallback> > CallbackList; //called by Selected Index when the menu receives input

var localized string m_strTitleLabel;

delegate OnClickCallback();

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	super.InitScreen(InitController, InitMovie, InitName);

	if (`HQPRES != none) // Strategy
	{
		NavHelp =`HQPRES.m_kAvengerHUD.NavHelp;
	}
	else // Shell
	{
		NavHelp = InitController.Pres.GetNavHelp();
	}

	NavHelp.ClearButtonHelp();
	NavHelp.bIsVerticalHelp = true;
	NavHelp.AddBackButton(CloseScreen);
	NavHelp.AddSelectNavHelp();
}

//----------------------------------------------------------------------------
//	Set default values.
//
simulated function OnInit()
{
	local int i;

	super.OnInit();	
	
	//Build Menu
	List = Spawn(class'UIList', self);
	List.InitList('ItemList', , , 415, 450);
	List.OnItemClicked = OnSelectionPressed;
	List.OnItemDoubleClicked = OnSelectionPressed;

	//If the labels/callback functions were set before initialization, it will create them here
	for(i=0; i<LabelList.Length; i++)
	{
		AddItem(LabelList[i],CallbackList[i],true);
	}	

	MC.FunctionString("SetTitle", m_strTitleLabel);
	MC.FunctionVoid("AnimateIn");

	Navigator.SetSelected(List);
	List.SetSelectedIndex(0);
}

simulated function AddItem(string Label, optional delegate<OnClickCallback> CallbackFunction, optional bool bCalledFromInit = false)
{
	local UIListItemString NewItem;

	//If list doesn't exist, OnInit will add these after initialization
	if(!bCalledFromInit)
	{
		CallbackList.AddItem(CallbackFunction);
		LabelList.AddItem(Label);
	}	

	if(List != None)
	{
		NewItem = Spawn(class'UIListItemString',List.ItemContainer);
		NewItem.InitListItem(Label);	
	}
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	// Only pay attention to presses or repeats; ignoring other input types
	// NOTE: Ensure repeats only occur with arrow keys
	if ( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	switch( cmd )
	{
	case class'UIUtilities_Input'.const.FXS_BUTTON_B: //bsg-crobinson (4.20.17): account for SCEJ controller scheme
		CloseScreen();
		return true;
	}

	return super.OnUnrealCommand(cmd, arg);
}

simulated function OnSelectionPressed(UIList ContainerList, int ItemIndex)
{
	local delegate<OnClickCallback> CallbackFunction;

	CallbackFunction = CallbackList[List.SelectedIndex];
	if(CallbackFunction != None)
	{
		CallbackFunction();
		CloseScreen();
	}
}

simulated function ClearList()
{
	List.ClearItems();
	CallbackList.Length = 0;
}

DefaultProperties
{
	Package   = "/ package/gfxManageEquipmentMenu/ManageEquipmentMenu";
	MCName    = "theMenu";

	InputState= eInputState_Consume;
	bConsumeMouseEvents = true;
}
