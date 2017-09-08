//----------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIBondIcon.uc
//  AUTHOR:  Brittany Steiner 11/18/2016
//----------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//----------------------------------------------------------------------------

class UIBondIcon extends UIPanel;

var int BondLevel;
var bool bAnimateCohesion;
var bool bAnimateBond;
var bool bOnMission; 

delegate OnClickedDelegate(UIBondIcon Icon);

simulated function UIBondIcon InitBondIcon( optional name InitName,
											optional int InitBondLevel = -1,
											optional delegate<OnClickedDelegate> initClickedDelegate, 
											optional StateObjectReference BondmateRef)
{
	OnClickedDelegate = initClickedDelegate;
	bProcessesMouseEvents = (OnClickedDelegate != none); 

	InitPanel(InitName);
	SetBondLevel(InitBondLevel);

	return self;
}

simulated function UIBondIcon SetBondLevel(int NewBondLevel, optional bool bNewOnMission = true)
{
	if( BondLevel != NewBondLevel || bOnMission != bNewOnMission )
	{
		BondLevel = NewBondLevel;
		bOnMission = bNewOnMission;

		MC.BeginFunctionOp("SetBondLevel");
		MC.QueueNumber(BondLevel);
		MC.QueueBoolean(bOnMission);
		MC.EndOp();
	}

	if( BondLevel > -1 )
	{
		if( bNewOnMission )
		{
			SetVisible(true);
			SetAlpha(100);
		}
		else
		{
			RemoveTweens();
			SetVisible(true);
			SetAlpha(50);
	}
	}
	else
	{
		SetVisible(false);
	}
	if( bNewOnMission ) //bOnMission will modify the alpha, so don't try to override it here. 
	{
	SetVisible(BondLevel > -1);
	}
	
	if( !IsVisible() )
	{
		RemoveTooltip();
	}

	return self;
}

simulated function UIBondIcon SetBondmateTooltip(StateObjectReference BondmateRef, optional int IconAnchor = class'UIUtilities'.const.ANCHOR_TOP_LEFT)
{

	local StateObjectReference NoneRef;
	local XComGameState_Unit Bondmate;

	RemoveTooltip();

	if (BondmateRef != NoneRef)
	{
		Bondmate = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(BondmateRef.ObjectID));
		SetTooltipText(Caps(Bondmate.GetName(eNameType_FullNick)),,,,, IconAnchor,true,0.0);
	}
	return self;
}

simulated function UIBondIcon AnimateBond(bool bAnimate)
{
	if (bAnimateBond != bAnimate)
	{
		bAnimateBond = bAnimate;
		mc.FunctionBool("AnimateBond", bAnimateBond);
	}

	return self;
}

simulated function UIBondIcon AnimateCohesion(bool bAnimate)
{
	if (bAnimate)
	{
		SetBondLevel(0); // zero is the cohesion icon
	}

	if (bAnimateCohesion != bAnimate)
	{
		bAnimateCohesion = bAnimate;
		mc.FunctionBool("AnimateCohesion", bAnimateCohesion);
	}

	return self; 
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
	LibID = "SoldierBondIcon";

	bIsNavigable = true;
	BondLevel = -1;
	
	//On the flash stage, default: 
	Width = 64;
	Height = 92; 
}
