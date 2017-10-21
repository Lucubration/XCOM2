//---------------------------------------------------------------------------------------
//  FILE:    UIAlert_DLC_Day60.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class UIAlert_DLC_Day60 extends UIAlert;

enum EAlertType_DLC_Day60
{
	eAlert_HunterWeaponsAvailable,
	eAlert_HunterWeaponsScanningSite,
	eAlert_NestScanningSite,
	eAlert_HunterWeaponsScanComplete,
	eAlert_NestScanComplete,
	eAlert_RulerGuardingFacility,
};

var public localized string m_strHunterWeaponsAvailableTitle;
var public localized string m_strHunterWeaponsAvailableLabel;
var public localized string m_strHunterWeaponsAvailableBody;
var public localized string m_strHunterWeaponsAvailableGoToArmory;

var public localized string m_strHunterWeaponsPOIAvailableBody;
var public localized string m_strAlienNestPOIAvailableBody;

var public localized string m_strRulerGuardingFacilityTitle;
var public localized string m_strRulerGuardingFacilityLabel;
var public localized string m_strRulerGuardingFacilityImage;
var public localized string m_strRulerGuardingFacilityBody;

simulated function BuildAlert()
{
	BindLibraryItem();

	switch ( eAlertName )
	{
	case 'eAlert_HunterWeaponsAvailable':
		BuildHunterWeaponsAvailableAlert();
		break;
	case 'eAlert_HunterWeaponsScanningSite': // Hunter Weapons POI Available
		BuildHunterWeaponsPOIAvailableAlert();
		break;
	case 'eAlert_NestScanningSite': // Alien Nest POI Available
		BuildAlienNestPOIAvailableAlert();
		break;
	case 'eAlert_HunterWeaponsScanComplete': // Hunter Weapons POI Complete
		BuildWeaponsPOICompleteAlert();
		break;
	case 'eAlert_NestScanComplete': // Alien Nest POI Complete
		BuildNestPOICompleteAlert();
		break;
	case 'eAlert_RulerGuardingFacility': // Ruler Guarding Alien Facility Mission
		BuildRulerGuardingFacilityAlert();
		break;
	default:
		AddBG(MakeRect(0, 0, 1000, 500), eUIState_Normal).SetAlpha(0.75f);
		break;
	}

	// Set  up the navigation *after* the alert is built, so that the button visibility can be used. 
	RefreshNavigation();
}

simulated function Name GetLibraryID()
{
	//This gets the Flash library name to load in a panel. No name means no library asset yet. 
	switch ( eAlertName )
	{
	case 'eAlert_HunterWeaponsAvailable':						return 'Alert_Complete';
	case 'eAlert_HunterWeaponsScanningSite':					return 'Alert_SpecialPOI';
	case 'eAlert_NestScanningSite':							return 'Alert_SpecialPOI';
	case 'eAlert_HunterWeaponsScanComplete':					return 'Alert_SpecialPOI';
	case 'eAlert_NestScanComplete':							return 'Alert_SpecialPOI';
	case 'eAlert_RulerGuardingFacility':					return 'Alert_AlienSplash';

	default:
		return '';
	}
}

simulated function BuildHunterWeaponsAvailableAlert()
{
	local TAlertCompletedInfo kInfo;
	local X2ItemTemplate ItemTemplate;
	local X2ItemTemplateManager TemplateManager;

	TemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	ItemTemplate = TemplateManager.FindItemTemplate(
		class'X2StrategyGameRulesetDataStructures'.static.GetDynamicNameProperty(DisplayPropertySet, 'ItemTemplate'));

	kInfo.strName = m_strHunterWeaponsAvailableTitle;
	kInfo.strHeaderLabel = m_strHunterWeaponsAvailableLabel;
	kInfo.strBody = m_strHunterWeaponsAvailableBody;
	kInfo.strConfirm = m_strHunterWeaponsAvailableGoToArmory;
	kInfo.strCarryOn = m_strCarryOn;
	kInfo.strImage = ItemTemplate.strImage;
	kInfo = FillInShenAlertComplete(kInfo);
	kInfo.strHeadImage2 = "";
	kInfo.eColor = eUIState_Good;
	kInfo.clrAlert = MakeLinearColor(0.0, 0.75, 0.0, 1);

	BuildCompleteAlert(kInfo);
}

