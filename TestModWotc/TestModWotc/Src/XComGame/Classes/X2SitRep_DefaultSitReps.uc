//---------------------------------------------------------------------------------------
//  FILE:    X2SitRep_DefaultSitReps.uc
//  AUTHOR:  David Burchanowski  --  8/5/2016
//  PURPOSE: Defines the default set of sitrep templates.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2SitRep_DefaultSitReps extends X2SitRep config(GameData);

var config array<name> SitReps;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	local X2SitRepTemplate Template;
	local name SitRepName;

	foreach default.SitReps(SitRepName)
	{
		`CREATE_X2TEMPLATE(class'X2SitRepTemplate', Template, SitRepName);
		ModifySitrepTemplate(Template);
		Templates.AddItem(Template);
	}

	return Templates;
}

static function ModifySitrepTemplate(out X2SitRepTemplate Template)
{
	switch (Template.DataName)
	{
	case 'LowProfile':
		ModifyLowProfileSitrepTemplate(Template);
		break;
	case 'StealthInsertion':
		ModifyStealthInsertionSitrepTemplate(Template);
		break;
	default:
		break;
	}
}

static function ModifyLowProfileSitrepTemplate(out X2SitRepTemplate Template)
{
	Template.StrategyReqs.SpecialRequirementsFn = IsLowProfileSitrepAvailable;
}

static function bool IsLowProfileSitrepAvailable()
{
	local XComGameState_HeadquartersXCom XComHQ;
	local array<XComGameState_Unit> AvailableLowProfileSoldiers;
	
	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	AvailableLowProfileSoldiers = XComHQ.GetDeployableSoldiers(false, false, -1, 3);

	return (AvailableLowProfileSoldiers.Length > 0);
}

static function ModifyStealthInsertionSitrepTemplate(out X2SitRepTemplate Template)
{
	Template.StrategyReqs.SpecialRequirementsFn = IsStealthInsertionSitrepAvailable;
}

static function bool IsStealthInsertionSitrepAvailable()
{
	local XComGameState_HeadquartersAlien AlienHQ;

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	return !AlienHQ.IsDarkEventActive('DarkEvent_HighAlert');
}