//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_XpackRewards.uc
//  AUTHOR:  Mark Nauta  --  07/20/2016
//  PURPOSE: Create Xpack reward templates
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_XpackRewards extends X2StrategyElement_DefaultRewards
	dependson(X2RewardTemplate)
	config(GameData);

var config array<int>                   AbilityPointsBaseReward;
var config array<int>                   AbilityPointsInterval;
var config array<int>                   AbilityPointsRewardIncrease;
var config int							AbilityPointsRangePercent;

var() config array<name>				FactionSoldierCharacters; // Characters which can be selected randomly as faction soldier rewards

var config array<int>					FactionInfluenceMinReward;
var config array<int>					FactionInfluenceMaxReward;

var config array<int>					SoldierAbilityPointsMinReward;
var config array<int>					SoldierAbilityPointsMaxReward;

var config int							ReleaseSoldierRaiseXCOMAwarenessChance;

var config array<int>					RemoveDoomReward;

var config array<int>					RescueCivilianIncomeIncreaseReward;

var localized string					RewardIncreaseComInt;
var localized string					RewardFormSoldierBond;
var localized string					RewardCancelChosenActivity;
var localized string					RewardFactionInfluence;
var localized string					RewardPromotion;
var localized string					RewardDoomRemoved;
var localized string					RewardDoomRemovedLabel;
var localized string					RewardDoomRemovedSabotage;
var localized string					RewardStatBoost;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Rewards;

	// Covert Actions
	Rewards.AddItem(CreateAbilityPointsRewardTemplate());
	Rewards.AddItem(CreateIncreaseComIntRewardTemplate());
	Rewards.AddItem(CreateFormSoldierBondRewardTemplate());
	Rewards.AddItem(CreateCancelChosenActivityRewardTemplate());
	Rewards.AddItem(CreateRemoveDoomRewardTemplate());

	// Personnel
	Rewards.AddItem(CreateFactionSoldierRewardTemplate());
	Rewards.AddItem(CreateExtraFactionSoldierRewardTemplate());
	Rewards.AddItem(CreateChosenCapturedSoldierRewardTemplate());

	// Items
	Rewards.AddItem(CreateChosenInformationTemplate());
	Rewards.AddItem(CreateSuperiorWeaponUpgradeTemplate());
	Rewards.AddItem(CreateSuperiorPCSTemplate());
	Rewards.AddItem(CreateAlienLootTemplate());
	
	//Missions
	Rewards.AddItem(CreateRescueSoldierMissionRewardTemplate());
	Rewards.AddItem(CreateRevealChosenStrongholdRewardTemplate());
	Rewards.AddItem(CreateUnlockChosenStrongholdRewardTemplate());

	// Factions
	Rewards.AddItem(CreateFindFactionRewardTemplate());
	Rewards.AddItem(CreateFindFarthestFactionRewardTemplate());
	Rewards.AddItem(CreateFactionInfluenceRewardTemplate());
	Rewards.AddItem(CreateResistanceCardRewardTemplate());

	// Techs
	Rewards.AddItem(CreateBreakthroughTechRewardTemplate());

	// Individual Rewards
	Rewards.AddItem(CreateRankUpRewardTemplate());
	Rewards.AddItem(CreateStatBoostHPRewardTemplate());
	Rewards.AddItem(CreateStatBoostAimRewardTemplate());
	Rewards.AddItem(CreateStatBoostMobilityRewardTemplate());
	Rewards.AddItem(CreateStatBoostDodgeRewardTemplate());
	Rewards.AddItem(CreateStatBoostWillRewardTemplate());
	Rewards.AddItem(CreateStatBoostHackingRewardTemplate());
	Rewards.AddItem(CreateSoldierAbilityPointsRewardTemplate());

	// Covert Actions
	Rewards.AddItem(CreateDecreaseRiskRewardTemplate());

	return Rewards;
}

// #######################################################################################
// --------------------- RESOURCE REWARDS ------------------------------------------------
// #######################################################################################
static function X2DataTemplate CreateAbilityPointsRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_AbilityPoints');
	Template.rewardObjectTemplateName = 'AbilityPoint';
	Template.RewardImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Intel";

	Template.GenerateRewardFn = GenerateAbilityPointsReward;
	Template.SetRewardFn = SetResourceReward;
	Template.GiveRewardFn = GiveResourceReward;
	Template.GetRewardStringFn = GetResourceRewardString;
	Template.GetRewardPreviewStringFn = GetResourceRewardString;
	Template.GetRewardImageFn = GetResourceRewardImage;
	Template.GetRewardIconFn = GetGenericRewardIcon;

	return Template;
}

static function GenerateAbilityPointsReward(XComGameState_Reward RewardState, XComGameState NewGameState, optional float RewardScalar = 1.0, optional StateObjectReference RegionRef)
{
	RewardState.Quantity = GetResourceReward(GetAbilityPointsBaseReward(), GetAbilityPointsRewardIncrease(), GetAbilityPointsInterval(), default.AbilityPointsRangePercent);
	RewardState.Quantity = Round(RewardScalar * float(RewardState.Quantity));
}

static function X2DataTemplate CreateIncreaseComIntRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_IncreaseComInt');
	Template.RewardImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Intel";

	Template.GenerateRewardFn = GenerateIncreaseComIntReward;
	Template.GiveRewardFn = GiveIncreaseComIntReward;
	Template.GetRewardStringFn = GetIncreaseComIntRewardString;
	Template.CleanUpRewardFn = CleanUpRewardWithoutRemoval;

	return Template;
}

static function GenerateIncreaseComIntReward(XComGameState_Reward RewardState, XComGameState NewGameState, optional float RewardScalar = 1.0, optional StateObjectReference ActionRef)
{
	RewardState.RewardObjectReference = ActionRef;
}

static function GiveIncreaseComIntReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameState_CovertAction ActionState;
	local XComGameState_StaffSlot SlotState;
	local XComGameState_Unit UnitState;
	local int idx;
	
	ActionState = XComGameState_CovertAction(`XCOMHISTORY.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	if (ActionState != none)
	{
		for (idx = 0; idx < ActionState.StaffSlots.Length; idx++)
		{
			SlotState = ActionState.GetStaffSlot(idx);
			if (SlotState.IsSoldierSlot() && SlotState.IsSlotFilled())
			{
				UnitState = SlotState.GetAssignedStaff();
				UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));
				UnitState.ImproveCombatIntelligence();
				
				// Save the state of the unit who received the improved Combat Intelligence
				RewardState.RewardObjectReference = UnitState.GetReference();

				`XEVENTMGR.TriggerEvent( 'AbilityPointsChange', UnitState, , NewGameState );

				break;
			}
		}
	}
}

static function string GetIncreaseComIntRewardString(XComGameState_Reward RewardState)
{	
	local XComGameState_Unit UnitState;
	local XGParamTag kTag;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	if (UnitState != none)
	{
		kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
		kTag.StrValue0 = UnitState.GetFullName();
		kTag.StrValue1 = UnitState.GetCombatIntelligenceLabel();

		return `XEXPAND.ExpandString(default.RewardIncreaseComInt);
	}

	return "";
}

static function X2DataTemplate CreateFormSoldierBondRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_FormSoldierBond');
	Template.RewardImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Intel";

	Template.GenerateRewardFn = GenerateFormSoldierBondReward;
	Template.GiveRewardFn = GiveFormSoldierBondReward;
	Template.GetRewardStringFn = GetFormSoldierBondRewardString;
	Template.CleanUpRewardFn = CleanUpRewardWithoutRemoval;

	return Template;
}

static function GenerateFormSoldierBondReward(XComGameState_Reward RewardState, XComGameState NewGameState, optional float RewardScalar = 1.0, optional StateObjectReference ActionRef)
{
	RewardState.RewardObjectReference = ActionRef;
}

static function GiveFormSoldierBondReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameState_CovertAction ActionState;
	local XComGameState_StaffSlot SlotState;
	local XComGameState_Unit UnitState, BondmateA, BondmateB;
	local array<XComGameState_Unit> Bondmates;
	local SoldierBond BondData;
	local int idx, DesiredCohesion;

	ActionState = XComGameState_CovertAction(`XCOMHISTORY.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	if (ActionState != none)
	{
		for (idx = 0; idx < ActionState.StaffSlots.Length; idx++)
		{
			SlotState = ActionState.GetStaffSlot(idx);
			if (SlotState.IsSoldierSlot() && SlotState.IsSlotFilled())
			{
				UnitState = SlotState.GetAssignedStaff();
				UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));
				Bondmates.AddItem(UnitState);
			}
		}

		if (Bondmates.Length >= 2)
		{
			BondmateA = Bondmates[0];
			BondmateB = Bondmates[1];
			
			BondmateA.GetBondData(BondmateB.GetReference(), BondData);
			if (BondmateA != none && BondmateB != none && (BondData.BondLevel + 1) < class'X2StrategyGameRulesetDataStructures'.default.CohesionThresholds.Length)
			{
				DesiredCohesion = class'X2StrategyGameRulesetDataStructures'.default.CohesionThresholds[BondData.BondLevel + 1];
				if (DesiredCohesion > BondData.Cohesion)
				{
					class'X2StrategyGameRulesetDataStructures'.static.ModifySoldierCohesion(BondmateA, BondmateB, (DesiredCohesion - BondData.Cohesion), true);
				}
			}
		}		
	}
}

