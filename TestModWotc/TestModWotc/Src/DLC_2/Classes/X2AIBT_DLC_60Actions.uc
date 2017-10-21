class X2AIBT_DLC_60Actions extends X2AIBTDefaultActions;

static event bool FindBTActionDelegate(name strName, optional out delegate<BTActionDelegate> dOutFn, optional out name NameParam, optional out name MoveProfile)
{
	dOutFn = None;
	switch( strName )
	{
		case 'SetEscapeDestination':
			dOutFn = SetEscapeDestination;
			return true;
		break;

		case 'FindDestinationOnPathToEscape':
			dOutFn = FindDestinationOnPathToEscape;
			return true;
		break;

		case 'FindDestinationTowardsAoEAttack':
			dOutFn = FindDestinationTowardsAoEAttack;
			return true;
		break;

		case 'ForcePathToGround':
			dOutFn = ForcePathToGround;
			return true;
		break;

		default:
			`WARN("Unresolved behavior tree Action name with no delegate definition:"@strName);
		break;

	}
	return super.FindBTActionDelegate(strName, dOutFn, NameParam, MoveProfile);
}

function bt_status FindDestinationTowardsAoEAttack()
{
	local TTile Tile;
	local XComWorldData World;
	local vector Destination;

	if( m_kBehavior.TopAoETarget.Ability != '' )
	{
		World = `XWORLD;
		if( m_kUnitState.CanTakeCover() 
		   && m_kBehavior.GetClosestCoverLocation(m_kBehavior.TopAoETarget.Location, Destination))
		{
			Tile = World.GetTileCoordinatesFromPosition(Destination);
		}
		else
		{
			Tile = World.GetTileCoordinatesFromPosition(m_kBehavior.TopAoETarget.Location);
			Tile = class'Helpers'.static.GetClosestValidTile(Tile); // Ensure the tile isn't occupied before finding a path to it.
			if( !class'Helpers'.static.GetFurthestReachableTileOnPathToDestination(Tile, Tile, m_kUnitState) )
			{
				Tile = m_kBehavior.m_kUnit.m_kReachableTilesCache.GetClosestReachableDestination(Tile);
			}
		}

		if( m_kBehavior.m_kUnit.m_kReachableTilesCache.IsTileReachable(Tile) && Tile != m_kUnitState.TileLocation )
		{
			m_kBehavior.m_vBTDestination = World.GetPositionFromTileCoordinates(Tile);
			m_kBehavior.m_bBTDestinationSet = true;
			return BTS_SUCCESS;
		}
	}
	return BTS_FAILURE;

}

