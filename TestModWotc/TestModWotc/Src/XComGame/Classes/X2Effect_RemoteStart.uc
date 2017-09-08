//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_RemoteStart.uc
//  AUTHOR:  Joshua Bouscher  --  8/10/2016
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Effect_RemoteStart extends X2Effect;

var() float UnitDamageMultiplier;
var() float DamageRadiusMultiplier;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Destructible DestructibleState;
	local XComDestructibleActor Actor;
	local XComGameState_EnvironmentDamage NewDamageEvent;
	local XComDestructibleActor_Action_RadialDamage DamageAction;
	local XComDestructibleActor_Action_PlayEffectCue EffectCueAction;
	local int i;

	DestructibleState = XComGameState_Destructible(kNewTargetState);
	Actor = XComDestructibleActor(DestructibleState.GetVisualizer());

	`assert(Actor != none);

	for (i = 0; i < Actor.DestroyedEvents.Length; ++i)
	{
		if (Actor.DestroyedEvents[i].Action != None)
		{
			DamageAction = XComDestructibleActor_Action_RadialDamage(Actor.DestroyedEvents[i].Action);
			if (DamageAction != none)
			{
				DamageAction.UnitDamage *= UnitDamageMultiplier;
				DamageAction.DamageTileRadius *= DamageRadiusMultiplier;
			}
			EffectCueAction = XComDestructibleActor_Action_PlayEffectCue(Actor.DestroyedEvents[i].Action);
			if (EffectCueAction != none && EffectCueAction.bAllowRemoteStartScaleAdjustment)
			{
				EffectCueAction.ScaleAdjustment *= DamageRadiusMultiplier;
			}
		}
	}

	NewDamageEvent = XComGameState_EnvironmentDamage(NewGameState.CreateNewStateObject(class'XComGameState_EnvironmentDamage'));
	NewDamageEvent.DEBUG_SourceCodeLocation = "UC: X2Effect_RemoteStart:OnEffectAdded()";
	NewDamageEvent.HitLocation = Actor.Location;
	NewDamageEvent.DamageSource.ObjectID = ApplyEffectParameters.SourceStateObjectRef.ObjectID;
	NewDamageEvent.DestroyedActors.AddItem(Actor.GetActorId());
	NewDamageEvent.DamageTiles.AddItem(DestructibleState.TileLocation);

	DestructibleState.DestroyedByRemoteStartShooter = ApplyEffectParameters.SourceStateObjectRef;
	DestructibleState.ForceDestroyed(NewGameState, NewDamageEvent);
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local ActorIdentifier ActorID;
	local XComDestructibleActor Destructible;
	local XComGameState_Destructible DestructibleState;
	local XComGameState_EnvironmentDamage DamageEvent;
	local XComGameState_EnvironmentDamage FallbackDamageEvent;

	super.AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, EffectApplyResult);

	DestructibleState = XComGameState_Destructible(ActionMetadata.StateObject_NewState);

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_EnvironmentDamage', DamageEvent)
	{
		foreach DamageEvent.DestroyedActors(ActorID)
		{
			Destructible = `XWORLD.FindDestructibleActor(ActorId);

			if (Destructible.ObjectID == DestructibleState.ObjectID)
			{
				ActionMetadata.StateObject_OldState = DamageEvent;
				ActionMetadata.StateObject_NewState = DamageEvent;

				class'X2Action_ApplyWeaponDamageToTerrain'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext());//auto-parent to fire action

				return;
			}
		}

		FallbackDamageEvent = DamageEvent;
	}

	//Fallback - in situations where the destructible actor couldn't be resolved... just set up events based on the damage event. If there is one.
	if (ActionMetadata.LastActionAdded == none && FallbackDamageEvent != none)
	{
		ActionMetadata.StateObject_OldState = FallbackDamageEvent;
		ActionMetadata.StateObject_NewState = FallbackDamageEvent;

		class'X2Action_ApplyWeaponDamageToTerrain'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext());//auto-parent to fire action
	}
}

simulated function bool IsExplosiveDamage() { return true; }