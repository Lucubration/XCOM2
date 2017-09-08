//---------------------------------------------------------------------------------------
//  FILE:    UIFacility_AdvancedWarfareCenterSlot.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class UIFacility_AdvancedWarfareCenterSlot extends UIFacility_StaffSlot
	dependson(UIPersonnel);

var localized string m_strRespecSoldierDialogTitle;
var localized string m_strRespecSoldierDialogText;
var localized string m_strStopRespecSoldierDialogTitle;
var localized string m_strStopRespecSoldierDialogText;

simulated function UIStaffSlot InitStaffSlot(UIStaffContainer OwningContainer, StateObjectReference LocationRef, int SlotIndex, delegate<OnStaffUpdated> onStaffUpdatedDel)
{
	super.InitStaffSlot(OwningContainer, LocationRef, SlotIndex, onStaffUpdatedDel);

	return self;
}

//-----------------------------------------------------------------------------
simulated function ShowDropDown()
{
	local XComGameState_StaffSlot StaffSlot;
	local XComGameState_Unit UnitState;
	local string StopTrainingText;

	StaffSlot = XComGameState_StaffSlot(`XCOMHISTORY.GetGameStateForObjectID(StaffSlotRef.ObjectID));

	if (StaffSlot.IsSlotEmpty())
	{
		StaffContainer.ShowDropDown(self);
	}
	else // Ask the user to confirm that they want to empty the slot and stop training
	{
		UnitState = StaffSlot.GetAssignedStaff();

		StopTrainingText = m_strStopRespecSoldierDialogText;
		StopTrainingText = Repl(StopTrainingText, "%UNITNAME", UnitState.GetName(eNameType_RankFull));

		ConfirmEmptyProjectSlotPopup(m_strStopRespecSoldierDialogTitle, StopTrainingText);
	}
}

simulated function OnPersonnelSelected(StaffUnitInfo UnitInfo)
{
	local XComGameStateHistory History;
	local XGParamTag LocTag;
	local TDialogueBoxData DialogData;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit Unit;
	local UICallbackData_StateObjectReference CallbackData;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	Unit = XComGameState_Unit(History.GetGameStateForObjectID(UnitInfo.UnitRef.ObjectID));

	LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	LocTag.StrValue0 = Unit.GetName(eNameType_RankFull);
	LocTag.IntValue0 = XComHQ.GetRespecSoldierDays();

	CallbackData = new class'UICallbackData_StateObjectReference';
	CallbackData.ObjectRef = Unit.GetReference();
	DialogData.xUserData = CallbackData;
	DialogData.fnCallbackEx = RespecSoldierDialogCallback;

	DialogData.eType = eDialog_Alert;
	DialogData.strTitle = m_strRespecSoldierDialogTitle;
	DialogData.strText = `XEXPAND.ExpandString(m_strRespecSoldierDialogText);
	DialogData.strAccept = class'UIUtilities_Text'.default.m_strGenericYes;
	DialogData.strCancel = class'UIUtilities_Text'.default.m_strGenericNo;

	Movie.Pres.UIRaiseDialog(DialogData);
}

simulated function RespecSoldierDialogCallback(Name eAction, UICallbackData xUserData)
{
	local XComGameState_StaffSlot StaffSlot;
	local UICallbackData_StateObjectReference CallbackData;
	local StaffUnitInfo UnitInfo;

	CallbackData = UICallbackData_StateObjectReference(xUserData);

	if (eAction == 'eUIAction_Accept')
	{
		StaffSlot = XComGameState_StaffSlot(`XCOMHISTORY.GetGameStateForObjectID(StaffSlotRef.ObjectID));

		if (StaffSlot != none)
		{
			UnitInfo.UnitRef = CallbackData.ObjectRef;
			StaffSlot.FillSlot(UnitInfo); // The Training project is started when the staff slot is filled
			
			`XSTRATEGYSOUNDMGR.PlaySoundEvent("StrategyUI_Staff_Assign");
		}
		
		UpdateData();
	}
}

//==============================================================================

defaultproperties
{
	width = 370;
	height = 65;
}
