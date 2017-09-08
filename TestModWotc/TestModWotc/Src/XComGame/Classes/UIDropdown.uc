//----------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIDropdown.uc
//  AUTHOR:  Samuel Batista
//  PURPOSE: UIDropdown that controls a UI dropdown widget.
//----------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//----------------------------------------------------------------------------

class UIDropdown extends UIPanel;

var string		 Label;
var string		 Description;
var array<string> Items;
var array<string> Data;
var int			 SelectedItem;
var bool			 AllItemsLoaded;
var bool			 IsOpen;
var bool			 OpenOnHover;

var private int LastSelected; //bsg-nlong (12.16.16): Used to return to SelectedItem to the previous value on a B press

var delegate<OnItemsLoadedCallback> OnItemsLoadedDelegate;
var delegate<OnSelectionChangedCallback> OnItemSelectedDelegate;

delegate OnItemsLoadedCallback(UIDropdown DropdownControl);
delegate OnSelectionChangedCallback(UIDropdown DropdownControl);

simulated function UIDropdown InitDropdown(optional name InitName, optional string startingLabel, optional delegate<OnSelectionChangedCallback> itemSelectedDelegate)
{
	InitPanel(InitName);
	SetLabel(startingLabel);
	Navigator.CheckForOwnerHandling = NavigationCheckForOwnerHandling;
	
	if(itemSelectedDelegate != none) 
		onItemSelectedDelegate = itemSelectedDelegate;
	return self;
}

simulated function UIDropdown SetLabel(string newLabel)
{
	if(label != newLabel)
	{
		label = newLabel;
		mc.FunctionString("setButtonLabel", label);
	}
	return self;
}

simulated function UIDropdown SetDescription(string newDescription)
{
	if(description != newDescription)
	{
		description = newDescription;
		mc.FunctionString("setButtonText", description);
	}
	return self;
}

// example of function with custom params
public function UIDropdown AddItem(string itemText, optional coerce string itemData)
{
	mc.BeginFunctionOp("AddListItem");
	mc.QueueNumber(float(items.Length));
	mc.QueueString(itemText);
	mc.EndOp();
	
	Items.AddItem(itemText);                 // store item text in case we need to access it later
	Data.AddItem(itemData);

	return self;
}

simulated function UIDropdown SetSelected(int itemIndex)
{
	if(SelectedItem != itemIndex)
	{
		SelectedItem = itemIndex;
		
		// setting selection before all items are loaded doesn't do anything
		if(allItemsLoaded)
		{
			mc.FunctionNum("setSelected", itemIndex);
		}
	}
	return self;
}

simulated function string GetSelectedItemText()
{
	return Items[SelectedItem];
}

simulated function string GetSelectedItemData()
{
	return Data[SelectedItem];
}

simulated function string GetItemText(int itemIndex)
{
	return Items[itemIndex];
}

simulated function UIDropdown Open()
{
	if(!isOpen)
	{
		LastSelected = SelectedItem;
		
		// close all other dropdowns
		class'UIUtilities_Controls'.static.CloseAllDropdowns(screen);

		isOpen = true;
		//mc.FunctionBool("playListboxAnim", isOpen);

		mc.FunctionVoid("openDropdown");

		//bsg-nlong (12.16.16): end

	}
	return self;
}

simulated function UIDropdown Close()
{
	if(isOpen)
	{
		isOpen = false;
		//mc.FunctionBool("playListboxAnim", isOpen);

		mc.FunctionVoid("closeDropdown");

		//bsg-nlong (12.16.16): end
	}
	return self;
}

simulated function BackOut()
{
	SetSelected(LastSelected); //bsg-nlong(12.16.16): If cancelling set the member variable to reflect the last selected index in the list
	Close();
}

simulated function UIDropdown Clear()
{
	Close();
	SelectedItem = -1;
	if(Items.Length > 0)
	{
		Items.Length = 0;
		Data.Length = 0;
		allItemsLoaded = false;
		mc.FunctionVoid("clearList");
	}
	return self;
}