static function string GetFormSoldierBondRewardString(XComGameState_Reward RewardState)
{
	local XComGameState_CovertAction ActionState;
	local XComGameState_StaffSlot SlotState;
	local array<XComGameState_Unit> Bondmates;
	local XGParamTag kTag;
	local int idx;

	ActionState = XComGameState_CovertAction(`XCOMHISTORY.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	if (ActionState != none)
	{
		for (idx = 0; idx < ActionState.StaffSlots.Length; idx++)
		{
			SlotState = ActionState.GetStaffSlot(idx);
			if (SlotState.IsSoldierSlot() && SlotState.IsSlotFilled())
			{
				Bondmates.AddItem(SlotState.GetAssignedStaff());
			}
		}	
	
		if (Bondmates.Length >= 2)
		{
			kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
			kTag.StrValue0 = Bondmates[0].GetFullName();
			kTag.StrValue1 = Bondmates[1].GetFullName();

			return `XEXPAND.ExpandString(default.RewardFormSoldierBond);
		}
	}

	return "";
}

static function X2DataTemplate CreateCancelChosenActivityRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_CancelChosenActivity');
	Template.RewardImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Intel";

	Template.IsRewardAvailableFn = IsCancelChosenActivityRewardAvailable;
	Template.GenerateRewardFn = GenerateCancelChosenActivityReward;
	Template.GetRewardImageFn = GetCancelChosenActivityRewardImage;
	Template.GetRewardStringFn = GetCancelChosenActivityRewardString;
	Template.GetRewardDetailsStringFn = GetCancelChosenActivityRewardDetailsString;
	Template.CleanUpRewardFn = CleanUpRewardWithoutRemoval;

	return Template;
}

static function bool IsCancelChosenActivityRewardAvailable(optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	local XComGameStateHistory History;
	local XComGameState_ResistanceFaction FactionState;
	local XComGameState_AdventChosen ChosenState;
	
	History = `XCOMHISTORY;
	FactionState = GetFactionState(NewGameState, AuxRef);
	if (FactionState != none)
	{
		if (NewGameState != none)
		{
			ChosenState = XComGameState_AdventChosen(NewGameState.GetGameStateForObjectID(FactionState.RivalChosen.ObjectID));
		}

		if (ChosenState == none)
		{
			ChosenState = XComGameState_AdventChosen(History.GetGameStateForObjectID(FactionState.RivalChosen.ObjectID));
		}

		if (ChosenState.bMetXCom && !ChosenState.bDefeated &&
			ChosenState.CurrentMonthAction.ObjectID != 0 && ChosenState.bActionUsesTimer && !ChosenState.bPerformedMonthlyAction)
		{
			return true;
		}
	}
	else
	{
		`Redscreen("@jweinhoffer CancelChosenActivityReward not available because FactionState was not found");
	}

	return false;
}

static function GenerateCancelChosenActivityReward(XComGameState_Reward RewardState, XComGameState NewGameState, optional float RewardScalar = 1.0, optional StateObjectReference ActionRef)
{
	local XComGameStateHistory History;
	local XComGameState_CovertAction ActionState;
	local XComGameState_AdventChosen ChosenState;
	local StateObjectReference ChosenRef;

	History = `XCOMHISTORY;
	ActionState = XComGameState_CovertAction(NewGameState.GetGameStateForObjectID(ActionRef.ObjectID));
	if (ActionState != none)
	{
		ChosenRef = ActionState.GetFaction().RivalChosen;
		ChosenState = XComGameState_AdventChosen(NewGameState.GetGameStateForObjectID(ChosenRef.ObjectID));
		if (ChosenState == none)
		{
			ChosenState = XComGameState_AdventChosen(History.GetGameStateForObjectID(ChosenRef.ObjectID));
		}

		if (ChosenState != none)
		{
			RewardState.RewardObjectReference = ChosenState.CurrentMonthAction;
		}
	}	
}

static function string GetCancelChosenActivityRewardImage(XComGameState_Reward RewardState)
{
	local XComGameStateHistory History;
	local XComGameState_ChosenAction ActionState;

	History = `XCOMHISTORY;
	ActionState = XComGameState_ChosenAction(History.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	if (ActionState != none)
	{
		return ActionState.GetImagePath();
	}

	return "";
}

static function string GetCancelChosenActivityRewardString(XComGameState_Reward RewardState)
{
	local XComGameStateHistory History;
	local XComGameState_ChosenAction ActionState;
	local XComGameState_AdventChosen ChosenState;
	local XGParamTag kTag;

	History = `XCOMHISTORY;
	ActionState = XComGameState_ChosenAction(History.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	if (ActionState != none)
	{
		ChosenState = XComGameState_AdventChosen(History.GetGameStateForObjectID(ActionState.ChosenRef.ObjectID));

		kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
		kTag.StrValue0 = ChosenState.GetChosenName();

		return `XEXPAND.ExpandString(default.RewardCancelChosenActivity);
	}
	
	return "";
}

static function string GetCancelChosenActivityRewardDetailsString(XComGameState_Reward RewardState)
{
	local XComGameStateHistory History;
	local XComGameState_ChosenAction ActionState;

	History = `XCOMHISTORY;
	ActionState = XComGameState_ChosenAction(History.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	if (ActionState != none)
	{		
		return ActionState.GetDisplayName() $ ":" @ ActionState.GetSummaryText();
	}

	return "";
}

static function X2DataTemplate CreateRemoveDoomRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_RemoveDoom');
	Template.RewardImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Intel";

	Template.IsRewardAvailableFn = IsRemoveDoomRewardAvailable;
	Template.GiveRewardFn = GiveRemoveDoomReward;
	Template.GetRewardStringFn = GetRemoveDoomRewardString;

	return Template;
}

static function bool IsRemoveDoomRewardAvailable(optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	local XComGameState_HeadquartersAlien AlienHQ;

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	if (AlienHQ.bHasSeenFortress && AlienHQ.GetCurrentDoom() >= class'X2StrategyElement_XPackRewards'.static.GetRemoveDoomReward())
	{
		return true;
	}

	return false;
}

static function GiveRemoveDoomReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_MissionSite MissionState, FortressState, MostDoomMissionState;
	local PendingDoom DoomPending;
	local XGParamTag ParamTag;
	local int DoomReward;
	local string DoomString;

	History = `XCOMHISTORY;

	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersAlien', AlienHQ)
	{
		break;
	}

	if (AlienHQ == none)
	{
		AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
		AlienHQ = XComGameState_HeadquartersAlien(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersAlien', AlienHQ.ObjectID));
	}

	DoomReward = GetRemoveDoomReward();
	DoomString = default.RewardDoomRemovedLabel;
	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	FortressState = AlienHQ.GetFortressMission();

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_MissionSite', MissionState)
	{
		if (MostDoomMissionState == none || (MissionState.Available && MissionState.Doom > MostDoomMissionState.Doom))
		{
			MostDoomMissionState = MissionState;
		}
	}

	if (FortressState.Doom > 0 && FortressState.Doom >= MostDoomMissionState.Doom)
	{
		DoomReward = Clamp(DoomReward, 0, FortressState.Doom); // Clamp the amount to remove based on the Doom the Fortress actually has
		RewardState.Quantity = DoomReward;
		
		ParamTag.StrValue0 = string(DoomReward);
		DoomString @= `XEXPAND.ExpandString(class'UIRewardsRecap'.default.m_strAvatarProgressReducedPlural);

		AlienHQ.RemoveDoomFromFortress(NewGameState, DoomReward, DoomString);
	}
	else if (MostDoomMissionState != none && MostDoomMissionState.Doom > 0)
	{
		// If the Fortress does not have any doom, find a Facility mission with the highest doom amount and apply the reward there instead
		DoomReward = Clamp(DoomReward, 0, MostDoomMissionState.Doom); // Clamp the amount to remove based on the Doom the Facility actually has
		RewardState.Quantity = DoomReward;
			
		ParamTag.StrValue0 = string(DoomReward);
		DoomString @= `XEXPAND.ExpandString(class'UIRewardsRecap'.default.m_strAvatarProgressReducedPlural);
			
		MostDoomMissionState= XComGameState_MissionSite(NewGameState.ModifyStateObject(class'XComGameState_MissionSite', MostDoomMissionState.ObjectID));
		MostDoomMissionState.Doom -= DoomReward;
		DoomPending.Doom = -1 * DoomReward;
		DoomPending.DoomMessage = DoomString;
			
		AlienHQ.PendingDoomData.AddItem(DoomPending);
		AlienHQ.PendingDoomEntity = MostDoomMissionState.GetReference();
	}
}

static function string GetRemoveDoomRewardString(XComGameState_Reward RewardState)
{
	local XGParamTag kTag;

	kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	kTag.StrValue0 = string(RewardState.Quantity);
	return `XEXPAND.ExpandString(default.RewardDoomRemoved);
}

// #######################################################################################
// -------------------- PERSONNEL REWARDS ------------------------------------------------
// #######################################################################################
static function X2RewardTemplate BuildFactionSoldierRewardTemplate(name RewardTemplateName)
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, RewardTemplateName);

	Template.IsRewardAvailableFn = IsFactionSoldierRewardAvailable;
	Template.GenerateRewardFn = GenerateFactionSoldierReward;
	Template.SetRewardFn = SetPersonnelReward;
	Template.GiveRewardFn = GiveFactionSoldierReward;
	Template.GetRewardStringFn = GetPersonnelRewardString;
	Template.GetRewardImageFn = GetPersonnelRewardImage;
	Template.GetBlackMarketStringFn = GetSoldierBlackMarketString;
	Template.GetRewardIconFn = GetGenericRewardIcon;
	Template.CleanUpRewardFn = CleanUpUnitReward;
	Template.RewardPopupFn = FactionSoldierRewardPopup;

	return Template;
}

static function X2DataTemplate CreateFactionSoldierRewardTemplate()
{
	local X2RewardTemplate Template;

	Template = BuildFactionSoldierRewardTemplate('Reward_FactionSoldier');

	return Template;
}

static function bool IsFactionSoldierRewardAvailable(optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	local XComGameState_ResistanceFaction FactionState;

	FactionState = GetFactionState(NewGameState, AuxRef);
	if (FactionState != none)
	{
		return FactionState.IsFactionSoldierRewardAllowed(NewGameState);
	}
	else
	{
		`Redscreen("@jweinhoffer FactionSoldierReward not available because FactionState was not found");
	}

	return false;
}

