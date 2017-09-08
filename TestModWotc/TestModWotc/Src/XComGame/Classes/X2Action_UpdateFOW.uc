//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_UpdateFOW extends X2Action;

var bool Remove;
var bool ForceUpdate;
var bool BeginUpdate;
var bool EndUpdate;

simulated state Executing
{
Begin:
	if( Remove )
	{
		if (Unit != none)
		{
			Unit.UnregisterAsViewer();
		}
		else
		{
			`XWORLD.UnregisterActor(MetaData.VisualizeActor);
		}
	}
	else if (ForceUpdate)
	{
		if (Unit != none)
		{
			Unit.ForceVisibilityUpdate();
		}
		else
		{
			`XWORLD.ForceFOWViewerUpdate(MetaData.VisualizeActor);
		}
	}
	else if (BeginUpdate)
	{
		if (Unit != none)
		{
			Unit.BeginUpdatingVisibility();
		}
		else
		{
			`XWORLD.BeginFOWViewerUpdates(MetaData.VisualizeActor);
		}
	}
	else if (EndUpdate)
	{
		if (Unit != none)
		{
			Unit.EndUpdatingVisibility();
		}
		else
		{
			`XWORLD.EndFOWViewerUpdates(MetaData.VisualizeActor);
		}
	}
	else
	{
		`redscreen("X2Action_UpdateFOW created but not configured with an option for how to act");
	}

	CompleteAction();
}

event bool ShouldForceCompleteWhenStoppingAllPreviousActions()
{
	return false;
}

DefaultProperties
{

}
