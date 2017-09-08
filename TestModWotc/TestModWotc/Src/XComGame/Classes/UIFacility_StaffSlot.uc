//---------------------------------------------------------------------------------------
//  FILE:    UIFacility_StaffSlot.uc
//  AUTHOR:  Sam Batista
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class UIFacility_StaffSlot extends UIStaffSlot;

var localized string m_strNoSoldiersTooltip;
var localized string m_strSoldiersAvailableTooltip;
var localized string m_strNoEngineersTooltip;
var localized string m_strEngineersAvailableTooltip;
var localized string m_strNoScientistsTooltip;
var localized string m_strScientistsAvailableTooltip;
var localized string m_strSlotLockedTooltip;

//-----------------------------------------------------------------------------

simulated function UIStaffSlot InitStaffSlot(UIStaffContainer OwningContainer, StateObjectReference LocationRef, int SlotIndex, delegate<OnStaffUpdated> onStaffUpdatedDel)
{
	local XComGameState_FacilityXCom Facility;
	local int TooltipID;

	Facility = XComGameState_FacilityXCom(`XCOMHISTORY.GetGameStateForObjectID(LocationRef.ObjectID));
	StaffSlotRef = Facility.GetStaffSlot(SlotIndex).GetReference();
	
	super.InitStaffSlot(OwningContainer, LocationRef, SlotIndex, onStaffUpdatedDel);
	
	TooltipID = Movie.Pres.m_kTooltipMgr.AddNewTooltipTextBox(m_strNoSoldiersTooltip, 0, 0, string(MCPath), , , , true);
	Movie.Pres.m_kTooltipMgr.TextTooltip.SetMouseDelegates(TooltipID, RefreshTooltip);

	return self;
}

simulated function string GetNewLocationString(XComGameState_StaffSlot StaffSlotState)
{
	return StaffSlotState.GetFacility().GetMyTemplate().DisplayName;
}

simulated function OnLoseFocus()
{
	super.OnLoseFocus();

	if (`ISCONTROLLERACTIVE)
	{
		if (StaffContainer.m_kPersonnelDropDown != none)
			StaffContainer.m_kPersonnelDropDown.Hide();
	}
}
simulated function RefreshTooltip(UITooltip Tooltip)
{
	local XComGameState_StaffSlot StaffSlot;

	StaffSlot = XComGameState_StaffSlot(`XCOMHISTORY.GetGameStateForObjectID(StaffSlotRef.ObjectID));
	
	if (StaffSlot.IsLocked())
	{
		UITextTooltip(Tooltip).SetText(m_strSlotLockedTooltip);
	}
	else if (StaffSlot.IsSoldierSlot())
	{
		if (StaffSlot.IsUnitAvailableForThisSlot())
			UITextTooltip(Tooltip).SetText(m_strSoldiersAvailableTooltip);
		else
			UITextTooltip(Tooltip).SetText(m_strNoSoldiersTooltip);
	}
	else if (StaffSlot.IsEngineerSlot())
	{
		if (StaffSlot.IsUnitAvailableForThisSlot())
			UITextTooltip(Tooltip).SetText(m_strEngineersAvailableTooltip);
		else
			UITextTooltip(Tooltip).SetText(m_strNoEngineersTooltip);
	}
	else if (StaffSlot.IsScientistSlot())
	{
		if (StaffSlot.IsUnitAvailableForThisSlot())
			UITextTooltip(Tooltip).SetText(m_strScientistsAvailableTooltip);
		else
			UITextTooltip(Tooltip).SetText(m_strNoScientistsTooltip);
	}
}

//==============================================================================

defaultproperties
{
}
