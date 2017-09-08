//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIPersonnel_CovertAction
//  AUTHOR:  Joe Weinhoffer
//  PURPOSE: Provides custom behavior for personnel selection screen when
//           selecting soldiers to take on a covert action mission.
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIPersonnel_CovertAction extends UIPersonnel;

simulated function UpdateList()
{
	local XComGameState_StaffSlot SlotState;
	local XComGameState_Unit Unit;
	local UIPersonnel_ListItem UnitItem;
	local StaffUnitInfo UnitInfo;
	local int i;

	super.UpdateList();

	SlotState = XComGameState_StaffSlot(`XCOMHISTORY.GetGameStateForObjectID(SlotRef.ObjectID));

	// Disable any soldiers who are not eligible for this staff slot
	for (i = 0; i < m_kList.itemCount; ++i)
	{
		UnitItem = UIPersonnel_ListItem(m_kList.GetItem(i));
		Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitItem.UnitRef.ObjectID));

		UnitInfo.UnitRef = Unit.GetReference();
		UnitInfo.bGhostUnit = false;
		UnitInfo.GhostLocation.ObjectID = 0;

		if (!SlotState.ValidUnitForSlot(UnitInfo))
		{
			UnitItem.SetDisabled(true);
		}
	}
}

//bsg-crobinson (5.18.17): Add select button navhelp
//Also respective receive/lose focus calls for proper navhelp cleaning
simulated function UpdateNavHelp()
{
	local UINavigationHelp NavHelp;

	NavHelp = `HQPRES.m_kAvengerHUD.NavHelp;

	super.UpdateNavHelp();

	NavHelp.AddSelectNavHelp();
}

simulated function OnReceiveFocus()
{
	super.OnReceiveFocus();
	UpdateNavHelp();
}

simulated function OnLoseFocus()
{
	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
	super.OnLoseFocus();
}
//bsg-crobinson (5.18.17): end

defaultproperties
{
	m_bRemoveWhenUnitSelected = true;
}