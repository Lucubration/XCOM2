class X2Effect_SpawnUnit extends X2Effect_Persistent
	abstract;

var name UnitToSpawnName;
var bool bClearTileBlockedByTargetUnitFlag; // The spawned unit will be placed in the same tile as the target
var bool bCopyTargetAppearance, bCopySourceAppearance;	//	Mutually exclusive! Target will take precedence if both are true.
var bool bKnockbackAffectsSpawnLocation;
var bool bAddToSourceGroup;
var bool bCopyReanimatedFromUnit;		//	copy not just appearance but inventory, abilities, etc.
var bool bCopyReanimatedStatsFromUnit;
var bool bSetProcessedScamperAs;

var private name SpawnUnitTriggerName;
var privatewrite name SpawnedUnitValueName;
var private name SpawnedThisTurnUnitValueName;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnitState;

	TargetUnitState = XComGameState_Unit(kNewTargetState);
	`assert(TargetUnitState != none);

	TriggerSpawnEvent(ApplyEffectParameters, TargetUnitState, NewGameState, NewEffectState);
}

simulated function ModifyAbilitiesPreActivation(StateObjectReference NewUnitRef, out array<AbilitySetupData> AbilityData, XComGameState NewGameState)
{
	// Jwats: Used by children to add abilities or remove them
}

simulated function ModifyItemsPreActivation(StateObjectReference NewUnitRef, XComGameState NewGameState)
{
	// JWeinhoffer: Used by children to add or remove items
}

// It is possible this effect gets added to a unit the same turn it is knocked back. The Knockback sets the target unit's
// tile location in ApplyEffectToWorld, so this possibly needs to update the spawned unit's location as well.
simulated function ApplyEffectToWorld(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState)
{
	local XComGameState_Unit TargetUnitState, SpawnedUnitState;
	local UnitValue SpawnedUnitValue;
	local TTile TargetUnitTile, SpawnedUnitTile;

	if( bKnockbackAffectsSpawnLocation )
	{
		foreach NewGameState.IterateByClassType(class'XComGameState_Unit', TargetUnitState)
		{
			if( TargetUnitState.GetUnitValue(class'X2Effect_SpawnUnit'.default.SpawnedThisTurnUnitValueName, SpawnedUnitValue) )
			{
				SpawnedUnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(SpawnedUnitValue.fValue));
				if( SpawnedUnitState != none )
				{
					TargetUnitState.NativeGetKeystoneVisibilityLocation(TargetUnitTile);
					SpawnedUnitState.NativeGetKeystoneVisibilityLocation(SpawnedUnitTile);

					if( TargetUnitTile != SpawnedUnitTile )
					{
						TargetUnitTile = GetActualSpawnTileFromDesiredTile(TargetUnitTile);
						SpawnedUnitState.SetVisibilityLocation(TargetUnitTile);
					}
				}

				SpawnedUnitValue.fValue = 0;
				TargetUnitState.ClearUnitValue(class'X2Effect_SpawnUnit'.default.SpawnedThisTurnUnitValueName);
			}
		}
	}
}

function TriggerSpawnEvent(const out EffectAppliedData ApplyEffectParameters, XComGameState_Unit EffectTargetUnit, XComGameState NewGameState, XComGameState_Effect EffectGameState)
{
	local XComGameState_Unit SourceUnitState, TargetUnitState, SpawnedUnit, CopiedUnit, ModifiedEffectTargetUnit;
	local XComGameStateHistory History;
	local XComAISpawnManager SpawnManager;
	local StateObjectReference NewUnitRef;
	local XComWorldData World;
	local XComGameState_AIGroup GroupState;

	History = `XCOMHISTORY;
	SpawnManager = `SPAWNMGR;
	World = `XWORLD;

	TargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if( TargetUnitState == none )
	{
		`RedScreen("TargetUnitState in X2Effect_SpawnUnit::TriggerSpawnEvent does not exist. @dslonneger");
		return;
	}
	SourceUnitState = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	if( bClearTileBlockedByTargetUnitFlag )
	{
		World.ClearTileBlockedByUnitFlag(TargetUnitState);
	}

	if( bCopyTargetAppearance )
	{
		CopiedUnit = TargetUnitState;
	}
	else if ( bCopySourceAppearance )
	{
		CopiedUnit = SourceUnitState;
	}

	// Spawn the new unit
	NewUnitRef = SpawnManager.CreateUnit(
		GetSpawnLocation(ApplyEffectParameters, NewGameState), 
		GetUnitToSpawnName(ApplyEffectParameters), 
		GetTeam(ApplyEffectParameters), 
		false, 
		false, 
		NewGameState, 
		CopiedUnit, 
		, 
		, 
		bCopyReanimatedFromUnit,
		(SourceUnitState != None && (bAddToSourceGroup || SourceUnitState.IsMine()) ) ? SourceUnitState.GetGroupMembership(NewGameState).ObjectID : -1,
		bCopyReanimatedStatsFromUnit);

	SpawnedUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(NewUnitRef.ObjectID));
	SpawnedUnit.bTriggerRevealAI = !bSetProcessedScamperAs;

	// Don't allow scamper
	GroupState = SpawnedUnit.GetGroupMembership(NewGameState);
	if( GroupState != None )
	{
		GroupState = XComGameState_AIGroup(NewGameState.ModifyStateObject(class'XComGameState_AIGroup', GroupState.ObjectID));
		GroupState.bProcessedScamper = bSetProcessedScamperAs;
	}

	ModifiedEffectTargetUnit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', EffectTargetUnit.ObjectID));
	ModifiedEffectTargetUnit.SetUnitFloatValue(SpawnedUnitValueName, NewUnitRef.ObjectID, eCleanup_Never);
	ModifiedEffectTargetUnit.SetUnitFloatValue(SpawnedThisTurnUnitValueName, NewUnitRef.ObjectID, eCleanup_BeginTurn);

	EffectGameState.CreatedObjectReference = SpawnedUnit.GetReference();

	OnSpawnComplete(ApplyEffectParameters, NewUnitRef, NewGameState, EffectGameState);
}

function name GetUnitToSpawnName(const out EffectAppliedData ApplyEffectParameters)
{
	return UnitToSpawnName;
}

// Returns a vector that the new unit should be spawned in given TileLocation
function vector GetSpawnLocation(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState)
{
	local XComWorldData World;
	local XComGameState_Unit TargetUnitState;
	local XComGameStateHistory History;
	local vector SpawnLocation;
	local TTile OtherTile;

	World = `XWORLD;
	History = `XCOMHISTORY;

	TargetUnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (TargetUnitState == none)
		TargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	`assert(TargetUnitState != none);

	OtherTile = GetActualSpawnTileFromDesiredTile(TargetUnitState.TileLocation);
	SpawnLocation = World.GetPositionFromTileCoordinates(OtherTile);

	return SpawnLocation;
}

