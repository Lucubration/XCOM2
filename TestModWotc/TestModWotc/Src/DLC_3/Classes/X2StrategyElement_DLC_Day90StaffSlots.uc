//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DLC_Day90StaffSlots.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_DLC_Day90StaffSlots extends X2StrategyElement;

//---------------------------------------------------------------------------------------
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> StaffSlots;

	StaffSlots.AddItem(CreateSparkStaffSlotTemplate());

	return StaffSlots;
}

//#############################################################################################
//----------------   PROVING GROUND   -------------------------------------------------------------
//#############################################################################################

static function X2DataTemplate CreateSparkStaffSlotTemplate()
{
	local X2StaffSlotTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StaffSlotTemplate', Template, 'SparkStaffSlot');
	Template = class'X2StrategyElement_DefaultStaffSlots'.static.CreateStaffSlotTemplate('SparkStaffSlot');
	Template.bSoldierSlot = true;
	Template.AssociatedProjectClass = class'XComGameState_HeadquartersProjectHealSpark';
	Template.FillFn = FillSparkSlot;
	Template.EmptyFn = EmptySparkSlot;
	Template.ShouldDisplayToDoWarningFn = ShouldDisplaySparkToDoWarning;
	Template.GetSkillDisplayStringFn = GetSparkSkillDisplayString;
	Template.GetBonusDisplayStringFn = GetSparkBonusDisplayString;
	Template.IsUnitValidForSlotFn = IsUnitValidForSparkSlot;
	Template.MatineeSlotName = "Spark";

	return Template;
}

static function FillSparkSlot(XComGameState NewGameState, StateObjectReference SlotRef, StaffUnitInfo UnitInfo, optional bool bTemporary = false)
{
	local XComGameState_Unit NewUnitState;
	local XComGameState_StaffSlot NewSlotState;
	local XComGameState_HeadquartersProjectHealSpark HealSparkProject;

	class'X2StrategyElement_DefaultStaffSlots'.static.FillSlot(NewGameState, SlotRef, UnitInfo, NewSlotState, NewUnitState);
	
	// Look for a heal project in the NewGameState
	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersProjectHealSpark', HealSparkProject)
	{
		if (HealSparkProject.ProjectFocus.ObjectID == UnitInfo.UnitRef.ObjectID)
		{
			break;
		}
	}

	if (HealSparkProject == none)
	{
		// If a heal project was not found in the NewGameState, get it from the History
		HealSparkProject = class'X2Helpers_DLC_Day90'.static.GetHealSparkProject(UnitInfo.UnitRef);
		HealSparkProject = XComGameState_HeadquartersProjectHealSpark(NewGameState.ModifyStateObject(HealSparkProject.Class, HealSparkProject.ObjectID));
	}	

	HealSparkProject.bForcePaused = false; // Now that we definitely have a heal project, make sure it is active
}

static function EmptySparkSlot(XComGameState NewGameState, StateObjectReference SlotRef)
{
	local XComGameState_StaffSlot NewSlotState;
	local XComGameState_Unit NewUnitState;
	local XComGameState_HeadquartersProjectHealSpark HealSparkProject;

	class'X2StrategyElement_DefaultStaffSlots'.static.EmptySlot(NewGameState, SlotRef, NewSlotState, NewUnitState);
	
	HealSparkProject = class'X2Helpers_DLC_Day90'.static.GetHealSparkProject(NewUnitState.GetReference());
	if (HealSparkProject != none)
	{
		HealSparkProject = XComGameState_HeadquartersProjectHealSpark(NewGameState.ModifyStateObject(HealSparkProject.Class, HealSparkProject.ObjectID));
		HealSparkProject.bForcePaused = true;
	}
}

static function bool ShouldDisplaySparkToDoWarning(StateObjectReference SlotRef)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_StaffSlot SlotState;
	local StaffUnitInfo UnitInfo;
	local int i;

	History = `XCOMHISTORY;
	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	SlotState = XComGameState_StaffSlot(History.GetGameStateForObjectID(SlotRef.ObjectID));

	for (i = 0; i < XComHQ.Crew.Length; i++)
	{
		UnitInfo.UnitRef = XComHQ.Crew[i];

		if (IsUnitValidForSparkSlot(SlotState, UnitInfo))
		{
			return true;
		}
	}

	return false;
}

static function bool IsUnitValidForSparkSlot(XComGameState_StaffSlot SlotState, StaffUnitInfo UnitInfo)
{
	local XComGameState_Unit Unit;

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitInfo.UnitRef.ObjectID));

	// Ensure that the unit is not already in this slot, and is an injured Spark soldier
	if (Unit.IsAlive()
		&& Unit.GetMyTemplate().bStaffingAllowed
		&& Unit.GetReference().ObjectID != SlotState.GetAssignedStaffRef().ObjectID
		&& Unit.IsSoldier()
		&& Unit.IsInjured()
		&& Unit.GetMyTemplateName() == 'SparkSoldier') // Only injured SPARKs can be staffed here to heal
	{
		return true;
	}

	return false;
}

static function string GetSparkBonusDisplayString(XComGameState_StaffSlot SlotState, optional bool bPreview)
{
	local string Contribution;

	if (SlotState.IsSlotFilled())
	{
		Contribution = string(class'X2StrategyElement_DefaultStaffSlots'.static.GetAvengerBonusDefault(SlotState.GetAssignedStaff(), bPreview));
	}

	return class'X2StrategyElement_DefaultStaffSlots'.static.GetBonusDisplayString(SlotState, "%AVENGERBONUS", Contribution);
}


static function string GetSparkSkillDisplayString(XComGameState_StaffSlot SlotState)
{
	return "";
}