//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DefaultCovertActions.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2StrategyElement_DefaultCovertActions extends X2StrategyElement;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> CovertActions;

	CovertActions.AddItem(CreateRecruitScientistTemplate());
	CovertActions.AddItem(CreateRecruitEngineerTemplate());
	CovertActions.AddItem(CreateRevealChosenMovementsTemplate());
	CovertActions.AddItem(CreateRevealChosenStrengthsTemplate());
	CovertActions.AddItem(CreateRevealChosenStrongholdTemplate());
	CovertActions.AddItem(CreateGatherSuppliesTemplate());
	CovertActions.AddItem(CreateGatherIntelTemplate());
	CovertActions.AddItem(CreateIncreaseIncomeTemplate());
	CovertActions.AddItem(CreateCancelChosenActivityTemplate());
	CovertActions.AddItem(CreateRemoveDoomTemplate());
	CovertActions.AddItem(CreateRescueSoldierTemplate());
	CovertActions.AddItem(CreateFindFactionTemplate());
	CovertActions.AddItem(CreateFindFarthestFactionTemplate());
	CovertActions.AddItem(CreateRecruitFactionSoldierTemplate());
	CovertActions.AddItem(CreateRecruitExtraFactionSoldierTemplate());
	CovertActions.AddItem(CreateImproveComIntTemplate());
	CovertActions.AddItem(CreateFormSoldierBondTemplate());
	CovertActions.AddItem(CreateGainResistanceContactTemplate());
	CovertActions.AddItem(CreateGainSharedAbilityPointsTemplate());
	CovertActions.AddItem(CreateGainBreakthroughTechTemplate());
	CovertActions.AddItem(CreateGainResistanceCardTemplate());
	CovertActions.AddItem(CreateGainSuperiorWeaponUpgradeTemplate());
	CovertActions.AddItem(CreateGainSuperiorPCSTemplate());
	CovertActions.AddItem(CreateGainFacilityLeadTemplate());
	CovertActions.AddItem(CreateGainAlienLootTemplate());

	return CovertActions;
}

//---------------------------------------------------------------------------------------
// RECRUIT SCIENTIST
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateRecruitScientistTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_RecruitScientist');

	Template.ChooseLocationFn = ChooseRandomRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";

	Template.Narratives.AddItem('CovertActionNarrative_RecruitScientist_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_RecruitScientist_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_RecruitScientist_Templars');

	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));
	Template.OptionalCosts.AddItem(CreateOptionalCostSlot('EleriumDust', 10));

	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');

	Template.Rewards.AddItem('Reward_Scientist');

	return Template;
}

//---------------------------------------------------------------------------------------
// RECRUIT ENGINEER
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateRecruitEngineerTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_RecruitEngineer');

	Template.ChooseLocationFn = ChooseRandomRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";

	Template.Narratives.AddItem('CovertActionNarrative_RecruitEngineer_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_RecruitEngineer_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_RecruitEngineer_Templars');

	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));
	Template.OptionalCosts.AddItem(CreateOptionalCostSlot('AlienAlloy', 25));

	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');

	Template.Rewards.AddItem('Reward_Engineer');

	return Template;
}

//---------------------------------------------------------------------------------------
// REVEAL CHOSEN MOVEMENTS
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateRevealChosenMovementsTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_RevealChosenMovements');

	Template.ChooseLocationFn = ChooseRivalChosenHomeContinentRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";
	Template.bGoldenPath = true;
	Template.bUseRewardImage = true;

	Template.Narratives.AddItem('CovertActionNarrative_RevealChosenMovements_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_RevealChosenMovements_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_RevealChosenMovements_Templars');

	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot', 3));
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));
	Template.Slots.AddItem(CreateDefaultOptionalSlot('CovertActionSoldierStaffSlot'));

	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');
	Template.Risks.AddItem('CovertActionRisk_Ambush');

	Template.Rewards.AddItem('Reward_FactionInfluence');

	return Template;
}

