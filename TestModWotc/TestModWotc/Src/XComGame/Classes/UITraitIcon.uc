//----------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UITraitIcon.uc
//  AUTHOR:  Brittany Steiner 3/13/2016
//----------------------------------------------------------------------------
//  Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
//----------------------------------------------------------------------------

class UITraitIcon extends UIPanel;

var bool bAnimateCohesion;
var bool bAnimateTrait;
var bool bPositive; 

delegate OnClickedDelegate(UITraitIcon Icon);

simulated function UITraitIcon InitTraitIcon(optional name InitName,
											 optional bool bIsPositive = false, 
											 optional delegate<OnClickedDelegate> initClickedDelegate)
{
	OnClickedDelegate = initClickedDelegate;
	bProcessesMouseEvents = (OnClickedDelegate != none); 

	InitPanel(InitName);
	if( bPositive )
		SetPositive();
	else
		SetNegative(); 

	return self;
}

simulated function UITraitIcon AnimateTrait(bool bAnimate)
{
	if (bAnimateTrait != bAnimate)
	{
		bAnimateTrait = bAnimate;
		mc.FunctionBool("AnimateTrait", bAnimateTrait);
	}

	return self;
}

function SetPositive()
{
	MC.FunctionVoid("SetPositive");
}
function SetNegative()
{
	MC.FunctionVoid("SetNegative");
}

simulated function OnMouseEvent(int cmd, array<string> args)
{
	super.OnMouseEvent(cmd, args);

	switch( cmd )
	{
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_IN :
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OVER :
		OnReceiveFocus();
		break;
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT :
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OUT :
		OnLoseFocus();
		break;
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_UP_DELAYED :
		if( OnClickedDelegate != none )
			OnClickedDelegate(self);
		break;
		break;
	}
}


defaultproperties
{
	LibID = "SoldierTraitIcon";

	bIsNavigable = true;
	
	//On the flash stage, default: 
	Width = 64;
	Height = 92; 
}
