//---------------------------------------------------------------------------------------
//  FILE:    X2Condition_Bondmate.uc
//  AUTHOR:  David Burchanowski
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2Condition_Bondmate extends X2Condition
	config(GameData_SoldierSkills)
	native(Core);

enum AdjacencyRequirement
{
	EAR_AnyAdjacency,
	EAR_DisallowAdjacency,
	EAR_RequireAdjacency,
};

// The ability will only fire if the bondmate rating of the activator and this unit 
// are within this range, inclusive
var int MinBondLevel;
var int MaxBondLevel;
var AdjacencyRequirement RequiresAdjacency;

// if true, this condition checks whether there is a bondmate for the source unit on the mission, 
// but does not worry about whether the target of the ability is that unit (used for self-targeting bondmate abilities)
var bool bSkipCheckWithSource;

// true if the unit has a living bondmate in the correct range on the mission
native function name MeetsCondition(XComGameState_BaseObject kTarget);
// only true if the two units are bondmates, and within bond range
native function name MeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource);
native function name MeetsBondmateConditions(XComGameState_Unit SourceUnit, XComGameState_Unit BondmateUnit, const out SoldierBond BondInfo);

function bool CanEverBeValid(XComGameState_Unit SourceUnit, bool bStrategyCheck)
{
	local StateObjectReference BondmateRef;
	local SoldierBond BondInfo;
	local XComGameState_HeadquartersXCom XComHQ;

	// this condition can only ever be valid if the source unit is bonded to another unit on the mission and within the restricted level range
	if( SourceUnit.HasSoldierBond(BondmateRef, BondInfo) )
	{
		// the bondmate must be on the mission to count
		XComHQ = `XCOMHQ;
		if( bStrategyCheck || XComHQ.IsUnitInSquad(BondmateRef) )
		{
			// check the level range
			if( MinBondLevel <= BondInfo.BondLevel && BondInfo.BondLevel <= MaxBondLevel )
			{
				return true;
			}
		}
	}

	return false;
}

defaultproperties
{
	MinBondLevel=1
	MaxBondLevel=-1
}