function TTile GetActualSpawnTileFromDesiredTile(TTile DesiredSpawn)
{
	local XComWorldData World;
	local TTile ReturnTile, OtherTile;
	local vector Loc;

	World = `XWORLD;
	ReturnTile = DesiredSpawn;
	if (!World.CanUnitsEnterTile(ReturnTile))
	{
		if (class'Helpers'.static.FindAvailableNeighborTile(DesiredSpawn, OtherTile))
		{
			ReturnTile = OtherTile;
		}
		else
		{
			Loc = World.GetPositionFromTileCoordinates(DesiredSpawn);
			Loc = World.FindClosestValidLocation(Loc, false, true);
			ReturnTile = World.GetTileCoordinatesFromPosition(Loc);
		}
	}
	return ReturnTile;
}

// Helper functions to quickly get teams for inheriting classes
protected function ETeam GetTargetUnitsTeam(const out EffectAppliedData ApplyEffectParameters, optional bool UseOriginalTeam=false)
{
	local XComGameState_Unit TargetUnit;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	// Defaults to the team of the unit that this effect is on
	TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	`assert(TargetUnit != none);

	if( UseOriginalTeam )
	{
		return GetUnitsOriginalTeam(TargetUnit);
	}

	return TargetUnit.GetTeam();
}

protected function ETeam GetSourceUnitsTeam(const out EffectAppliedData ApplyEffectParameters, optional bool UseOriginalTeam=false)
{
	local XComGameState_Unit SourceUnit;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	// Defaults to the team of the unit that this effect is on
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	`assert(SourceUnit != none);

	if( UseOriginalTeam )
	{
		return GetUnitsOriginalTeam(SourceUnit);
	}

	return SourceUnit.GetTeam();
}

// Things like mind control may change a unit's team. This grabs the team the unit was originally on.
protected function ETeam GetUnitsOriginalTeam(const out XComGameState_Unit UnitGameState)
{
	local XComGameState_Unit UnitState;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	// find the original game state for this unit
	UnitState = XComGameState_Unit(History.GetOriginalGameStateRevision(UnitGameState.ObjectID));
	`assert(UnitState != none);

	return UnitState.GetTeam();
}

// Find the units that were spawned this GameState
static function FindNewlySpawnedUnit(XComGameState VisualizeGameState, out array<XComGameState_Unit> SpawnedUnits)
{
	local XComGameStateHistory History;
	local XComGameState_Unit SpawnedUnit;
	local XComGameState_Unit ExistedPreviousFrame;

	History = `XCOMHISTORY;

	SpawnedUnits.Length = 0;

	foreach VisualizeGameState.IterateByClassType( class'XComGameState_Unit', SpawnedUnit )
	{
		// If we exist in this game state but not the previous one we are a new unit
		ExistedPreviousFrame = XComGameState_Unit(History.GetGameStateForObjectID(SpawnedUnit.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));
		if( ExistedPreviousFrame == None )
		{
			SpawnedUnits.AddItem(SpawnedUnit);
		}
	}
}

function AddSpawnVisualizationsToTracks(XComGameStateContext Context, XComGameState_Unit SpawnedUnit, out VisualizationActionMetadata SpawnedUnitTrack,
										XComGameState_Unit EffectTargetUnit, optional out VisualizationActionMetadata EffectTargetUnitTrack )
{
	class'X2Action_ShowSpawnedUnit'.static.AddToVisualizationTree(SpawnedUnitTrack, Context);
}

// Get the team that this unit should be added to
function ETeam GetTeam(const out EffectAppliedData ApplyEffectParameters);

// Any clean up or final updates that need to occur after the unit is spawned
function OnSpawnComplete(const out EffectAppliedData ApplyEffectParameters, StateObjectReference NewUnitRef, XComGameState NewGameState, XComGameState_Effect NewEffectState);

defaultproperties
{
	SpawnUnitTriggerName="SpawnUnit"
	SpawnedUnitValueName="SpawnedUnitValue"
	SpawnedThisTurnUnitValueName="SpawnedThisTurnUnitValue"
	bClearTileBlockedByTargetUnitFlag=false
	bCopyTargetAppearance=false
	bKnockbackAffectsSpawnLocation=true
	bSetProcessedScamperAs=true

	DuplicateResponse=eDupe_Allow
	bCanBeRedirected=false
}