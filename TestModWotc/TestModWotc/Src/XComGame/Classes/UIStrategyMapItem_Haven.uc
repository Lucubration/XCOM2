//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIStrategyMapItem_Haven
//  AUTHOR:  Mark Nauta
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIStrategyMapItem_Haven extends UIStrategyMapItem;

var string m_strHavenLabel;
var string m_strStateLabel;

event UpdateVisuals(bool bOnScreen)
{
	super.UpdateVisuals(bOnScreen);
	UpdateMaterials();
	UpdateFlyoverText();
}

function UpdateMaterials()
{
	local XComGameStateHistory History;
	local XComGameState_Haven HavenState;
	local XComGameState_WorldRegion RegionState;
	local string CurrentPath, DesiredPath;
	local MaterialInstanceConstant NewMaterial;
	local Object MaterialObject;
	local EResistanceLevelType eResistance;
	//local XComGameState_HeadquartersXCom XComHQ;

	CurrentPath = PathName(MapItem3D.GetMeshMaterial(0));

	History = `XCOMHISTORY;
	HavenState = XComGameState_Haven(History.GetGameStateForObjectID(GeoscapeEntityRef.ObjectID));
	RegionState = HavenState.GetWorldRegion();

	eResistance = RegionState.ResistanceLevel;

	//XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	//if(XComHQ.bFreeContact && eResistance < eResLevel_Unlocked)
	//{
	//	eResistance = eResLevel_Unlocked;
	//}

	DesiredPath = class'X2StrategyGameRulesetDataStructures'.default.HavenMaterialPaths[eResistance];

	if(CurrentPath != DesiredPath)
	{
		MaterialObject = `CONTENT.RequestGameArchetype(DesiredPath);
		if(MaterialObject != none && MaterialObject.IsA('MaterialInstanceConstant'))
		{
			NewMaterial = MaterialInstanceConstant(MaterialObject);
			MapItem3D.SetMeshMaterial(0, NewMaterial);
		}

	}
}

function UpdateFlyoverText()
{
	SetLabel(MapPin_Header);
}

public function UpdateLabel(string HavenLabel, string StateLabel, int ResistanceLevel)
{
	if( m_strHavenLabel != HavenLabel || m_strStateLabel != StateLabel )
	{
		m_strHavenLabel = HavenLabel;
		m_strStateLabel = StateLabel;

		mc.BeginFunctionOp("UpdateLabel");
		mc.QueueString(HavenLabel);
		mc.QueueString(StateLabel);
		mc.QueueNumber(ResistanceLevel);
		mc.EndOp();
	}
}

function EUIState GetIncomeColor(EResistanceLevelType eResLevel, bool bAtMaxControl)
{
	switch( eResLevel )
	{
	case eResLevel_Contact:
	case eResLevel_Outpost:
		if( bAtMaxControl )
		{
			return eUIState_Bad;
		}
		else
		{
			return eUIState_Good;
		}
	case eResLevel_Locked:
	case eResLevel_Unlocked: 
	default:
		return eUIState_Disabled;
	}
}

// Handle mouse hover special behavior
simulated function OnMouseIn()
{
	//Movie.Pres.SetDrawScale(1.5f);
}

// Clear mouse hover special behavior
simulated function OnMouseOut()
{
	//Movie.Pres.SetDrawScale(1.0f);
}

DefaultProperties
{
}