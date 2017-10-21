//---------------------------------------------------------------------------------------
//  FILE:    UIFacility_HuntersLodge.uc
//  AUTHOR:  Mike Donovan -- 02/18/2016
//  PURPOSE: This object add Hunter's Lodge functionality to the Armory UI
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class UIFacility_HuntersLodge extends UIFacility_Armory config(GameData);

var UIHuntersLodge3D HuntersLodgeDisplay;

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	local XComHQPresentationLayer HQPres;

	super.InitScreen(InitController, InitMovie, InitName);

	HQPres = XComHQPresentationLayer(Movie.Pres);
	HuntersLodgeDisplay = Spawn(class'UIHuntersLodge3D', HQPres);
	HuntersLodgeDisplay.InitScreen(XComPlayerController(HQPres.Owner), HQPres.Get3DMovie());
	HQPres.Get3DMovie().LoadScreen(HuntersLodgeDisplay);
}

simulated function OnReceiveFocus()
{
	super.OnReceiveFocus();
	HuntersLodgeDisplay.Show();
}

simulated function OnLoseFocus()
{
	super.OnLoseFocus();
	HuntersLodgeDisplay.Hide();
}


simulated function LeaveArmory()
{
	super.LeaveArmory();
	if (HuntersLodgeDisplay != none)
		HuntersLodgeDisplay.Hide();
}


simulated function OnRemoved()
{
	if (HuntersLodgeDisplay != none)
	{
		HuntersLodgeDisplay.Hide();
		Movie.Pres.Get3DMovie().RemoveScreen(HuntersLodgeDisplay);
		HuntersLodgeDisplay = none;
	}
	super.OnRemoved();
}