function bt_status ForcePathToGround()
{
	local TTile Tile, ValidatedTile;
	local XComWorldData World;

	World = `XWORLD;
	Tile = m_kUnitState.TileLocation;
	Tile.Z = World.GetFloorTileZ(Tile, true);
	ValidatedTile = class'Helpers'.static.GetClosestValidTile(Tile);

	m_kBehavior.m_vBTDestination = World.GetPositionFromTileCoordinates(ValidatedTile);
	m_kBehavior.m_bBTDestinationSet = true;
	m_kBehavior.bForcePathIfUnreachable = true;
	return BTS_SUCCESS;
}

// Get the escape tile, then compute the path to this tile.  Get furthest point along this path that is reachable, and set as our destination.
function bt_status FindDestinationOnPathToEscape()
{
	local array<TTile> EscapeArea, EscapePath;
	local TTile PathTile;
	local Vector Destination;
	local XComWorldData World;
	World = `XWORLD;

	// Find possible escape tiles.
	if( !class'X2Helpers_DLC_Day60'.static.GetEscapeTiles(EscapeArea, m_kUnitState) )
	{
		`LogAIBT("No escape tiles found!");
		return BTS_FAILURE;
	}

	if( !class'X2Helpers_DLC_Day60'.static.HasPathToArea(EscapeArea, m_kUnitState, EscapePath) )
	{
		`LogAIBT("No path could be found to escape tiles!");
		return BTS_FAILURE;
	}

	if( class'Helpers'.static.GetFurthestReachableTileOnPath(PathTile, EscapePath, m_kUnitState) )
	{
		Destination = World.GetPositionFromTileCoordinates(PathTile);
		m_kBehavior.m_vBTDestination = Destination;
		m_kBehavior.m_bBTDestinationSet = true;
		return BTS_SUCCESS;
	}

	`LogAIBT("Reachable tile cache has no tiles in common with path to escape area!  Something is broken.");
	return BTS_FAILURE;
}

// Set destination, flag as destination set (m_kBehavior.m_bBTDestinationSet).
function bt_status SetEscapeDestination() 
{
	local TTile EscapeTile;

	if( !SelectEscapeTile(EscapeTile) )
	{
		`LogAIBT("Unable to find any valid escape tile destination!");
		return BTS_FAILURE;
	}

	m_kBehavior.m_bBTDestinationSet = true;
	m_kBehavior.m_vBTDestination = `XWORLD.GetPositionFromTileCoordinates(EscapeTile);

	return BTS_SUCCESS;
}

// Test if an escape zone placed at the given tile is outside a single move.  Check 3x3 area around the given tile for reachability.
// (Also fail if any surrounding tile on the same Z level is not a valid floor tile.)
function bool IsInAcceptableEscapeZoneTileRange(TTile SelectedTile)
{
	local array<TTile> SurroundingTiles;
	local TTile CornerTile;
	local XComWorldData World;
	local vector TilePos;
	local bool bWithinOneMovementRange;
	local array<TTile> TooCloseTiles;
	World = `XWORLD;

	class'X2Helpers_DLC_Day60'.static.GetSideAndCornerTiles(SurroundingTiles, SelectedTile, 1, 0);
	class'X2Helpers_DLC_Day60'.static.GetSideAndCornerTiles(TooCloseTiles, m_kUnitState.TileLocation, 1, 0);

	bWithinOneMovementRange = false;
	foreach SurroundingTiles(CornerTile)
	{
		if( class'Helpers'.static.FindTileInList(CornerTile, TooCloseTiles) != INDEX_NONE )
		{
			return false;
		}
		TilePos = World.GetPositionFromTileCoordinates(CornerTile);
		if( !World.IsPositionOnFloorAndValidDestination(TilePos, m_kUnitState) )
		{
			return false;
		}
		if( m_kBehavior.m_kUnit.m_kReachableTilesCache.IsTileReachable(CornerTile) )
		{
			bWithinOneMovementRange = true;
		}
	}
	return bWithinOneMovementRange;
}

