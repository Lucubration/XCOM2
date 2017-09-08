//-----------------------------------------------------------
// This is the base class for all movement related X2Actions. This class
// provides shared functionality that all movement actions should have, 
// such as interrupt / resume functionality that releases control and
// regains control of the camera.
//-----------------------------------------------------------
class X2Action_Move extends X2Action
	config(Animation);

//Cached info for performing the action
//************************************
//Since moves are interruptible, and frequently are interrupted, there are multiple contexts stored here.
var protectedwrite XComGameStateContext_Ability AbilityContext; //If the move was interrupted, this context points to the resume
var protectedwrite XComGameState LastInGameStateChain; //Some effects / systems need to know the last game state, so store it here
var protectedwrite array<XComGameStateContext_Ability> Interrupts; //Filled out if this move is associated with interrupts. Used to signal interrupt markers.

//These are set in Init, which is run immediately prior to the action executing
var protectedwrite int			MovePathIndex;	//Index into the InputContext's MovementPaths array defining which path this move action is for
var protectedwrite int          PathIndex;		//Index into the PathingInputData.MovementData array - defining string-pulled path points that define locations for the pawn to path through
var protectedwrite array<int>	PathIndices;		//Used in addition to PathIndex for certain types of movement that encapsulate several path points
var protectedwrite int          PathTileIndex;	//Index into the PathingInputData.MovementTiles array - tiles, set within Init using the location of the unit's visualizer
var X2Action_MoveBegin			MoveBeginAction;  //Points back to move begin for this move action, if available.

var protected bool				bShouldUseWalkAnim; //Cached value determined by parse path
var protected bool				bLocalUnit;
var protected int				MovingUnitPlayerID;
var protected bool              bUpdateEffects;   //Indicates the unit has effects that need to be notified when the tile changes
var protected bool              NotifiedWindowBreak; // if animation doesn't provide a notify for a window break, allows us to break it at the end of the action

// Jwats: Moved from MoveDirect so more actions can predict how close to cover to get
var vector						Destination;
var float						Distance;
var ECoverState					PredictedCoverState;
var vector						PredictedCoverDirection;
var int							PredictedCoverIndex;
//*************************************

function Init()
{
	local X2TacticalGameRuleset Ruleset;
	local XComGameState_Unit MovingUnitState;
	local name EffectName;
	local XComGameState_Effect EffectState;
	local XComGameState_Effect SourceEffectState;
	local XComGameStateContext_Ability TempContext;
	local XComGameState WalkbackState;
	local XComGameStateHistory History;
	local X2Action Child;
	local bool bHasInterrupts;

	super.Init();

	AbilityContext = XComGameStateContext_Ability(StateChangeContext);

	// if this assert hits, you can uncomment the AddToVisualizationTree function override above to find
	// the specific culprit adding the action to a track
	`assert( (AbilityContext != none) || (X2Action_MoveTurn(self) != none));

	LastInGameStateChain = StateChangeContext.GetLastStateInInterruptChain();

	History = `XCOMHISTORY;

	//Check to see if there are interrupts associated with this move.
	foreach ChildActions(Child)
	{
		if (Child.IsA('X2Action_MarkerInterruptBegin'))
		{
			bHasInterrupts = true;
			break;
		}
	}

	Interrupts.Length = 0;
	if (bHasInterrupts)
	{
		//The starting context here will always be the last state in the interrupt chain. So walk backwards through the interrupt chain
		//and generate the list of interrupt contexts.
		TempContext = AbilityContext;
		if (TempContext.InterruptionStatus != eInterruptionStatus_Resume)
		{
			//Entry into this code block indicates that this interruption was terminal. The unit died or was otherwise unable to complete their move
			//normally. At the moment the only causes of this are 1. Death 2. AIs encountering the player's units while patrolling.
			Interrupts.AddItem(TempContext);
		}

		while (TempContext.InterruptionHistoryIndex > -1)
		{			
			WalkbackState = History.GetGameStateFromHistory(TempContext.InterruptionHistoryIndex);
			TempContext = XComGameStateContext_Ability(WalkbackState.GetContext());
			Interrupts.AddItem(TempContext);
		}
	}

	Ruleset = `TACTICALRULES;	
	MovingUnitState = XComGameState_Unit(Metadata.StateObject_NewState);
	MovingUnitPlayerID = MovingUnitState.ControllingPlayer.ObjectID;
	bLocalUnit = MovingUnitPlayerID == Ruleset.GetLocalClientPlayerObjectID();

	foreach class'X2AbilityTemplateManager'.default.EffectUpdatesOnMove(EffectName)
	{
		SourceEffectState = MovingUnitState.GetUnitApplyingEffectState(EffectName);
		EffectState = MovingUnitState.GetUnitAffectedByEffectState(EffectName);

		if (EffectState != None || SourceEffectState != None )
		{
			bUpdateEffects = true;
			break;
		}
	}

	if (AbilityContext != none)
	{
		MovePathIndex = AbilityContext.GetMovePathIndex(Unit.ObjectID);
		`assert( (MovePathIndex != -1) || (X2Action_MoveTurn(self) != none)); //sometimes people turn when someone else is the one moving

		if (MovePathIndex >=0)
		{
			PathTileIndex = FindPathTileIndex();

			if (PathIndex == -1) // some derived types (like climb ladder) set this directly
			{
				PathIndex = FindPathIndex();
			}

			//when the 1st move is directly into a thin wall, this is required to cause the phasing to happen Chang You Wong 2015-9-22
			UpdatePhasingEffect();
		}
	}

	ModifyDestinationForCover();

	//Instant complete the move action if the unit died. Fallback case in the event that the X2Actions were not removed by the terminal interrupt.
	if (UnitPawn.bPlayedDeath)
	{
		CompleteAction();
	}
}

