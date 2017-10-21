//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_WaitForAnotherAction extends X2Action;

var X2Action ActionToWaitFor;

function Init()
{
	local X2EventManager EventManager;
	local int ScanEvent;
	local Object ThisObj;

	super.Init();

	EventManager = `XEVENTMGR;
	ThisObj = self;

	// Jwats: Register to ActionToWaitFor events
	if( ActionToWaitFor != None )
	{
		for( ScanEvent = 0; ScanEvent < InputEventIDs.Length; ++ScanEvent )
		{
			EventManager.RegisterForEvent(ThisObj, InputEventIDs[ScanEvent], OnEventFromActionToWaitFor, , , ActionToWaitFor);
		}
	}
}

function EventListenerReturn OnEventFromActionToWaitFor(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	CompleteAction();
	return ELR_NoInterrupt;
}

//------------------------------------------------------------------------------------------------
simulated state Executing
{
Begin:
	while( ActionToWaitFor != None && !ActionToWaitFor.bCompleted )
	{
		Sleep(0.0f);
	}

	CompleteAction();
}

DefaultProperties
{	
	InputEventIDs.Add("Visualizer_AbilityHit")
	InputEventIDs.Add("Visualizer_ProjectileHit")
	TimeoutSeconds=60
}
