//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_GeoscapeCharacter.uc
//  AUTHOR:  Mark Nauta  --  4/27/2016
//  PURPOSE: This object represents a character on the geoscape that plays the territory
//			 game by taking and losing control of Bastions
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_GeoscapeCharacter extends XComGameState_GeoscapeEntity
	abstract
	config(GameData);

var array<StateObjectReference> ControlledBastions;
var StateObjectReference		HomeRegion;

//#############################################################################################
//----------------   BASTIONS   ---------------------------------------------------------------	
//#############################################################################################

//---------------------------------------------------------------------------------------
function GainControlOfBastion(XComGameState NewGameState, StateObjectReference BastionRef)
{
	local XComGameState_Bastion BastionState;

	BastionState = XComGameState_Bastion(NewGameState.GetGameStateForObjectID(BastionRef.ObjectID));

	if(BastionState == none)
	{
		BastionState = XComGameState_Bastion(`XCOMHISTORY.GetGameStateForObjectID(BastionRef.ObjectID));

		if(BastionState == none)
		{
			`RedScreen("Invalid Bastion Reference @gameplay @mnauta");
			return;
		}

		BastionState = XComGameState_Bastion(NewGameState.ModifyStateObject(class'XComGameState_Bastion', BastionState.ObjectID));
	}

	BastionState.GainControllingEntity(NewGameState, self.GetReference());
}

//---------------------------------------------------------------------------------------
function LoseControlOfBastion(XComGameState NewGameState, StateObjectReference BastionRef)
{
	local XComGameState_Bastion BastionState;

	BastionState = XComGameState_Bastion(NewGameState.GetGameStateForObjectID(BastionRef.ObjectID));

	if(BastionState == none)
	{
		BastionState = XComGameState_Bastion(`XCOMHISTORY.GetGameStateForObjectID(BastionRef.ObjectID));

		if(BastionState == none)
		{
			`RedScreen("Invalid Bastion Reference @gameplay @mnauta");
			return;
		}

		BastionState = XComGameState_Bastion(NewGameState.ModifyStateObject(class'XComGameState_Bastion', BastionState.ObjectID));
	}

	if(BastionState.ControllingEntity == self.GetReference())
	{
		BastionState.LoseControllingEntity(NewGameState);
	}
}

//---------------------------------------------------------------------------------------
function int GetNumBastions()
{
	return ControlledBastions.Length;
}

//#############################################################################################
//----------------   LOCATION   ---------------------------------------------------------------	
//#############################################################################################

//---------------------------------------------------------------------------------------
function XComGameState_WorldRegion GetHomeRegion()
{
	return XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(HomeRegion.ObjectID));
}

//---------------------------------------------------------------------------------------
// Return home region and all regions where this character controls a bastion
function array<XComGameState_WorldRegion> GetControlledRegions()
{
	local XComGameStateHistory History;
	local array<StateObjectReference> ControlledRegionRefs;
	local array<XComGameState_WorldRegion> ControlledRegions;
	local XComGameState_Bastion BastionState;
	local int idx;

	History = `XCOMHISTORY;

	// Add home region (not neccessarily guaranteed to have a bastion)
	ControlledRegions.AddItem(GetHomeRegion());
	ControlledRegionRefs.AddItem(HomeRegion);

	// Grab all other regions that have a controlled bastion
	for(idx = 0; idx < ControlledBastions.Length; idx++)
	{
		BastionState = XComGameState_Bastion(History.GetGameStateForObjectID(ControlledBastions[idx].ObjectID));

		if(ControlledRegionRefs.Find('ObjectID', BastionState.Region.ObjectID) == INDEX_NONE)
		{
			ControlledRegions.AddItem(BastionState.GetWorldRegion());
			ControlledRegionRefs.AddItem(BastionState.Region);
		}
	}

	return ControlledRegions;
}

//---------------------------------------------------------------------------------------
function array<XComGameState_Bastion> GetControlledBastionsInRegion(XComGameState_WorldRegion RegionState)
{
	local array<XComGameState_Bastion> AllRegionBastions, ControlledRegionBastions;
	local int idx;

	AllRegionBastions = RegionState.GetAllBastions();

	for(idx = 0; idx < AllRegionBastions.Length; idx++)
	{
		if(AllRegionBastions[idx].ControllingEntity.ObjectID == self.ObjectID)
		{
			ControlledRegionBastions.AddItem(AllRegionBastions[idx]);
		}
	}

	return ControlledRegionBastions;
}

//#############################################################################################
//----------------   GEOSCAPE ENTITY IMPLEMENTATION   -----------------------------------------
//#############################################################################################

//---------------------------------------------------------------------------------------
function bool RequiresAvenger()
{
	return true;
}

//---------------------------------------------------------------------------------------
function bool HasTooltipBounds()
{
	return false;
}

//---------------------------------------------------------------------------------------
function bool ShouldBeVisible()
{
	return false;
}

//---------------------------------------------------------------------------------------
function bool CanBeScanned()
{
	return false;
}

//---------------------------------------------------------------------------------------
protected function bool CanInteract()
{
	return false;
}

//---------------------------------------------------------------------------------------
function DestinationReached()
{
}

//---------------------------------------------------------------------------------------
DefaultProperties
{

}