//---------------------------------------------------------------------------------------
// REVEAL CHOSEN STRENGTHS
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateRevealChosenStrengthsTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_RevealChosenStrengths');

	Template.ChooseLocationFn = ChooseRivalChosenHomeContinentRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";
	Template.RequiredFactionInfluence = eFactionInfluence_Respected;
	Template.bGoldenPath = true;
	Template.bUseRewardImage = true;

	Template.Narratives.AddItem('CovertActionNarrative_RevealChosenStrengths_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_RevealChosenStrengths_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_RevealChosenStrengths_Templars');

	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot', 4));
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));
	Template.Slots.AddItem(CreateDefaultOptionalSlot('CovertActionSoldierStaffSlot', 3));

	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');
	Template.Risks.AddItem('CovertActionRisk_SoldierCaptured');
	Template.Risks.AddItem('CovertActionRisk_Ambush');

	Template.Rewards.AddItem('Reward_RevealStronghold');

	return Template;
}

//---------------------------------------------------------------------------------------
// REVEAL CHOSEN STRONGHOLD
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateRevealChosenStrongholdTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_RevealChosenStronghold');

	Template.ChooseLocationFn = ChooseRivalChosenHomeRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";
	Template.RequiredFactionInfluence = eFactionInfluence_Influential;
	Template.bGoldenPath = true;
	Template.bUseRewardImage = true;

	Template.Narratives.AddItem('CovertActionNarrative_RevealChosenStronghold_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_RevealChosenStronghold_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_RevealChosenStronghold_Templars');

	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot', 6));
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));
	Template.Slots.AddItem(CreateDefaultOptionalSlot('CovertActionSoldierStaffSlot', , true));

	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');
	Template.Risks.AddItem('CovertActionRisk_Ambush');

	Template.Rewards.AddItem('Reward_UnlockStronghold');

	return Template;
}

//---------------------------------------------------------------------------------------
// GATHER SUPPLIES
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateGatherSuppliesTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_GatherSupplies');

	Template.ChooseLocationFn = ChooseRandomRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";

	Template.Narratives.AddItem('CovertActionNarrative_GatherSupplies_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_GatherSupplies_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_GatherSupplies_Templars');

	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));
	Template.Slots.AddItem(CreateDefaultOptionalSlot('CovertActionEngineerStaffSlot'));

	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');

	Template.Rewards.AddItem('Reward_Supplies');

	return Template;
}

//---------------------------------------------------------------------------------------
// GATHER INTEL
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateGatherIntelTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_GatherIntel');

	Template.ChooseLocationFn = ChooseRandomRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";

	Template.Narratives.AddItem('CovertActionNarrative_GatherIntel_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_GatherIntel_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_GatherIntel_Templars');
	
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));
	Template.Slots.AddItem(CreateDefaultOptionalSlot('CovertActionScientistStaffSlot'));

	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');

	Template.Rewards.AddItem('Reward_Intel');

	return Template;
}

//---------------------------------------------------------------------------------------
// INCREASE INCOME
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateIncreaseIncomeTemplate()
{
	local X2CovertActionTemplate Template;
	
	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_IncreaseIncome');

	Template.ChooseLocationFn = ChooseRandomContactedRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";

	Template.Narratives.AddItem('CovertActionNarrative_IncreaseIncome_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_IncreaseIncome_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_IncreaseIncome_Templars');

	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot', 3));
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));
	Template.Slots.AddItem(CreateDefaultOptionalSlot('CovertActionEngineerStaffSlot'));

	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');
	Template.Risks.AddItem('CovertActionRisk_SoldierCaptured');
	Template.Risks.AddItem('CovertActionRisk_Ambush');

	Template.Rewards.AddItem('Reward_IncreaseIncome');

	return Template;
}

