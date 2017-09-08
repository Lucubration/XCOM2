//----------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIListItemString.uc
//  AUTHOR:  Samuel Batista
//  PURPOSE: Basic list item control.
//
//  NOTE: Mouse events are handled by UIList class
//
//----------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//----------------------------------------------------------------------------

class UIEventNotice_ListItem extends UIPanel;

var string Text;
var string ImagePath;

var private string LeftLibID;
var private string RightLibID;

var protected bool bInTactical; 

simulated function UIPanel InitPanel(optional name InitName, optional name InitLibID)
{
	bInTactical = XComPresentationLayer(`PRESBASE) != none;

	if (bInTactical)
		super.InitPanel(, name(RightLibID));
	else
		super.InitPanel(, name(LeftLibID));

	return self;
}

simulated function UIEventNotice_ListItem PopulateData(string NewText, string NewPath)
{
	if( Text != NewText || ImagePath != NewPath )
	{
		Text = NewText;	
		ImagePath = NewPath;
		
		MC.BeginFunctionOp("PopulateData");
		MC.QueueString(Text);
		MC.QueueString(ImagePath);
		MC.QueueBoolean(bInTactical);
		MC.EndOp();
	}
	return self;
}


defaultproperties
{
	LeftLibID = "X2EventNoticeListItemLeft";
	RightLibID = "X2EventNoticeListItemRight";
	LibID = "X2EventNoticeListItem";
	bProcessesMouseEvents = false;

	width = 433; // size according to flash movie clip
	height = 56; // size according to flash movie clip
}