static function X2DataTemplate CreateExtraFactionSoldierRewardTemplate()
{
	local X2RewardTemplate Template;

	Template = BuildFactionSoldierRewardTemplate('Reward_ExtraFactionSoldier');
	Template.IsRewardAvailableFn = IsExtraFactionSoldierRewardAvailable;

	return Template;
}

static function bool IsExtraFactionSoldierRewardAvailable(optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	local XComGameState_ResistanceFaction FactionState;

	FactionState = GetFactionState(NewGameState, AuxRef);
	if (FactionState != none)
	{
		return FactionState.IsExtraFactionSoldierRewardAllowed(NewGameState);
	}
	else
	{
		`Redscreen("@jweinhoffer ExtraFactionSoldierReward not available because FactionState was not found");
	}

	return false;
}

static function GenerateFactionSoldierReward(XComGameState_Reward RewardState, XComGameState NewGameState, optional float RewardScalar = 1.0, optional StateObjectReference AuxRef)
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_CovertAction ActionState;
	local XComGameState_Unit NewUnitState;
	local XComGameState_ResistanceFaction FactionState;
	local name nmCountry, nmCharacterClass;

	History = `XCOMHISTORY;
	ActionState = XComGameState_CovertAction(NewGameState.GetGameStateForObjectID(AuxRef.ObjectID));
	FactionState = XComGameState_ResistanceFaction(History.GetGameStateForObjectID(AuxRef.ObjectID));
	if (ActionState != none) // If this is a covert action reward, the action's faction determines the character type
	{
		nmCharacterClass = ActionState.GetFaction().GetChampionCharacterName();
		RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(ActionState.Region.ObjectID));
	}
	else if (FactionState != none) // If this is a Res Op mission for a faction, give the associated soldier
	{
		nmCharacterClass = FactionState.GetChampionCharacterName();
		RegionState = FactionState.GetHomeRegion();
	}

	if (nmCharacterClass == '')
	{
		`RedScreen("@jweinhoffer Failed to find a soldier class when generating a Faction Soldier Reward.");
	}
	
	// Grab the region and pick a random country
	nmCountry = '';
	if (RegionState != none)
	{
		nmCountry = RegionState.GetMyTemplate().GetRandomCountryInRegion();
	}	

	NewUnitState = CreatePersonnelUnit(NewGameState, nmCharacterClass, nmCountry);
	RewardState.RewardObjectReference = NewUnitState.GetReference();
}

static function GiveFactionSoldierReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameState_Unit UnitState;
	local XComGameState_ResistanceFaction FactionState;

	GivePersonnelReward(NewGameState, RewardState, AuxRef, bOrder, OrderHours);
	
	UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	FactionState = UnitState.GetResistanceFaction();

	// If the player is rewarded a soldier for an non-met faction, meet them. This is the code path for the "Find Faction" covert action
	// Late game Covert Actions which reward faction soldiers will only be for previously met factions
	if (FactionState != none && !FactionState.bMetXCom)
	{
		FactionState = XComGameState_ResistanceFaction(NewGameState.ModifyStateObject(class'XComGameState_ResistanceFaction', FactionState.ObjectID));
		FactionState.MeetXCom(NewGameState); // Don't give a Faction soldier since we were just rewarded one
	}
}

static function FactionSoldierRewardPopup(XComGameState_Reward RewardState)
{
	local XComGameState NewGameState;
	local XComGameState_Unit UnitState;
	local XComGameState_ResistanceFaction FactionState;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	FactionState = UnitState.GetResistanceFaction();

	if (FactionState != none)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger Event: Faction Soldier Reward");
		`XEVENTMGR.TriggerEvent(FactionState.GetNewFactionSoldierEvent(), , , NewGameState);
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}

	PersonnelRewardPopup(RewardState);
}

static function X2DataTemplate CreateChosenCapturedSoldierRewardTemplate()
{
	local X2RewardTemplate Template;

	// Rescue missions can give back soldiers who were captured by Chosen as a reward, so this template will attempt to do that.
	// Otherwise it defaults to generating a soldier reward
	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_ChosenSoldierCaptured');

	Template.IsRewardAvailableFn = IsChosenCapturedSoldierRewardAvailable;
	Template.GenerateRewardFn = GenerateChosenCapturedSoldierReward;
	Template.SetRewardFn = SetPersonnelReward;
	Template.GiveRewardFn = GiveChosenCapturedSoldierReward;
	Template.GetRewardStringFn = GetPersonnelRewardString;
	Template.GetBlackMarketStringFn = GetSoldierBlackMarketString;
	Template.GetRewardIconFn = GetGenericRewardIcon;
	Template.CleanUpRewardFn = CleanUpRewardWithoutRemoval;

	return Template;
}

