
//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    XComGameState_AIBlackboard.uc    
//  AUTHOR:  Alex Cheng  --  6/2/2016
//  PURPOSE: Simple Blackboard system to hold values for shared AI knowledge.  
//   (Currently stores only int values. Can be expanded to store other data types.)
//  (Also currently holds key objective info pertinent to the AI-controlled player for AutoRuns.)
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_AIBlackboard extends XComGameState_BaseObject
	native(AI)
	config(AI);

// Generic String to Int mapping used by kismet actions to store persistent data
var native Map_Mirror IntKVP{TMap<FString, INT>};

struct native ObjectivePriority
{
	var String Tag;				// Name of the objective.
	var float PriorityValue;		// Priority value of the objective.  Set as float so values can be inserted easily.  Any negative numbers are added, unsorted, to the end of the list after any positive values.
};
var config array<ObjectivePriority> PrioritizedObjectives;

simulated native function int GetKeyValue(string key);
simulated native function SetKeyValue(string key, INT Value);

// When called, the visualized object must create it's visualizer if needed, 
function Actor FindOrCreateVisualizer( optional XComGameState Gamestate = none )
{
	return none;
}

// Ensure that the visualizer visual state is an accurate reflection of the state of this object.
function SyncVisualizer( optional XComGameState GameState = none )
{
}

function OnBeginTacticalPlay(XComGameState NewGameState)
{
	local X2EventManager EventManager;
	local Object ThisObj;

	super.OnBeginTacticalPlay(NewGameState);

	EventManager = `XEVENTMGR;
	ThisObj = self;
	EventManager.RegisterForEvent(ThisObj, 'AIBlackboardCreated', OnAIBlackboardCreated, ELD_OnStateSubmitted, , ThisObj);
	EventManager.TriggerEvent('AIBlackboardCreated', ThisObj, ThisObj, NewGameState);
	EventManager.RegisterForEvent(ThisObj, 'ForceVIPAcquisition', OnObjectiveComplete, ELD_OnStateSubmitted);
	EventManager.RegisterForEvent(ThisObj, 'MissionObjectiveMarkedCompleted', OnObjectiveComplete, ELD_OnStateSubmitted);
	EventManager.RegisterForEvent(ThisObj, 'MissionObjectiveMarkedFailed', OnObjectiveComplete, ELD_OnStateSubmitted);
	EventManager.RegisterForEvent(ThisObj, 'EvacZonePlaced', OnObjectiveComplete, ELD_OnStateSubmitted);
}

function OnEndTacticalPlay(XComGameState NewGameState)
{
	local X2EventManager EventManager;
	local Object ThisObj;

	super.OnEndTacticalPlay(NewGameState);

	EventManager = `XEVENTMGR;
	ThisObj = self;
	//EventManager.UnRegisterFromEvent(ThisObj, 'AIBlackboardCreated');
	EventManager.UnRegisterFromEvent(ThisObj, 'ForceVIPAcquisition');
	EventManager.UnRegisterFromEvent(ThisObj, 'MissionObjectiveMarkedCompleted');
	EventManager.UnRegisterFromEvent(ThisObj, 'MissionObjectiveMarkedFailed');
	EventManager.UnRegisterFromEvent(ThisObj, 'EvacZonePlaced');
}

// This is called after this Blackboard spawner has finished construction
function EventListenerReturn OnAIBlackboardCreated(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	UpdateObjectiveData();
	return ELR_NoInterrupt;
}

function EventListenerReturn OnObjectiveComplete(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_ObjectivesList ObjectiveList;
	ObjectiveList = XComGameState_ObjectivesList(EventData);
	UpdateObjectiveData(ObjectiveList);
	return ELR_NoInterrupt;
}

