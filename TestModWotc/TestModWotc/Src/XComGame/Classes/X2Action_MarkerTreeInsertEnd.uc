//-----------------------------------------------------------
// Marker nodes are used to help guide placement for other nodes in the visualization tree
//-----------------------------------------------------------
class X2Action_MarkerTreeInsertEnd extends X2Action native(Core);

//Holds visualization frames that did not have visualization of their own. Used by the visualization mgr to call on vis block completed for these
//history frames when this action completes. This list is added to as needed by <ProcessNoVisualization> on the visualization mgr. If a visualization
//tree exists already when a no vis history frame is processed, it is appended to this array. If there is no visualization running already, the 
//mgr just calls on block completed right away.
var array<XComGameState> PendingNoVisStates; 

event bool BlocksAbilityActivation()
{
	return false;
}

function string SummaryString()
{
	return "SubTreeEnd Frame(" @  StateChangeContext.AssociatedState.HistoryIndex @ ")";
}

function CompleteAction()
{
	super.CompleteAction();
		
	//RAM - limit this to the tutorial until it gets a TON more testing in the regular game. For the moment it fixes:
	// TTP 12839 - The camera will continually switch and hitch between the XCOM units and the ADVENT units when progressing through the tutorial mission.
	if (StateChangeContext.IsA('XComGameStateContext_Ability') && `REPLAY.bInTutorial)
	{
		`CAMERASTACK.OnVisTreeEndMarkerCompleted(self);
	}
}

//------------------------------------------------------------------------------------------------
simulated state Executing
{	
Begin:
	CompleteAction();
}

defaultproperties
{	
}

