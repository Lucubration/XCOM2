//----------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIList_SquadEditor.uc
//  AUTHOR:  Jake Akemann
//  PURPOSE: This extends UIList, handling functionality for UISquadSelect_ListItem
//----------------------------------------------------------------------------

class UIList_SquadEditor extends UIList;

simulated function OnInit()
{
	Super.OnInit();
	Navigator = none;
	InitPosition();
}

//centers the squad list
simulated function InitPosition()
{
	local int AnchorOffSetX;

	AnchorOffSetX = X;
	AnchorBottomCenter();
	SetX(-Width / 2.0 + AnchorOffSetX);
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local bool bHandled;
	local int StartingIndex;

	StartingIndex = SelectedIndex;

	// Only pay attention to presses or repeats; ignoring other input types
	// NOTE: Ensure repeats only occur with arrow keys
	if ( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	bHandled = true;
	
	switch( cmd )
	{
		case class'UIUtilities_Input'.const.FXS_BUTTON_A :
		case class'UIUtilities_Input'.const.FXS_KEY_ENTER:
			HandleControllerSelect();
			break;

		case class'UIUtilities_Input'.const.FXS_BUTTON_LBUMPER:
			ShiftFocus(FALSE);
			break;

		case class'UIUtilities_Input'.const.FXS_BUTTON_RBUMPER :
		case class'UIUtilities_Input'.const.FXS_KEY_TAB :
			ShiftFocus(TRUE);
			break;

		case class'UIUtilities_Input'.const.FXS_DPAD_DOWN:
		case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_DOWN :
		case class'UIUtilities_Input'.const.FXS_ARROW_DOWN:
			ShiftFocusVertical(TRUE);
			break;

		case class'UIUtilities_Input'.const.FXS_DPAD_UP:
		case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_UP :
		case class'UIUtilities_Input'.const.FXS_ARROW_UP:
			ShiftFocusVertical(FALSE);
			break;

		case class'UIUtilities_Input'.const.FXS_DPAD_LEFT:
		case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_LEFT :
		case class'UIUtilities_Input'.const.FXS_ARROW_LEFT :
			if (!ShiftFocusHorizontal(FALSE))
			{
				ShiftFocus(false);
			}

			break;

		case class'UIUtilities_Input'.const.FXS_DPAD_RIGHT:
		case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_RIGHT :
		case class'UIUtilities_Input'.const.FXS_ARROW_RIGHT :
			if (!ShiftFocusHorizontal(TRUE))
			{
				ShiftFocus(true);
			}

			break;
		default:
			bHandled = false;
			break;
	}

	//if we move the currently selected item to the top, change the selection to the item that got moved into that location
	if (StartingIndex == SelectedIndex && OnSelectionChanged != none)
		OnSelectionChanged(self, SelectedIndex);

	return bHandled || super.OnUnrealCommand(cmd, arg);
}

//Finds the next available index (looping if it moves out of bounds)
simulated function INT LoopListItemIndex(INT Index, Bool bDownward)
{
	Index = bDownward ? Index + 1 : Index - 1;
	if(Index < 0)
		Index = ItemCount - 1;
	Index = Index % ItemCount;

	return Index;
}

//cycles through ListItems and returns the first one that is focused
//(note: if the mouse is allowed with the controller, there may be more than one focused at a time)
simulated function UISquadSelect_ListItem GetActiveListItem()
{
	local UISquadSelect_ListItem ListItem;
	local int Index;

	//attempts to return the first item found that is in focus
	for(Index = 0; Index < ItemCount; ++Index)
	{
		ListItem = UISquadSelect_ListItem(GetItem(Index));
		if(ListItem != None && ListItem.bIsFocused)
			return ListItem;
	}

	//attempts to return the first item found that is not disabled (used for finding the initial focus)
	for(Index = 0; Index < ItemCount; ++Index)
	{
		ListItem = UISquadSelect_ListItem(GetItem(Index));
		if(ListItem != None && !ListItem.bDisabled)
		{
			SetSelectedItem(ListItem); // bsg-jrebar (5/18/17): When returning a new item as active, make it the real selected item
			return ListItem;
		}
	}

	//should never hit this point as there will always be non-disabled listItems in-game
	SetSelectedItem(GetItem(0)); // bsg-jrebar (5/18/17): When returning a new item as active, make it the real selected item
	return UISquadSelect_ListItem(GetItem(0));
}

// bsg-jrebar (5/16/17): Gain/Remove focus for first selected item on UI
simulated function SelectFirstListItem()
{
	local UISquadSelect_ListItem ListItem, PrevListItem;
	local int Index;
	local bool bFoundIndex;

	// bsg-jrebar (5/30/17): Adding SelectFirst to select the old previously selected item slot or the actual first item in the list
	PrevListItem = UISquadSelect_ListItem(GetSelectedItem());

	if(PrevListItem == none)
	{
	PrevListItem = GetActiveListItem();
	}

	if (PrevListItem != none)
	{
		PrevListItem.OnLoseFocus();
	}
	
	bFoundIndex = false;
	ListItem = UISquadSelect_ListItem(GetSelectedItem());
	if(ListItem != none)
	{
		bFoundIndex = true;
		Index = SelectedIndex;
	}
	else
	{
	for (Index = 0; Index < ItemCount; Index++)
	{
		ListItem = UISquadSelect_ListItem(GetItem(Index));
		if (ListItem != none && !ListItem.bDisabled && ListItem.HasUnit())
		{
			bFoundIndex = true;
			break;
		}
	}

	if (!bFoundIndex)
	{
		for (Index = 0; Index < ItemCount; Index++)
		{
			ListItem = UISquadSelect_ListItem(GetItem(Index));
			if (ListItem != none && !ListItem.bDisabled)
			{
				break;
			}
		}
	}
	}
	// bsg-jrebar (5/30/17): end

	ListItem.OnReceiveFocus();
	ListItem.SetSquadSelectButtonFocus(PrevListItem.m_eActiveButton, false);

	SelectedIndex = Index;
}
// bsg-jrebar (5/16/17): end

//The list items are normally given focus using only "mouseover" events set in actionscript, this function simulates that if the player is using a controller
simulated function ShiftFocus(Bool bForward)
{
	local UISquadSelect_ListItem ListItem, PrevListItem;
	local int PrevIndex, Index;

	PrevListItem = GetActiveListItem();
	PrevIndex = GetItemIndex(PrevListItem);
	Index = PrevIndex;

	//Focused ListItem was found
	if(PrevListItem != None)
	{
		//Remove Current Focus
		PrevListItem.OnLoseFocus();

		//Find index of next ListItem in sequence
		do
		{
			Index = LoopListItemIndex(Index, bForward);
			ListItem = UISquadSelect_ListItem(GetItem(Index));
		}
		until ( ListItem != None && !ListItem.bDisabled );		

		// bsg-jrebar (5/18/17): 
		// the edges
		// 1. new index is less than previous, meaning we are moving left.
		// 2. previous index is the first slot and we are looping (first can be 0 or 1 depending)

		if(Index < PrevIndex || ( PrevIndex == 0 && Index != 1) || (PrevIndex == 1 && Index == 0 && UISquadSelect_ListItem(GetItem(0)).HasUnit()) )
			ListItem.SetSquadSelectButtonFocus(PrevListItem.m_eActiveButton, true);
		else
			ListItem.SetSquadSelectButtonFocus(PrevListItem.m_eActiveButton, false);

		SetSelectedIndex( Index );
		// bsg-jrebar (5/18/17): end
		
		// bsg-jrebar (5/16/17): Play sound on shift
		PlaySound(SoundCue'SoundUI.MenuScrollCue', true);
	}
}

//while a Listitem is in focus, this function simulates the player hovering their mouse over specific buttons contained within the ListItem
simulated function ShiftFocusVertical(Bool bDownward)
{
	local UISquadSelect_ListItem ListItem;

	ListItem = GetActiveListItem();
	if (ListItem != None)
	{
		// bsg-jrebar (5/16/17): Play sound on shift
		PlaySound(SoundCue'SoundUI.MenuScrollCue', true);

		ListItem.ShiftButtonFocus(bDownward);
	}
}

//cycles through the utility items while the player is focused on that them
simulated function bool ShiftFocusHorizontal(Bool bIncreasing)
{
	local UISquadSelect_ListItem ListItem;

	ListItem = GetActiveListItem();
	if (ListItem != None)
	{
		// bsg-jrebar (5/16/17): Play sound on shift
		PlaySound(SoundCue'SoundUI.MenuScrollCue', true);

		return ListItem.ShiftHorizontalFocus(bIncreasing);
	}
	return false;
}

//marks the currently selected list item as dirty (if it exists)
simulated function MarkActiveListItemAsDirty()
{
	/*local UISquadSelect_ListItem ListItem;

	ListItem = GetActiveListItem();
	//if(ListItem != None)
	//	ListItem.bDirty = true;
	*/
}

simulated function MarkAllListItemsAsDirty()
{
	/*local UISquadSelect_ListItem ListItem;
	local int i;

	for(i = 0; i<ItemCount; i++)
	{
		ListItem = UISquadSelect_ListItem(GetItem(i));
		if(ListItem != None)
			ListItem.bDirty = true;
	}*/
}

//simulates a mouse click by determining which button is focused on the listItem
simulated function HandleControllerSelect()
{
	local UISquadSelect_ListItem ListItem;

	ListItem = GetActiveListItem();
	if(ListItem != None)
		ListItem.HandleButtonSelect();
}

// bsg-jrebar (5/18/17): Brought over from MPLobby.  Sets our new selected index internally so we can track.
simulated function UIList SetSelectedIndex(int Index, optional bool bForce)
{
	if(Index != SelectedIndex || bForce)
	{
		if(SelectedIndex > INDEX_NONE && SelectedIndex < ItemCount)
			GetSelectedItem().OnLoseFocus();

		SelectedIndex = Index;

		if(SelectedIndex > INDEX_NONE && SelectedIndex < ItemCount)
			GetSelectedItem().OnReceiveFocus();

		if(OnSelectionChanged != none)
			OnSelectionChanged(self, SelectedIndex);
	}
	
	if(OnSetSelectedIndex != none)
		OnSetSelectedIndex(self, SelectedIndex);

	// lists with a valid selected index are considered "focused" for navigation purposes
	bIsFocused = SelectedIndex > -1 && SelectedIndex < ItemCount;
	return self;
}
// bsg-jrebar (5/18/17): end

// bsg-jrebar (5/30/17): This is overwritten by the List because we only focus the *selected* child, and not *all* children like the Panel does.  
simulated function OnReceiveFocus()
{
	local UIPanel SelectedChild;

	super.OnReceiveFocus();

	if( !bIsFocused )
	{
		bIsFocused = true;
		MC.FunctionVoid("onReceiveFocus");
	}

	SelectedChild = GetSelectedItem();

	if( SelectedChild != none )
		SelectedChild.OnReceiveFocus();
}
// bsg-jrebar (5/30/17): end

defaultproperties
{
}