//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_HeadquartersProjectBondSoldiers.uc
//  AUTHOR:  Mark Nauta  --  07/29/2016
//  PURPOSE: This object represents the instance data for an XComHQ Bond Soldiers project
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_HeadquartersProjectBondSoldiers extends XComGameState_HeadquartersProject;

var localized string BondLevelSubtitle;

//---------------------------------------------------------------------------------------
function SetProjectFocus(StateObjectReference FocusRef, optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	local XComGameStateHistory History;
	local XComGameState_GameTime TimeState;
	local XComGameState_Unit UnitState, LinkedUnitState;

	History = `XCOMHISTORY;
	ProjectFocus = FocusRef; // Unit
	AuxilaryReference = AuxRef; // Linked Unit

	ProjectPointsRemaining = CalculatePointsToTrain();
	InitialProjectPoints = ProjectPointsRemaining;

	UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ProjectFocus.ObjectID));
	UnitState.SetStatus(eStatus_Training);
	LinkedUnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AuxilaryReference.ObjectID));
	LinkedUnitState.SetStatus(eStatus_Training);

	UpdateWorkPerHour(NewGameState);
	TimeState = XComGameState_GameTime(History.GetSingleGameStateObjectForClass(class'XComGameState_GameTime'));
	StartDateTime = TimeState.CurrentTime;

	if(`STRATEGYRULES != none)
	{
		if(class'X2StrategyGameRulesetDataStructures'.static.LessThan(TimeState.CurrentTime, `STRATEGYRULES.GameTime))
		{
			StartDateTime = `STRATEGYRULES.GameTime;
		}
	}

	if(MakingProgress())
	{
		SetProjectedCompletionDateTime(StartDateTime);
	}
	else
	{
		// Set completion time to unreachable future
		CompletionDateTime.m_iYear = 9999;
	}
}

//---------------------------------------------------------------------------------------
function int CalculatePointsToTrain()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit UnitState;
	local SoldierBond Bond;
	local int BondTimeModifier;
	
	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(ProjectFocus.ObjectID));

	if (UnitState.GetBondData(AuxilaryReference, Bond))
	{
		BondTimeModifier = class'X2StrategyGameRulesetDataStructures'.default.BondProjectPoints[Bond.BondLevel + 1];
		return XComHQ.GetBondSoldiersDays() * 24 * BondTimeModifier;
	}

	return 168;
}

//---------------------------------------------------------------------------------------
function int CalculateWorkPerHour(optional XComGameState StartState = none, optional bool bAssumeActive = false)
{
	return 1;
}

//---------------------------------------------------------------------------------------
// Adjust the bond level of the soldiers, unstaff them, and remove the project
function OnProjectCompleted()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit UnitState, PairUnitState;
	local XComGameState_StaffSlot SlotState;
	local SoldierBond Bond;
	local int NewBondLevel;
	local XGParamTag ParamTag;
	local string BondIconPath;

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("On Soldier Bond Project Completed");
	UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ProjectFocus.ObjectID));
	PairUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', AuxilaryReference.ObjectID));

	// Start making completion notification
	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));

	// Set Unit Status
	UnitState.SetStatus(eStatus_Active);
	PairUnitState.SetStatus(eStatus_Active);

	// Set Bond Level
	if(UnitState.GetBondData(PairUnitState.GetReference(), Bond))
	{
		NewBondLevel = (Bond.BondLevel + 1);
		ParamTag.IntValue0 = NewBondLevel;
		class'X2StrategyGameRulesetDataStructures'.static.SetBondLevel(UnitState, PairUnitState, NewBondLevel);
	}

	ParamTag.IntValue0 = NewBondLevel;

	// Unstaff them
	SlotState = UnitState.GetStaffSlot();
	SlotState = XComGameState_StaffSlot(NewGameState.ModifyStateObject(class'XComGameState_StaffSlot', SlotState.ObjectID));
	SlotState.EmptySlot(NewGameState);

	// Remove the project
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	XComHQ.Projects.RemoveItem(self.GetReference());
	NewGameState.RemoveStateObject(self.ObjectID);

	`XEVENTMGR.TriggerEvent('BondLevelUpComplete', UnitState, PairUnitState, NewGameState);

	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

	switch(NewBondLevel)
	{
	case 1:
		BondIconPath = "img:///UILibrary_XPACK_Common.SoldierBond_icon_1";
		break;
	case 2:
		BondIconPath = "img:///UILibrary_XPACK_Common.SoldierBond_icon_2";
		break;
	case 3:
		BondIconPath = "img:///UILibrary_XPACK_Common.SoldierBond_icon_3";
		break;
	default:
		BondIconPath = "";
	}

	`HQPRES.NotifyBanner(ProjectCompleteNotification, BondIconPath, UnitState.GetName(eNameType_RankFull) $ "," @ PairUnitState.GetName(eNameType_RankFull),
						 `XEXPAND.ExpandString(BondLevelSubtitle), eUIState_Good);
}

//---------------------------------------------------------------------------------------
DefaultProperties
{
}
