class X2AIBT_DLC_90Actions extends X2AIBTDefaultActions;

static event bool FindBTActionDelegate(name strName, optional out delegate<BTActionDelegate> dOutFn, optional out name NameParam, optional out name MoveProfile)
{
	dOutFn = None;

	if( ParseNameForNameAbilitySplit(strName, "SetTargetStack-", NameParam) )
	{
		dOutFn = SetTargetStackWithExclusions;
		return true;
	}

	switch( strName )
	{
		case 'FindDestinationTowardsSelfDestructTargets':
			dOutFn = FindDestinationTowardsSelfDestructTargets;
			return true;
		break;

		case 'ScoreTargetForOverload':
			dOutFn = ScoreTargetForOverload;
			return true;
		break;

		default:
			`WARN("Unresolved behavior tree Action name with no delegate definition:"@strName);
		break;

	}
	return super.FindBTActionDelegate(strName, dOutFn, NameParam, MoveProfile);
}

static function bool ExcludeAbilityWithSacrifice(Name AbilityName)
{
	if( class'X2Effect_DLC_3SacrificeShield'.default.AbilitiesDisabledForAI.Find(AbilityName) != INDEX_NONE )
	{
		return true;
	}
	return false;
}

function bt_status SetTargetStackWithExclusions()
{
	local int NumTargets, CurrTargetIndex;
	local XComGameState_Unit TargetState;
	local XComGameStateHistory History;
	if( m_kBehavior.BT_SetTargetStack(SplitNameParam) )
	{
		if( ExcludeAbilityWithSacrifice(SplitNameParam) )
		{
			NumTargets = m_kBehavior.m_arrBTTargetStack.Length;
			History = `XCOMHISTORY;
			for( CurrTargetIndex = NumTargets - 1; CurrTargetIndex >= 0; --CurrTargetIndex )
			{
				// Remove targets that are protected by Sacrifice.
				TargetState = XComGameState_Unit(History.GetGameStateForObjectID(m_kBehavior.m_arrBTTargetStack[CurrTargetIndex].PrimaryTarget.ObjectID));
				if( TargetState.IsUnitAffectedByEffectName(class'X2Effect_DLC_3SacrificeShield'.default.EffectName) )
				{
					`LogAIBT("\nRemoving target id# "$TargetState.ObjectID$" from target stack: Affected by Sacrifice Shield.");
					m_kBehavior.m_arrBTTargetStack.Remove(CurrTargetIndex, 1);
				}
			}
		}

		if( m_kBehavior.m_arrBTTargetStack.Length > 0 )
		{
			return BTS_SUCCESS;
		}
	}
	return BTS_FAILURE;
}

// Add to score based on distance from Overloading unit.
function bt_status ScoreTargetForOverload()
{
	local int OverloaderID, Score;
	local XComGameState_Unit Overloader, Target;
	local XComGameStateHistory History;
	local XGAIBehavior OverloaderBehavior;
	local float Distance, ScaleValue;
	local String strParam;
	if( m_kBehavior.BT_HasBTVar('Overloader', OverloaderID) )
	{
		History = `XCOMHISTORY;
		Overloader = XComGameState_Unit(History.GetGameStateForObjectID(OverloaderID));
		Target = XComGameState_Unit(History.GetGameStateForObjectID(m_kBehavior.m_kBTCurrTarget.TargetID));
		if( Overloader != None && Overloader.IsAbleToAct() && Target != None )
		{
			OverloaderBehavior = XGUnit(Overloader.GetVisualizer()).m_kBehavior;
			if( OverloaderBehavior == None )
			{
				`RedScreen("Overloader behavior could not be found! @acheng");
				m_kBehavior.BT_AddToTargetScore(-1000);
				return BTS_FAILURE;
			}
			strParam = String(m_ParamList[0]);
			ScaleValue = float(strParam);

			Distance = OverloaderBehavior.GetDistanceFromEnemy(Target);
			Score = `UNITSTOMETERS(Distance);
			`LogAIBT("Distance = "@Score@" meters from overloader.");
			Score = (Score*ScaleValue) - Overloader.GetMaxStat(eStat_Mobility)*ScaleValue;
			`LogAIBT("Scaled value = "@Score$".");
			m_kBehavior.BT_AddToTargetScore(Score);
		}
	}
	else
	{
		m_kBehavior.BT_AddToTargetScore(-1000);
		return BTS_FAILURE;
	}
}

function bt_status FindDestinationTowardsSelfDestructTargets()
{
	local TTile Tile;
	local XComWorldData World;

	if( m_kBehavior.TopAoETarget.Ability != '' )
	{
		World = `XWORLD;
		Tile = World.GetTileCoordinatesFromPosition(m_kBehavior.TopAoETarget.Location);
		Tile = class'Helpers'.static.GetClosestValidTile(Tile); // Ensure the tile isn't occupied before finding a path to it.
		if( !class'Helpers'.static.GetFurthestReachableTileOnPathToDestination(Tile, Tile, m_kUnitState, false) )
		{
			Tile = m_kBehavior.m_kUnit.m_kReachableTilesCache.GetClosestReachableDestination(Tile);
		}

		if( m_kBehavior.m_kUnit.m_kReachableTilesCache.IsTileReachable(Tile) && Tile != m_kUnitState.TileLocation )
		{
			m_kBehavior.m_vBTDestination = World.GetPositionFromTileCoordinates(Tile);
			m_kBehavior.m_bBTDestinationSet = true;
			return BTS_SUCCESS;
		}
	}
	`LogAIBT("No AoE Targets specified!  Need to call FindPotentialAoETargets-xxx before this node!");
	return BTS_FAILURE;

}

//------------------------------------------------------------------------------------------------
defaultproperties
{
}