static function bool IsChosenCapturedSoldierRewardAvailable(optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	local XComGameStateHistory History;
	local XComGameState_AdventChosen ChosenState;
	local XComGameState_CovertAction ActionState;
	
	History = `XCOMHISTORY;

	// If this reward is being generated for a Covert Action, only check the Chosen associated with the Action's Faction
	ActionState = GetCovertActionState(NewGameState, AuxRef);
	if (ActionState != none)
	{
		ChosenState = ActionState.GetFaction().GetRivalChosen();
		if (ChosenState.bMetXCom && ChosenState.GetNumSoldiersCaptured() > 0)
		{
			return true;
		}
	}
	else
	{
		foreach History.IterateByClassType(class'XComGameState_AdventChosen', ChosenState)
		{
			// Must be a active chosen not at max awareness
			if (ChosenState.bMetXCom && ChosenState.GetNumSoldiersCaptured() > 0)
			{
				return true;
			}
		}
	}

	return false;
}

static function GenerateChosenCapturedSoldierReward(XComGameState_Reward RewardState, XComGameState NewGameState, optional float RewardScalar = 1.0, optional StateObjectReference AuxRef)
{
	local XComGameStateHistory History;
	local XComGameState_CovertAction ActionState;
	local XComGameState_AdventChosen ChosenState;
	local array<XComGameState_AdventChosen> EligibleChosen;
	local int CapturedSoldierIndex;

	History = `XCOMHISTORY;

	// If this reward is being generated for a Covert Action, use the Chosen associated with the Action's Faction
	ActionState = GetCovertActionState(NewGameState, AuxRef);
	if (ActionState != none)
	{
		ChosenState = ActionState.GetFaction().GetRivalChosen();
		if (ChosenState.bMetXCom && ChosenState.GetNumSoldiersCaptured() > 0)
		{
			EligibleChosen.AddItem(ChosenState);
		}
	}
	else
	{
		EligibleChosen.Length = 0;

		foreach History.IterateByClassType(class'XComGameState_AdventChosen', ChosenState)
		{
			if (ChosenState.bMetXCom && ChosenState.GetNumSoldiersCaptured() > 0)
			{
				EligibleChosen.AddItem(ChosenState);
			}
		}
	}
	
	if (EligibleChosen.Length == 0)
	{
		// Should not happen IsRewardAvailableFn needs to be called before generate
		`RedScreen("Tried to generate a chosen captured soldier reward, but no chosen are eligible @gameplay @jweinhoffer");
		return;
	}

	// Pick a random eligible chosen
	ChosenState = EligibleChosen[`SYNC_RAND_STATIC(EligibleChosen.Length)];
	
	// pick a soldier to rescue and save as the Reward
	CapturedSoldierIndex = `SYNC_RAND_STATIC(ChosenState.CapturedSoldiers.Length);
	RewardState.RewardObjectReference = ChosenState.CapturedSoldiers[CapturedSoldierIndex];
}

static function GiveChosenCapturedSoldierReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameState_Unit UnitState;
	local XComGameState_AdventChosen ChosenState;
	local StateObjectReference EmptyRef;

	GivePersonnelReward(NewGameState, RewardState, AuxRef, bOrder, OrderHours);
	
	// The unit should always be in the NewGameState from calling GivePersonnelReward
	UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));	
	
	ChosenState = XComGameState_AdventChosen(NewGameState.GetGameStateForObjectID(UnitState.ChosenCaptorRef.ObjectID));
	if (ChosenState == none)
	{
		ChosenState = XComGameState_AdventChosen(NewGameState.ModifyStateObject(class'XComGameState_AdventChosen', UnitState.ChosenCaptorRef.ObjectID));
	}

	// Release the soldier from the Chosen's captured unit list
	// Also updates the Chosen's Hunt XCOM score, so should only be called when the reward is actually given (ie: mission completed)
	ChosenState.ReleaseSoldier(NewGameState, UnitState.GetReference());
	
	// Set the Unit as no longer captured, and clear their Captor ref
	UnitState.bCaptured = false;
	UnitState.ChosenCaptorRef = EmptyRef;
}

// #######################################################################################
// -------------------- ITEM REWARDS -----------------------------------------------------
// #######################################################################################
static function X2DataTemplate CreateChosenInformationTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_ChosenInformation');
	Template.rewardObjectTemplateName = 'ChosenInformation';

	Template.IsRewardAvailableFn = IsChosenInfoRewardAvailable;
	Template.GenerateRewardFn = GenerateChosenInfoReward;
	Template.SetRewardFn = SetItemReward;
	Template.GiveRewardFn = GiveItemReward;
	Template.GetRewardStringFn = GetChosenInfoRewardString;
	Template.GetRewardImageFn = GetItemRewardImage;
	Template.GetBlackMarketStringFn = GetItemBlackMarketString;
	Template.GetRewardIconFn = GetGenericRewardIcon;

	return Template;
}

static function bool IsChosenInfoRewardAvailable(optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	local XComGameStateHistory History;
	local XComGameState_AdventChosen ChosenState;
	
	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_AdventChosen', ChosenState)
	{
		// Must be a living chosen whose stronghold is not revealed
		if (ChosenState.GetRivalFaction().bMetXCom && ChosenState.bMetXCom && !ChosenState.bDefeated && !ChosenState.IsStrongholdMissionAvailable())
		{
			return true;
		}
	}

	return false;
}

static function GenerateChosenInfoReward(XComGameState_Reward RewardState, XComGameState NewGameState, optional float RewardScalar = 1.0, optional StateObjectReference AuxRef)
{
	local XComGameStateHistory History;
	local XComGameState_AdventChosen ChosenState;
	local array<XComGameState_AdventChosen> EligibleChosen;
	local XComGameState_Item ItemState;
	local X2ItemTemplateManager ItemMgr;
	local X2ItemTemplate ItemTemplate;

	EligibleChosen.Length = 0;

	History = `XCOMHISTORY;
	foreach History.IterateByClassType(class'XComGameState_AdventChosen', ChosenState)
	{
		// Only Chosen who Factions still have available Hunt Chosen Covert Actions available
		if (ChosenState.bMetXCom && !ChosenState.bDefeated && !ChosenState.IsStrongholdMissionAvailable())
		{
			EligibleChosen.AddItem(ChosenState);
		}
	}

	if (EligibleChosen.Length == 0)
	{
		// Should not happen IsRewardAvailableFn needs to be called before generate
		`RedScreen("Tried to generate a chosen info reward, but no chosen are eligible @gameplay @mnauta");
		return;
	}

	// Pick a random eligible chosen and make the info item
	ChosenState = EligibleChosen[`SYNC_RAND_STATIC(EligibleChosen.Length)];

	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	ItemTemplate = ItemMgr.FindItemTemplate(RewardState.GetMyTemplate().rewardObjectTemplateName);
	ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
	ItemState.LinkedEntity = ChosenState.GetReference();
	RewardState.RewardObjectReference = ItemState.GetReference();
}

static function string GetChosenInfoRewardString(XComGameState_Reward RewardState)
{
	local XComGameStateHistory History;
	local XComGameState_Item ItemState;
	local XComGameState_AdventChosen ChosenState;
	local XGParamTag kTag;
	
	History = `XCOMHISTORY;
	ItemState = XComGameState_Item(History.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	ChosenState = XComGameState_AdventChosen(History.GetGameStateForObjectID(ItemState.LinkedEntity.ObjectID));

	if (ChosenState != none)
	{
		kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
		kTag.StrValue0 = ChosenState.GetChosenClassName();
	}
	
	if (ItemState != none)
	{
		return `XEXPAND.ExpandString(RewardState.GetMyTemplate().DisplayName);
	}
	
	return "";
}

static function X2DataTemplate CreateSuperiorWeaponUpgradeTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_SuperiorWeaponUpgrade');
	Template.rewardObjectTemplateName = 'SuperiorWeaponUpgrade';

	Template.SetRewardByTemplateFn = SetLootTableReward;
	Template.GiveRewardFn = GiveLootTableReward;
	Template.GetRewardStringFn = GetLootTableRewardString;
	Template.RewardPopupFn = ItemRewardPopup;

	return Template;
}

static function X2DataTemplate CreateSuperiorPCSTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_SuperiorPCS');
	Template.rewardObjectTemplateName = 'SuperiorPCS';

	Template.SetRewardByTemplateFn = SetLootTableReward;
	Template.GiveRewardFn = GiveLootTableReward;
	Template.GetRewardStringFn = GetLootTableRewardString;
	Template.RewardPopupFn = ItemRewardPopup;

	return Template;
}

static function X2DataTemplate CreateAlienLootTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_AlienLoot');
	Template.rewardObjectTemplateName = 'AlienLoot';

	Template.SetRewardByTemplateFn = SetLootTableReward;
	Template.GiveRewardFn = GiveLootTableReward;
	Template.GetRewardStringFn = GetLootTableRewardString;

	return Template;
}

// #######################################################################################
// -------------------- MISSION REWARDS --------------------------------------------------
// #######################################################################################
static function X2DataTemplate CreateRescueSoldierMissionRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_RescueSoldier');

	Template.IsRewardAvailableFn = IsRescueSoldierRewardAvailable;
	Template.GenerateRewardFn = GenerateRescueSoldierReward;
	Template.GiveRewardFn = GiveRescueSoldierReward;
	Template.GetRewardPreviewStringFn = GetRescueSoldierRewardString;
	Template.GetRewardStringFn = GetRescueSoldierRewardString;
	Template.CleanUpRewardFn = CleanUpRewardWithoutRemoval;
	Template.RewardPopupFn = MissionRewardPopup;

	return Template;
}

static function bool IsRescueSoldierRewardAvailable(optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	local XComGameStateHistory History;
	local XComGameState_CampaignSettings CampaignSettings;
	local XComGameState_ResistanceFaction FactionState;
	local XComGameState_AdventChosen ChosenState;
	
	History = `XCOMHISTORY;

	// If the XPack narrative is turned on, only allow a normal Rescue Soldier once Mox has been rescued
	CampaignSettings = XComGameState_CampaignSettings(History.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));
	if (!CampaignSettings.bXPackNarrativeEnabled || class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('XP0_M4_RescueMoxComplete'))
	{
		FactionState = GetFactionState(NewGameState, AuxRef);
		if (FactionState != none)
		{
			ChosenState = FactionState.GetRivalChosen();
			if (ChosenState.bMetXCom && ChosenState.GetNumSoldiersCaptured() > 0)
			{
				return true;
			}
		}
		else
		{
			`Redscreen("@jweinhoffer RescueSoldierReward not available because FactionState was not found");
		}
	}

	return false;
}

