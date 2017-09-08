//---------------------------------------------------------------------------------------
//  FILE:    UIFacility_CovertActions.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class UIFacility_CovertActions extends UIFacility;

var public localized string m_strViewActions;

//----------------------------------------------------------------------------
// MEMBERS

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	super.InitScreen(InitController, InitMovie, InitName);
	CreateCovertOpsStatus();
	
	UpdateData();
}

public function UpdateData()
{
	local XComGameStateHistory History;
	local XComGameState_CovertAction ActionState;

	if( m_kCovertOpsStatus == none ) return; 

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_CovertAction', ActionState)
	{
		if( ActionState.bStarted )
		{
			m_kCovertOpsStatus.Refresh(ActionState);
			return; 
		}
	}
	
	//else we don't have one. TODO @bsteiner show blank data? or click to start? 
	m_kCovertOpsStatus.SetEmpty();
}

simulated function CreateFacilityButtons()
{
	AddFacilityButton(m_strViewActions, OnViewActions);
}

simulated function OnViewActions()
{
	`HQPRES().UICovertActions();
}

simulated function OnRemoved()
{
	super.OnRemoved();
}

simulated function OnReceiveFocus()
{
	super.OnReceiveFocus();
	UpdateData();
	m_kCovertOpsStatus.Show();
}
simulated function OnLoseFocus()
{
	super.OnLoseFocus();
	m_kCovertOpsStatus.Hide();
}

defaultproperties
{
	bHideOnLoseFocus = false;
}