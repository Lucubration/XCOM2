//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_SyncVisualizer extends X2Action;

function bool CheckInterrupted()
{
	return false;
}

/// <summary>
/// We don't want to timeout this action as its causing problems with the tutorial not being visually sync'd up at the demo start frame
/// </summary>
function ForceImmediateTimeout()
{
}

function SyncVisualizer()
{
	local X2VisualizedInterface VisualizedObject;

	VisualizedObject = X2VisualizedInterface(Metadata.StateObject_NewState);
	if (VisualizedObject != none)
	{
		VisualizedObject.SyncVisualizer(StateChangeContext.AssociatedState);
	}
}

simulated state Executing
{
Begin:
	//Units must be dormant when running their visualizer sync
	if(XGUnit(Metadata.VisualizeActor) != none)
	{
		XGUnit(Metadata.VisualizeActor).GetPawn().StopTurning();		
	}

	SyncVisualizer();

	if(XGUnit(Metadata.VisualizeActor) != none)
	{
		XGUnit(Metadata.VisualizeActor).IdleStateMachine.Resume(self);
	}

	CompleteAction();
}

DefaultProperties
{
}
