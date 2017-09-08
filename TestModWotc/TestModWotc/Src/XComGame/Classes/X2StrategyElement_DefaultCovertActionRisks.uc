//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DefaultCovertActionRisks.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2StrategyElement_DefaultCovertActionRisks extends X2StrategyElement;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> CovertActions;

	CovertActions.AddItem(CreateSoldierWoundedRiskTemplate());
	CovertActions.AddItem(CreateSoldierCapturedRiskTemplate());
	CovertActions.AddItem(CreateAmbushRiskTemplate());

	return CovertActions;
}

//---------------------------------------------------------------------------------------
// SOLDIER WOUNDED
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateSoldierWoundedRiskTemplate()
{
	local X2CovertActionRiskTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionRiskTemplate', Template, 'CovertActionRisk_SoldierWounded');
	Template.FindTargetFn = ChooseRandomSoldierWithExclusions;
	Template.ApplyRiskFn = ApplySoldierWounded;

	return Template;
}

static function ApplySoldierWounded(XComGameState NewGameState, XComGameState_CovertAction ActionState, optional StateObjectReference TargetRef)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit UnitState;
	local XComGameState_HeadquartersProjectHealSoldier HealProjectState;
	local int MinHP, MaxHP, NewHP;

	if (TargetRef.ObjectID != 0)
	{
		UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', TargetRef.ObjectID));
		if (UnitState != none)
		{			
			XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
			XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));

			// Set soldier HP to be half of their full HP
			MinHP = Round(UnitState.GetMaxStat(eStat_HP) / 2);
			MaxHP = max(MinHP, UnitState.GetMaxStat(eStat_HP) - 2);
			NewHP = MinHP + `SYNC_RAND_STATIC(MaxHP - MinHP + 1);
			UnitState.SetCurrentStat(eStat_HP, NewHP);
			UnitState.SetStatus(eStatus_Healing);
			
			// Start healing project
			HealProjectState = XComGameState_HeadquartersProjectHealSoldier(NewGameState.CreateNewStateObject(class'XComGameState_HeadquartersProjectHealSoldier'));
			HealProjectState.SetProjectFocus(UnitState.GetReference(), NewGameState);
			XComHQ.Projects.AddItem(HealProjectState.GetReference());
		}
	}
}

//---------------------------------------------------------------------------------------
// SOLDIER CAPTURED
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateSoldierCapturedRiskTemplate()
{
	local X2CovertActionRiskTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionRiskTemplate', Template, 'CovertActionRisk_SoldierCaptured');
	Template.IsRiskAvailableFn = IsRivalChosenAlive;
	Template.FindTargetFn = ChooseRandomSoldierWithExclusions;
	Template.ApplyRiskFn = ApplySoldierCaptured;
	Template.RiskPopupFn = SoldierCapturedPopup;

	return Template;
}

static function ApplySoldierCaptured(XComGameState NewGameState, XComGameState_CovertAction ActionState, optional StateObjectReference TargetRef)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_AdventChosen ChosenState;
	local XComGameState_Unit UnitState;
	
	if (TargetRef.ObjectID != 0)
	{
		UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', TargetRef.ObjectID));
		if (UnitState != none)
		{
			// Add soldier to the Chosen's captured list
			ChosenState = XComGameState_AdventChosen(NewGameState.ModifyStateObject(class'XComGameState_AdventChosen', ActionState.GetFaction().RivalChosen.ObjectID));
			ChosenState.CaptureSoldier(NewGameState, UnitState.GetReference());

			`XEVENTMGR.TriggerEvent( 'ChosenCapture', UnitState, ChosenState, NewGameState );
			
			// Remove captured soldier from XComHQ crew
			XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
			XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
			XComHQ.RemoveFromCrew(UnitState.GetReference());			
		}
	}
}

