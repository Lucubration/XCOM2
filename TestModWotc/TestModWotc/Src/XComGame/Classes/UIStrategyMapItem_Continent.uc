//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIStrategyMapItem_Continent
//  AUTHOR:  Sam Batista -- 08/2014
//  PURPOSE: This file represents a landing spot on the StrategyMap.
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIStrategyMapItem_Continent extends UIStrategyMapItem;

var int m_iContinentLevel;

var public localized String m_strBonusAchieved;
var public localized String m_strBonusHelp;

var string tooltipHTML; 


simulated function UIStrategyMapItem InitMapItem(out XComGameState_GeoscapeEntity Entity)
{
	super.InitMapItem(Entity);
	return self;
}

function GenerateTooltip(string NewTooltipHTML)
{
	local String TooltipStr;

	tooltipHTML = NewTooltipHTML;
	TooltipStr = GetTooltipString(NewTooltipHTML);

	super.GenerateTooltip(TooltipStr);
	Movie.Pres.m_kTooltipMgr.TextTooltip.SetMouseDelegates(CachedTooltipID, UpdateTooltipText);
}

simulated function string GetTooltipHtmlString()
{
	return GetTooltipString(MapPin_Tooltip);
}


//This is called on mouse in triggering the tooltip. The status may have changed but not updated the item yet, 
//and so we need to rebuild the text each time. 
simulated function UpdateTooltipText( UIToolTip tooltip )
{
	UITextTooltip(tooltip).SetText(GetTooltipString(tooltipHTML));
}

function string GetTooltipString(string NewTooltipHTML)
{
	local String strBonusTT, strBonusSummary;
	local XComGameState_Continent ContinentState;
	local XComGameState_StrategyCard ContinentBonusCard;
	local XGParamTag ParamTag;
	
	ContinentState = XComGameState_Continent(`XCOMHISTORY.GetGameStateForObjectID(GeoscapeEntityRef.ObjectID));
	ContinentBonusCard = ContinentState.GetContinentBonusCard();

	strBonusSummary = ContinentBonusCard.GetSummaryText();

	// Tooltip about Continent bonus
	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = ContinentBonusCard.GetDisplayName();
	ParamTag.StrValue1 = strBonusSummary;

	if( ContinentState.bContinentBonusActive )
	{
		ParamTag.StrValue2 = m_strBonusAchieved;
		strBonusTT = `XEXPAND.ExpandString(NewTooltipHTML);
		strBonusTT = class'UIUtilities_Text'.static.GetColoredText(strBonusTT, eUIState_Good);
	}
	else
	{
		ParamTag.StrValue2 = m_strBonusHelp;
		strBonusTT = `XEXPAND.ExpandString(NewTooltipHTML);
		strBonusTT = class'UIUtilities_Text'.static.GetColoredText(strBonusTT, eUIState_Disabled);
	}

	return strBonusTT;
}

function UpdateFlyoverText()
{
	local XComGameState_Continent ContinentState;
	local XComGameState_StrategyCard ContinentBonusCard;
	local string Bonus; 
	local int CurrentRadioTowers, MaxRadioTowers;

	ContinentState = XComGameState_Continent(`XCOMHISTORY.GetGameStateForObjectID(GeoscapeEntityRef.ObjectID));
	ContinentBonusCard = ContinentState.GetContinentBonusCard();

	if( ContinentState.bContinentBonusActive )
		Bonus = class'UIUtilities_Text'.static.GetColoredText( ContinentBonusCard.GetDisplayName(), eUIState_Good );
	else 
		Bonus = class'UIUtilities_Text'.static.GetColoredText(ContinentBonusCard.GetDisplayName(), eUIState_Disabled);

	CurrentRadioTowers = ContinentState.GetNumRadioTowers();
	MaxRadioTowers = ContinentState.GetMaxRadioTowers();

	SetLabel(ContinentState.GetMyTemplate().DisplayName, Bonus);
	SetContinentLevel(ContinentState.GetResistanceLevel() - CurrentRadioTowers, 
					  ContinentState.GetMaxResistanceLevel() - MaxRadioTowers,
					 CurrentRadioTowers, 
					  MaxRadioTowers);
}

public function SetContinentLevel(int _level, int _max, int _numTowers, int _numTowersMax)
{
	m_iContinentLevel = _level;
	mc.BeginFunctionOp("SetContinentLevel");
	mc.QueueNumber(m_iContinentLevel);
	mc.QueueNumber(_max);
	mc.QueueNumber(_numTowers);
	mc.QueueNumber(_numTowersMax);
	mc.EndOp();
}

defaultproperties
{
	bDisableHitTestWhenZoomedOut = false;
	bFadeWhenZoomedOut = false;
	m_iContinentLevel = -1;
	bIsNavigable = false;
}