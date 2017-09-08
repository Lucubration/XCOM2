//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIMPShell_Base.uc
//  AUTHOR:  Todd Smith  --  6/25/2015
//  PURPOSE: Base class for the MP shell screens. Contains boilerplate code for 
//           navigation, input, etc.
//---------------------------------------------------------------------------------------
//  Copyright (c) 2015 Firaxis Games Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIMPShell_Base extends UIScreen
	dependson(UIProgressDialogue);

var string TEMP_strSreenNameText;
var UIX2PanelHeader TEMP_ScreenNameHeader;

var X2MPShellManager m_kMPShellManager;
var X2Photobooth_StrategyAutoGen m_kPhotobooth_StrategyAutoGen;
var string MPLevelName;
var string ShellLevelName;

var string CameraTag;
var string DisplayTag;

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	super.InitScreen(InitController, InitMovie, InitName);

	m_kMPShellManager = XComShellPresentationLayer(InitController.Pres).m_kMPShellManager;
	m_kPhotobooth_StrategyAutoGen = Spawn(class'X2Photobooth_StrategyAutoGen');
}


simulated function bool OnUnrealCommand(int cmd, int arg)
{
	if ( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	switch( cmd )
	{
		case class'UIUtilities_Input'.const.FXS_BUTTON_B:
		case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE:
		case class'UIUtilities_Input'.const.FXS_R_MOUSE_DOWN:
			if(bIsInited)
				CloseScreen();
			return true;
	}

	return super.OnUnrealCommand(cmd, arg);
}

simulated function CloseScreen()
{
	m_kPhotobooth_StrategyAutoGen.Destroy();
	// do any custom cleanup we need here. -tsmith
	super.CloseScreen();
}

simulated function OnRemoved()
{
	super.OnRemoved();
	
	Movie.Pres.UIClearGrid();
}


//==============================================================================
//		DEFAULTS:
//==============================================================================
DefaultProperties
{
	InputState = eInputState_Evaluate;
	TEMP_strSreenNameText="";
	MPLevelName="XComShell_Multiplayer.umap";

	DisplayTag="UIDisplay_MPShell"
	CameraTag="UIDisplay_MPShell"
}