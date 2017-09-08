//----------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UICovertActionSlotContainer.uc
//  AUTHOR:  Joe Weinhoffer
//  PURPOSE: Container that will load in and format covert action slot items.
//----------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//----------------------------------------------------------------------------

class UICovertActionSlotContainer extends UIPanel
	dependson(UICovertActionSlot);

var array<UICovertActionSlot> ActionSlots;
var array<UIPanel> ActionSlotPanels;  // bsg-nlong (1.20.17): A parallel array of the panels that display the action slot info

simulated function UICovertActionSlotContainer InitSlotContainer(optional name InitName)
{
	local int i;

	InitPanel(InitName);
	

	if( UICovertActions(Screen) != none )
	{
		// bsg-nlong (1.20.17): Setting the panels in the script to apply to panels that already exist on the stage
		// see XPACK_CovertOps.fla
		for( i = 0; i < 4; i++ )
		{
			ActionSlotPanels[i] = Spawn(class'UIPanel', self).InitPanel(name("slotMC_" $ i), 'CovertOpsSlot');
		}
		// bsg-nlong (1.20.17): end
	}
	return self;
}

simulated function HardReset()
{
	ActionSlots.Length = 0; 
}

simulated function Refresh(StateObjectReference ActionRef, delegate<UICovertActionSlot.OnSlotUpdated> onSlotUpdatedDelegate)
{
	local XComGameState_CovertAction Action;
	local int i, SlotMCID;
	local UICovertActionStaffSlot NewStaffItem; 
	local UICovertActionCostSlot NewCostItem; 

	//ClearSlots();

	Action = XComGameState_CovertAction(`XCOMHISTORY.GetGameStateForObjectID(ActionRef.ObjectID));
	SlotMCID = -1; 

	// Show or create staff slots for the currently requested covert action
	for (i = 0; i < Action.StaffSlots.Length; i++)
	{
		// If the staff slot is optional and the tutorial has not been completed, do not display it
		if (!class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('XP2_M0_FirstCovertActionTutorial') && Action.StaffSlots[i].bOptional)
		{
			continue;
		}

		// If the staff slot is hidden, or the action has been completed and the slot was not filled, do not display it
		if (!Action.ShouldStaffSlotBeDisplayed(i))
		{
			continue;
		}

		SlotMCID++; 

		// Update any slots which already exist, accounting for slots that were skipped during creation
		if (SlotMCID < ActionSlots.Length )
		{
			if(UICovertActionStaffSlot(ActionSlots[SlotMCID]) != none)
				ActionSlots[SlotMCID].UpdateData();
			else
				`log("UI slot update problem! STAFF", , 'uixcom');
		}
		else
		{
			NewStaffItem = new(self) class'UICovertActionStaffSlot';
			ActionSlots.AddItem(NewStaffItem.InitStaffSlot(self, ActionRef, SlotMCID, i, onSlotUpdatedDelegate));
		}
	}

	// Then create any optional cost slots if the first CA tutorial has been completed
	if (class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('XP2_M0_FirstCovertActionTutorial'))
	{
		for (i = 0; i < Action.CostSlots.Length; i++)
		{
			if (Action.ShouldCostSlotBeDisplayed(i))
			{
				SlotMCID++;

				if (SlotMCID < ActionSlots.Length)
				{
					if (UICovertActionCostSlot(ActionSlots[SlotMCID]) != none)
						ActionSlots[SlotMCID].UpdateData();
					else
						`log("UI slot update problem! COPST", , 'uixcom');
				}
				else
				{
					NewCostItem = new(self) class'UICovertActionCostSlot';
					ActionSlots.AddItem(NewCostItem.InitStaffSlot(self, ActionRef, SlotMCID, i, onSlotUpdatedDelegate));
				}
			}
		}
	}

	//Clear any remaining slots 
	for (i = SlotMCID+1; i < 4; i++)
	{
		if( UICovertActionReport(Screen) != none )
		{
			UICovertActionReport(Screen).AS_SetSlotData(i, eUIState_Disabled, "", "", "", "", "", "", "", "", "");
		}
		else
		{
			UICovertActions(Screen).AS_SetSlotData(i, eUIState_Disabled, "", "", "", "", "", "", "");
		}
	}
}

simulated function ClearSlots()
{
	local int i;

	// Show or create slots for the currently requested covert action
	for (i = 0; i < ActionSlots.length; i++)
	{
		ActionSlots[i].ClearSlot();
	}

	for( i = 0; i < 4; i++ )
	{
		if( UICovertActionReport(Screen) != none )
		{
			UICovertActionReport(Screen).AS_SetSlotData(i, eUIState_Disabled, "", "", "", "", "", "", "", "", "");
		}
		else
		{
			UICovertActions(Screen).AS_ClearSlotData(i);
		}
	}

	ActionSlots.length = 0; 
}

// bsg-jrebar (3/30/17 ) : Loops for enable and disable of mouse hits on parent screen disable
simulated function DisableAllSlots()
{
	local int i;
	for (i = 0; i < ActionSlots.length; i++)
	{
		ActionSlots[i].IsDisabled = true;
		ActionSlotPanels[i].DisableMouseHit();
	}
}

simulated function EnableAllSlots()
{
	local int i;
	for (i = 0; i < ActionSlots.length; i++)
	{
		ActionSlots[i].IsDisabled = false;
		ActionSlotPanels[i].EnableMouseHit();
	}
}
// bsg-jrebar (3/30/17) : end

defaultproperties
{
	MCName = "infoPanelMC";
	bIsNavigable = true;
}
