//---------------------------------------------------------------------------------------
//  FILE:    X2StaffSlotTemplate.uc
//  AUTHOR:  Mark Nauta
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StaffSlotTemplate extends X2StrategyElementTemplate;

// Data
var bool					bHideStaffSlot; // Do not show this staff slot on the facility screen
var bool					bRequireConfirmToEmpty; // Flag to require confirmation from the player before emptying this slot
var bool					bScientistSlot;
var bool					bEngineerSlot;
var bool					bSoldierSlot;
var bool					CreatesGhosts; // Does this staff slot create ghost units
var bool					bPreventFilledPopup; // Do not show the "unit assigned" popup for this staff slot
var class<UIStaffSlot>	UIStaffSlotClass; // Name of UI class for the staff slot
var class<XComGameState_HeadquartersProject> AssociatedProjectClass; // Headquarters Project class associated with this staff slot, used for displaying time previews
var array<name>			ExcludeClasses; // List of soldier classes which are not allowed in this staff slot
var string				MatineeSlotName; // used with avenger crew population matinee's to pick an appropriate matinee seqvar to assign staff too

// Text
var localized string	EmptyText;
var localized string	BonusText;
var localized string	BonusDefaultText;			// Used by staff slots which don't rely on a numeric bonus to have a default yet potentially dynamic string
var localized string	BonusEmptyText;
var localized string	FilledText;
var localized string	GhostName;					// If this staff slot can provide ghost units, this is what they will be called
var localized string	LockedText;

// Functions
var delegate<Fill> FillFn; // Call to fill the slot
var delegate<Empty> EmptyFn; // Call to empty the slot
var delegate<EmptyStopProject> EmptyStopProjectFn; // Call to empty the slot through stopping the associated headquarters project
var delegate<CanStaffBeMovedDelegate> CanStaffBeMovedFn;
var delegate<ShouldDisplayToDoWarning> ShouldDisplayToDoWarningFn;
var delegate<GetContributionFromSkill> GetContributionFromSkillFn; // Call to get the unit's numeric contribution for the specific staff slot
var delegate<GetAvengerBonusAmount> GetAvengerBonusAmountFn; // Call to get the value of the bonus this unit's staffing provides to the avenger - unique and different for each staff slot
var delegate<GetNameDisplayString> GetNameDisplayStringFn; // Call to get display name as text
var delegate<GetSkillDisplayString> GetSkillDisplayStringFn; // Call to get display skill as text
var delegate<GetBonusDisplayString> GetBonusDisplayStringFn; // Call to get staffing bonus as text
var delegate<GetLocationDisplayString> GetLocationDisplayStringFn; // Call to get the location of the staff slot
var delegate<GetValidUnitsForSlot> GetValidUnitsForSlotFn; // Call to get all of the units that can be staffed in this slot
var delegate<IsUnitValidForSlot> IsUnitValidForSlotFn; // Is the unit allowed to be placed in this staff slot
var delegate<IsStaffSlotBusy> IsStaffSlotBusyFn; // Is the unit in this slot busy contributing to a project or task. Used for reassigning staffers.

delegate Fill(XComGameState NewGameState, StateObjectReference SlotRef, StaffUnitInfo UnitInfo, optional bool bTemporary = false);
delegate Empty(XComGameState NewGameState, StateObjectReference SlotRef);
delegate EmptyStopProject(StateObjectReference SlotRef);
delegate bool CanStaffBeMovedDelegate(StateObjectReference SlotRef);
delegate bool ShouldDisplayToDoWarning(StateObjectReference SlotRef);
delegate int GetContributionFromSkill(XComGameState_Unit UnitState);
delegate int GetAvengerBonusAmount(XComGameState_Unit UnitState, optional bool bPreview);
delegate string GetNameDisplayString(XComGameState_StaffSlot SlotState);
delegate string GetSkillDisplayString(XComGameState_StaffSlot SlotState);
delegate string GetBonusDisplayString(XComGameState_StaffSlot SlotState, optional bool bPreview);
delegate string GetLocationDisplayString(XComGameState_StaffSlot SlotState);
delegate array<StaffUnitInfo> GetValidUnitsForSlot(XComGameState_StaffSlot SlotState);
delegate bool IsUnitValidForSlot(XComGameState_StaffSlot SlotState, StaffUnitInfo UnitInfo);
delegate bool IsStaffSlotBusy(XComGameState_StaffSlot SlotState);

//---------------------------------------------------------------------------------------
function XComGameState_StaffSlot CreateInstanceFromTemplate(XComGameState NewGameState)
{
	local XComGameState_StaffSlot SlotState;

	SlotState = XComGameState_StaffSlot(NewGameState.CreateNewStateObject(class'XComGameState_StaffSlot', self));

	return SlotState;
}

//---------------------------------------------------------------------------------------
DefaultProperties
{
	UIStaffSlotClass = class'UIFacility_StaffSlot';
}