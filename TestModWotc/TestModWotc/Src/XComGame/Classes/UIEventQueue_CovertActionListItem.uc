//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIEventQueue_CovertActionListItem.uc
//  AUTHOR:  Brit Steiner
//  PURPOSE: Individual event list item that connects to a flash library asset. 
//
//---------------------------------------------------------------------------------------
//  Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIEventQueue_CovertActionListItem extends UIEventQueue_ListItem;

const EVENTQUEUEICON_STAFF = "_staff";
const EVENTQUEUEICON_RESOURCE = "_resource";

var bool bHasTooltips; 

var array<string> SlotColors, SlotTypes; 

var string FactionIcon; 
var string Label; 

var UIPanel Background; 

simulated function OnInit()
{
	super.OnInit();
	Background = Spawn(class'UIPanel', self);
	Background.InitPanel('bgMC').ProcessMouseEvents(OnChildMouseEvent);
}

simulated function OnChildMouseEvent(UIPanel control, int cmd)
{
	if (control == Background)
	{
		switch (cmd)
		{
		case class'UIUtilities_Input'.const.FXS_L_MOUSE_IN :
		case class'UIUtilities_Input'.const.FXS_L_MOUSE_OVER :
		case class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OVER :
			OnReceiveFocus();
			break;
		case class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT :
		case class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OUT :
		case class'UIUtilities_Input'.const.FXS_L_MOUSE_RELEASE_OUTSIDE :
			OnLoseFocus();
			break;
		case class'UIUtilities_Input'.const.FXS_L_MOUSE_UP :
			OpenCovertActionScreen();
			break;
		}
	}
}

simulated function OpenCovertActionScreen()
{
	local XComGameState_HeadquartersResistance ResHQ;
	local XComGameState_FacilityXCom FacilityState;

	ResHQ = XComGameState_HeadquartersResistance(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));

	// If the Ring is built, bring the player there
	if (IsResistanceRingAvailable())
	{
		FacilityState = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom')).GetFacilityByName('ResistanceRing');
		if (FacilityState != None)
		{
			FacilityState.GetMyTemplate().SelectFacilityFn(FacilityState.GetReference());
			`HQPRES.UICovertActions();
		}
	}
	else if (IsActionInProgress() || !ResHQ.bCovertActionStartedThisMonth)
	{
		`HQPRES.UICovertActions();
	}
}

simulated function string GetFactionFrameLabel(StateObjectReference ActionRef)
{
	local StateObjectReference NoneRef; 
	local Name FactionName; 

	if( ActionRef == NoneRef ) return ""; 

	FactionName = GetAction(ActionRef).GetFaction().GetMyTemplateName();
	return class'UIUtilities_Image'.static.GetFlashLabelForFaction(FactionName);
}

simulated function UpdateData(HQEvent Event)
{
	local string ActionLabel;

	super.UpdateData(Event);	

	ActionLabel = class'UICovertActions'.default.CovertActions_ScreenHeader;
	
	UpdateSlotData(Event.ActionRef);
	AS_SetLabel(ActionLabel);
}


simulated function AS_SetLabel(string NewValue)
{
	if( Label != NewValue )
	{
		Label = NewValue;
		MC.FunctionString("setLabel", Label);
	}
}


