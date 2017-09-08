//-----------------------------------------------------------
// Defines static helper methods for constructing visualizer sequences
//-----------------------------------------------------------
class X2VisualizerHelpers extends Object 
	config(Animation);

var bool bShouldUseWalkAnim; //Used in ParsePath to indicate whether the pawns should walk or run when moving along the path
var PathingInputData InputData;
var PathingResultData ResultData;
var int TilesInFog; //The goal for moves that end or start in the fog is for only the visible part of the path to exist / be shown to the player.
var X2Action_MoveBegin MoveBeginAction; //Stores the move begin action for later assignment into following actions
var X2Action_MoveDirect LastMoveDirectAction;
var X2Action LastMoveAction;
var array<X2Action> AdditionalParents;
var array<XComGameStateContext_Ability> Interrupts; //Game state contexts corresponding to points during a move where an interrupt occurred
var bool bAIMoveInterrupted; //This flag is set to TRUE for the unique situation where a group of AIs has interrupted themselves while patrolling. In this situation
						     //the interrupt markers should be added to the END of the move.
var bool bIsMoveAttack;

function Cleanup()
{
	local PathingInputData EmptyInputData;
	local PathingResultData EmptyResultData;

	//Clear data in these structures, as they may contain references we want to ditch
	InputData = EmptyInputData;
	ResultData = EmptyResultData;
}

