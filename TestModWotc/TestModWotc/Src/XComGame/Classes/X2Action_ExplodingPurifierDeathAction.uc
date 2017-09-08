//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_ExplodingPurifierDeathAction extends X2Action_ExplodingUnitDeathAction;

simulated function name GetAssociatedAbilityName()
{
	return 'PurifierDeathExplosion';
}

simulated function Name ComputeAnimationToPlay()
{
	// Always allow new animations to play.
	UnitPawn.GetAnimTreeController().SetAllowNewAnimations(true);

	return 'HL_ExplosionDeath';
}