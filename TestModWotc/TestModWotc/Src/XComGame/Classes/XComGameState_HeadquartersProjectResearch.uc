
//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_HeadquartersProjectResearch.uc
//  AUTHOR:  Mark Nauta  --  04/17/2014
//  PURPOSE: This object represents the instance data for an XCom HQ research project
//           Will eventually be a component
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_HeadquartersProjectResearch extends XComGameState_HeadquartersProject native(Core);

var bool bShadowProject;
var bool bProvingGroundProject;
var bool bForcePaused;
var bool bIgnoreScienceScore;

//---------------------------------------------------------------------------------------
// Call when you start a new project
function SetProjectFocus(StateObjectReference FocusRef, optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	local XComGameStateHistory History;
	local XComGameState_Tech Tech;

	History = `XCOMHISTORY;

	ProjectFocus = FocusRef;
	AuxilaryReference = AuxRef;
	Tech = XComGameState_Tech(History.GetGameStateForObjectID(FocusRef.ObjectID));

	if (Tech.GetMyTemplate().bShadowProject)
	{
		bShadowProject = true;
	}
	if (Tech.GetMyTemplate().bProvingGround)
	{
		bProvingGroundProject = true;
	}
	bInstant = Tech.IsInstant();
	
	if (Tech.bBreakthrough) // If this tech is a breakthrough, duration is not modified by science score
	{
		bIgnoreScienceScore = true;
	}

	UpdateWorkPerHour();
	InitialProjectPoints = Tech.GetProjectPoints(WorkPerHour);
	ProjectPointsRemaining = InitialProjectPoints;
	StartDateTime = `STRATEGYRULES.GameTime;
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
function int CalculateWorkPerHour(optional XComGameState StartState = none, optional bool bAssumeActive = false)
{
	local XComGameStateHistory History;
	local int iTotalResearch;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersResistance ResHQ;
	local XComGameState_Tech TechState;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	if(bShadowProject)
	{
		if(bForcePaused && !bAssumeActive)
		{
			return 0;
		}

		iTotalResearch = XComHQ.GetScienceScore(true); // +XComHQ.GetEngineeringScore(true);

		if (iTotalResearch == 0)
		{
			return 0;
		}
		
		return iTotalResearch;
	}
	else
	{
		// Can't make progress when paused or while shadow project is active or paused
		if ((XComHQ.HasActiveShadowProject() || bForcePaused) && !bAssumeActive)
		{
			return 0;
		}
				
		if (bIgnoreScienceScore)
		{
			iTotalResearch = 5; // Research defaults to a base level of one scientist
		}
		else
		{
			iTotalResearch = XComHQ.GetScienceScore(true);
		}
		
		if (iTotalResearch == 0)
		{
			return 0;
		}
		else
		{
			// Check for Higher Learning
			iTotalResearch += Round(float(iTotalResearch) * (float(XComHQ.ResearchEffectivenessPercentIncrease) / 100.0));

			TechState = XComGameState_Tech(History.GetGameStateForObjectID(ProjectFocus.ObjectID));
			ResHQ = XComGameState_HeadquartersResistance(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));

			// Check for Res Order bonuses
			if(TechState.IsWeaponTech() && ResHQ.WeaponsResearchScalar > 0)
			{
				iTotalResearch = Round(float(iTotalResearch) * ResHQ.WeaponsResearchScalar);
			}
			else if(TechState.IsArmorTech() && ResHQ.ArmorResearchScalar > 0)
			{
				iTotalResearch = Round(float(iTotalResearch) * ResHQ.ArmorResearchScalar);
			}
		}

		return iTotalResearch;
	}
}

//---------------------------------------------------------------------------------------
// Add the tech to XComs list of completed research, and call any OnResearched methods for the tech
function OnProjectCompleted()
{
	local XComGameState_Tech TechState;
	local HeadquartersOrderInputContext OrderInput;
	local StateObjectReference TechRef;
	local X2ItemTemplate ItemTemplate;

	TechRef = ProjectFocus;

	OrderInput.OrderType = eHeadquartersOrderType_ResearchCompleted;
	OrderInput.AcquireObjectReference = ProjectFocus;

	class'XComGameStateContext_HeadquartersOrder'.static.IssueHeadquartersOrder(OrderInput);

	`GAME.GetGeoscape().Pause();

	if (bProvingGroundProject)
	{
		TechState = XComGameState_Tech(`XCOMHISTORY.GetGameStateForObjectID(TechRef.ObjectID));

		// If the Proving Ground project rewards an item, display all the project popups on the Geoscape
		if (TechState.ItemRewards.Length > 0)
		{
			TechState.DisplayTechCompletePopups();

			foreach TechState.ItemRewards(ItemTemplate)
			{
				`HQPRES.UIProvingGroundItemReceived(ItemTemplate, TechRef);
			}
		}
		else // Otherwise give the normal project complete popup
		{
			`HQPRES.UIProvingGroundProjectComplete(TechRef);
		}
	}
	else if(bInstant)
	{
		TechState = XComGameState_Tech(`XCOMHISTORY.GetGameStateForObjectID(TechRef.ObjectID));
		TechState.DisplayTechCompletePopups();

		`HQPRES.ResearchReportPopup(TechRef);
	}
	else
	{
		`HQPRES.UIResearchComplete(TechRef);
	}
}

//---------------------------------------------------------------------------------------
function RushResearch(XComGameState NewGameState)
{
	local XComGameState_Tech TechState;

	TechState = XComGameState_Tech(NewGameState.GetGameStateForObjectID(ProjectFocus.ObjectID));

	UpdateProjectPointsRemaining(GetCurrentWorkPerHour());
	ProjectPointsRemaining -= Round(float(ProjectPointsRemaining) * TechState.TimeReductionScalar);
	ProjectPointsRemaining = Clamp(ProjectPointsRemaining, 0, InitialProjectPoints);

	StartDateTime = `STRATEGYRULES.GameTime;
	if(MakingProgress())
	{
		SetProjectedCompletionDateTime(StartDateTime);
	}
}

//---------------------------------------------------------------------------------------
function AddResearchDays(int NumDays)
{
	local int PointsToAdd;

	PointsToAdd = CalculateWorkPerHour(, true);
	PointsToAdd *= (NumDays * 24);

	ProjectPointsRemaining += PointsToAdd;

	StartDateTime = `STRATEGYRULES.GameTime;
	if(MakingProgress())
	{
		SetProjectedCompletionDateTime(StartDateTime);
	}
}

//---------------------------------------------------------------------------------------
DefaultProperties
{
}
