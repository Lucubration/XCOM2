//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIAlertSitRepPanel.uc
//  AUTHOR:  Brit Steiner
//---------------------------------------------------------------------------------------
//  Copyright (c) 2010-2017 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIAlertSitRepPanel extends UIPanel;

var UIButton InfoButton;
var UIGamepadIcons ControllerHint;

simulated function UIPanel InitPanel(optional name InitName, optional name InitLibID)
{
	super.InitPanel(InitName, InitLibID);

	SetPosition(1330, 736); //Location on stage in flash 

	DisableNavigation();

	InfoButton = Spawn(class'UIButton', self);
	InfoButton.bIsNavigable = false;
	InfoButton.InitButton('SitRepInfoButton',,OnInfoButtonMouseEvent);
	InfoButton.bAnimateOnInit = false;

	ControllerHint = Spawn(class'UIGamepadIcons', self);
	ControllerHint.InitGamepadIcon('', class'UIUtilities_Input'.static.GetGamepadIconPrefix() $class'UIUtilities_Input'.const.ICON_LSCLICK_L3, 28);
	ControllerHint.SetPosition(358, 4);
	
	if (`ISCONTROLLERACTIVE)
	{
		InfoButton.Hide();
		ControllerHint.Show();
	}
	else
	{
		InfoButton.Show();
		ControllerHint.Hide();
	}

	return self;
}

simulated function SetTitle(string Label)
{
	MC.FunctionString("SetSitRepAlertTitle", Label);
}

function OnInfoButtonMouseEvent(UIButton Button)
{
	local UIMission ParentMission; 

	if (!IsVisible()) return; 

	ParentMission = UIMission(Owner.Owner); //If we ar eon a UIMission's library panel, then we can get data. 
	if( ParentMission != none )
		`HQPRES.UISitRepInformation(ParentMission.MissionRef);	
}

defaultproperties
{
	LibID = "Alert_SitRep";
}