//OutVisualizationActionMetadatas is used for special circumstances where the movement action adds other visualizers to the
//tracks via an end of move ability. Could end of move actions be refactored to be less crazy?! Probably.
static function ParsePath(const out XComGameStateContext_Ability AbilityContext, 
						  out VisualizationActionMetadata ActionMetaData,						  
						  optional bool InShouldSkipStop = false)
{
	local XGUnit Unit;
	local int TileIndex;
	local int MovementPathIndex; //Index in the MovementPaths array - supporting multiple paths for a single ability context
	local Vector Point;
	local Vector NextPoint;
	local Vector NewDirection;
	local float DistanceBetweenPoints;
	local ETraversalType LastTraversalType;	
	local X2VisualizerHelpers VisualizerHelper;			
	local int LocalPlayerID;	
	local XComGameState_Unit UnitState;			
	local XComGameStateContext_Ability LastInterruptedMoveContext;	
	local XComGameState_Unit InterruptedUnitState;
	local X2Action_CameraFrameAbility FrameAbilityAction;
	local X2Action_CameraFollowUnit CameraFollowAction;		
	local X2Action_CameraRemove RemoveCameraAction;
	local int UpdateFirstTile;
	local int UpdateLength, InterruptIndex;
	local int TileCount;
	local PathPoint TempPoint;
	local TTile TempTile, EndTile;
	local bool bCivilianMove;
	
	local int NumPathTiles;
	local bool bMoveVisible;	
	local int LastVisibleTileIndex;		
	local XComGameStateHistory History;
	local int LastAddedTileIndex;
	local float MoveSpeedModifier;
	local XComGameStateVisualizationMgr VisualizationMgr;
	local XComGameStateContext_Ability TempContext;
	local XComGameState WalkbackState;
	local array<X2Action> EndMoveActions;
	local X2Action_MarkerInterruptBegin InterruptMarker;
	local XComGameStateContext_Ability InterruptContext;

	local StateObjectReference EffectRef;
	local XComGameState_Effect EffectState;
	local X2Effect_Persistent EffectTemplate;
	local bool bMoveVisibleOverridden;
	local bool bDidNotMakeItToDestination;	
	local bool bAffectedByTargetDefinition; //Forces the unit to be visible even in the fog
	local bool bHiddenTeleportToEndPos;
	local XComUnitPawnNativeBase UnitPawn;
	
	Unit = XGUnit( ActionMetaData.StateObject_NewState.GetVisualizer() );
	VisualizationMgr = `XCOMVISUALIZATIONMGR;
	VisualizerHelper = VisualizationMgr.VisualizerHelpers;

	if(Unit != none)
	{
		History = `XCOMHISTORY;
		VisualizerHelper.LastMoveAction = none;
		VisualizerHelper.MoveBeginAction = none;
		VisualizerHelper.LastMoveDirectAction = none;
		VisualizerHelper.AdditionalParents.Length = 0;
		VisualizerHelper.bAIMoveInterrupted = false;
		VisualizerHelper.bIsMoveAttack = false;

		bCivilianMove = Unit.GetTeam() == eTeam_Neutral;
		MovementPathIndex = AbilityContext.GetMovePathIndex(Unit.ObjectID);		
		NewDirection = Vector(Unit.GetPawn().Rotation);		
		LastTraversalType = eTraversal_None;
		DistanceBetweenPoints = 0.0f;

		UnitState = XComGameState_Unit(ActionMetaData.StateObject_NewState);
		LocalPlayerID = `TACTICALRULES.GetLocalClientPlayerObjectID();

		InterruptIndex = INDEX_NONE;
		UpdateFirstTile = 0;
		UpdateLength = AbilityContext.InputContext.MovementPaths[MovementPathIndex].MovementTiles.Length;
		
		if( AbilityContext.InputContext.MovementPaths.Length == 1 )
		{
			MoveSpeedModifier = UnitState.GetMyTemplate().SoloMoveSpeedModifier;
		}
		else
		{
			MoveSpeedModifier = 1.0f;
		}

		// gremlin flies much faster in zip mode
		if( UnitState.GetMyTemplate().bIsCosmetic && `XPROFILESETTINGS.Data.bEnableZipMode )
		{
			MoveSpeedModifier *= class'X2TacticalGameRuleset'.default.ZipModeTrivialAnimSpeed;
		}


		//Truncate the path if the unit did not make it to their destination but is still alive. In this situation the unit should still play
		//move end animation and generally behave as if that is what they meant to do. For other cases such as where the unit dies, the death
		//action takes care of animations at the end of the interrupted move...		
		NumPathTiles = AbilityContext.InputContext.MovementPaths[MovementPathIndex].MovementTiles.Length;		

		//See if this was a move attack - if there was a target or target effect results we assume it was. Don't allow the visible portion of the path to be shortened if so.
		VisualizerHelper.bIsMoveAttack = AbilityContext.InputContext.PrimaryTarget.ObjectID > 0 || AbilityContext.ResultContext.TargetEffectResults.ApplyResults.Length > 0;

		if(!VisualizerHelper.bIsMoveAttack && UnitState.IsAlive() && !UnitState.IsBleedingOut() && !UnitState.GetMyTemplate().bIsCosmetic &&
		   UnitState.TileLocation != AbilityContext.InputContext.MovementPaths[MovementPathIndex].MovementTiles[NumPathTiles - 1])
		{
			LastInterruptedMoveContext = XComGameStateContext_Ability(AbilityContext.GetLastStateInInterruptChain().GetContext());
			if(LastInterruptedMoveContext != none)
			{	
				//See if the unit is still alive at the end of the event chain that this interrupt was a part of. If the unit died, then we don't want to truncate the path
				InterruptedUnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitState.ObjectID, eReturnType_Reference, AbilityContext.GetLastStateInEventChain().HistoryIndex));
				if(InterruptedUnitState.IsAlive())
				{
					//Truncate the movement tiles if there was an interruption. If this was a group move, use the movement path index to offset
					UpdateLength = LastInterruptedMoveContext.ResultContext.InterruptionStep + 1;
					UpdateLength = Max(UpdateLength, 1); //Make sure we don't reduce the length to 0					
					InterruptIndex = UpdateLength;
					bDidNotMakeItToDestination = true;
				}
			}
		}

		// A GameState Effect can cause the unit to move invisibly (Example: Assassin/Spectre vanish). Alternately, TargetDefinition can force the entire move visible		
		bMoveVisibleOverridden = false;
		bMoveVisible = UnitState.ControllingPlayer.ObjectID == LocalPlayerID; //Initialize based on whether this unit is being controlled by the player or not
		foreach UnitState.AffectedByEffects(EffectRef)
		{
			EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID, eReturnType_Reference, AbilityContext.AssociatedState.HistoryIndex));
			if (EffectState != None)
			{
				EffectTemplate = EffectState.GetX2Effect();
				if (EffectTemplate != None)
				{
					if (!EffectTemplate.AreMovesVisible())
					{
						bMoveVisible = false;
						bMoveVisibleOverridden = true;
					}
					else if (EffectTemplate.EffectName == 'TargetDefinition')
					{
						bAffectedByTargetDefinition = true;
					}
				}
			}
		}

		//Truncate the front of the path for any part of it not visible to a local viewer. Only do this calculation for AIs and non local players
		if (!bMoveVisibleOverridden)
		{
			if (UnitState.ControllingPlayer.ObjectID != LocalPlayerID &&
				UnitState.ReflexActionState != eReflexActionState_AIScamper) //Never truncate the scamper path, as a FOW viewer will reveal the movement area artificially
			{
				NumPathTiles = AbilityContext.ResultContext.PathResults[MovementPathIndex].PathTileData.Length;
				bMoveVisible = UnitState.ControllingPlayer.ObjectID == LocalPlayerID; //If this is the local player, the moves are always visible
				for (TileIndex = 0; TileIndex < NumPathTiles; ++TileIndex)
				{
					if (AbilityContext.ResultContext.PathResults[MovementPathIndex].PathTileData[TileIndex].NumLocalViewers > 0)
					{
						LastVisibleTileIndex = TileIndex;

						if (!bMoveVisible)
						{
							UpdateFirstTile = TileIndex;
						}
						bMoveVisible = true;
					}
				}
				UnitPawn = Unit.GetPawn();
				if (UpdateFirstTile != 0 // NumLocalViewers count does not check if a unit is currently visible in the FoW.
					&& UnitPawn != None  // Correct this here.  
					&& UnitPawn.IsPawnSeenInFOW())  // Otherwise the pawn will visibly teleport to the first visible tile.
				{
					UpdateFirstTile = 0;
				}
			}
			else
			{
				LastVisibleTileIndex = UpdateLength - 1;
				bMoveVisible = true;
			}
		}
		
		UpdateLength = Min(UpdateLength, LastVisibleTileIndex + class'X2VisualizerHelpers'.default.TilesInFog + 1);//+1 because this is a length
		UpdateFirstTile = Max(0, UpdateFirstTile - class'X2VisualizerHelpers'.default.TilesInFog);
		
		//Make adjustments to the path if we have a new starting tile or a new ending tile. This is only necessary if at least some part of the path is visible. 
		// Don't do anything to the path if affected by TargetDefinition - except if the move was interrupted.
		if(bMoveVisible && ((!bAffectedByTargetDefinition && (UpdateFirstTile > 0 || UpdateLength < AbilityContext.InputContext.MovementPaths[MovementPathIndex].MovementTiles.Length))
			|| (bAffectedByTargetDefinition && InterruptIndex != INDEX_NONE) ) )
		{
			VisualizerHelper.InputData = AbilityContext.InputContext.MovementPaths[MovementPathIndex];

			//Zero out the arrays as we will be rebuilding these
			VisualizerHelper.InputData.MovementTiles.Length = 0;
			VisualizerHelper.InputData.MovementData.Length = 0;

			//Enforce some limits on the tile removal
			if(UpdateFirstTile == UpdateLength)
			{
				UpdateFirstTile = 0; 
			}

			if (bAffectedByTargetDefinition && InterruptIndex != INDEX_NONE) // Only modify paths based on interrupts, not Visibility/FoW.
			{
				UpdateFirstTile = 0;
				UpdateLength = Max(InterruptIndex, 2); // Should always have at least two tiles in the path.
			}

			//Build the new tile array		
			for(TileIndex = 0; TileIndex < NumPathTiles; ++TileIndex)
			{			
				if(TileIndex >= UpdateFirstTile && TileIndex < UpdateLength)
				{
					TempTile = AbilityContext.InputContext.MovementPaths[MovementPathIndex].MovementTiles[TileIndex];
					LastAddedTileIndex = TileIndex;
					//`SHAPEMGR.DrawTile(TempTile, 0, 155, 0, 0.9f);
					VisualizerHelper.InputData.MovementTiles.AddItem(TempTile);
				}
				else
				{
					//`SHAPEMGR.DrawTile(TempTile, 100, 100, 100, 0.9f);
				}
			}
			// If the move visualization is cut short due to visibility, we need to ensure the final destination is still reached.
			EndTile = AbilityContext.InputContext.MovementPaths[MovementPathIndex].MovementTiles[NumPathTiles - 1];
			TileCount = VisualizerHelper.InputData.MovementTiles.Length;
			if (LastAddedTileIndex != NumPathTiles - 1 && VisualizerHelper.InputData.MovementTiles[TileCount - 1] != EndTile
				&& !bDidNotMakeItToDestination) // Do not teleport to the end position if the move was interrupted.
			{
				bHiddenTeleportToEndPos = true;
			}

			// Fix for red screen where only one movement tile is in the list.
			if( VisualizerHelper.InputData.MovementTiles.Length == 1 )
			{ 
				// Ensure at least 2 tiles are in here.
				if( LastAddedTileIndex > 0)
				{
					// Insert previous tile in list.
					TempTile = AbilityContext.InputContext.MovementPaths[MovementPathIndex].MovementTiles[LastAddedTileIndex - 1];
					VisualizerHelper.InputData.MovementTiles.InsertItem(0, TempTile);
				}
				else if( LastAddedTileIndex < AbilityContext.InputContext.MovementPaths[MovementPathIndex].MovementTiles.Length - 1 )
				{
					// Add next tile in list.
					TempTile = AbilityContext.InputContext.MovementPaths[MovementPathIndex].MovementTiles[LastAddedTileIndex + 1];
					VisualizerHelper.InputData.MovementTiles.AddItem(TempTile);
				}
				else
				{
					`RedScreenOnce("Error - only one movement tile in path? @acheng");
				}
			}

			//Convert path tiles in the path points
			class'X2PathSolver'.static.GetPathPointsFromPath(UnitState, VisualizerHelper.InputData.MovementTiles, VisualizerHelper.InputData.MovementData);

			//Run string pulling on the path points
			class'XComPath'.static.PerformStringPulling(Unit, VisualizerHelper.InputData.MovementData, VisualizerHelper.InputData.WaypointTiles);			
			
			//Fill out the result data for the path
			class'X2TacticalVisibilityHelpers'.static.FillPathTileData(VisualizerHelper.InputData.MovingUnitRef.ObjectID, VisualizerHelper.InputData.MovementTiles, VisualizerHelper.ResultData.PathTileData);

		}
		else
		{
			/*
			for (TileIndex = 0; TileIndex < NumPathTiles; ++TileIndex)
			{
				TempTile = AbilityContext.InputContext.MovementPaths[MovementPathIndex].MovementTiles[TileIndex];
				`SHAPEMGR.DrawTile(TempTile, 0, 155, 0, 0.9f);
				VisualizerHelper.InputData.MovementTiles.AddItem(TempTile);
			}
			*/

			VisualizerHelper.InputData = AbilityContext.InputContext.MovementPaths[MovementPathIndex];
			VisualizerHelper.ResultData = AbilityContext.ResultContext.PathResults[MovementPathIndex];
		}

		//When determining whether to walk or not we use the first state / initial state of the unit when it was moving. The context passed in here will be the *last* state
		//which is appropriate for the rest of the move.
		VisualizerHelper.bShouldUseWalkAnim = Unit.ShouldUseWalkAnim(AbilityContext.GetFirstStateInInterruptChain());

		if(!bMoveVisible && VisualizerHelper.InputData.MovementData.Length > 1 && UnitState.ForceModelVisible() != eForceVisible)
		{
			TempPoint = VisualizerHelper.InputData.MovementData[0];
			//This unit was not seen at any point during its move, teleport to keep turn times down
			VisualizerHelper.AddTrackAction_Teleport(LastTraversalType, TempPoint.Position, VisualizerHelper.InputData.MovementData[VisualizerHelper.InputData.MovementData.Length - 1].Position, NewDirection, 0, 0, AbilityContext, ActionMetaData);
		}
		else
		{			
			if( (Unit.GetPawn().m_bShouldTurnBeforeMoving || VisualizerHelper.bShouldUseWalkAnim) && VisualizerHelper.InputData.MovementData.Length > 1 )// Rotate before BeginMove if needed
			{
				TempPoint = VisualizerHelper.InputData.MovementData[1];
				VisualizerHelper.AddTrackAction_TurnTorwards(TempPoint.Position, AbilityContext, ActionMetaData);
			}

			if (!bCivilianMove && //Per Jake, never have the camera follow civilian moves
				MovementPathIndex == 0 &&  //For group moves, follow the first mover
				UnitState.ReflexActionState != eReflexActionState_AIScamper && //The scamper action sequence has its own camera
				!Unit.bNextMoveIsFollow && //A unit following another will not get a follow cam
				bMoveVisible) //A unit that isn't visible to the local player shouldn't frame
			{
				// Movement is unique in that we spawn our own frame ability camera
				if(class'X2Camera_FollowMovingUnit'.default.UseFollowUnitCamera)
				{
					// more like old school EU
					CameraFollowAction = X2Action_CameraFollowUnit(VisualizationMgr.GetNodeOfType(VisualizationMgr.BuildVisTree, class'X2Action_CameraFollowUnit', ActionMetaData.VisualizeActor));						
					if(CameraFollowAction == none)
					{
						CameraFollowAction = X2Action_CameraFollowUnit(class'X2Action_CameraFollowUnit'.static.AddToVisualizationTree(ActionMetaData, AbilityContext));
					}
					CameraFollowAction.AbilityToFrame = AbilityContext;
					CameraFollowAction.ParsePathSetParameters(VisualizerHelper.InputData, VisualizerHelper.ResultData);
					CameraFollowAction.CameraTag = 'MovementFramingCamera';
				}
				else
				{
					// full move framing camera
					FrameAbilityAction = X2Action_CameraFrameAbility(class'X2Action_CameraFrameAbility'.static.AddToVisualizationTree(ActionMetaData, AbilityContext));
					FrameAbilityAction.AbilitiesToFrame.AddItem(AbilityContext);
					FrameAbilityAction.CameraTag = 'MovementFramingCamera';
				}
			}

			//Build a list of the interrupts that occurred during this move, in the form of interrupt steps. The path points know which tile indices they are relevant for, so this 
			//data will be correlated with the purpose of attaching interrupt marker nodes to the move actions as we create them.
			VisualizerHelper.bAIMoveInterrupted = false;
			VisualizerHelper.Interrupts.Length = 0;
			TempContext = AbilityContext;
			if (TempContext.InterruptionStatus != eInterruptionStatus_None)
			{
				if (TempContext.InterruptionStatus != eInterruptionStatus_Resume)
				{
					VisualizerHelper.Interrupts.AddItem(TempContext);
				}
				while (TempContext.InterruptionHistoryIndex > -1)
				{
					WalkbackState = History.GetGameStateFromHistory(TempContext.InterruptionHistoryIndex);
					TempContext = XComGameStateContext_Ability(WalkbackState.GetContext());
					VisualizerHelper.Interrupts.AddItem(TempContext);
				}
			}
			VisualizerHelper.bAIMoveInterrupted = bDidNotMakeItToDestination && VisualizerHelper.Interrupts.Length != 0 && UnitState.ControllingPlayer.ObjectID != LocalPlayerID; //Only AIs

			VisualizerHelper.AddTrackAction_BeginMove(AbilityContext, ActionMetaData, MoveSpeedModifier);
			VisualizerHelper.AddTrackActions_MoveOverPath(LastTraversalType, Point, NextPoint, NewDirection, DistanceBetweenPoints, 0, VisualizerHelper.InputData.MovementData, AbilityContext, ActionMetaData, InShouldSkipStop,, MoveSpeedModifier);

			// MHU - Set the total path length distance into the pawn.
			Unit.GetPawn().m_fTotalDistanceAlongPath = DistanceBetweenPoints;

			VisualizerHelper.AddTrackAction_EndMove(LastTraversalType, Point, NextPoint, NewDirection, DistanceBetweenPoints, VisualizerHelper.InputData.MovementData.Length - 1, AbilityContext, ActionMetaData, bHiddenTeleportToEndPos);

			if( CameraFollowAction != none || FrameAbilityAction != none )
			{
				RemoveCameraAction = X2Action_CameraRemove(class'X2Action_CameraRemove'.static.AddToVisualizationTree(ActionMetaData, AbilityContext, false, ActionMetaData.LastActionAdded));
				RemoveCameraAction.CameraTagToRemove = 'MovementFramingCamera';
			}
		}		

		if (VisualizerHelper.bAIMoveInterrupted && MovementPathIndex == (AbilityContext.InputContext.MovementPaths.Length - 1))
		{		
			VisualizationMgr.GetNodesOfType(VisualizationMgr.BuildVisTree, class'X2Action_MoveEnd', EndMoveActions);

			InterruptContext = VisualizerHelper.Interrupts[0]; //Not sure about this....
			InterruptMarker = class'X2Action'.static.AddInterruptMarkerPair(ActionMetaData, InterruptContext, EndMoveActions[0]).BeginNode;
			VisualizerHelper.Interrupts.Length = 0;
			
			if (EndMoveActions.Length > 0)
			{
				VisualizationMgr.ConnectAction(InterruptMarker, VisualizationMgr.BuildVisTree, false, none, EndMoveActions);
			}
			else
			{
				VisualizationMgr.ConnectAction(InterruptMarker, VisualizationMgr.BuildVisTree, false, ActionMetaData.LastActionAdded);
			}
		}
	}	
}

