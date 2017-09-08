//----------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIResearchArchives.uc
//  AUTHOR:  Brit Steiner 
//  PURPOSE: Screen that allows the player to review tech research already completed. 
//----------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//----------------------------------------------------------------------------

class UIResearchArchives extends UIChooseResearch;

var localized string m_strViewReport;

//----------------------------------------------------------------------------
simulated function OnPurchaseClicked(UIList kList, int itemIndex)
{
	local XComGameState_Tech TechState;

	TechState = XComGameState_Tech(`XCOMHISTORY.GetGameStateForObjectID(m_arrRefs[itemIndex].ObjectID));
	if (!TechState.GetMyTemplate().bBreakthrough) // Do not show research reports for breakthrough techs
	{
		`HQPRES.ResearchReportPopup(m_arrRefs[itemIndex]);
	}
}

//bsg-crobinson (5.30.17): Overload the selection change to update the navhelp as well
simulated function SelectedItemChanged(UIList ContainerList, int ItemIndex)
{
	RealizeNavHelp();
	super.SelectedItemChanged(ContainerList, ItemIndex);
}

simulated function RealizeNavHelp()
{
	local XComGameState_Tech TechState;
	local UINavigationHelp NavHelp;

	NavHelp = `HQPRES.m_kAvengerHUD.NavHelp;

	NavHelp.ClearButtonHelp();
	NavHelp.bIsVerticalHelp = `ISCONTROLLERACTIVE;
	NavHelp.AddBackButton(OnCancel);
	
	// Grab the current list item and check if it's a breakthrough, if it is don't show the select button
	TechState = XComGameState_Tech(History.GetGameStateForObjectID(XComHQ.TechsResearched[List.SelectedIndex].ObjectID));

	if(!TechState.bBreakthrough)
		NavHelp.AddSelectNavHelp();
}

simulated function OnLoseFocus()
{
	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
	super.OnLoseFocus();
}

simulated function OnReceiveFocus()
{
	super.OnReceiveFocus();
	RealizeNavHelp();
}
//bsg-crobinson (5.30.17): end

simulated function array<StateObjectReference> GetTechs() 
{
	return class'UIUtilities_Strategy'.static.GetXComHQ().GetCompletedResearchTechs();
}

simulated function array<Commodity> ConvertTechsToCommodities()
{
	local XComGameState_Tech TechState;
	local X2TechTemplate TechTemplate;
	local int iTech;
	local array<Commodity> arrCommodoties;
	local Commodity TechComm;
	local StrategyCost EmptyCost;
	local StrategyRequirement EmptyReqs;
	local string TechSummary;

	m_arrRefs.Remove(0, m_arrRefs.Length);
	m_arrRefs = GetTechs();
	m_arrRefs.Sort(SortTechsAlpha);

	for (iTech = 0; iTech < m_arrRefs.Length; iTech++)
	{
		TechState = XComGameState_Tech(History.GetGameStateForObjectID(m_arrRefs[iTech].ObjectID));
		TechTemplate = TechState.GetMyTemplate();
		
		TechComm.Title = TechState.GetDisplayName();
		TechComm.Image = TechState.GetImage();
		
		TechSummary = TechState.GetSummary();
		if (TechTemplate.GetValueFn != none)
		{
			TechSummary = Repl(TechSummary, "%VALUE", TechTemplate.GetValueFn());
		}
		TechComm.Desc = TechSummary;
		
		TechComm.bTech = true;
		
		//We are reviewing these in the archives, so no cost or requirements should display here. 
		TechComm.Cost = EmptyCost;
		TechComm.OrderHours = -1;
		TechComm.Requirements = EmptyReqs;
		
		arrCommodoties.AddItem(TechComm);
	}

	return arrCommodoties;
}


simulated function String GetButtonString(int ItemIndex)
{
	local XComGameState_Tech TechState;

	TechState = XComGameState_Tech(`XCOMHISTORY.GetGameStateForObjectID(m_arrRefs[itemIndex].ObjectID));
	if (TechState.GetMyTemplate().bBreakthrough) // Do not show research reports for breakthrough techs
	{
		return "";
	}
	else
	{
		return m_strViewReport;
	}
}

simulated function bool ShouldShowGoodState(int ItemIndex)
{
	local XComGameState_Tech TechState;
	TechState = XComGameState_Tech(History.GetGameStateForObjectID(m_arrRefs[ItemIndex].ObjectID));
	return (TechState.bForceInstant || TechState.bInspired);
}

//==============================================================================

defaultproperties
{
	DisplayTag      = "UIBlueprint_Powercore";
	CameraTag       = "UIBlueprint_Powercore";

	m_bInfoOnly=true
	m_bShowButton=false
	m_eStyle = eUIConfirmButtonStyle_Default
}
