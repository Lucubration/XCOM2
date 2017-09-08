//---------------------------------------------------------------------------------------
//  FILE:    UICovertActionSlot.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class UICovertActionSlot extends Object
	dependson(UIPersonnel, XComGameState_CovertAction, UICovertActions, UICovertActionReport);

var StateObjectReference ActionRef;

//var UIImage m_kSlotImage;
//var UIButton m_kSlotButton; // , m_kClearButton;
//var UIText m_kSlotStatus, m_kSlotReward;

var UICovertActionSlotContainer SlotContainer;
var bool bSizeRealized;
var bool IsDisabled;
var int MCIndex;
var EUIState eState;

var string PromoteLabel;
var string Value1;
var string Value2;
var string Value3;
var string Value4; //Automatically red / negative. 

var public delegate<OnSlotUpdated> onSlotUpdatedDelegate;
delegate OnSlotUpdated();

//-----------------------------------------------------------------------------
function UICovertActionSlot InitStaffSlot(UICovertActionSlotContainer OwningContainer, StateObjectReference Action, int _MCIndex, int _SlotIndex, delegate<OnSlotUpdated> onSlotUpdatedDel)
{		
	ActionRef = Action;
	SlotContainer = OwningContainer;
	onSlotUpdatedDelegate = onSlotUpdatedDel;
	MCIndex = _MCIndex;

//	ProcessMouseEvents(OnClickSlot);

	UpdateData();
		
	return self;
}

function UpdateData()
{
	// Implement in subclasses
}

function Update(string SlotLabel, string SlotValue, string SlotButton, string SlotImage, optional string RankImage = "", optional string ClassImage = "", optional string SlotButton2 = "" )
{
	if ( UICovertActions(SlotContainer.Screen) != none)
		UICovertActions(SlotContainer.Screen).AS_SetSlotData(MCIndex, eState, SlotImage, RankImage, ClassImage, SlotLabel, SlotValue, SlotButton, SlotButton2);
	else
		UICovertActionReport(SlotContainer.Screen).AS_SetSlotData(MCIndex, eState, SlotImage, RankImage, ClassImage, SlotLabel, PromoteLabel, Value1, Value2, Value3, Value4);

	//Show();
}

function HandleClick(string ButtonName)
{
	// Implement in subclasses
}

//bsg-jneal (3.10.17): adding controller navigation support for staff slots
function bool CanEditLoadout()
{
	// Implement in subclasses
}
//bsg-jneal (3.10.17): end

function ClearSlot()
{
	// Implement in subclasses
	//Hide();
	//UICovertActions(SlotContainer.Screen).AS_ClearSlotData(SlotIndex);
}

function OnClickSlot(UIPanel kControl, int cmd)
{
	switch (cmd)
	{
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_UP:
		//HandleClick(kControl);
		break;
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_IN:
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_OVER:
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OVER:
		`SOUNDMGR.PlaySoundEvent("Play_Mouseover");
		break;
	}
}

function OnClickedSlotButton(string ButtonName)
{
	HandleClick(ButtonName);
}

function OnClickedClearButton(UIButton Button)
{
	ClearSlot();
}

function UpdateDisplay()
{
	UpdateData();

	if (onSlotUpdatedDelegate != none)
		onSlotUpdatedDelegate();
}

function XComGameState_CovertAction GetAction()
{
	return XComGameState_CovertAction(`XCOMHISTORY.GetGameStateForObjectID(ActionRef.ObjectID));
}

//==============================================================================
