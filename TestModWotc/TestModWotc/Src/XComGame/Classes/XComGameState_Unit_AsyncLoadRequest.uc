
class XComGameState_Unit_AsyncLoadRequest extends AsynchronousLoadRequest;


var string ArchetypeName;

var vector UseLocation;
var rotator UseRotation;
var int NumContentRequests;
var bool bForceMenuState;
var array<string> ArchetypesToLoad;

var bool bIsComplete;

var XComUnitPawn UnitPawnArchetype;

var array<Object> LoadedObjects;

var delegate<OnUnitPawnCreated> PawnCreatedCallback;

var delegate<OnAsyncLoadComplete_UnitCallbackDelegate> OnAsyncLoadComplete_UnitCallback;

delegate OnAsyncLoadComplete_UnitCallbackDelegate(XComGameState_Unit_AsyncLoadRequest asyncRequest);
delegate OnUnitPawnCreated(XComGameState_Unit Unit);

function OnObjectLoaded(Object LoadedObject)
{
	LoadedObjects.AddItem(LoadedObject);

	if (LoadedObjects.Length == NumContentRequests)
	{
		OnAsyncLoadComplete_UnitCallback(self);
		bIsComplete = true;
	}    
}

defaultProperties
{
    bForceMenuState = false;
    bIsComplete = false;
}