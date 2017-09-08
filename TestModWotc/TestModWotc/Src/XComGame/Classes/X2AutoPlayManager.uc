//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    X2AutoPlayManager.uc    
//  AUTHOR:  Alex Cheng  --  5/18/2016
//  PURPOSE: System responsible for automating XCom soldiers to play certain tactical missions.
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2AutoPlayManager extends Object
	native(AI)
	config(AutoPlay);

// MissionAutoPlay - Defines a list of jobs to fill per Mission Type.
struct native MissionAutoPlay
{
	var String MissionType;					// Should correspond to an existing mission type from XComTacticalMissionManager
	var bool AutoPlayAllowed;				// Specify if AutoPlay is allowed on this mission type.
};

var config array<MissionAutoPlay> AutoPlayMissions; // Define what missions are valid for autoplay.
var bool AutoRunSoldiers;
var int ObjectiveUnitID, ObjectiveObjectID;
var vector ObjectiveLocation;
var bool bHasObjectiveLocation;

native static function X2AutoPlayManager GetAutoPlayManager();

static function bool IsMissionValidForAutoRun()
{
	local string CurrentMissionType;
	local int MissionIndex;
	local bool bAllowed;
	CurrentMissionType = `TACTICALMISSIONMGR.ActiveMission.sType;
	MissionIndex = default.AutoPlayMissions.Find('MissionType', CurrentMissionType);
	if( MissionIndex == INDEX_NONE )
	{
		`RedScreen("Current mission type ("$CurrentMissionType$") not listed in file DefaultAutoPlay.ini!  @acheng");
	}
	else
	{
		bAllowed = default.AutoPlayMissions[MissionIndex].AutoPlayAllowed;
	}
	return bAllowed;
}

static function String GetRandomValidMissionTypeForAutoRun()
{
	local int RandIndex;

	do {
		RandIndex = `SYNC_RAND_STATIC( default.AutoPlayMissions.Length );
	} until( default.AutoPlayMissions[ RandIndex ].AutoPlayAllowed );

	return default.AutoPlayMissions[ RandIndex ].MissionType;
}

function bool GetObjectivesList(out array<XComGameState_ObjectiveInfo> ObjectiveInfos)
{
	local XComGameStateHistory History;
	local XComTacticalMissionManager MissionManager;
	local string MissionType;
	local XComGameState_ObjectiveInfo ObjectiveInfo;
	local XComGameState_Unit ObjectiveUnit;
	local XComGameState_InteractiveObject ObjectiveObject;
	local actor ObjectiveActor;
	local bool UnitSet, ObjectSet, ActorSet;
	local TTile Tile;

	History = `XCOMHISTORY;
	MissionManager = `TACTICALMISSIONMGR;
	MissionType = MissionManager.ActiveMission.sType;

	// get all objectives that are valid for this map
	foreach History.IterateByClassType(class'XComGameState_ObjectiveInfo', ObjectiveInfo)
	{
		if( MissionType == ObjectiveInfo.MissionType )
		{
			ObjectiveInfos.AddItem(ObjectiveInfo);
		}

		// now fill out the kismet vars		
		ObjectiveUnit = XComGameState_Unit(ObjectiveInfo.FindComponentObject(class'XComGameState_Unit', true));
		ObjectiveObject = XComGameState_InteractiveObject(ObjectiveInfo.FindComponentObject(class'XComGameState_InteractiveObject', true));
		ObjectiveActor = History.GetVisualizer(ObjectiveInfo.ObjectID);


		// get the location
		if( ObjectiveUnit != none )
		{
			ObjectiveUnitID = ObjectiveUnit.ObjectID;

			if( !UnitSet )
			{
				`LogAI("Objective Unit set to:"@ObjectiveUnitID);
			}
			else
			{
				`LogAI("Objective Unit OVERWRITE- Now set to:"@ObjectiveUnitID);
			}
			UnitSet = true;
			// special case units. They are special
			ObjectiveUnit.GetKeystoneVisibilityLocation(Tile);
			ObjectiveLocation = class'XComWorldData'.static.GetWorldData().GetPositionFromTileCoordinates(Tile);
		}
		else if( ObjectiveObject != None )
		{
			ObjectiveObjectID = ObjectiveObject.ObjectID;

			if( !ObjectSet )
			{
				`LogAI("Objective Object set to:"@ObjectiveObjectID);
			}
			else
			{
				`LogAI("Objective Object OVERWRITE- Now set to:"@ObjectiveObjectID);
			}
			ObjectSet = true;
			// special case interactive objects. They are special-ish
			Tile = ObjectiveObject.TileLocation;
			ObjectiveLocation = class'XComWorldData'.static.GetWorldData().GetPositionFromTileCoordinates(Tile);
		}
		else if( ObjectiveActor != None )
		{
			if( !ActorSet )
			{
				`LogAI("Objective Actor set to:"@ObjectiveInfo.ObjectID);
			}
			else
			{
				`LogAI("Objective Actor OVERWRITE- Now set to:"@ObjectiveInfo.ObjectID);
			}
			ActorSet = true;
			// not a special object, just look at the actor
			ObjectiveLocation = ObjectiveActor.Location;
			bHasObjectiveLocation = true;
		}
	}

	return ObjectiveInfos.Length > 0;
}

function ToggleAutoRun()
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local Name AutoRunBT;
	local X2EventManager EventManager;
	local XComGameState_AIGroup GroupState;
	local Object UnitObject;

	EventManager = `XEVENTMGR;

	if( AutoRunSoldiers )
	{
		AutoRunSoldiers = false;
		`Log("AutoRunSoldiers disabled.");
	}
	else if( `AUTOPLAYMGR.IsMissionValidForAutoRun() )
	{
		History = `XCOMHISTORY;
		foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
		{
			UnitObject = UnitState;
			GroupState = XComGameState_AIGroup(`XCOMHISTORY.GetGameStateForObjectID(UnitState.GroupMembershipID));
			EventManager.RegisterForEvent(UnitObject, 'UnitGroupTurnBegun', UnitState.OnGroupTurnBegin, ELD_OnStateSubmitted, , GroupState);

			AutoRunBT = Name(UnitState.GetMyTemplate().strAutoRunNonAIBT);
			if( !UnitState.ControllingPlayerIsAI() && UnitState.IsAbleToAct()
				&& UnitState.GetTeam() == eTeam_XCom && UnitState.NumActionPoints() > 0
				&& AutoRunBT != '' ) // Not in Stunned state.
			{
				UnitState.AutoRunBehaviorTree(AutoRunBT, UnitState.NumActionPoints());
			}
		}
		AutoRunSoldiers = true;
		`Log("AutoRunSoldiers enabled.");
	}
	else
	{
		`Log("AutoRunSoldiers is not valid for the current mission type!");
	}
}
defaultproperties
{
}