function XComGameState_ObjectiveInfo GetPriorityObjective(array<XComGameState_ObjectiveInfo> Objectives)
{
	local array<XComGameState_ObjectiveInfo> SortedObjectives;
	local array<float> SortedObjectivesPriorityValue;
	local XComGameState_ObjectiveInfo Objective;
	local int Index;
	local float PriorityValue;
	local bool bInserted;

	foreach Objectives(Objective)
	{
		bInserted = false;
		Index = PrioritizedObjectives.Find('Tag', Objective.OSPSpawnTag);
		if( Index == INDEX_NONE)
		{
			SortedObjectives.AddItem(Objective);
			SortedObjectivesPriorityValue.AddItem(-1);
			bInserted = true;
			`LogAI("Priority of OSP Tag "$Objective.OSPSpawnTag@"Not listed in configuration file XComAI.ini - Adding as lowest priority.");
		}
		else
		{
			PriorityValue = PrioritizedObjectives[Index].PriorityValue;
			for( Index = 0; Index < SortedObjectives.Length; ++Index )
			{
				if( PriorityValue < SortedObjectivesPriorityValue[Index] || SortedObjectivesPriorityValue[Index] < 0)  // Positive numbers get priority over negative numbers
				{
					SortedObjectivesPriorityValue.InsertItem(Index, PriorityValue);
					SortedObjectives.InsertItem(Index, Objective);
					bInserted = true;
					break;
				}
			}
		}
		if( !bInserted )
		{
			SortedObjectives.AddItem(Objective);
			SortedObjectivesPriorityValue.AddItem(PriorityValue);
			bInserted = true;
		}
	}
	if( SortedObjectives.Length != Objectives.Length || SortedObjectives.Length < 1 )
	{
		`RedScreen("Objectives sorting error!  @acheng");
	}
	return SortedObjectives[0];
}

function UpdateObjectiveData(optional XComGameState_ObjectivesList ObjectiveList)
{
	local X2AutoPlayManager AutoPlayMgr;
	local XComGameStateHistory History;
	local XComGameState_ObjectiveInfo ObjectiveInfo;
	local XComGameState_Unit ObjectiveUnit;
	local XComGameState_InteractiveObject ObjectiveObject, ObjectiveDoor;
	local Actor ObjectiveActor;
	local int ObjectiveID, ObjectiveDoorID;
	local array<XComGameState_ObjectiveInfo> Objectives;
	local TTile TileLocation, DoorTile;
	local ObjectiveSpawnPossibility OSP;
	local XComInteractiveLevelActor OSPLockedActor;
	local XComGameState NewGameState;
	local XComGameState_AIBlackboard NewBlackboardState;
	local X2GameRuleset Ruleset;
	//local bool bIsObjectiveDoor;

	AutoPlayMgr = `AUTOPLAYMGR;
	AutoPlayMgr.GetObjectivesList(Objectives);
	if( Objectives.Length > 1 )
	{
		ObjectiveInfo = GetPriorityObjective(Objectives);
	}
	else if( Objectives.Length == 1 )
	{
		ObjectiveInfo = Objectives[0];
	}

	if( ObjectiveInfo != None )
	{
		History = `XCOMHISTORY;
		ObjectiveID = INDEX_NONE;
		ObjectiveDoorID = INDEX_NONE;
		`Log("Active Objective: "$ObjectiveInfo.OSPSpawnTag);

		// First look for any locked door or hackable objects that we need to pass.
		foreach `XCOMGAME.AllActors(class'ObjectiveSpawnPossibility', OSP)
		{
			if( OSP.bBeenUsed )
			{
				OSPLockedActor = OSP.AssociatedObjectiveActor;
				if( OSPLockedActor != None )
				{
					ObjectiveDoor = OSPLockedActor.GetInteractiveState();
					ObjectiveDoorID = ObjectiveDoor.ObjectID;
					DoorTile = ObjectiveDoor.TileLocation;
					break;
				}
			}
		}

		ObjectiveUnit = XComGameState_Unit(ObjectiveInfo.FindComponentObject(class'XComGameState_Unit', true));
		ObjectiveObject = XComGameState_InteractiveObject(ObjectiveInfo.FindComponentObject(class'XComGameState_InteractiveObject', true));
		ObjectiveActor = History.GetVisualizer(ObjectiveInfo.ObjectID);

		if( ObjectiveUnit != None )
		{
			ObjectiveID = ObjectiveUnit.ObjectID;
			TileLocation = ObjectiveUnit.TileLocation;
		}
		else if( ObjectiveObject != None )
		{
			ObjectiveID = ObjectiveObject.ObjectID;
			TileLocation = ObjectiveObject.TileLocation;
		}
		else if( ObjectiveActor != None )
		{
			// not a special object, just look at the actor
			ObjectiveID = ObjectiveInfo.ObjectID;
			TileLocation = `XWORLD.GetTileCoordinatesFromPosition(ObjectiveActor.Location);
		}

		if( ObjectiveID > 0 )
		{
			if( GetKeyValue("ObjectiveID") != ObjectiveID
			   || GetKeyValue("ObjectiveTileX") != TileLocation.X
			   || GetKeyValue("ObjectiveTileY") != TileLocation.Y
			   || GetKeyValue("ObjectiveTileZ") != TileLocation.Z
			   || GetKeyValue("ObjectiveDoorID") != ObjectiveDoorID
			   || GetKeyValue("ObjectiveDoorTileX") != DoorTile.X
			   || GetKeyValue("ObjectiveDoorTileY") != DoorTile.Y
			   || GetKeyValue("ObjectiveDoorTileZ") != DoorTile.Z

			   )

			{
				Ruleset = `XCOMGAME.GameRuleset;
				NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("AIBlackboardUpdateObjectiveData");
				NewBlackboardState = XComGameState_AIBlackboard(NewGameState.ModifyStateObject(class'XComGameState_AIBlackboard', ObjectID));
				NewBlackboardState.SetKeyValue("ObjectiveID", ObjectiveID);
				NewBlackboardState.SetKeyValue("ObjectiveTileX", TileLocation.X);
				NewBlackboardState.SetKeyValue("ObjectiveTileY", TileLocation.Y);
				NewBlackboardState.SetKeyValue("ObjectiveTileZ", TileLocation.Z);
				NewBlackboardState.SetKeyValue("ObjectiveDoorID", ObjectiveDoorID);
				NewBlackboardState.SetKeyValue("ObjectiveDoorTileX", DoorTile.X);
				NewBlackboardState.SetKeyValue("ObjectiveDoorTileY", DoorTile.Y);
				NewBlackboardState.SetKeyValue("ObjectiveDoorTileZ", DoorTile.Z);
				Ruleset.SubmitGameState(NewGameState);
			}
		}
	}
}

cpptext
{
	// UObject interface
	virtual void Serialize(FArchive& Ar);
}

defaultproperties
{
	bTacticalTransient=true
}

