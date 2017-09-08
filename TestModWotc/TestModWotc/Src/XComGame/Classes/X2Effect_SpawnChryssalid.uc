class X2Effect_SpawnChryssalid extends X2Effect_SpawnUnit;

function vector GetSpawnLocation(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState)
{
	local XComGameState_Unit TargetUnitState;
	local XComGameStateHistory History;
	local TTile TileLocation, NeighborTileLocation;
	local XComWorldData World;
	local array<Actor> TileActors;
	local vector SpawnLocation;

	World = `XWORLD;
	History = `XCOMHISTORY;

	TargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	`assert(TargetUnitState != none);

	TileLocation = TargetUnitState.TileLocation;
	NeighborTileLocation = TileLocation;

	for (NeighborTileLocation.X = TileLocation.X - 1; NeighborTileLocation.X <= TileLocation.X + 1; ++NeighborTileLocation.X)
	{
		for (NeighborTileLocation.Y = TileLocation.Y - 1; NeighborTileLocation.Y <= TileLocation.Y + 1; ++NeighborTileLocation.Y)
		{
			TileActors = World.GetActorsOnTile(NeighborTileLocation);

			// If the tile is empty and is on the same z as this unit's location
			if ((TileActors.Length == 0) && (World.GetFloorTileZ(NeighborTileLocation, false) == World.GetFloorTileZ(TileLocation, false)))
			{
				SpawnLocation = World.GetPositionFromTileCoordinates(NeighborTileLocation);
				return SpawnLocation;
			}
		}
	}

	SpawnLocation = World.GetPositionFromTileCoordinates(TileLocation);
	return SpawnLocation;
}

function ETeam GetTeam(const out EffectAppliedData ApplyEffectParameters)
{
	return GetSourceUnitsTeam(ApplyEffectParameters);
}

function OnSpawnComplete(const out EffectAppliedData ApplyEffectParameters, StateObjectReference NewUnitRef, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit ChryssalidPupGameState;
	local int HalfLife;

	ChryssalidPupGameState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(NewUnitRef.ObjectID));
	`assert(ChryssalidPupGameState != none);

	HalfLife = ChryssalidPupGameState.GetCurrentStat(eStat_HP) / 2;
	ChryssalidPupGameState.SetBaseMaxStat(eStat_HP, HalfLife);
	ChryssalidPupGameState.SetCurrentStat(eStat_HP, HalfLife);

	ChryssalidPupGameState.SetUnitFloatValue('NewSpawnedUnit', 1, eCleanup_BeginTactical);
}

function AddSpawnVisualizationsToTracks(XComGameStateContext Context, XComGameState_Unit SpawnedUnit, out VisualizationActionMetadata SpawnedUnitTrack,
										XComGameState_Unit EffectTargetUnit, optional out VisualizationActionMetadata EffectTargetUnitTrack)
{
	local XComGameStateHistory History;
	local X2Action_SpawnChryssalid ShowUnitAction;
	local XGUnit SourceUnitActor;

	History = `XCOMHISTORY;

	SourceUnitActor = XGUnit(History.GetVisualizer(EffectTargetUnit.ObjectID));

	// Show the spawned unit, using the tile and rotation for the visualizer
	ShowUnitAction = X2Action_SpawnChryssalid(class'X2Action_SpawnChryssalid'.static.AddToVisualizationTree(SpawnedUnitTrack, Context));
	ShowUnitAction.CocoonUnit = SourceUnitActor;
}

defaultproperties
{
	UnitToSpawnName="Chryssalid"
	bKnockbackAffectsSpawnLocation=false
}