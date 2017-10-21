//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DLC_Day60Rewards.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_DLC_Day60Rewards extends X2StrategyElement
	dependson(X2RewardTemplate)
	config(GameData);

var config array<name> StartingHunterWeapons;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Rewards;

	Rewards.AddItem(CreateHunterWeaponsRewardTemplate());
	Rewards.AddItem(CreateAlienNestMissionRewardTemplate());

	return Rewards;
}

// #######################################################################################
// -------------------- ITEM REWARDS --------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateHunterWeaponsRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_HunterWeapons');

	Template.GiveRewardFn = GiveHunterWeaponsReward;
	Template.GetRewardStringFn = GetHunterWeaponsRewardString;
	
	return Template;
}

static function string GetHunterWeaponsRewardString(XComGameState_Reward RewardState)
{
	return RewardState.GetMyTemplate().DisplayName;
}

static function GiveHunterWeaponsReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Item ItemState;
	local X2ItemTemplateManager ItemMgr;
	local X2ItemTemplate ItemTemplate;
	local name HunterWeaponName;
	local int idx;

	History = `XCOMHISTORY;
	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	//Add the armor items to the HQ's inventory so that the player can select them
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));

	for (idx = 0; idx < default.StartingHunterWeapons.Length; idx++)
	{
		HunterWeaponName = default.StartingHunterWeapons[idx];
		if (!XComHQ.HasItemByName(HunterWeaponName))
		{
			ItemTemplate = ItemMgr.FindItemTemplate(HunterWeaponName);

			if (ItemTemplate != none)
			{
				//This is a starting item so it needs to be added
				ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
				XComHQ.AddItemToHQInventory(ItemState);
			}
		}
	}
}

// #######################################################################################
// -------------------- MISSION REWARDS --------------------------------------------------
// #######################################################################################
static function X2DataTemplate CreateAlienNestMissionRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_AlienNest');

	Template.GiveRewardFn = GiveAlienNestReward;
	Template.GetRewardStringFn = GetMissionRewardString;
	Template.RewardPopupFn = MissionRewardPopup;

	return Template;
}

static function string GetMissionRewardString(XComGameState_Reward RewardState)
{
	return RewardState.GetMyTemplate().DisplayName;
}

static function GiveAlienNestReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameState_MissionSiteAlienNest MissionState;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_Reward MissionRewardState;
	local X2RewardTemplate RewardTemplate;
	local X2StrategyElementTemplateManager StratMgr;
	local X2MissionSourceTemplate MissionSource;
	local array<XComGameState_Reward> MissionRewards;

	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	RegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(AuxRef.ObjectID));

	MissionRewards.Length = 0;
	RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_None'));
	MissionRewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
	MissionRewards.AddItem(MissionRewardState);

	MissionState = XComGameState_MissionSiteAlienNest(NewGameState.CreateNewStateObject(class'XComGameState_MissionSiteAlienNest'));
	MissionSource = X2MissionSourceTemplate(StratMgr.FindStrategyElementTemplate('MissionSource_AlienNest'));
	MissionState.BuildMission(MissionSource, RegionState.GetRandom2DLocationInRegion(), RegionState.GetReference(), MissionRewards);

	RewardState.RewardObjectReference = MissionState.GetReference();
}

static function MissionRewardPopup(XComGameState_Reward RewardState)
{
	local XComGameState_MissionSite MissionSite;

	MissionSite = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	if (MissionSite != none && MissionSite.GetMissionSource().MissionPopupFn != none)
	{
		MissionSite.GetMissionSource().MissionPopupFn(MissionSite);
	}
}