//---------------------------------------------------------------------------------------
// CANCEL CHOSEN ACTIVITY
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateCancelChosenActivityTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_CancelChosenActivity');

	Template.ChooseLocationFn = ChooseRandomRivalChosenRegion;
	Template.OnStartedFn = OnCancelChosenActivityStarted;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";
	Template.bMultiplesAllowed = true;
	Template.bDisplayRequiresAvailable = true;
	Template.bUseRewardImage = true;

	Template.Narratives.AddItem('CovertActionNarrative_CancelChosenActivity_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_CancelChosenActivity_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_CancelChosenActivity_Templars');

	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot', 3));
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));
	Template.OptionalCosts.AddItem(CreateOptionalCostSlot('Intel', 25));

	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');
	Template.Risks.AddItem('CovertActionRisk_SoldierCaptured');
	Template.Risks.AddItem('CovertActionRisk_Ambush');

	Template.Rewards.AddItem('Reward_CancelChosenActivity');

	return Template;
}

function OnCancelChosenActivityStarted(XComGameState NewGameState, XComGameState_CovertAction ActionState)
{
	local XComGameState_AdventChosen ChosenState;

	ChosenState = ActionState.GetFaction().GetRivalChosen();
	if (ChosenState != none && !ChosenState.bPerformedMonthlyAction && ChosenState.bActionUsesTimer)
	{
		// Flag the Chosen's monthly action as countered as soon as the Covert Action starts, so it does not trigger
		// while the Action is still in progress
		ChosenState = XComGameState_AdventChosen(NewGameState.ModifyStateObject(class'XComGameState_AdventChosen', ChosenState.ObjectID));
		ChosenState.bActionCountered = true;
	}
}

//---------------------------------------------------------------------------------------
// REMOVE DOOM
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateRemoveDoomTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_RemoveDoom');

	Template.ChooseLocationFn = ChooseRandomRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";
	Template.bMultiplesAllowed = true;
	Template.bDisplayRequiresAvailable = true;

	Template.Narratives.AddItem('CovertActionNarrative_RemoveDoom_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_RemoveDoom_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_RemoveDoom_Templars');

	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot', 3));
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));
	Template.OptionalCosts.AddItem(CreateOptionalCostSlot('Supplies', 25));

	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');
	Template.Risks.AddItem('CovertActionRisk_SoldierCaptured');
	Template.Risks.AddItem('CovertActionRisk_Ambush');

	Template.Rewards.AddItem('Reward_RemoveDoom');

	return Template;
}

//---------------------------------------------------------------------------------------
// RESCUE SOLDIER
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateRescueSoldierTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_RescueSoldier');

	Template.ChooseLocationFn = ChooseRandomRivalChosenRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";

	Template.Narratives.AddItem('CovertActionNarrative_RescueSoldier_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_RescueSoldier_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_RescueSoldier_Templars');

	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));
	Template.OptionalCosts.AddItem(CreateOptionalCostSlot('Intel', 25));

	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');
	Template.Risks.AddItem('CovertActionRisk_Ambush');

	Template.Rewards.AddItem('Reward_RescueSoldier');

	return Template;
}

//---------------------------------------------------------------------------------------
// FIND FACTION
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateFindFactionTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_FindFaction');

	Template.ChooseLocationFn = ChooseFactionRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";
	Template.bGoldenPath = true;

	Template.Narratives.AddItem('CovertActionNarrative_FindFaction_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_FindFaction_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_FindFaction_Templars');

	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));

	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');

	Template.Rewards.AddItem('Reward_FindFaction');

	return Template;
}

//---------------------------------------------------------------------------------------
// FIND FARTHEST FACTION
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateFindFarthestFactionTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_FindFarthestFaction');

	Template.ChooseLocationFn = ChooseFactionRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";
	Template.bGoldenPath = true;

	Template.Narratives.AddItem('CovertActionNarrative_FindFaction_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_FindFaction_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_FindFaction_Templars');

	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot', 3));
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));

	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');

	Template.Rewards.AddItem('Reward_FindFarthestFaction');

	return Template;
}

