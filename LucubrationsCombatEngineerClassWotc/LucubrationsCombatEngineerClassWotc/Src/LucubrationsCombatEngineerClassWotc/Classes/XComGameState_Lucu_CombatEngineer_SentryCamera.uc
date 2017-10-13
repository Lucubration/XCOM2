class XComGameState_Lucu_CombatEngineer_SentryCamera extends XComGameState_BaseObject;

var StateObjectReference CameraRef;
var Actor FOWViewer;

//ObjectDestroyed
function EventListenerReturn OnObjectDestroyed(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Destructible EventDestructible;
	local Object ThisObj;

	EventDestructible = XComGameState_Destructible(EventData);
    if (EventDestructible != none && EventDestructible.ObjectID == CameraRef.ObjectID)
    {
        ShowFOW();

	    ThisObj = self;
	    `XEVENTMGR.UnRegisterFromEvent(ThisObj, 'ObjectDestroyed');
    }

	return ELR_NoInterrupt;
}

function HideFOW(vector Location)
{
	local XComGameStateHistory History;
    local XComGameState_Destructible Camera;

    if (FOWViewer == none)
    {
	    History = `XCOMHISTORY;

	    Camera = XComGameState_Destructible(History.GetGameStateForObjectID(CameraRef.ObjectId));

	    FOWViewer = `XWORLD.CreateFOWViewer(
            Camera.SpawnedDestructibleLocation,
            class'X2Item_Lucu_CombatEngineer_Weapons'.default.SentryCameraSightRadius);
    }
}

function ShowFOW()
{
	if (FOWViewer != none)
	{
		`XWORLD.DestroyFOWViewer(FOWViewer);
	}
}