//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIPersonnel_BoostSoldier
//  AUTHOR:  Joe Weinhoffer
//  PURPOSE: Provides custom behavior for personnel selection screen when
//           selecting soldiers to use a recovery boost before a mission.
//---------------------------------------------------------------------------------------
//  Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIPersonnel_BoostSoldier extends UIPersonnel;

simulated function UpdateList()
{
	local int i;
	local XComGameState_Unit Unit;
	local UIPersonnel_ListItem UnitItem;
	
	super.UpdateList();
	
	// loop through every soldier to make sure they're not already in the squad
	for (i = 0; i < m_kList.itemCount; ++i)
	{
		UnitItem = UIPersonnel_ListItem(m_kList.GetItem(i));
		Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitItem.UnitRef.ObjectID));

		if (!Unit.CanBeBoosted())
		{
			UnitItem.SetDisabled(true);
		}
	}
}

defaultproperties
{
	m_eListType = eUIPersonnel_Soldiers;
	m_bRemoveWhenUnitSelected = true;
}