//---------------------------------------------------------------------------------------
// RECRUIT FACTION SOLDIER
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateRecruitFactionSoldierTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_RecruitFactionSoldier');

	Template.ChooseLocationFn = ChooseRandomRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";
	Template.bMultiplesAllowed = true;
	Template.bForceCreation = true;

	Template.Narratives.AddItem('CovertActionNarrative_RecruitFactionSoldier_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_RecruitFactionSoldier_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_RecruitFactionSoldier_Templars');

	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot', 3));
	Template.Slots.AddItem(CreateDefaultOptionalSlot('CovertActionSoldierStaffSlot'));

	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');
	Template.Risks.AddItem('CovertActionRisk_Ambush');

	Template.Rewards.AddItem('Reward_FactionSoldier');

	return Template;
}

//---------------------------------------------------------------------------------------
// RECRUIT EXTRA FACTION SOLDIER
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateRecruitExtraFactionSoldierTemplate()
{
	local X2CovertActionTemplate Template;
	
	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_RecruitExtraFactionSoldier');

	Template.ChooseLocationFn = ChooseRandomRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";
	Template.RequiredFactionInfluence = eFactionInfluence_Influential;
	Template.bDisplayIgnoresInfluence = true;

	Template.Narratives.AddItem('CovertActionNarrative_RecruitFactionSoldier_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_RecruitFactionSoldier_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_RecruitFactionSoldier_Templars');
	
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot', 3));
	Template.Slots.AddItem(CreateDefaultOptionalSlot('CovertActionSoldierStaffSlot'));

	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');
	Template.Risks.AddItem('CovertActionRisk_Ambush');

	Template.Rewards.AddItem('Reward_ExtraFactionSoldier');

	return Template;
}

//---------------------------------------------------------------------------------------
// IMPROVE COM INT
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateImproveComIntTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_ImproveComInt');

	Template.ChooseLocationFn = ChooseRandomRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";

	Template.Narratives.AddItem('CovertActionNarrative_ImproveComInt_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_ImproveComInt_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_ImproveComInt_Templars');
	
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionImproveComIntStaffSlot'));
	Template.Slots.AddItem(CreateDefaultOptionalSlot('CovertActionScientistStaffSlot'));

	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');

	Template.Rewards.AddItem('Reward_IncreaseComInt');
	
	return Template;
}

//---------------------------------------------------------------------------------------
// FORM SOLDIER BOND
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateFormSoldierBondTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_FormSoldierBond');

	Template.ChooseLocationFn = ChooseRandomRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";

	Template.Narratives.AddItem('CovertActionNarrative_FormSoldierBond_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_FormSoldierBond_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_FormSoldierBond_Templars');

	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionFormSoldierBondStaffSlot'));
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionFormSoldierBondStaffSlot'));
	Template.OptionalCosts.AddItem(CreateOptionalCostSlot('Supplies', 25));

	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');

	Template.Rewards.AddItem('Reward_FormSoldierBond');

	return Template;
}

//---------------------------------------------------------------------------------------
// GAIN RESISTANCE CONTACT
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateGainResistanceContactTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_ResistanceContact');

	Template.ChooseLocationFn = ChooseRandomRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";
	Template.RequiredFactionInfluence = eFactionInfluence_Respected;
	Template.bUnique = true;

	Template.Narratives.AddItem('CovertActionNarrative_ResistanceContact_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_ResistanceContact_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_ResistanceContact_Templars');

	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot', 3));
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));
	Template.OptionalCosts.AddItem(CreateOptionalCostSlot('Supplies', 25));

	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');
	Template.Risks.AddItem('CovertActionRisk_SoldierCaptured');
	Template.Risks.AddItem('CovertActionRisk_Ambush');

	Template.Rewards.AddItem('Reward_AvengerResComms');

	return Template;
}