function bool ModifyDestinationForCover(optional out X2Action_MoveEnd MoveEndAction)
{
	local XComCoverPoint kCoverPointHandle;
	local vector TestLocation;
	local float TestDistance;
	local X2Action FoundAction;
	local Vector vTestPosition;
	local Vector AwayFromCover;
	local bool FoundCover;
	local bool NextActionIsEnd;
	local X2Action_MoveDirect FoundMoveDirect;
	local TTile TileCoord;

	// Jwats: Consider move end as the next action if it is a move direct in the same tile as the move end
	NextActionIsEnd = IsNextActionTypeOf(class'X2Action_MoveEnd', FoundAction);
	if( NextActionIsEnd == false )
	{
		IsNextActionTypeOf(class'X2Action_MoveDirect', FoundAction);
		FoundMoveDirect = X2Action_MoveDirect(FoundAction);
		if( FoundMoveDirect != None )
		{
			NextActionIsEnd = FoundMoveDirect.IsNextActionTypeOf(class'X2Action_MoveEnd', FoundAction);
			if( NextActionIsEnd && FoundMoveDirect.Distance - Distance >= (class'XComWorldData'.const.WORLD_StepSize / 2) )
			{
				NextActionIsEnd = false;
			}
		}
	}

	if( NextActionIsEnd )
	{
		MoveEndAction = X2Action_MoveEnd(FoundAction);
		vTestPosition = MoveEndAction.Destination;
		vTestPosition.Z = `XWORLD.GetFloorZForPosition(vTestPosition) + class'XComWorldData'.const.Cover_BufferDistance;
		FoundCover = `XWORLD.GetCoverPoint(vTestPosition, kCoverPointHandle);

		if( Distance > (class'XComWorldData'.const.WORLD_StepSize * 2) )
		{
			TestDistance = Distance - (class'XComWorldData'.const.WORLD_StepSize * 2);
			TestLocation = Unit.VisualizerUsePath.FindPointOnPath(TestDistance);
		}
		else
		{
			TestLocation = Unit.Location;
		}

		// Jwats: Pass the history index after the move.
		PredictedCoverState = Unit.PredictCoverState(TestLocation, kCoverPointHandle, class'X2Action_MoveDirect'.default.PredictedCoverShouldUsePeeksThreshold, PredictedCoverDirection, PredictedCoverIndex, StateChangeContext.AssociatedState.HistoryIndex);
		switch( PredictedCoverState )
		{
		case eCS_LowLeft:
			Unit.IdleStateMachine.DesiredPeekSide = ePeekRight;
			Unit.IdleStateMachine.DesiredCoverIndex = PredictedCoverIndex;
			break;
		case eCS_LowRight:
			Unit.IdleStateMachine.DesiredPeekSide = ePeekLeft;
			Unit.IdleStateMachine.DesiredCoverIndex = PredictedCoverIndex;
			break;
		case eCS_HighRight:
			Unit.IdleStateMachine.DesiredPeekSide = ePeekLeft;
			Unit.IdleStateMachine.DesiredCoverIndex = PredictedCoverIndex;
			break;
		case eCS_HighLeft:
			Unit.IdleStateMachine.DesiredPeekSide = ePeekRight;
			Unit.IdleStateMachine.DesiredCoverIndex = PredictedCoverIndex;
			break;
		case eCS_None:
			Unit.IdleStateMachine.DesiredPeekSide = eNoPeek;
			Unit.IdleStateMachine.DesiredCoverIndex = -1;
			break;
		}

		Unit.SetUnitCoverState(PredictedCoverState);
		if( PredictedCoverState != eCS_None && PredictedCoverIndex != -1 )
		{
			Unit.SetCoverDirectionIndex(PredictedCoverIndex);
		}

		if( FoundCover )
		{
			// Jwats: Make sure we test the center of the tile
			TileCoord = `XWORLD.GetTileCoordinatesFromPosition(vTestPosition);
			vTestPosition = `XWORLD.GetPositionFromTileCoordinates(TileCoord);
			AwayFromCover = vTestPosition - kCoverPointHandle.CoverLocation;
			AwayFromCover.Z = 0;
			AwayFromCover = Normal(AwayFromCover) * UnitPawn.DistanceFromCoverToCenter;
			Destination = kCoverPointHandle.CoverLocation + AwayFromCover;
			Destination.Z = MoveEndAction.Destination.Z;
			MoveEndAction.Destination = Destination;
		}
	}

	return NextActionIsEnd;
}

