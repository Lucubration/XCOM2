//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIReconnectController.uc
//  AUTHOR:  dwuenschell
//  PURPOSE: Reconnect Controller UI
//---------------------------------------------------------------------------------------
//  Copyright (c) 2011-2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIReconnectController extends UIProgressDialogue;

var bool m_bOnOptionsScreen;

//==============================================================================
// 		UNIQUE FUNCTIONS:
//==============================================================================
simulated function bool OnCancel( optional string strOption = "" )
{
	local UIOptionsPCScreen OptionsScreen; 

	OptionsScreen = UIOptionsPCScreen(Movie.Pres.ScreenStack.GetScreen(class'UIOptionsPCScreen'));
	if( OptionsScreen != none )
	{
		OptionsScreen.ForceInputDeviceToMouse();
	}

	return super.OnCancel();
}

//==============================================================================
//		DEFAULTS:
//==============================================================================
defaultproperties
{
	m_bOnOptionsScreen = false;
}