//Path Support
//*************************************************************************************************************
//*************************************************************************************************************
//*************************************************************************************************************
private function AddTrackActions_MoveOverPath(out ETraversalType LastTraversalType, out Vector Point, out Vector NextPoint, out Vector NewDirection, out float DistanceBetweenPoints, int Index, out array<PathPoint> Path,
											const out XComGameStateContext_Ability AbilityContext, out VisualizationActionMetadata ActionMetaData, optional bool ShouldSkipStop = false, optional float StopShortOfEndDistance = 0.0f, 
											optional float MoveSpeedModifier = 1.0f)
{
	local XGUnit Unit;
	local Vector LastPoint;
	local XComCoverPoint CoverPoint;		
	local X2VisualizerHelpers VisualizerHelper;		
	local bool ShouldSkipStopThisAction;
	local Vector PrevDirection;
	local bool bTriedLookAhead;

	Unit = XGUnit( ActionMetaData.StateObject_NewState.GetVisualizer() );
	VisualizerHelper = `XCOMVISUALIZATIONMGR.VisualizerHelpers;
	
	LastPoint=Unit.Location;
	for(Index = 0; Index < VisualizerHelper.InputData.MovementData.Length; Index++)
	{
		Point = VisualizerHelper.InputData.MovementData[Index].Position;
		if(Index + 1 < VisualizerHelper.InputData.MovementData.Length)
		{
			PrevDirection = NewDirection;
			bTriedLookAhead = false;

			NextPoint = VisualizerHelper.InputData.MovementData[Index + 1].Position;
			// MILLER - Compute the direction we should end up facing
			//          at the end of this action
			if(Index + 2 < VisualizerHelper.InputData.MovementData.Length)
			{
				NewDirection = VisualizerHelper.InputData.MovementData[Index + 2].Position - NextPoint;
				bTriedLookAhead = true;
			}
			else
			{
				NewDirection = NextPoint - Point;
			}

			if (VSizeSq(NewDirection) > 0.0f)
			{
				// if we are going up/down make sure we maintain our current facing (so we dont spin around)
				if (VisualizerHelper.InputData.MovementData[Index].Traversal != eTraversal_Flying)
				{
					NewDirection.Z = 0;
				}
				NewDirection = Normal(NewDirection);				
			}
			else
			{	
				//If the lookahed attempt was no good, try the current segment
				if (bTriedLookAhead)
				{
					NewDirection = NextPoint - Point;
				}	

				if (VSizeSq(NewDirection) > 16.0f)
				{
					if (VisualizerHelper.InputData.MovementData[Index].Traversal != eTraversal_Flying)
					{
						NewDirection.Z = 0;
					}
					NewDirection = Normal(NewDirection);
				}
				else
				{
					//Fall back to the previous direction if neither gave a satisfactory direction
					NewDirection = PrevDirection;
				}
			}
		}
		else
		{
			//If the move location is in a tile with cover, make sure the destination is at the cover point
			if( `XWORLD.GetCoverPoint(Point, CoverPoint) && Unit.CanUseCover() )
			{
				Point = CoverPoint.ShieldLocation;
			}

			NextPoint = Point;
			NewDirection = Point-LastPoint;
			NewDirection.Z = 0;
			NewDirection = Normal(NewDirection);
		}
		LastPoint=Point;

		
		DistanceBetweenPoints += VSize(Point - NextPoint);

		if(Index == VisualizerHelper.InputData.MovementData.Length - 2)
			DistanceBetweenPoints -= StopShortOfEndDistance;

		// only skip the stop on the last movement action. +2 because the very last node is for the end move action
		ShouldSkipStopThisAction = ShouldSkipStop && ((Index + 2) >= VisualizerHelper.InputData.MovementData.Length);

		// MILLER - Grab the traversal type and queue up an action.  If it's the first
		//          action in the path, we let it interrupt the current action.  Otherwise,
		//          it doesn't interrupt.
		switch (VisualizerHelper.InputData.MovementData[Index].Traversal)
		{
			case eTraversal_None:
				`Log("Invalid path");
				break;
			case eTraversal_Normal:
			case eTraversal_Ramp:
				if((Index + 1) < VisualizerHelper.InputData.MovementData.Length)
				{
					VisualizerHelper.LastMoveAction = VisualizerHelper.AddTrackAction_Normal(LastTraversalType, Point, NextPoint, NewDirection, DistanceBetweenPoints, Index, AbilityContext, ActionMetaData, ShouldSkipStopThisAction, MoveSpeedModifier);
				}
				break;
			case eTraversal_Flying:
				VisualizerHelper.LastMoveAction = VisualizerHelper.AddTrackAction_Flying(LastTraversalType, Point, NextPoint, NewDirection, DistanceBetweenPoints, Index, AbilityContext, ActionMetaData, ShouldSkipStopThisAction, MoveSpeedModifier);
				break;
			case eTraversal_Launch:
				VisualizerHelper.LastMoveAction = VisualizerHelper.AddTrackAction_Flying(eTraversal_None, Point, NextPoint, NewDirection, DistanceBetweenPoints, Index, AbilityContext, ActionMetaData, ShouldSkipStopThisAction, MoveSpeedModifier);
				break;
			case eTraversal_Land:
				VisualizerHelper.LastMoveAction = VisualizerHelper.AddTrackAction_Normal(LastTraversalType, Point, NextPoint, NewDirection, DistanceBetweenPoints, Index, AbilityContext, ActionMetaData, ShouldSkipStopThisAction, MoveSpeedModifier);
				break;
			case eTraversal_ClimbOver:
				VisualizerHelper.LastMoveAction = VisualizerHelper.AddTrackAction_ClimbOver(LastTraversalType, Point, NextPoint, NewDirection, DistanceBetweenPoints, Index, AbilityContext, ActionMetaData);
				break;
			case eTraversal_BreakWindow:
				VisualizerHelper.LastMoveAction = VisualizerHelper.AddTrackAction_BreakWindow(LastTraversalType, Point, NextPoint, NewDirection, DistanceBetweenPoints, Index, AbilityContext, ActionMetaData);
				break;
			case eTraversal_KickDoor:
				VisualizerHelper.LastMoveAction = VisualizerHelper.AddTrackAction_KickDoor(LastTraversalType, Path, Point, NextPoint, NewDirection, DistanceBetweenPoints, Index, AbilityContext, ActionMetaData);
				break;
			case eTraversal_ClimbOnto:
				VisualizerHelper.LastMoveAction = VisualizerHelper.AddTrackAction_ClimbOnto(LastTraversalType, Point, NextPoint, NewDirection, DistanceBetweenPoints, Index, AbilityContext, ActionMetaData);
				break;
			case eTraversal_ClimbLadder:
				VisualizerHelper.LastMoveAction = VisualizerHelper.AddTrackAction_ClimbLadder(LastTraversalType, Point, NextPoint, NewDirection, DistanceBetweenPoints, Index, AbilityContext, ActionMetaData);
				break;
			case eTraversal_DropDown:
				VisualizerHelper.LastMoveAction = VisualizerHelper.AddTrackAction_DropDown(LastTraversalType, Point, NextPoint, NewDirection, DistanceBetweenPoints, Index, AbilityContext, ActionMetaData);
				break;
			case eTraversal_Grapple:
				VisualizerHelper.LastMoveAction = VisualizerHelper.AddTrackAction_Grapple(LastTraversalType, Point, NextPoint, NewDirection, DistanceBetweenPoints, Index, AbilityContext, ActionMetaData);
				break;
			case eTraversal_Landing:
				VisualizerHelper.LastMoveAction = VisualizerHelper.AddTrackAction_Normal(LastTraversalType, Point, NextPoint, NewDirection, DistanceBetweenPoints, Index, AbilityContext, ActionMetaData, ShouldSkipStopThisAction, MoveSpeedModifier);
				break;
			case eTraversal_JumpUp:
				VisualizerHelper.LastMoveAction = VisualizerHelper.AddTrackAction_JumpUp(LastTraversalType, Point, NextPoint, NewDirection, DistanceBetweenPoints, Index, AbilityContext, ActionMetaData);
				break;
			case eTraversal_WallClimb:
				VisualizerHelper.LastMoveAction = VisualizerHelper.AddTrackAction_ClimbWall(LastTraversalType, Point, NextPoint, NewDirection, DistanceBetweenPoints, Index, AbilityContext, ActionMetaData);
				break;
			case eTraversal_Unreachable:
				break;
			case eTraversal_Teleport:
				VisualizerHelper.LastMoveAction = VisualizerHelper.AddTrackAction_VisibleTeleport(LastTraversalType, Point, NextPoint, NewDirection, DistanceBetweenPoints, Index, AbilityContext, ActionMetaData);
				break;
			default:
				VisualizerHelper.LastMoveAction = VisualizerHelper.AddTrackAction_Teleport(LastTraversalType, Point, NextPoint, NewDirection, DistanceBetweenPoints, Index, AbilityContext, ActionMetaData);
				break;
		}

		LastTraversalType = VisualizerHelper.InputData.MovementData[Index].Traversal;
	}
}

private function X2Action AddTrackAction_BeginMove(const out XComGameStateContext_Ability AbilityContext, out VisualizationActionMetadata ActionMetaData, optional float MoveSpeedModifier = 1.0f)
{
	local int InterruptIndex;
	local XComGameStateContext_Ability InterruptContext;
	local X2Action_MoveBegin NewAction;

	NewAction = X2Action_MoveBegin(class'X2Action_MoveBegin'.static.AddToVisualizationTree(ActionMetaData, AbilityContext, false, ActionMetaData.LastActionAdded));
	NewAction.SetShouldUseWalkAnim(bShouldUseWalkAnim);
	NewAction.ParsePathSetParameters(InputData, ResultData);

	//Build a list of interrupts specific to this move action. If the interruption step is 0 or 1, it will occur during the move begin.
	if (!bAIMoveInterrupted)
	{
		for (InterruptIndex = 0; InterruptIndex < Interrupts.Length; ++InterruptIndex)
		{
			InterruptContext = Interrupts[InterruptIndex];
			if (InterruptContext.ResultContext.InterruptionStep <= 1)
			{
				class'X2Action'.static.AddInterruptMarkerPair(ActionMetaData, InterruptContext, NewAction);
				Interrupts.Remove(InterruptIndex--, 1);
			}
		}
	}

	MoveBeginAction = NewAction;
	LastMoveAction = MoveBeginAction;

	return NewAction;
}

private function X2Action AddTrackAction_EndMove(ETraversalType LastTraversalType, Vector Point, Vector NextPoint, Vector NewDirection, float DistanceBetweenPoints, int Index,
									const out XComGameStateContext_Ability AbilityContext, out VisualizationActionMetadata ActionMetaData, bool bHiddenTeleportToEndPos=false)
{
	local X2Action_MoveEnd NewAction;

	//If this was a move attack, add the remaining interrupts to the move action right before end move.
	if (Interrupts.Length > 0 && bIsMoveAttack)
	{
		AddInterruptMarkers(Index, LastMoveAction, ActionMetaData);
	}

	NewAction = X2Action_MoveEnd(class'X2Action_MoveEnd'.static.AddToVisualizationTree(ActionMetaData, AbilityContext, false, LastMoveAction, AdditionalParents));
	NewAction.SetShouldUseWalkAnim(bShouldUseWalkAnim);
	NewAction.ParsePathSetParameters(Index, NextPoint, DistanceBetweenPoints);
	NewAction.MoveBeginAction = MoveBeginAction;
	NewAction.bHiddenTeleportToEndPos = bHiddenTeleportToEndPos;

	if (Interrupts.Length > 0 && !bAIMoveInterrupted)
	{
		AddInterruptMarkers(Index, NewAction, ActionMetaData);
	}

	return NewAction;
}

private function X2Action AddTrackAction_TurnTorwards(const out vector TurnTowardsLocation, const out XComGameStateContext_Ability AbilityContext, out VisualizationActionMetadata ActionMetaData)
{
	local X2Action NewAction;

	NewAction = class'X2Action_MoveTurn'.static.AddToVisualizationTree(ActionMetaData, AbilityContext, false, LastMoveAction, AdditionalParents);
	X2Action_MoveTurn(NewAction).ParsePathSetParameters(TurnTowardsLocation);
	return NewAction;
}

//This method loops the interrupts that have occurred during this move sequence, and adds interrupt markers as appropriate. When a marker set has been added, it removes
//the interrupt from the list to indicate it was consumed.
private function AddInterruptMarkers(int Index, X2Action NewAction, out VisualizationActionMetadata ActionMetaData)
{
	local int InterruptIndex;	
	local XComGameStateContext_Ability InterruptContext;	

	if (!bAIMoveInterrupted)
	{
		//Build a list of interrupts specific to this move action
		for (InterruptIndex = Interrupts.Length - 1; InterruptIndex > -1; --InterruptIndex)
		{
			InterruptContext = Interrupts[InterruptIndex];
			if (InterruptContext.ResultContext.InterruptionStep >= InputData.MovementData[Index].PathTileIndex &&
				((Index + 1) >= InputData.MovementData.Length || InterruptContext.ResultContext.InterruptionStep < InputData.MovementData[Index + 1].PathTileIndex))
			{				
				AdditionalParents[0] = class'X2Action'.static.AddInterruptMarkerPair(ActionMetaData, InterruptContext, NewAction);
				Interrupts.Remove(InterruptIndex, 1);
			}
		}
	}
}

private function X2Action AddTrackAction_Normal(ETraversalType LastTraversalType, Vector Point, Vector NextPoint, Vector NewDirection, float DistanceBetweenPoints, int Index,
									   const out XComGameStateContext_Ability AbilityContext, out VisualizationActionMetadata ActionMetaData, optional bool ShouldSkipStop,
									   optional float MoveSpeedModifier = 1.0f)
{	
	local X2Action_MoveDirect NewAction;	
	local Vector CurrentDirection;			

	CurrentDirection = NextPoint - Point;
	CurrentDirection.Z = 0.0f;
	CurrentDirection = Normal(CurrentDirection);
	if( LastTraversalType == eTraversal_Normal || LastTraversalType == eTraversal_Flying )
	{			
		//Normal traversals are consolidated together by simply updating the parameters of an existing move direct		
		if( NextPoint != LastMoveDirectAction.Destination ) //Don't let the system create a traversal that doesn't go anywhere!
		{
			LastMoveDirectAction.ParsePathSetParameters(Index, NextPoint, DistanceBetweenPoints, CurrentDirection, NewDirection, ShouldSkipStop, MoveSpeedModifier);
		}
		NewAction = LastMoveDirectAction; //Assign as "newaction" as additional processing of the action is done below
	}
	else
	{			
		NewAction = X2Action_MoveDirect(class'X2Action_MoveDirect'.static.AddToVisualizationTree(ActionMetaData, AbilityContext, false, LastMoveAction, AdditionalParents));
		NewAction.SetShouldUseWalkAnim(bShouldUseWalkAnim);
		NewAction.ParsePathSetParameters(Index, NextPoint, DistanceBetweenPoints, CurrentDirection, NewDirection, ShouldSkipStop, MoveSpeedModifier);
		NewAction.MoveBeginAction = MoveBeginAction;
		LastMoveDirectAction = NewAction;
	}

	//Add interrupt markers if interrupts were detected
	if (Interrupts.Length > 0)
	{
		AddInterruptMarkers(Index, NewAction, ActionMetaData);
	}

	return NewAction;
}

private function X2Action AddTrackAction_Flying(ETraversalType LastTraversalType, Vector Point, Vector NextPoint, Vector NewDirection, float DistanceBetweenPoints, int Index,
									   const out XComGameStateContext_Ability AbilityContext, out VisualizationActionMetadata ActionMetaData, optional bool ShouldSkipStop = false,
									   optional float MoveSpeedModifier = 1.0f)
{
	local X2Action_MoveDirect NewAction;
	local X2Action_MoveDirect PrevMoveFlyingAction;
	local Vector CurrentDirection;

	// flying moves are concatenated together if possible
	CurrentDirection = Normal(NextPoint - Point);

	if(LastTraversalType == eTraversal_Flying || LastTraversalType == eTraversal_Launch )
	{	
		PrevMoveFlyingAction = LastMoveDirectAction;
		PrevMoveFlyingAction.ParsePathSetParameters(Index, NextPoint, DistanceBetweenPoints, CurrentDirection, NewDirection, ShouldSkipStop, MoveSpeedModifier);
		PrevMoveFlyingAction.SetFlying();
		NewAction = PrevMoveFlyingAction; //Assign as "newaction" as additional processing of the action is done below
	}
	else
	{
		NewAction = X2Action_MoveDirect(class'X2Action_MoveDirect'.static.AddToVisualizationTree(ActionMetaData, AbilityContext, false, LastMoveAction, AdditionalParents));
		NewAction.SetShouldUseWalkAnim(bShouldUseWalkAnim);
		NewAction.ParsePathSetParameters(Index, NextPoint, DistanceBetweenPoints, CurrentDirection, NewDirection, ShouldSkipStop, MoveSpeedModifier);
		NewAction.SetFlying();
		NewAction.MoveBeginAction = MoveBeginAction;
		LastMoveDirectAction = NewAction;
	}

	//Add interrupt markers if interrupts were detected
	if (Interrupts.Length > 0)
	{
		AddInterruptMarkers(Index, NewAction, ActionMetaData);
	}

	return NewAction;
}

private function X2Action AddTrackAction_ClimbOver(ETraversalType LastTraversalType, Vector Point, Vector NextPoint, Vector NewDirection, float DistanceBetweenPoints, int Index,
									const out XComGameStateContext_Ability AbilityContext, out VisualizationActionMetadata ActionMetaData)
{
	local X2Action_MoveClimbOver NewAction;

	NewAction = X2Action_MoveClimbOver(class'X2Action_MoveClimbOver'.static.AddToVisualizationTree(ActionMetaData, AbilityContext, false, LastMoveAction, AdditionalParents));
	NewAction.SetShouldUseWalkAnim(bShouldUseWalkAnim);
	NewAction.ParsePathSetParameters(Index, NextPoint, DistanceBetweenPoints, NewDirection);
	NewAction.MoveBeginAction = MoveBeginAction;

	//Add interrupt markers if interrupts were detected
	if (Interrupts.Length > 0)
	{
		AddInterruptMarkers(Index, NewAction, ActionMetaData);
	}

	return NewAction;
}

private function X2Action AddTrackAction_BreakWindow(ETraversalType LastTraversalType, Vector Point, Vector NextPoint, Vector NewDirection, float DistanceBetweenPoints, int Index,
									const out XComGameStateContext_Ability AbilityContext, out VisualizationActionMetadata ActionMetaData)
{
	local X2Action_MovePlayAnimation NewAction;

	NewAction = X2Action_MovePlayAnimation(class'X2Action_MovePlayAnimation'.static.AddToVisualizationTree(ActionMetaData, AbilityContext, false, LastMoveAction, AdditionalParents));
	NewAction.SetShouldUseWalkAnim(bShouldUseWalkAnim);
	NewAction.ParsePathSetParameters(Index, NextPoint, DistanceBetweenPoints, 'MV_WindowBreakThroughA', NewDirection);
	NewAction.MoveBeginAction = MoveBeginAction;

	//Add interrupt markers if interrupts were detected
	if (Interrupts.Length > 0)
	{
		AddInterruptMarkers(Index, NewAction, ActionMetaData);
	}

	`XEVENTMGR.TriggerEvent('BreakWindow', AbilityContext, ActionMetaData.StateObject_NewState);

	return NewAction;
}