function SetShouldUseWalkAnim(bool bSetting)
{
	bShouldUseWalkAnim = bSetting;
}

function int FindPathTileIndex()
{
	local int Index;
	local TTile CurrTile;
	local Vector CurrPos;
	local float DistSqToCur;
	local float DistSqToBest;
	local int BestIndex;

	//This logic must use the ability context's tile list, as it is the canonical move. The one stored on the unit in CurrentMoveData is a potentially
	//truncated / shortened path since for AI moves the portions that are not visible to the player are removed
	DistSqToBest = 10000000.0f;
	for(Index = 0; Index < AbilityContext.InputContext.MovementPaths[MovePathIndex].MovementTiles.Length; ++Index)
	{
		CurrTile = AbilityContext.InputContext.MovementPaths[MovePathIndex].MovementTiles[Index];
		CurrPos = `XWORLD.GetPositionFromTileCoordinates(CurrTile);
		DistSqToCur = VSizeSq(CurrPos - Unit.Location);
		if(DistSqToCur < DistSqToBest)
		{
			DistSqToBest = DistSqToCur;
			BestIndex = Index;
		}
	}

	return BestIndex;
}

function bool CheckInterrupted()
{
	local int Index;
	local bool bReturn;

	local XComGameStateContext_Ability InterruptContext;
	if (Interrupts.Length > 0)
	{
		for (Index = Interrupts.Length - 1; Index > -1; --Index)
		{
			InterruptContext = Interrupts[Index];
			if (InterruptContext.ResultContext.InterruptionStep <= PathTileIndex)
			{
				`XEVENTMGR.TriggerEvent('Visualizer_Interrupt', InterruptContext, self);
				Interrupts.Remove(Index, 1); //Remove the interrupts from the list once they have been processed				
				bReturn = true;
			}
		}

		return bReturn;
	}

	return false;
}

function bool IsTimedOut()
{
	return ExecutingTime >= TimeoutSeconds;
}