simulated function SetIconImage(string NewValue)
{
	//Do Nothing
	return;
}
simulated function XComGameState_CovertAction GetAction(StateObjectReference ActionRef)
{
	return XComGameState_CovertAction(`XCOMHISTORY.GetGameStateForObjectID(ActionRef.ObjectID));
}

simulated function bool IsActionInProgress()
{
	return XComGameState_HeadquartersResistance(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance')).IsCovertActionInProgress();
}

simulated function bool IsResistanceRingAvailable()
{
	return XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom')).HasFacilityByName('ResistanceRing');
}

function UpdateSlotData(StateObjectReference ActionRef)
{
	local array<string> Colors, Types;
	local  int i;
	local XComGameState_CovertAction Action;
	local XComGameState_StaffSlot StaffSlot;
	local CovertActionStaffSlot CovertStaffSlot;
	local XComGameState_Reward RewardState;
	local XComGameStateHistory History;
	local XComGameState_ResistanceFaction FactionState;

	History = `XCOMHISTORY;
	Action = GetAction(ActionRef);
	if (Action != none)
	{
		FactionState = Action.GetFaction();
		for (i = 0; i < Action.StaffSlots.Length; i++)
		{
			StaffSlot = Action.GetStaffSlot(i);
			if (StaffSlot.IsSlotFilled())
			{
				CovertStaffSlot = Action.StaffSlots[i];
				RewardState = XComGameState_Reward(History.GetGameStateForObjectID(CovertStaffSlot.RewardRef.ObjectID));

				if (StaffSlot.IsScientistSlot())
				{
					Colors.AddItem(class'UIUtilities_Colors'.const.SCIENCE_HTML_COLOR);
					Types.AddItem(EVENTQUEUEICON_STAFF);
				}
				else if (StaffSlot.IsEngineerSlot())
				{
					Colors.AddItem(class'UIUtilities_Colors'.const.ENGINEERING_HTML_COLOR);
					Types.AddItem(EVENTQUEUEICON_STAFF);
				}
				else // For soldiers, and default case
				{
					Colors.AddItem(class'UIUtilities_Colors'.const.NORMAL_HTML_COLOR);
					Types.AddItem(EVENTQUEUEICON_STAFF);
				}

				if(!bHasTooltips)
				{
					if (RewardState != None)
						AddSlotTooltip(i, StaffSlot.GetNameDisplayString() $"<br \>" $ RewardState.GetRewardString());
					else
						AddSlotTooltip(i, StaffSlot.GetNameDisplayString());
				}
			}
		}

		for (i = 0; i < Action.CostSlots.Length; i++)
		{
			if (Action.CostSlots[i].bPurchased)
			{
				Colors.AddItem(class'UIUtilities_Colors'.const.GOOD_HTML_COLOR);
				Types.AddItem(EVENTQUEUEICON_RESOURCE);

				Movie.Pres.m_kTooltipMgr.RemoveTooltipsByPartialPath(MCPath $".slot"$i);
			}
		}

		AS_UpdateSlotData(Colors, Types);

		if (FactionState != none)
		{
			AS_SetFactionIcon(FactionState.GetFactionIcon());
		}

		MC.FunctionVoid("setActive");
	}
	else
	{
		MC.FunctionVoid("setEmpty");
	}
	
	bHasTooltips = true; 
}

private function AddSlotTooltip(int index, string DisplayText)
{
	Movie.Pres.m_kTooltipMgr.AddNewTooltipTextBox(DisplayText, -15, 0, MCPath $".slot"$index, , false, class'UIUtilities'.const.ANCHOR_TOP_RIGHT, true, , , , , , 0.0);
}

function AS_UpdateSlotData(array<string> NewSlotColors, array<string> NewSlotTypes)
{
	local int i;
	
	if( SlotColors.length == NewSlotColors.length && SlotTypes.length == NewSlotTypes.length ) return;

	SlotColors = NewSlotColors;
	SlotTypes = NewSlotTypes; 

	MC.BeginFunctionOp("setSlotData");

	//May be zero to four rewards displayed here 
	for( i = 0; i < SlotColors.length; i++ ) 
	{
		MC.QueueString(SlotColors[i]);
		MC.QueueString(SlotTypes[i]);
	}

	if( SlotColors.Length > 4 ) `log("UI Event Queue: Covert Action: You're sending in too many resources. Note any beyond 4 will not be displayed.", , 'uixcom');

	//fill any remaining slots with blank data
	for( i = SlotColors.length; i < 4; i++ ) //Max of 4 slots 
	{
		MC.QueueString("");
		MC.QueueString("");
	}

	MC.EndOp();

}
public function AS_SetFactionIcon(StackedUIIconData IconInfo)
{
	local int i;

	if (IconInfo.Images.Length > 0)
	{
		MC.BeginFunctionOp("SetFaction");
		MC.QueueBoolean(IconInfo.bInvert);
		for (i = 0; i < IconInfo.Images.Length; i++)
		{
			MC.QueueString("img:///" $ Repl(IconInfo.Images[i], ".tga", "_sm.tga"));
		}

		MC.EndOp();
	}
}

simulated function OnMouseEvent(int Cmd, array<string> Args)
{
	if (Cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_UP)
	{
		if (Args[Args.length - 2] == string(MCName))
			OpenCovertActionScreen();
	}

	super.OnMouseEvent(cmd, Args);
}

defaultproperties
{
	LibID = "CovertActionEventListItem";
	height = 95;
	bHasTooltips = false;
}