function bool SelectEscapeTile( out TTile EscapeTile)
{
	local array<TTile> EscapeTiles, TileList, PreferredList, Path;
	local XComGameState_Unit SelectedEnemy;
	local TTile SelectedTile, FurthestTile;
	local vector TilePos, vEnemyPos, vRulerPos;
	local XComWorldData World;
	local float RulerDist, EnemyDist, FurthestDist;
	local int Rand, TileRadius;
	local XGPlayer EnemyPlayer;
	local bool AcceptableRange, ValidPath;

	World = `XWORLD;
	// Use our mobility range (+2) to find tiles outside our movement range.
	TileRadius = `METERSTOTILES(m_kUnitState.GetMaxStat(eStat_Mobility) / 2);

	// Get tile locations outside our movement range.
	if( !GetPossibleEscapeTilesAroundPoint(EscapeTiles, m_kUnitState.TileLocation, TileRadius) )
	{
		return false;
	}

	// Use the closest enemy to filter out any potential escape tiles that are closer to us than the enemy.
	SelectedEnemy = GetNearestActiveEnemy();
	if( SelectedEnemy != None )
	{
		vRulerPos = World.GetPositionFromTileCoordinates(m_kUnitState.TileLocation);
		vEnemyPos = World.GetPositionFromTileCoordinates(SelectedEnemy.TileLocation);
		FurthestDist = -1;
		// Remove any tiles closer to us than the enemy, 
		// as well as points that fall within one movement distance, factoring in the 3x3 escape volume.
		foreach EscapeTiles(SelectedTile)
		{
			TilePos = World.GetPositionFromTileCoordinates(SelectedTile);
			EnemyDist = VSizeSq(vEnemyPos - TilePos);
			RulerDist = VSizeSq(vRulerPos - TilePos);

			ValidPath = true;
			AcceptableRange = IsInAcceptableEscapeZoneTileRange(SelectedTile);
			// Only consider tiles outside our immediate movement range, where the enemy is closer.
			if( EnemyDist < RulerDist && AcceptableRange )
			{
				// Ensure this is a valid destination that isn't currently blocked or unreachable.
				ValidPath = class'X2PathSolver'.static.BuildPath(m_kUnitState, m_kUnitState.TileLocation, SelectedTile, Path, false);
				if( ValidPath )
				{
					TileList.AddItem(SelectedTile);
				}
				else if( `CHEATMGR.bShowEscapeOptions )
				{
					`CHEATMGR.DrawSphereT(SelectedTile, 13); // Orange == No valid path to target location.
				}
			}
			else if( `CHEATMGR.bShowEscapeOptions )
			{
				if( !AcceptableRange )
				{
					`CHEATMGR.DrawSphereT(SelectedTile, 16); // Red == Reachable in one move or a bordering tile is invalid/non-floor-tile
				}
				else
				{
					`CHEATMGR.DrawSphereT(SelectedTile, 9); // Yellow == Closer to ruler than the nearest active enemy.
				}
			}

			// Keep track of the furthest tile from the ruler in case we run out of valid tiles.
			if(AcceptableRange && ( RulerDist > FurthestDist ))
			{
				FurthestDist = RulerDist;
				FurthestTile = SelectedTile;
			}
		}

		// Handle delinquent case - no remaining tiles.  Reinsert the furthest tile from the ruler.
		if( EscapeTiles.Length > 0 && TileList.Length == 0 && FurthestDist > 0 )
		{
			TileList.AddItem(FurthestTile);
		}
		if( TileList.Length > 0 )
		{
			EscapeTiles = TileList;
		}
	}
	else
	{
		// No xcom units found?
		`LogAI("No active closest enemy or valid tiles found.");
	}

	EnemyPlayer = `BATTLE.GetEnemyPlayer(m_kBehavior.m_kPlayer);
	// Prefer tiles visible to the enemy.
	foreach EscapeTiles(SelectedTile)
	{
		if( class'X2TacticalVisibilityHelpers'.static.CanSquadSeeLocation(EnemyPlayer.ObjectID, SelectedTile) )
		{
			PreferredList.AddItem(SelectedTile);
			if( `CHEATMGR.bShowEscapeOptions )
			{
				`CHEATMGR.DrawSphereT(SelectedTile, 0); // Green = preferred destination.  Visible to enemy squad.
			}
		}
		else
		{
			if( `CHEATMGR.bShowEscapeOptions )
			{
				`CHEATMGR.DrawSphereT(SelectedTile, 6); // Greenish-Yellow = Not visible to enemy squad.
			}
		}
	}
	if( PreferredList.Length > 0 )
	{
		Rand = `SYNC_RAND(PreferredList.Length);
		// Pick randomly from set.
		EscapeTile = PreferredList[Rand];
		return true;
	}

	if( EscapeTiles.Length == 0 )
	{
		return false;
	}

	// If no tiles are visible to the enemy, then just pick any of our original tiles.
	Rand = `SYNC_RAND(EscapeTiles.Length);
	// Pick randomly from set.
	EscapeTile = EscapeTiles[Rand];
	return true;
}

// Attempt to get the nearest visible enemy with action points remaining.  Otherwise just pick the nearest enemy.
function XComGameState_Unit GetNearestActiveEnemy()
{
	local XComGameState_Unit SelectedEnemy;
	local GameRulesCache_VisibilityInfo ClosestInfo;
	local X2Condition_UnitActionPoints ActionPointsCondition;
	local X2Condition_UnitEffects EffectsCondition;
	local X2Condition_UnitProperty LivingUnitCondition;
	local X2AIBTBehaviorTree BT;

	BT = `BEHAVIORTREEMGR;
	if( BT.CachedActiveWithAPConditions.Length == 0 )
	{
		ActionPointsCondition = new class'X2Condition_UnitActionPoints';
		ActionPointsCondition.AddActionPointCheck(1, , , eCheck_GreaterThanOrEqual);
		BT.CachedActiveWithAPConditions.AddItem(ActionPointsCondition);

		// Skip units unable to act.
		EffectsCondition = new class'X2Condition_UnitEffects';
		EffectsCondition.AddExcludeEffect(class'X2StatusEffects'.default.UnconsciousName, 'AA_UnitIsUnconscious');
		EffectsCondition.AddExcludeEffect(class'X2StatusEffects'.default.BleedingOutName, 'AA_UnitIsBleedingOut');
		EffectsCondition.AddExcludeEffect(class'X2AbilityTemplateManager'.default.StunnedName, 'AA_UnitIsStunned');
		EffectsCondition.AddExcludeEffect(class'X2AbilityTemplateManager'.default.BoundName, 'AA_UnitIsBound');
		EffectsCondition.AddExcludeEffect(class'X2Effect_PersistentVoidConduit'.default.EffectName, 'AA_UnitIsBound');
		EffectsCondition.AddExcludeEffect(class'X2AbilityTemplateManager'.default.PanickedName, 'AA_UnitIsPanicked');
		EffectsCondition.AddExcludeEffect(class'X2Effect_DLC_Day60Freeze'.default.EffectName, 'AA_UnitIsFrozen');
		BT.CachedActiveWithAPConditions.AddItem(EffectsCondition);

		LivingUnitCondition = new class'X2Condition_UnitProperty';
		LivingUnitCondition.ExcludeDead = true;
		LivingUnitCondition.ExcludeStunned = true;
		LivingUnitCondition.ExcludeInStasis = true;
		BT.CachedActiveWithAPConditions.AddItem(LivingUnitCondition);
	}
	// Attempt to use the closest active enemy (with action points remaining).
	if( class'X2TacticalVisibilityHelpers'.static.GetClosestVisibleEnemy(m_kUnitState.ObjectID, ClosestInfo, , BT.CachedActiveWithAPConditions) 
	   && ClosestInfo.TargetID > 0)
	{
		SelectedEnemy = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ClosestInfo.TargetID));
	}

	// Otherwise just take the closest enemy.
	if( SelectedEnemy == None )
	{
		SelectedEnemy = m_kBehavior.GetNearestKnownEnemy(m_kBehavior.m_kUnit.GetGameStateLocation(), , , false);
	}
	return SelectedEnemy;
}

