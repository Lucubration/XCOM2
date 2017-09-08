//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_MimicBeaconThrow extends X2Action_Fire;

// Set by visualizer so we know the mimic unit
var StateObjectReference MimicBeaconUnitReference;

function NotifyTargetsAbilityApplied()
{	
	if( !bNotifiedTargets )
	{
		`XEVENTMGR.TriggerEvent('Visualizer_AbilityHit', self, self);

		super.NotifyTargetsAbilityApplied();
	}
}