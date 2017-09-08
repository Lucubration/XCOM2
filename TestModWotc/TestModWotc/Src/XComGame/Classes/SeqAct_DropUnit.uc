///---------------------------------------------------------------------------------------
//  FILE:    SeqAct_DropUnit.uc
//  AUTHOR:  David Burchanowski  --  11/05/2014
//  PURPOSE: Drops a unit at the specified location
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_DropUnit extends SequenceAction
	implements(X2KismetSeqOpVisualizer);

var private XComGameState_Unit SpawnedUnit; // the unit that was dropped
var private string CharacterPoolEntry; // The character pool entry that we want to drop
var private string CharacterTemplate; // The template of the unit we want to drop (only needed if no pool entry specified)

var private Vector DropLocation; // the location to drop the unit at
var private bool SnapToFloor;
var() private Actor DropLocationActor; // allows placing a marker in the map to drop a unit at
var() private int AddToSquad;

event Activated()
{	
	local XComGameStateHistory History;
	local XComAISpawnManager SpawnManager;
	local StateObjectReference SpawnedUnitRef;
	local ETeam Team;
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_AIGroup GroupState;
	local int GroupID;

	// spawn the unit
	History = `XCOMHISTORY;

	// determine our drop location
	if(DropLocationActor != none)
	{
		DropLocation = DropLocationActor.Location;
	}
	if (SnapToFloor)
	{
		DropLocation.Z = `XWORLD.GetFloorZForPosition( DropLocation, true );
	}

	// determine the drop team
	if(InputLinks[0].bHasImpulse)
	{
		Team = eTeam_XCom;
	}
	else if(InputLinks[1].bHasImpulse)
	{
		Team = eTeam_Alien;
	}
	else if(InputLinks[2].bHasImpulse)
	{
		Team = eTeam_Neutral;
	}
	else if( InputLinks[3].bHasImpulse )
	{
		Team = eTeam_TheLost;
	}
	else if( InputLinks[4].bHasImpulse )
	{
		Team = eTeam_Resistance;
	}

	GroupID = -1;
	if (Team == eTeam_XCom)
	{
		foreach History.IterateByClassType( class'XComGameState_AIGroup', GroupState )
		{
			if (GroupState.TeamName == eTeam_XCom)
				break;
		}
		`assert( GroupState != none );

		GroupID = GroupState.ObjectID;
	}
	SpawnManager = `SPAWNMGR;
	SpawnedUnitRef = SpawnManager.CreateUnit( DropLocation, name(CharacterTemplate), Team, false,,,, CharacterPoolEntry, , , GroupID );
	SpawnedUnit = XComGameState_Unit(History.GetGameStateForObjectID(SpawnedUnitRef.ObjectID));

	if(SpawnedUnit == none)
	{
		`Redscreen("SeqAct_DropUnit failed to drop a unit. CharacterTemplate: " $ CharacterTemplate $ ", CharacterPoolEntry: " $ CharacterPoolEntry);
	}
	else if (Team == eTeam_XCom)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "SeqAct_DropUnit: Add To Squad" );

		XComHQ = XComGameState_HeadquartersXCom( History.GetSingleGameStateObjectForClass( class'XComGameState_HeadquartersXCom' ) );
		XComHQ = XComGameState_HeadquartersXCom( NewGameState.ModifyStateObject( class'XComGameState_HeadquartersXCom', XComHQ.ObjectID ) );

		if (AddToSquad >= 0 && AddToSquad < XComHQ.AllSquads.Length)
		{
			XComHQ.AllSquads[ AddToSquad ].SquadMembers.AddItem( SpawnedUnitRef );
		}
		XComHQ.Squad.AddItem( SpawnedUnitRef );
		SpawnedUnit.bMissionProvided = true;

		NewGameState.GetContext().SetAssociatedPlayTiming(SPT_AfterSequential);

		`TACTICALRULES.SubmitGameState( NewGameState );
	}
}

function BuildVisualization(XComGameState GameState)
{
	local VisualizationActionMetadata ActionMetadata;

	ActionMetadata.StateObject_OldState = SpawnedUnit;
	ActionMetadata.StateObject_NewState = SpawnedUnit;
	class'X2Action_ShowSpawnedUnit'.static.AddToVisualizationTree(ActionMetadata, GameState.GetContext());

	
}

/**
* Return the version number for this class.  Child classes should increment this method by calling Super then adding
* a individual class version to the result.  When a class is first created, the number should be 0; each time one of the
* link arrays is modified (VariableLinks, OutputLinks, InputLinks, etc.), the number that is added to the result of
* Super.GetObjClassVersion() should be incremented by 1.
*
* @return	the version number for this specific class.
*/
static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

function ModifyKismetGameState(out XComGameState GameState);

defaultproperties
{
	ObjCategory="Unit"
	ObjName="Drop Unit"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
	bAutoActivateOutputLinks=true

	AddToSquad=-1
	SnapToFloor=true

	InputLinks(0)=(LinkDesc="XCom")
	InputLinks(1)=(LinkDesc="Alien")
	InputLinks(2)=(LinkDesc="Civilian")
	InputLinks(3)=(LinkDesc="TheLost")
	InputLinks(4)=(LinkDesc="Resistance")

	VariableLinks(0)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="Spawned Unit",PropertyName=SpawnedUnit,bWriteable=true)
	VariableLinks(1)=(ExpectedType=class'SeqVar_String',LinkDesc="Pool Entry",PropertyName=CharacterPoolEntry)
	VariableLinks(2)=(ExpectedType=class'SeqVar_String',LinkDesc="Template",PropertyName=CharacterTemplate)
	VariableLinks(3)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Location",PropertyName=DropLocation)
}
