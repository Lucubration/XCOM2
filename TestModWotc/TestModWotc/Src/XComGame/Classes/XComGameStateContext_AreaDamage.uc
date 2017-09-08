//---------------------------------------------------------------------------------------
//  FILE:    XComGameStateContext_AreaDamage.uc
//  AUTHOR:  Ryan McFall, David Burchanowski  --  3/5/2014
//  PURPOSE: This context is used with damage events that require their own game state
//           object. IE. Kismet driven damage.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameStateContext_AreaDamage extends XComGameStateContext
	native(Core);

function bool Validate(optional EInterruptionStatus InInterruptionStatus) 
{
	return true;
}

function XComGameState ContextBuildGameState()
{
	// this class isn't meant to be used with SubmitGameStateContext. Use plain vanilla SubmitGameState + manually building the game state instead. 
	// ContextBuildVisualization IS STILL USED to create the necessary tracks to show damage occurring
	`assert(false);
	return none;
}

protected function ContextBuildVisualization()
{
	local XComGameStateHistory History;
	local VisualizationActionMetadata ActionMetadata;
	local VisualizationActionMetadata EmptyTrack;
	local XComGameState_EnvironmentDamage DamageEventStateObject;
	local XComGameState_Unit UnitObject;
	local XComGameState_WorldEffectTileData TileDataStateObject;
	local XComGameState_Destructible DestructibleStateObject;
	local X2Effect ApplyEffect;
	local X2Action_WaitForDestructibleActorActionTrigger WaitForTriggerAction;
	local X2Action_WaitForWorldDamage WaitForWorldDamageAction;
	local X2Action_Delay DelayAction;
	local int FirstDamageSource;
	local bool bCausedByDestructible;
	local X2VisualizerInterface TargetVisualizerInterface;
	local XComGameStateContext VisualizingWithContext;
	local bool bShouldWaitForWorldDamage;
	local X2Action_UpdateUI UpdateUI;

	History = `XCOMHISTORY;

	//Look up the context we're visualizing with - if it's an ability context, we should wait for it.
	if (DesiredVisualizationBlockIndex != -1)
	{
		VisualizingWithContext = History.GetGameStateFromHistory(DesiredVisualizationBlockIndex).GetContext();
		if (XComGameStateContext_Ability(VisualizingWithContext) != None)
			bShouldWaitForWorldDamage = true;
	}

	// add visualization of environment damage
	foreach AssociatedState.IterateByClassType(class'XComGameState_EnvironmentDamage', DamageEventStateObject)
	{
		ActionMetadata = EmptyTrack;
		ActionMetadata.StateObject_OldState = DamageEventStateObject;
		ActionMetadata.StateObject_NewState = DamageEventStateObject;

		if (FirstDamageSource == 0)
		{
			FirstDamageSource = DamageEventStateObject.DamageSource.ObjectID;
			bCausedByDestructible = XComDestructibleActor(History.GetVisualizer(FirstDamageSource)) != None;
		}

		if(bCausedByDestructible)
		{
			WaitForTriggerAction = X2Action_WaitForDestructibleActorActionTrigger(class'X2Action_WaitForDestructibleActorActionTrigger'.static.AddToVisualizationTree(ActionMetadata, self));
			WaitForTriggerAction.SetTriggerParameters(class'XComDestructibleActor_Action_RadialDamage', FirstDamageSource);
		}
		else if (bShouldWaitForWorldDamage)
		{
			WaitForWorldDamageAction = X2Action_WaitForWorldDamage(class'X2Action_WaitForWorldDamage'.static.AddToVisualizationTree(ActionMetadata, self));
			WaitForWorldDamageAction.bIgnoreIfPriorWaitFound = true;
		}

		// Jwats: if we added a wait set it as our parent.
		class'X2Action_ApplyWeaponDamageToTerrain'.static.AddToVisualizationTree(ActionMetadata, self, false, ActionMetadata.LastActionAdded);
			
	}

	// add visualization of all damaged units
	foreach AssociatedState.IterateByClassType(class'XComGameState_Unit', UnitObject)
	{
		ActionMetadata = EmptyTrack;
		ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(UnitObject.ObjectID,, AssociatedState.HistoryIndex - 1);
		ActionMetadata.StateObject_NewState = UnitObject;
		ActionMetadata.VisualizeActor = UnitObject.GetVisualizer();

		if(bCausedByDestructible)
		{
			WaitForTriggerAction = X2Action_WaitForDestructibleActorActionTrigger(class'X2Action_WaitForDestructibleActorActionTrigger'.static.AddToVisualizationTree(ActionMetadata, self));
			WaitForTriggerAction.SetTriggerParameters(class'XComDestructibleActor_Action_RadialDamage', FirstDamageSource);

			//Add a delay in so that they appear caught in the explosion
			DelayAction = X2Action_Delay(class'X2Action_Delay'.static.AddToVisualizationTree(ActionMetadata, self));
			DelayAction.Duration = 0.5f;
		}
		else if (bShouldWaitForWorldDamage)
		{
			WaitForWorldDamageAction = X2Action_WaitForWorldDamage(class'X2Action_WaitForWorldDamage'.static.AddToVisualizationTree(ActionMetadata, self));
			WaitForWorldDamageAction.bIgnoreIfPriorWaitFound = true;
		}
		
		class'X2Action_ApplyWeaponDamageToUnit'.static.AddToVisualizationTree(ActionMetadata, self, false, ActionMetadata.LastActionAdded);

		//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
		TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
		if (TargetVisualizerInterface != none)
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(AssociatedState, ActionMetadata);

			
	}

	foreach AssociatedState.IterateByClassType(class'XComGameState_Destructible', DestructibleStateObject)
	{
		ActionMetadata = EmptyTrack;
		ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(DestructibleStateObject.ObjectID,, AssociatedState.HistoryIndex - 1);
		ActionMetadata.StateObject_NewState = DestructibleStateObject;
		ActionMetadata.VisualizeActor = DestructibleStateObject.GetVisualizer();

		if(bCausedByDestructible)
		{
			WaitForTriggerAction = X2Action_WaitForDestructibleActorActionTrigger(class'X2Action_WaitForDestructibleActorActionTrigger'.static.AddToVisualizationTree(ActionMetadata, self));
			WaitForTriggerAction.SetTriggerParameters(class'XComDestructibleActor_Action_RadialDamage', FirstDamageSource);

			//Add a delay in so that they appear caught in the explosion
			DelayAction = X2Action_Delay(class'X2Action_Delay'.static.AddToVisualizationTree(ActionMetadata, self));
			DelayAction.Duration = 0.5f;
		}
		else if (bShouldWaitForWorldDamage)
		{
			WaitForWorldDamageAction = X2Action_WaitForWorldDamage(class'X2Action_WaitForWorldDamage'.static.AddToVisualizationTree(ActionMetadata, self));
			WaitForWorldDamageAction.bIgnoreIfPriorWaitFound = true;
		}

		class'X2Action_ApplyWeaponDamageToTerrain'.static.AddToVisualizationTree(ActionMetadata, AssociatedState.GetContext(), , ActionMetadata.LastActionAdded );
		UpdateUI = X2Action_UpdateUI( class'X2Action_UpdateUI'.static.AddToVisualizationTree(ActionMetadata, AssociatedState.GetContext(), , ActionMetadata.LastActionAdded ) );
		UpdateUI.UpdateType = EUIUT_UnitFlag_Health;
		UpdateUI.SpecificID = DestructibleStateObject.ObjectID;
	}
	
	foreach AssociatedState.IterateByClassType(class'XComGameState_WorldEffectTileData', TileDataStateObject)
	{
		ActionMetadata = EmptyTrack;
		ActionMetadata.StateObject_OldState = TileDataStateObject;
		ActionMetadata.StateObject_NewState = TileDataStateObject;

		if( TileDataStateObject.StoredTileData.Length > 0 )
		{
			//Assume that effect names are the same for each tile
			ApplyEffect = X2Effect(class'Engine'.static.FindClassDefaultObject(string(TileDataStateObject.StoredTileData[0].Data.EffectName)));
			if( ApplyEffect != none )
			{
				if(bCausedByDestructible)
				{
					WaitForTriggerAction = X2Action_WaitForDestructibleActorActionTrigger(class'X2Action_WaitForDestructibleActorActionTrigger'.static.AddToVisualizationTree(ActionMetadata, self));
					WaitForTriggerAction.SetTriggerParameters(class'XComDestructibleActor_Action_RadialDamage', FirstDamageSource);
				}
				else if (bShouldWaitForWorldDamage)
				{
					WaitForWorldDamageAction = X2Action_WaitForWorldDamage(class'X2Action_WaitForWorldDamage'.static.AddToVisualizationTree(ActionMetadata, self));
					WaitForWorldDamageAction.bIgnoreIfPriorWaitFound = true;
				}

				ApplyEffect.AddX2ActionsForVisualization(AssociatedState, ActionMetadata, 'AA_Success');
			}
			else
			{
				`redscreen("UpdateWorldEffects context failed to build visualization, could not resolve class from name:"@TileDataStateObject.StoredTileData[0].Data.EffectName@"!");
			}

			
		}
	}	
}

function MergeIntoVisualizationTree(X2Action BuildTree, out X2Action VisualizationTree)
{
	local array<X2Action> WaitForDestructibleActorActionTrigger_NodesToMove;
	local array<X2Action> WaitForWorldDamage_NodesToMove;
	local XComGameStateVisualizationMgr VisMgr;	

	//Get the list of nodes for us to reparent from build tree before it is merged with the vis tree at large. We don't want to 
	//go reparenting nodes that have nothing to do with this visualization sequence.
	VisMgr = `XCOMVISUALIZATIONMGR;
	VisMgr.GetNodesOfType(BuildTree, class'X2Action_WaitForDestructibleActorActionTrigger', WaitForDestructibleActorActionTrigger_NodesToMove);
	VisMgr.GetNodesOfType(BuildTree, class'X2Action_WaitForWorldDamage', WaitForWorldDamage_NodesToMove);

	// Jwats: Now disconnect any of the destructible waits and connect them to the root so they start immediately
	MergeHelper(VisMgr, WaitForDestructibleActorActionTrigger_NodesToMove, BuildTree);
	MergeHelper(VisMgr, WaitForWorldDamage_NodesToMove, BuildTree);

	SetAssociatedPlayTiming( SPT_BeforeParallel );
	Super.MergeIntoVisualizationTree(BuildTree, VisualizationTree);
}

function MergeHelper(XComGameStateVisualizationMgr VisMgr, const out Array<X2Action> NodesToMove, out X2Action VisualizationTree)
{
	local int ScanNodes;
	local X2Action CurrentAction;

	for( ScanNodes = 0; ScanNodes < NodesToMove.Length; ++ScanNodes )
	{
		CurrentAction = NodesToMove[ScanNodes];
		VisMgr.DisconnectAction(CurrentAction);
		VisMgr.ConnectAction(CurrentAction, VisualizationTree, false, VisualizationTree);
	}
}

function string SummaryString()
{
	return "XComGameStateContext_AreaDamage";
}