event bool BlocksAbilityActivation()
{
	// only X2Action_MoveEnd needs to determine this
	return false;
}

event OnAnimNotify(AnimNotify ReceiveNotify)
{	
	local AnimNotify_BreakWindow BreakWindowNotify;

	super.OnAnimNotify(ReceiveNotify);

	BreakWindowNotify = AnimNotify_BreakWindow(ReceiveNotify);
	if( BreakWindowNotify != none && !NotifiedWindowBreak )
	{
		NotifyEnvironmentDamage(PathTileIndex, true);
		NotifiedWindowBreak = true;		
	}
}

//If bForce is true, this method will send a notify to the nearest environment damage object if none meet the distance criteria
function NotifyEnvironmentDamage(int PreviousPathTileIndex, bool bFragileOnly = true, bool bCheckForDestructibleObject = false)
{
	local float DestroyTileDistance;
	local Vector HitLocation;
	local Vector TileLocation;
	local XComGameState_EnvironmentDamage EnvironmentDamage;		
	local XComWorldData WorldData;
	local TTile PathTile;
	local int Index;		

	WorldData = `XWORLD;
			
	//If the unit jumped more than one tile index, make sure it is caught
	for(Index = PreviousPathTileIndex; Index <= PathTileIndex; ++Index)
	{
		if (bCheckForDestructibleObject)
		{
			//Only trigger nearby environment damage if the traversal to the next tile has a destructible object
			if (AbilityContext.InputContext.MovementPaths[MovePathIndex].Destructibles.Length == 0 || 
				AbilityContext.InputContext.MovementPaths[MovePathIndex].Destructibles.Find(Index + 1) == INDEX_NONE)
			{
				continue;
			}
		}

		foreach LastInGameStateChain.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamage)
		{
			if (EnvironmentDamage.DamageCause.ObjectID != Unit.ObjectID)
				continue;

			HitLocation = WorldData.GetPositionFromTileCoordinates(EnvironmentDamage.HitLocationTile);			
			PathTile = AbilityContext.InputContext.MovementPaths[MovePathIndex].MovementTiles[Index];
			TileLocation = WorldData.GetPositionFromTileCoordinates(PathTile);
			
			DestroyTileDistance = VSize(HitLocation - TileLocation);
			if(DestroyTileDistance < (class'XComWorldData'.const.WORLD_StepSize * 1.5f) &&
			   ((!bFragileOnly && !EnvironmentDamage.bAffectFragileOnly) || (bFragileOnly && EnvironmentDamage.bAffectFragileOnly)))
			{				
				`XEVENTMGR.TriggerEvent('Visualizer_WorldDamage', EnvironmentDamage, self);				
			}
		}
	}
}

//This method is used to handle wall smashing movement
private function UpdateDestruction()
{
	local int PreviousPathTileIndex;

	PreviousPathTileIndex = PathTileIndex;
	if(UpdatePathTileIndex())
	{
		UpdatePathIndex();
		UpdatePhasingEffect();
		NotifyEnvironmentDamage(PreviousPathTileIndex, false);
	}
}

function UpdatePhasingEffect()
{
	local PathPoint CurrPoint, NextPoint;

	if((PathIndex + 1) >= Unit.CurrentMoveData.MovementData.Length) // >= to handle the empty path case (such as a full teleport on a hidden unit)
	{
		if(UnitPawn.m_bIsPhasing)
		{
			UnitPawn.SetPhasing(false);
		}
		return;
	}

	CurrPoint = Unit.CurrentMoveData.MovementData[PathIndex];
	NextPoint = Unit.CurrentMoveData.MovementData[PathIndex + 1];

	if((NextPoint.PathTileIndex == (PathTileIndex + 1)) && (NextPoint.Phasing))
	{
		UnitPawn.SetPhasing(true);
	}
	else if((PathIndex > 0) && !CurrPoint.Phasing && Unit.CurrentMoveData.MovementData[PathIndex - 1].Phasing)
	{
		UnitPawn.SetPhasing(false);
	}
}