simulated function BuildHunterWeaponsPOIAvailableAlert()
{
	local XComGameStateHistory History;
	local XGParamTag ParamTag;
	local XComGameState_PointOfInterest POIState;
	local TAlertPOIAvailableInfo kInfo;

	History = `XCOMHISTORY;
	POIState = XComGameState_PointOfInterest(History.GetGameStateForObjectID(
		class'X2StrategyGameRulesetDataStructures'.static.GetDynamicIntProperty(DisplayPropertySet, 'POIRef')));

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = POIState.GetResistanceRegionName();

	kInfo.zoomLocation = POIState.Get2DLocation();
	kInfo.strTitle = m_strPOITitle; // Unused
	kInfo.strLabel = m_strPOILabel; // Unused
	kInfo.strBody = m_strHunterWeaponsPOIAvailableBody;
	kInfo.strImage = m_strPOIImage;
	kInfo.strReport = POIState.GetDisplayName();
	kInfo.strReward = POIState.GetRewardDescriptionString();
	kInfo.strRewardIcon = POIState.GetRewardIconString();
	kInfo.strDurationLabel = m_strPOIDuration;
	kInfo.strDuration = class'UIUtilities_Text'.static.GetTimeRemainingString(POIState.GetNumScanHoursRemaining());
	kInfo.strInvestigate = m_strPOIInvestigate;
	kInfo.strIgnore = m_strNotNow;
	kInfo.strFlare = m_strPOIFlare; // Unused
	kInfo.strUIIcon = POIState.GetUIButtonIcon();
	kInfo.eColor = eUIState_Normal;
	kInfo.clrAlert = MakeLinearColor(0.75f, 0.75f, 0, 1);
	
	BuildPointOfInterestAvailableAlert(kInfo);
}

simulated function BuildAlienNestPOIAvailableAlert()
{
	local XComGameStateHistory History;
	local XGParamTag ParamTag;
	local XComGameState_PointOfInterest POIState;
	local TAlertPOIAvailableInfo kInfo;

	History = `XCOMHISTORY;
	POIState = XComGameState_PointOfInterest(History.GetGameStateForObjectID(
		class'X2StrategyGameRulesetDataStructures'.static.GetDynamicIntProperty(DisplayPropertySet, 'POIRef')));

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = POIState.GetResistanceRegionName();

	kInfo.zoomLocation = POIState.Get2DLocation();
	kInfo.strTitle = m_strPOITitle; // Unused
	kInfo.strLabel = m_strPOILabel; // Unused
	kInfo.strBody = m_strAlienNestPOIAvailableBody;
	kInfo.strImage = m_strPOIImage;
	kInfo.strReport = POIState.GetDisplayName();
	kInfo.strReward = POIState.GetRewardDescriptionString();
	kInfo.strRewardIcon = POIState.GetRewardIconString();
	kInfo.strDurationLabel = m_strPOIDuration;
	kInfo.strDuration = class'UIUtilities_Text'.static.GetTimeRemainingString(POIState.GetNumScanHoursRemaining());
	kInfo.strInvestigate = m_strPOIInvestigate;
	kInfo.strIgnore = m_strNotNow;
	kInfo.strFlare = m_strPOIFlare; // Unused
	kInfo.strUIIcon = POIState.GetUIButtonIcon();
	kInfo.eColor = eUIState_Normal;
	kInfo.clrAlert = MakeLinearColor(0.75f, 0.75f, 0, 1);

	BuildPointOfInterestAvailableAlert(kInfo);
}

simulated function BuildWeaponsPOICompleteAlert()
{
	BuildPointOfInterestCompleteAlert();
	Button2.Hide(); // Do not display the "Return to Res HQ" button
}

simulated function BuildNestPOICompleteAlert()
{
	BuildPointOfInterestCompleteAlert();
	Button1.Hide(); // Do not display the "Return to Res HQ" button
}

simulated function BuildRulerGuardingFacilityAlert()
{	
	BuildAlienSplashAlert(
		m_strRulerGuardingFacilityTitle, 
		m_strRulerGuardingFacilityLabel, 
		m_strRulerGuardingFacilityBody,
		m_strRulerGuardingFacilityImage,
		m_strFacilityConfirm,
		m_strCarryOn);
}