static function GenerateRescueSoldierReward(XComGameState_Reward RewardState, XComGameState NewGameState, optional float RewardScalar = 1.0, optional StateObjectReference ActionRef)
{
	local XComGameState_CovertAction ActionState;
	local XComGameState_AdventChosen ChosenState;
	local XComGameState_Unit UnitState;
	local int CapturedSoldierIndex;

	ActionState = XComGameState_CovertAction(NewGameState.GetGameStateForObjectID(ActionRef.ObjectID));
	ChosenState = ActionState.GetFaction().GetRivalChosen();
	
	// pick a soldier to rescue and save as the Reward
	CapturedSoldierIndex = `SYNC_RAND_STATIC(ChosenState.CapturedSoldiers.Length);
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ChosenState.CapturedSoldiers[CapturedSoldierIndex].ObjectID));
	RewardState.RewardObjectReference = UnitState.GetReference();
	RewardState.RewardString = UnitState.GetName(eNameType_RankFull);
}

static function GiveRescueSoldierReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameState_MissionSite MissionState;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_Reward MissionRewardState;
	local XComGameState_CovertAction ActionState;
	local X2RewardTemplate RewardTemplate;
	local X2StrategyElementTemplateManager StratMgr;
	local X2MissionSourceTemplate MissionSource;
	local array<XComGameState_Reward> MissionRewards;
	local float MissionDuration;
	local bool bExpire;

	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	ActionState = XComGameState_CovertAction(`XCOMHISTORY.GetGameStateForObjectID(AuxRef.ObjectID));
	RegionState = ActionState.GetWorldRegion();

	MissionRewards.Length = 0;
	RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_ChosenSoldierCaptured'));
	MissionRewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
	MissionRewardState.SetReward(RewardState.RewardObjectReference); // Set the soldier we chose to rescue for the Action as the mission reward
	MissionRewards.AddItem(MissionRewardState);

	MissionDuration = float((default.MissionMinDuration + `SYNC_RAND_STATIC(default.MissionMaxDuration - default.MissionMinDuration + 1)) * 3600);
	
	// If the mission is designed to Rescue Mox, don't let it expire
	bExpire = (class'XComGameState_HeadquartersXCom'.static.GetObjectiveStatus('XP0_M4_RescueMoxComplete') == eObjectiveState_Completed);

	MissionSource = X2MissionSourceTemplate(StratMgr.FindStrategyElementTemplate('MissionSource_RescueSoldier'));
	MissionState = XComGameState_MissionSite(NewGameState.CreateNewStateObject(class'XComGameState_MissionSite'));
	MissionState.BuildMission(MissionSource, RegionState.GetRandom2DLocationInRegion(), RegionState.GetReference(), MissionRewards, true, bExpire, , MissionDuration);

	// Set this mission as associated with the Faction whose Covert Action spawned it
	MissionState.ResistanceFaction = ActionState.Faction;

	// Then overwrite the reward reference so the mission is properly awarded when the Action completes
	RewardState.RewardObjectReference = MissionState.GetReference();
}

static function string GetRescueSoldierRewardString(XComGameState_Reward RewardState)
{
	return (RewardState.GetMyTemplate().DisplayName @ RewardState.RewardString);
}

static function X2DataTemplate CreateRevealChosenStrongholdRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_RevealStronghold');

	Template.IsRewardAvailableFn = IsRevealStrongholdRewardAvailable;
	Template.GenerateRewardFn = GenerateChosenStrongholdReward;
	Template.GiveRewardFn = GiveRevealStrongholdReward;
	Template.GetRewardImageFn = GetRevealStrongholdRewardImage;
	Template.CleanUpRewardFn = CleanUpRewardWithoutRemoval;
	Template.RewardPopupFn = FactionInfluenceRewardPopup;

	return Template;
}

static function bool IsRevealStrongholdRewardAvailable(optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	local XComGameState_ResistanceFaction FactionState;
	local XComGameState_AdventChosen ChosenState;

	FactionState = GetFactionState(NewGameState, AuxRef);
	if (FactionState != none)
	{
		// Rival chosen must be active and not at max awareness
		ChosenState = FactionState.GetRivalChosen();
		if (FactionState.bMetXCom && ChosenState.bMetXCom && !ChosenState.bDefeated && FactionState.Influence >= eFactionInfluence_Respected)
		{
			return true;
		}
	}
	else
	{
		`Redscreen("@jweinhoffer RevealStrongholdReward not available because FactionState was not found");
	}

	return false;
}

static function GenerateChosenStrongholdReward(XComGameState_Reward RewardState, XComGameState NewGameState, optional float RewardScalar = 1.0, optional StateObjectReference ActionRef)
{
	RewardState.RewardObjectReference = ActionRef;
}

static function GiveRevealStrongholdReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameState_CovertAction ActionState;
	local XComGameState_ResistanceFaction FactionState;
	local XComGameState_AdventChosen ChosenState;

	ActionState = XComGameState_CovertAction(`XCOMHISTORY.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));

	// Increase influence with the Faction
	FactionState = XComGameState_ResistanceFaction(NewGameState.ModifyStateObject(class'XComGameState_ResistanceFaction', ActionState.Faction.ObjectID));
	FactionState.IncreaseInfluenceLevel(NewGameState);

	// Then reveal the Stronghold mission
	ChosenState = ActionState.GetFaction().GetRivalChosen();
	ChosenState.MakeStrongholdMissionVisible(NewGameState);
}

static function string GetRevealStrongholdRewardImage(XComGameState_Reward RewardState)
{
	local XComGameStateHistory History;
	local XComGameState_CovertAction ActionState;
	local XComGameState_AdventChosen ChosenState;

	History = `XCOMHISTORY;
	ActionState = XComGameState_CovertAction(History.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	ChosenState = ActionState.GetFaction().GetRivalChosen();

	return ChosenState.GetHuntChosenImage(1);
}

static function X2DataTemplate CreateUnlockChosenStrongholdRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_UnlockStronghold');

	Template.IsRewardAvailableFn = IsUnlockStrongholdRewardAvailable;
	Template.GenerateRewardFn = GenerateChosenStrongholdReward;
	Template.GiveRewardFn = GiveUnlockStrongholdReward;
	Template.GetRewardImageFn = GetUnlockStrongholdRewardImage;
	Template.CleanUpRewardFn = CleanUpRewardWithoutRemoval;
	Template.RewardPopupFn = FactionInfluenceRewardPopup;

	return Template;
}

static function bool IsUnlockStrongholdRewardAvailable(optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	local XComGameState_ResistanceFaction FactionState;
	local XComGameState_AdventChosen ChosenState;

	FactionState = GetFactionState(NewGameState, AuxRef);
	if (FactionState != none)
	{
		// Rival chosen must be active and XCOM is at max awareness
		ChosenState = FactionState.GetRivalChosen();
		if (FactionState.bMetXCom && ChosenState.bMetXCom && !ChosenState.bDefeated && FactionState.GetInfluence() >= eFactionInfluence_Influential)
		{
			return true;
		}
	}
	else
	{
		`Redscreen("@jweinhoffer UnlockStrongholdReward not available because FactionState was not found");
	}

	return false;
}

static function GiveUnlockStrongholdReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameState_CovertAction ActionState;
	local XComGameState_AdventChosen ChosenState;

	ActionState = XComGameState_CovertAction(`XCOMHISTORY.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	ChosenState = ActionState.GetFaction().GetRivalChosen();
	ChosenState.MakeStrongholdMissionAvailable(NewGameState);
}

static function string GetUnlockStrongholdRewardImage(XComGameState_Reward RewardState)
{
	local XComGameStateHistory History;
	local XComGameState_CovertAction ActionState;
	local XComGameState_AdventChosen ChosenState;

	History = `XCOMHISTORY;
	ActionState = XComGameState_CovertAction(History.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	ChosenState = ActionState.GetFaction().GetRivalChosen();

	return ChosenState.GetHuntChosenImage(2);
}

// #######################################################################################
// --------------------- FACTION REWARDS ---------------------------------------------
// #######################################################################################
static function X2RewardTemplate BuildFindFactionRewardTemplate(name RewardTemplateName)
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, RewardTemplateName);

	Template.IsRewardAvailableFn = IsFindFactionRewardAvailable;
	Template.GenerateRewardFn = GenerateFactionSoldierReward;
	Template.GiveRewardFn = GiveFactionSoldierReward;
	Template.CleanUpRewardFn = CleanUpUnitReward;

	return Template;
}

static function X2DataTemplate CreateFindFactionRewardTemplate()
{
	local X2RewardTemplate Template;

	Template = BuildFindFactionRewardTemplate('Reward_FindFaction');

	return Template;
}

static function bool IsFindFactionRewardAvailable(optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	local XComGameStateHistory History;
	local XComGameState_ResistanceFaction FactionState;
	local XComGameState_CampaignSettings CampaignSettings;

	History = `XCOMHISTORY;
	FactionState = GetFactionState(NewGameState, AuxRef);
	if (FactionState != none)
	{
		CampaignSettings = XComGameState_CampaignSettings(History.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));
		if (CampaignSettings.bXPackNarrativeEnabled && FactionState.GetMyTemplateName() == 'Faction_Skirmishers')
		{
			return false; // If L&A is enabled, no Find Faction action is present for the Skirmishers. They are met after rescuing Mox.
		}

		return !FactionState.bMetXCom && !FactionState.bFarthestFaction;
	}
	else
	{
		`Redscreen("@jweinhoffer FindFactionReward not available because FactionState was not found");
	}

	return false;
}

static function X2DataTemplate CreateFindFarthestFactionRewardTemplate()
{
	local X2RewardTemplate Template;

	Template = BuildFindFactionRewardTemplate('Reward_FindFarthestFaction');
	Template.IsRewardAvailableFn = IsFindFarthestFactionRewardAvailable;
	
	return Template;
}

static function bool IsFindFarthestFactionRewardAvailable(optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	local XComGameState_ResistanceFaction FactionState;

	FactionState = GetFactionState(NewGameState, AuxRef);
	if (FactionState != none)
	{
		return !FactionState.bMetXCom && FactionState.bFarthestFaction;
	}
	else
	{
		`Redscreen("@jweinhoffer FindFarthestFactionReward not available because FactionState was not found");
	}

	return false;
}

