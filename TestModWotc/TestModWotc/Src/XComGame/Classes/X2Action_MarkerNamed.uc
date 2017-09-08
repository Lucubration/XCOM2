//-----------------------------------------------------------
// Marker nodes are used to help guide placement for other nodes in the visualization tree
//-----------------------------------------------------------
class X2Action_MarkerNamed extends X2Action;

var privatewrite name MarkerName;

event bool BlocksAbilityActivation()
{
	return false;
}

function SetName(string InMarkerName)
{
	local string EventID;

	//We don't actually emit this event, we just use completed. But this event ID is used to pair this node with others
	EventID = "Visualizer_" $ InMarkerName;
	OutputEventIDs.AddItem(name(EventID));

	MarkerName = name(InMarkerName);
}

function string SummaryString()
{
	return string(MarkerName);
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

