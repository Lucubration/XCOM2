//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_CorruptDeath extends X2Action_Death;

static function bool AllowOverrideActionDeath(VisualizationActionMetadata ActionMetadata, XComGameStateContext Context)
{
	return true;
}

simulated function Name ComputeAnimationToPlay()
{
	return 'HL_ResurrectDeath';
}

event OnAnimNotify(AnimNotify ReceiveNotify)
{
	super.OnAnimNotify(ReceiveNotify);

	if( (XComAnimNotify_NotifyTarget(ReceiveNotify) != none) && (AbilityContext != none) )
	{
		bWaitUntilNotified = false;
	}
}

defaultproperties
{
	bWaitUntilNotified=true
}