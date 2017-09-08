class UIFacility_CovertOpsStatus extends UIPanel;

const EVENTQUEUEICON_STAFF = "_staff";
const EVENTQUEUEICON_RESOURCE = "_resource";

var array<string> SlotColors, SlotTypes;

var string FactionIcon;
var string Label;

var localized string CovertOpsStatus_EmptyTitle;
var localized string CovertOpsStatus_EmptyLabel;

simulated function UIFacility_CovertOpsStatus InitCovertOpsStatus()
{
	InitPanel();

	return self;
}
public function SetEmpty()
{
	local array<string> Colors, Types;
	local  int i;

	MC.FunctionString("setDaysLabel", "");
	MC.FunctionString("setDaysValue", "");
	MC.FunctionString("setLabel", CovertOpsStatus_EmptyLabel);// 'UIUtilities_Text'.static.GetColoredText(CovertOpsStatus_EmptyLabel, eUIState_Bad));
	MC.FunctionString("setTitle", CovertOpsStatus_EmptyTitle);// 'UIUtilities_Text'.static.GetColoredText(CovertOpsStatus_EmptyTitle, eUIState_Bad));

	for( i = 0; i < 4; i++ )
	{
		Colors.AddItem("");
		Types.AddItem("");
	}
	AS_UpdateSlotData(Colors, Types);

	MC.FunctionVoid("setEmpty");
}

public function Refresh(XComGameState_CovertAction ActionState)
{
	local string TimeValue, TimeLabel, Desc;
	local int Hours; 
	local XComGameState_ResistanceFaction FactionState;
	
	FactionState = ActionState.GetFaction();

	Hours = ActionState.GetNumHoursRemaining();
	// Let the utility auto format: 
	class'UIUtilities_Text'.static.GetTimeValueAndLabel(Hours, TimeValue, TimeLabel, 0);

	if( Hours < 0 )
	{
		Desc = class'UIUtilities_Text'.static.GetColoredText(Desc, eUIState_Warning);
		TimeLabel = " ";
		TimeValue = "--";
	}
	MC.FunctionString("setDaysLabel", TimeLabel);
	MC.FunctionString("setDaysValue", TimeValue);

	MC.FunctionString("setLabel", class'UICovertActions'.default.CovertActions_ScreenHeader);
	MC.FunctionString("setTitle", ActionState.GetDisplayName());

	UpdateSlotData(ActionState);
	AS_SetFactionIcon(FactionState.GetFactionIcon());

	MC.FunctionVoid("setActive");
}

function UpdateSlotData(XComGameState_CovertAction Action)
{
	local array<string> Colors, Types;
	local  int i;
	local XComGameState_StaffSlot StaffSlot;

	for( i = 0; i < Action.StaffSlots.Length; i++ )
	{
		StaffSlot = Action.GetStaffSlot(i);
		if( StaffSlot.IsSlotFilled() )
		{
			if( StaffSlot.IsScientistSlot() )
			{
				Colors.AddItem(class'UIUtilities_Colors'.const.SCIENCE_HTML_COLOR);
				Types.AddItem(EVENTQUEUEICON_STAFF);
			}
			else if( StaffSlot.IsEngineerSlot() )
			{
				Colors.AddItem(class'UIUtilities_Colors'.const.ENGINEERING_HTML_COLOR);
				Types.AddItem(EVENTQUEUEICON_STAFF);
			}
			else // For soldiers, and default case
			{
				Colors.AddItem(class'UIUtilities_Colors'.const.NORMAL_HTML_COLOR);
				Types.AddItem(EVENTQUEUEICON_STAFF);
			}
		}
	}

	for( i = 0; i < Action.CostSlots.Length; i++ )
	{
		if( Action.CostSlots[i].bPurchased )
		{
			Colors.AddItem(class'UIUtilities_Colors'.const.GOOD_HTML_COLOR);
			Types.AddItem(EVENTQUEUEICON_RESOURCE);
		}
	}

	AS_UpdateSlotData(Colors, Types);
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

defaultproperties
{
	LibID = "FacilityCovertOpStatus";
	bIsNavigable = false;
	bProcessesMouseEvents = false; 
}