static function X2DataTemplate CreateFactionInfluenceRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_FactionInfluence');

	Template.IsRewardAvailableFn = IsFactionInfluenceRewardAvailable;
	Template.GenerateRewardFn = GenerateFactionInfluenceReward;
	Template.GiveRewardFn = GiveFactionInfluenceReward;
	Template.GetRewardImageFn = GetFactionInfluenceRewardImage;
	Template.GetRewardStringFn = GetFactionInfluenceRewardString;
	Template.CleanUpRewardFn = CleanUpRewardWithoutRemoval;
	Template.RewardPopupFn = FactionInfluenceRewardPopup;

	return Template;
}

static function bool IsFactionInfluenceRewardAvailable(optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	local XComGameState_ResistanceFaction FactionState;
	local XComGameState_AdventChosen ChosenState;

	FactionState = GetFactionState(NewGameState, AuxRef);
	if (FactionState != none)
	{
		// Rival chosen must be active and not at max awareness
		ChosenState = FactionState.GetRivalChosen();
		if (FactionState.bMetXCom && ChosenState.bMetXCom && !ChosenState.bDefeated)
		{
			return true;
		}
	}
	else
	{
		`Redscreen("@jweinhoffer FactionInfluenceReward not available because FactionState was not found");
	}

	return false;
}

static function GenerateFactionInfluenceReward(XComGameState_Reward RewardState, XComGameState NewGameState, optional float RewardScalar = 1.0, optional StateObjectReference ActionRef)
{
	RewardState.RewardObjectReference = ActionRef;
}

static function GiveFactionInfluenceReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameState_CovertAction ActionState;
	local XComGameState_ResistanceFaction FactionState;

	ActionState = XComGameState_CovertAction(`XCOMHISTORY.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	FactionState = XComGameState_ResistanceFaction(NewGameState.ModifyStateObject(class'XComGameState_ResistanceFaction', ActionState.Faction.ObjectID));
	FactionState.IncreaseInfluenceLevel(NewGameState);
}

static function string GetFactionInfluenceRewardImage(XComGameState_Reward RewardState)
{
	local XComGameStateHistory History;
	local XComGameState_CovertAction ActionState;
	local XComGameState_AdventChosen ChosenState;

	History = `XCOMHISTORY;
	ActionState = XComGameState_CovertAction(History.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	ChosenState = ActionState.GetFaction().GetRivalChosen();

	return ChosenState.GetHuntChosenImage(0);
}

static function string GetFactionInfluenceRewardString(XComGameState_Reward RewardState)
{
	local XComGameState_CovertAction ActionState;
	local XGParamTag kTag;

	ActionState = XComGameState_CovertAction(`XCOMHISTORY.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));

	kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	kTag.StrValue0 = ActionState.GetFaction().GetFactionName();
	kTag.IntValue0 = RewardState.Quantity;

	return `XEXPAND.ExpandString(default.RewardFactionInfluence);
}

static function FactionInfluenceRewardPopup(XComGameState_Reward RewardState)
{
	local XComGameState_CovertAction ActionState;
	local XComGameState_ResistanceFaction FactionState;

	ActionState = XComGameState_CovertAction(`XCOMHISTORY.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	FactionState = ActionState.GetFaction();
	
	`HQPRES.UIChosenFragmentRecovered(FactionState.GetRivalChosen().GetReference());
}

static function X2DataTemplate CreateResistanceCardRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_ResistanceCard');
	Template.RewardImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Intel";

	Template.IsRewardAvailableFn = IsResistanceCardRewardAvailable;
	Template.GenerateRewardFn = GenerateResistanceCardReward;
	Template.GiveRewardFn = GiveResistanceCardReward;
	Template.GetRewardImageFn = GetResistanceCardRewardImage;
	Template.GetRewardStringFn = GetResistanceCardRewardString;
	Template.GetRewardPreviewStringFn = GetResistanceCardRewardString;
	Template.GetRewardDetailsStringFn = GetResistanceCardRewardDetailsString;
	Template.CleanUpRewardFn = CleanUpResistanceCardReward;
	Template.RewardPopupFn = ResistanceCardRewardPopup;

	return Template;
}

static function bool IsResistanceCardRewardAvailable(optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	local XComGameState_ResistanceFaction FactionState;

	FactionState = GetFactionState(NewGameState, AuxRef);
	if (FactionState != none)
	{
		return FactionState.IsCardAvailableToMakePlayable();
	}
	else
	{
		`Redscreen("@jweinhoffer ResistanceCardReward not available because FactionState was not found");
	}

	return false;
}

static function GenerateResistanceCardReward(XComGameState_Reward RewardState, XComGameState NewGameState, optional float RewardScalar = 1.0, optional StateObjectReference AuxRef)
{
	local XComGameState_CovertAction ActionState;
	local XComGameState_ResistanceFaction FactionState;
	local XComGameState_StrategyCard CardState;

	ActionState = XComGameState_CovertAction(NewGameState.GetGameStateForObjectID(AuxRef.ObjectID));
	if (ActionState != none)
	{
		FactionState = ActionState.GetFaction();
		CardState = FactionState.DrawRandomPlayableCard(NewGameState);
		
		// Save the generated card to the Action so it can easily be retrieved later
		if (CardState != none)
		{
			ActionState.StoredRewardRef = CardState.GetReference();
		}

		RewardState.RewardObjectReference = AuxRef;
	}
	else
	{
		`RedScreen("@jweinhoffer Tried to generate Resistance Card reward for non-covert action");
	}
}

static function GiveResistanceCardReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameStateHistory History;
	local XComGameState_CovertAction ActionState;
	local XComGameState_ResistanceFaction FactionState;

	History = `XCOMHISTORY;
	ActionState = XComGameState_CovertAction(History.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	
	FactionState = XComGameState_ResistanceFaction(NewGameState.ModifyStateObject(class'XComGameState_ResistanceFaction', ActionState.Faction.ObjectID));
	FactionState.AddPlayableCard(NewGameState, ActionState.StoredRewardRef);
}

static function string GetResistanceCardRewardImage(XComGameState_Reward RewardState)
{
	local XComGameStateHistory History;
	local XComGameState_CovertAction ActionState;
	local XComGameState_StrategyCard CardState;

	History = `XCOMHISTORY;
	ActionState = XComGameState_CovertAction(History.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	CardState = XComGameState_StrategyCard(History.GetGameStateForObjectID(ActionState.StoredRewardRef.ObjectID));

	return CardState.GetImagePath();
}

static function string GetResistanceCardRewardString(XComGameState_Reward RewardState)
{
	local XComGameStateHistory History;
	local XComGameState_CovertAction ActionState;
	local XComGameState_StrategyCard CardState;

	History = `XCOMHISTORY;
	ActionState = XComGameState_CovertAction(History.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	CardState = XComGameState_StrategyCard(History.GetGameStateForObjectID(ActionState.StoredRewardRef.ObjectID));
	
	return CardState.GetDisplayName();
}

static function string GetResistanceCardRewardDetailsString(XComGameState_Reward RewardState)
{
	local XComGameStateHistory History;
	local XComGameState_CovertAction ActionState;
	local XComGameState_StrategyCard CardState;

	History = `XCOMHISTORY;
	ActionState = XComGameState_CovertAction(History.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	CardState = XComGameState_StrategyCard(History.GetGameStateForObjectID(ActionState.StoredRewardRef.ObjectID));

	return CardState.GetSummaryText();
}

static function CleanUpResistanceCardReward(XComGameState NewGameState, XComGameState_Reward RewardState)
{
	local XComGameState_CovertAction ActionState;
	local XComGameState_StrategyCard CardState;
	
	ActionState = XComGameState_CovertAction(`XCOMHISTORY.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	CardState = XComGameState_StrategyCard(NewGameState.ModifyStateObject(class'XComGameState_StrategyCard', ActionState.StoredRewardRef.ObjectID));
	CardState.bDrawn = false; // Put the selected card back into the available pool
}

static function ResistanceCardRewardPopup(XComGameState_Reward RewardState)
{
	local XComGameStateHistory History;
	local XComGameState_CovertAction ActionState;
	local XComGameState_StrategyCard CardState;

	History = `XCOMHISTORY;
	ActionState = XComGameState_CovertAction(History.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	if (ActionState != none)
	{
		CardState = XComGameState_StrategyCard(History.GetGameStateForObjectID(ActionState.StoredRewardRef.ObjectID));
		if (CardState != none)
		{
			`HQPRES.UIStrategyCardReceived(CardState.GetReference());
		}
	}
}

// #######################################################################################
// ---------------------- BREAKTHROUGH TECHS ---------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateBreakthroughTechRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_BreakthroughTech');
	Template.RewardImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Intel";

	Template.IsRewardAvailableFn = IsBreakthroughTechRewardAvailable;
	Template.GenerateRewardFn = GenerateBreakthroughTechReward;
	Template.GiveRewardFn = GiveBreakthroughTechReward;
	Template.GetRewardImageFn = GetBreakthroughTechRewardImage;
	Template.GetRewardStringFn = GetBreakthroughTechRewardString;
	Template.GetRewardPreviewStringFn = GetBreakthroughTechRewardString;
	Template.GetRewardDetailsStringFn = GetBreakthroughTechRewardDetailsString;
	Template.CleanUpRewardFn = CleanUpRewardWithoutRemoval;

	return Template;
}

