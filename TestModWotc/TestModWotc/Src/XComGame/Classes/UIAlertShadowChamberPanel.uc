//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIAlertShadowChamberPanel.uc
//  AUTHOR:  Brit Steiner
//---------------------------------------------------------------------------------------
//  Copyright (c) 2010-2017 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIAlertShadowChamberPanel extends UIPanel;

simulated function UIPanel InitPanel(optional name InitName, optional name InitLibID)
{
	super.InitPanel(InitName, InitLibID);

	SetPosition(1330, 199); //Location on stage in flash 

	DisableNavigation();

	return self;
}

defaultproperties
{
	LibID = "Alert_ShadowChamber";
}