private function bool UpdatePathTileIndex()
{	
	local int Index;	
	local bool bStartVisible;
	local bool bEndVisible;
	local array<X2Action> FollowUnitActions;
	local X2Action_CameraFollowUnit MostRecentFollowUnitAction;
	local int ActionIndex;

	Index = FindPathTileIndex();
	if(PathTileIndex != Index)
	{
		PathTileIndex = Index;

		CheckInterrupted();

		//This functionality manipulates the visibility of units based on distance from the start and end of their path if those start or end
		//points are in the fog
		if(Unit.ForceVisibility == eForceVisible && !bLocalUnit && 
		   Unit.CurrentMoveResultData.PathTileData.Length != AbilityContext.InputContext.MovementPaths[MovePathIndex].MovementTiles.Length) //Only perform this additional logic if the path is truncated in some way
		{
			bStartVisible = Unit.CurrentMoveResultData.PathTileData[0].NumLocalViewers > 0;
			bEndVisible = Unit.CurrentMoveResultData.PathTileData[Unit.CurrentMoveResultData.PathTileData.Length - 1].NumLocalViewers > 0;
			
			//Don't do any processing if the unit starts and ends visible. Perform special handling if the unit begins or ends its move not visible
			
			if(!bStartVisible && PathTileIndex >= class'X2VisualizerHelpers'.default.TilesInFog - 1)
			{
				//If we didn't start out visible, make us visible when we are one tile in from the edge of the fog
				//`SHAPEMGR.DrawTile(EventTile, 0, 255, 0);
				Unit.SetForceVisibility(eForceVisible);
			}

			if(!bEndVisible && PathTileIndex >= (Unit.CurrentMoveResultData.PathTileData.Length - 2))
			{
				VisualizationMgr.GetNodesOfType(VisualizationMgr.VisualizationTree, class'X2Action_CameraFollowUnit', FollowUnitActions, Unit);
				
				//Walk backwards through the returned actions ( which may include actions that have not yet been started ) and find the last one that
				//executed. In the vast majority of cases, there will only be one element.
				for (ActionIndex = FollowUnitActions.Length - 1; ActionIndex > -1; --ActionIndex)
				{
					if (FollowUnitActions[ActionIndex].bCompleted)
					{
						MostRecentFollowUnitAction = X2Action_CameraFollowUnit(FollowUnitActions[ActionIndex]);
					}
				}

				if (MostRecentFollowUnitAction != none)
				{					
					`CAMERASTACK.RemoveCamera(MostRecentFollowUnitAction.FollowCamera);
				}
				//If we didn't end visible, make us not visible when we are one tile in the edge of the fog
				//`SHAPEMGR.DrawTile(EventTile, 255, 0, 0);
				Unit.SetForceVisibility(eForceNotVisible);
			}
		}

		return true;
	}

	return false;
}

// Return val : Path index has changed.
function bool UpdatePathIndex()
{
	local int NextIndex;

	// Only need to update until we hit the last tile.
	if(PathIndex < Unit.CurrentMoveData.MovementData.Length - 1)
	{
		NextIndex = PathIndex + 1;
		while (Unit.CurrentMoveData.MovementData[NextIndex].PathTileIndex == -1)
		{
			++NextIndex;
		}

		if(Unit.CurrentMoveData.MovementData[NextIndex].PathTileIndex == PathTileIndex)
		{
			PathIndex = NextIndex;
			return true;
		}
	}
	return false;
}

function int FindPathIndex()
{
	local int Index, LastValid;

	Index = 0;

	while (Index < Unit.CurrentMoveData.MovementData.Length)
	{
		if (Unit.CurrentMoveData.MovementData[Index].PathTileIndex == -1)
		{
			++Index;
			continue; // skip the path smoothing entries
		}

		if (Unit.CurrentMoveData.MovementData[Index].PathTileIndex > PathTileIndex)
		{
			return LastValid; // return the last valid index
		}

		LastValid = Index; // keep track of the last non-negative move data index
		++Index;
	}

	return LastValid;
}

function OnUnitChangedTile(const out TTile NewTileLocation)
{
	UpdateDestruction();

	if (bUpdateEffects)
	{
		UpdateEffectsForChangedTile(NewTileLocation);	
	}

	if(!NotifiedWindowBreak)
	{
		// make sure we break any windows we've moved through, no matter how we moved through them
		NotifyEnvironmentDamage(PathTileIndex, true, true);
	}
}

function UpdateEffectsForChangedTile(const out TTile NewTileLocation)
{
	local XComGameState_Unit UnitState;
	local XComGameState_Effect EffectState;
	local name EffectName;
	local int scan;
	local XComGameStateHistory History;
	local array<XComGameState_Effect> EffectsToDo;

	History = `XCOMHISTORY;
	UnitState = XComGameState_Unit(Metadata.StateObject_NewState);
	foreach class'X2AbilityTemplateManager'.default.EffectUpdatesOnMove(EffectName)
	{
		for( scan = 0; scan < UnitState.AffectedByEffects.Length; ++scan )
		{
			EffectState = XComGameState_Effect(History.GetGameStateForObjectID(UnitState.AffectedByEffects[scan].ObjectID));
			if( EffectState.GetX2Effect().EffectName == EffectName )
			{
				EffectsToDo.AddItem(EffectState);
			}
		}

		for( scan = 0; scan < UnitState.AppliedEffects.Length; ++scan )
		{
			EffectState = XComGameState_Effect(History.GetGameStateForObjectID(UnitState.AppliedEffects[scan].ObjectID));
			if( EffectState.GetX2Effect().EffectName == EffectName )
			{
				if (EffectsToDo.Find(EffectState) == INDEX_NONE)
				{
					EffectsToDo.AddItem(EffectState);
				}
			}
		}
	}

	foreach EffectsToDo(EffectState)
	{
		EffectOnUnitChangedTile(UnitState, EffectState, NewTileLocation);
	}
}

simulated state Executing
{
	simulated function BeginState(name PrevStateName)
	{
		local XComGameState_Unit MovingUnitState;

		super.BeginState( PrevStateName );

		MovingUnitState = XComGameState_Unit(Metadata.StateObject_NewState);
		XGUnit(MovingUnitState.GetVisualizer()).BeginUpdatingVisibility();
	}
}

function CompleteAction()
{
	local XComGameState_Unit MovingUnitState;

	//If the move action tries to complete while interrupted, this will cause issues because the next move action is not allowed to proceed until the 
	//interruption is done. In this situation, unit may believe that it is running no actions and return to idle, which is problematic for moving.
	//
    //Ensure that the unit is frozen as much as possible, and let the interrupts proceed. When the interrupt markers on this move are cleared, we can resume
	if (bInterrupted)
	{
		//Make sure unit is time dilated as much as possible
		VisualizationMgr.SetInterruptionSloMoFactor(Unit, 0.0001f);
		TimerWaitForInterruptionToClear();
	}
	else
	{
		super.CompleteAction();

		//Fire off a world damage event as a failsafe
		`XEVENTMGR.TriggerEvent('Visualizer_WorldDamage', none, self);

		MovingUnitState = XComGameState_Unit(Metadata.StateObject_NewState);
		XGUnit(MovingUnitState.GetVisualizer()).EndUpdatingVisibility();
	}
}

function TimerWaitForInterruptionToClear()
{
	if (bInterrupted)
	{
		SetTimer(0.1f, false, nameof(TimerWaitForInterruptionToClear));
	}
	else
	{
		//Try again now we are free
		CompleteAction();
	}
}

function EffectOnUnitChangedTile(XComGameState_Unit UnitState, XComGameState_Effect EffectState, const out TTile NewTileLocation)
{
	local X2Effect_Persistent EffectTemplate;

	EffectTemplate = EffectState.GetX2Effect();
	if( EffectTemplate != None )
	{
		EffectTemplate.OnUnitChangedTile(NewTileLocation, EffectState, UnitState);
	}
}

defaultproperties
{
	OutputEventIDs.Add( "Visualizer_WorldDamage" )	//World damage application
	TimeoutSeconds = 10.0
	PathIndex = -1;
}
