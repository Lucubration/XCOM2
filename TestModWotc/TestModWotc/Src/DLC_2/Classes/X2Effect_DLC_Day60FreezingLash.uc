//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_DLC_Day60FreezingLash.uc
//  AUTHOR:  Michael Donovan
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2Effect_DLC_Day60FreezingLash extends X2Effect;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit SourceUnitState, TargetUnitState;
	local XComGameStateHistory History;
	local XComWorldData World;
	local TTIle TeleportToTile;
	local Vector PreferredDirection;
	local X2EventManager EventManager;

	History = `XCOMHISTORY;
	World = `XWORLD;

	SourceUnitState = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	`assert(SourceUnitState != none);
	TargetUnitState = XComGameState_Unit(kNewTargetState);
	`assert(TargetUnitState != none);

	PreferredDirection = Normal(World.GetPositionFromTileCoordinates(TargetUnitState.TileLocation) - World.GetPositionFromTileCoordinates(SourceUnitState.TileLocation));

	if( class'X2Helpers_DLC_Day60'.static.FindAvailableMidpointTile(SourceUnitState.TileLocation, TargetUnitState.TileLocation, PreferredDirection, TeleportToTile) )
	{
		EventManager = `XEVENTMGR;

		// Move the target to this space
		TargetUnitState.SetVisibilityLocation(TeleportToTile);

		EventManager.TriggerEvent('ObjectMoved', TargetUnitState, TargetUnitState, NewGameState);
		EventManager.TriggerEvent('UnitMoveFinished', TargetUnitState, TargetUnitState, NewGameState);
	}
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
	local XComGameState_Unit TargetUnitState;
	local vector NewUnitLoc;
	local X2Action_DLC_Day60FreezingLashTarget FreezingLashTarget;

	TargetUnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
	`assert(TargetUnitState != none);

	// Move the target to this space
	if( EffectApplyResult == 'AA_Success' )
	{
		FreezingLashTarget = X2Action_DLC_Day60FreezingLashTarget(class'X2Action_DLC_Day60FreezingLashTarget'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		NewUnitLoc = `XWORLD.GetPositionFromTileCoordinates(TargetUnitState.TileLocation);
		FreezingLashTarget.SetDesiredLocation(NewUnitLoc, XGUnit(ActionMetadata.VisualizeActor));
	}
}