//----------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIIconChip.uc
//  AUTHOR:  Brittany Steiner 9/1/2014
//  PURPOSE: UIPanel to for an icon chip in the icon selector grid. 
//----------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//----------------------------------------------------------------------------

class UIIconChip extends UIPanel;

var UIIcon Icon; 
var int index; 
var int Row; 
var int Col; 
var int PADDING_HIGHLIGHT;

delegate OnSelectDelegate(int iColorIndex);
delegate OnAcceptDelegate(int iColorIndex);

simulated function UIIconChip InitIconChip( optional name InitName, 
											optional int initIndex = -1,
											optional string initIconPath,
											optional float initX = 0,
											optional float initY = 0,
											optional float initSize = 0,
											optional float initRow = -1,
											optional float initCol = -1,
											optional delegate<OnSelectDelegate> initSelectDelegate,
											optional delegate<OnAcceptDelegate> initAcceptDelegate)
{
	InitPanel(InitName);

	Icon = Spawn(class'UIIcon', self);
	Icon.bAnimateOnInit = false;
	Icon.InitIcon('IconChip', initIconPath,,,,, OnIconClicked, OnIconClicked);
	Icon.EnableMouseAutomaticColor(class'UIUtilities_Colors'.const.NORMAL_HTML_COLOR);
	Icon.ProcessMouseEvents(UIIconSelector(Owner.Owner).OnChildMouseEvent);

	SetPosition(initX, initY);
	
	if( initSize != 0 )
		SetSize(initSize, initSize);
	else
		SetSize( class'UIIconChip'.default.width, class'UIIconChip'.default.height);

	index = initIndex;
	Row = initRow;
	Col = initCol; 

	OnSelectDelegate = initSelectDelegate;
	OnAcceptDelegate = initAcceptDelegate;

	Navigator.OnSelectedIndexChanged = OnSelectDelegate;

	return self; 
}

simulated function UIPanel SetSize(float newWidth, float newHeight)
{
	SetWidth(newWidth);
	SetHeight(newHeight);

	return self; 
}
simulated function SetWidth(float newWidth)
{
	width = newWidth;
	Icon.SetWidth(width);
}
simulated function SetHeight(float newHeight)
{
	height = newHeight;
	Icon.SetHeight(height);
}

simulated function UIPanel LoadIcon(string IconPath)
{
	Icon.LoadIcon(IconPath);
	return self; 
}

simulated function OnReceiveFocus()
{
	Icon.OnReceiveFocus();
	if(OnSelectDelegate != none)
		OnSelectDelegate( index );
}

simulated function OnLoseFocus()
{
	Icon.OnLoseFocus();
}

simulated function OnIconClicked()
{
	if( OnAcceptDelegate != none )
		OnAcceptDelegate(index);
}


//------------------------------------------------------

simulated function OnMouseEvent(int cmd, array<string> args)
{
	super.OnMouseEvent(cmd, args);

	switch(cmd)
	{
		//TODO: this control BG doesn't get in and out calls yet, so these don't trigger. 
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_IN:
		OnReceiveFocus();
		break;
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT:
		OnLoseFocus();
		break;
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_UP:
		if(OnAcceptDelegate != none)
			OnAcceptDelegate( index );
		break;
	}
}

//------------------------------------------------------

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	if( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	switch( cmd )
	{
		case class'UIUtilities_Input'.const.FXS_BUTTON_A:
		case class'UIUtilities_Input'.const.FXS_KEY_ENTER:
		case class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR:
			if(OnAcceptDelegate != none)
			{
				OnAcceptDelegate( index );
			}
			return true;
		default:
			if (Navigator.OnUnrealCommand(cmd, arg))
			{
				return true;
			}
			break;
	}

	return false;
}

//------------------------------------------------------


defaultproperties
{
	bIsNavigable = true;
	bAnimateOnInit = false;

	width = 64; 
	height = 64;

	PADDING_HIGHLIGHT = 6; 
}