//---------------------------------------------------------------------------------------
// GAIN SHARED ABILITY POINTS
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateGainSharedAbilityPointsTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_SharedAbilityPoints');

	Template.ChooseLocationFn = ChooseRandomRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";
	
	Template.Narratives.AddItem('CovertActionNarrative_SharedAbilityPoints_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_SharedAbilityPoints_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_SharedAbilityPoints_Templars');

	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));
	Template.OptionalCosts.AddItem(CreateOptionalCostSlot('Intel', 25));

	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');

	Template.Rewards.AddItem('Reward_AbilityPoints');
	
	return Template;
}

//---------------------------------------------------------------------------------------
// GAIN BREAKTHROUGH TECH
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateGainBreakthroughTechTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_BreakthroughTech');

	Template.ChooseLocationFn = ChooseRandomRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";
	Template.bMultiplesAllowed = true;
	Template.bUseRewardImage = true;

	Template.Narratives.AddItem('CovertActionNarrative_BreakthroughTech_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_BreakthroughTech_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_BreakthroughTech_Templars');

	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));
	Template.Slots.AddItem(CreateDefaultStaffSlot('CovertActionScientistStaffSlot'));
	Template.Slots.AddItem(CreateDefaultOptionalSlot('CovertActionSoldierStaffSlot'));

	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');

	Template.Rewards.AddItem('Reward_BreakthroughTech');

	return Template;
}

//---------------------------------------------------------------------------------------
// GAIN RESISTANCE CARD
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateGainResistanceCardTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_ResistanceCard');

	Template.ChooseLocationFn = ChooseRandomRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";
	Template.bMultiplesAllowed = true;
	Template.bUseRewardImage = true;

	Template.Narratives.AddItem('CovertActionNarrative_ResistanceCard_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_ResistanceCard_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_ResistanceCard_Templars');

	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));
	Template.OptionalCosts.AddItem(CreateOptionalCostSlot('Intel', 25));

	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');
	Template.Risks.AddItem('CovertActionRisk_Ambush');

	Template.Rewards.AddItem('Reward_ResistanceCard');

	return Template;
}

//---------------------------------------------------------------------------------------
// GAIN SUPERIOR WEAPON UPGRADE
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateGainSuperiorWeaponUpgradeTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_SuperiorWeaponUpgrade');

	Template.ChooseLocationFn = ChooseRandomRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";
	Template.RequiredFactionInfluence = eFactionInfluence_Respected;
	Template.bUnique = true;

	Template.Narratives.AddItem('CovertActionNarrative_SuperiorWeaponUpgrade_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_SuperiorWeaponUpgrade_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_SuperiorWeaponUpgrade_Templars');

	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot', 3));
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));
	Template.OptionalCosts.AddItem(CreateOptionalCostSlot('Supplies', 25));

	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');

	Template.Rewards.AddItem('Reward_SuperiorWeaponUpgrade');

	return Template;
}

//---------------------------------------------------------------------------------------
// GAIN SUPERIOR PCS
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateGainSuperiorPCSTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_SuperiorPCS');

	Template.ChooseLocationFn = ChooseRandomRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";
	Template.RequiredFactionInfluence = eFactionInfluence_Respected;
	Template.bUnique = true;

	Template.Narratives.AddItem('CovertActionNarrative_SuperiorPCS_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_SuperiorPCS_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_SuperiorPCS_Templars');

	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot', 3));
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));
	Template.OptionalCosts.AddItem(CreateOptionalCostSlot('Intel', 25));

	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');

	Template.Rewards.AddItem('Reward_SuperiorPCS');

	return Template;
}

//---------------------------------------------------------------------------------------
// GAIN FACILITY LEAD
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateGainFacilityLeadTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_FacilityLead');

	Template.ChooseLocationFn = ChooseAdventFacilityRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";
	Template.RequiredFactionInfluence = eFactionInfluence_Respected;
	Template.bUnique = true;

	Template.Narratives.AddItem('CovertActionNarrative_FacilityLead_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_FacilityLead_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_FacilityLead_Templars');

	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot', 3));
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot', 3));
	Template.OptionalCosts.AddItem(CreateOptionalCostSlot('Supplies', 25));

	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');
	Template.Risks.AddItem('CovertActionRisk_SoldierCaptured');
	Template.Risks.AddItem('CovertActionRisk_Ambush');

	Template.Rewards.AddItem('Reward_FacilityLead');

	return Template;
}

