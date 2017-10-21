//---------------------------------------------------------------------------------------
//  FILE:    UIAlert_DLC_Day90.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class UIAlert_DLC_Day90 extends UIAlert;

enum EAlertType_DLC_Day90
{
	eAlert_LostTowersScanningSite,
	eAlert_LostTowersScanComplete,
	eAlert_SparkSquadSelectInfo
};

var public localized string m_strLostTowersPOIAvailableBody;
var public localized string m_strSparkSquadSelectInfoTitle;
var public localized string m_strSparkSquadSelectInfoBody;


simulated function BuildAlert()
{
	BindLibraryItem();

	switch ( eAlertName )
	{
	case 'eAlert_LostTowersScanningSite': // Lost Towers POI Available
		BuildLostTowersPOIAvailableAlert();
		break;
	case 'eAlert_LostTowersScanComplete': // Lost Towers POI Complete
		BuildLostTowersPOICompleteAlert();
		break;
	case 'eAlert_SparkSquadSelectInfo':
		BuildSparkSquadSelectInfoAlert();
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
	case 'eAlert_LostTowersScanningSite':					return 'Alert_SpecialPOI';
	case 'eAlert_LostTowersScanComplete':					return 'Alert_SpecialPOI';
	case 'eAlert_SparkSquadSelectInfo':					return 'Alert_XComGeneric';

	default:
		return '';
	}
}

simulated function BuildLostTowersPOIAvailableAlert()
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
	kInfo.strBody = m_strLostTowersPOIAvailableBody;
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

simulated function BuildLostTowersPOICompleteAlert()
{
	BuildPointOfInterestCompleteAlert();
	Button2.Hide(); // Do not display the "Return to Res HQ" button
}

simulated function BuildSparkSquadSelectInfoAlert()
{
	// Send over to flash
	LibraryPanel.MC.BeginFunctionOp("UpdateData");
	LibraryPanel.MC.QueueString(m_strSoldierShakenHeader); // Header (ATTENTION)
	LibraryPanel.MC.QueueString(m_strSparkSquadSelectInfoTitle); // Title
	LibraryPanel.MC.QueueString(m_strSparkSquadSelectInfoBody); // Body
	LibraryPanel.MC.QueueString(""); // Button 0
	LibraryPanel.MC.QueueString(m_strOK); // Button 1
	LibraryPanel.MC.EndOp();

	Button2.SetGamepadIcon(class'UIUtilities_Input'.static.GetAdvanceButtonIcon());
	Button1.Hide();
	Button1.DisableNavigation();
}