private function X2Action AddTrackAction_KickDoor(ETraversalType LastTraversalType, const out array<PathPoint> Path, Vector Point, Vector NextPoint, Vector NewDirection, float DistanceBetweenPoints, int Index,
										 const out XComGameStateContext_Ability AbilityContext, out VisualizationActionMetadata ActionMetaData, bool bUseWalkAnim = false)
{
	local X2Action_MovePlayAnimation NewAction;
	local Actor Door;
	local XComInteractiveLevelActor InteractiveDoor;

	local X2Action_MoveTurn TurnAnimation;
	local X2Action_PlayAnimation PlayAnimation;	
	local X2Action_Delay DelayAction;

	class'WorldInfo'.static.GetWorldInfo().FindActorByIdentifier(InputData.MovementData[Index].ActorId, Door);
	InteractiveDoor = XComInteractiveLevelActor(Door);

	if ((InteractiveDoor == none || InteractiveDoor.IsInState('_Pristine')))
	{	
		if (InteractiveDoor.HasDestroyAnim())
		{
			NewAction = X2Action_MovePlayAnimation(class'X2Action_MovePlayAnimation'.static.AddToVisualizationTree(ActionMetaData, AbilityContext, false, LastMoveAction, AdditionalParents));
			NewAction.SetShouldUseWalkAnim(bShouldUseWalkAnim);
			NewAction.ParsePathSetParameters(Index, NextPoint, DistanceBetweenPoints, 'MV_DoorOpenBreakA', NewDirection);
			NewAction.MoveBeginAction = MoveBeginAction;
		}
		else
		{
			//Turn towards the door - specify the last move action to the parent. The actions below will use the ActionMetaData.LastActionAdded
			TurnAnimation = X2Action_MoveTurn(class'X2Action_MoveTurn'.static.AddToVisualizationTree(ActionMetaData, AbilityContext, false, LastMoveAction, AdditionalParents));
			TurnAnimation.m_vFacePoint = NextPoint;			

			//Play idle animation while door opens
			PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetaData, AbilityContext));
			PlayAnimation.Params.AnimName = 'NO_IdleGunDwnA';
			PlayAnimation.bFinishAnimationWait = false;

			//Wait for the door to open
			DelayAction = X2Action_Delay(class'X2Action_Delay'.static.AddToVisualizationTree(ActionMetaData, AbilityContext));
			DelayAction.Duration = 0.6f;

			//Run into room
			NewAction = X2Action_MovePlayAnimation(class'X2Action_MovePlayAnimation'.static.AddToVisualizationTree(ActionMetaData, AbilityContext));
			NewAction.SetShouldUseWalkAnim(bShouldUseWalkAnim);
			NewAction.ParsePathSetParameters(Index, NextPoint, DistanceBetweenPoints, 'MV_RunFwd_StartA', NewDirection);
			NewAction.MoveBeginAction = MoveBeginAction;
		}

		`XEVENTMGR.TriggerEvent('BreakDoor', AbilityContext, ActionMetaData.StateObject_NewState);
	}
	else
	{
		//If the door is already broken, but somehow there is a kick door traversal, we fall through here and treat it as a normal traversal
		return AddTrackAction_Normal(LastTraversalType, Point, NextPoint, NewDirection, DistanceBetweenPoints, Index, AbilityContext, ActionMetaData);
	}

	return NewAction;
}

private function X2Action AddTrackAction_ClimbOnto(ETraversalType LastTraversalType, Vector Point, Vector NextPoint, Vector NewDirection, float DistanceBetweenPoints, int Index,
									const out XComGameStateContext_Ability AbilityContext, out VisualizationActionMetadata ActionMetaData)
{
	local X2Action_MoveClimbOnto NewAction;
	local vector ModifiedDestination;

	ModifiedDestination = NextPoint;
	ModifiedDestination.Z -= 4.0f;

	NewAction = X2Action_MoveClimbOnto(class'X2Action_MoveClimbOnto'.static.AddToVisualizationTree(ActionMetaData, AbilityContext, false, LastMoveAction, AdditionalParents));
	NewAction.SetShouldUseWalkAnim(bShouldUseWalkAnim);
	NewAction.ParsePathSetParameters(Index, ModifiedDestination, DistanceBetweenPoints, NewDirection);
	NewAction.MoveBeginAction = MoveBeginAction;

	//Add interrupt markers if interrupts were detected
	if (Interrupts.Length > 0)
	{
		AddInterruptMarkers(Index, NewAction, ActionMetaData);
	}

	return NewAction;
}

private function AddTrackAction_Landing(ETraversalType LastTraversalType, Vector Point, Vector NextPoint, Vector NewDirection, float DistanceBetweenPoints, int Index,
										const out XComGameStateContext_Ability AbilityContext, out VisualizationActionMetadata ActionMetaData, bool bUseWalkAnim = false, optional float MoveSpeedModifier = 1.0f)
{
	
}

private function X2Action AddTrackAction_DropDown(ETraversalType LastTraversalType, Vector Point, Vector NextPoint, Vector NewDirection, float DistanceBetweenPoints, int Index,
									const out XComGameStateContext_Ability AbilityContext, out VisualizationActionMetadata ActionMetaData)
{
	local X2Action_MoveDropDown NewAction;

	NewAction = X2Action_MoveDropDown(class'X2Action_MoveDropDown'.static.AddToVisualizationTree(ActionMetaData, AbilityContext, false, LastMoveAction, AdditionalParents));
	NewAction.SetShouldUseWalkAnim(bShouldUseWalkAnim);
	NewAction.ParsePathSetParameters(Index, NextPoint, DistanceBetweenPoints, NewDirection);	
	NewAction.MoveBeginAction = MoveBeginAction;

	return NewAction;
}

private function X2Action AddTrackAction_Grapple(ETraversalType LastTraversalType, Vector Point, Vector NextPoint, Vector NewDirection, float DistanceBetweenPoints, int Index,
									const out XComGameStateContext_Ability AbilityContext, out VisualizationActionMetadata ActionMetaData)
{
	return AddTrackAction_Teleport(LastTraversalType, Point, NextPoint, NewDirection, DistanceBetweenPoints, Index, AbilityContext, ActionMetaData);
}

private function X2Action AddTrackAction_ClimbLadder(ETraversalType LastTraversalType, Vector Point, Vector NextPoint, Vector NewDirection, float DistanceBetweenPoints, int Index,
									const out XComGameStateContext_Ability AbilityContext, out VisualizationActionMetadata ActionMetaData)
{
	local X2Action_MoveClimbLadder NewAction;

	NewAction = X2Action_MoveClimbLadder(class'X2Action_MoveClimbLadder'.static.AddToVisualizationTree(ActionMetaData, AbilityContext, false, LastMoveAction, AdditionalParents));
	NewAction.SetShouldUseWalkAnim(bShouldUseWalkAnim);
	NewAction.ParsePathSetParameters(Index, NextPoint, DistanceBetweenPoints, NewDirection);
	NewAction.MoveBeginAction = MoveBeginAction;

	return NewAction;
}


private function X2Action AddTrackAction_JumpUp(ETraversalType LastTraversalType, Vector Point, Vector NextPoint, Vector NewDirection, float DistanceBetweenPoints, int Index,
									const out XComGameStateContext_Ability AbilityContext, out VisualizationActionMetadata ActionMetaData)
{
	local X2Action_MoveJumpUp NewAction;

	NewAction = X2Action_MoveJumpUp(class'X2Action_MoveJumpUp'.static.AddToVisualizationTree(ActionMetaData, AbilityContext, false, LastMoveAction, AdditionalParents));
	NewAction.SetShouldUseWalkAnim(bShouldUseWalkAnim);
	NewAction.ParsePathSetParameters(Index, NextPoint, DistanceBetweenPoints, NewDirection);	
	NewAction.MoveBeginAction = MoveBeginAction;

	return NewAction;
}


private function X2Action AddTrackAction_ClimbWall(ETraversalType LastTraversalType, Vector Point, Vector NextPoint, Vector NewDirection, float DistanceBetweenPoints, int Index,
									const out XComGameStateContext_Ability AbilityContext, out VisualizationActionMetadata ActionMetaData)
{
	local X2Action_MoveClimbWall NewAction;

	NewAction = X2Action_MoveClimbWall(class'X2Action_MoveClimbWall'.static.AddToVisualizationTree(ActionMetaData, AbilityContext, false, LastMoveAction, AdditionalParents));
	NewAction.SetShouldUseWalkAnim(bShouldUseWalkAnim);
	NewAction.ParsePathSetParameters(Index, NextPoint, Point, DistanceBetweenPoints);	
	NewAction.MoveBeginAction = MoveBeginAction;

	return NewAction;
}

private function X2Action AddTrackAction_Teleport(ETraversalType LastTraversalType, Vector Point, Vector NextPoint, Vector NewDirection, float DistanceBetweenPoints, int Index,
															   const out XComGameStateContext_Ability AbilityContext, out VisualizationActionMetadata ActionMetaData)
{
	local X2Action_MoveTeleport NewAction;

	NewAction = X2Action_MoveTeleport(class'X2Action_MoveTeleport'.static.AddToVisualizationTree(ActionMetaData, AbilityContext, false, LastMoveAction, AdditionalParents));
	NewAction.SetShouldUseWalkAnim(bShouldUseWalkAnim);
	NewAction.ParsePathSetParameters(Index, NextPoint, DistanceBetweenPoints, InputData, ResultData);	
	NewAction.MoveBeginAction = MoveBeginAction;

	return NewAction;
}

private function X2Action AddTrackAction_VisibleTeleport(ETraversalType LastTraversalType, Vector Point, Vector NextPoint, Vector NewDirection, float DistanceBetweenPoints, int Index,
												const out XComGameStateContext_Ability AbilityContext, out VisualizationActionMetadata ActionMetaData)
{
	local X2Action_MoveVisibleTeleport NewAction;

	NewAction = X2Action_MoveVisibleTeleport(class'X2Action_MoveVisibleTeleport'.static.AddToVisualizationTree(ActionMetaData, AbilityContext, false, LastMoveAction, AdditionalParents));
	NewAction.SetShouldUseWalkAnim(bShouldUseWalkAnim);
	NewAction.ParsePathSetParameters(Index, NextPoint, DistanceBetweenPoints);
	NewAction.MoveBeginAction = MoveBeginAction;

	return NewAction;
}
//*************************************************************************************************************

defaultproperties
{
	TilesInFog = 2
}