// Return array of possible escape tiles around the ruler's location (not checked for actual pathing distance yet).
// Creates a list of tiles all around the square of the given TileRadius that surrounds the ruler.
function bool GetPossibleEscapeTilesAroundPoint(out array<TTile> EnemyTiles, TTile CenterTile, int TileRadius)
{
	local TTile Tile, ValidatedTile;
	local XComWorldData World;
	local int HalfRadius;
	local array<TTile> CornerSideTiles;

	World = `XWORLD;
	HalfRadius = 3; // Get side points centered at 1.5 x the movement radius, and the corner points as well.
	class'X2Helpers_DLC_Day60'.static.GetSideAndCornerTiles(CornerSideTiles, CenterTile, TileRadius, HalfRadius);

	// Collect all unoccupied floor tiles on map with no cover within a radius around each of these 8 points surrounding the ruler.
	foreach CornerSideTiles(Tile)
	{
		ValidatedTile = class'Helpers'.static.GetClosestValidTile(Tile);
		World.GetUnoccupiedNonCoverTiles(ValidatedTile, HalfRadius, EnemyTiles);
	}

	if( EnemyTiles.Length == 0 )
	{
		`RedScreen("DLC_60 error! Unable to find any valid unoccupied non-cover Escape Tiles around the ruler!  @acheng");
		`LogAIBT("CornerSideTiles around ("$CenterTile.X@CenterTile.Y@CenterTile.Z$") count = "$CornerSideTiles.Length@"  No unoccupied non-cover tiles found!");
		return false;
	}
	return true;
}


//------------------------------------------------------------------------------------------------
defaultproperties
{
}