//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Reward.uc
//  AUTHOR:  Mark Nauta  --  09/02/2014
//  PURPOSE: This object represents the instance data for a strategy reward
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_Reward extends XComGameState_BaseObject 
	native(Core);

var() protected name                   m_TemplateName;
var() protected X2RewardTemplate       m_Template;

// State vars
var StateObjectReference RewardObjectReference;     // Reference to Unit or Item to be rewarded
var int                  Quantity;      // Amount of resource to be given
var name				 RewardObjectTemplateName; // For rewards that don't have a state object and are defined by a template (Haven Op)
var string				 RewardString;	// For rewards that give multiple items and need to create their string as they are given (Loot Table)


//#############################################################################################
//----------------   INITIALIZATION   ---------------------------------------------------------
//#############################################################################################

//---------------------------------------------------------------------------------------
static function X2StrategyElementTemplateManager GetMyTemplateManager()
{
	return class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
}

//---------------------------------------------------------------------------------------
simulated function name GetMyTemplateName()
{
	return m_TemplateName;
}

//---------------------------------------------------------------------------------------
simulated function X2RewardTemplate GetMyTemplate()
{
	if (m_Template == none)
	{
		m_Template = X2RewardTemplate(GetMyTemplateManager().FindStrategyElementTemplate(m_TemplateName));
	}
	return m_Template;
}

//---------------------------------------------------------------------------------------
event OnCreation(optional X2DataTemplate Template)
{
	super.OnCreation(Template);

	m_Template = X2RewardTemplate(Template);
	m_TemplateName = Template.DataName;
}

//#############################################################################################
//----------------   REWARD GENERATION   ------------------------------------------------------
//#############################################################################################

//---------------------------------------------------------------------------------------
function GenerateReward(XComGameState NewGameState, optional float RewardScalar=1.0, optional StateObjectReference RegionRef)
{
	if(GetMyTemplate().GenerateRewardFn != none)
	{
		GetMyTemplate().GenerateRewardFn(self, NewGameState, RewardScalar, RegionRef);
	}
}

//---------------------------------------------------------------------------------------
// For manually setting rewards (reward generation used mostly for missions)
function SetReward(optional StateObjectReference RewardObjectRef, optional int Amount)
{
	if(GetMyTemplate().SetRewardFn != none)
	{
		GetMyTemplate().SetRewardFn(self, RewardObjectRef, Amount);
	}
}

//---------------------------------------------------------------------------------------
function SetRewardByTemplate(name TemplateName)
{
	if(GetMyTemplate().SetRewardByTemplateFn != none)
	{
		GetMyTemplate().SetRewardByTemplateFn(self, TemplateName);
	}
}

//#############################################################################################
//----------------   GIVE REWARDS   -----------------------------------------------------------
//#############################################################################################

//---------------------------------------------------------------------------------------
function GiveReward(XComGameState NewGameState, optional StateObjectReference AuxRef, optional bool bOrder=false, optional int OrderHours=-1)
{
	if(GetMyTemplate().GiveRewardFn != none)
	{
		GetMyTemplate().GiveRewardFn(NewGameState, self, AuxRef, bOrder, OrderHours);
	}
	
	// The reward state is always removed after giving the reward
	NewGameState.RemoveStateObject(ObjectID);
}

//#############################################################################################
//----------------   HELPER FUNCTIONS   -------------------------------------------------------
//#############################################################################################

//---------------------------------------------------------------------------------------
function string GetRewardString()
{
	if(GetMyTemplate().GetRewardStringFn != none)
	{
		return GetMyTemplate().GetRewardStringFn(self);
	}
	else
	{
		return GetMyTemplate().DisplayName;
	}
}

//---------------------------------------------------------------------------------------
function string GetRewardPreviewString()
{
	if (GetMyTemplate().GetRewardPreviewStringFn != none)
	{
		return GetMyTemplate().GetRewardPreviewStringFn(self);
	}
	else
	{
		return GetMyTemplate().DisplayName;
	}
}

//---------------------------------------------------------------------------------------
function string GetRewardDetailsString()
{
	if (GetMyTemplate().GetRewardDetailsStringFn != none)
	{
		return GetMyTemplate().GetRewardDetailsStringFn(self);
	}
	else
	{
		return GetMyTemplate().RewardDetails;
	}
}

//---------------------------------------------------------------------------------------
function string GetRewardImage()
{
	if (GetMyTemplate().GetRewardImageFn != none)
	{
		return GetMyTemplate().GetRewardImageFn(self);
	}

	return "";
}

//---------------------------------------------------------------------------------------
function string GetBlackMarketString()
{
	if(GetMyTemplate().GetBlackMarketStringFn != none)
	{
		return GetMyTemplate().GetBlackMarketStringFn(self);
	}

	return "";
}

//---------------------------------------------------------------------------------------
function string GetRewardIcon()
{
	if(GetMyTemplate().GetRewardIconFn != none)
	{
		return GetMyTemplate().GetRewardIconFn(self);
	}

	return "";
}

//---------------------------------------------------------------------------------------
function DisplayRewardPopup()
{
	if (GetMyTemplate().RewardPopupFn != none)
	{
		GetMyTemplate().RewardPopupFn(self);
	}
}

//---------------------------------------------------------------------------------------
function CleanUpReward(XComGameState NewGameState)
{
	// First perform any reward-specific cleanup tasks
	if (GetMyTemplate().CleanUpRewardFn != none)
	{
		GetMyTemplate().CleanUpRewardFn(NewGameState, self);
	}
	else if(RewardObjectReference.ObjectID != 0)
	{
		NewGameState.RemoveStateObject(RewardObjectReference.ObjectID);
	}
	
	// Remove the actual reward state
	NewGameState.RemoveStateObject(ObjectID);
}

//---------------------------------------------------------------------------------------
function bool IsResourceReward()
{
	return GetMyTemplate().bResourceReward;
}

//---------------------------------------------------------------------------------------
function ScaleRewardQuantity(float ScaleValue)
{
	Quantity = Round(float(Quantity) * ScaleValue);
}

//---------------------------------------------------------------------------------------
DefaultProperties
{
}