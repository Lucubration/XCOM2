//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIPersonnel_CovertAction
//  AUTHOR:  Joe Weinhoffer
//  PURPOSE: Provides custom behavior for personnel selection screen when
//           selecting soldiers to take on a covert action mission.
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIPersonnel_Armory extends UIPersonnel;

simulated function UpdateList()
{
	local XComGameState_Unit Unit;
	local UIPersonnel_ListItem UnitItem;
	local int i;

	super.UpdateList();
	
	// Disable any soldiers who are away on Covert Actions
	for (i = 0; i < m_kList.itemCount; ++i)
	{
		UnitItem = UIPersonnel_ListItem(m_kList.GetItem(i));
		Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitItem.UnitRef.ObjectID));

		if(Unit.IsOnCovertAction())
		{
			UnitItem.SetDisabled(true);
		}
	}
}

// bsg-jrebar (4/19/17): Add nav help for A button if on armory
simulated function UpdateNavHelp()
{
	local UINavigationHelp NavHelp;

	NavHelp = `HQPRES.m_kAvengerHUD.NavHelp;

	NavHelp.ClearButtonHelp();
	NavHelp.bIsVerticalHelp = `ISCONTROLLERACTIVE;
	if(HQState.IsObjectiveCompleted('T0_M2_WelcomeToArmory'))
	{
		NavHelp.AddBackButton(OnCancel);
		NavHelp.AddSelectNavHelp();

		// Don't allow jumping to the geoscape from the armory in the tutorial or when coming from squad select
		if (class'XComGameState_HeadquartersXCom'.static.GetObjectiveStatus('T0_M7_WelcomeToGeoscape') != eObjectiveState_InProgress
			&& !`SCREENSTACK.IsInStack(class'UISquadSelect'))
			NavHelp.AddGeoscapeButton();

		if( `ISCONTROLLERACTIVE )
		{
			NavHelp.AddLeftHelp(m_strToggleSort, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_X_SQUARE);
			NavHelp.AddLeftHelp(m_strChangeColumn, class'UIUtilities_Input'.const.ICON_DPAD_HORIZONTAL); //bsg-crobinson (5.15.17): Add change column icon
		}
	}
	else if( `ISCONTROLLERACTIVE )
	{
		NavHelp.AddLeftHelp(m_strToggleSort, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_X_SQUARE);
		NavHelp.AddLeftHelp(m_strChangeColumn, class'UIUtilities_Input'.const.ICON_DPAD_HORIZONTAL); //bsg-crobinson (5.15.17): Add change column icon
	}
}
// bsg-jrebar (4/19/17): end

defaultproperties
{
	m_eListType = eUIPersonnel_Soldiers;
}