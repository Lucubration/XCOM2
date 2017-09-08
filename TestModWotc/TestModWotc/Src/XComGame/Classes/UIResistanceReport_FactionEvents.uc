
//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIResistanceReport_FactionEvents
//  AUTHOR:  Dan Kaplan 
//  PURPOSE: Shows end of month information summary.
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 


class UIResistanceReport_FactionEvents extends UIX2SimpleScreen;

var name DisplayTag;
var string CameraTag;

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	super.InitScreen(InitController, InitMovie, InitName);
	UpdateNavHelp();
	BuildScreen();

	class'UIUtilities_Sound'.static.PlayOpenSound();
	
	class'UIUtilities'.static.DisplayUI3D(DisplayTag, name(CameraTag), `SCREENSTACK.IsInStack(class'UIStrategyMap') ? 0.0 : `HQINTERPTIME);
	

	`HQPRES.m_kAvengerHUD.FacilityHeader.Hide();
}

//-------------- UI LAYOUT --------------------------------------------------------

simulated function BuildScreen()
{
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	if (!CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
	{
		return false;
	}

	switch(cmd)
	{
	case class'UIUtilities_Input'.const.FXS_BUTTON_A:
	case class'UIUtilities_Input'.const.FXS_KEY_ENTER:
		OnContinue();
		return true;
		break;
	case class'UIUtilities_Input'.const.FXS_BUTTON_B:
		return false;
	}

	return super.OnUnrealCommand(cmd, arg);
}

//-------------- EVENT HANDLING ----------------------------------------------------------
simulated function OnContinue()
{
	CloseScreen();
}

simulated function UpdateNavHelp()
{
	if( HQPRES() != none )
	{
		HQPRES().m_kAvengerHUD.NavHelp.ClearButtonHelp();
		HQPRES().m_kAvengerHUD.NavHelp.AddContinueButton(OnContinue);
	}
}

simulated function CloseScreen()
{
	super.CloseScreen();

	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();

	`GAME.GetGeoscape().Resume();
}

//-------------- FLASH DIRECT ACCESS --------------------------------------------------

//------------------------------------------------------

defaultproperties
{
	//Package = "/ package/gfxCouncilScreen/CouncilScreen";
	//LibID = "CouncilScreenReportCard";
	DisplayTag = "UIDisplay_Council_FactionEvents"
	CameraTag = "UIDisplayCam_ResistanceScreen_FactionEvents"
}
