// Additional Behavior Tree conditions for Alien Rulers DLC.
class X2AIBT_DLC_60Conditions extends X2AIBTDefaultConditions;

const ON_FLOOR_MAX_TILE_RANGE = 3;

static event bool FindBTConditionDelegate(name strName, optional out delegate<BTConditionDelegate> dOutFn, optional out Name NameParam)
{
	dOutFn = None;
	switch( strName )
	{
		case 'CanAttemptEscape':
			dOutFn = CanAttemptEscape;
			return true;
			break;

		case 'RulerHealthBelowThreshold':
			dOutFn = RulerHealthBelowThreshold;
			return true;
			break;

		case 'RulerDisabledEnoughEnemiesToEscape':
			dOutFn = RulerDisabledEnoughEnemiesToEscape;
			return true;
		break;

		case 'IsActiveFlanked':
			dOutFn = IsActiveFlanked;
			return true;
		break;

		case 'IsTargetOverwatching':
			dOutFn = IsTargetOverwatching;
			return true;
		break;
		
		case 'PathToEscapeFails':
			dOutFn = PathToEscapeFails;
			return true;

		case 'HasDamagedVisibleEnemies':
			dOutFn = HasDamagedVisibleEnemies;
			return true;
		break;

		case 'MultipleValidTargetsRemain':
			dOutFn = MultipleValidTargetsRemain;
			return true;
		break;

		case 'IsOnFloorTile':
			dOutFn = IsOnFloorTile;
			return true;
		break;

		case 'HasValidDestination':
			dOutFn = HasValidDestination;
			return true;
		break;

		case 'IsAbleToMove':
			dOutFn = IsAbleToMove;
			return true;
		break;

		case 'IsArchonKingActive':
			dOutFn = IsArchonKingActive;
			return true;
		break;

		default:
		break;
	}

	return super.FindBTConditionDelegate(strName, dOutFn, NameParam);
}

function bt_status IsArchonKingActive()
{
	local XGPlayer PlayerVisualizer;
	local array<XComGameState_Unit> Units;
	local XComGameState_Unit Unit;
	PlayerVisualizer = XGPlayer(`XCOMHISTORY.GetVisualizer(m_kUnitState.ControllingPlayer.ObjectID));
	if( PlayerVisualizer != None )
	{
		PlayerVisualizer.GetPlayableUnits(Units, true);
		foreach Units(Unit)
		{
			if( Unit.GetMyTemplateName() == 'ArchonKing' )
			{
				if( !Unit.IsUnrevealedAI() )
				{
					return BTS_SUCCESS;
				}
				break;
			}
		}
	}
	return BTS_FAILURE;
}

function bt_status IsAbleToMove()
{
	local array<TTile> ReachableTiles;
	m_kBehavior.m_kUnit.m_kReachableTilesCache.GetAllPathableTiles(ReachableTiles);
	if( ReachableTiles.Length < 2 )
	{
		return BTS_FAILURE;
	}
	return BTS_SUCCESS;
}

function bt_status HasValidDestination()
{
	local TTile DestinationTile;
	local array<TTile> InvalidDestinations;
	if( m_kBehavior.m_bBTDestinationSet )
	{
		DestinationTile = `XWORLD.GetTileCoordinatesFromPosition(m_kBehavior.m_vBTDestination);
		class'X2Helpers_DLC_Day60'.static.GetSideAndCornerTiles(InvalidDestinations, m_kUnitState.TileLocation, 1, 0);
		if( DestinationTile != m_kUnitState.TileLocation
		   && class'Helpers'.static.FindTileInList(DestinationTile, InvalidDestinations) == INDEX_NONE
		   && m_kBehavior.m_kUnit.m_kReachableTilesCache.IsTileReachable(DestinationTile) )
		{
			return BTS_SUCCESS;
		}
	}
	return BTS_FAILURE;
}

function bt_status IsOnFloorTile()
{
	if( UnitIsOnFloorTile(m_kUnitState) )
	{
		return BTS_SUCCESS;
	}
	return BTS_FAILURE;
}

static function bool UnitIsOnFloorTile( XComGameState_Unit UnitState )
{
	local int LowestFloorCheck;
	local TTile CurrTile;
	local XComWorldData World;
	World = `XWORLD;

	LowestFloorCheck = UnitState.TileLocation.Z - const.ON_FLOOR_MAX_TILE_RANGE;
	for( CurrTile = UnitState.TileLocation; CurrTile.Z >= LowestFloorCheck; --CurrTile.Z )
	{
		if( World.IsFloorTile(CurrTile) )
		{
			return true;
		}
	}
	`LogAI("Found no floor tiles from ("$CurrTile.X@CurrTile.Y@CurrTile.Z$") to ("$CurrTile.X@CurrTile.Y@UnitState.TileLocation.Z$")");
	return false;
}

