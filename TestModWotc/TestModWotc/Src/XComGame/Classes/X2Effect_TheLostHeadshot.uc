//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Effect_TheLostHeadshot extends X2Effect_Persistent
	config(GameData_SoldierSkills);

var config array<name> ValidHeadshotAbilities;

function bool GrantsFreeActionPoint_Target(XComGameStateContext_Ability AbilityContext, XComGameState_Unit Shooter, XComGameState_Unit Target, XComGameState GameState)
{
	return TargetKilledByHeadshot(AbilityContext, Target);
}

function bool ImmediateSelectNextTarget(XComGameStateContext_Ability AbilityContext, XComGameState_Unit Target)
{
	local XComGameStateHistory History;
	local XComGameState_Unit Shooter;

	History = `XCOMHISTORY;
	Shooter = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));

	if( Shooter.GetTeam() != eTeam_XCom )
	{
		return false;
	}

	return TargetKilledByHeadshot(AbilityContext, Target);
}

function bool TargetKilledByHeadshot(XComGameStateContext_Ability AbilityContext, XComGameState_Unit Target)
{
	// Make sure target unit is dead
	return Target.IsDead() &&
		IsValidHeadshotAbility(AbilityContext.InputContext.AbilityTemplateName);
}

function bool ShouldUseMidpointCameraForTarget(XComGameState_Ability AbilityState, XComGameState_Unit Target)
{
	return Target.GetMyTemplate().bDontUseOTSTargetingCamera &&
		IsValidHeadshotAbility(AbilityState.GetMyTemplateName());
}

function bool IsValidHeadshotAbility(Name AbilityName)
{
	return (default.ValidHeadshotAbilities.Find(AbilityName) != INDEX_NONE);
}