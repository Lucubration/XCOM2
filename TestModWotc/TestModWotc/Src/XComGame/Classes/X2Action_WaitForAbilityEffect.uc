//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_WaitForAbilityEffect extends X2Action;

function Init()
{
	super.Init();
}

function ChangeTimeoutLength( float newTimeout )
{
	TimeoutSeconds = newTimeout;
}

function bool IsTimedOut()
{
	return ExecutingTime >= TimeoutSeconds && TimeoutSeconds > 0.0f;
}

function bool AllowEvent(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit EventDataUnit;

	if( EventID == 'Visualizer_ProjectileHit' )
	{
		// A Visualizer_ProjectileHit event came in so we treat it differently
		EventDataUnit = XComGameState_Unit(EventData);

		if( EventDataUnit != None &&
			EventDataUnit.ObjectID == Metadata.StateObject_NewState.ObjectID )
		{
			// The EventData matches our action's unit so allow the event
			return true;
		}

		// The EventData didn't match our action's unit so don't allow the event
		return false;
	}

	// We trigger from any non-Visualizer_ProjectileHit event. This class is legacy and will eventually be removed.
	return true;
}

//------------------------------------------------------------------------------------------------

simulated state Executing
{
Begin:
	
	CompleteAction();
}

DefaultProperties
{	
	InputEventIDs.Add( "Visualizer_AbilityHit" )
	InputEventIDs.Add( "Visualizer_ProjectileHit" )
	TimeoutSeconds = 15.0;
}