//---------------------------------------------------------------------------------------
// GAIN ALIEN LOOT
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateGainAlienLootTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_AlienLoot');

	Template.ChooseLocationFn = ChooseRandomRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";

	Template.Narratives.AddItem('CovertActionNarrative_AlienLoot_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_AlienLoot_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_AlienLoot_Templars');

	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot', 3));
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot'));
	Template.OptionalCosts.AddItem(CreateOptionalCostSlot('Intel', 25));

	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');
	Template.Risks.AddItem('CovertActionRisk_SoldierCaptured');
	Template.Risks.AddItem('CovertActionRisk_Ambush');

	Template.Rewards.AddItem('Reward_AlienLoot');

	return Template;
}

//---------------------------------------------------------------------------------------
// DEFAULT SLOTS
//---------------------------------------------------------------------------------------

private static function CovertActionSlot CreateDefaultSoldierSlot(name SlotName, optional int iMinRank, optional bool bRandomClass, optional bool bFactionClass)
{
	local CovertActionSlot SoldierSlot;

	SoldierSlot.StaffSlot = SlotName;
	SoldierSlot.Rewards.AddItem('Reward_StatBoostHP');
	SoldierSlot.Rewards.AddItem('Reward_StatBoostAim');
	SoldierSlot.Rewards.AddItem('Reward_StatBoostMobility');
	SoldierSlot.Rewards.AddItem('Reward_StatBoostDodge');
	SoldierSlot.Rewards.AddItem('Reward_StatBoostWill');
	SoldierSlot.Rewards.AddItem('Reward_StatBoostHacking');
	SoldierSlot.Rewards.AddItem('Reward_RankUp');
	SoldierSlot.iMinRank = iMinRank;
	SoldierSlot.bChanceFame = false;
	SoldierSlot.bRandomClass = bRandomClass;
	SoldierSlot.bFactionClass = bFactionClass;

	if (SlotName == 'CovertActionRookieStaffSlot')
	{
		SoldierSlot.bChanceFame = false;
	}

	return SoldierSlot;
}

private static function CovertActionSlot CreateDefaultStaffSlot(name SlotName)
{
	local CovertActionSlot StaffSlot;
	
	// Same as Soldier Slot, but no rewards
	StaffSlot.StaffSlot = SlotName;
	StaffSlot.bReduceRisk = false;
	
	return StaffSlot;
}

private static function CovertActionSlot CreateDefaultOptionalSlot(name SlotName, optional int iMinRank, optional bool bFactionClass)
{
	local CovertActionSlot OptionalSlot;

	OptionalSlot.StaffSlot = SlotName;
	OptionalSlot.bChanceFame = false;
	OptionalSlot.bReduceRisk = true;
	OptionalSlot.iMinRank = iMinRank;
	OptionalSlot.bFactionClass = bFactionClass;

	return OptionalSlot;
}

private static function StrategyCostReward CreateOptionalCostSlot(name ResourceName, int Quantity)
{
	local StrategyCostReward ActionCost;
	local ArtifactCost Resources;

	Resources.ItemTemplateName = ResourceName;
	Resources.Quantity = Quantity;
	ActionCost.Cost.ResourceCosts.AddItem(Resources);
	ActionCost.Reward = 'Reward_DecreaseRisk';
	
	return ActionCost;
}

//---------------------------------------------------------------------------------------
// GENERIC DELEGATES
//---------------------------------------------------------------------------------------

