class X2AbilityMultiTargetStyle_Lucu_Sniper_SabotRound extends X2AbilityMultiTarget_Line;

simulated function UpdateSightRangeLimited(const XComGameState_Ability Ability)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Ability.OwnerStateObject.ObjectID));
	`assert(UnitState != none);
	
	bSightRangeLimited = !UnitState.HasSquadsight();
}
