//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_SendInterTrackMessage extends X2Action;

var StateObjectReference                    SendTrackMessageToRef;
//*************************************

simulated state Executing
{
Begin:
	//DELETE ME

	CompleteAction();
}

event bool BlocksAbilityActivation()
{
	return false;
}
