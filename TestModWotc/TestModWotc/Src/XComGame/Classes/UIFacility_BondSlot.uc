//---------------------------------------------------------------------------------------
//  FILE:    UIFacility_BondSlot.uc
//  AUTHOR:  Mark Nauta  --  08/01/2016
//  PURPOSE: UI handling for soldier bond staff slots
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class UIFacility_BondSlot extends UIFacility_StaffSlot
	dependson(UIPersonnel);

var localized string m_strBondSoldiersDialogTitle;
var localized string m_strBondSoldiersDialogText;
var localized string m_strStopBondSoldiersDialogTitle;
var localized string m_strStopBondSoldiersDialogText;
var localized string m_strBondsAvailableTooltip;
var localized string m_strCurrentlyBondingTooltip;
var localized string m_strChooseBondmateTooltip;

//-----------------------------------------------------------------------------
simulated function UIStaffSlot InitStaffSlot(UIStaffContainer OwningContainer, StateObjectReference LocationRef, int SlotIndex, delegate<OnStaffUpdated> onStaffUpdatedDel)
{
	super.InitStaffSlot(OwningContainer, LocationRef, SlotIndex, onStaffUpdatedDel);

	return self;
}

//-----------------------------------------------------------------------------
simulated function ShowDropDown()
{
	local XComGameState_StaffSlot StaffSlot;
	local XGParamTag LocTag;

	StaffSlot = XComGameState_StaffSlot(`XCOMHISTORY.GetGameStateForObjectID(StaffSlotRef.ObjectID));

	if(StaffSlot.IsSlotEmpty())
	{
		StaffContainer.ShowDropDown(self);
	}
	else // Ask the user to confirm that they want to empty the slot and stop training
	{
		LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
		LocTag.StrValue0 = StaffSlot.GetAssignedStaff().GetName(eNameType_RankFull);
		LocTag.StrValue1 = StaffSlot.GetPairedStaff().GetName(eNameType_RankFull);
		
		ConfirmEmptyProjectSlotPopup(m_strStopBondSoldiersDialogTitle, `XEXPAND.ExpandString(m_strStopBondSoldiersDialogText));
	}
}

simulated function OnPersonnelSelected(StaffUnitInfo UnitInfo)
{
	local XComGameStateHistory History;
	local XGParamTag LocTag;
	local TDialogueBoxData DialogData;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit Unit, PairUnit;
	local SoldierBond Bond;
	local int DaysToTrain, BondTimeModifier;
	local UICallbackData_StateObjectReference CallbackData;
		
	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	Unit = XComGameState_Unit(History.GetGameStateForObjectID(UnitInfo.UnitRef.ObjectID));
	PairUnit = XComGameState_Unit(History.GetGameStateForObjectID(UnitInfo.PairUnitRef.ObjectID));
		
	if (Unit.GetBondData(PairUnit.GetReference(), Bond))
	{
		BondTimeModifier = class'X2StrategyGameRulesetDataStructures'.default.BondProjectPoints[Bond.BondLevel + 1];
		DaysToTrain = XComHQ.GetBondSoldiersDays() * BondTimeModifier;
	}

	LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	LocTag.StrValue0 = Unit.GetName(eNameType_RankFull);
	LocTag.StrValue1 = PairUnit.GetName(eNameType_RankFull);
	LocTag.IntValue0 = DaysToTrain;

	CallbackData = new class'UICallbackData_StateObjectReference';
	CallbackData.ObjectRef = Unit.GetReference();
	CallbackData.ObjectRef2 = PairUnit.GetReference();
	DialogData.xUserData = CallbackData;
	DialogData.fnCallbackEx = BondSoldiersDialogCallback;

	DialogData.eType = eDialog_Alert;
	DialogData.strTitle = m_strBondSoldiersDialogTitle;
	DialogData.strText = `XEXPAND.ExpandString(m_strBondSoldiersDialogText);
	DialogData.strAccept = class'UIUtilities_Text'.default.m_strGenericYes;
	DialogData.strCancel = class'UIUtilities_Text'.default.m_strGenericNo;

	Movie.Pres.UIRaiseDialog(DialogData);
}

simulated function BondSoldiersDialogCallback(Name eAction, UICallbackData xUserData)
{
	local XComGameStateHistory History;
	local UICallbackData_StateObjectReference CallbackData;
	local XComGameState_Unit UnitStateA, UnitStateB;
	local XComGameState_StaffSlot StaffSlotState;

	History = `XCOMHISTORY;
	CallbackData = UICallbackData_StateObjectReference(xUserData);
		
	StaffSlotState = XComGameState_StaffSlot(History.GetGameStateForObjectID(StaffSlotRef.ObjectID)); // the staff slot being filled
	UnitStateA = XComGameState_Unit(History.GetGameStateForObjectID(CallbackData.ObjectRef.ObjectID));
	UnitStateB = XComGameState_Unit(History.GetGameStateForObjectID(CallbackData.ObjectRef2.ObjectID));;
	
	if (eAction == 'eUIAction_Accept')
	{
		`HQPRES.UISoldierBondConfirm(UnitStateA, UnitStateB, StaffSlotState);
	}
}

//-----------------------------------------------------------------------------
simulated function RefreshTooltip(UITooltip Tooltip)
{
	local XComGameState_StaffSlot StaffSlot;

	StaffSlot = XComGameState_StaffSlot(`XCOMHISTORY.GetGameStateForObjectID(StaffSlotRef.ObjectID));

	if(StaffSlot.IsUnitAvailableForThisSlot())
	{
		if(StaffSlot.IsSlotEmpty())
		{
			UITextTooltip(Tooltip).SetText(m_strBondsAvailableTooltip);
		}
		else
		{
			UITextTooltip(Tooltip).SetText(m_strCurrentlyBondingTooltip);
		}
	}
	else
	{
		UITextTooltip(Tooltip).SetText(m_strNoSoldiersTooltip);
	}	
}


DefaultProperties
{
}