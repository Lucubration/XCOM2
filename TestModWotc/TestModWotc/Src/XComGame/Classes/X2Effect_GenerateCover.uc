class X2Effect_GenerateCover extends X2Effect_Persistent
	dependson(XComCoverInterface);

var ECoverForceFlag CoverType;
var bool bRemoveWhenMoved;
var bool bRemoveOnOtherActivation;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (bRemoveWhenMoved)
	{
		EventMgr.RegisterForEvent(EffectObj, 'ObjectMoved', EffectGameState.GenerateCover_ObjectMoved, ELD_OnStateSubmitted,, UnitState);
	}
	else
	{
		EventMgr.RegisterForEvent(EffectObj, 'UnitMoveFinished', EffectGameState.GenerateCover_ObjectMoved_Update, ELD_OnStateSubmitted,, UnitState);
	}
	EventMgr.RegisterForEvent(EffectObj, 'UnitCoverUpdated', EffectGameState.GenerateCover_ObjectMoved_Update, ELD_OnStateSubmitted,, UnitState);

	if (bRemoveOnOtherActivation)
	{
		EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', EffectGameState.GenerateCover_AbilityActivated, ELD_OnStateSubmitted,, UnitState);
	}
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(kNewTargetState);
	if (UnitState != None)
	{
		UnitState.bGeneratesCover = true;
		UnitState.CoverForceFlag = CoverType;

		`XEVENTMGR.TriggerEvent('UnitCoverUpdated', kNewTargetState, kNewTargetState, NewGameState);
	}
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (UnitState != None)
	{
		UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
		UnitState.bGeneratesCover = false;
		UnitState.CoverForceFlag = CoverForce_Default;

		`XEVENTMGR.TriggerEvent('UnitCoverUpdated', UnitState, UnitState, NewGameState);
	}

	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);
}

static function UpdateWorldCoverData(XComGameState_Unit NewUnitState, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_Unit OldUnitState;
	local int BeforeChainIndex;

	History = `XCOMHISTORY;

	BeforeChainIndex = NewUnitState.GetParentGameState().GetContext().GetFirstStateInEventChain().HistoryIndex - 1;
	OldUnitState = XComGameState_Unit(History.GetGameStateForObjectID(NewUnitState.ObjectID,, BeforeChainIndex));

	if (OldUnitState != none && OldUnitState.TileLocation != NewUnitState.TileLocation)        //  will not be different at tactical match startup
	{
		UpdateWorldDataForTile(OldUnitState.TileLocation, NewGameState);
	}
	UpdateWorldDataForTile(NewUnitState.TileLocation, NewGameState);
}

static function UpdateWorldCoverDataOnSync(XComGameState_Unit UnitState)
{
	local XComWorldData WorldData;
	local TTile RebuildTile;
	local array<TTile> UpdateTiles;

	WorldData = `XWORLD;

	GetUpdateTiles(UnitState.TileLocation, UpdateTiles);

	// update the world data for each tile touched
	foreach UpdateTiles(RebuildTile)
	{
		WorldData.DebugRebuildTileData( RebuildTile );
	}
}

// helper to get the 3x3 cross of tiles around the specified tile
protected static function GetUpdateTiles(TTile Tile, out array<TTile> Tiles)
{
	// center tile
	Tiles.AddItem(Tile);

	// adjacent x tiles
	Tile.X -= 1;
	Tiles.AddItem(Tile);
	Tile.X += 2;
	Tiles.AddItem(Tile);
	Tile.X -= 1;

	// adjacent y tiles
	Tile.Y -= 1;
	Tiles.AddItem(Tile);
	Tile.Y += 2;
	Tiles.AddItem(Tile);
}

protected static function UpdateWorldDataForTile(const out TTile OriginalTile, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComWorldData WorldData;
	local TTile RebuildTile;
	local array<TTile> ChangeTiles;
	local array<StateObjectReference> UnitRefs;
	local StateObjectReference UnitRef;
	local XComGameState_BaseObject UnitOnTile;

	History = `XCOMHISTORY;
	WorldData = `XWORLD;

	GetUpdateTiles(OriginalTile, ChangeTiles);

	// update the world data for each tile touched
	foreach ChangeTiles(RebuildTile)
	{
		WorldData.DebugRebuildTileData( RebuildTile );
	}

	// add any units on the tiles to the new game state since they need to do a visibility update
	foreach ChangeTiles(RebuildTile)
	{
		UnitRefs = WorldData.GetUnitsOnTile( RebuildTile );
		foreach UnitRefs( UnitRef )
		{
			UnitOnTile = History.GetGameStateForObjectID(UnitRef.ObjectID);
			UnitOnTile = NewGameState.ModifyStateObject(UnitOnTile.Class, UnitOnTile.ObjectID);
			UnitOnTile.bRequiresVisibilityUpdate = true;
		}
	}
}

DefaultProperties
{
	CoverType = CoverForce_High
	EffectName = "GenerateCover"
	DuplicateResponse = eDupe_Ignore
	bRemoveWhenMoved = true
	bRemoveOnOtherActivation = true
}