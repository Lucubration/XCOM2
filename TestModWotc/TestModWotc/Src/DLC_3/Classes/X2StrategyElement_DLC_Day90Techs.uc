//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DLC_Day90Techs.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_DLC_Day90Techs extends X2StrategyElement;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Techs;

	// Spark Techs
	Techs.AddItem(CreateMechanizedWarfareTemplate());
	Techs.AddItem(CreateBuildSparkTemplate());
	
	return Techs;
}

//---------------------------------------------------------------------------------------
// Helper function for calculating project time
static function int StafferXDays(int iNumScientists, int iNumDays)
{
	return (iNumScientists * 5) * (24 * iNumDays); // Scientists at base skill level
}

static function X2DataTemplate CreateMechanizedWarfareTemplate()
{
	local X2TechTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'MechanizedWarfare');
	Template.PointsToComplete = StafferXDays(1, 10);
	Template.strImage = "img:///UILibrary_DLC3Images.TECH_Spark";
	Template.SortingTier = 1;

	Template.bProvingGround = true;
	Template.ResearchCompletedFn = CreateSparkSoldierAndEquipment;

	// Non-Narrative Requirements
	Template.Requirements.SpecialRequirementsFn = IsMechanizedWarfareAvailable;
	
	return Template;
}

static function bool IsMechanizedWarfareAvailable()
{
	local XComGameState_CampaignSettings CampaignSettings;
	
	CampaignSettings = XComGameState_CampaignSettings(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));

	if (CampaignSettings.HasIntegratedDLCEnabled())
	{
		return false; // Mechanized Warfare is not displayed if XPack Integration is turned on
	}

	// Otherwise check if the narrative has been disabled
	return (!CampaignSettings.HasOptionalNarrativeDLCEnabled(name(class'X2DownloadableContentInfo_DLC_Day90'.default.DLCIdentifier)));
}

static function X2DataTemplate CreateBuildSparkTemplate()
{
	local X2TechTemplate Template;
	local StrategyRequirement AltReq;
	local ArtifactCost Artifacts;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'BuildSpark');
	Template.PointsToComplete = StafferXDays(1, 14);
	Template.SortingTier = 1;
	Template.strImage = "img:///UILibrary_DLC3Images.TECH_Spark";

	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.ResearchCompletedFn = CreateSparkSoldier;
	
	// Narrative Requirements
	Template.Requirements.SpecialRequirementsFn = class'X2Helpers_DLC_Day90'.static.IsLostTowersNarrativeContentComplete;

	// Non Narrative Requirements
	AltReq.RequiredTechs.AddItem('MechanizedWarfare');
	Template.AlternateRequirements.AddItem(AltReq);
	
	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 100;
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 20;
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	Artifacts.ItemTemplateName = 'EleriumCore';
	Artifacts.Quantity = 2;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	return Template;
}

static function CreateSparkSoldierAndEquipment(XComGameState NewGameState, XComGameState_Tech TechState)
{	
	class'X2Helpers_DLC_Day90'.static.CreateSparkEquipment(NewGameState);
	CreateSparkSoldier(NewGameState, TechState);
}

static function CreateSparkSoldier(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_FacilityXCom FacilityState;
	local XComGameState_CampaignSettings CampaignSettings;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	CampaignSettings = XComGameState_CampaignSettings(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));

	if (CampaignSettings.HasIntegratedDLCEnabled() && XComHQ.IsTechResearched('BuildSpark'))
	{
		// The first time a Spark is built in DLC Integrated XPack games, create the necessary Spark gear for XComHQ
		class'X2Helpers_DLC_Day90'.static.CreateSparkEquipment(NewGameState);
	}

	class'X2Helpers_DLC_Day90'.static.CreateSparkSoldier(NewGameState, , TechState);

	FacilityState = XComHQ.GetFacilityByName('Storage');
	if (FacilityState != none && FacilityState.GetNumLockedStaffSlots() > 0)
	{
		// Unlock the Repair SPARK staff slot in Engineering
		FacilityState.UnlockStaffSlot(NewGameState);
	}
}