simulated function UIDropdown HideButton()
{
	mc.FunctionVoid("hideButton");
	return self;
}

simulated function UIDropdown ShowButton()
{
	mc.FunctionVoid("showButton");
	return self;
}

simulated function OnCommand(string cmd, string arg)
{
	if(cmd == "allItemsLoaded")
	{
		allItemsLoaded = true;
		
		if(SelectedItem < 0 || SelectedItem >= Items.Length)
		{
			SelectedItem = 0;
		}

		// refresh selection if it was set before items were loaded
		if(SelectedItem != class'UIDropdown'.default.SelectedItem)
			mc.FunctionNum("setSelected", SelectedItem);
		else
			mc.FunctionNum("setSelected", 0);

		if(onItemsLoadedDelegate != none)
			onItemsLoadedDelegate(self);
	}
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	if ( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	switch (cmd)
	{
		case class'UIUtilities_Input'.const.FXS_KEY_ENTER:
		case class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR:
		case class'UIUtilities_Input'.const.FXS_BUTTON_A:
			if(isOpen)
			{
				Close();
				//bsg-nlong (12.16.16): Put the make selection here when the drop down colaapses and the selection is made
				SetSelected(SelectedItem);
				LastSelected = SelectedItem;
				if(onItemSelectedDelegate != none)
					onItemSelectedDelegate(self);
				//bsg-nlong (12.16.16): end
			}
			else
				Open();
			return true;
		case class'UIUtilities_Input'.const.FXS_ARROW_UP:
		case class'UIUtilities_Input'.const.FXS_DPAD_UP:
		case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_UP:
			if(isOpen)
			{
				Next();
				return true;
			}
			break;
		case class'UIUtilities_Input'.const.FXS_ARROW_DOWN:
		case class'UIUtilities_Input'.const.FXS_DPAD_DOWN:
		case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_DOWN:
			if(isOpen)
			{
				Prev();
				return true;
			}
			break;
			
		case class'UIUtilities_Input'.const.FXS_BUTTON_B :
		case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE :
		case class'UIUtilities_Input'.const.FXS_R_MOUSE_DOWN :
			if (isOpen)
			{
				BackOut();
				return true;
			}
			break;
		//</workshop>
	}

	return super.OnUnrealCommand(cmd, arg);
}

simulated function OnMouseEvent(int cmd, array<string> args)
{
	local int selectedIndex;

	// send a clicked callback
	if(cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_UP)
	{
		if(args[args.Length - 1] == "theButton")
		{
			if(!isOpen)
				Close();
			else
				Open();
		}
		else
		{
			selectedIndex = int(args[args.Length - 1]);
			if(selectedIndex != -1)
			{
				Close();
				SetSelected(selectedIndex);
				if(onItemSelectedDelegate != none)
					onItemSelectedDelegate(self);
			}
		}
	}
	super.OnMouseEvent(cmd, args);
}

function Next()
{
	if( isOpen )
	{
		SelectedItem = SelectedItem - 1;
		if( SelectedItem < 0 )
			SelectedItem = Items.Length - 1;

		MC.FunctionNum("setFocusIndex", SelectedItem);
	}
}

function Prev()
{
	if( isOpen )
	{
		SelectedItem = (SelectedItem + 1) % Items.Length;
		MC.FunctionNum("setFocusIndex", SelectedItem);
	}
}

function bool NavigationCheckForOwnerHandling(bool bIsNext)
{
	if( isOpen )
	{
		bIsNext ? Prev() : Next();
		return true; 
	}
	else
	{
		return false;
	}
}

defaultproperties
{
	label = "undefined"; // this forces the SetLabel call to go through with the empty string
	SelectedItem = -1;
	LibID = "DropdownControl";
	bProcessesMouseEvents = true;
}
