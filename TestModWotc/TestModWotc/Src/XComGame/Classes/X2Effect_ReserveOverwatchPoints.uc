//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_ReserveOverwatchPoints.uc
//  AUTHOR:  Joshua Bouscher  --  2/11/2015
//  PURPOSE: Specifically for Overwatch; allows Pistols to use their own action points,
//           making it easier to distinguish from the Sniper Rifle.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Effect_ReserveOverwatchPoints extends X2Effect_ReserveActionPoints;

var array<name> UseAllPointsWithAbilities;	//	if the unit has any of the abilities listed, reserver a number of points equal to action points spent instead of NumPoints

simulated function name GetReserveType(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState)
{
	local XComGameState_Item ItemState;
	local X2WeaponTemplate WeaponTemplate;

	if (ApplyEffectParameters.ItemStateObjectRef.ObjectID > 0 && ReserveType == default.ReserveType)
	{
		ItemState = XComGameState_Item(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));
		if (ItemState == none)
			ItemState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));

		if (ItemState != none)
		{
			WeaponTemplate = X2WeaponTemplate(ItemState.GetMyTemplate());
			if (WeaponTemplate != None && WeaponTemplate.OverwatchActionPoint != '')
				return WeaponTemplate.OverwatchActionPoint;
		}
	}
	return ReserveType;
}

simulated protected function int GetNumPoints(XComGameState_Unit UnitState)
{
	local name AbilityName;

	foreach UseAllPointsWithAbilities(AbilityName)
	{
		if (UnitState.HasSoldierAbility(AbilityName))
		{
			return UnitState.ActionPoints.Length;
		}
	}
	return super.GetNumPoints(UnitState);
}

DefaultProperties
{
	ReserveType = "overwatch"
	NumPoints = 1
	UseAllPointsWithAbilities(0)="SkirmisherAmbush"
}