static function ChooseRandomRegion(XComGameState NewGameState, XComGameState_CovertAction ActionState, out array<StateObjectReference> ExcludeLocations)
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;
	local array<StateObjectReference> RegionRefs;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		if (ExcludeLocations.Find('ObjectID', RegionState.GetReference().ObjectID) == INDEX_NONE)
		{
			RegionRefs.AddItem(RegionState.GetReference());
		}		
	}

	ActionState.LocationEntity = RegionRefs[`SYNC_RAND_STATIC(RegionRefs.Length)];
}

static function ChooseRandomContactedRegion(XComGameState NewGameState, XComGameState_CovertAction ActionState, out array<StateObjectReference> ExcludeLocations)
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;
	local array<StateObjectReference> RegionRefs;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		if (ExcludeLocations.Find('ObjectID', RegionState.GetReference().ObjectID) == INDEX_NONE && RegionState.HaveMadeContact())
		{
			RegionRefs.AddItem(RegionState.GetReference());
		}
	}

	ActionState.LocationEntity = RegionRefs[`SYNC_RAND_STATIC(RegionRefs.Length)];
}

static function ChooseAdventFacilityRegion(XComGameState NewGameState, XComGameState_CovertAction ActionState, out array<StateObjectReference> ExcludeLocations)
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;
	local array<StateObjectReference> RegionRefs;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		if (ExcludeLocations.Find('ObjectID', RegionState.GetReference().ObjectID) == INDEX_NONE && RegionState.AlienFacility.ObjectID != 0)
		{
			RegionRefs.AddItem(RegionState.GetReference());
		}
	}

	ActionState.LocationEntity = RegionRefs[`SYNC_RAND_STATIC(RegionRefs.Length)];
}

static function ChooseFactionRegion(XComGameState NewGameState, XComGameState_CovertAction ActionState, out array<StateObjectReference> ExcludeLocations)
{
	ActionState.LocationEntity = ActionState.GetFaction().HomeRegion;
}

static function ChooseRivalChosenHomeRegion(XComGameState NewGameState, XComGameState_CovertAction ActionState, out array<StateObjectReference> ExcludeLocations)
{
	ActionState.LocationEntity = ActionState.GetFaction().GetRivalChosen().HomeRegion;
}

static function ChooseRivalChosenHomeContinentRegion(XComGameState NewGameState, XComGameState_CovertAction ActionState, out array<StateObjectReference> ExcludeLocations)
{
	local XComGameState_Continent ContinentState;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_AdventChosen ChosenState;
	local array<StateObjectReference> ValidRegionRefs;
	local StateObjectReference RegionRef;
	
	ChosenState = ActionState.GetFaction().GetRivalChosen();
	RegionState = ChosenState.GetHomeRegion();

	if (RegionState != none)
	{
		ContinentState = RegionState.GetContinent();
		ValidRegionRefs.Length = 0;

		foreach ContinentState.Regions(RegionRef)
		{
			if(ChosenState.TerritoryRegions.Find('ObjectID', RegionRef.ObjectID) != INDEX_NONE)
			{
				ValidRegionRefs.AddItem(RegionRef);
			}
		}

		if(ValidRegionRefs.Length > 0)
		{
			ActionState.LocationEntity = ValidRegionRefs[`SYNC_RAND_STATIC(ValidRegionRefs.Length)];
		}
		else
		{
		ActionState.LocationEntity = ContinentState.Regions[`SYNC_RAND_STATIC(ContinentState.Regions.Length)];
	}
	}
	else
	{
		ActionState.LocationEntity = ChosenState.HomeRegion;
	}
}

static function ChooseRandomRivalChosenRegion(XComGameState NewGameState, XComGameState_CovertAction ActionState, out array<StateObjectReference> ExcludeLocations)
{
	local XComGameState_AdventChosen ChosenState;

	ChosenState = ActionState.GetFaction().GetRivalChosen();
	ActionState.LocationEntity = ChosenState.TerritoryRegions[`SYNC_RAND_STATIC(ChosenState.TerritoryRegions.Length)];
}