static function SoldierCapturedPopup(XComGameState_CovertAction ActionState, StateObjectReference TargetRef)
{
	`HQPRES.UISoldierCaptured(ActionState.GetFaction().GetRivalChosen(), TargetRef);
}

//---------------------------------------------------------------------------------------
// AMBUSH
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateAmbushRiskTemplate()
{
	local X2CovertActionRiskTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionRiskTemplate', Template, 'CovertActionRisk_Ambush');
	Template.IsRiskAvailableFn = IsRivalChosenAlive;
	Template.ApplyRiskFn = CreateAmbushMission;
	Template.bBlockOtherRisks = true;

	return Template;
}

static function CreateAmbushMission(XComGameState NewGameState, XComGameState_CovertAction ActionState, optional StateObjectReference TargetRef)
{
	local XComGameState_HeadquartersResistance ResHQ;
	local XComGameState_MissionSiteChosenAmbush MissionState;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_Reward RewardState;
	local X2StrategyElementTemplateManager StratMgr;
	local X2RewardTemplate RewardTemplate;
	local X2MissionSourceTemplate MissionSource;
	local array<XComGameState_Reward> MissionRewards;

	ResHQ = XComGameState_HeadquartersResistance(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));
	if (ResHQ.CanCovertActionsBeAmbushed()) // If a Covert Action was supposed to be ambushed, but now the Order is active, don't spawn the mission
	{
		StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
		ActionState.bAmbushed = true; // Flag the Action as being ambushed so it cleans up properly and doesn't give rewards
		ActionState.bNeedsAmbushPopup = true; // Set up for the Ambush popup
		RegionState = ActionState.GetWorldRegion();

		MissionRewards.Length = 0;
		RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_None'));
		RewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
		MissionRewards.AddItem(RewardState);

		MissionSource = X2MissionSourceTemplate(StratMgr.FindStrategyElementTemplate('MissionSource_ChosenAmbush'));

		MissionState = XComGameState_MissionSiteChosenAmbush(NewGameState.CreateNewStateObject(class'XComGameState_MissionSiteChosenAmbush'));
		MissionState.CovertActionRef = ActionState.GetReference();
		MissionState.BuildMission(MissionSource, RegionState.GetRandom2DLocationInRegion(), RegionState.GetReference(), MissionRewards, true);

		MissionState.ResistanceFaction = ActionState.Faction;
	}
}

//---------------------------------------------------------------------------------------
// GENERIC DELEGATES
//---------------------------------------------------------------------------------------

static function StateObjectReference ChooseRandomSoldier(XComGameState_CovertAction ActionState, out array<StateObjectReference> ExclusionList)
{
	local XComGameState_StaffSlot SlotState;
	local array<StateObjectReference> EligibleSoldiers;
	local int idx;

	for (idx = 0; idx < ActionState.StaffSlots.Length; idx++)
	{
		SlotState = ActionState.GetStaffSlot(idx);
		if (SlotState.IsSlotFilled() && SlotState.IsSoldierSlot())
		{
			EligibleSoldiers.AddItem(SlotState.GetAssignedStaffRef());
		}
	}

	return EligibleSoldiers[`SYNC_RAND_STATIC(EligibleSoldiers.Length)];
}

static function StateObjectReference ChooseRandomSoldierWithExclusions(XComGameState_CovertAction ActionState, out array<StateObjectReference> ExclusionList)
{
	local XComGameState_StaffSlot SlotState;
	local array<StateObjectReference> EligibleSoldiers;
	local StateObjectReference EmptyRef, RandomSoldierRef;
	local int idx, RandIndex;

	for (idx = 0; idx < ActionState.StaffSlots.Length; idx++)
	{
		SlotState = ActionState.GetStaffSlot(idx);
		if (SlotState.IsSlotFilled() && SlotState.IsSoldierSlot())
		{
			EligibleSoldiers.AddItem(SlotState.GetAssignedStaffRef());
		}
	}

	while (EligibleSoldiers.Length > 0)
	{
		RandIndex = `SYNC_RAND_STATIC(EligibleSoldiers.Length);
		RandomSoldierRef = EligibleSoldiers[RandIndex];
		if (ExclusionList.Find('ObjectID', RandomSoldierRef.ObjectID) == INDEX_NONE)
		{
			ExclusionList.AddItem(RandomSoldierRef);
			return RandomSoldierRef;
		}
		else
		{
			EligibleSoldiers.Remove(RandIndex, 1);
		}
	}
	
	return EmptyRef;
}

static function bool IsRivalChosenAlive(XComGameState_ResistanceFaction FactionState, optional XComGameState NewGameState)
{
	local XComGameState_AdventChosen ChosenState;

	// Try to get the Chosen from the NewGameState, if not grab from the history
	if (NewGameState != none)
	{
		ChosenState = XComGameState_AdventChosen(NewGameState.GetGameStateForObjectID(FactionState.RivalChosen.ObjectID));
	}

	if (ChosenState == none)
	{
		ChosenState = FactionState.GetRivalChosen();
	}

	if (ChosenState != none && !ChosenState.bDefeated)
	{
		return true;
	}

	return false;
}