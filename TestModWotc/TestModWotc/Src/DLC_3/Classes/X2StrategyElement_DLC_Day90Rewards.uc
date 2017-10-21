//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DLC_Day90Rewards.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_DLC_Day90Rewards extends X2StrategyElement
	dependson(X2RewardTemplate)
	config(GameData);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Rewards;

	Rewards.AddItem(CreateLostTowersMissionRewardTemplate());

	return Rewards;
}

// #######################################################################################
// -------------------- MISSION REWARDS --------------------------------------------------
// #######################################################################################
static function X2DataTemplate CreateLostTowersMissionRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_LostTowers');

	Template.GiveRewardFn = GiveLostTowersReward;
	Template.GetRewardStringFn = GetMissionRewardString;
	Template.RewardPopupFn = MissionRewardPopup;

	return Template;
}

static function string GetMissionRewardString(XComGameState_Reward RewardState)
{
	return RewardState.GetMyTemplate().DisplayName;
}

static function GiveLostTowersReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameState_MissionSiteLostTowers MissionState;
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

	MissionState = XComGameState_MissionSiteLostTowers(NewGameState.CreateNewStateObject(class'XComGameState_MissionSiteLostTowers'));
	MissionSource = X2MissionSourceTemplate(StratMgr.FindStrategyElementTemplate('MissionSource_LostTowers'));
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