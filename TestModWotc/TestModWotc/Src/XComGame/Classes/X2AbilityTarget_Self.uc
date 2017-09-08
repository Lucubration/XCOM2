class X2AbilityTarget_Self extends X2AbilityTargetStyle native(Core);

simulated function bool SuppressShotHudTargetIcons()
{
	return true;
}

simulated native function name GetPrimaryTargetOptions(const XComGameState_Ability Ability, out array<AvailableTarget> Targets);
simulated native function name CheckFilteredPrimaryTargets(const XComGameState_Ability Ability, const out array<AvailableTarget> Targets);
// Returns distance in Units this Ability can reach from the source location.  -1 if unlimited range.
simulated function float GetHitRange(const XComGameState_Ability Ability)
{
	return Ability.GetAbilityRadius();
}