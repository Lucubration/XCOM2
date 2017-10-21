//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIScreenListener_UICustomize_DLC_Day90
//  AUTHOR:  Brit Steiner
//
//  PURPOSE: Adding DLC icons to the item lists. 
//
//---------------------------------------------------------------------------------------
//  Copyright (c) 2009-2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIScreenListener_UICustomize_DLC_Day90 extends UIScreenListener;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	UICustomize(Screen).CustomizeManager.SubscribeToGetIconsForBodyPart(GetIconsForBodyPart);
}

// This event is triggered when a screen is removed
event OnRemoved(UIScreen Screen)
{
	local UICustomize CustomizeScreen;

	CustomizeScreen = UICustomize(Screen);

	if( CustomizeScreen != none )
	{
		if( CustomizeScreen.CustomizeManager != None )
		{
			CustomizeScreen.CustomizeManager.UnsubscribeToGetIconsForBodyPart(GetIconsForBodyPart);
		}
	}

}

function string GetIconsForBodyPart(X2BodyPartTemplate BodyPart)
{
	if( BodyPart.DLCName == 'DLC_3' )
	{
		return class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Image'.const.HTML_GearIcon, 26, 26, -4) $ " ";
	}
	return "";

}

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = class'UICustomize_Menu';
}