function bt_status MultipleValidTargetsRemain()
{
	local XComGameState_Unit Unit;
	local XGAIPlayer AIPlayer;
	local XGPlayer EnemyPlayer;
	local array<XComGameState_Unit> AllEnemies;
	local int ValidTargetCounter;

	AIPlayer = XGAIPlayer(`BATTLE.GetAIPlayer());
	EnemyPlayer = `BATTLE.GetEnemyPlayer(AIPlayer);
	EnemyPlayer.GetPlayableUnits(AllEnemies);
	foreach AllEnemies(Unit)
	{
		if( Unit.IsAbleToAct() && !Unit.IsUnitAffectedByEffectName(class'X2Effect_DLC_Day60Freeze'.default.EffectName) )
		{
			`LogAIBT("Unit #"$Unit.ObjectID@"passed IsAbleToAct() && not frozen check.\n");
			if( ++ValidTargetCounter > 1 )
			{
				return BTS_SUCCESS;
			}
		}
		else
		{
			`LogAIBT("Unit #"$Unit.ObjectID@"failed IsAbleToAct() check, or is frozen.\n");
		}
	}
	return BTS_FAILURE;
}

function bt_status HasDamagedVisibleEnemies()
{
	local array<StateObjectReference> VisibleEnemies, ActiveDamagedEnemies;
	local X2AIBTBehaviorTree BT;

	local X2Condition_UnitEffects EffectsCondition;
	local X2Condition_UnitProperty LivingDamagedUnitCondition;
	local X2Condition Condition;
	local XComGameState_Unit Enemy;
	local StateObjectReference EnemyRef;
	local XComGameStateHistory History;
	local bool PassesConditions;
	local Name ConditionStatus;
	local int MinEnemyCount;
	local String MinEnemyString;

	BT = `BEHAVIORTREEMGR;
	History = `XCOMHISTORY;
	class'X2TacticalVisibilityHelpers'.static.GetAllVisibleEnemyUnitsForUnit(m_kUnitState.ObjectID, VisibleEnemies);

	MinEnemyCount = 2;
	if( m_ParamList.Length == 1 )
	{
		MinEnemyString = String(m_ParamList[0]);
		MinEnemyCount = int(MinEnemyString);
	}

	if( BT.CachedActiveDamagedConditions.Length == 0 )
	{
		// Skip units unable to act.
		EffectsCondition = new class'X2Condition_UnitEffects';
		EffectsCondition.AddExcludeEffect(class'X2StatusEffects'.default.UnconsciousName, 'AA_UnitIsUnconscious');
		EffectsCondition.AddExcludeEffect(class'X2StatusEffects'.default.BleedingOutName, 'AA_UnitIsBleedingOut');
		EffectsCondition.AddExcludeEffect(class'X2AbilityTemplateManager'.default.StunnedName, 'AA_UnitIsStunned');
		EffectsCondition.AddExcludeEffect(class'X2AbilityTemplateManager'.default.BoundName, 'AA_UnitIsBound');
		EffectsCondition.AddExcludeEffect(class'X2Effect_PersistentVoidConduit'.default.EffectName, 'AA_UnitIsBound');
		EffectsCondition.AddExcludeEffect(class'X2AbilityTemplateManager'.default.PanickedName, 'AA_UnitIsPanicked');
		EffectsCondition.AddExcludeEffect(class'X2Effect_DLC_Day60Freeze'.default.EffectName, 'AA_UnitIsFrozen');
		BT.CachedActiveDamagedConditions.AddItem(EffectsCondition);

		LivingDamagedUnitCondition = new class'X2Condition_UnitProperty';
		LivingDamagedUnitCondition.ExcludeDead = true;
		LivingDamagedUnitCondition.ExcludeStunned = true;
		LivingDamagedUnitCondition.ExcludeInStasis = true;
		LivingDamagedUnitCondition.ExcludeFullHealth = true; // Must be damaged.
		LivingDamagedUnitCondition.FailOnNonUnits = true;
		BT.CachedActiveDamagedConditions.AddItem(LivingDamagedUnitCondition);
	}
	// Manually check each visible enemy against the above target conditions
	if( VisibleEnemies.Length > 1 )
	{
		foreach VisibleEnemies(EnemyRef)
		{
			Enemy = XComGameState_Unit(History.GetGameStateForObjectID(EnemyRef.ObjectID));
			if( Enemy != None )
			{
				PassesConditions = true;
				foreach BT.CachedActiveDamagedConditions(Condition)
				{
					ConditionStatus = Condition.MeetsCondition(Enemy);
					if( ConditionStatus != 'AA_Success' )
					{
						`LogAIBT("Visible Unit#"@EnemyRef.ObjectID@"failed Damaged Active check:" @ConditionStatus@"\n");
						PassesConditions = false;
						break;
					}
				}
				if( PassesConditions )
				{
					ActiveDamagedEnemies.AddItem(EnemyRef);
					`LogAIBT("Visible Unit#"@EnemyRef.ObjectID@"PASSED Damaged Active check.\n");
					if( ActiveDamagedEnemies.Length >= MinEnemyCount )
					{
						`LogAIBT("Returned Success with active damaged enemies.  (at least"@MinEnemyCount$")\n");
						return BTS_SUCCESS;
					}
				}
			}
		}
	}
	return BTS_FAILURE;
}

function bt_status PathToEscapeFails()
{
	local array<TTile> EscapeArea;

	if (class'X2Helpers_DLC_Day60'.static.GetEscapeTiles(EscapeArea, m_kUnitState))
	{
		if( class'X2Helpers_DLC_Day60'.static.HasPathToArea(EscapeArea, m_kUnitState) )
		{
			return BTS_FAILURE;
		}
		else
		{
			`LogAIBT("Failed to find path to escape area.");
		}
	}
	else
	{
		`LogAIBT("Failed to find escape location!");
	}
	return BTS_SUCCESS;

}

function bt_status IsTargetOverwatching()
{
	local XComGameState_Unit TargetUnit;
	if( m_kBehavior.BT_GetTarget(TargetUnit) )
	{
		if( TargetUnit.NumAllReserveActionPoints() > 0 ) // Overwatch check
		{
			return BTS_SUCCESS;
		}
	}
	return BTS_FAILURE;
}

// Flanked check for rulers, only cares about enemies with action points remaining
function bt_status IsActiveFlanked()
{
	local array<StateObjectReference> FlankingEnemies;
	local StateObjectReference EnemyRef;
	local XComGameState_Unit Enemy;
	local bool bAnyActionPointsRemaining;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	// Skip action point check if this is the last action point, i.e. XCom team will all get their action points back before our next action.
	bAnyActionPointsRemaining = class'X2Helpers_DLC_Day60'.static.AnyActionPointsRemainingForXCom();

	class'X2TacticalVisibilityHelpers'.static.GetVisibleFlankersOfTarget(m_kUnitState.ObjectID, m_kUnitState.GetTeam(), FlankingEnemies,,,true);

	foreach FlankingEnemies(EnemyRef)
	{
		Enemy = XComGameState_Unit(History.GetGameStateForObjectID(EnemyRef.ObjectID));
		if( !bAnyActionPointsRemaining || Enemy.NumActionPoints() > 0 ) // No action points for anyone == action points for everyone.
		{
			return BTS_SUCCESS;  // Return true if any unit with action points remaining is flanking us.
		}
	}

	return BTS_FAILURE;
}

function bt_status RulerDisabledEnoughEnemiesToEscape()
{
	local string DebugText;
	// Rulers hit the enemy threshold when the disabled enemy count is NOT BELOW the escape threshold. ( >= enemy threshold )
	if( class'X2Helpers_DLC_Day60'.static.RulerDisabledEnoughEnemiesToEscape(m_kUnitState, DebugText) )
	{
		`LogAIBT(DebugText);
		return BTS_SUCCESS;
	}
	`LogAIBT(DebugText);
	return BTS_FAILURE;
}

function bt_status RulerHealthBelowThreshold()
{
	local String DebugText;
	// Rulers hit the health threshold when the ruler's HP is below the escape threshold. ( < hp threshold )
	if( class'X2Helpers_DLC_Day60'.static.RulerHealthBelowEscapeThreshold(m_kUnitState, DebugText) )
	{
		`LogAIBT(DebugText);
		return BTS_SUCCESS;
	}
	`LogAIBT(DebugText);
	return BTS_FAILURE;
}

function bt_status CanAttemptEscape()
{
	// Escape cap is hit means the ruler cannot attempt escape based on the number of previous escapes.
	if( class'X2Helpers_DLC_Day60'.static.CanRulerAttemptEscape(m_kUnitState) )
	{
		return BTS_SUCCESS;
	}

	return BTS_FAILURE;
}


defaultproperties
{
}