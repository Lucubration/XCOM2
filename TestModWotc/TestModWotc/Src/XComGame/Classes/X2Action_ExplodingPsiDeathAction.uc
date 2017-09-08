//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_ExplodingPsiDeathAction extends X2Action_ExplodingUnitDeathAction;

function Init()
{
	super.Init();

	UnitPawn.bUseDesiredEndingAtomOnDeath = false;
}

function bool ShouldRunDeathHandler()
{
	return false;
}

function bool ShouldPlayDamageContainerDeathEffect()
{
	return false;
}

function bool DamageContainerDeathSound()
{
	return false;
}

simulated function name GetAssociatedAbilityName()
{
	return 'PsiDeathExplosion';
}

private function bool IsPreppedForSelfDestruct()
{
	return NewUnitState.AffectedByEffectNames.Find(class'X2Ability_ChosenWarlock'.default.PsiSelfDestructEffectName) != INDEX_NONE;
}

simulated function Name ComputeAnimationToPlay()
{
	// Always allow new animations to play.  (fixes sectopod never breaking out of its wrath cannon idle)
	UnitPawn.GetAnimTreeController().SetAllowNewAnimations(true);

	if( IsPreppedForSelfDestruct() )
	{
		return 'FF_Self_Destruct_Boom';
	}

	return 'HL_Death';
}

protected function bool DoWaitUntilNotified()
{
	// If the Spark is Prepped for Self Destruct, then use the usual Exploding Unit's function
	if( IsPreppedForSelfDestruct() )
	{
		return super.DoWaitUntilNotified();
	}

	// Otherwise, this is a regular death so we don't want to wait
	return false;
}