static function bool IsBreakthroughTechRewardAvailable(optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	return XComHQ.IsBreakthroughTechAvailable();
}

static function GenerateBreakthroughTechReward(XComGameState_Reward RewardState, XComGameState NewGameState, optional float RewardScalar = 1.0, optional StateObjectReference AuxRef)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_CovertAction ActionState;
	local XComGameState_ResistanceFaction FactionState;
	local array<StateObjectReference> AvailableTechRefs;
	local XComGameState_Tech TechState;
	local StateObjectReference TechRef;
	local bool bBreakthroughFound;
	local int TechIndex;
	local name ReqClass;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	ActionState = XComGameState_CovertAction(NewGameState.GetGameStateForObjectID(AuxRef.ObjectID));
		
	if (ActionState != none)
	{
		FactionState = ActionState.GetFaction();

		// Grab all available breakthrough techs and randomly choose one
		AvailableTechRefs = XComHQ.GetAvailableBreakthroughTechs();
		
		while (AvailableTechRefs.Length > 0 && !bBreakthroughFound)
		{
			TechIndex = `SYNC_RAND_STATIC(AvailableTechRefs.Length);
			TechRef = AvailableTechRefs[TechIndex];
			TechState = XComGameState_Tech(History.GetGameStateForObjectID(TechRef.ObjectID));
			
			if (TechState != none)
			{
				bBreakthroughFound = true;

				// Check if the breakthrough requires a soldier class
				if (TechState.GetMyTemplate().Requirements.RequiredSoldierClass != '')
				{
					ReqClass = TechState.GetMyTemplate().Requirements.RequiredSoldierClass;
					if (class'X2SoldierClass_DefaultChampionClasses'.default.ChampionClasses.Find(ReqClass) != INDEX_NONE)
					{
						// This tech requires one of the Faction classes, so make sure that it matches the Faction providing this reward
						if (ReqClass != FactionState.GetChampionClassName())
						{
							bBreakthroughFound = false;
						}
					}
				}
			}

			AvailableTechRefs.Remove(TechIndex, 1);
		}

		// Save the tech to the Action so it can easily be retrieved later
		if (TechState != none)
		{
			ActionState.StoredRewardRef = TechState.GetReference();

			XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
			XComHQ.IgnoredBreakthroughTechs.AddItem(TechRef); // Ignore the breakthrough tech to the HQ ignore list so it doesn't come up in the future
		}

		RewardState.RewardObjectReference = AuxRef;
	}
	else
	{
		`RedScreen("@jweinhoffer Tried to generate Breakthrough Tech reward for non-covert action");
	}
}

static function GiveBreakthroughTechReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_CovertAction ActionState;
	local XComGameState_Tech TechState;
	local int TechIndex;

	History = `XCOMHISTORY;
	ActionState = XComGameState_CovertAction(History.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));

	// Mark the tech as completed in XComHQ, and remove it from the ignored list
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	XComHQ.TechsResearched.AddItem(ActionState.StoredRewardRef);
	TechIndex = XComHQ.IgnoredBreakthroughTechs.Find('ObjectID', ActionState.StoredRewardRef.ObjectID);
	if (TechIndex != INDEX_NONE)
	{
		XComHQ.IgnoredBreakthroughTechs.Remove(TechIndex, 1);
	}
	
	// Then modify the tech data
	TechState = XComGameState_Tech(NewGameState.ModifyStateObject(class'XComGameState_Tech', ActionState.StoredRewardRef.ObjectID));
	TechState.TimesResearched++;
	TechState.TimeReductionScalar = 0;
	TechState.bBreakthrough = true; // Flag the tech state as a breakthrough so research reports are displayed properly
	TechState.OnResearchCompleted(NewGameState);
}

static function string GetBreakthroughTechRewardImage(XComGameState_Reward RewardState)
{
	local XComGameStateHistory History;
	local XComGameState_CovertAction ActionState;
	local XComGameState_Tech TechState;

	History = `XCOMHISTORY;
	ActionState = XComGameState_CovertAction(History.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	TechState = XComGameState_Tech(History.GetGameStateForObjectID(ActionState.StoredRewardRef.ObjectID));

	return TechState.GetImage();
}

static function string GetBreakthroughTechRewardString(XComGameState_Reward RewardState)
{
	local XComGameStateHistory History;
	local XComGameState_CovertAction ActionState;
	local XComGameState_Tech TechState;

	History = `XCOMHISTORY;
	ActionState = XComGameState_CovertAction(History.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	TechState = XComGameState_Tech(History.GetGameStateForObjectID(ActionState.StoredRewardRef.ObjectID));

	return TechState.GetDisplayName();
}

static function string GetBreakthroughTechRewardDetailsString(XComGameState_Reward RewardState)
{
	local XComGameStateHistory History;
	local XComGameState_CovertAction ActionState;
	local XComGameState_Tech TechState;
	local X2TechTemplate TechTemplate;
	local string TechSummary;

	History = `XCOMHISTORY;
	ActionState = XComGameState_CovertAction(History.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	TechState = XComGameState_Tech(History.GetGameStateForObjectID(ActionState.StoredRewardRef.ObjectID));
	TechTemplate = TechState.GetMyTemplate();

	TechSummary = TechState.GetSummary();
	if (TechTemplate.GetValueFn != none)
	{
		TechSummary = Repl(TechSummary, "%VALUE", TechTemplate.GetValueFn());
	}

	return TechSummary;
}

// #######################################################################################
// --------------------- INDIVIDUAL REWARDS ---------------------------------------------
// #######################################################################################
static function X2DataTemplate CreateRankUpRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_RankUp');

	Template.GiveRewardFn = GiveRankUpReward;
	Template.GetRewardStringFn = GetRankUpRewardString;
	Template.RewardPopupFn = RankUpRewardPopup;
	Template.CleanUpRewardFn = CleanUpRewardWithoutRemoval;

	return Template;
}

static function GiveRankUpReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit UnitState;
	local int NewRank;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AuxRef.ObjectID));
	if (UnitState == none)
	{
		UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', AuxRef.ObjectID));
	}
		
	if (!UnitState.GetSoldierClassTemplate().bBlockRankingUp && UnitState.GetRank() < UnitState.GetSoldierClassTemplate().GetMaxConfiguredRank())
	{
		UnitState.RankUpSoldier(NewGameState);
		NewRank = UnitState.GetRank();

		if (NewRank == 1)
		{
			XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
			UnitState.ApplySquaddieLoadout(NewGameState, XComHQ);
			UnitState.ApplyBestGearLoadout(NewGameState); // Make sure the squaddie has the best gear available
		}

		// Set unit's XP and kills to the next rank, so when the action completes they will have a promotion ready
		UnitState.SetXPForRank(NewRank);
		UnitState.SetKillsForRank(NewRank);
		
		RewardState.RewardObjectReference = UnitState.GetReference();
		
		`XEVENTMGR.TriggerEvent('PromotionEvent', UnitState, UnitState, NewGameState);
	}	
}

static function string GetRankUpRewardString(XComGameState_Reward RewardState)
{
	local XComGameState_Unit UnitState;
	local XGParamTag kTag;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));

	if (UnitState != none)
	{
		kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
		kTag.StrValue0 = UnitState.GetName(eNameType_Rank);

		return `XEXPAND.ExpandString(default.RewardPromotion);
	}

	return "";
}

