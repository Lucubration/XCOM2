//---------------------------------------------------------------------------------------
//  FILE:    X2Action_LootDestruction.uc
//  AUTHOR:  Dan Kaplan
//  DATE:    5/25/2015
//  PURPOSE: Visualization for Loot Destruction.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Action_LootDestruction extends X2Action;

//Cached info for the unit performing the action and the target object
//*************************************

// the distance above the original starting position that the loot will rise as it is being destructed
var float						LootDestructZOffset;

// The length of time it will take each loot item to be destructed
var float						LootDestructTime;

var float						LootStartTimeSeconds;
var Vector						LootStartLoc;
var Vector						TargetLocation;

var array<Actor>				LootVisActors;
var array<int>					LootVisActorsObjectIDs;

var Lootable					LootableObjectState;

//*************************************

function Init()
{
	local XComGameStateHistory History;
	local array<StateObjectReference> LootItemRefs;
	local Actor LootVisActor;
	local int LootObjectID;

	super.Init();
	
	History = `XCOMHISTORY;

	// select the loot items based on what previously existed in the old state of the lootable
	LootableObjectState = Lootable(Metadata.StateObject_OldState);
	LootItemRefs = LootableObjectState.GetAvailableLoot();

	// update loot sparkles based on the new state of the lootable
	LootableObjectState = Lootable(Metadata.StateObject_NewState);

	while( LootItemRefs.Length > 0 )
	{
		LootObjectID = LootItemRefs[LootItemRefs.Length - 1].ObjectID;
		LootVisActor = History.GetVisualizer(LootObjectID);
		if( LootVisActor != None )
		{
			LootVisActors.AddItem(LootVisActor);
			LootVisActorsObjectIDs.AddItem(LootObjectID);

			// have to clear the visualizer from the map, since it is about to be destroyed
			History.SetVisualizer(LootObjectID, None);

		}
		LootItemRefs.Remove(LootItemRefs.Length - 1, 1);
	}
}

function bool IsTimedOut()
{
	return false;
}

//------------------------------------------------------------------------------------------------
simulated state Executing
{
	function BeginDestruct()
	{
		local ParticleSystemComponent FXComponent;
		local XComGameState_Item LootItemState;
		local X2ItemTemplate ItemTemplate;
		local XComGameStateHistory History;
		local XComTacticalController TacticalController;
		local XGUnit ActiveUnit;
		local XComGameState_Unit SelectedUnit;
		local float ParameterValue;
		local Vector VectorValue;

		History = `XCOMHISTORY;

		if( LootVisActors.Length > 0 )
		{
			LootVisActors[0].SetPhysics(PHYS_Interpolating);
			LootStartTimeSeconds = WorldInfo.TimeSeconds;
			LootStartLoc = LootVisActors[0].Location;
			TargetLocation = LootStartLoc;
			TargetLocation.Z += LootDestructZOffset;

			LootItemState = XComGameState_Item(History.GetGameStateForObjectID(LootVisActorsObjectIDs[0]));
			ItemTemplate = LootItemState.GetMyTemplate();
			if( ItemTemplate.LootParticleSystemEnding != None )
			{
				foreach LootVisActors[0].AllOwnedComponents(class'ParticleSystemComponent', FXComponent)
				{
					// Jwats: Swap the particles for the ending particle system
					LootVisActors[0].DetachComponent(FXComponent);
					FXComponent = class'WorldInfo'.static.GetWorldInfo().MyEmitterPool.SpawnEmitter(ItemTemplate.LootParticleSystemEnding, LootVisActors[0].Location, LootVisActors[0].Rotation, LootVisActors[0]);
					LootVisActors[0].AttachComponent(FXComponent);

					TacticalController = XComTacticalController(`XWORLDINFO.GetALocalPlayerController());
					ActiveUnit = TacticalController.GetActiveUnit();
					SelectedUnit = XComGameState_Unit(History.GetGameStateForObjectID(ActiveUnit.ObjectID));
					if( SelectedUnit != None )
					{
						ParameterValue = SelectedUnit.GetSoldierClassTemplateName() == 'Templar' ? 1.0f : 0.0f;
						VectorValue.X = ParameterValue;
						VectorValue.Y = ParameterValue;
						VectorValue.Z = ParameterValue;
						FXComponent.SetVectorParameter('Templar', VectorValue);
						FXComponent.SetFloatParameter('Templar', ParameterValue);

						// Jwats: Don't interpolate but allow it to destroy for 2.3 seconds
						TargetLocation = LootStartLoc;
						LootDestructTime = 2.3f;
					}
					break;
				}
			}
		}
	}

	function UpdateDestruct()
	{
		local float TimeSinceStart;
		local float Alpha;

		TimeSinceStart = WorldInfo.TimeSeconds - LootStartTimeSeconds;

		if( TimeSinceStart >= LootDestructTime )
		{
			LootVisActors[0].Destroy();
			LootVisActors.Remove(0, 1);
			LootVisActorsObjectIDs.Remove(0, 1);
			BeginDestruct();
		}
		else
		{
			Alpha = TimeSinceStart / LootDestructTime;
			LootVisActors[0].SetLocation(VLerp(LootStartLoc, TargetLocation, Alpha));
		}
	}

Begin:
	LootableObjectState.UpdateLootSparklesEnabled(false);

	BeginDestruct();
	while( LootVisActors.Length > 0 )
	{
		UpdateDestruct();
		Sleep(0.001f);
	}

	CompleteAction();
}

defaultproperties
{
	LootDestructTime = 0.25  //todo - shorten this
	LootStartTimeSeconds = -1.0
	LootDestructZOffset = 50.0
}

