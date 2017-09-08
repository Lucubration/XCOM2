//---------------------------------------------------------------------------------------
//  FILE:    X2RewardTemplate.uc
//  AUTHOR:  Mark Nauta
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2RewardTemplate extends X2StrategyElementTemplate;

var localized String    DisplayName;
var localized String	RewardDetails;
var localized String    RewardDescriptions[5];
var name				rewardObjectTemplateName;
var string				RewardImage;
var bool				bResourceReward;

var Delegate<IsRewardAvailableDelegate> IsRewardAvailableFn; // allows logical augmentation of reward availability. For example, rescue rewards are only available if there are captured soldiers
var Delegate<IsRewardNeededDelegate> IsRewardNeededFn; // allows logical augmentation of reward availability. Used to indicate if the player desperately needs this resource
var Delegate<GenerateRewardDelegate> GenerateRewardFn;
var Delegate<SetRewardDelegate> SetRewardFn;
var Delegate<GiveRewardDelegate> GiveRewardFn;
var Delegate<GetRewardStringDelegate> GetRewardStringFn;
var Delegate<GetRewardPreviewStringDelegate> GetRewardPreviewStringFn;
var Delegate<GetRewardDetailsStringDelegate> GetRewardDetailsStringFn;
var Delegate<GetRewardImageDelegate> GetRewardImageFn;
var Delegate<SetRewardByTemplateDelegate> SetRewardByTemplateFn;
var Delegate<GetBlackMarketStringDelegate> GetBlackMarketStringFn;
var Delegate<GetRewardIconDelegate> GetRewardIconFn;
var Delegate<CleanUpRewardDelegate> CleanUpRewardFn;
var Delegate<RewardPopupDelegate> RewardPopupFn;

delegate bool IsRewardAvailableDelegate(optional XComGameState NewGameState, optional StateObjectReference AuxRef);
delegate bool IsRewardNeededDelegate();
delegate GenerateRewardDelegate(XComGameState_Reward RewardState, XComGameState NewGameState, optional float RewardScalar=1.0, optional StateObjectReference AuxRef);
delegate SetRewardDelegate(XComGameState_Reward RewardState, optional StateObjectReference RewardObjectRef, optional int Amount);
delegate GiveRewardDelegate(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder=false, optional int OrderHours=-1);
delegate string GetRewardStringDelegate(XComGameState_Reward RewardState);
delegate string GetRewardPreviewStringDelegate(XComGameState_Reward RewardState);
delegate string GetRewardDetailsStringDelegate(XComGameState_Reward RewardState);
delegate string GetRewardImageDelegate(XComGameState_Reward RewardState);
delegate SetRewardByTemplateDelegate(XComGameState_Reward RewardState, name TemplateName);
delegate string GetBlackMarketStringDelegate(XComGameState_Reward RewardState);
delegate string GetRewardIconDelegate(XComGameState_Reward RewardState);
delegate CleanUpRewardDelegate(XComGameState NewGameState, XComGameState_Reward RewardState);
delegate RewardPopupDelegate(XComGameState_Reward RewardState);

function XComGameState_Reward CreateInstanceFromTemplate(XComGameState NewGameState)
{
	local XComGameState_Reward RewardState;

	RewardState = XComGameState_Reward(NewGameState.CreateNewStateObject(class'XComGameState_Reward', self));

	return RewardState;
}

//---------------------------------------------------------------------------------------
DefaultProperties
{
}