static function RankUpRewardPopup(XComGameState_Reward RewardState)
{	
	if (RewardState.RewardObjectReference.ObjectID != 0)
	{
		`HQPRES.UISoldierPromoted(RewardState.RewardObjectReference);
	}
}

static function X2DataTemplate CreateStatBoostHPRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_StatBoostHP');
	Template.rewardObjectTemplateName = 'StatBoost_HP';
	
	Template.GenerateRewardFn = GenerateItemReward;
	Template.GiveRewardFn = GiveStatBoostReward;
	Template.GetRewardPreviewStringFn = GetStatBoostRewardPreviewString;
	Template.GetRewardStringFn = GetStatBoostRewardString;
	
	return Template;
}

static function X2DataTemplate CreateStatBoostAimRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_StatBoostAim');
	Template.rewardObjectTemplateName = 'StatBoost_Aim';

	Template.GenerateRewardFn = GenerateItemReward;
	Template.GiveRewardFn = GiveStatBoostReward;
	Template.GetRewardPreviewStringFn = GetStatBoostRewardPreviewString;
	Template.GetRewardStringFn = GetStatBoostRewardString;

	return Template;
}

static function X2DataTemplate CreateStatBoostMobilityRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_StatBoostMobility');
	Template.rewardObjectTemplateName = 'StatBoost_Mobility';

	Template.GenerateRewardFn = GenerateItemReward;
	Template.GiveRewardFn = GiveStatBoostReward;
	Template.GetRewardPreviewStringFn = GetStatBoostRewardPreviewString;
	Template.GetRewardStringFn = GetStatBoostRewardString;

	return Template;
}

static function X2DataTemplate CreateStatBoostDodgeRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_StatBoostDodge');
	Template.rewardObjectTemplateName = 'StatBoost_Dodge';

	Template.GenerateRewardFn = GenerateItemReward;
	Template.GiveRewardFn = GiveStatBoostReward;
	Template.GetRewardPreviewStringFn = GetStatBoostRewardPreviewString;
	Template.GetRewardStringFn = GetStatBoostRewardString;

	return Template;
}

static function X2DataTemplate CreateStatBoostWillRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_StatBoostWill');
	Template.rewardObjectTemplateName = 'StatBoost_Will';

	Template.GenerateRewardFn = GenerateItemReward;
	Template.GiveRewardFn = GiveStatBoostReward;
	Template.GetRewardPreviewStringFn = GetStatBoostRewardPreviewString;
	Template.GetRewardStringFn = GetStatBoostRewardString;

	return Template;
}

static function X2DataTemplate CreateStatBoostHackingRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_StatBoostHacking');
	Template.rewardObjectTemplateName = 'StatBoost_Hacking';

	Template.GenerateRewardFn = GenerateItemReward;
	Template.GiveRewardFn = GiveStatBoostReward;
	Template.GetRewardPreviewStringFn = GetStatBoostRewardPreviewString;
	Template.GetRewardStringFn = GetStatBoostRewardString;

	return Template;
}

static function GiveStatBoostReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit UnitState;
	local XComGameState_Item ItemState;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	
	UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AuxRef.ObjectID));
	if (UnitState == none)
	{
		UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', AuxRef.ObjectID));
	}	
	
	ItemState = XComGameState_Item(NewGameState.ModifyStateObject(class'XComGameState_Item', RewardState.RewardObjectReference.ObjectID));
	ItemState.LinkedEntity = UnitState.GetReference(); // Link the item and unit together so the stat boost gets applied properly
	
	if (!XComHQ.PutItemInInventory(NewGameState, ItemState))
	{
		NewGameState.PurgeGameStateForObjectID(XComHQ.ObjectID);
	}
}

static function string GetStatBoostRewardPreviewString(XComGameState_Reward RewardState)
{
	local XComGameStateHistory History;
	local XComGameState_Item ItemState;
	local StatBoost ItemStatBoost;
	local int Quantity;

	History = `XCOMHISTORY;
	ItemState = XComGameState_Item(History.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));

	if (ItemState != none)
	{
		foreach ItemState.StatBoosts(ItemStatBoost)
		{
			Quantity += ItemStatBoost.Boost;

			if ((ItemStatBoost.StatType == eStat_HP) && `SecondWaveEnabled('BetaStrike'))
			{
				Quantity += ItemStatBoost.Boost * (class'X2StrategyGameRulesetDataStructures'.default.SecondWaveBetaStrikeHealthMod - 1.0);
			}
		}
		return ItemState.GetMyTemplate().GetItemFriendlyName() @ "+" $ string(Quantity);
	}

	return "";
}

static function string GetStatBoostRewardString(XComGameState_Reward RewardState)
{
	local XComGameStateHistory History;
	local XComGameState_Item ItemState;
	local StatBoost ItemStatBoost;
	local XGParamTag kTag;
	local int Quantity;

	History = `XCOMHISTORY;
	ItemState = XComGameState_Item(History.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));

	if (ItemState != none)
	{
		foreach ItemState.StatBoosts(ItemStatBoost)
		{
			Quantity += ItemStatBoost.Boost;

			if ((ItemStatBoost.StatType == eStat_HP) && `SecondWaveEnabled('BetaStrike'))
			{
				Quantity += ItemStatBoost.Boost * (class'X2StrategyGameRulesetDataStructures'.default.SecondWaveBetaStrikeHealthMod - 1.0);
			}
		}
		
		kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
		kTag.StrValue0 = ItemState.GetMyTemplate().GetItemFriendlyName();
		kTag.IntValue0 = Quantity;

		return `XEXPAND.ExpandString(default.RewardStatBoost);
	}

	return "";
}

static function X2DataTemplate CreateSoldierAbilityPointsRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_SoldierAbilityPoints');
	Template.rewardObjectTemplateName = 'AbilityPoint';
	
	Template.GenerateRewardFn = GenerateSoldierAbilityPointsReward;
	Template.GiveRewardFn = GiveSoldierAbilityPointsReward;
	Template.GetRewardStringFn = GetSoldierAbilityPointsRewardString;
	
	return Template;
}

static function GenerateSoldierAbilityPointsReward(XComGameState_Reward RewardState, XComGameState NewGameState, optional float RewardScalar = 1.0, optional StateObjectReference AuxRef)
{
	RewardState.Quantity = GetSoldierAbilityPointsMinReward() + `SYNC_RAND_STATIC(GetSoldierAbilityPointsMaxReward() - GetSoldierAbilityPointsMinReward() + 1);
}

static function GiveSoldierAbilityPointsReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AuxRef.ObjectID));
	if (UnitState == none)
	{
		UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', AuxRef.ObjectID));
	}

	UnitState.AbilityPoints += RewardState.Quantity;
}

static function string GetSoldierAbilityPointsRewardString(XComGameState_Reward RewardState)
{
	return "+" $ string(RewardState.Quantity) @ RewardState.GetMyTemplate().DisplayName;
}

// #######################################################################################
// --------------------- COVERT ACTIONS ---------------------------------------------
// #######################################################################################
static function X2DataTemplate CreateDecreaseRiskRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_DecreaseRisk');

	Template.GenerateRewardFn = GenerateDecreaseRiskReward;
	Template.GetRewardPreviewStringFn = GetDecreaseRiskRewardString;
	Template.GetRewardStringFn = GetDecreaseRiskRewardString;

	return Template;
}

static function GenerateDecreaseRiskReward(XComGameState_Reward RewardState, XComGameState NewGameState, optional float RewardScalar = 1.0, optional StateObjectReference AuxRef)
{
	local XComGameState_CovertAction ActionState;
	local int RandIdx;

	// Choose a risk at random, and save its name so it can be removed from the Action
	ActionState = XComGameState_CovertAction(NewGameState.GetGameStateForObjectID(AuxRef.ObjectID));

	// If Soldier Captured is a risk on the default Covert Action (ie not added by a Dark Event), always attempt to counter it
	if (ActionState.GetMyTemplate().Risks.Find('CovertActionRisk_SoldierCaptured') != INDEX_NONE)
	{
		RewardState.RewardObjectTemplateName = 'CovertActionRisk_SoldierCaptured';
	}
	else // Otherwise choose a random risk to counter
	{
		RandIdx = `SYNC_RAND_STATIC(ActionState.Risks.Length); // Choose a random risk
		RewardState.RewardObjectTemplateName = ActionState.Risks[RandIdx].RiskTemplateName;
	}
}

static function string GetDecreaseRiskRewardString(XComGameState_Reward RewardState)
{
	local X2StrategyElementTemplateManager StratMgr;
	local X2CovertActionRiskTemplate RiskTemplate;

	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	RiskTemplate = X2CovertActionRiskTemplate(StratMgr.FindStrategyElementTemplate(RewardState.RewardObjectTemplateName));

	return RewardState.GetMyTemplate().DisplayName @ RiskTemplate.RiskName;
}

// #######################################################################################
// -------------------- DIFFICULTY HELPERS -----------------------------------------------
// #######################################################################################

static function int GetAbilityPointsBaseReward()
{
	return `ScaleStrategyArrayInt(default.AbilityPointsBaseReward);
}

static function int GetAbilityPointsRewardIncrease()
{
	return `ScaleStrategyArrayInt(default.AbilityPointsRewardIncrease);
}

static function int GetAbilityPointsInterval()
{
	return `ScaleStrategyArrayInt(default.AbilityPointsInterval);
}

static function int GetFactionInfluenceMinReward()
{
	return `ScaleStrategyArrayInt(default.FactionInfluenceMinReward);
}

static function int GetFactionInfluenceMaxReward()
{
	return `ScaleStrategyArrayInt(default.FactionInfluenceMaxReward);
}

static function int GetSoldierAbilityPointsMinReward()
{
	return `ScaleStrategyArrayInt(default.SoldierAbilityPointsMinReward);
}

static function int GetSoldierAbilityPointsMaxReward()
{
	return `ScaleStrategyArrayInt(default.SoldierAbilityPointsMaxReward);
}

static function int GetRemoveDoomReward()
{
	return `ScaleStrategyArrayInt(default.RemoveDoomReward);
}

static function int GetRescueCivilianIncomeIncreaseReward()
{
	return `ScaleStrategyArrayInt(default.RescueCivilianIncomeIncreaseReward);
}