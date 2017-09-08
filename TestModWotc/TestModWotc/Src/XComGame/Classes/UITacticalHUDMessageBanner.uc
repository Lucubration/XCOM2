//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    TacticalHUDMessageBanner.uc
//  AUTHORS: Brit Steiner
//---------------------------------------------------------------------------------------
//  Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UITacticalHUDMessageBanner extends UIScreen;

simulated function OnInit()
{
	super.OnInit();
}
function SetStyleBad()
{
	MC.FunctionVoid("SetStyleBad");
}
function SetStyleGood()
{
	MC.FunctionVoid("SetStyleGood");
}
function SetStyleNeutral()
{
	MC.FunctionVoid("SetStyleNeutral");
}
function SetBanner(string DisplayText)
{
	MC.FunctionString("SetBanner", DisplayText);
	AnimateIn();
}

simulated function AnimateOut(optional float Delay = -1.0)
{
	MC.FunctionVoid("AnimateOut");
}
simulated function AnimateIn(optional float Delay = -1.0)
{
	MC.FunctionVoid("AnimateIn");
}

defaultproperties
{
	Package = "/ package/gfxXPACK_TacticalHUDMessageBanner/XPACK_TacticalHUDMessageBanner";
	InputState = eInputState_None;
}