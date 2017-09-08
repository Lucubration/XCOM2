//----------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIEventNotice_BannerListItem.uc
//  AUTHOR:  Brit Steiner 
//  PURPOSE: Fancy list item control.
//
//  NOTE: Mouse events are handled by UIList class
//
//----------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//----------------------------------------------------------------------------

class UIEventNotice_BannerListItem extends UIEventNotice_ListItem;

var string Value;
var string Label;
var EUIState eState;

delegate OnMouseEventDel(int cmd);

simulated function UIEventNotice_BannerListItem PopulateBannerData(EUIState NewState, string NewText, string NewLabel, string NewValue, string NewImagePath, delegate<OnMouseEventDel> NewOnMouseEvent)
{
	if(	  Text != NewText 
	   || Label != NewLabel 
	   || Value != NewValue
	   || ImagePath != NewImagePath
	   || eState != NewState )
	{
		Text = NewText;
		Label = NewLabel;
		Value = NewValue;
		ImagePath = NewImagePath;
		eState = NewState; 
		
		MC.BeginFunctionOp("PopulateData");
		MC.QueueNumber(bInTactical ? 1 : 0); // bIsInTactical
		MC.QueueNumber(eState);
		MC.QueueString(Text);
		MC.QueueString(Label);
		MC.QueueString(Value);
		MC.QueueString(ImagePath);
		MC.EndOp();
	}

	OnMouseEventDel = NewOnMouseEvent;

	if( OnMouseEventDel == none )
		IgnoreMouseEvents();
	else
		ProcessMouseEvents();

	return self;
}

simulated function OnMouseEvent(int cmd, array<string> args)
{
	if( OnMouseEventDel != none )
		OnMouseEventDel(cmd);
}


defaultproperties
{
	LeftLibID = "XPACKEventNoticeBannerLeftListItem";
	RightLibID = "XPACKEventNoticeBannerRightListItem";
	bProcessesMouseEvents = false;

	width = 969; // size according to flash movie clip
	height = 88; // size according to flash movie clip

	eState = eUIState_Normal; 
}