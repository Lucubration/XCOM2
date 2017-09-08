//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_City.uc
//  AUTHOR:  Ryan McFall  --  02/18/2014
//  PURPOSE: This object represents the instance data for a city within the strategy
//           game of X-Com 2. For more information on the design spec for cities, refer to
//           https://arcade/sites/2k/Studios/Firaxis/XCOM2/Shared%20Documents/World%20Map%20and%20Strategy%20AI.docx
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_City extends XComGameState_GeoscapeEntity native(Core)
	dependson(X2StrategyGameRulesetDataStructures);

var() protected name                   m_TemplateName;
var() protected X2CityTemplate         m_Template;

var string GeneratedName;

var localized string AdventCityPrefix;
var localized array<string> AdventCityNames;

static function X2StrategyElementTemplateManager GetMyTemplateManager()
{
	return class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
}

simulated function name GetMyTemplateName()
{
	return m_TemplateName;
}

simulated function X2CityTemplate GetMyTemplate()
{
	if (m_Template == none)
	{
		m_Template = X2CityTemplate(GetMyTemplateManager().FindStrategyElementTemplate(m_TemplateName));
	}
	return m_Template;
}

event OnCreation(optional X2DataTemplate Template)
{
	local Vector2D v2Loc;
	super.OnCreation( Template );

	m_Template = X2CityTemplate( Template );
	m_TemplateName = Template.DataName;

	Location = m_Template.Location;
	Location = class'XComEarth'.static.ConvertUVToWorld(Location);
	v2Loc = class'XComEarth'.static.ConvertWorldToEarth(Location);
	Location.X = v2Loc.X;
	Location.Y = v2Loc.Y;
}

static function SetUpCities(XComGameState StartState)
{
	local X2StrategyElementTemplateManager StratMgr;
	//local XComGameState_City CityState;
	local X2CityTemplate CityTemplate;
	local array<X2StrategyElementTemplate> AllTemplates;
	local X2StrategyElementTemplate StratTemplate;

	StratMgr = GetMyTemplateManager();
	AllTemplates = StratMgr.GetAllTemplatesOfClass(class'X2CityTemplate');

	foreach AllTemplates(StratTemplate)
	{
		CityTemplate = X2CityTemplate(StratTemplate);
		CityTemplate.CreateInstanceFromTemplate(StartState);
	}
}

function string GetDisplayName()
{
	if(GetMyTemplate().bAdventMadeCity)
	{
		return GeneratedName;
	}

	return GetMyTemplate().DisplayName;
}

function GenerateName(int RandomNumber)
{
	local string CityNumber;

	CityNumber = string(RandomNumber);

	if(RandomNumber < 10)
	{
		CityNumber = "0" $ CityNumber;
	}

	GeneratedName = AdventCityPrefix @ AdventCityNames[`SYNC_RAND(AdventCityNames.Length)] @ CityNumber;
}

//#############################################################################################
//----------------   Geoscape Entity Implementation   -----------------------------------------
//#############################################################################################

function class<UIStrategyMapItem> GetUIClass()
{
	return class'UIStrategyMapItem_City';
}

function string GetUIWidgetFlashLibraryName()
{
	return "MI_outpost";
}

function string GetUIPinImagePath()
{
	return "";
}

protected function bool CanInteract()
{
	return false;
}

function bool ShouldBeVisible()
{
	return false;
}

//---------------------------------------------------------------------------------------
DefaultProperties
{    
}
