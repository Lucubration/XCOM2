//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_AlertTheLost.uc
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Effect_AlertTheLost extends X2Effect 
	config(GameData);

var config int AlertRangeMeters;

//  Alert all inactive TheLost units within range.
simulated function ApplyEffectToWorld(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComWorldData WorldData; 
	local XComGameState_Unit LostUnitState, TargetState; 
	local vector LureLocation, UnitLocation;
	local float fMaxDistSq;
	local array<StateObjectReference> Targets;
	local int TargetIndex;
	local XComGameState_AIGroup LostGroup;
	local array<XComGameState_AIGroup> LostGroupsToActivate;
	local array<XComGameState_Unit> Members;
	local array<int> MemberIDs;
	local X2EventManager EventManager;

	if (ApplyEffectParameters.AbilityInputContext.TargetLocations.Length > 0)
	{
		History = `XCOMHISTORY;
		EventManager = `XEVENTMGR;
		WorldData = `XWORLD;
		LureLocation = ApplyEffectParameters.AbilityInputContext.TargetLocations[0];
		fMaxDistSq = `METERSTOUNITS_SQ(AlertRangeMeters);

		// Alert all lost in range, to any targets hit by the lure.
		Targets = ApplyEffectParameters.AbilityInputContext.MultiTargets;
		if ( Targets.Length > 0)
		{
			// Iterate through all lost within range of LureLocation.
			foreach History.IterateByClassType(class'XComGameState_Unit', LostUnitState)
			{
				if (LostUnitState.IsAlive() && LostUnitState.IsUnrevealedAI() && LostUnitState.GetTeam() == eTeam_TheLost)
				{
					UnitLocation = WorldData.GetPositionFromTileCoordinates(LostUnitState.TileLocation);
					if (VSizeSq(UnitLocation - LureLocation) <= fMaxDistSq)
					{
						
						LostGroup = LostUnitState.GetGroupMembership();
						if (LostGroupsToActivate.Find(LostGroup) == INDEX_NONE)
						{
							LostGroupsToActivate.AddItem(LostGroup);
						}
					}
				}
			}
			foreach LostGroupsToActivate(LostGroup)
			{
				if (LostGroup.GetLivingMembers(MemberIDs, Members))
				{
					TargetState = XComGameState_Unit(History.GetGameStateForObjectID(Targets[TargetIndex].ObjectID));
					TargetIndex = (TargetIndex + 1) % Targets.Length;
					EventManager.TriggerEvent('Alerted', Members[0], TargetState);
				}
			}
		}
	}
}

defaultproperties
{
	bCanBeRedirected = false
}